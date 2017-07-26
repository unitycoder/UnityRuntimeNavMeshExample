// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Invisible"
{
	Properties
	{
		_MaskClipValue( "Mask Clip Value", Float ) = 0.5
		[HideInInspector] __dirty( "", Int ) = 1
		_DistortionMap("DistortionMap", 2D) = "bump" {}
		_RippleScale("Ripple Scale", Range( 0 , 20)) = 1.5
		_DisturbanceScale("Disturbance Scale", Range( 0 , 1)) = 0.19
		_RippleSpeed("RippleSpeed", Range( 0 , 1)) = 0.3
		_Blending("Blending", Range( 0 , 1)) = 0.5393515
	}

	SubShader
	{
		Tags{ "RenderType" = "Overlay"  "Queue" = "Transparent+1" "IsEmissive" = "true"  }
		Cull Back
		GrabPass{ "_GrabScreen0" }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha  noshadow noforwardadd 
		struct Input
		{
			float4 screenPos;
		};

		uniform sampler2D _GrabScreen0;
		uniform sampler2D _DistortionMap;
		uniform float _RippleScale;
		uniform float _RippleSpeed;
		uniform float _DisturbanceScale;
		uniform float _Blending;
		uniform float _MaskClipValue = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Albedo = float3(0,0,0);
			float4 screenPos3 = i.screenPos;
			#if UNITY_UV_STARTS_AT_TOP
			float scale3 = -1.0;
			#else
			float scale3 = 1.0;
			#endif
			float halfPosW3 = screenPos3.w * 0.5;
			screenPos3.y = ( screenPos3.y - halfPosW3 ) * _ProjectionParams.x* scale3 + halfPosW3;
			screenPos3.w += 0.00000000001;
			screenPos3.xyzw /= screenPos3.w;
			float4 temp_cast_0 = ( _Time.y * _RippleSpeed );
			float4 temp_cast_3 = 1.0;
			o.Emission = lerp( tex2Dproj( _GrabScreen0, UNITY_PROJ_COORD( ( float4( ( UnpackNormal( tex2D( _DistortionMap,( _RippleScale * float2( ( temp_cast_0 + screenPos3 ).x , ( temp_cast_0 + screenPos3 ).y ) ).xy) ) * _DisturbanceScale ) , 0.0 ) + screenPos3 ) ) ) , temp_cast_3 , _Blending ).rgb;
			float temp_output_20_0 = 1.0;
			o.Metallic = temp_output_20_0;
			o.Alpha = 1;
		}

		ENDCG
	}
}