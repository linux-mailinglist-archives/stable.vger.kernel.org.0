Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91944313BF
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 11:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbhJRJoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 05:44:55 -0400
Received: from mga07.intel.com ([134.134.136.100]:21934 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231493AbhJRJov (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 05:44:51 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10140"; a="291682969"
X-IronPort-AV: E=Sophos;i="5.85,381,1624345200"; 
   d="scan'208";a="291682969"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2021 02:42:03 -0700
X-IronPort-AV: E=Sophos;i="5.85,381,1624345200"; 
   d="scan'208";a="493516730"
Received: from ideak-desk.fi.intel.com ([10.237.68.141])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2021 02:42:02 -0700
From:   Imre Deak <imre.deak@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH 3/6] drm/i915/dp: Ensure max link params are always valid
Date:   Mon, 18 Oct 2021 12:41:51 +0300
Message-Id: <20211018094154.1407705-4-imre.deak@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211018094154.1407705-1-imre.deak@intel.com>
References: <20211018094154.1407705-1-imre.deak@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Atm until the DPCD for a connector is read the max link rate and lane
count params are invalid. If the connector is modeset, in
intel_dp_compute_config(), intel_dp_common_len_rate_limit(max_link_rate)
will return 0, leading to a intel_dp->common_rates[-1] access.

Fix the above by making sure the max link params are always valid.

The above access leads to an undefined behaviour by definition, though
not causing a user visible problem to my best knowledge, see the previous
patch why. Nevertheless it is an undefined behaviour and it triggers a
BUG() in CONFIG_UBSAN builds, hence CC:stable.

Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/gpu/drm/i915/display/intel_dp.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 153ae944a354b..1935eb49f9574 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -1864,6 +1864,12 @@ void intel_dp_set_link_params(struct intel_dp *intel_dp,
 	intel_dp->lane_count = lane_count;
 }
 
+static void intel_dp_reset_max_link_params(struct intel_dp *intel_dp)
+{
+	intel_dp->max_link_lane_count = intel_dp_max_common_lane_count(intel_dp);
+	intel_dp->max_link_rate = intel_dp_max_common_rate(intel_dp);
+}
+
 /* Enable backlight PWM and backlight PP control. */
 void intel_edp_backlight_on(const struct intel_crtc_state *crtc_state,
 			    const struct drm_connector_state *conn_state)
@@ -2023,8 +2029,7 @@ void intel_dp_sync_state(struct intel_encoder *encoder,
 	if (intel_dp->dpcd[DP_DPCD_REV] == 0)
 		intel_dp_get_dpcd(intel_dp);
 
-	intel_dp->max_link_lane_count = intel_dp_max_common_lane_count(intel_dp);
-	intel_dp->max_link_rate = intel_dp_max_common_rate(intel_dp);
+	intel_dp_reset_max_link_params(intel_dp);
 }
 
 bool intel_dp_initial_fastset_check(struct intel_encoder *encoder,
@@ -2597,6 +2602,7 @@ intel_edp_init_dpcd(struct intel_dp *intel_dp)
 		intel_dp_set_sink_rates(intel_dp);
 
 	intel_dp_set_common_rates(intel_dp);
+	intel_dp_reset_max_link_params(intel_dp);
 
 	/* Read the eDP DSC DPCD registers */
 	if (DISPLAY_VER(dev_priv) >= 10)
@@ -4338,12 +4344,7 @@ intel_dp_detect(struct drm_connector *connector,
 	 * supports link training fallback params.
 	 */
 	if (intel_dp->reset_link_params || intel_dp->is_mst) {
-		/* Initial max link lane count */
-		intel_dp->max_link_lane_count = intel_dp_max_common_lane_count(intel_dp);
-
-		/* Initial max link rate */
-		intel_dp->max_link_rate = intel_dp_max_common_rate(intel_dp);
-
+		intel_dp_reset_max_link_params(intel_dp);
 		intel_dp->reset_link_params = false;
 	}
 
@@ -5011,6 +5012,7 @@ intel_dp_init_connector(struct intel_digital_port *dig_port,
 	intel_dp_set_source_rates(intel_dp);
 	intel_dp_set_default_sink_rates(intel_dp);
 	intel_dp_set_common_rates(intel_dp);
+	intel_dp_reset_max_link_params(intel_dp);
 
 	if (IS_VALLEYVIEW(dev_priv) || IS_CHERRYVIEW(dev_priv))
 		intel_dp->pps.active_pipe = vlv_active_pipe(intel_dp);
-- 
2.27.0

