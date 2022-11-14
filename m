Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95EA8628C02
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 23:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236214AbiKNWUF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 17:20:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236826AbiKNWTp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 17:19:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135A6630A
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 14:18:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668464322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BlE+TWuiPf3ZMjnWvEfys1pkhGn5WMcJH2x/6pN/Vzs=;
        b=hKP1eK4Tm6HPVJuXQ/1nCNUFba9vOEr5EhXf0fWEZttLaNxMQWUGANBUlwm9Y3ySY1ARIw
        g18QSVQYSGImoLakAjOGxPe5cTeyeFd5t+umX2xgu1GIcpAfvWHpoVt+FZ3ML6f3AzNkHc
        YjE3clD9YjRnMZibw5US80sfl1sHSSg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-442-xdni5xJfP0yPtSJsSTzf4g-1; Mon, 14 Nov 2022 17:18:38 -0500
X-MC-Unique: xdni5xJfP0yPtSJsSTzf4g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D8D12380390C;
        Mon, 14 Nov 2022 22:18:36 +0000 (UTC)
Received: from emerald.lyude.net (unknown [10.22.18.150])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C047D49BB60;
        Mon, 14 Nov 2022 22:18:35 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     amd-gfx@lists.freedesktop.org
Cc:     Harry Wentland <harry.wentland@amd.com>, stable@vger.kernel.org,
        Leo Li <sunpeng.li@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Roman Li <roman.li@amd.com>, Fangzhi Zuo <Jerry.Zuo@amd.com>,
        hersen wu <hersenxs.wu@amd.com>, Wayne Lin <Wayne.Lin@amd.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Hamza Mahfooz <hamza.mahfooz@amd.com>,
        Alex Hung <alex.hung@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Wenjing Liu <Wenjing.Liu@amd.com>,
        David Francis <David.Francis@amd.com>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/4] drm/amdgpu/mst: Stop ignoring error codes and deadlocking
Date:   Mon, 14 Nov 2022 17:17:52 -0500
Message-Id: <20221114221754.385090-2-lyude@redhat.com>
In-Reply-To: <20221114221754.385090-1-lyude@redhat.com>
References: <20221114221754.385090-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  18 +-
 .../display/amdgpu_dm/amdgpu_dm_mst_types.c   | 235 ++++++++++--------
 .../display/amdgpu_dm/amdgpu_dm_mst_types.h   |  12 +-
 3 files changed, 147 insertions(+), 118 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 0db2a88cd4d7b..852a2100c6b38 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6462,7 +6462,7 @@ static int dm_update_mst_vcpi_slots_for_dsc(struct drm_atomic_state *state,
 	struct drm_connector_state *new_con_state;
 	struct amdgpu_dm_connector *aconnector;
 	struct dm_connector_state *dm_conn_state;
-	int i, j;
+	int i, j, ret;
 	int vcpi, pbn_div, pbn, slot_num = 0;
 
 	for_each_new_connector_in_state(state, connector, new_con_state, i) {
@@ -6509,8 +6509,11 @@ static int dm_update_mst_vcpi_slots_for_dsc(struct drm_atomic_state *state,
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
 
@@ -9523,10 +9526,9 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 
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
 
@@ -9621,9 +9623,9 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
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
index 6ff96b4bdda5c..bba2e8aaa2c20 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -703,13 +703,13 @@ static int bpp_x16_from_pbn(struct dsc_mst_fairness_params param, int pbn)
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
@@ -719,6 +719,7 @@ static bool increase_dsc_bpp(struct drm_atomic_state *state,
 	int remaining_to_increase = 0;
 	int link_timeslots_used;
 	int fair_pbn_alloc;
+	int ret = 0;
 
 	for (i = 0; i < count; i++) {
 		if (vars[i + k].dsc_enabled) {
@@ -757,52 +758,60 @@ static bool increase_dsc_bpp(struct drm_atomic_state *state,
 
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
@@ -810,6 +819,7 @@ static bool try_disable_dsc(struct drm_atomic_state *state,
 	int max_kbps_increase;
 	int next_index;
 	int remaining_to_try = 0;
+	int ret;
 
 	for (i = 0; i < count; i++) {
 		if (vars[i + k].dsc_enabled
@@ -840,49 +850,52 @@ static bool try_disable_dsc(struct drm_atomic_state *state,
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
@@ -933,7 +946,7 @@ static bool compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
 
 	if (count == 0) {
 		ASSERT(0);
-		return true;
+		return 0;
 	}
 
 	/* k is start index of vars for current phy link used by mst hub */
@@ -947,13 +960,17 @@ static bool compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
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
@@ -962,31 +979,36 @@ static bool compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
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
@@ -1087,15 +1109,16 @@ static bool is_dsc_need_re_compute(
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
@@ -1118,17 +1141,19 @@ bool compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
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
 
@@ -1143,22 +1168,22 @@ bool compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
 
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
@@ -1184,11 +1209,12 @@ static bool
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
 
@@ -1198,7 +1224,7 @@ static bool
 		}
 	}
 
-	return true;
+	return ret;
 }
 
 static int find_crtc_index_in_state_by_stream(struct drm_atomic_state *state,
@@ -1253,9 +1279,9 @@ static bool is_dsc_precompute_needed(struct drm_atomic_state *state)
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
@@ -1264,11 +1290,12 @@ bool pre_validate_dsc(struct drm_atomic_state *state,
 
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
 
@@ -1280,7 +1307,7 @@ bool pre_validate_dsc(struct drm_atomic_state *state,
 
 	local_dc_state = kmemdup(dm_state->context, sizeof(struct dc_state), GFP_KERNEL);
 	if (!local_dc_state)
-		return false;
+		return -ENOMEM;
 
 	for (i = 0; i < local_dc_state->stream_count; i++) {
 		struct dc_stream_state *stream = dm_state->context->streams[i];
@@ -1316,9 +1343,9 @@ bool pre_validate_dsc(struct drm_atomic_state *state,
 	if (ret != 0)
 		goto clean_exit;
 
-	if (!pre_compute_mst_dsc_configs_for_state(state, local_dc_state, vars)) {
+	ret = pre_compute_mst_dsc_configs_for_state(state, local_dc_state, vars);
+	if (ret != 0) {
 		DRM_INFO_ONCE("pre_compute_mst_dsc_configs_for_state() failed\n");
-		ret = -EINVAL;
 		goto clean_exit;
 	}
 
@@ -1349,7 +1376,7 @@ bool pre_validate_dsc(struct drm_atomic_state *state,
 
 	kfree(local_dc_state);
 
-	return (ret == 0);
+	return ret;
 }
 
 static unsigned int kbps_from_pbn(unsigned int pbn)
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
index b92a7c5671aa2..97fd70df531bf 100644
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
-- 
2.37.3

