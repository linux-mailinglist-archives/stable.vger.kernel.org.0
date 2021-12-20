Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983D647AF2D
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239107AbhLTPKe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:10:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238354AbhLTPJO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:09:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC071C079796;
        Mon, 20 Dec 2021 06:54:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3C02B80EE3;
        Mon, 20 Dec 2021 14:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E112EC36AE7;
        Mon, 20 Dec 2021 14:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012064;
        bh=XhY1+6TsgBaiiAV67dkTSyMWpTAvl9m7cEa1vCYI0/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cMOB8Jdwja7GB5UFkCmyoPwb0gM5hyt7c0ymleUcVV9oLPXoAZMaH3bEezX2EePCr
         gpfbP2Osf7ntSwz59NpyC8nEnbyN0C6yoRuiaz08NX7WPVNgAWmOgnxbovH4RULlSE
         j6BnRM2/PXerAc/5g34yCSZW4+tkCWk2cgOzKbjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.15 035/177] drm/i915/hdmi: convert intel_hdmi_to_dev to intel_hdmi_to_i915
Date:   Mon, 20 Dec 2021 15:33:05 +0100
Message-Id: <20211220143041.281841925@linuxfoundation.org>
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

From: Jani Nikula <jani.nikula@intel.com>

commit 7ceb751b615900086eed1d65955933923f127d99 upstream.

Prefer i915 over drm pointer.

Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210921110244.8666-1-jani.nikula@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_hdmi.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/display/intel_hdmi.c
@@ -53,21 +53,20 @@
 #include "intel_panel.h"
 #include "intel_snps_phy.h"
 
-static struct drm_device *intel_hdmi_to_dev(struct intel_hdmi *intel_hdmi)
+static struct drm_i915_private *intel_hdmi_to_i915(struct intel_hdmi *intel_hdmi)
 {
-	return hdmi_to_dig_port(intel_hdmi)->base.base.dev;
+	return to_i915(hdmi_to_dig_port(intel_hdmi)->base.base.dev);
 }
 
 static void
 assert_hdmi_port_disabled(struct intel_hdmi *intel_hdmi)
 {
-	struct drm_device *dev = intel_hdmi_to_dev(intel_hdmi);
-	struct drm_i915_private *dev_priv = to_i915(dev);
+	struct drm_i915_private *dev_priv = intel_hdmi_to_i915(intel_hdmi);
 	u32 enabled_bits;
 
 	enabled_bits = HAS_DDI(dev_priv) ? DDI_BUF_CTL_ENABLE : SDVO_ENABLE;
 
-	drm_WARN(dev,
+	drm_WARN(&dev_priv->drm,
 		 intel_de_read(dev_priv, intel_hdmi->hdmi_reg) & enabled_bits,
 		 "HDMI port enabled, expecting disabled\n");
 }
@@ -1246,7 +1245,7 @@ static void hsw_set_infoframes(struct in
 
 void intel_dp_dual_mode_set_tmds_output(struct intel_hdmi *hdmi, bool enable)
 {
-	struct drm_i915_private *dev_priv = to_i915(intel_hdmi_to_dev(hdmi));
+	struct drm_i915_private *dev_priv = intel_hdmi_to_i915(hdmi);
 	struct i2c_adapter *adapter =
 		intel_gmbus_get_adapter(dev_priv, hdmi->ddc_bus);
 
@@ -1830,7 +1829,7 @@ hdmi_port_clock_valid(struct intel_hdmi
 		      int clock, bool respect_downstream_limits,
 		      bool has_hdmi_sink)
 {
-	struct drm_i915_private *dev_priv = to_i915(intel_hdmi_to_dev(hdmi));
+	struct drm_i915_private *dev_priv = intel_hdmi_to_i915(hdmi);
 
 	if (clock < 25000)
 		return MODE_CLOCK_LOW;
@@ -1946,8 +1945,7 @@ intel_hdmi_mode_valid(struct drm_connect
 		      struct drm_display_mode *mode)
 {
 	struct intel_hdmi *hdmi = intel_attached_hdmi(to_intel_connector(connector));
-	struct drm_device *dev = intel_hdmi_to_dev(hdmi);
-	struct drm_i915_private *dev_priv = to_i915(dev);
+	struct drm_i915_private *dev_priv = intel_hdmi_to_i915(hdmi);
 	enum drm_mode_status status;
 	int clock = mode->clock;
 	int max_dotclk = to_i915(connector->dev)->max_dotclk_freq;


