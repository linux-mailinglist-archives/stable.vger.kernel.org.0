Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8B27628C00
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 23:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237010AbiKNWUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 17:20:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236693AbiKNWTp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 17:19:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A9FBE10
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 14:18:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668464325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BwdYUydnhRZsWPP/sXvy2mAjn3fiCkV9s76CcNVZuMU=;
        b=UszbIIuLXlTJibvtXk2BHO1yrs9HboYkM/hJsERrIZhupHsj+v5x9cMwg9/3P/KosxcHvt
        H9/Bz/j3FwLIy2ZJVVhf4N7seQ3Qt1SO2qvhNngppckXKK4iiYQ8tNadGJJTQPIPDK1kSG
        hvgAVo3uYQZ5H0s2dqMOuhI9p/JfvQ4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-507-lNYgjQTHOvisQdRJTmanfQ-1; Mon, 14 Nov 2022 17:18:42 -0500
X-MC-Unique: lNYgjQTHOvisQdRJTmanfQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73C6B85A5A6;
        Mon, 14 Nov 2022 22:18:41 +0000 (UTC)
Received: from emerald.lyude.net (unknown [10.22.18.150])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B28DE49BB60;
        Mon, 14 Nov 2022 22:18:40 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     amd-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        hersen wu <hersenxs.wu@amd.com>,
        Fangzhi Zuo <Jerry.Zuo@amd.com>, Wayne Lin <Wayne.Lin@amd.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Roman Li <Roman.Li@amd.com>,
        Hamza Mahfooz <hamza.mahfooz@amd.com>,
        Wenjing Liu <Wenjing.Liu@amd.com>,
        David Francis <David.Francis@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 3/4] drm/amdgpu/dm/mst: Use the correct topology mgr pointer in amdgpu_dm_connector
Date:   Mon, 14 Nov 2022 17:17:54 -0500
Message-Id: <20221114221754.385090-4-lyude@redhat.com>
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

This bug hurt me. Basically, it appears that we've been grabbing the
entirely wrong mutex in the MST DSC computation code for amdgpu! While
we've been grabbing:

  amdgpu_dm_connector->mst_mgr

That's zero-initialized memory, because the only connectors we'll ever
actually be doing DSC computations for are MST ports. Which have mst_mgr
zero-initialized, and instead have the correct topology mgr pointer located
at:

  amdgpu_dm_connector->mst_port->mgr;

I'm a bit impressed that until now, this code has managed not to crash
anyone's systems! It does seem to cause a warning in LOCKDEP though:

  [   66.637670] DEBUG_LOCKS_WARN_ON(lock->magic != lock)

This was causing the problems that appeared to have been introduced by:

  commit 4d07b0bc4034 ("drm/display/dp_mst: Move all payload info into the atomic state")

This wasn't actually where they came from though. Presumably, before the
only thing we were doing with the topology mgr pointer was attempting to
grab mst_mgr->lock. Since the above commit however, we grab much more
information from mst_mgr including the atomic MST state and respective
modesetting locks.

This patch also implies that up until now, it's quite likely we could be
susceptible to race conditions when going through the MST topology state
for DSC computations since we technically will not have grabbed any lock
when going through it.

So, let's fix this by adjusting all the respective code paths to look at
the right pointer and skip things that aren't actual MST connectors from a
topology.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Gitlab issue: https://gitlab.freedesktop.org/drm/amd/-/issues/2171
Fixes: 8c20a1ed9b4f ("drm/amd/display: MST DSC compute fair share")
Cc: <stable@vger.kernel.org> # v5.6+
---
 .../display/amdgpu_dm/amdgpu_dm_mst_types.c   | 37 +++++++++----------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index bba2e8aaa2c20..5196c9a0e432d 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1117,6 +1117,7 @@ int compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
 	struct dc_stream_state *stream;
 	bool computed_streams[MAX_PIPES];
 	struct amdgpu_dm_connector *aconnector;
+	struct drm_dp_mst_topology_mgr *mst_mgr;
 	int link_vars_start_index = 0;
 	int ret = 0;
 
@@ -1131,7 +1132,7 @@ int compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
 
 		aconnector = (struct amdgpu_dm_connector *)stream->dm_stream_context;
 
-		if (!aconnector || !aconnector->dc_sink)
+		if (!aconnector || !aconnector->dc_sink || !aconnector->port)
 			continue;
 
 		if (!aconnector->dc_sink->dsc_caps.dsc_dec_caps.is_dsc_supported)
@@ -1146,16 +1147,13 @@ int compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
 		if (!is_dsc_need_re_compute(state, dc_state, stream->link))
 			continue;
 
-		mutex_lock(&aconnector->mst_mgr.lock);
-
-		ret = compute_mst_dsc_configs_for_link(state, dc_state, stream->link, vars,
-						       &aconnector->mst_mgr,
+		mst_mgr = aconnector->port->mgr;
+		mutex_lock(&mst_mgr->lock);
+		ret = compute_mst_dsc_configs_for_link(state, dc_state, stream->link, vars, mst_mgr,
 						       &link_vars_start_index);
-		if (ret != 0) {
-			mutex_unlock(&aconnector->mst_mgr.lock);
+		mutex_unlock(&mst_mgr->lock);
+		if (ret != 0)
 			return ret;
-		}
-		mutex_unlock(&aconnector->mst_mgr.lock);
 
 		for (j = 0; j < dc_state->stream_count; j++) {
 			if (dc_state->streams[j]->link == stream->link)
@@ -1182,6 +1180,7 @@ static int pre_compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
 	struct dc_stream_state *stream;
 	bool computed_streams[MAX_PIPES];
 	struct amdgpu_dm_connector *aconnector;
+	struct drm_dp_mst_topology_mgr *mst_mgr;
 	int link_vars_start_index = 0;
 	int ret;
 
@@ -1196,7 +1195,7 @@ static int pre_compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
 
 		aconnector = (struct amdgpu_dm_connector *)stream->dm_stream_context;
 
-		if (!aconnector || !aconnector->dc_sink)
+		if (!aconnector || !aconnector->dc_sink || !aconnector->port)
 			continue;
 
 		if (!aconnector->dc_sink->dsc_caps.dsc_dec_caps.is_dsc_supported)
@@ -1208,15 +1207,13 @@ static int pre_compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
 		if (!is_dsc_need_re_compute(state, dc_state, stream->link))
 			continue;
 
-		mutex_lock(&aconnector->mst_mgr.lock);
-		ret = compute_mst_dsc_configs_for_link(state, dc_state, stream->link, vars,
-						       &aconnector->mst_mgr,
+		mst_mgr = aconnector->port->mgr;
+		mutex_lock(&mst_mgr->lock);
+		ret = compute_mst_dsc_configs_for_link(state, dc_state, stream->link, vars, mst_mgr,
 						       &link_vars_start_index);
-		if (ret != 0) {
-			mutex_unlock(&aconnector->mst_mgr.lock);
+		mutex_unlock(&mst_mgr->lock);
+		if (ret != 0)
 			return ret;
-		}
-		mutex_unlock(&aconnector->mst_mgr.lock);
 
 		for (j = 0; j < dc_state->stream_count; j++) {
 			if (dc_state->streams[j]->link == stream->link)
@@ -1419,6 +1416,7 @@ enum dc_status dm_dp_mst_is_port_support_mode(
 	unsigned int upper_link_bw_in_kbps = 0, down_link_bw_in_kbps = 0;
 	unsigned int max_compressed_bw_in_kbps = 0;
 	struct dc_dsc_bw_range bw_range = {0};
+	struct drm_dp_mst_topology_mgr *mst_mgr;
 
 	/*
 	 * check if the mode could be supported if DSC pass-through is supported
@@ -1427,7 +1425,8 @@ enum dc_status dm_dp_mst_is_port_support_mode(
 	 */
 	if (is_dsc_common_config_possible(stream, &bw_range) &&
 	    aconnector->port->passthrough_aux) {
-		mutex_lock(&aconnector->mst_mgr.lock);
+		mst_mgr = aconnector->port->mgr;
+		mutex_lock(&mst_mgr->lock);
 
 		cur_link_settings = stream->link->verified_link_cap;
 
@@ -1440,7 +1439,7 @@ enum dc_status dm_dp_mst_is_port_support_mode(
 		end_to_end_bw_in_kbps = min(upper_link_bw_in_kbps,
 					    down_link_bw_in_kbps);
 
-		mutex_unlock(&aconnector->mst_mgr.lock);
+		mutex_unlock(&mst_mgr->lock);
 
 		/*
 		 * use the maximum dsc compression bandwidth as the required
-- 
2.37.3

