Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EADD56B3DFE
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 12:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbjCJLgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 06:36:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbjCJLgm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 06:36:42 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7B612CF9
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 03:36:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AFF38CE289A
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 11:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA4B8C433EF;
        Fri, 10 Mar 2023 11:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678448196;
        bh=9tGszUjEdSOpzV0M/swUF8VMOr7QS039VjuK3KUuafk=;
        h=Subject:To:Cc:From:Date:From;
        b=P43rwjPEzSRoWRfwj/kKQYW8UM8bTTxSMzCuHEy786eKIXkeHXlBJJNy+vtBt5S5N
         CetBjdZ/NKB8opEqeKMBOhnba/hl4G27dJnziUBwAX0SLYi6j85loE3Sbn6Ry4ahB9
         /QeZnihU+cxyDXNI3zQieaD39d65wl2U8BJzmDyA=
Subject: FAILED: patch "[PATCH] drm/amdgpu/display/mst: Fix mst_state->pbn_div and slot count" failed to apply to 6.1-stable tree
To:     lyude@redhat.com, alexander.deucher@amd.com,
        harry.wentland@amd.com, odyx@debian.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Mar 2023 12:36:33 +0100
Message-ID: <167844819310084@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
git checkout FETCH_HEAD
git cherry-pick -x c689e1e362ea29d10fbd9a5e94b17be991d0e231
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167844819310084@kroah.com' --subject-prefix 'PATCH 6.1.y' HEAD^..

Possible dependencies:

c689e1e362ea ("drm/amdgpu/display/mst: Fix mst_state->pbn_div and slot count assignments")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c689e1e362ea29d10fbd9a5e94b17be991d0e231 Mon Sep 17 00:00:00 2001
From: Lyude Paul <lyude@redhat.com>
Date: Wed, 23 Nov 2022 14:50:16 -0500
Subject: [PATCH] drm/amdgpu/display/mst: Fix mst_state->pbn_div and slot count
 assignments

Looks like I made a pretty big mistake here without noticing: it seems when
I moved the assignments of mst_state->pbn_div I completely missed the fact
that the reason for us calling drm_dp_mst_update_slots() earlier was to
account for the fact that we need to call this function using info from the
root MST connector, instead of just trying to do this from each MST
encoder's atomic check function. Otherwise, we end up filling out all of
DC's link information with zeroes.

So, let's restore that and hopefully fix this DSC regression.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2171
Signed-off-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Fixes: 4d07b0bc4034 ("drm/display/dp_mst: Move all payload info into the atomic state")
Cc: stable@vger.kernel.org # 6.1
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Tested-by: Didier Raboud <odyx@debian.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 39513a6d2244..2122c2be269b 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -9683,6 +9683,8 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 	struct drm_connector_state *old_con_state, *new_con_state;
 	struct drm_crtc *crtc;
 	struct drm_crtc_state *old_crtc_state, *new_crtc_state;
+	struct drm_dp_mst_topology_mgr *mgr;
+	struct drm_dp_mst_topology_state *mst_state;
 	struct drm_plane *plane;
 	struct drm_plane_state *old_plane_state, *new_plane_state;
 	enum dc_status status;
@@ -9938,6 +9940,28 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 		lock_and_validation_needed = true;
 	}
 
+#if defined(CONFIG_DRM_AMD_DC_DCN)
+	/* set the slot info for each mst_state based on the link encoding format */
+	for_each_new_mst_mgr_in_state(state, mgr, mst_state, i) {
+		struct amdgpu_dm_connector *aconnector;
+		struct drm_connector *connector;
+		struct drm_connector_list_iter iter;
+		u8 link_coding_cap;
+
+		drm_connector_list_iter_begin(dev, &iter);
+		drm_for_each_connector_iter(connector, &iter) {
+			if (connector->index == mst_state->mgr->conn_base_id) {
+				aconnector = to_amdgpu_dm_connector(connector);
+				link_coding_cap = dc_link_dp_mst_decide_link_encoding_format(aconnector->dc_link);
+				drm_dp_mst_update_slots(mst_state, link_coding_cap);
+
+				break;
+			}
+		}
+		drm_connector_list_iter_end(&iter);
+	}
+#endif
+
 	/**
 	 * Streams and planes are reset when there are changes that affect
 	 * bandwidth. Anything that affects bandwidth needs to go through
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 5fa9bab95038..e8d14ab0953a 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -927,11 +927,6 @@ static int compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
 	if (IS_ERR(mst_state))
 		return PTR_ERR(mst_state);
 
-	mst_state->pbn_div = dm_mst_get_pbn_divider(dc_link);
-#if defined(CONFIG_DRM_AMD_DC_DCN)
-	drm_dp_mst_update_slots(mst_state, dc_link_dp_mst_decide_link_encoding_format(dc_link));
-#endif
-
 	/* Set up params */
 	for (i = 0; i < dc_state->stream_count; i++) {
 		struct dc_dsc_policy dsc_policy = {0};

