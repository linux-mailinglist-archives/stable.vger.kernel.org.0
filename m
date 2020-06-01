Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D9A1EAC72
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbgFASgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:36:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:36996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731128AbgFASQX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:16:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0671C206E2;
        Mon,  1 Jun 2020 18:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035381;
        bh=RSyrKG42waXidXtLPSonVr1C9ikQcTRggyQfm0NWDso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MunnPJfMVa2QtxMu1B0lWY/M4OWnaHMElqUvmY79oXbBbsJ9n1p7wq8cPtCEIHlvT
         llVxHLisSXjnzIFGeGO/fGcoEfz9vKdvW3ig4jTOM6wLMkzM59BsV14xHx5V3bU3cg
         Nvi3VoDEznaeDt1mCjjbyYZJ5iTu2DnDj+GVR/XY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anthony Koo <Anthony.Koo@amd.com>,
        Lucy Li <lucy.li@amd.com>, Aric Cyr <Aric.Cyr@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 127/177] drm/amd/display: Added locking for atomic update stream and update planes
Date:   Mon,  1 Jun 2020 19:54:25 +0200
Message-Id: <20200601174059.144981771@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anthony Koo <Anthony.Koo@amd.com>

[ Upstream commit 009114f6df84150a567b05537aa29b9d660e419b ]

[Why]
Screen flickering when HDR switches between FP16 and ARGB2101010

[How]
Moved pipe_control_lock so stream update and plane update occur atomically

Signed-off-by: Anthony Koo <Anthony.Koo@amd.com>
Signed-off-by: Lucy Li <lucy.li@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c      |  87 +++++++++++----
 .../display/dc/dce110/dce110_hw_sequencer.c   |  23 +---
 .../amd/display/dc/dcn10/dcn10_hw_sequencer.c |  32 +-----
 .../amd/display/dc/dcn10/dcn10_hw_sequencer.h |   4 +
 .../gpu/drm/amd/display/dc/dcn10/dcn10_init.c |   1 +
 .../drm/amd/display/dc/dcn20/dcn20_hwseq.c    | 101 ++++++++----------
 .../drm/amd/display/dc/dcn20/dcn20_hwseq.h    |   4 -
 .../gpu/drm/amd/display/dc/dcn20/dcn20_init.c |   2 +-
 .../gpu/drm/amd/display/dc/dcn21/dcn21_init.c |   2 +-
 .../gpu/drm/amd/display/dc/inc/hw_sequencer.h |   4 +-
 10 files changed, 125 insertions(+), 135 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 2667691ba2aa..32a07665863f 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -763,6 +763,29 @@ static bool disable_all_writeback_pipes_for_stream(
 	return true;
 }
 
+void apply_ctx_interdependent_lock(struct dc *dc, struct dc_state *context, struct dc_stream_state *stream, bool lock)
+{
+	int i = 0;
+
+	/* Checks if interdependent update function pointer is NULL or not, takes care of DCE110 case */
+	if (dc->hwss.interdependent_update_lock)
+		dc->hwss.interdependent_update_lock(dc, context, lock);
+	else {
+		for (i = 0; i < dc->res_pool->pipe_count; i++) {
+			struct pipe_ctx *pipe_ctx = &context->res_ctx.pipe_ctx[i];
+			struct pipe_ctx *old_pipe_ctx = &dc->current_state->res_ctx.pipe_ctx[i];
+
+			// Copied conditions that were previously in dce110_apply_ctx_for_surface
+			if (stream == pipe_ctx->stream) {
+				if (!pipe_ctx->top_pipe &&
+					(pipe_ctx->plane_state || old_pipe_ctx->plane_state))
+					dc->hwss.pipe_control_lock(dc, pipe_ctx, lock);
+				break;
+			}
+		}
+	}
+}
+
 static void disable_dangling_plane(struct dc *dc, struct dc_state *context)
 {
 	int i, j;
@@ -788,12 +811,17 @@ static void disable_dangling_plane(struct dc *dc, struct dc_state *context)
 		if (should_disable && old_stream) {
 			dc_rem_all_planes_for_stream(dc, old_stream, dangling_context);
 			disable_all_writeback_pipes_for_stream(dc, old_stream, dangling_context);
+
 			if (dc->hwss.apply_ctx_for_surface) {
+				apply_ctx_interdependent_lock(dc, dc->current_state, old_stream, true);
 				dc->hwss.apply_ctx_for_surface(dc, old_stream, 0, dangling_context);
+				apply_ctx_interdependent_lock(dc, dc->current_state, old_stream, false);
 				dc->hwss.post_unlock_program_front_end(dc, dangling_context);
 			}
 			if (dc->hwss.program_front_end_for_ctx) {
+				dc->hwss.interdependent_update_lock(dc, dc->current_state, true);
 				dc->hwss.program_front_end_for_ctx(dc, dangling_context);
+				dc->hwss.interdependent_update_lock(dc, dc->current_state, false);
 				dc->hwss.post_unlock_program_front_end(dc, dangling_context);
 			}
 		}
@@ -1215,17 +1243,19 @@ static enum dc_status dc_commit_state_no_check(struct dc *dc, struct dc_state *c
 	/* re-program planes for existing stream, in case we need to
 	 * free up plane resource for later use
 	 */
-	if (dc->hwss.apply_ctx_for_surface)
+	if (dc->hwss.apply_ctx_for_surface) {
 		for (i = 0; i < context->stream_count; i++) {
 			if (context->streams[i]->mode_changed)
 				continue;
-
+			apply_ctx_interdependent_lock(dc, context, context->streams[i], true);
 			dc->hwss.apply_ctx_for_surface(
 				dc, context->streams[i],
 				context->stream_status[i].plane_count,
 				context); /* use new pipe config in new context */
+			apply_ctx_interdependent_lock(dc, context, context->streams[i], false);
 			dc->hwss.post_unlock_program_front_end(dc, context);
 		}
+	}
 
 	/* Program hardware */
 	for (i = 0; i < dc->res_pool->pipe_count; i++) {
@@ -1245,10 +1275,11 @@ static enum dc_status dc_commit_state_no_check(struct dc *dc, struct dc_state *c
 
 	/* Program all planes within new context*/
 	if (dc->hwss.program_front_end_for_ctx) {
+		dc->hwss.interdependent_update_lock(dc, context, true);
 		dc->hwss.program_front_end_for_ctx(dc, context);
+		dc->hwss.interdependent_update_lock(dc, context, false);
 		dc->hwss.post_unlock_program_front_end(dc, context);
 	}
-
 	for (i = 0; i < context->stream_count; i++) {
 		const struct dc_link *link = context->streams[i]->link;
 
@@ -1256,10 +1287,12 @@ static enum dc_status dc_commit_state_no_check(struct dc *dc, struct dc_state *c
 			continue;
 
 		if (dc->hwss.apply_ctx_for_surface) {
+			apply_ctx_interdependent_lock(dc, context, context->streams[i], true);
 			dc->hwss.apply_ctx_for_surface(
 					dc, context->streams[i],
 					context->stream_status[i].plane_count,
 					context);
+			apply_ctx_interdependent_lock(dc, context, context->streams[i], false);
 			dc->hwss.post_unlock_program_front_end(dc, context);
 		}
 
@@ -2112,15 +2145,10 @@ static void commit_planes_do_stream_update(struct dc *dc,
 			if (update_type == UPDATE_TYPE_FAST)
 				continue;
 
-			if (stream_update->dsc_config && dc->hwss.pipe_control_lock_global) {
-				dc->hwss.pipe_control_lock_global(dc, pipe_ctx, true);
+			if (stream_update->dsc_config)
 				dp_update_dsc_config(pipe_ctx);
-				dc->hwss.pipe_control_lock_global(dc, pipe_ctx, false);
-			}
 
 			if (stream_update->dpms_off) {
-				dc->hwss.pipe_control_lock(dc, pipe_ctx, true);
-
 				if (*stream_update->dpms_off) {
 					core_link_disable_stream(pipe_ctx);
 					/* for dpms, keep acquired resources*/
@@ -2134,8 +2162,6 @@ static void commit_planes_do_stream_update(struct dc *dc,
 
 					core_link_enable_stream(dc->current_state, pipe_ctx);
 				}
-
-				dc->hwss.pipe_control_lock(dc, pipe_ctx, false);
 			}
 
 			if (stream_update->abm_level && pipe_ctx->stream_res.abm) {
@@ -2191,6 +2217,27 @@ static void commit_planes_for_stream(struct dc *dc,
 		context_clock_trace(dc, context);
 	}
 
+	for (j = 0; j < dc->res_pool->pipe_count; j++) {
+		struct pipe_ctx *pipe_ctx = &context->res_ctx.pipe_ctx[j];
+
+		if (!pipe_ctx->top_pipe &&
+			!pipe_ctx->prev_odm_pipe &&
+			pipe_ctx->stream &&
+			pipe_ctx->stream == stream) {
+			top_pipe_to_program = pipe_ctx;
+		}
+	}
+
+	if ((update_type != UPDATE_TYPE_FAST) && dc->hwss.interdependent_update_lock)
+		dc->hwss.interdependent_update_lock(dc, context, true);
+	else
+		/* Lock the top pipe while updating plane addrs, since freesync requires
+		 *  plane addr update event triggers to be synchronized.
+		 *  top_pipe_to_program is expected to never be NULL
+		 */
+		dc->hwss.pipe_control_lock(dc, top_pipe_to_program, true);
+
+
 	// Stream updates
 	if (stream_update)
 		commit_planes_do_stream_update(dc, stream, stream_update, update_type, context);
@@ -2205,6 +2252,11 @@ static void commit_planes_for_stream(struct dc *dc,
 		if (dc->hwss.program_front_end_for_ctx)
 			dc->hwss.program_front_end_for_ctx(dc, context);
 
+		if ((update_type != UPDATE_TYPE_FAST) && dc->hwss.interdependent_update_lock)
+			dc->hwss.interdependent_update_lock(dc, context, false);
+		else
+			dc->hwss.pipe_control_lock(dc, top_pipe_to_program, false);
+
 		dc->hwss.post_unlock_program_front_end(dc, context);
 		return;
 	}
@@ -2241,8 +2293,6 @@ static void commit_planes_for_stream(struct dc *dc,
 			pipe_ctx->stream == stream) {
 			struct dc_stream_status *stream_status = NULL;
 
-			top_pipe_to_program = pipe_ctx;
-
 			if (!pipe_ctx->plane_state)
 				continue;
 
@@ -2287,12 +2337,6 @@ static void commit_planes_for_stream(struct dc *dc,
 
 	// Update Type FAST, Surface updates
 	if (update_type == UPDATE_TYPE_FAST) {
-		/* Lock the top pipe while updating plane addrs, since freesync requires
-		 *  plane addr update event triggers to be synchronized.
-		 *  top_pipe_to_program is expected to never be NULL
-		 */
-		dc->hwss.pipe_control_lock(dc, top_pipe_to_program, true);
-
 		if (dc->hwss.set_flip_control_gsl)
 			for (i = 0; i < surface_count; i++) {
 				struct dc_plane_state *plane_state = srf_updates[i].surface;
@@ -2334,9 +2378,12 @@ static void commit_planes_for_stream(struct dc *dc,
 					dc->hwss.update_plane_addr(dc, pipe_ctx);
 			}
 		}
+	}
 
+	if ((update_type != UPDATE_TYPE_FAST) && dc->hwss.interdependent_update_lock)
+		dc->hwss.interdependent_update_lock(dc, context, false);
+	else
 		dc->hwss.pipe_control_lock(dc, top_pipe_to_program, false);
-	}
 
 	if (update_type != UPDATE_TYPE_FAST)
 		dc->hwss.post_unlock_program_front_end(dc, context);
diff --git a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
index a961b94aefd9..56d4ec7bdad7 100644
--- a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
@@ -2574,17 +2574,6 @@ static void dce110_apply_ctx_for_surface(
 	if (dc->fbc_compressor)
 		dc->fbc_compressor->funcs->disable_fbc(dc->fbc_compressor);
 
-	for (i = 0; i < dc->res_pool->pipe_count; i++) {
-		struct pipe_ctx *pipe_ctx = &context->res_ctx.pipe_ctx[i];
-		struct pipe_ctx *old_pipe_ctx = &dc->current_state->res_ctx.pipe_ctx[i];
-
-		if (stream == pipe_ctx->stream) {
-			if (!pipe_ctx->top_pipe &&
-				(pipe_ctx->plane_state || old_pipe_ctx->plane_state))
-				dc->hwss.pipe_control_lock(dc, pipe_ctx, true);
-		}
-	}
-
 	for (i = 0; i < dc->res_pool->pipe_count; i++) {
 		struct pipe_ctx *pipe_ctx = &context->res_ctx.pipe_ctx[i];
 
@@ -2607,16 +2596,6 @@ static void dce110_apply_ctx_for_surface(
 
 	}
 
-	for (i = 0; i < dc->res_pool->pipe_count; i++) {
-		struct pipe_ctx *pipe_ctx = &context->res_ctx.pipe_ctx[i];
-		struct pipe_ctx *old_pipe_ctx = &dc->current_state->res_ctx.pipe_ctx[i];
-
-		if ((stream == pipe_ctx->stream) &&
-			(!pipe_ctx->top_pipe) &&
-			(pipe_ctx->plane_state || old_pipe_ctx->plane_state))
-			dc->hwss.pipe_control_lock(dc, pipe_ctx, false);
-	}
-
 	if (dc->fbc_compressor)
 		enable_fbc(dc, context);
 }
@@ -2626,6 +2605,7 @@ static void dce110_post_unlock_program_front_end(
 		struct dc_state *context)
 {
 }
+
 static void dce110_power_down_fe(struct dc *dc, struct pipe_ctx *pipe_ctx)
 {
 	struct dce_hwseq *hws = dc->hwseq;
@@ -2742,6 +2722,7 @@ static const struct hw_sequencer_funcs dce110_funcs = {
 	.disable_audio_stream = dce110_disable_audio_stream,
 	.disable_plane = dce110_power_down_fe,
 	.pipe_control_lock = dce_pipe_control_lock,
+	.interdependent_update_lock = NULL,
 	.prepare_bandwidth = dce110_prepare_bandwidth,
 	.optimize_bandwidth = dce110_optimize_bandwidth,
 	.set_drr = set_drr,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index a9a5a13d5edf..7fc559acffcd 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -82,7 +82,7 @@ void print_microsec(struct dc_context *dc_ctx,
 			us_x10 % frac);
 }
 
-static void dcn10_lock_all_pipes(struct dc *dc,
+void dcn10_lock_all_pipes(struct dc *dc,
 	struct dc_state *context,
 	bool lock)
 {
@@ -93,6 +93,7 @@ static void dcn10_lock_all_pipes(struct dc *dc,
 	for (i = 0; i < dc->res_pool->pipe_count; i++) {
 		pipe_ctx = &context->res_ctx.pipe_ctx[i];
 		tg = pipe_ctx->stream_res.tg;
+
 		/*
 		 * Only lock the top pipe's tg to prevent redundant
 		 * (un)locking. Also skip if pipe is disabled.
@@ -103,9 +104,9 @@ static void dcn10_lock_all_pipes(struct dc *dc,
 			continue;
 
 		if (lock)
-			tg->funcs->lock(tg);
+			dc->hwss.pipe_control_lock(dc, pipe_ctx, true);
 		else
-			tg->funcs->unlock(tg);
+			dc->hwss.pipe_control_lock(dc, pipe_ctx, false);
 	}
 }
 
@@ -1576,7 +1577,7 @@ void dcn10_pipe_control_lock(
 	/* use TG master update lock to lock everything on the TG
 	 * therefore only top pipe need to lock
 	 */
-	if (pipe->top_pipe)
+	if (!pipe || pipe->top_pipe)
 		return;
 
 	if (dc->debug.sanity_checks)
@@ -2530,11 +2531,6 @@ void dcn10_apply_ctx_for_surface(
 	if (underflow_check_delay_us != 0xFFFFFFFF && hws->funcs.did_underflow_occur)
 		ASSERT(hws->funcs.did_underflow_occur(dc, top_pipe_to_program));
 
-	if (interdependent_update)
-		dcn10_lock_all_pipes(dc, context, true);
-	else
-		dcn10_pipe_control_lock(dc, top_pipe_to_program, true);
-
 	if (underflow_check_delay_us != 0xFFFFFFFF)
 		udelay(underflow_check_delay_us);
 
@@ -2554,19 +2550,6 @@ void dcn10_apply_ctx_for_surface(
 
 		pipe_ctx->update_flags.raw = 0;
 
-		/*
-		 * Powergate reused pipes that are not powergated
-		 * fairly hacky right now, using opp_id as indicator
-		 * TODO: After move dc_post to dc_update, this will
-		 * be removed.
-		 */
-		if (pipe_ctx->plane_state && !old_pipe_ctx->plane_state) {
-			if (old_pipe_ctx->stream_res.tg == tg &&
-			    old_pipe_ctx->plane_res.hubp &&
-			    old_pipe_ctx->plane_res.hubp->opp_id != OPP_ID_INVALID)
-				dc->hwss.disable_plane(dc, old_pipe_ctx);
-		}
-
 		if ((!pipe_ctx->plane_state ||
 		     pipe_ctx->stream_res.tg != old_pipe_ctx->stream_res.tg) &&
 		    old_pipe_ctx->plane_state &&
@@ -2599,11 +2582,6 @@ void dcn10_apply_ctx_for_surface(
 				&pipe_ctx->dlg_regs,
 				&pipe_ctx->ttu_regs);
 		}
-
-	if (interdependent_update)
-		dcn10_lock_all_pipes(dc, context, false);
-	else
-		dcn10_pipe_control_lock(dc, top_pipe_to_program, false);
 }
 
 void dcn10_post_unlock_program_front_end(
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h
index b523f0b8dc23..16a50e05ffbf 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h
@@ -70,6 +70,10 @@ void dcn10_reset_hw_ctx_wrap(
 		struct dc *dc,
 		struct dc_state *context);
 void dcn10_disable_plane(struct dc *dc, struct pipe_ctx *pipe_ctx);
+void dcn10_lock_all_pipes(
+		struct dc *dc,
+		struct dc_state *context,
+		bool lock);
 void dcn10_apply_ctx_for_surface(
 		struct dc *dc,
 		const struct dc_stream_state *stream,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c
index 681db997a532..b88ef9703b2b 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c
@@ -50,6 +50,7 @@ static const struct hw_sequencer_funcs dcn10_funcs = {
 	.disable_audio_stream = dce110_disable_audio_stream,
 	.disable_plane = dcn10_disable_plane,
 	.pipe_control_lock = dcn10_pipe_control_lock,
+	.interdependent_update_lock = dcn10_lock_all_pipes,
 	.prepare_bandwidth = dcn10_prepare_bandwidth,
 	.optimize_bandwidth = dcn10_optimize_bandwidth,
 	.set_drr = dcn10_set_drr,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index 0c4a8c37ce84..611dac544bfe 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1088,40 +1088,18 @@ void dcn20_enable_plane(
 //	}
 }
 
-
-void dcn20_pipe_control_lock_global(
-		struct dc *dc,
-		struct pipe_ctx *pipe,
-		bool lock)
-{
-	if (lock) {
-		pipe->stream_res.tg->funcs->lock_doublebuffer_enable(
-				pipe->stream_res.tg);
-		pipe->stream_res.tg->funcs->lock(pipe->stream_res.tg);
-	} else {
-		pipe->stream_res.tg->funcs->unlock(pipe->stream_res.tg);
-		pipe->stream_res.tg->funcs->wait_for_state(pipe->stream_res.tg,
-				CRTC_STATE_VACTIVE);
-		pipe->stream_res.tg->funcs->wait_for_state(pipe->stream_res.tg,
-				CRTC_STATE_VBLANK);
-		pipe->stream_res.tg->funcs->wait_for_state(pipe->stream_res.tg,
-				CRTC_STATE_VACTIVE);
-		pipe->stream_res.tg->funcs->lock_doublebuffer_disable(
-				pipe->stream_res.tg);
-	}
-}
-
 void dcn20_pipe_control_lock(
 	struct dc *dc,
 	struct pipe_ctx *pipe,
 	bool lock)
 {
 	bool flip_immediate = false;
+	bool dig_update_required = false;
 
 	/* use TG master update lock to lock everything on the TG
 	 * therefore only top pipe need to lock
 	 */
-	if (pipe->top_pipe)
+	if (!pipe || pipe->top_pipe)
 		return;
 
 	if (pipe->plane_state != NULL)
@@ -1154,6 +1132,19 @@ void dcn20_pipe_control_lock(
 		    (!flip_immediate && pipe->stream_res.gsl_group > 0))
 			dcn20_setup_gsl_group_as_lock(dc, pipe, flip_immediate);
 
+	if (pipe->stream && pipe->stream->update_flags.bits.dsc_changed)
+		dig_update_required = true;
+
+	/* Need double buffer lock mode in order to synchronize front end pipe
+	 * updates with dig updates.
+	 */
+	if (dig_update_required) {
+		if (lock) {
+			pipe->stream_res.tg->funcs->lock_doublebuffer_enable(
+					pipe->stream_res.tg);
+		}
+	}
+
 	if (pipe->plane_state != NULL && pipe->plane_state->triplebuffer_flips) {
 		if (lock)
 			pipe->stream_res.tg->funcs->triplebuffer_lock(pipe->stream_res.tg);
@@ -1165,6 +1156,19 @@ void dcn20_pipe_control_lock(
 		else
 			pipe->stream_res.tg->funcs->unlock(pipe->stream_res.tg);
 	}
+
+	if (dig_update_required) {
+		if (!lock) {
+			pipe->stream_res.tg->funcs->wait_for_state(pipe->stream_res.tg,
+					CRTC_STATE_VACTIVE);
+			pipe->stream_res.tg->funcs->wait_for_state(pipe->stream_res.tg,
+					CRTC_STATE_VBLANK);
+			pipe->stream_res.tg->funcs->wait_for_state(pipe->stream_res.tg,
+					CRTC_STATE_VACTIVE);
+			pipe->stream_res.tg->funcs->lock_doublebuffer_disable(
+					pipe->stream_res.tg);
+		}
+	}
 }
 
 static void dcn20_detect_pipe_changes(struct pipe_ctx *old_pipe, struct pipe_ctx *new_pipe)
@@ -1536,26 +1540,28 @@ static void dcn20_program_pipe(
 	}
 }
 
-static bool does_pipe_need_lock(struct pipe_ctx *pipe)
-{
-	if ((pipe->plane_state && pipe->plane_state->update_flags.raw)
-			|| pipe->update_flags.raw)
-		return true;
-	if (pipe->bottom_pipe)
-		return does_pipe_need_lock(pipe->bottom_pipe);
-
-	return false;
-}
-
 void dcn20_program_front_end_for_ctx(
 		struct dc *dc,
 		struct dc_state *context)
 {
 	int i;
 	struct dce_hwseq *hws = dc->hwseq;
-	bool pipe_locked[MAX_PIPES] = {false};
 	DC_LOGGER_INIT(dc->ctx->logger);
 
+	for (i = 0; i < dc->res_pool->pipe_count; i++) {
+		struct pipe_ctx *pipe_ctx = &context->res_ctx.pipe_ctx[i];
+
+		if (!pipe_ctx->top_pipe && !pipe_ctx->prev_odm_pipe && pipe_ctx->plane_state) {
+			ASSERT(!pipe_ctx->plane_state->triplebuffer_flips);
+			if (dc->hwss.program_triplebuffer != NULL &&
+				!dc->debug.disable_tri_buf) {
+				/*turn off triple buffer for full update*/
+				dc->hwss.program_triplebuffer(
+					dc, pipe_ctx, pipe_ctx->plane_state->triplebuffer_flips);
+			}
+		}
+	}
+
 	/* Carry over GSL groups in case the context is changing. */
 	for (i = 0; i < dc->res_pool->pipe_count; i++)
 		if (context->res_ctx.pipe_ctx[i].stream == dc->current_state->res_ctx.pipe_ctx[i].stream)
@@ -1566,17 +1572,6 @@ void dcn20_program_front_end_for_ctx(
 	for (i = 0; i < dc->res_pool->pipe_count; i++)
 		dcn20_detect_pipe_changes(&dc->current_state->res_ctx.pipe_ctx[i],
 				&context->res_ctx.pipe_ctx[i]);
-	for (i = 0; i < dc->res_pool->pipe_count; i++)
-		if (!context->res_ctx.pipe_ctx[i].top_pipe &&
-				does_pipe_need_lock(&context->res_ctx.pipe_ctx[i])) {
-			struct pipe_ctx *pipe_ctx = &context->res_ctx.pipe_ctx[i];
-
-			if (pipe_ctx->update_flags.bits.tg_changed || pipe_ctx->update_flags.bits.enable)
-				dc->hwss.pipe_control_lock(dc, pipe_ctx, true);
-			if (!pipe_ctx->update_flags.bits.enable)
-				dc->hwss.pipe_control_lock(dc, &dc->current_state->res_ctx.pipe_ctx[i], true);
-			pipe_locked[i] = true;
-		}
 
 	/* OTG blank before disabling all front ends */
 	for (i = 0; i < dc->res_pool->pipe_count; i++)
@@ -1614,17 +1609,6 @@ void dcn20_program_front_end_for_ctx(
 				hws->funcs.program_all_writeback_pipes_in_tree(dc, pipe->stream, context);
 		}
 	}
-
-	/* Unlock all locked pipes */
-	for (i = 0; i < dc->res_pool->pipe_count; i++)
-		if (pipe_locked[i]) {
-			struct pipe_ctx *pipe_ctx = &context->res_ctx.pipe_ctx[i];
-
-			if (pipe_ctx->update_flags.bits.tg_changed || pipe_ctx->update_flags.bits.enable)
-				dc->hwss.pipe_control_lock(dc, pipe_ctx, false);
-			if (!pipe_ctx->update_flags.bits.enable)
-				dc->hwss.pipe_control_lock(dc, &dc->current_state->res_ctx.pipe_ctx[i], false);
-		}
 }
 
 void dcn20_post_unlock_program_front_end(
@@ -1664,7 +1648,6 @@ void dcn20_post_unlock_program_front_end(
 		dc->res_pool->hubbub->funcs->apply_DEDCN21_147_wa(dc->res_pool->hubbub);
 }
 
-
 void dcn20_prepare_bandwidth(
 		struct dc *dc,
 		struct dc_state *context)
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.h b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.h
index 80f192b8b3a2..63ce763f148e 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.h
@@ -61,10 +61,6 @@ void dcn20_pipe_control_lock(
 	struct dc *dc,
 	struct pipe_ctx *pipe,
 	bool lock);
-void dcn20_pipe_control_lock_global(
-		struct dc *dc,
-		struct pipe_ctx *pipe,
-		bool lock);
 void dcn20_prepare_bandwidth(
 		struct dc *dc,
 		struct dc_state *context);
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_init.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_init.c
index c0a7cf1ba3a0..1642bf546ceb 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_init.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_init.c
@@ -51,7 +51,7 @@ static const struct hw_sequencer_funcs dcn20_funcs = {
 	.disable_audio_stream = dce110_disable_audio_stream,
 	.disable_plane = dcn20_disable_plane,
 	.pipe_control_lock = dcn20_pipe_control_lock,
-	.pipe_control_lock_global = dcn20_pipe_control_lock_global,
+	.interdependent_update_lock = dcn10_lock_all_pipes,
 	.prepare_bandwidth = dcn20_prepare_bandwidth,
 	.optimize_bandwidth = dcn20_optimize_bandwidth,
 	.update_bandwidth = dcn20_update_bandwidth,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_init.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_init.c
index bb8309513964..8b91445389df 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_init.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_init.c
@@ -52,7 +52,7 @@ static const struct hw_sequencer_funcs dcn21_funcs = {
 	.disable_audio_stream = dce110_disable_audio_stream,
 	.disable_plane = dcn20_disable_plane,
 	.pipe_control_lock = dcn20_pipe_control_lock,
-	.pipe_control_lock_global = dcn20_pipe_control_lock_global,
+	.interdependent_update_lock = dcn10_lock_all_pipes,
 	.prepare_bandwidth = dcn20_prepare_bandwidth,
 	.optimize_bandwidth = dcn20_optimize_bandwidth,
 	.update_bandwidth = dcn20_update_bandwidth,
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h b/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h
index 63919866ba38..d4c1fb242c63 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h
@@ -80,10 +80,10 @@ struct hw_sequencer_funcs {
 	void (*update_pending_status)(struct pipe_ctx *pipe_ctx);
 
 	/* Pipe Lock Related */
-	void (*pipe_control_lock_global)(struct dc *dc,
-			struct pipe_ctx *pipe, bool lock);
 	void (*pipe_control_lock)(struct dc *dc,
 			struct pipe_ctx *pipe, bool lock);
+	void (*interdependent_update_lock)(struct dc *dc,
+			struct dc_state *context, bool lock);
 	void (*set_flip_control_gsl)(struct pipe_ctx *pipe_ctx,
 			bool flip_immediate);
 
-- 
2.25.1



