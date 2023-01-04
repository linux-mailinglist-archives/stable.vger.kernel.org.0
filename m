Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33EC265D56E
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235134AbjADOTb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:19:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239213AbjADOTP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:19:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA331EADE
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:19:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75A04B81677
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCBE9C433EF;
        Wed,  4 Jan 2023 14:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672841951;
        bh=u32SNT0nbgo6OrnQ2ah4BjK5iMrBEk3i+hgauHrVgCE=;
        h=Subject:To:Cc:From:Date:From;
        b=zWoLEQUKP5b0VIN81FU3zPvPz4bw+wfNcEB+p+MFyIlCQ4WSmAFaJmRYcNNPrWegU
         LXc0AbHInkH5OQlFS1fRqmpGQhl89wsowVxzg+Up1A4GeixT7jcXDa/j8KjEG/u69Z
         nYNarILWKsFAcD5Fwqu3NaWSTbDG+xaUpVZf4XNI=
Subject: FAILED: patch "[PATCH] drm/amdgpu/mst: Stop ignoring error codes and deadlocking" failed to apply to 6.0-stable tree
To:     lyude@redhat.com, Wayne.Lin@amd.com, alexander.deucher@amd.com,
        harry.wentland@amd.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:19:05 +0100
Message-ID: <167284194511714@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

7cce4cd628be ("drm/amdgpu/mst: Stop ignoring error codes and deadlocking")
876fcc4222e1 ("drm/amd/display: Validate DSC After Enable All New CRTCs")
4d07b0bc4034 ("drm/display/dp_mst: Move all payload info into the atomic state")
6366fc70deb9 ("drm/display/dp_mst: Maintain time slot allocations when deleting payloads")
a5c2c0d164e9 ("drm/display/dp_mst: Add nonblocking helpers for DP MST")
0b4e477e08a1 ("drm/display/dp_mst: Add helper for finding payloads in atomic MST state")
0bee2ae29eb4 ("drm/display/dp_mst: Add some missing kdocs for atomic MST structs")
df78f7f660cd ("drm/display/dp_mst: Call them time slots, not VCPI slots")
48b6b3726fb7 ("drm/display/dp_mst: Rename drm_dp_mst_vcpi_allocation")
dbaadb3cebaa ("drm/amdgpu/dm/mst: Rename get_payload_table()")
8c5e9bbb3662 ("drm/amdgpu/dc/mst: Rename dp_mst_stream_allocation(_table)")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7cce4cd628bee0d0caff7518c377cf8f599aa38f Mon Sep 17 00:00:00 2001
From: Lyude Paul <lyude@redhat.com>
Date: Mon, 14 Nov 2022 17:17:52 -0500
Subject: [PATCH] drm/amdgpu/mst: Stop ignoring error codes and deadlocking

It appears that amdgpu makes the mistake of completely ignoring the return
values from the DP MST helpers, and instead just returns a simple
true/false. In this case, it seems to have come back to bite us because as
a result of simply returning false from
compute_mst_dsc_configs_for_state(), amdgpu had no way of telling when a
deadlock happened from these helpers. This could definitely result in some
kernel splats.

V2:
* Address Wayne's comments (fix another bunch of spots where we weren't
  passing down return codes)

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: 8c20a1ed9b4f ("drm/amd/display: MST DSC compute fair share")
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: <stable@vger.kernel.org> # v5.6+
Reviewed-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 35fa88787dc1..ef4f788edabe 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6539,7 +6539,7 @@ static int dm_update_mst_vcpi_slots_for_dsc(struct drm_atomic_state *state,
 	struct drm_connector_state *new_con_state;
 	struct amdgpu_dm_connector *aconnector;
 	struct dm_connector_state *dm_conn_state;
-	int i, j;
+	int i, j, ret;
 	int vcpi, pbn_div, pbn, slot_num = 0;
 
 	for_each_new_connector_in_state(state, connector, new_con_state, i) {
@@ -6586,8 +6586,11 @@ static int dm_update_mst_vcpi_slots_for_dsc(struct drm_atomic_state *state,
 			dm_conn_state->pbn = pbn;
 			dm_conn_state->vcpi_slots = slot_num;
 
-			drm_dp_mst_atomic_enable_dsc(state, aconnector->port, dm_conn_state->pbn,
-						     false);
+			ret = drm_dp_mst_atomic_enable_dsc(state, aconnector->port,
+							   dm_conn_state->pbn, false);
+			if (ret < 0)
+				return ret;
+
 			continue;
 		}
 
@@ -9604,10 +9607,9 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 
 #if defined(CONFIG_DRM_AMD_DC_DCN)
 	if (dc_resource_is_dsc_encoding_supported(dc)) {
-		if (!pre_validate_dsc(state, &dm_state, vars)) {
-			ret = -EINVAL;
+		ret = pre_validate_dsc(state, &dm_state, vars);
+		if (ret != 0)
 			goto fail;
-		}
 	}
 #endif
 
@@ -9702,9 +9704,9 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 		}
 
 #if defined(CONFIG_DRM_AMD_DC_DCN)
-		if (!compute_mst_dsc_configs_for_state(state, dm_state->context, vars)) {
+		ret = compute_mst_dsc_configs_for_state(state, dm_state->context, vars);
+		if (ret) {
 			DRM_DEBUG_DRIVER("compute_mst_dsc_configs_for_state() failed\n");
-			ret = -EINVAL;
 			goto fail;
 		}
 
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index d7907974f25a..7d87b1b8eb8d 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -710,13 +710,13 @@ static int bpp_x16_from_pbn(struct dsc_mst_fairness_params param, int pbn)
 	return dsc_config.bits_per_pixel;
 }
 
-static bool increase_dsc_bpp(struct drm_atomic_state *state,
-			     struct drm_dp_mst_topology_state *mst_state,
-			     struct dc_link *dc_link,
-			     struct dsc_mst_fairness_params *params,
-			     struct dsc_mst_fairness_vars *vars,
-			     int count,
-			     int k)
+static int increase_dsc_bpp(struct drm_atomic_state *state,
+			    struct drm_dp_mst_topology_state *mst_state,
+			    struct dc_link *dc_link,
+			    struct dsc_mst_fairness_params *params,
+			    struct dsc_mst_fairness_vars *vars,
+			    int count,
+			    int k)
 {
 	int i;
 	bool bpp_increased[MAX_PIPES];
@@ -726,6 +726,7 @@ static bool increase_dsc_bpp(struct drm_atomic_state *state,
 	int remaining_to_increase = 0;
 	int link_timeslots_used;
 	int fair_pbn_alloc;
+	int ret = 0;
 
 	for (i = 0; i < count; i++) {
 		if (vars[i + k].dsc_enabled) {
@@ -764,52 +765,60 @@ static bool increase_dsc_bpp(struct drm_atomic_state *state,
 
 		if (initial_slack[next_index] > fair_pbn_alloc) {
 			vars[next_index].pbn += fair_pbn_alloc;
-			if (drm_dp_atomic_find_time_slots(state,
-							  params[next_index].port->mgr,
-							  params[next_index].port,
-							  vars[next_index].pbn) < 0)
-				return false;
-			if (!drm_dp_mst_atomic_check(state)) {
+			ret = drm_dp_atomic_find_time_slots(state,
+							    params[next_index].port->mgr,
+							    params[next_index].port,
+							    vars[next_index].pbn);
+			if (ret < 0)
+				return ret;
+
+			ret = drm_dp_mst_atomic_check(state);
+			if (ret == 0) {
 				vars[next_index].bpp_x16 = bpp_x16_from_pbn(params[next_index], vars[next_index].pbn);
 			} else {
 				vars[next_index].pbn -= fair_pbn_alloc;
-				if (drm_dp_atomic_find_time_slots(state,
-								  params[next_index].port->mgr,
-								  params[next_index].port,
-								  vars[next_index].pbn) < 0)
-					return false;
+				ret = drm_dp_atomic_find_time_slots(state,
+								    params[next_index].port->mgr,
+								    params[next_index].port,
+								    vars[next_index].pbn);
+				if (ret < 0)
+					return ret;
 			}
 		} else {
 			vars[next_index].pbn += initial_slack[next_index];
-			if (drm_dp_atomic_find_time_slots(state,
-							  params[next_index].port->mgr,
-							  params[next_index].port,
-							  vars[next_index].pbn) < 0)
-				return false;
-			if (!drm_dp_mst_atomic_check(state)) {
+			ret = drm_dp_atomic_find_time_slots(state,
+							    params[next_index].port->mgr,
+							    params[next_index].port,
+							    vars[next_index].pbn);
+			if (ret < 0)
+				return ret;
+
+			ret = drm_dp_mst_atomic_check(state);
+			if (ret == 0) {
 				vars[next_index].bpp_x16 = params[next_index].bw_range.max_target_bpp_x16;
 			} else {
 				vars[next_index].pbn -= initial_slack[next_index];
-				if (drm_dp_atomic_find_time_slots(state,
-								  params[next_index].port->mgr,
-								  params[next_index].port,
-								  vars[next_index].pbn) < 0)
-					return false;
+				ret = drm_dp_atomic_find_time_slots(state,
+								    params[next_index].port->mgr,
+								    params[next_index].port,
+								    vars[next_index].pbn);
+				if (ret < 0)
+					return ret;
 			}
 		}
 
 		bpp_increased[next_index] = true;
 		remaining_to_increase--;
 	}
-	return true;
+	return 0;
 }
 
-static bool try_disable_dsc(struct drm_atomic_state *state,
-			    struct dc_link *dc_link,
-			    struct dsc_mst_fairness_params *params,
-			    struct dsc_mst_fairness_vars *vars,
-			    int count,
-			    int k)
+static int try_disable_dsc(struct drm_atomic_state *state,
+			   struct dc_link *dc_link,
+			   struct dsc_mst_fairness_params *params,
+			   struct dsc_mst_fairness_vars *vars,
+			   int count,
+			   int k)
 {
 	int i;
 	bool tried[MAX_PIPES];
@@ -817,6 +826,7 @@ static bool try_disable_dsc(struct drm_atomic_state *state,
 	int max_kbps_increase;
 	int next_index;
 	int remaining_to_try = 0;
+	int ret;
 
 	for (i = 0; i < count; i++) {
 		if (vars[i + k].dsc_enabled
@@ -847,49 +857,52 @@ static bool try_disable_dsc(struct drm_atomic_state *state,
 			break;
 
 		vars[next_index].pbn = kbps_to_peak_pbn(params[next_index].bw_range.stream_kbps);
-		if (drm_dp_atomic_find_time_slots(state,
-						  params[next_index].port->mgr,
-						  params[next_index].port,
-						  vars[next_index].pbn) < 0)
-			return false;
+		ret = drm_dp_atomic_find_time_slots(state,
+						    params[next_index].port->mgr,
+						    params[next_index].port,
+						    vars[next_index].pbn);
+		if (ret < 0)
+			return ret;
 
-		if (!drm_dp_mst_atomic_check(state)) {
+		ret = drm_dp_mst_atomic_check(state);
+		if (ret == 0) {
 			vars[next_index].dsc_enabled = false;
 			vars[next_index].bpp_x16 = 0;
 		} else {
 			vars[next_index].pbn = kbps_to_peak_pbn(params[next_index].bw_range.max_kbps);
-			if (drm_dp_atomic_find_time_slots(state,
-							  params[next_index].port->mgr,
-							  params[next_index].port,
-							  vars[next_index].pbn) < 0)
-				return false;
+			ret = drm_dp_atomic_find_time_slots(state,
+							    params[next_index].port->mgr,
+							    params[next_index].port,
+							    vars[next_index].pbn);
+			if (ret < 0)
+				return ret;
 		}
 
 		tried[next_index] = true;
 		remaining_to_try--;
 	}
-	return true;
+	return 0;
 }
 
-static bool compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
-					     struct dc_state *dc_state,
-					     struct dc_link *dc_link,
-					     struct dsc_mst_fairness_vars *vars,
-					     struct drm_dp_mst_topology_mgr *mgr,
-					     int *link_vars_start_index)
+static int compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
+					    struct dc_state *dc_state,
+					    struct dc_link *dc_link,
+					    struct dsc_mst_fairness_vars *vars,
+					    struct drm_dp_mst_topology_mgr *mgr,
+					    int *link_vars_start_index)
 {
 	struct dc_stream_state *stream;
 	struct dsc_mst_fairness_params params[MAX_PIPES];
 	struct amdgpu_dm_connector *aconnector;
 	struct drm_dp_mst_topology_state *mst_state = drm_atomic_get_mst_topology_state(state, mgr);
 	int count = 0;
-	int i, k;
+	int i, k, ret;
 	bool debugfs_overwrite = false;
 
 	memset(params, 0, sizeof(params));
 
 	if (IS_ERR(mst_state))
-		return false;
+		return PTR_ERR(mst_state);
 
 	mst_state->pbn_div = dm_mst_get_pbn_divider(dc_link);
 #if defined(CONFIG_DRM_AMD_DC_DCN)
@@ -940,7 +953,7 @@ static bool compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
 
 	if (count == 0) {
 		ASSERT(0);
-		return true;
+		return 0;
 	}
 
 	/* k is start index of vars for current phy link used by mst hub */
@@ -954,13 +967,17 @@ static bool compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
 		vars[i + k].pbn = kbps_to_peak_pbn(params[i].bw_range.stream_kbps);
 		vars[i + k].dsc_enabled = false;
 		vars[i + k].bpp_x16 = 0;
-		if (drm_dp_atomic_find_time_slots(state, params[i].port->mgr, params[i].port,
-						  vars[i + k].pbn) < 0)
-			return false;
+		ret = drm_dp_atomic_find_time_slots(state, params[i].port->mgr, params[i].port,
+						    vars[i + k].pbn);
+		if (ret < 0)
+			return ret;
 	}
-	if (!drm_dp_mst_atomic_check(state) && !debugfs_overwrite) {
+	ret = drm_dp_mst_atomic_check(state);
+	if (ret == 0 && !debugfs_overwrite) {
 		set_dsc_configs_from_fairness_vars(params, vars, count, k);
-		return true;
+		return 0;
+	} else if (ret != -ENOSPC) {
+		return ret;
 	}
 
 	/* Try max compression */
@@ -969,31 +986,36 @@ static bool compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
 			vars[i + k].pbn = kbps_to_peak_pbn(params[i].bw_range.min_kbps);
 			vars[i + k].dsc_enabled = true;
 			vars[i + k].bpp_x16 = params[i].bw_range.min_target_bpp_x16;
-			if (drm_dp_atomic_find_time_slots(state, params[i].port->mgr,
-							  params[i].port, vars[i + k].pbn) < 0)
-				return false;
+			ret = drm_dp_atomic_find_time_slots(state, params[i].port->mgr,
+							    params[i].port, vars[i + k].pbn);
+			if (ret < 0)
+				return ret;
 		} else {
 			vars[i + k].pbn = kbps_to_peak_pbn(params[i].bw_range.stream_kbps);
 			vars[i + k].dsc_enabled = false;
 			vars[i + k].bpp_x16 = 0;
-			if (drm_dp_atomic_find_time_slots(state, params[i].port->mgr,
-							  params[i].port, vars[i + k].pbn) < 0)
-				return false;
+			ret = drm_dp_atomic_find_time_slots(state, params[i].port->mgr,
+							    params[i].port, vars[i + k].pbn);
+			if (ret < 0)
+				return ret;
 		}
 	}
-	if (drm_dp_mst_atomic_check(state))
-		return false;
+	ret = drm_dp_mst_atomic_check(state);
+	if (ret != 0)
+		return ret;
 
 	/* Optimize degree of compression */
-	if (!increase_dsc_bpp(state, mst_state, dc_link, params, vars, count, k))
-		return false;
+	ret = increase_dsc_bpp(state, mst_state, dc_link, params, vars, count, k);
+	if (ret < 0)
+		return ret;
 
-	if (!try_disable_dsc(state, dc_link, params, vars, count, k))
-		return false;
+	ret = try_disable_dsc(state, dc_link, params, vars, count, k);
+	if (ret < 0)
+		return ret;
 
 	set_dsc_configs_from_fairness_vars(params, vars, count, k);
 
-	return true;
+	return 0;
 }
 
 static bool is_dsc_need_re_compute(
@@ -1094,15 +1116,16 @@ static bool is_dsc_need_re_compute(
 	return is_dsc_need_re_compute;
 }
 
-bool compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
-				       struct dc_state *dc_state,
-				       struct dsc_mst_fairness_vars *vars)
+int compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
+				      struct dc_state *dc_state,
+				      struct dsc_mst_fairness_vars *vars)
 {
 	int i, j;
 	struct dc_stream_state *stream;
 	bool computed_streams[MAX_PIPES];
 	struct amdgpu_dm_connector *aconnector;
 	int link_vars_start_index = 0;
+	int ret = 0;
 
 	for (i = 0; i < dc_state->stream_count; i++)
 		computed_streams[i] = false;
@@ -1125,17 +1148,19 @@ bool compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
 			continue;
 
 		if (dcn20_remove_stream_from_ctx(stream->ctx->dc, dc_state, stream) != DC_OK)
-			return false;
+			return -EINVAL;
 
 		if (!is_dsc_need_re_compute(state, dc_state, stream->link))
 			continue;
 
 		mutex_lock(&aconnector->mst_mgr.lock);
-		if (!compute_mst_dsc_configs_for_link(state, dc_state, stream->link, vars,
-						      &aconnector->mst_mgr,
-						      &link_vars_start_index)) {
+
+		ret = compute_mst_dsc_configs_for_link(state, dc_state, stream->link, vars,
+						       &aconnector->mst_mgr,
+						       &link_vars_start_index);
+		if (ret != 0) {
 			mutex_unlock(&aconnector->mst_mgr.lock);
-			return false;
+			return ret;
 		}
 		mutex_unlock(&aconnector->mst_mgr.lock);
 
@@ -1150,22 +1175,22 @@ bool compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
 
 		if (stream->timing.flags.DSC == 1)
 			if (dc_stream_add_dsc_to_resource(stream->ctx->dc, dc_state, stream) != DC_OK)
-				return false;
+				return -EINVAL;
 	}
 
-	return true;
+	return ret;
 }
 
-static bool
-	pre_compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
-					      struct dc_state *dc_state,
-					      struct dsc_mst_fairness_vars *vars)
+static int pre_compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
+						 struct dc_state *dc_state,
+						 struct dsc_mst_fairness_vars *vars)
 {
 	int i, j;
 	struct dc_stream_state *stream;
 	bool computed_streams[MAX_PIPES];
 	struct amdgpu_dm_connector *aconnector;
 	int link_vars_start_index = 0;
+	int ret;
 
 	for (i = 0; i < dc_state->stream_count; i++)
 		computed_streams[i] = false;
@@ -1191,11 +1216,12 @@ static bool
 			continue;
 
 		mutex_lock(&aconnector->mst_mgr.lock);
-		if (!compute_mst_dsc_configs_for_link(state, dc_state, stream->link, vars,
-						      &aconnector->mst_mgr,
-						      &link_vars_start_index)) {
+		ret = compute_mst_dsc_configs_for_link(state, dc_state, stream->link, vars,
+						       &aconnector->mst_mgr,
+						       &link_vars_start_index);
+		if (ret != 0) {
 			mutex_unlock(&aconnector->mst_mgr.lock);
-			return false;
+			return ret;
 		}
 		mutex_unlock(&aconnector->mst_mgr.lock);
 
@@ -1205,7 +1231,7 @@ static bool
 		}
 	}
 
-	return true;
+	return ret;
 }
 
 static int find_crtc_index_in_state_by_stream(struct drm_atomic_state *state,
@@ -1260,9 +1286,9 @@ static bool is_dsc_precompute_needed(struct drm_atomic_state *state)
 	return ret;
 }
 
-bool pre_validate_dsc(struct drm_atomic_state *state,
-		      struct dm_atomic_state **dm_state_ptr,
-		      struct dsc_mst_fairness_vars *vars)
+int pre_validate_dsc(struct drm_atomic_state *state,
+		     struct dm_atomic_state **dm_state_ptr,
+		     struct dsc_mst_fairness_vars *vars)
 {
 	int i;
 	struct dm_atomic_state *dm_state;
@@ -1271,11 +1297,12 @@ bool pre_validate_dsc(struct drm_atomic_state *state,
 
 	if (!is_dsc_precompute_needed(state)) {
 		DRM_INFO_ONCE("DSC precompute is not needed.\n");
-		return true;
+		return 0;
 	}
-	if (dm_atomic_get_state(state, dm_state_ptr)) {
+	ret = dm_atomic_get_state(state, dm_state_ptr);
+	if (ret != 0) {
 		DRM_INFO_ONCE("dm_atomic_get_state() failed\n");
-		return false;
+		return ret;
 	}
 	dm_state = *dm_state_ptr;
 
@@ -1287,7 +1314,7 @@ bool pre_validate_dsc(struct drm_atomic_state *state,
 
 	local_dc_state = kmemdup(dm_state->context, sizeof(struct dc_state), GFP_KERNEL);
 	if (!local_dc_state)
-		return false;
+		return -ENOMEM;
 
 	for (i = 0; i < local_dc_state->stream_count; i++) {
 		struct dc_stream_state *stream = dm_state->context->streams[i];
@@ -1323,9 +1350,9 @@ bool pre_validate_dsc(struct drm_atomic_state *state,
 	if (ret != 0)
 		goto clean_exit;
 
-	if (!pre_compute_mst_dsc_configs_for_state(state, local_dc_state, vars)) {
+	ret = pre_compute_mst_dsc_configs_for_state(state, local_dc_state, vars);
+	if (ret != 0) {
 		DRM_INFO_ONCE("pre_compute_mst_dsc_configs_for_state() failed\n");
-		ret = -EINVAL;
 		goto clean_exit;
 	}
 
@@ -1356,7 +1383,7 @@ bool pre_validate_dsc(struct drm_atomic_state *state,
 
 	kfree(local_dc_state);
 
-	return (ret == 0);
+	return ret;
 }
 
 static unsigned int kbps_from_pbn(unsigned int pbn)
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
index b92a7c5671aa..97fd70df531b 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
@@ -53,15 +53,15 @@ struct dsc_mst_fairness_vars {
 	struct amdgpu_dm_connector *aconnector;
 };
 
-bool compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
-				       struct dc_state *dc_state,
-				       struct dsc_mst_fairness_vars *vars);
+int compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
+				      struct dc_state *dc_state,
+				      struct dsc_mst_fairness_vars *vars);
 
 bool needs_dsc_aux_workaround(struct dc_link *link);
 
-bool pre_validate_dsc(struct drm_atomic_state *state,
-		      struct dm_atomic_state **dm_state_ptr,
-		      struct dsc_mst_fairness_vars *vars);
+int pre_validate_dsc(struct drm_atomic_state *state,
+		     struct dm_atomic_state **dm_state_ptr,
+		     struct dsc_mst_fairness_vars *vars);
 
 enum dc_status dm_dp_mst_is_port_support_mode(
 	struct amdgpu_dm_connector *aconnector,

