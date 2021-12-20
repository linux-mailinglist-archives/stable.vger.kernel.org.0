Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C65E947AF30
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238058AbhLTPKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239391AbhLTPJV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:09:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39118C061401;
        Mon, 20 Dec 2021 06:54:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD19C611B6;
        Mon, 20 Dec 2021 14:54:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC89C36AE7;
        Mon, 20 Dec 2021 14:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012067;
        bh=BcK7/XkQOHkOgwMC276YuNW+agXBk4FdVA0PGkd9XGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wXsJoPQAAIBFkSBRyryxW+174d9H/4iZGbDmRHbnG5dZbZa+f2uvcd9cSjHAT0iGC
         lAvITgeIx8uDvo6TJ8MspyTrfbw9eKRuNraMnDqpccSoSFa54Fu/IR0AHUeJcjnHyD
         FXYNVXyUK1wBTbO5AUChsTUaB+bE9FrJKvrbwOBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.15 036/177] drm/i915/hdmi: Turn DP++ TMDS output buffers back on in encoder->shutdown()
Date:   Mon, 20 Dec 2021 15:33:06 +0100
Message-Id: <20211220143041.314760957@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit cecbc0c7eba7983965cac94f88d2db00b913253b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/g4x_hdmi.c   |    1 +
 drivers/gpu/drm/i915/display/intel_ddi.c  |    1 +
 drivers/gpu/drm/i915/display/intel_hdmi.c |   16 ++++++++++++++--
 drivers/gpu/drm/i915/display/intel_hdmi.h |    1 +
 4 files changed, 17 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/g4x_hdmi.c
+++ b/drivers/gpu/drm/i915/display/g4x_hdmi.c
@@ -584,6 +584,7 @@ void g4x_hdmi_init(struct drm_i915_priva
 		else
 			intel_encoder->enable = g4x_enable_hdmi;
 	}
+	intel_encoder->shutdown = intel_hdmi_encoder_shutdown;
 
 	intel_encoder->type = INTEL_OUTPUT_HDMI;
 	intel_encoder->power_domain = intel_port_to_power_domain(port);
--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -4432,6 +4432,7 @@ static void intel_ddi_encoder_shutdown(s
 	enum phy phy = intel_port_to_phy(i915, encoder->port);
 
 	intel_dp_encoder_shutdown(encoder);
+	intel_hdmi_encoder_shutdown(encoder);
 
 	if (!intel_phy_is_tc(i915, phy))
 		return;
--- a/drivers/gpu/drm/i915/display/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/display/intel_hdmi.c
@@ -1246,12 +1246,13 @@ static void hsw_set_infoframes(struct in
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
 
@@ -2258,6 +2259,17 @@ int intel_hdmi_compute_config(struct int
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
--- a/drivers/gpu/drm/i915/display/intel_hdmi.h
+++ b/drivers/gpu/drm/i915/display/intel_hdmi.h
@@ -28,6 +28,7 @@ void intel_hdmi_init_connector(struct in
 int intel_hdmi_compute_config(struct intel_encoder *encoder,
 			      struct intel_crtc_state *pipe_config,
 			      struct drm_connector_state *conn_state);
+void intel_hdmi_encoder_shutdown(struct intel_encoder *encoder);
 bool intel_hdmi_handle_sink_scrambling(struct intel_encoder *encoder,
 				       struct drm_connector *connector,
 				       bool high_tmds_clock_ratio,


