Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7F660FA87
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 16:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234035AbiJ0Ohh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 10:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234911AbiJ0Ohh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 10:37:37 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4904518A00C
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 07:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666881455; x=1698417455;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=3PrHTCCUskJvDjW3UQTojbk+LOCikwBZxbnHzkjxatA=;
  b=WYjPH9yhKngsfKWmFG/Nj+Jj8OKMgJM39fannz7sk6uVSOcTLizCaMaA
   45pEFsfJ++hZ8VCSAYiv7QyTkoBTvC6V3oToSmMYgO/NO0dLfLn/hJcl4
   Z4gie0HY2qmMKFjkkuBdzlYlFxFh4uDmSwX5VDGkkOWmETOsxIuwR4DT2
   OnykchEqLocGr1GXt3yIpgqAG1FlWJlG0gJ/ULGZL+581QHuoEvfGKsWi
   xyI5gWgU5Jw7sIEMcEfPHz5DtXWhSp3wYH2MvDFAkzMTsS+uby0U0ico2
   vr21nhKlR05ktsss6VHReW2dAwHvNpdpJkGQ8F7zvSRlhUPkp1TK6w0Q4
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="308232094"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="308232094"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 07:36:30 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="737706372"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="737706372"
Received: from jnikula-mobl4.fi.intel.com (HELO localhost) ([10.237.66.147])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 07:36:29 -0700
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 2/8] drm/i915/sdvo: Setup DDC fully before
 output init
In-Reply-To: <20221026101134.20865-3-ville.syrjala@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20221026101134.20865-1-ville.syrjala@linux.intel.com>
 <20221026101134.20865-3-ville.syrjala@linux.intel.com>
Date:   Thu, 27 Oct 2022 17:36:24 +0300
Message-ID: <87pmedcp07.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 26 Oct 2022, Ville Syrjala <ville.syrjala@linux.intel.com> wrote:
> From: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
>
> Call intel_sdvo_select_ddc_bus() before initializing any
> of the outputs. And before that is functional (assuming no VBT)
> we have to set up the controlled_outputs thing. Otherwise DDC
> won't be functional during the output init but LVDS really
> needs it for the fixed mode setup.
>
> Note that the whole multi output support still looks very
> bogus, and more work will be needed to make it correct.
> But for now this should at least fix the LVDS EDID fixed mode
> setup.
>
> Cc: stable@vger.kernel.org
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/7301
> Fixes: aa2b88074a56 ("drm/i915/sdvo: Fix multi function encoder stuff")
> Signed-off-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
> ---
>  drivers/gpu/drm/i915/display/intel_sdvo.c | 31 +++++++++--------------
>  1 file changed, 12 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/display/intel_sdvo.c b/drivers/gpu/drm/=
i915/display/intel_sdvo.c
> index c6200a91a777..ccf81d616cb4 100644
> --- a/drivers/gpu/drm/i915/display/intel_sdvo.c
> +++ b/drivers/gpu/drm/i915/display/intel_sdvo.c
> @@ -2746,13 +2746,10 @@ intel_sdvo_dvi_init(struct intel_sdvo *intel_sdvo=
, int device)
>  	if (!intel_sdvo_connector)
>  		return false;
>=20=20
> -	if (device =3D=3D 0) {
> -		intel_sdvo->controlled_output |=3D SDVO_OUTPUT_TMDS0;
> +	if (device =3D=3D 0)
>  		intel_sdvo_connector->output_flag =3D SDVO_OUTPUT_TMDS0;
> -	} else if (device =3D=3D 1) {
> -		intel_sdvo->controlled_output |=3D SDVO_OUTPUT_TMDS1;
> +	else if (device =3D=3D 1)
>  		intel_sdvo_connector->output_flag =3D SDVO_OUTPUT_TMDS1;
> -	}
>=20=20
>  	intel_connector =3D &intel_sdvo_connector->base;
>  	connector =3D &intel_connector->base;
> @@ -2807,7 +2804,6 @@ intel_sdvo_tv_init(struct intel_sdvo *intel_sdvo, i=
nt type)
>  	encoder->encoder_type =3D DRM_MODE_ENCODER_TVDAC;
>  	connector->connector_type =3D DRM_MODE_CONNECTOR_SVIDEO;
>=20=20
> -	intel_sdvo->controlled_output |=3D type;
>  	intel_sdvo_connector->output_flag =3D type;
>=20=20
>  	if (intel_sdvo_connector_init(intel_sdvo_connector, intel_sdvo) < 0) {
> @@ -2848,13 +2844,10 @@ intel_sdvo_analog_init(struct intel_sdvo *intel_s=
dvo, int device)
>  	encoder->encoder_type =3D DRM_MODE_ENCODER_DAC;
>  	connector->connector_type =3D DRM_MODE_CONNECTOR_VGA;
>=20=20
> -	if (device =3D=3D 0) {
> -		intel_sdvo->controlled_output |=3D SDVO_OUTPUT_RGB0;
> +	if (device =3D=3D 0)
>  		intel_sdvo_connector->output_flag =3D SDVO_OUTPUT_RGB0;
> -	} else if (device =3D=3D 1) {
> -		intel_sdvo->controlled_output |=3D SDVO_OUTPUT_RGB1;
> +	else if (device =3D=3D 1)
>  		intel_sdvo_connector->output_flag =3D SDVO_OUTPUT_RGB1;
> -	}
>=20=20
>  	if (intel_sdvo_connector_init(intel_sdvo_connector, intel_sdvo) < 0) {
>  		kfree(intel_sdvo_connector);
> @@ -2884,13 +2877,10 @@ intel_sdvo_lvds_init(struct intel_sdvo *intel_sdv=
o, int device)
>  	encoder->encoder_type =3D DRM_MODE_ENCODER_LVDS;
>  	connector->connector_type =3D DRM_MODE_CONNECTOR_LVDS;
>=20=20
> -	if (device =3D=3D 0) {
> -		intel_sdvo->controlled_output |=3D SDVO_OUTPUT_LVDS0;
> +	if (device =3D=3D 0)
>  		intel_sdvo_connector->output_flag =3D SDVO_OUTPUT_LVDS0;
> -	} else if (device =3D=3D 1) {
> -		intel_sdvo->controlled_output |=3D SDVO_OUTPUT_LVDS1;
> +	else if (device =3D=3D 1)
>  		intel_sdvo_connector->output_flag =3D SDVO_OUTPUT_LVDS1;
> -	}
>=20=20
>  	if (intel_sdvo_connector_init(intel_sdvo_connector, intel_sdvo) < 0) {
>  		kfree(intel_sdvo_connector);
> @@ -2945,8 +2935,14 @@ static u16 intel_sdvo_filter_output_flags(u16 flag=
s)
>  static bool
>  intel_sdvo_output_setup(struct intel_sdvo *intel_sdvo, u16 flags)
>  {
> +	struct drm_i915_private *i915 =3D to_i915(intel_sdvo->base.base.dev);
> +
>  	flags =3D intel_sdvo_filter_output_flags(flags);
>=20=20
> +	intel_sdvo->controlled_output =3D flags;
> +
> +	intel_sdvo_select_ddc_bus(i915, intel_sdvo);

AFAICT the ->controlled_outputs member could now be removed and just
passed by value here.

Reviewed-by: Jani Nikula <jani.nikula@intel.com>


> +
>  	if (flags & SDVO_OUTPUT_TMDS0)
>  		if (!intel_sdvo_dvi_init(intel_sdvo, 0))
>  			return false;
> @@ -2987,7 +2983,6 @@ intel_sdvo_output_setup(struct intel_sdvo *intel_sd=
vo, u16 flags)
>  	if (flags =3D=3D 0) {
>  		unsigned char bytes[2];
>=20=20
> -		intel_sdvo->controlled_output =3D 0;
>  		memcpy(bytes, &intel_sdvo->caps.output_flags, 2);
>  		DRM_DEBUG_KMS("%s: Unknown SDVO output type (0x%02x%02x)\n",
>  			      SDVO_NAME(intel_sdvo),
> @@ -3399,8 +3394,6 @@ bool intel_sdvo_init(struct drm_i915_private *dev_p=
riv,
>  	 */
>  	intel_sdvo->base.cloneable =3D 0;
>=20=20
> -	intel_sdvo_select_ddc_bus(dev_priv, intel_sdvo);
> -
>  	/* Set the input timing to the screen. Assume always input 0. */
>  	if (!intel_sdvo_set_target_input(intel_sdvo))
>  		goto err_output;

--=20
Jani Nikula, Intel Open Source Graphics Center
