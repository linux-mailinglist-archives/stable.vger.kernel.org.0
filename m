Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93DBB43C74D
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 12:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236189AbhJ0KFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 06:05:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:33666 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231848AbhJ0KFw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Oct 2021 06:05:52 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10149"; a="229983757"
X-IronPort-AV: E=Sophos;i="5.87,186,1631602800"; 
   d="scan'208";a="229983757"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2021 03:03:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,186,1631602800"; 
   d="scan'208";a="635669892"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.171])
  by fmsmga001.fm.intel.com with SMTP; 27 Oct 2021 03:03:22 -0700
Received: by stinkbox (sSMTP sendmail emulation); Wed, 27 Oct 2021 13:03:22 +0300
Date:   Wed, 27 Oct 2021 13:03:22 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Lyude Paul <lyude@redhat.com>
Cc:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org,
        Satadru Pramanik <satadru@gmail.com>, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/5] drm/i915: Add support for panels with VESA
 backlights with PWM enable/disable
Message-ID: <YXkj6n/6U5ZaSRN7@intel.com>
References: <20211026220848.439530-1-lyude@redhat.com>
 <20211026220848.439530-2-lyude@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211026220848.439530-2-lyude@redhat.com>
X-Patchwork-Hint: comment
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 26, 2021 at 06:08:44PM -0400, Lyude Paul wrote:
> This simply adds proper support for panel backlights that can be controlled
> via VESA's backlight control protocol, but which also require that we
> enable and disable the backlight via PWM instead of via the DPCD interface.
> We also enable this by default, in order to fix some people's backlights
> that were broken by not having this enabled.
> 
> For reference, backlights that require this and use VESA's backlight
> interface tend to be laptops with hybrid GPUs, but this very well may
> change in the future.
> 
> v4:
> * Make sure that we call intel_backlight_level_to_pwm() in
>   intel_dp_aux_vesa_enable_backlight() - vsyrjala
> 
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Link: https://gitlab.freedesktop.org/drm/intel/-/issues/3680
> Fixes: fe7d52bccab6 ("drm/i915/dp: Don't use DPCD backlights that need PWM enable/disable")
> Cc: <stable@vger.kernel.org> # v5.12+

Seems consistent enough.
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

> ---
>  .../drm/i915/display/intel_dp_aux_backlight.c | 27 ++++++++++++++-----
>  1 file changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c b/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
> index 569d17b4d00f..f05b71c01b8e 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
> +++ b/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
> @@ -293,6 +293,13 @@ intel_dp_aux_vesa_enable_backlight(const struct intel_crtc_state *crtc_state,
>  	struct intel_panel *panel = &connector->panel;
>  	struct intel_dp *intel_dp = enc_to_intel_dp(connector->encoder);
>  
> +	if (!panel->backlight.edp.vesa.info.aux_enable) {
> +		u32 pwm_level = intel_backlight_invert_pwm_level(connector,
> +								 panel->backlight.pwm_level_max);
> +
> +		panel->backlight.pwm_funcs->enable(crtc_state, conn_state, pwm_level);
> +	}
> +
>  	drm_edp_backlight_enable(&intel_dp->aux, &panel->backlight.edp.vesa.info, level);
>  }
>  
> @@ -304,6 +311,10 @@ static void intel_dp_aux_vesa_disable_backlight(const struct drm_connector_state
>  	struct intel_dp *intel_dp = enc_to_intel_dp(connector->encoder);
>  
>  	drm_edp_backlight_disable(&intel_dp->aux, &panel->backlight.edp.vesa.info);
> +
> +	if (!panel->backlight.edp.vesa.info.aux_enable)
> +		panel->backlight.pwm_funcs->disable(old_conn_state,
> +						    intel_backlight_invert_pwm_level(connector, 0));
>  }
>  
>  static int intel_dp_aux_vesa_setup_backlight(struct intel_connector *connector, enum pipe pipe)
> @@ -321,6 +332,15 @@ static int intel_dp_aux_vesa_setup_backlight(struct intel_connector *connector,
>  	if (ret < 0)
>  		return ret;
>  
> +	if (!panel->backlight.edp.vesa.info.aux_enable) {
> +		ret = panel->backlight.pwm_funcs->setup(connector, pipe);
> +		if (ret < 0) {
> +			drm_err(&i915->drm,
> +				"Failed to setup PWM backlight controls for eDP backlight: %d\n",
> +				ret);
> +			return ret;
> +		}
> +	}
>  	panel->backlight.max = panel->backlight.edp.vesa.info.max;
>  	panel->backlight.min = 0;
>  	if (current_mode == DP_EDP_BACKLIGHT_CONTROL_MODE_DPCD) {
> @@ -340,12 +360,7 @@ intel_dp_aux_supports_vesa_backlight(struct intel_connector *connector)
>  	struct intel_dp *intel_dp = intel_attached_dp(connector);
>  	struct drm_i915_private *i915 = dp_to_i915(intel_dp);
>  
> -	/* TODO: We currently only support AUX only backlight configurations, not backlights which
> -	 * require a mix of PWM and AUX controls to work. In the mean time, these machines typically
> -	 * work just fine using normal PWM controls anyway.
> -	 */
> -	if ((intel_dp->edp_dpcd[1] & DP_EDP_BACKLIGHT_AUX_ENABLE_CAP) &&
> -	    drm_edp_backlight_supported(intel_dp->edp_dpcd)) {
> +	if (drm_edp_backlight_supported(intel_dp->edp_dpcd)) {
>  		drm_dbg_kms(&i915->drm, "AUX Backlight Control Supported!\n");
>  		return true;
>  	}
> -- 
> 2.31.1

-- 
Ville Syrjälä
Intel
