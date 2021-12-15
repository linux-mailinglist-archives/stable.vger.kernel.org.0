Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA65E4763D4
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 21:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhLOU6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 15:58:11 -0500
Received: from mga12.intel.com ([192.55.52.136]:39918 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229517AbhLOU6L (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Dec 2021 15:58:11 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="219349480"
X-IronPort-AV: E=Sophos;i="5.88,209,1635231600"; 
   d="scan'208";a="219349480"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2021 12:58:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,209,1635231600"; 
   d="scan'208";a="568072002"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.171])
  by fmsmga008.fm.intel.com with SMTP; 15 Dec 2021 12:58:07 -0800
Received: by stinkbox (sSMTP sendmail emulation); Wed, 15 Dec 2021 22:58:06 +0200
Date:   Wed, 15 Dec 2021 22:58:06 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     gregkh@linuxfoundation.org
Cc:     rodrigo.vivi@intel.com, stable@vger.kernel.org,
        stanislav.lisovskiy@intel.com
Subject: Re: FAILED: patch "[PATCH] drm/i915/hdmi: Turn DP++ TMDS output
 buffers back on in" failed to apply to 5.15-stable tree
Message-ID: <YbpW3h6JoZBra+aM@intel.com>
References: <1637668322209209@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1637668322209209@kroah.com>
X-Patchwork-Hint: comment
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 23, 2021 at 12:52:02PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Looks like cherry-picking
commit 7ceb751b6159 ("drm/i915/hdmi: convert intel_hdmi_to_dev to intel_hdmi_to_i915")
should solve the conflict with this one.

> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> >From cecbc0c7eba7983965cac94f88d2db00b913253b Mon Sep 17 00:00:00 2001
> From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
> Date: Fri, 29 Oct 2021 22:18:02 +0300
> Subject: [PATCH] drm/i915/hdmi: Turn DP++ TMDS output buffers back on in
>  encoder->shutdown()
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> Looks like our VBIOS/GOP generally fail to turn the DP dual mode adater
> TMDS output buffers back on after a reboot. This leads to a black screen
> after reboot if we turned the TMDS output buffers off prior to reboot.
> And if i915 decides to do a fastboot the black screen will persist even
> after i915 takes over.
> 
> Apparently this has been a problem ever since commit b2ccb822d376 ("drm/i915:
> Enable/disable TMDS output buffers in DP++ adaptor as needed") if one
> rebooted while the display was turned off. And things became worse with
> commit fe0f1e3bfdfe ("drm/i915: Shut down displays gracefully on reboot")
> since now we always turn the display off before a reboot.
> 
> This was reported on a RKL, but I confirmed the same behaviour on my
> SNB as well. So looks pretty universal.
> 
> Let's fix this by explicitly turning the TMDS output buffers back on
> in the encoder->shutdown() hook. Note that this gets called after irqs
> have been disabled, so the i2c communication with the DP dual mode
> adapter has to be performed via polling (which the gmbus code is
> perfectly happy to do for us).
> 
> We also need a bit of care in handling DDI encoders which may or may
> not be set up for HDMI output. Specifically ddc_pin will not be
> populated for a DP only DDI encoder, in which case we don't want to
> call intel_gmbus_get_adapter(). We can handle that by simply doing
> the dual mode adapter type check before calling
> intel_gmbus_get_adapter().
> 
> Cc: <stable@vger.kernel.org> # v5.11+
> Fixes: fe0f1e3bfdfe ("drm/i915: Shut down displays gracefully on reboot")
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/4371
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20211029191802.18448-2-ville.syrjala@linux.intel.com
> Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
> (cherry picked from commit 49c55f7b035b87371a6d3c53d9af9f92ddc962db)
> Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
> 
> diff --git a/drivers/gpu/drm/i915/display/g4x_hdmi.c b/drivers/gpu/drm/i915/display/g4x_hdmi.c
> index 88c427f3c346..f5b4dd5b4275 100644
> --- a/drivers/gpu/drm/i915/display/g4x_hdmi.c
> +++ b/drivers/gpu/drm/i915/display/g4x_hdmi.c
> @@ -584,6 +584,7 @@ void g4x_hdmi_init(struct drm_i915_private *dev_priv,
>  		else
>  			intel_encoder->enable = g4x_enable_hdmi;
>  	}
> +	intel_encoder->shutdown = intel_hdmi_encoder_shutdown;
>  
>  	intel_encoder->type = INTEL_OUTPUT_HDMI;
>  	intel_encoder->power_domain = intel_port_to_power_domain(port);
> diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
> index 1dcfe31e6c6f..cfb567df71b3 100644
> --- a/drivers/gpu/drm/i915/display/intel_ddi.c
> +++ b/drivers/gpu/drm/i915/display/intel_ddi.c
> @@ -4361,6 +4361,7 @@ static void intel_ddi_encoder_shutdown(struct intel_encoder *encoder)
>  	enum phy phy = intel_port_to_phy(i915, encoder->port);
>  
>  	intel_dp_encoder_shutdown(encoder);
> +	intel_hdmi_encoder_shutdown(encoder);
>  
>  	if (!intel_phy_is_tc(i915, phy))
>  		return;
> diff --git a/drivers/gpu/drm/i915/display/intel_hdmi.c b/drivers/gpu/drm/i915/display/intel_hdmi.c
> index d2e61f6c6e08..371736bdc01f 100644
> --- a/drivers/gpu/drm/i915/display/intel_hdmi.c
> +++ b/drivers/gpu/drm/i915/display/intel_hdmi.c
> @@ -1246,12 +1246,13 @@ static void hsw_set_infoframes(struct intel_encoder *encoder,
>  void intel_dp_dual_mode_set_tmds_output(struct intel_hdmi *hdmi, bool enable)
>  {
>  	struct drm_i915_private *dev_priv = intel_hdmi_to_i915(hdmi);
> -	struct i2c_adapter *adapter =
> -		intel_gmbus_get_adapter(dev_priv, hdmi->ddc_bus);
> +	struct i2c_adapter *adapter;
>  
>  	if (hdmi->dp_dual_mode.type < DRM_DP_DUAL_MODE_TYPE2_DVI)
>  		return;
>  
> +	adapter = intel_gmbus_get_adapter(dev_priv, hdmi->ddc_bus);
> +
>  	drm_dbg_kms(&dev_priv->drm, "%s DP dual mode adaptor TMDS output\n",
>  		    enable ? "Enabling" : "Disabling");
>  
> @@ -2258,6 +2259,17 @@ int intel_hdmi_compute_config(struct intel_encoder *encoder,
>  	return 0;
>  }
>  
> +void intel_hdmi_encoder_shutdown(struct intel_encoder *encoder)
> +{
> +	struct intel_hdmi *intel_hdmi = enc_to_intel_hdmi(encoder);
> +
> +	/*
> +	 * Give a hand to buggy BIOSen which forget to turn
> +	 * the TMDS output buffers back on after a reboot.
> +	 */
> +	intel_dp_dual_mode_set_tmds_output(intel_hdmi, true);
> +}
> +
>  static void
>  intel_hdmi_unset_edid(struct drm_connector *connector)
>  {
> diff --git a/drivers/gpu/drm/i915/display/intel_hdmi.h b/drivers/gpu/drm/i915/display/intel_hdmi.h
> index b43a180d007e..2bf440eb400a 100644
> --- a/drivers/gpu/drm/i915/display/intel_hdmi.h
> +++ b/drivers/gpu/drm/i915/display/intel_hdmi.h
> @@ -28,6 +28,7 @@ void intel_hdmi_init_connector(struct intel_digital_port *dig_port,
>  int intel_hdmi_compute_config(struct intel_encoder *encoder,
>  			      struct intel_crtc_state *pipe_config,
>  			      struct drm_connector_state *conn_state);
> +void intel_hdmi_encoder_shutdown(struct intel_encoder *encoder);
>  bool intel_hdmi_handle_sink_scrambling(struct intel_encoder *encoder,
>  				       struct drm_connector *connector,
>  				       bool high_tmds_clock_ratio,

-- 
Ville Syrjälä
Intel
