Shader "MagicTavern/SurfaceOutLineShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
        _OutLineWidth("OutLineWidth",Range(0,1)) = 0.1
        _OutLineColor("OutLineColor",Color) = (0,0,0,0)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
        Pass {
            NAME "OUTLINE"            
            Cull Front           
            CGPROGRAM            
            #pragma vertex vert
            #pragma fragment frag            
            #include "UnityCG.cginc"            
            float _OutLineWidth;
            fixed4 _OutlineColor;
            
            struct a2v {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            }; 
            
            struct v2f {
                float4 pos : SV_POSITION;
            };
            
            v2f vert (a2v v) {
                v2f o;
                
                float4 pos = mul(UNITY_MATRIX_MV, v.vertex); 
                float3 normal = mul((float3x3)UNITY_MATRIX_IT_MV, v.normal);  
                normal.z = -0.5;
                pos = pos + float4(normalize(normal), 0) * _OutLineWidth;
                o.pos = mul(UNITY_MATRIX_P, pos);
                
                return o;
            }
            
            float4 frag(v2f i) : SV_Target { 
                return float4(_OutlineColor.rgb, 1);               
            }
            
            ENDCG
        }

    		CGPROGRAM
    		// Physically based Standard lighting model, and enable shadows on all light types
    		#pragma surface surf Standard fullforwardshadows

    		// Use shader model 3.0 target, to get nicer looking lighting
    		#pragma target 3.0

    		sampler2D _MainTex;

    		struct Input {
    			float2 uv_MainTex;
                float3 viewDir; 
    		};

    		half _Glossiness;
    		half _Metallic;
    		fixed4 _Color;
    		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
    		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
    		// #pragma instancing_options assumeuniformscaling
    		UNITY_INSTANCING_BUFFER_START(Props)
    			// put more per-instance properties here
    		UNITY_INSTANCING_BUFFER_END(Props)

    		void surf (Input IN, inout SurfaceOutputStandard o) {
    			// Albedo comes from a texture tinted by color
    			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
    			o.Albedo = c.rgb;
    			// Metallic and smoothness come from slider variables
    			o.Metallic = _Metallic;
    			o.Smoothness = _Glossiness;
    			o.Alpha = c.a;
    		}
    		ENDCG
    }
	FallBack "Diffuse"
}
