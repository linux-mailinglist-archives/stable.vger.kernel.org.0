Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837E41EAC3A
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731229AbgFASRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:17:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730753AbgFASRN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:17:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DFF8206E2;
        Mon,  1 Jun 2020 18:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035431;
        bh=G7pXJ7gjYCbsGDybjXy2ttQC5CykFVlMMwk7hZpNo30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gTSzNvY7+2qxDN2toWJqvsWGEkl+a6rT/64lnw/bZeZOvoVit8aLhepj9jgn8S+jQ
         mAN5fEt/CcvMd6JiKflEzd+OnuuufhavBaHTIqhzVACSUWSl8Zyy0E8+l5Gexy2Tdq
         LpQLyngSbfxkcJkqzFT+bc6eTgs0NGvToJwHaC+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 129/177] drm/amd/display: Defer cursor lock until after VUPDATE
Date:   Mon,  1 Jun 2020 19:54:27 +0200
Message-Id: <20200601174059.291380865@linuxfoundation.org>
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

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 31ecebee9c36d5e5e113a357a655d993fa916174 ]

[Why]
We dropped the delay after changed the cursor functions locking the
entire pipe to locking just the CURSOR registers to fix page flip
stuttering - this introduced cursor stuttering instead, and an underflow
issue.

The cursor update can be delayed indefinitely if the cursor update
repeatedly happens right around VUPDATE.

The underflow issue can happen if we do a viewport update on a pipe
on the same frame where a cursor update happens around VUPDATE - the
old cursor registers are retained which can be in an invalid position.

This can cause a pipe hang and indefinite underflow.

[How]
The complex, ideal solution to the problem would be a software
triple buffering mechanism from the DM layer to program only one cursor
update per frame just before VUPDATE.

The simple workaround until we have that infrastructure in place is
this change - bring back the delay until VUPDATE before locking, but
with some corrections to the calculations.

This didn't work for all timings before because the calculation for
VUPDATE was wrong - it was using the offset from VSTARTUP instead and
didn't correctly handle the case where VUPDATE could be in the back
porch.

Add a new hardware sequencer function to use the existing helper to
calculate the real VUPDATE start and VUPDATE end - VUPDATE can last
multiple lines after all.

Change the udelay to incorporate the width of VUPDATE as well.

Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/dcn10/dcn10_hw_sequencer.c | 69 ++++++++++++++++++-
 .../amd/display/dc/dcn10/dcn10_hw_sequencer.h |  5 ++
 .../gpu/drm/amd/display/dc/dcn10/dcn10_init.c |  1 +
 .../gpu/drm/amd/display/dc/dcn20/dcn20_init.c |  1 +
 .../gpu/drm/amd/display/dc/dcn21/dcn21_init.c |  1 +
 .../gpu/drm/amd/display/dc/inc/hw_sequencer.h |  5 ++
 6 files changed, 81 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index 97a820b90541..60cea910759b 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -1592,12 +1592,79 @@ void dcn10_pipe_control_lock(
 		hws->funcs.verify_allow_pstate_change_high(dc);
 }
 
+/**
+ * delay_cursor_until_vupdate() - Delay cursor update if too close to VUPDATE.
+ *
+ * Software keepout workaround to prevent cursor update locking from stalling
+ * out cursor updates indefinitely or from old values from being retained in
+ * the case where the viewport changes in the same frame as the cursor.
+ *
+ * The idea is to calculate the remaining time from VPOS to VUPDATE. If it's
+ * too close to VUPDATE, then stall out until VUPDATE finishes.
+ *
+ * TODO: Optimize cursor programming to be once per frame before VUPDATE
+ *       to avoid the need for this workaround.
+ */
+static void delay_cursor_until_vupdate(struct dc *dc, struct pipe_ctx *pipe_ctx)
+{
+	struct dc_stream_state *stream = pipe_ctx->stream;
+	struct crtc_position position;
+	uint32_t vupdate_start, vupdate_end;
+	unsigned int lines_to_vupdate, us_to_vupdate, vpos;
+	unsigned int us_per_line, us_vupdate;
+
+	if (!dc->hwss.calc_vupdate_position || !dc->hwss.get_position)
+		return;
+
+	if (!pipe_ctx->stream_res.stream_enc || !pipe_ctx->stream_res.tg)
+		return;
+
+	dc->hwss.calc_vupdate_position(dc, pipe_ctx, &vupdate_start,
+				       &vupdate_end);
+
+	dc->hwss.get_position(&pipe_ctx, 1, &position);
+	vpos = position.vertical_count;
+
+	/* Avoid wraparound calculation issues */
+	vupdate_start += stream->timing.v_total;
+	vupdate_end += stream->timing.v_total;
+	vpos += stream->timing.v_total;
+
+	if (vpos <= vupdate_start) {
+		/* VPOS is in VACTIVE or back porch. */
+		lines_to_vupdate = vupdate_start - vpos;
+	} else if (vpos > vupdate_end) {
+		/* VPOS is in the front porch. */
+		return;
+	} else {
+		/* VPOS is in VUPDATE. */
+		lines_to_vupdate = 0;
+	}
+
+	/* Calculate time until VUPDATE in microseconds. */
+	us_per_line =
+		stream->timing.h_total * 10000u / stream->timing.pix_clk_100hz;
+	us_to_vupdate = lines_to_vupdate * us_per_line;
+
+	/* 70 us is a conservative estimate of cursor update time*/
+	if (us_to_vupdate > 70)
+		return;
+
+	/* Stall out until the cursor update completes. */
+	us_vupdate = (vupdate_end - vupdate_start + 1) * us_per_line;
+	udelay(us_to_vupdate + us_vupdate);
+}
+
 void dcn10_cursor_lock(struct dc *dc, struct pipe_ctx *pipe, bool lock)
 {
 	/* cursor lock is per MPCC tree, so only need to lock one pipe per stream */
 	if (!pipe || pipe->top_pipe)
 		return;
 
+	/* Prevent cursor lock from stalling out cursor updates. */
+	if (lock)
+		delay_cursor_until_vupdate(dc, pipe);
+
 	dc->res_pool->mpc->funcs->cursor_lock(dc->res_pool->mpc,
 			pipe->stream_res.opp->inst, lock);
 }
@@ -3142,7 +3209,7 @@ int dcn10_get_vupdate_offset_from_vsync(struct pipe_ctx *pipe_ctx)
 	return vertical_line_start;
 }
 
-static void dcn10_calc_vupdate_position(
+void dcn10_calc_vupdate_position(
 		struct dc *dc,
 		struct pipe_ctx *pipe_ctx,
 		uint32_t *start_line,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h
index af51424315d5..42b6e016d71e 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h
@@ -34,6 +34,11 @@ struct dc;
 void dcn10_hw_sequencer_construct(struct dc *dc);
 
 int dcn10_get_vupdate_offset_from_vsync(struct pipe_ctx *pipe_ctx);
+void dcn10_calc_vupdate_position(
+		struct dc *dc,
+		struct pipe_ctx *pipe_ctx,
+		uint32_t *start_line,
+		uint32_t *end_line);
 void dcn10_setup_vupdate_interrupt(struct dc *dc, struct pipe_ctx *pipe_ctx);
 enum dc_status dcn10_enable_stream_timing(
 		struct pipe_ctx *pipe_ctx,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c
index 4a8e4b797bea..0900c861204f 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c
@@ -72,6 +72,7 @@ static const struct hw_sequencer_funcs dcn10_funcs = {
 	.set_clock = dcn10_set_clock,
 	.get_clock = dcn10_get_clock,
 	.get_vupdate_offset_from_vsync = dcn10_get_vupdate_offset_from_vsync,
+	.calc_vupdate_position = dcn10_calc_vupdate_position,
 };
 
 static const struct hwseq_private_funcs dcn10_private_funcs = {
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_init.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_init.c
index 0cae0c2f84c4..71bfde2cf646 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_init.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_init.c
@@ -83,6 +83,7 @@ static const struct hw_sequencer_funcs dcn20_funcs = {
 	.init_vm_ctx = dcn20_init_vm_ctx,
 	.set_flip_control_gsl = dcn20_set_flip_control_gsl,
 	.get_vupdate_offset_from_vsync = dcn10_get_vupdate_offset_from_vsync,
+	.calc_vupdate_position = dcn10_calc_vupdate_position,
 };
 
 static const struct hwseq_private_funcs dcn20_private_funcs = {
diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_init.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_init.c
index 8fe8ec7c0882..7f53bf724fce 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_init.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_init.c
@@ -86,6 +86,7 @@ static const struct hw_sequencer_funcs dcn21_funcs = {
 	.optimize_pwr_state = dcn21_optimize_pwr_state,
 	.exit_optimized_pwr_state = dcn21_exit_optimized_pwr_state,
 	.get_vupdate_offset_from_vsync = dcn10_get_vupdate_offset_from_vsync,
+	.calc_vupdate_position = dcn10_calc_vupdate_position,
 	.set_cursor_position = dcn10_set_cursor_position,
 	.set_cursor_attribute = dcn10_set_cursor_attribute,
 	.set_cursor_sdr_white_level = dcn10_set_cursor_sdr_white_level,
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h b/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h
index e57467d99d66..08307f3796e3 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h
@@ -92,6 +92,11 @@ struct hw_sequencer_funcs {
 	void (*get_position)(struct pipe_ctx **pipe_ctx, int num_pipes,
 			struct crtc_position *position);
 	int (*get_vupdate_offset_from_vsync)(struct pipe_ctx *pipe_ctx);
+	void (*calc_vupdate_position)(
+			struct dc *dc,
+			struct pipe_ctx *pipe_ctx,
+			uint32_t *start_line,
+			uint32_t *end_line);
 	void (*enable_per_frame_crtc_position_reset)(struct dc *dc,
 			int group_size, struct pipe_ctx *grouped_pipes[]);
 	void (*enable_timing_synchronization)(struct dc *dc,
-- 
2.25.1



