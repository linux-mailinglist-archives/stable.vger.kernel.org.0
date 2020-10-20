Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64F3291EB6
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730388AbgJRTyl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:54:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728795AbgJRTUW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:20:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72872222EA;
        Sun, 18 Oct 2020 19:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048821;
        bh=upg59azAPWroDcY4JtWyc8IG+Ta079sqAoCtyX2Q9Eo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kAeJESx+1gYIJat729JX3LHfXvs0FRqyDWgDCHil3QRJ4qEjFyElJ5QkWShCJZpng
         io+31qz7bwALEHTgHLeyjUxJCHYDFkDqex2rNIj2lg0+eh63pQUKEe+4BG4bbnIQSg
         MlkXQsBVG7AHa07+5h9V+GKYtN3fFbgT7snFRgbA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alvin Lee <alvin.lee2@amd.com>, Aric Cyr <Aric.Cyr@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.9 109/111] drm/amd/display: Disconnect pipe separetely when disable pipe split
Date:   Sun, 18 Oct 2020 15:18:05 -0400
Message-Id: <20201018191807.4052726-109-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018191807.4052726-1-sashal@kernel.org>
References: <20201018191807.4052726-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alvin Lee <alvin.lee2@amd.com>

[ Upstream commit 81b437f57e35a6caa3a4304e6fff0eba0a9f3266 ]

[Why]
When changing pixel formats for HDR (e.g. ARGB -> FP16)
there are configurations that change from 2 pipes to 1 pipe.
In these cases, it seems that disconnecting MPCC and doing
a surface update at the same time(after unlocking) causes
some registers to be updated slightly faster than others
after unlocking (e.g. if the pixel format is updated to FP16
before the new surface address is programmed, we get
corruption on the screen because the pixel formats aren't
matching). We separate disconnecting MPCC from the rest
of  the  pipe programming sequence to prevent this.

[How]
Move MPCC disconnect into separate operation than the
rest of the pipe programming.

Signed-off-by: Alvin Lee <alvin.lee2@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c      |  10 ++
 .../amd/display/dc/dcn10/dcn10_hw_sequencer.c | 146 ++++++++++++++++++
 .../amd/display/dc/dcn10/dcn10_hw_sequencer.h |   6 +
 .../gpu/drm/amd/display/dc/dcn10/dcn10_init.c |   2 +
 .../gpu/drm/amd/display/dc/dcn20/dcn20_init.c |   2 +
 .../gpu/drm/amd/display/dc/dcn21/dcn21_init.c |   2 +
 .../gpu/drm/amd/display/dc/dcn30/dcn30_init.c |   2 +
 .../gpu/drm/amd/display/dc/inc/hw_sequencer.h |   4 +
 8 files changed, 174 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 22cbfda6ab338..95ec8ae5a7739 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2295,6 +2295,7 @@ static void commit_planes_for_stream(struct dc *dc,
 		enum surface_update_type update_type,
 		struct dc_state *context)
 {
+	bool mpcc_disconnected = false;
 	int i, j;
 	struct pipe_ctx *top_pipe_to_program = NULL;
 
@@ -2325,6 +2326,15 @@ static void commit_planes_for_stream(struct dc *dc,
 		context_clock_trace(dc, context);
 	}
 
+	if (update_type != UPDATE_TYPE_FAST && dc->hwss.interdependent_update_lock &&
+		dc->hwss.disconnect_pipes && dc->hwss.wait_for_pending_cleared){
+		dc->hwss.interdependent_update_lock(dc, context, true);
+		mpcc_disconnected = dc->hwss.disconnect_pipes(dc, context);
+		dc->hwss.interdependent_update_lock(dc, context, false);
+		if (mpcc_disconnected)
+			dc->hwss.wait_for_pending_cleared(dc, context);
+	}
+
 	for (j = 0; j < dc->res_pool->pipe_count; j++) {
 		struct pipe_ctx *pipe_ctx = &context->res_ctx.pipe_ctx[j];
 
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index fa643ec5a8760..4bbfd8a26a606 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -2769,6 +2769,152 @@ static struct pipe_ctx *dcn10_find_top_pipe_for_stream(
 	return NULL;
 }
 
+bool dcn10_disconnect_pipes(
+		struct dc *dc,
+		struct dc_state *context)
+{
+		bool found_stream = false;
+		int i, j;
+		struct dce_hwseq *hws = dc->hwseq;
+		struct dc_state *old_ctx = dc->current_state;
+		bool mpcc_disconnected = false;
+		struct pipe_ctx *old_pipe;
+		struct pipe_ctx *new_pipe;
+		DC_LOGGER_INIT(dc->ctx->logger);
+
+		/* Set pipe update flags and lock pipes */
+		for (i = 0; i < dc->res_pool->pipe_count; i++) {
+			old_pipe = &dc->current_state->res_ctx.pipe_ctx[i];
+			new_pipe = &context->res_ctx.pipe_ctx[i];
+			new_pipe->update_flags.raw = 0;
+
+			if (!old_pipe->plane_state && !new_pipe->plane_state)
+				continue;
+
+			if (old_pipe->plane_state && !new_pipe->plane_state)
+				new_pipe->update_flags.bits.disable = 1;
+
+			/* Check for scl update */
+			if (memcmp(&old_pipe->plane_res.scl_data, &new_pipe->plane_res.scl_data, sizeof(struct scaler_data)))
+					new_pipe->update_flags.bits.scaler = 1;
+
+			/* Check for vp update */
+			if (memcmp(&old_pipe->plane_res.scl_data.viewport, &new_pipe->plane_res.scl_data.viewport, sizeof(struct rect))
+					|| memcmp(&old_pipe->plane_res.scl_data.viewport_c,
+						&new_pipe->plane_res.scl_data.viewport_c, sizeof(struct rect)))
+				new_pipe->update_flags.bits.viewport = 1;
+
+		}
+
+		if (!IS_DIAG_DC(dc->ctx->dce_environment)) {
+			/* Disconnect mpcc here only if losing pipe split*/
+			for (i = 0; i < dc->res_pool->pipe_count; i++) {
+				if (context->res_ctx.pipe_ctx[i].update_flags.bits.disable &&
+					old_ctx->res_ctx.pipe_ctx[i].top_pipe) {
+
+					/* Find the top pipe in the new ctx for the bottom pipe that we
+					 * want to remove by comparing the streams. If both pipes are being
+					 * disabled then do it in the regular pipe programming sequence
+					 */
+					for (j = 0; j < dc->res_pool->pipe_count; j++) {
+						if (old_ctx->res_ctx.pipe_ctx[i].top_pipe->stream == context->res_ctx.pipe_ctx[j].stream &&
+							!context->res_ctx.pipe_ctx[j].top_pipe &&
+							!context->res_ctx.pipe_ctx[j].update_flags.bits.disable) {
+							found_stream = true;
+							break;
+						}
+					}
+
+					// Disconnect if the top pipe lost it's pipe split
+					if (found_stream && !context->res_ctx.pipe_ctx[j].bottom_pipe) {
+						hws->funcs.plane_atomic_disconnect(dc, &dc->current_state->res_ctx.pipe_ctx[i]);
+						DC_LOG_DC("Reset mpcc for pipe %d\n", dc->current_state->res_ctx.pipe_ctx[i].pipe_idx);
+						mpcc_disconnected = true;
+					}
+				}
+				found_stream = false;
+			}
+		}
+
+		if (mpcc_disconnected) {
+			for (i = 0; i < dc->res_pool->pipe_count; i++) {
+				struct pipe_ctx *pipe_ctx = &context->res_ctx.pipe_ctx[i];
+				struct pipe_ctx *old_pipe = &dc->current_state->res_ctx.pipe_ctx[i];
+				struct dc_plane_state *plane_state = pipe_ctx->plane_state;
+				struct hubp *hubp = pipe_ctx->plane_res.hubp;
+
+				if (!pipe_ctx || !plane_state || !pipe_ctx->stream)
+					continue;
+
+				// Only update scaler and viewport here if we lose a pipe split.
+				// This is to prevent half the screen from being black when we
+				// unlock after disconnecting MPCC.
+				if (!(old_pipe && !pipe_ctx->top_pipe &&
+					!pipe_ctx->bottom_pipe && old_pipe->bottom_pipe))
+					continue;
+
+				if (pipe_ctx->update_flags.raw || pipe_ctx->plane_state->update_flags.raw || pipe_ctx->stream->update_flags.raw) {
+					if (pipe_ctx->update_flags.bits.scaler ||
+						plane_state->update_flags.bits.scaling_change ||
+						plane_state->update_flags.bits.position_change ||
+						plane_state->update_flags.bits.per_pixel_alpha_change ||
+						pipe_ctx->stream->update_flags.bits.scaling) {
+
+						pipe_ctx->plane_res.scl_data.lb_params.alpha_en = pipe_ctx->plane_state->per_pixel_alpha;
+						ASSERT(pipe_ctx->plane_res.scl_data.lb_params.depth == LB_PIXEL_DEPTH_30BPP);
+						/* scaler configuration */
+						pipe_ctx->plane_res.dpp->funcs->dpp_set_scaler(
+						pipe_ctx->plane_res.dpp, &pipe_ctx->plane_res.scl_data);
+					}
+
+					if (pipe_ctx->update_flags.bits.viewport ||
+						(context == dc->current_state && plane_state->update_flags.bits.position_change) ||
+						(context == dc->current_state && plane_state->update_flags.bits.scaling_change) ||
+						(context == dc->current_state && pipe_ctx->stream->update_flags.bits.scaling)) {
+
+						hubp->funcs->mem_program_viewport(
+							hubp,
+							&pipe_ctx->plane_res.scl_data.viewport,
+							&pipe_ctx->plane_res.scl_data.viewport_c);
+					}
+				}
+			}
+		}
+	return mpcc_disconnected;
+}
+
+void dcn10_wait_for_pending_cleared(struct dc *dc,
+		struct dc_state *context)
+{
+		struct pipe_ctx *pipe_ctx;
+		struct timing_generator *tg;
+		int i;
+
+		for (i = 0; i < dc->res_pool->pipe_count; i++) {
+			pipe_ctx = &context->res_ctx.pipe_ctx[i];
+			tg = pipe_ctx->stream_res.tg;
+
+			/*
+			 * Only wait for top pipe's tg penindg bit
+			 * Also skip if pipe is disabled.
+			 */
+			if (pipe_ctx->top_pipe ||
+			    !pipe_ctx->stream || !pipe_ctx->plane_state ||
+			    !tg->funcs->is_tg_enabled(tg))
+				continue;
+
+			/*
+			 * Wait for VBLANK then VACTIVE to ensure we get VUPDATE.
+			 * For some reason waiting for OTG_UPDATE_PENDING cleared
+			 * seems to not trigger the update right away, and if we
+			 * lock again before VUPDATE then we don't get a separated
+			 * operation.
+			 */
+			pipe_ctx->stream_res.tg->funcs->wait_for_state(pipe_ctx->stream_res.tg, CRTC_STATE_VBLANK);
+			pipe_ctx->stream_res.tg->funcs->wait_for_state(pipe_ctx->stream_res.tg, CRTC_STATE_VACTIVE);
+		}
+}
+
 void dcn10_apply_ctx_for_surface(
 		struct dc *dc,
 		const struct dc_stream_state *stream,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h
index 6d891166da8a4..e5691e4990231 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h
@@ -194,6 +194,12 @@ void dcn10_get_surface_visual_confirm_color(
 void dcn10_get_hdr_visual_confirm_color(
 		struct pipe_ctx *pipe_ctx,
 		struct tg_color *color);
+bool dcn10_disconnect_pipes(
+		struct dc *dc,
+		struct dc_state *context);
+
+void dcn10_wait_for_pending_cleared(struct dc *dc,
+		struct dc_state *context);
 void dcn10_set_hdr_multiplier(struct pipe_ctx *pipe_ctx);
 void dcn10_verify_allow_pstate_change_high(struct dc *dc);
 
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c
index 5c98b71c1d47a..a1d1559bb5d73 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c
@@ -34,6 +34,8 @@ static const struct hw_sequencer_funcs dcn10_funcs = {
 	.apply_ctx_to_hw = dce110_apply_ctx_to_hw,
 	.apply_ctx_for_surface = dcn10_apply_ctx_for_surface,
 	.post_unlock_program_front_end = dcn10_post_unlock_program_front_end,
+	.disconnect_pipes = dcn10_disconnect_pipes,
+	.wait_for_pending_cleared = dcn10_wait_for_pending_cleared,
 	.update_plane_addr = dcn10_update_plane_addr,
 	.update_dchub = dcn10_update_dchub,
 	.update_pending_status = dcn10_update_pending_status,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_init.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_init.c
index 3dde6f26de474..966e1790b9bfd 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_init.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_init.c
@@ -34,6 +34,8 @@ static const struct hw_sequencer_funcs dcn20_funcs = {
 	.apply_ctx_to_hw = dce110_apply_ctx_to_hw,
 	.apply_ctx_for_surface = NULL,
 	.program_front_end_for_ctx = dcn20_program_front_end_for_ctx,
+	.disconnect_pipes = dcn10_disconnect_pipes,
+	.wait_for_pending_cleared = dcn10_wait_for_pending_cleared,
 	.post_unlock_program_front_end = dcn20_post_unlock_program_front_end,
 	.update_plane_addr = dcn20_update_plane_addr,
 	.update_dchub = dcn10_update_dchub,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_init.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_init.c
index b187f71afa652..2ba880c3943c3 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_init.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_init.c
@@ -35,6 +35,8 @@ static const struct hw_sequencer_funcs dcn21_funcs = {
 	.apply_ctx_to_hw = dce110_apply_ctx_to_hw,
 	.apply_ctx_for_surface = NULL,
 	.program_front_end_for_ctx = dcn20_program_front_end_for_ctx,
+	.disconnect_pipes = dcn10_disconnect_pipes,
+	.wait_for_pending_cleared = dcn10_wait_for_pending_cleared,
 	.post_unlock_program_front_end = dcn20_post_unlock_program_front_end,
 	.update_plane_addr = dcn20_update_plane_addr,
 	.update_dchub = dcn10_update_dchub,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_init.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_init.c
index 9afee71604902..19daa456e3bfe 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_init.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_init.c
@@ -35,6 +35,8 @@ static const struct hw_sequencer_funcs dcn30_funcs = {
 	.apply_ctx_to_hw = dce110_apply_ctx_to_hw,
 	.apply_ctx_for_surface = NULL,
 	.program_front_end_for_ctx = dcn20_program_front_end_for_ctx,
+	.disconnect_pipes = dcn10_disconnect_pipes,
+	.wait_for_pending_cleared = dcn10_wait_for_pending_cleared,
 	.post_unlock_program_front_end = dcn20_post_unlock_program_front_end,
 	.update_plane_addr = dcn20_update_plane_addr,
 	.update_dchub = dcn10_update_dchub,
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h b/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h
index 3c986717dcd56..64c1be818b0e8 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h
@@ -67,6 +67,10 @@ struct hw_sequencer_funcs {
 			int num_planes, struct dc_state *context);
 	void (*program_front_end_for_ctx)(struct dc *dc,
 			struct dc_state *context);
+	bool (*disconnect_pipes)(struct dc *dc,
+			struct dc_state *context);
+	void (*wait_for_pending_cleared)(struct dc *dc,
+			struct dc_state *context);
 	void (*post_unlock_program_front_end)(struct dc *dc,
 			struct dc_state *context);
 	void (*update_plane_addr)(const struct dc *dc,
-- 
2.25.1

