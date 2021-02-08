Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7333137D6
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233616AbhBHPcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:32:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:37070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231931AbhBHP1p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:27:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B28C164F1F;
        Mon,  8 Feb 2021 15:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797363;
        bh=Fz3VnFGFeEUIyW+fyYDJdIxniSsJ8bk1pCf9rj5Tmp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eMMf0GpuEdOl5oZMMm/uF+7x7TsPacij2kO3Ba+H0t/dikPZZafWPFDySIdjJlGbd
         Y54PrNG/2W3Inv/tSti1T/Bm08TYMpgR9L9FyczgVH8/csYk2TVGFZmDRTqbdDR/TK
         0L4Hk06A5nXSIqsfRE3H/aL/Df3EP0wqOMkjGg+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Imre Deak <imre.deak@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.10 083/120] drm/i915: Extract intel_ddi_power_up_lanes()
Date:   Mon,  8 Feb 2021 16:01:10 +0100
Message-Id: <20210208145821.706343627@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 425cbd1fce10d4d68188123404d1a302a6939e0a upstream.

Reduce the copypasta by pulling the combo PHY lane
power up stuff into a helper. We'll have a third user soon.

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210128155948.13678-2-ville.syrjala@linux.intel.com
Reviewed-by: Imre Deak <imre.deak@intel.com>
(cherry picked from commit 5cdf706fb91a6e4e6af799bb957c4d598e6a067b)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_ddi.c |   35 ++++++++++++++++---------------
 1 file changed, 19 insertions(+), 16 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -3274,6 +3274,23 @@ static void intel_ddi_disable_fec_state(
 	intel_de_posting_read(dev_priv, intel_dp->regs.dp_tp_ctl);
 }
 
+static void intel_ddi_power_up_lanes(struct intel_encoder *encoder,
+				     const struct intel_crtc_state *crtc_state)
+{
+	struct drm_i915_private *i915 = to_i915(encoder->base.dev);
+	struct intel_digital_port *dig_port = enc_to_dig_port(encoder);
+	enum phy phy = intel_port_to_phy(i915, encoder->port);
+
+	if (intel_phy_is_combo(i915, phy)) {
+		bool lane_reversal =
+			dig_port->saved_port_bits & DDI_BUF_PORT_REVERSAL;
+
+		intel_combo_phy_power_up_lanes(i915, phy, false,
+					       crtc_state->lane_count,
+					       lane_reversal);
+	}
+}
+
 static void tgl_ddi_pre_enable_dp(struct intel_atomic_state *state,
 				  struct intel_encoder *encoder,
 				  const struct intel_crtc_state *crtc_state,
@@ -3367,14 +3384,7 @@ static void tgl_ddi_pre_enable_dp(struct
 	 * 7.f Combo PHY: Configure PORT_CL_DW10 Static Power Down to power up
 	 * the used lanes of the DDI.
 	 */
-	if (intel_phy_is_combo(dev_priv, phy)) {
-		bool lane_reversal =
-			dig_port->saved_port_bits & DDI_BUF_PORT_REVERSAL;
-
-		intel_combo_phy_power_up_lanes(dev_priv, phy, false,
-					       crtc_state->lane_count,
-					       lane_reversal);
-	}
+	intel_ddi_power_up_lanes(encoder, crtc_state);
 
 	/*
 	 * 7.g Configure and enable DDI_BUF_CTL
@@ -3458,14 +3468,7 @@ static void hsw_ddi_pre_enable_dp(struct
 	else
 		intel_prepare_dp_ddi_buffers(encoder, crtc_state);
 
-	if (intel_phy_is_combo(dev_priv, phy)) {
-		bool lane_reversal =
-			dig_port->saved_port_bits & DDI_BUF_PORT_REVERSAL;
-
-		intel_combo_phy_power_up_lanes(dev_priv, phy, false,
-					       crtc_state->lane_count,
-					       lane_reversal);
-	}
+	intel_ddi_power_up_lanes(encoder, crtc_state);
 
 	intel_ddi_init_dp_buf_reg(encoder);
 	if (!is_mst)


