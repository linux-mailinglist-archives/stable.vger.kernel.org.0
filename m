Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F979307A34
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 17:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbhA1QBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 11:01:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:6998 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229785AbhA1QBl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 11:01:41 -0500
IronPort-SDR: ct3ZBpW5vgiMIyP+ArZ/X85TGYYR5H197O2rAlBPLh18XxXNud0lHGPup4n7HdWoPnVnhhGN3t
 RdZ/E0YFLRow==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="199090692"
X-IronPort-AV: E=Sophos;i="5.79,382,1602572400"; 
   d="scan'208";a="199090692"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 07:59:55 -0800
IronPort-SDR: dW2GBBf3u9X43+wFRhxYe7cZ/tkaRtdFj0z1wbvozCxo6rXV6bU3LmkUqgE+R+A64DWHbGXebW
 qwBheWk1W0Lg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,382,1602572400"; 
   d="scan'208";a="473879654"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.171])
  by fmsmga001.fm.intel.com with SMTP; 28 Jan 2021 07:59:53 -0800
Received: by stinkbox (sSMTP sendmail emulation); Thu, 28 Jan 2021 17:59:52 +0200
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 2/5] drm/i915: Extract intel_ddi_power_up_lanes()
Date:   Thu, 28 Jan 2021 17:59:45 +0200
Message-Id: <20210128155948.13678-2-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210128155948.13678-1-ville.syrjala@linux.intel.com>
References: <20210128155948.13678-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

Reduce the copypasta by pulling the combo PHY lane
power up stuff into a helper. We'll have a third user soon.

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/intel_ddi.c | 35 +++++++++++++-----------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
index c94650488dc1..88cc6e2fbe91 100644
--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -3641,6 +3641,23 @@ static void intel_ddi_disable_fec_state(struct intel_encoder *encoder,
 	intel_de_posting_read(dev_priv, dp_tp_ctl_reg(encoder, crtc_state));
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
@@ -3732,14 +3749,7 @@ static void tgl_ddi_pre_enable_dp(struct intel_atomic_state *state,
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
@@ -3830,14 +3840,7 @@ static void hsw_ddi_pre_enable_dp(struct intel_atomic_state *state,
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
 
 	intel_ddi_init_dp_buf_reg(encoder, crtc_state);
 	if (!is_mst)
-- 
2.26.2

