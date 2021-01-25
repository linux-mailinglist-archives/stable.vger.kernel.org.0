Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D3D3033BC
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 06:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730822AbhAZFE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:04:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:39534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727096AbhAYSxN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:53:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32FF5230FA;
        Mon, 25 Jan 2021 18:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600772;
        bh=ZOZplDlWANsfdMboQmO8bEMMDH4reio1U9YJYlqlzhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y5//atbpXNzNH46DWg0fqfq2GtR4hBc39VOYpCZ2myNl85bTAbN/gFEchuHeoO7qu
         fjvoEw4gXPKRSWdhg19LIOj+j2YQe9xfJO9RfV3Q5qrLxnNBLQ9I9rvB7dFg4jL78J
         WrlRrUPM0hEzTLDsv4XfAA63pkT3GD2l0t44cZ8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Imre Deak <imre.deak@intel.com>
Subject: [PATCH 5.10 145/199] drm/i915: s/intel_dp_sink_dpms/intel_dp_set_power/
Date:   Mon, 25 Jan 2021 19:39:27 +0100
Message-Id: <20210125183222.334936578@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 0e634efd858e0e9331ea037e1a142e34a446e9e3 upstream.

Rename intel_dp_sink_dpms() to intel_dp_set_power()
so one doesn't always have to convert from the DPMS
enum values to the actual DP D-states.

Also when dealing with a branch device this has nothing to
do with any sink, so the old name was nonsense anyway.
Also adjust the debug message accordingly, and pimp it
with the standard encoder id+name thing.

Trivial bits done with cocci:
@@
expression DP;
@@
(
- intel_dp_sink_dpms(DP, DRM_MODE_DPMS_OFF)
+ intel_dp_set_power(DP, DP_SET_POWER_D3)
|
- intel_dp_sink_dpms(DP, DRM_MODE_DPMS_ON)
+ intel_dp_set_power(DP, DP_SET_POWER_D0)
)

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201016194800.25581-2-ville.syrjala@linux.intel.com
Reviewed-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/display/intel_ddi.c    |    6 +++---
 drivers/gpu/drm/i915/display/intel_dp.c     |   24 ++++++++++++------------
 drivers/gpu/drm/i915/display/intel_dp.h     |    2 +-
 drivers/gpu/drm/i915/display/intel_dp_mst.c |    2 +-
 4 files changed, 17 insertions(+), 17 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -3387,7 +3387,7 @@ static void tgl_ddi_pre_enable_dp(struct
 	intel_ddi_init_dp_buf_reg(encoder);
 
 	if (!is_mst)
-		intel_dp_sink_dpms(intel_dp, DRM_MODE_DPMS_ON);
+		intel_dp_set_power(intel_dp, DP_SET_POWER_D0);
 
 	intel_dp_sink_set_decompression_state(intel_dp, crtc_state, true);
 	/*
@@ -3469,7 +3469,7 @@ static void hsw_ddi_pre_enable_dp(struct
 
 	intel_ddi_init_dp_buf_reg(encoder);
 	if (!is_mst)
-		intel_dp_sink_dpms(intel_dp, DRM_MODE_DPMS_ON);
+		intel_dp_set_power(intel_dp, DP_SET_POWER_D0);
 	intel_dp_configure_protocol_converter(intel_dp);
 	intel_dp_sink_set_decompression_state(intel_dp, crtc_state,
 					      true);
@@ -3647,7 +3647,7 @@ static void intel_ddi_post_disable_dp(st
 	 * Power down sink before disabling the port, otherwise we end
 	 * up getting interrupts from the sink on detecting link loss.
 	 */
-	intel_dp_sink_dpms(intel_dp, DRM_MODE_DPMS_OFF);
+	intel_dp_set_power(intel_dp, DP_SET_POWER_D3);
 
 	if (INTEL_GEN(dev_priv) >= 12) {
 		if (is_mst) {
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -3496,22 +3496,22 @@ void intel_dp_sink_set_decompression_sta
 			    enable ? "enable" : "disable");
 }
 
-/* If the sink supports it, try to set the power state appropriately */
-void intel_dp_sink_dpms(struct intel_dp *intel_dp, int mode)
+/* If the device supports it, try to set the power state appropriately */
+void intel_dp_set_power(struct intel_dp *intel_dp, u8 mode)
 {
-	struct drm_i915_private *i915 = dp_to_i915(intel_dp);
+	struct intel_encoder *encoder = &dp_to_dig_port(intel_dp)->base;
+	struct drm_i915_private *i915 = to_i915(encoder->base.dev);
 	int ret, i;
 
 	/* Should have a valid DPCD by this point */
 	if (intel_dp->dpcd[DP_DPCD_REV] < 0x11)
 		return;
 
-	if (mode != DRM_MODE_DPMS_ON) {
+	if (mode != DP_SET_POWER_D0) {
 		if (downstream_hpd_needs_d0(intel_dp))
 			return;
 
-		ret = drm_dp_dpcd_writeb(&intel_dp->aux, DP_SET_POWER,
-					 DP_SET_POWER_D3);
+		ret = drm_dp_dpcd_writeb(&intel_dp->aux, DP_SET_POWER, mode);
 	} else {
 		struct intel_lspcon *lspcon = dp_to_lspcon(intel_dp);
 
@@ -3520,8 +3520,7 @@ void intel_dp_sink_dpms(struct intel_dp
 		 * time to wake up.
 		 */
 		for (i = 0; i < 3; i++) {
-			ret = drm_dp_dpcd_writeb(&intel_dp->aux, DP_SET_POWER,
-						 DP_SET_POWER_D0);
+			ret = drm_dp_dpcd_writeb(&intel_dp->aux, DP_SET_POWER, mode);
 			if (ret == 1)
 				break;
 			msleep(1);
@@ -3532,8 +3531,9 @@ void intel_dp_sink_dpms(struct intel_dp
 	}
 
 	if (ret != 1)
-		drm_dbg_kms(&i915->drm, "failed to %s sink power state\n",
-			    mode == DRM_MODE_DPMS_ON ? "enable" : "disable");
+		drm_dbg_kms(&i915->drm, "[ENCODER:%d:%s] Set power to %s failed\n",
+			    encoder->base.base.id, encoder->base.name,
+			    mode == DP_SET_POWER_D0 ? "D0" : "D3");
 }
 
 static bool cpt_dp_port_selected(struct drm_i915_private *dev_priv,
@@ -3707,7 +3707,7 @@ static void intel_disable_dp(struct inte
 	 * ensure that we have vdd while we switch off the panel. */
 	intel_edp_panel_vdd_on(intel_dp);
 	intel_edp_backlight_off(old_conn_state);
-	intel_dp_sink_dpms(intel_dp, DRM_MODE_DPMS_OFF);
+	intel_dp_set_power(intel_dp, DP_SET_POWER_D3);
 	intel_edp_panel_off(intel_dp);
 }
 
@@ -3929,7 +3929,7 @@ static void intel_enable_dp(struct intel
 				    lane_mask);
 	}
 
-	intel_dp_sink_dpms(intel_dp, DRM_MODE_DPMS_ON);
+	intel_dp_set_power(intel_dp, DP_SET_POWER_D0);
 	intel_dp_configure_protocol_converter(intel_dp);
 	intel_dp_start_link_train(intel_dp);
 	intel_dp_stop_link_train(intel_dp);
--- a/drivers/gpu/drm/i915/display/intel_dp.h
+++ b/drivers/gpu/drm/i915/display/intel_dp.h
@@ -50,7 +50,7 @@ int intel_dp_get_link_train_fallback_val
 					    int link_rate, u8 lane_count);
 int intel_dp_retrain_link(struct intel_encoder *encoder,
 			  struct drm_modeset_acquire_ctx *ctx);
-void intel_dp_sink_dpms(struct intel_dp *intel_dp, int mode);
+void intel_dp_set_power(struct intel_dp *intel_dp, u8 mode);
 void intel_dp_configure_protocol_converter(struct intel_dp *intel_dp);
 void intel_dp_sink_set_decompression_state(struct intel_dp *intel_dp,
 					   const struct intel_crtc_state *crtc_state,
--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -488,7 +488,7 @@ static void intel_mst_pre_enable_dp(stru
 		    intel_dp->active_mst_links);
 
 	if (first_mst_stream)
-		intel_dp_sink_dpms(intel_dp, DRM_MODE_DPMS_ON);
+		intel_dp_set_power(intel_dp, DP_SET_POWER_D0);
 
 	drm_dp_send_power_updown_phy(&intel_dp->mst_mgr, connector->port, true);
 


