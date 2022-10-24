Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2DF60A9F0
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiJXN0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236366AbiJXNZc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:25:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB2D88DFF;
        Mon, 24 Oct 2022 05:31:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FEA4612B3;
        Mon, 24 Oct 2022 12:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB19C433D6;
        Mon, 24 Oct 2022 12:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614649;
        bh=0Rj5oDI/zVqSP4IONDE510+rQzQ6XHEWox2i8JUDLcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QJn55OA5ZJ2BAv5szXjRI1CVL6dmOuqMvQ3R9i7jnutLMpkaded6+wxw/994Ymrij
         DfDU1BSmgdb5P46IIAI4QmIcxZFg/WeqMg0HfxbntzDHmDs6DlEhsP1KjobDtVF/j4
         yT+q7sr/NQV9oA7nNfcgfj+XlkAzn+TBJhJNbarM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaehyun Chung <jaehyun.chung@amd.com>,
        Jasdeep Dhillon <jdhillon@amd.com>,
        Aric Cyr <aric.cyr@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 341/390] drm/amd/display: Remove interface for periodic interrupt 1
Date:   Mon, 24 Oct 2022 13:32:18 +0200
Message-Id: <20221024113037.525868052@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aric Cyr <aric.cyr@amd.com>

[ Upstream commit 97d8d6f075bd8f988589be02b91f6fa644d0b0b8 ]

[why]
Only a single VLINE interrupt is available so interface should not
expose the second one which is used by DMU firmware.

[how]
Remove references to periodic_interrupt1 and VLINE1 from DC interfaces.

Reviewed-by: Jaehyun Chung <jaehyun.chung@amd.com>
Acked-by: Jasdeep Dhillon <jdhillon@amd.com>
Signed-off-by: Aric Cyr <aric.cyr@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c      | 16 +++------
 drivers/gpu/drm/amd/display/dc/dc_stream.h    |  6 ++--
 .../amd/display/dc/dcn10/dcn10_hw_sequencer.c | 35 ++++++-------------
 .../amd/display/dc/dcn10/dcn10_hw_sequencer.h |  3 +-
 .../gpu/drm/amd/display/dc/inc/hw_sequencer.h |  8 +----
 5 files changed, 18 insertions(+), 50 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 93f5229c303e..99887bcfada0 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2202,11 +2202,8 @@ static void copy_stream_update_to_stream(struct dc *dc,
 	if (update->abm_level)
 		stream->abm_level = *update->abm_level;
 
-	if (update->periodic_interrupt0)
-		stream->periodic_interrupt0 = *update->periodic_interrupt0;
-
-	if (update->periodic_interrupt1)
-		stream->periodic_interrupt1 = *update->periodic_interrupt1;
+	if (update->periodic_interrupt)
+		stream->periodic_interrupt = *update->periodic_interrupt;
 
 	if (update->gamut_remap)
 		stream->gamut_remap_matrix = *update->gamut_remap;
@@ -2288,13 +2285,8 @@ static void commit_planes_do_stream_update(struct dc *dc,
 
 		if (!pipe_ctx->top_pipe &&  !pipe_ctx->prev_odm_pipe && pipe_ctx->stream == stream) {
 
-			if (stream_update->periodic_interrupt0 &&
-					dc->hwss.setup_periodic_interrupt)
-				dc->hwss.setup_periodic_interrupt(dc, pipe_ctx, VLINE0);
-
-			if (stream_update->periodic_interrupt1 &&
-					dc->hwss.setup_periodic_interrupt)
-				dc->hwss.setup_periodic_interrupt(dc, pipe_ctx, VLINE1);
+			if (stream_update->periodic_interrupt && dc->hwss.setup_periodic_interrupt)
+				dc->hwss.setup_periodic_interrupt(dc, pipe_ctx);
 
 			if ((stream_update->hdr_static_metadata && !stream->use_dynamic_meta) ||
 					stream_update->vrr_infopacket ||
diff --git a/drivers/gpu/drm/amd/display/dc/dc_stream.h b/drivers/gpu/drm/amd/display/dc/dc_stream.h
index 205bedd1b196..0487c1b8957c 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_stream.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_stream.h
@@ -179,8 +179,7 @@ struct dc_stream_state {
 	/* DMCU info */
 	unsigned int abm_level;
 
-	struct periodic_interrupt_config periodic_interrupt0;
-	struct periodic_interrupt_config periodic_interrupt1;
+	struct periodic_interrupt_config periodic_interrupt;
 
 	/* from core_stream struct */
 	struct dc_context *ctx;
@@ -244,8 +243,7 @@ struct dc_stream_update {
 	struct dc_info_packet *hdr_static_metadata;
 	unsigned int *abm_level;
 
-	struct periodic_interrupt_config *periodic_interrupt0;
-	struct periodic_interrupt_config *periodic_interrupt1;
+	struct periodic_interrupt_config *periodic_interrupt;
 
 	struct dc_info_packet *vrr_infopacket;
 	struct dc_info_packet *vsc_infopacket;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index 31a13daf4289..71a85c5306ed 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -3611,7 +3611,7 @@ void dcn10_calc_vupdate_position(
 {
 	const struct dc_crtc_timing *dc_crtc_timing = &pipe_ctx->stream->timing;
 	int vline_int_offset_from_vupdate =
-			pipe_ctx->stream->periodic_interrupt0.lines_offset;
+			pipe_ctx->stream->periodic_interrupt.lines_offset;
 	int vupdate_offset_from_vsync = dc->hwss.get_vupdate_offset_from_vsync(pipe_ctx);
 	int start_position;
 
@@ -3636,18 +3636,10 @@ void dcn10_calc_vupdate_position(
 static void dcn10_cal_vline_position(
 		struct dc *dc,
 		struct pipe_ctx *pipe_ctx,
-		enum vline_select vline,
 		uint32_t *start_line,
 		uint32_t *end_line)
 {
-	enum vertical_interrupt_ref_point ref_point = INVALID_POINT;
-
-	if (vline == VLINE0)
-		ref_point = pipe_ctx->stream->periodic_interrupt0.ref_point;
-	else if (vline == VLINE1)
-		ref_point = pipe_ctx->stream->periodic_interrupt1.ref_point;
-
-	switch (ref_point) {
+	switch (pipe_ctx->stream->periodic_interrupt.ref_point) {
 	case START_V_UPDATE:
 		dcn10_calc_vupdate_position(
 				dc,
@@ -3656,7 +3648,9 @@ static void dcn10_cal_vline_position(
 				end_line);
 		break;
 	case START_V_SYNC:
-		// Suppose to do nothing because vsync is 0;
+		// vsync is line 0 so start_line is just the requested line offset
+		*start_line = pipe_ctx->stream->periodic_interrupt.lines_offset;
+		*end_line = *start_line + 2;
 		break;
 	default:
 		ASSERT(0);
@@ -3666,24 +3660,15 @@ static void dcn10_cal_vline_position(
 
 void dcn10_setup_periodic_interrupt(
 		struct dc *dc,
-		struct pipe_ctx *pipe_ctx,
-		enum vline_select vline)
+		struct pipe_ctx *pipe_ctx)
 {
 	struct timing_generator *tg = pipe_ctx->stream_res.tg;
+	uint32_t start_line = 0;
+	uint32_t end_line = 0;
 
-	if (vline == VLINE0) {
-		uint32_t start_line = 0;
-		uint32_t end_line = 0;
+	dcn10_cal_vline_position(dc, pipe_ctx, &start_line, &end_line);
 
-		dcn10_cal_vline_position(dc, pipe_ctx, vline, &start_line, &end_line);
-
-		tg->funcs->setup_vertical_interrupt0(tg, start_line, end_line);
-
-	} else if (vline == VLINE1) {
-		pipe_ctx->stream_res.tg->funcs->setup_vertical_interrupt1(
-				tg,
-				pipe_ctx->stream->periodic_interrupt1.lines_offset);
-	}
+	tg->funcs->setup_vertical_interrupt0(tg, start_line, end_line);
 }
 
 void dcn10_setup_vupdate_interrupt(struct dc *dc, struct pipe_ctx *pipe_ctx)
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h
index e5691e499023..81b5057d5ff1 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h
@@ -174,8 +174,7 @@ void dcn10_set_cursor_attribute(struct pipe_ctx *pipe_ctx);
 void dcn10_set_cursor_sdr_white_level(struct pipe_ctx *pipe_ctx);
 void dcn10_setup_periodic_interrupt(
 		struct dc *dc,
-		struct pipe_ctx *pipe_ctx,
-		enum vline_select vline);
+		struct pipe_ctx *pipe_ctx);
 enum dc_status dcn10_set_clock(struct dc *dc,
 		enum dc_clock_type clock_type,
 		uint32_t clk_khz,
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h b/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h
index 64c1be818b0e..3165a66c5362 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h
@@ -32,11 +32,6 @@
 #include "inc/hw/link_encoder.h"
 #include "core_status.h"
 
-enum vline_select {
-	VLINE0,
-	VLINE1
-};
-
 struct pipe_ctx;
 struct dc_state;
 struct dc_stream_status;
@@ -112,8 +107,7 @@ struct hw_sequencer_funcs {
 			int group_index, int group_size,
 			struct pipe_ctx *grouped_pipes[]);
 	void (*setup_periodic_interrupt)(struct dc *dc,
-			struct pipe_ctx *pipe_ctx,
-			enum vline_select vline);
+			struct pipe_ctx *pipe_ctx);
 	void (*set_drr)(struct pipe_ctx **pipe_ctx, int num_pipes,
 			unsigned int vmin, unsigned int vmax,
 			unsigned int vmid, unsigned int vmid_frame_number);
-- 
2.35.1



