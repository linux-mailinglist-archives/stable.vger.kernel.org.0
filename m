Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 369EF6C16FF
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbjCTPKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbjCTPK0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:10:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5A26EAE
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:05:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35A2961582
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42550C4339C;
        Mon, 20 Mar 2023 15:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324722;
        bh=twfeNMEA/AEjofChvTfbFfr4i3JY2jbEtlz7oDHFlrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bgraU6r8uE8CEurkaYHGwgcMo+L8lHK1QQIr/jzEu8vaSsA3iceKxhP/VPF1tQkS4
         pg7X/m1+mFj+UZFXjJdMSMw2xNQmujqHN+BxMYpklMqcbLG56BsSB3gCMQn2COXZa1
         OijSjpG4OvTP2BnR8Ucya9y4Le1ykb/ZhGZaCWTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 023/115] drm/i915/display/psr: Handle plane and pipe restrictions at every page flip
Date:   Mon, 20 Mar 2023 15:53:55 +0100
Message-Id: <20230320145450.384848084@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Roberto de Souza <jose.souza@intel.com>

[ Upstream commit ac220f5f754b1d2f4a69428f515c3f1b10d1fad0 ]

PSR2 selective is not supported over rotated and scaled planes.
We had the rotation check in intel_psr2_sel_fetch_config_valid()
but that code path is only execute when a modeset is needed and
those plane parameters can change without a modeset.

Pipe selective fetch restrictions are also needed, it could be added
in intel_psr_compute_config() but pippe scaling is computed after
it is executed, so leaving as is for now.
There is no much loss in this approach as it would cause selective
fetch to not enabled as for alderlake-P and newer will cause it to
switch to PSR1 that will have the same power-savings as do full pipe
fetch.

Also need to check those restricions in the second
for_each_oldnew_intel_plane_in_state() loop because the state could
only have a plane that is not affected by those restricitons but
the damaged area intersect with planes that has those restrictions,
so a full pipe fetch is required.

v2:
- also handling pipe restrictions

BSpec: 55229
Reviewed-by: Gwan-gyeong Mun <gwan-gyeong.mun@intel.com> # v1
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210930001409.254817-1-jose.souza@intel.com
Stable-dep-of: 71c602103c74 ("drm/i915/psr: Use calculated io and fast wake lines")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c | 65 +++++++++++++++++-------
 1 file changed, 46 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index 5e7827b076028..21d58d22c82ee 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -756,11 +756,7 @@ tgl_dc3co_exitline_compute_config(struct intel_dp *intel_dp,
 static bool intel_psr2_sel_fetch_config_valid(struct intel_dp *intel_dp,
 					      struct intel_crtc_state *crtc_state)
 {
-	struct intel_atomic_state *state = to_intel_atomic_state(crtc_state->uapi.state);
 	struct drm_i915_private *dev_priv = dp_to_i915(intel_dp);
-	struct intel_plane_state *plane_state;
-	struct intel_plane *plane;
-	int i;
 
 	if (!dev_priv->params.enable_psr2_sel_fetch &&
 	    intel_dp->psr.debug != I915_PSR_DEBUG_ENABLE_SEL_FETCH) {
@@ -775,14 +771,6 @@ static bool intel_psr2_sel_fetch_config_valid(struct intel_dp *intel_dp,
 		return false;
 	}
 
-	for_each_new_intel_plane_in_state(state, plane, plane_state, i) {
-		if (plane_state->uapi.rotation != DRM_MODE_ROTATE_0) {
-			drm_dbg_kms(&dev_priv->drm,
-				    "PSR2 sel fetch not enabled, plane rotated\n");
-			return false;
-		}
-	}
-
 	/* Wa_14010254185 Wa_14010103792 */
 	if (IS_TGL_DISPLAY_STEP(dev_priv, STEP_A0, STEP_C0)) {
 		drm_dbg_kms(&dev_priv->drm,
@@ -1624,6 +1612,41 @@ static void cursor_area_workaround(const struct intel_plane_state *new_plane_sta
 	clip_area_update(pipe_clip, damaged_area);
 }
 
+/*
+ * TODO: Not clear how to handle planes with negative position,
+ * also planes are not updated if they have a negative X
+ * position so for now doing a full update in this cases
+ *
+ * Plane scaling and rotation is not supported by selective fetch and both
+ * properties can change without a modeset, so need to be check at every
+ * atomic commmit.
+ */
+static bool psr2_sel_fetch_plane_state_supported(const struct intel_plane_state *plane_state)
+{
+	if (plane_state->uapi.dst.y1 < 0 ||
+	    plane_state->uapi.dst.x1 < 0 ||
+	    plane_state->scaler_id >= 0 ||
+	    plane_state->uapi.rotation != DRM_MODE_ROTATE_0)
+		return false;
+
+	return true;
+}
+
+/*
+ * Check for pipe properties that is not supported by selective fetch.
+ *
+ * TODO: pipe scaling causes a modeset but skl_update_scaler_crtc() is executed
+ * after intel_psr_compute_config(), so for now keeping PSR2 selective fetch
+ * enabled and going to the full update path.
+ */
+static bool psr2_sel_fetch_pipe_state_supported(const struct intel_crtc_state *crtc_state)
+{
+	if (crtc_state->scaler_state.scaler_id >= 0)
+		return false;
+
+	return true;
+}
+
 int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 				struct intel_crtc *crtc)
 {
@@ -1637,6 +1660,11 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 	if (!crtc_state->enable_psr2_sel_fetch)
 		return 0;
 
+	if (!psr2_sel_fetch_pipe_state_supported(crtc_state)) {
+		full_update = true;
+		goto skip_sel_fetch_set_loop;
+	}
+
 	/*
 	 * Calculate minimal selective fetch area of each plane and calculate
 	 * the pipe damaged area.
@@ -1656,13 +1684,7 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 		    !old_plane_state->uapi.visible)
 			continue;
 
-		/*
-		 * TODO: Not clear how to handle planes with negative position,
-		 * also planes are not updated if they have a negative X
-		 * position so for now doing a full update in this cases
-		 */
-		if (new_plane_state->uapi.dst.y1 < 0 ||
-		    new_plane_state->uapi.dst.x1 < 0) {
+		if (!psr2_sel_fetch_plane_state_supported(new_plane_state)) {
 			full_update = true;
 			break;
 		}
@@ -1741,6 +1763,11 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 		if (!drm_rect_intersect(&inter, &new_plane_state->uapi.dst))
 			continue;
 
+		if (!psr2_sel_fetch_plane_state_supported(new_plane_state)) {
+			full_update = true;
+			break;
+		}
+
 		sel_fetch_area = &new_plane_state->psr2_sel_fetch_area;
 		sel_fetch_area->y1 = inter.y1 - new_plane_state->uapi.dst.y1;
 		sel_fetch_area->y2 = inter.y2 - new_plane_state->uapi.dst.y1;
-- 
2.39.2



