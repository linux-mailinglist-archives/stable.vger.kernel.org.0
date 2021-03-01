Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CE132913B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243067AbhCAUWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:22:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:41296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243047AbhCAUNj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:13:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B38565350;
        Mon,  1 Mar 2021 18:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621709;
        bh=T0CRSaunAOQk389psJMrhUD64d8MIJ+Mw25FRpR7/pE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1jPtaKddnu2GoK/SavnDliTDY//ehly0sDotMeP2uHv4ZC9r9ApU96UjVBumjj0e4
         SSVZu5rUmZRMWEnb9Jzv/M0FQZA2IglLp5FIPeUnc+C9K1kqFAQYBv/ADVNrGK2ZAZ
         pYiMxLOVrddpizHhy8gg8NmER+gwteih1avE5yvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anson Jacob <Anson.Jacob@amd.com>,
        Bhawanpreet Lakha <bhawanpreet.lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.11 615/775] Revert "drm/amd/display: reuse current context instead of recreating one"
Date:   Mon,  1 Mar 2021 17:13:03 +0100
Message-Id: <20210301161231.793645371@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Jacob <Anson.Jacob@amd.com>

commit efc8278eecfd5e6fa36c5d41e71d038f534fe107 upstream.

This reverts commit 8866a67ab86cc0812e65c04f1ef02bcc41e24d68.

Reason for revert: This breaks hotplug of HDMI on some systems,
resulting in a blank screen. Caused general hangs on boot/hotplugs.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1487
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1492
Bug: https://bugzilla.kernel.org/show_bug.cgi?id=211649
Signed-off-by: Anson Jacob <Anson.Jacob@amd.com>
Reviewed-by: Bhawanpreet Lakha <bhawanpreet.lakha@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   23 ++++++++++--------
 drivers/gpu/drm/amd/display/dc/core/dc.c          |   27 ++++++----------------
 drivers/gpu/drm/amd/display/dc/dc_stream.h        |    3 +-
 3 files changed, 23 insertions(+), 30 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1934,7 +1934,7 @@ static void dm_gpureset_commit_state(str
 		dc_commit_updates_for_stream(
 			dm->dc, bundle->surface_updates,
 			dc_state->stream_status->plane_count,
-			dc_state->streams[k], &bundle->stream_update);
+			dc_state->streams[k], &bundle->stream_update, dc_state);
 	}
 
 cleanup:
@@ -1965,7 +1965,8 @@ static void dm_set_dpms_off(struct dc_li
 
 	stream_update.stream = stream_state;
 	dc_commit_updates_for_stream(stream_state->ctx->dc, NULL, 0,
-				     stream_state, &stream_update);
+				     stream_state, &stream_update,
+				     stream_state->ctx->dc->current_state);
 	mutex_unlock(&adev->dm.dc_lock);
 }
 
@@ -7548,7 +7549,7 @@ static void amdgpu_dm_commit_planes(stru
 				    struct drm_crtc *pcrtc,
 				    bool wait_for_vblank)
 {
-	int i;
+	uint32_t i;
 	uint64_t timestamp_ns;
 	struct drm_plane *plane;
 	struct drm_plane_state *old_plane_state, *new_plane_state;
@@ -7589,7 +7590,7 @@ static void amdgpu_dm_commit_planes(stru
 		amdgpu_dm_commit_cursors(state);
 
 	/* update planes when needed */
-	for_each_oldnew_plane_in_state_reverse(state, plane, old_plane_state, new_plane_state, i) {
+	for_each_oldnew_plane_in_state(state, plane, old_plane_state, new_plane_state, i) {
 		struct drm_crtc *crtc = new_plane_state->crtc;
 		struct drm_crtc_state *new_crtc_state;
 		struct drm_framebuffer *fb = new_plane_state->fb;
@@ -7812,7 +7813,8 @@ static void amdgpu_dm_commit_planes(stru
 						     bundle->surface_updates,
 						     planes_count,
 						     acrtc_state->stream,
-						     &bundle->stream_update);
+						     &bundle->stream_update,
+						     dc_state);
 
 		/**
 		 * Enable or disable the interrupts on the backend.
@@ -8148,13 +8150,13 @@ static void amdgpu_dm_atomic_commit_tail
 		struct dm_connector_state *dm_new_con_state = to_dm_connector_state(new_con_state);
 		struct dm_connector_state *dm_old_con_state = to_dm_connector_state(old_con_state);
 		struct amdgpu_crtc *acrtc = to_amdgpu_crtc(dm_new_con_state->base.crtc);
-		struct dc_surface_update surface_updates[MAX_SURFACES];
+		struct dc_surface_update dummy_updates[MAX_SURFACES];
 		struct dc_stream_update stream_update;
 		struct dc_info_packet hdr_packet;
 		struct dc_stream_status *status = NULL;
 		bool abm_changed, hdr_changed, scaling_changed;
 
-		memset(&surface_updates, 0, sizeof(surface_updates));
+		memset(&dummy_updates, 0, sizeof(dummy_updates));
 		memset(&stream_update, 0, sizeof(stream_update));
 
 		if (acrtc) {
@@ -8211,15 +8213,16 @@ static void amdgpu_dm_atomic_commit_tail
 		 * To fix this, DC should permit updating only stream properties.
 		 */
 		for (j = 0; j < status->plane_count; j++)
-			surface_updates[j].surface = status->plane_states[j];
+			dummy_updates[j].surface = status->plane_states[0];
 
 
 		mutex_lock(&dm->dc_lock);
 		dc_commit_updates_for_stream(dm->dc,
-						surface_updates,
+						     dummy_updates,
 						     status->plane_count,
 						     dm_new_crtc_state->stream,
-						     &stream_update);
+						     &stream_update,
+						     dc_state);
 		mutex_unlock(&dm->dc_lock);
 	}
 
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2679,7 +2679,8 @@ void dc_commit_updates_for_stream(struct
 		struct dc_surface_update *srf_updates,
 		int surface_count,
 		struct dc_stream_state *stream,
-		struct dc_stream_update *stream_update)
+		struct dc_stream_update *stream_update,
+		struct dc_state *state)
 {
 	const struct dc_stream_status *stream_status;
 	enum surface_update_type update_type;
@@ -2698,12 +2699,6 @@ void dc_commit_updates_for_stream(struct
 
 
 	if (update_type >= UPDATE_TYPE_FULL) {
-		struct dc_plane_state *new_planes[MAX_SURFACES];
-
-		memset(new_planes, 0, sizeof(new_planes));
-
-		for (i = 0; i < surface_count; i++)
-			new_planes[i] = srf_updates[i].surface;
 
 		/* initialize scratch memory for building context */
 		context = dc_create_state(dc);
@@ -2712,21 +2707,15 @@ void dc_commit_updates_for_stream(struct
 			return;
 		}
 
-		dc_resource_state_copy_construct(
-				dc->current_state, context);
+		dc_resource_state_copy_construct(state, context);
 
-		/*remove old surfaces from context */
-		if (!dc_rem_all_planes_for_stream(dc, stream, context)) {
-			DC_ERROR("Failed to remove streams for new validate context!\n");
-			return;
-		}
+		for (i = 0; i < dc->res_pool->pipe_count; i++) {
+			struct pipe_ctx *new_pipe = &context->res_ctx.pipe_ctx[i];
+			struct pipe_ctx *old_pipe = &dc->current_state->res_ctx.pipe_ctx[i];
 
-		/* add surface to context */
-		if (!dc_add_all_planes_for_stream(dc, stream, new_planes, surface_count, context)) {
-			DC_ERROR("Failed to add streams for new validate context!\n");
-			return;
+			if (new_pipe->plane_state && new_pipe->plane_state != old_pipe->plane_state)
+				new_pipe->plane_state->force_full_update = true;
 		}
-
 	}
 
 
--- a/drivers/gpu/drm/amd/display/dc/dc_stream.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_stream.h
@@ -283,7 +283,8 @@ void dc_commit_updates_for_stream(struct
 		struct dc_surface_update *srf_updates,
 		int surface_count,
 		struct dc_stream_state *stream,
-		struct dc_stream_update *stream_update);
+		struct dc_stream_update *stream_update,
+		struct dc_state *state);
 /*
  * Log the current stream state.
  */


