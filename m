Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D01881EAC2B
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731089AbgFASQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:16:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:36704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731652AbgFASQH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:16:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4470520897;
        Mon,  1 Jun 2020 18:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035365;
        bh=e1rPACQRcvomph7tDY65JDtsKRARRbqwl98H+xVzn2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YgmgPFxCmBOuR00FUJ/5C8rliVPL8jYbE9KRWj2YmjApuIc0WcYDy6432psWuVKSj
         n9m6p0RcNJF9w0N9Q18XylgV5102WWlugHSR+CHHU+EzhdxlGB/yFLr0cg9F2wi39U
         gy7/pcH2Q2wYzfMIOKqVSkn3sySwGkINrRL6BhWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anthony Koo <Anthony.Koo@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 125/177] drm/amd/display: Split program front end part that occur outside lock
Date:   Mon,  1 Jun 2020 19:54:23 +0200
Message-Id: <20200601174058.997108675@linuxfoundation.org>
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

[ Upstream commit bbf5f6c3f83bedd71006473849138a446ad4d9a3 ]

[Why]
Eventually want to lock at a higher level in stack.
To do this, we need to be able to isolate the parts that need to be done
after pipe unlock.

[How]
Split out programming that is done post unlock.

Signed-off-by: Anthony Koo <Anthony.Koo@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c      | 24 +++++++++---
 .../display/dc/dce110/dce110_hw_sequencer.c   |  6 +++
 .../amd/display/dc/dcn10/dcn10_hw_sequencer.c | 39 ++++++++++++++++---
 .../amd/display/dc/dcn10/dcn10_hw_sequencer.h |  3 ++
 .../gpu/drm/amd/display/dc/dcn10/dcn10_init.c |  1 +
 .../drm/amd/display/dc/dcn20/dcn20_hwseq.c    | 11 +++++-
 .../drm/amd/display/dc/dcn20/dcn20_hwseq.h    |  3 ++
 .../gpu/drm/amd/display/dc/dcn20/dcn20_init.c |  1 +
 .../gpu/drm/amd/display/dc/dcn21/dcn21_init.c |  1 +
 .../gpu/drm/amd/display/dc/inc/hw_sequencer.h |  2 +
 10 files changed, 79 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index b3987124183a..66be2920fab0 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -788,11 +788,15 @@ static void disable_dangling_plane(struct dc *dc, struct dc_state *context)
 		if (should_disable && old_stream) {
 			dc_rem_all_planes_for_stream(dc, old_stream, dangling_context);
 			disable_all_writeback_pipes_for_stream(dc, old_stream, dangling_context);
-			if (dc->hwss.apply_ctx_for_surface)
+			if (dc->hwss.apply_ctx_for_surface) {
 				dc->hwss.apply_ctx_for_surface(dc, old_stream, 0, dangling_context);
+				dc->hwss.post_unlock_program_front_end(dc, dangling_context);
+			}
+			if (dc->hwss.program_front_end_for_ctx) {
+				dc->hwss.program_front_end_for_ctx(dc, dangling_context);
+				dc->hwss.post_unlock_program_front_end(dc, dangling_context);
+			}
 		}
-		if (dc->hwss.program_front_end_for_ctx)
-			dc->hwss.program_front_end_for_ctx(dc, dangling_context);
 	}
 
 	current_ctx = dc->current_state;
@@ -1220,6 +1224,7 @@ static enum dc_status dc_commit_state_no_check(struct dc *dc, struct dc_state *c
 				dc, context->streams[i],
 				context->stream_status[i].plane_count,
 				context); /* use new pipe config in new context */
+			dc->hwss.post_unlock_program_front_end(dc, context);
 		}
 
 	/* Program hardware */
@@ -1239,19 +1244,24 @@ static enum dc_status dc_commit_state_no_check(struct dc *dc, struct dc_state *c
 	}
 
 	/* Program all planes within new context*/
-	if (dc->hwss.program_front_end_for_ctx)
+	if (dc->hwss.program_front_end_for_ctx) {
 		dc->hwss.program_front_end_for_ctx(dc, context);
+		dc->hwss.post_unlock_program_front_end(dc, context);
+	}
+
 	for (i = 0; i < context->stream_count; i++) {
 		const struct dc_link *link = context->streams[i]->link;
 
 		if (!context->streams[i]->mode_changed)
 			continue;
 
-		if (dc->hwss.apply_ctx_for_surface)
+		if (dc->hwss.apply_ctx_for_surface) {
 			dc->hwss.apply_ctx_for_surface(
 					dc, context->streams[i],
 					context->stream_status[i].plane_count,
 					context);
+			dc->hwss.post_unlock_program_front_end(dc, context);
+		}
 
 		/*
 		 * enable stereo
@@ -2190,6 +2200,7 @@ static void commit_planes_for_stream(struct dc *dc,
 		if (dc->hwss.program_front_end_for_ctx)
 			dc->hwss.program_front_end_for_ctx(dc, context);
 
+		dc->hwss.post_unlock_program_front_end(dc, context);
 		return;
 	}
 
@@ -2322,6 +2333,9 @@ static void commit_planes_for_stream(struct dc *dc,
 		dc->hwss.pipe_control_lock(dc, top_pipe_to_program, false);
 	}
 
+	if (update_type != UPDATE_TYPE_FAST)
+		dc->hwss.post_unlock_program_front_end(dc, context);
+
 	// Fire manual trigger only when bottom plane is flipped
 	for (j = 0; j < dc->res_pool->pipe_count; j++) {
 		struct pipe_ctx *pipe_ctx = &context->res_ctx.pipe_ctx[j];
diff --git a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
index 5b689273ff44..a961b94aefd9 100644
--- a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
@@ -2621,6 +2621,11 @@ static void dce110_apply_ctx_for_surface(
 		enable_fbc(dc, context);
 }
 
+static void dce110_post_unlock_program_front_end(
+		struct dc *dc,
+		struct dc_state *context)
+{
+}
 static void dce110_power_down_fe(struct dc *dc, struct pipe_ctx *pipe_ctx)
 {
 	struct dce_hwseq *hws = dc->hwseq;
@@ -2722,6 +2727,7 @@ static const struct hw_sequencer_funcs dce110_funcs = {
 	.init_hw = init_hw,
 	.apply_ctx_to_hw = dce110_apply_ctx_to_hw,
 	.apply_ctx_for_surface = dce110_apply_ctx_for_surface,
+	.post_unlock_program_front_end = dce110_post_unlock_program_front_end,
 	.update_plane_addr = update_plane_addr,
 	.update_pending_status = dce110_update_pending_status,
 	.enable_accelerated_mode = dce110_enable_accelerated_mode,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index 1008ac8a0f2a..a9a5a13d5edf 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -2512,7 +2512,6 @@ void dcn10_apply_ctx_for_surface(
 	int i;
 	struct timing_generator *tg;
 	uint32_t underflow_check_delay_us;
-	bool removed_pipe[4] = { false };
 	bool interdependent_update = false;
 	struct pipe_ctx *top_pipe_to_program =
 			dcn10_find_top_pipe_for_stream(dc, context, stream);
@@ -2552,6 +2551,9 @@ void dcn10_apply_ctx_for_surface(
 		struct pipe_ctx *pipe_ctx = &context->res_ctx.pipe_ctx[i];
 		struct pipe_ctx *old_pipe_ctx =
 				&dc->current_state->res_ctx.pipe_ctx[i];
+
+		pipe_ctx->update_flags.raw = 0;
+
 		/*
 		 * Powergate reused pipes that are not powergated
 		 * fairly hacky right now, using opp_id as indicator
@@ -2571,7 +2573,7 @@ void dcn10_apply_ctx_for_surface(
 		    old_pipe_ctx->stream_res.tg == tg) {
 
 			hws->funcs.plane_atomic_disconnect(dc, old_pipe_ctx);
-			removed_pipe[i] = true;
+			pipe_ctx->update_flags.bits.disable = 1;
 
 			DC_LOG_DC("Reset mpcc for pipe %d\n",
 					old_pipe_ctx->pipe_idx);
@@ -2602,16 +2604,41 @@ void dcn10_apply_ctx_for_surface(
 		dcn10_lock_all_pipes(dc, context, false);
 	else
 		dcn10_pipe_control_lock(dc, top_pipe_to_program, false);
+}
+
+void dcn10_post_unlock_program_front_end(
+		struct dc *dc,
+		struct dc_state *context)
+{
+	int i, j;
+
+	DC_LOGGER_INIT(dc->ctx->logger);
 
-	if (num_planes == 0)
-		false_optc_underflow_wa(dc, stream, tg);
+	for (i = 0; i < dc->res_pool->pipe_count; i++) {
+		struct pipe_ctx *pipe_ctx = &context->res_ctx.pipe_ctx[i];
+
+		if (!pipe_ctx->top_pipe &&
+			!pipe_ctx->prev_odm_pipe &&
+			pipe_ctx->stream) {
+			struct dc_stream_status *stream_status = NULL;
+			struct timing_generator *tg = pipe_ctx->stream_res.tg;
+
+			for (j = 0; j < context->stream_count; j++) {
+				if (pipe_ctx->stream == context->streams[j])
+					stream_status = &context->stream_status[j];
+			}
+
+			if (context->stream_status[i].plane_count == 0)
+				false_optc_underflow_wa(dc, pipe_ctx->stream, tg);
+		}
+	}
 
 	for (i = 0; i < dc->res_pool->pipe_count; i++)
-		if (removed_pipe[i])
+		if (context->res_ctx.pipe_ctx[i].update_flags.bits.disable)
 			dc->hwss.disable_plane(dc, &dc->current_state->res_ctx.pipe_ctx[i]);
 
 	for (i = 0; i < dc->res_pool->pipe_count; i++)
-		if (removed_pipe[i]) {
+		if (context->res_ctx.pipe_ctx[i].update_flags.bits.disable) {
 			dc->hwss.optimize_bandwidth(dc, context);
 			break;
 		}
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h
index 4d20f6586bb5..b523f0b8dc23 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h
@@ -75,6 +75,9 @@ void dcn10_apply_ctx_for_surface(
 		const struct dc_stream_state *stream,
 		int num_planes,
 		struct dc_state *context);
+void dcn10_post_unlock_program_front_end(
+		struct dc *dc,
+		struct dc_state *context);
 void dcn10_hubp_pg_control(
 		struct dce_hwseq *hws,
 		unsigned int hubp_inst,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c
index e7e5352ec424..681db997a532 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c
@@ -32,6 +32,7 @@ static const struct hw_sequencer_funcs dcn10_funcs = {
 	.init_hw = dcn10_init_hw,
 	.apply_ctx_to_hw = dce110_apply_ctx_to_hw,
 	.apply_ctx_for_surface = dcn10_apply_ctx_for_surface,
+	.post_unlock_program_front_end = dcn10_post_unlock_program_front_end,
 	.update_plane_addr = dcn10_update_plane_addr,
 	.update_dchub = dcn10_update_dchub,
 	.update_pending_status = dcn10_update_pending_status,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index ad422e00f9fe..0c4a8c37ce84 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1551,7 +1551,6 @@ void dcn20_program_front_end_for_ctx(
 		struct dc *dc,
 		struct dc_state *context)
 {
-	const unsigned int TIMEOUT_FOR_PIPE_ENABLE_MS = 100;
 	int i;
 	struct dce_hwseq *hws = dc->hwseq;
 	bool pipe_locked[MAX_PIPES] = {false};
@@ -1626,6 +1625,16 @@ void dcn20_program_front_end_for_ctx(
 			if (!pipe_ctx->update_flags.bits.enable)
 				dc->hwss.pipe_control_lock(dc, &dc->current_state->res_ctx.pipe_ctx[i], false);
 		}
+}
+
+void dcn20_post_unlock_program_front_end(
+		struct dc *dc,
+		struct dc_state *context)
+{
+	int i;
+	const unsigned int TIMEOUT_FOR_PIPE_ENABLE_MS = 100;
+
+	DC_LOGGER_INIT(dc->ctx->logger);
 
 	for (i = 0; i < dc->res_pool->pipe_count; i++)
 		if (context->res_ctx.pipe_ctx[i].update_flags.bits.disable)
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.h b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.h
index 02c9be5ebd47..80f192b8b3a2 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.h
@@ -35,6 +35,9 @@ bool dcn20_set_shaper_3dlut(
 void dcn20_program_front_end_for_ctx(
 		struct dc *dc,
 		struct dc_state *context);
+void dcn20_post_unlock_program_front_end(
+		struct dc *dc,
+		struct dc_state *context);
 void dcn20_update_plane_addr(const struct dc *dc, struct pipe_ctx *pipe_ctx);
 void dcn20_update_mpcc(struct dc *dc, struct pipe_ctx *pipe_ctx);
 bool dcn20_set_input_transfer_func(struct dc *dc, struct pipe_ctx *pipe_ctx,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_init.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_init.c
index 5e640f17d3d4..c0a7cf1ba3a0 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_init.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_init.c
@@ -33,6 +33,7 @@ static const struct hw_sequencer_funcs dcn20_funcs = {
 	.apply_ctx_to_hw = dce110_apply_ctx_to_hw,
 	.apply_ctx_for_surface = NULL,
 	.program_front_end_for_ctx = dcn20_program_front_end_for_ctx,
+	.post_unlock_program_front_end = dcn20_post_unlock_program_front_end,
 	.update_plane_addr = dcn20_update_plane_addr,
 	.update_dchub = dcn10_update_dchub,
 	.update_pending_status = dcn10_update_pending_status,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_init.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_init.c
index fddbd59bf4f9..bb8309513964 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_init.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_init.c
@@ -34,6 +34,7 @@ static const struct hw_sequencer_funcs dcn21_funcs = {
 	.apply_ctx_to_hw = dce110_apply_ctx_to_hw,
 	.apply_ctx_for_surface = NULL,
 	.program_front_end_for_ctx = dcn20_program_front_end_for_ctx,
+	.post_unlock_program_front_end = dcn20_post_unlock_program_front_end,
 	.update_plane_addr = dcn20_update_plane_addr,
 	.update_dchub = dcn10_update_dchub,
 	.update_pending_status = dcn10_update_pending_status,
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h b/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h
index 209118f9f193..63919866ba38 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h
@@ -66,6 +66,8 @@ struct hw_sequencer_funcs {
 			int num_planes, struct dc_state *context);
 	void (*program_front_end_for_ctx)(struct dc *dc,
 			struct dc_state *context);
+	void (*post_unlock_program_front_end)(struct dc *dc,
+			struct dc_state *context);
 	void (*update_plane_addr)(const struct dc *dc,
 			struct pipe_ctx *pipe_ctx);
 	void (*update_dchub)(struct dce_hwseq *hws,
-- 
2.25.1



