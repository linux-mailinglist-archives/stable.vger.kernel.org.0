Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 693FA45A1F3
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 12:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhKWLzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 06:55:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:41480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229955AbhKWLzM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 06:55:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0671060ED4;
        Tue, 23 Nov 2021 11:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637668324;
        bh=mHIeZA1ejTaDDEPygG0MYIQ+ab99QRg3B+sw903ZhgM=;
        h=Subject:To:Cc:From:Date:From;
        b=MAsSBi/qYKwIOa7ODio79mqJyehTxTYn/KBeSoIJC6MmQFX4+EfTQ4IHpyIGLgoRz
         32+NJGtApSKOcEs/w8PbTT9s+XBm/5Ra31d/RN3waPRK9EbKQSsGHyiIXVnRPRAu7C
         u9gfvVb7TX2D+DplgflbRl7jGeCvKKlC3ppCLJiA=
Subject: FAILED: patch "[PATCH] drm/i915/hdmi: Turn DP++ TMDS output buffers back on in" failed to apply to 5.15-stable tree
To:     ville.syrjala@linux.intel.com, rodrigo.vivi@intel.com,
        stable@vger.kernel.org, stanislav.lisovskiy@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Nov 2021 12:52:02 +0100
Message-ID: <1637668322209209@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cecbc0c7eba7983965cac94f88d2db00b913253b Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Date: Fri, 29 Oct 2021 22:18:02 +0300
Subject: [PATCH] drm/i915/hdmi: Turn DP++ TMDS output buffers back on in
 encoder->shutdown()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Looks like our VBIOS/GOP generally fail to turn the DP dual mode adater
TMDS output buffers back on after a reboot. This leads to a black screen
after reboot if we turned the TMDS output buffers off prior to reboot.
And if i915 decides to do a fastboot the black screen will persist even
after i915 takes over.

Apparently this has been a problem ever since commit b2ccb822d376 ("drm/i915:
Enable/disable TMDS output buffers in DP++ adaptor as needed") if one
rebooted while the display was turned off. And things became worse with
commit fe0f1e3bfdfe ("drm/i915: Shut down displays gracefully on reboot")
since now we always turn the display off before a reboot.

This was reported on a RKL, but I confirmed the same behaviour on my
SNB as well. So looks pretty universal.

Let's fix this by explicitly turning the TMDS output buffers back on
in the encoder->shutdown() hook. Note that this gets called after irqs
have been disabled, so the i2c communication with the DP dual mode
adapter has to be performed via polling (which the gmbus code is
perfectly happy to do for us).

We also need a bit of care in handling DDI encoders which may or may
not be set up for HDMI output. Specifically ddc_pin will not be
populated for a DP only DDI encoder, in which case we don't want to
call intel_gmbus_get_adapter(). We can handle that by simply doing
the dual mode adapter type check before calling
intel_gmbus_get_adapter().

Cc: <stable@vger.kernel.org> # v5.11+
Fixes: fe0f1e3bfdfe ("drm/i915: Shut down displays gracefully on reboot")
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/4371
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211029191802.18448-2-ville.syrjala@linux.intel.com
Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
(cherry picked from commit 49c55f7b035b87371a6d3c53d9af9f92ddc962db)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/display/g4x_hdmi.c b/drivers/gpu/drm/i915/display/g4x_hdmi.c
index 88c427f3c346..f5b4dd5b4275 100644
--- a/drivers/gpu/drm/i915/display/g4x_hdmi.c
+++ b/drivers/gpu/drm/i915/display/g4x_hdmi.c
@@ -584,6 +584,7 @@ void g4x_hdmi_init(struct drm_i915_private *dev_priv,
 		else
 			intel_encoder->enable = g4x_enable_hdmi;
 	}
+	intel_encoder->shutdown = intel_hdmi_encoder_shutdown;
 
 	intel_encoder->type = INTEL_OUTPUT_HDMI;
 	intel_encoder->power_domain = intel_port_to_power_domain(port);
diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
index 1dcfe31e6c6f..cfb567df71b3 100644
--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -4361,6 +4361,7 @@ static void intel_ddi_encoder_shutdown(struct intel_encoder *encoder)
 	enum phy phy = intel_port_to_phy(i915, encoder->port);
 
 	intel_dp_encoder_shutdown(encoder);
+	intel_hdmi_encoder_shutdown(encoder);
 
 	if (!intel_phy_is_tc(i915, phy))
 		return;
diff --git a/drivers/gpu/drm/i915/display/intel_hdmi.c b/drivers/gpu/drm/i915/display/intel_hdmi.c
index d2e61f6c6e08..371736bdc01f 100644
--- a/drivers/gpu/drm/i915/display/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/display/intel_hdmi.c
@@ -1246,12 +1246,13 @@ static void hsw_set_infoframes(struct intel_encoder *encoder,
 void intel_dp_dual_mode_set_tmds_output(struct intel_hdmi *hdmi, bool enable)
 {
 	struct drm_i915_private *dev_priv = intel_hdmi_to_i915(hdmi);
-	struct i2c_adapter *adapter =
-		intel_gmbus_get_adapter(dev_priv, hdmi->ddc_bus);
+	struct i2c_adapter *adapter;
 
 	if (hdmi->dp_dual_mode.type < DRM_DP_DUAL_MODE_TYPE2_DVI)
 		return;
 
+	adapter = intel_gmbus_get_adapter(dev_priv, hdmi->ddc_bus);
+
 	drm_dbg_kms(&dev_priv->drm, "%s DP dual mode adaptor TMDS output\n",
 		    enable ? "Enabling" : "Disabling");
 
@@ -2258,6 +2259,17 @@ int intel_hdmi_compute_config(struct intel_encoder *encoder,
 	return 0;
 }
 
+void intel_hdmi_encoder_shutdown(struct intel_encoder *encoder)
+{
+	struct intel_hdmi *intel_hdmi = enc_to_intel_hdmi(encoder);
+
+	/*
+	 * Give a hand to buggy BIOSen which forget to turn
+	 * the TMDS output buffers back on after a reboot.
+	 */
+	intel_dp_dual_mode_set_tmds_output(intel_hdmi, true);
+}
+
 static void
 intel_hdmi_unset_edid(struct drm_connector *connector)
 {
diff --git a/drivers/gpu/drm/i915/display/intel_hdmi.h b/drivers/gpu/drm/i915/display/intel_hdmi.h
index b43a180d007e..2bf440eb400a 100644
--- a/drivers/gpu/drm/i915/display/intel_hdmi.h
+++ b/drivers/gpu/drm/i915/display/intel_hdmi.h
@@ -28,6 +28,7 @@ void intel_hdmi_init_connector(struct intel_digital_port *dig_port,
 int intel_hdmi_compute_config(struct intel_encoder *encoder,
 			      struct intel_crtc_state *pipe_config,
 			      struct drm_connector_state *conn_state);
+void intel_hdmi_encoder_shutdown(struct intel_encoder *encoder);
 bool intel_hdmi_handle_sink_scrambling(struct intel_encoder *encoder,
 				       struct drm_connector *connector,
 				       bool high_tmds_clock_ratio,

