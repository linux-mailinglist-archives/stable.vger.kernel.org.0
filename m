Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3443663DC23
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 18:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiK3RiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 12:38:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiK3RiL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 12:38:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D7443AD6
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 09:38:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D43961D3A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 17:38:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E421C433D6;
        Wed, 30 Nov 2022 17:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669829888;
        bh=ebdK82teS1V00YGc3dCIyu80LwoRTr+a0owFo1qDDLk=;
        h=Subject:To:Cc:From:Date:From;
        b=U916hxT58Z/AracbL+kJfv0yH86c1O8iFrgVQJafd/ZnbseTTGpYno40x/LkHUeGb
         LW7OX1cUJfydNr9yWvloui36kzfarSlcIpGtBTbk+ZoW7yDPttHGDBmOqsI0hT3sxT
         WZhp8U0pMl8DFTCCXUGTeTm7H8n3rbcw+HYP3mXo=
Subject: FAILED: patch "[PATCH] drm/amdgpu/dm/mst: Use the correct topology mgr pointer in" failed to apply to 6.0-stable tree
To:     lyude@redhat.com, Wayne.Lin@amd.com, alexander.deucher@amd.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 30 Nov 2022 18:38:00 +0100
Message-ID: <166982988016939@kroah.com>
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

dfbc00410c48 ("drm/amdgpu/dm/mst: Use the correct topology mgr pointer in amdgpu_dm_connector")
ba891436c2d2 ("drm/amdgpu/mst: Stop ignoring error codes and deadlocking")
876fcc4222e1 ("drm/amd/display: Validate DSC After Enable All New CRTCs")
47519d8224ba ("Merge tag 'amd-drm-next-6.1-2022-09-08' of https://gitlab.freedesktop.org/agd5f/linux into drm-next")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From dfbc00410c48a9896d4a65600be7137202517780 Mon Sep 17 00:00:00 2001
From: Lyude Paul <lyude@redhat.com>
Date: Mon, 14 Nov 2022 17:17:54 -0500
Subject: [PATCH] drm/amdgpu/dm/mst: Use the correct topology mgr pointer in
 amdgpu_dm_connector

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

Gitlab issue: https://gitlab.freedesktop.org/drm/amd/-/issues/2171

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: 8c20a1ed9b4f ("drm/amd/display: MST DSC compute fair share")
Cc: <stable@vger.kernel.org> # v5.6+
Reviewed-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index bba2e8aaa2c2..5196c9a0e432 100644
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

