Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 816F945C64B
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351633AbhKXOGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:06:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:52678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356462AbhKXOEV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:04:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2390B63324;
        Wed, 24 Nov 2021 13:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759467;
        bh=SLHtvZjX+73X4UxWev/oG9jPuCyO+YsPOtR8+lk9VY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=izTUeNLuOEtSK6au6E1kGm5SKf1FRtiFRSnOj9l6PU+ImUQvgQ5OgqD72orA5N09S
         h0soVKPquELlSosYck5XuF+CiaTpgbgblRKXthmHSKg3EdZQ203mnSSs1wNseDFNEw
         K22OSQOFAZPxbjbKm4eRJsgUJa/kTNiCoiukQM1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Imre Deak <imre.deak@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.15 252/279] drm/i915/dp: Ensure max link params are always valid
Date:   Wed, 24 Nov 2021 12:58:59 +0100
Message-Id: <20211124115727.431013071@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

commit cc99bc62ff6902688ee7bd3a7b25eefc620fbb6a upstream.

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
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211018094154.1407705-4-imre.deak@intel.com
(cherry picked from commit 9ad87de4735620ffc555592e8c5f580478fa3ed0)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -1773,6 +1773,12 @@ void intel_dp_set_link_params(struct int
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
@@ -1932,8 +1938,7 @@ void intel_dp_sync_state(struct intel_en
 	if (intel_dp->dpcd[DP_DPCD_REV] == 0)
 		intel_dp_get_dpcd(intel_dp);
 
-	intel_dp->max_link_lane_count = intel_dp_max_common_lane_count(intel_dp);
-	intel_dp->max_link_rate = intel_dp_max_common_rate(intel_dp);
+	intel_dp_reset_max_link_params(intel_dp);
 }
 
 bool intel_dp_initial_fastset_check(struct intel_encoder *encoder,
@@ -2506,6 +2511,7 @@ intel_edp_init_dpcd(struct intel_dp *int
 		intel_dp_set_sink_rates(intel_dp);
 
 	intel_dp_set_common_rates(intel_dp);
+	intel_dp_reset_max_link_params(intel_dp);
 
 	/* Read the eDP DSC DPCD registers */
 	if (DISPLAY_VER(dev_priv) >= 10)
@@ -4249,12 +4255,7 @@ intel_dp_detect(struct drm_connector *co
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
 
@@ -5307,6 +5308,7 @@ intel_dp_init_connector(struct intel_dig
 	intel_dp_set_source_rates(intel_dp);
 	intel_dp_set_default_sink_rates(intel_dp);
 	intel_dp_set_common_rates(intel_dp);
+	intel_dp_reset_max_link_params(intel_dp);
 
 	intel_dp->reset_link_params = true;
 	intel_dp->pps.pps_pipe = INVALID_PIPE;


