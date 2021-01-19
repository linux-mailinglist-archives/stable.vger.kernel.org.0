Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA88F2FB496
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 09:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbhASIv4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 19 Jan 2021 03:51:56 -0500
Received: from mga18.intel.com ([134.134.136.126]:30878 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726284AbhASIvx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 03:51:53 -0500
IronPort-SDR: U2Tsyx2Y/MPQPOmsrE5SVdoHszHYMsVBwQoiDi9F23JrJIpsZeM1pqep6jZnj2R9gaTA0eF5fD
 fl7OfQZwjJrA==
X-IronPort-AV: E=McAfee;i="6000,8403,9868"; a="166563926"
X-IronPort-AV: E=Sophos;i="5.79,358,1602572400"; 
   d="scan'208";a="166563926"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2021 00:50:53 -0800
IronPort-SDR: +lTT9kCOZbxKrOtXOXDlnRihjkB3nDty7cE3zBBTSn2HkfSArUlIFUuR3OMkq402bW3KyPCsRM
 nOLawBKkAVPw==
X-IronPort-AV: E=Sophos;i="5.79,358,1602572400"; 
   d="scan'208";a="383851506"
Received: from obaracos-mobl2.amr.corp.intel.com (HELO localhost) ([10.252.44.192])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2021 00:50:50 -0800
From:   Jani Nikula <jani.nikula@intel.com>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH -fixes] drm/i915: Only enable DFP 4:4:4->4:2:0 conversion when outputting YCbCr 4:4:4
In-Reply-To: <20210118154355.24453-1-ville.syrjala@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <87lfcqobpl.fsf@intel.com> <20210118154355.24453-1-ville.syrjala@linux.intel.com>
Date:   Tue, 19 Jan 2021 10:50:47 +0200
Message-ID: <87a6t5nwd4.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 18 Jan 2021, Ville Syrjala <ville.syrjala@linux.intel.com> wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
>
> Let's not enable the 4:4:4->4:2:0 conversion bit in the DFP unless we're
> actually outputting YCbCr 4:4:4. It would appear some protocol
> converters blindy consult this bit even when the source is outputting
> RGB, resulting in a visual mess.
>
> Cc: stable@vger.kernel.org
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2914
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20210111164111.13302-1-ville.syrjala@linux.intel.com
> Fixes: 181567aa9f0d ("drm/i915: Do YCbCr 444->420 conversion via DP protocol converters")
> Reviewed-by: Jani Nikula <jani.nikula@intel.com>
> (cherry picked from commit 3170a21f7059c4660c469f59bf529f372a57da5f)
> ---
> Unfortunately the crtc_state plumbing to
> intel_dp_configure_protocol_converter() was part of the 
> HDMI 2.1 PCON stuff, so couldn't just cherry-pick it alone.

Thanks, pushed to fixes.

BR,
Jani.

>
>  drivers/gpu/drm/i915/display/intel_ddi.c | 2 +-
>  drivers/gpu/drm/i915/display/intel_dp.c  | 9 +++++----
>  drivers/gpu/drm/i915/display/intel_dp.h  | 3 ++-
>  3 files changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
> index 92940a0c5ef8..d5ace48b1ace 100644
> --- a/drivers/gpu/drm/i915/display/intel_ddi.c
> +++ b/drivers/gpu/drm/i915/display/intel_ddi.c
> @@ -3725,7 +3725,7 @@ static void hsw_ddi_pre_enable_dp(struct intel_atomic_state *state,
>  	intel_ddi_init_dp_buf_reg(encoder, crtc_state);
>  	if (!is_mst)
>  		intel_dp_set_power(intel_dp, DP_SET_POWER_D0);
> -	intel_dp_configure_protocol_converter(intel_dp);
> +	intel_dp_configure_protocol_converter(intel_dp, crtc_state);
>  	intel_dp_sink_set_decompression_state(intel_dp, crtc_state,
>  					      true);
>  	intel_dp_sink_set_fec_ready(intel_dp, crtc_state);
> diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
> index 37f1a10fd021..09123e8625c4 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp.c
> +++ b/drivers/gpu/drm/i915/display/intel_dp.c
> @@ -4014,7 +4014,8 @@ static void intel_dp_enable_port(struct intel_dp *intel_dp,
>  	intel_de_posting_read(dev_priv, intel_dp->output_reg);
>  }
>  
> -void intel_dp_configure_protocol_converter(struct intel_dp *intel_dp)
> +void intel_dp_configure_protocol_converter(struct intel_dp *intel_dp,
> +					   const struct intel_crtc_state *crtc_state)
>  {
>  	struct drm_i915_private *i915 = dp_to_i915(intel_dp);
>  	u8 tmp;
> @@ -4033,8 +4034,8 @@ void intel_dp_configure_protocol_converter(struct intel_dp *intel_dp)
>  		drm_dbg_kms(&i915->drm, "Failed to set protocol converter HDMI mode to %s\n",
>  			    enableddisabled(intel_dp->has_hdmi_sink));
>  
> -	tmp = intel_dp->dfp.ycbcr_444_to_420 ?
> -		DP_CONVERSION_TO_YCBCR420_ENABLE : 0;
> +	tmp = crtc_state->output_format == INTEL_OUTPUT_FORMAT_YCBCR444 &&
> +		intel_dp->dfp.ycbcr_444_to_420 ? DP_CONVERSION_TO_YCBCR420_ENABLE : 0;
>  
>  	if (drm_dp_dpcd_writeb(&intel_dp->aux,
>  			       DP_PROTOCOL_CONVERTER_CONTROL_1, tmp) != 1)
> @@ -4088,7 +4089,7 @@ static void intel_enable_dp(struct intel_atomic_state *state,
>  	}
>  
>  	intel_dp_set_power(intel_dp, DP_SET_POWER_D0);
> -	intel_dp_configure_protocol_converter(intel_dp);
> +	intel_dp_configure_protocol_converter(intel_dp, pipe_config);
>  	intel_dp_start_link_train(intel_dp, pipe_config);
>  	intel_dp_stop_link_train(intel_dp, pipe_config);
>  
> diff --git a/drivers/gpu/drm/i915/display/intel_dp.h b/drivers/gpu/drm/i915/display/intel_dp.h
> index b871a09b6901..05f7ddf7a795 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp.h
> +++ b/drivers/gpu/drm/i915/display/intel_dp.h
> @@ -51,7 +51,8 @@ int intel_dp_get_link_train_fallback_values(struct intel_dp *intel_dp,
>  int intel_dp_retrain_link(struct intel_encoder *encoder,
>  			  struct drm_modeset_acquire_ctx *ctx);
>  void intel_dp_set_power(struct intel_dp *intel_dp, u8 mode);
> -void intel_dp_configure_protocol_converter(struct intel_dp *intel_dp);
> +void intel_dp_configure_protocol_converter(struct intel_dp *intel_dp,
> +					   const struct intel_crtc_state *crtc_state);
>  void intel_dp_sink_set_decompression_state(struct intel_dp *intel_dp,
>  					   const struct intel_crtc_state *crtc_state,
>  					   bool enable);

-- 
Jani Nikula, Intel Open Source Graphics Center
