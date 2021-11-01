Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E252441566
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 09:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhKAIjh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 04:39:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:40480 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229933AbhKAIjg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 04:39:36 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10154"; a="218160601"
X-IronPort-AV: E=Sophos;i="5.87,198,1631602800"; 
   d="scan'208";a="218160601"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2021 01:37:03 -0700
X-IronPort-AV: E=Sophos;i="5.87,198,1631602800"; 
   d="scan'208";a="488548522"
Received: from unknown (HELO intel.com) ([10.237.72.167])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2021 01:37:02 -0700
Date:   Mon, 1 Nov 2021 10:36:31 +0200
From:   "Lisovskiy, Stanislav" <stanislav.lisovskiy@intel.com>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 2/2] drm/i915/hdmi: Turn DP++ TMDS output
 buffers back on in encoder->shutdown()
Message-ID: <20211101083631.GA8827@intel.com>
References: <20211029191802.18448-1-ville.syrjala@linux.intel.com>
 <20211029191802.18448-2-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211029191802.18448-2-ville.syrjala@linux.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 29, 2021 at 10:18:02PM +0300, Ville Syrjala wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
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

Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>

> 
> Cc: stable@vger.kernel.org
> Fixes: b2ccb822d376 ("drm/i915: Enable/disable TMDS output buffers in DP++ adaptor as needed")
> Fixes: fe0f1e3bfdfe ("drm/i915: Shut down displays gracefully on reboot")
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/4371
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> ---
>  drivers/gpu/drm/i915/display/g4x_hdmi.c   |  1 +
>  drivers/gpu/drm/i915/display/intel_ddi.c  |  1 +
>  drivers/gpu/drm/i915/display/intel_hdmi.c | 16 ++++++++++++++--
>  drivers/gpu/drm/i915/display/intel_hdmi.h |  1 +
>  4 files changed, 17 insertions(+), 2 deletions(-)
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
> index 9fb99b09fff8..5ef2882727e1 100644
> --- a/drivers/gpu/drm/i915/display/intel_ddi.c
> +++ b/drivers/gpu/drm/i915/display/intel_ddi.c
> @@ -4312,6 +4312,7 @@ static void intel_ddi_encoder_shutdown(struct intel_encoder *encoder)
>  	enum phy phy = intel_port_to_phy(i915, encoder->port);
>  
>  	intel_dp_encoder_shutdown(encoder);
> +	intel_hdmi_encoder_shutdown(encoder);
>  
>  	if (!intel_phy_is_tc(i915, phy))
>  		return;
> diff --git a/drivers/gpu/drm/i915/display/intel_hdmi.c b/drivers/gpu/drm/i915/display/intel_hdmi.c
> index 7e6af959bf83..3b5b9e7b05b7 100644
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
> @@ -2285,6 +2286,17 @@ int intel_hdmi_compute_config(struct intel_encoder *encoder,
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
> -- 
> 2.32.0
> 
