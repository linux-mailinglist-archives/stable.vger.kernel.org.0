Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF4565023D
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbiLRQoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:44:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232667AbiLRQoV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:44:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1AD21F;
        Sun, 18 Dec 2022 08:15:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 380B8B803F1;
        Sun, 18 Dec 2022 16:15:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0046FC433EF;
        Sun, 18 Dec 2022 16:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380139;
        bh=bGDsxwRMuhHdwn4tRIuRcfyfJm46g2xSTZ3EKUTpDM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qC9i7nM88uV6seoc+vlIi6ZNR9j0LizimXhPddp7o42TdabW07cXpeSRhDshf1Fx1
         m3h6Wze3ttdwhgFpfMUL7C+4ChZtHsUjKb3pzpOh+GDvCmQZbj5c9Y1Pw1iR7AddsW
         OKRI0G1Fl52IPVoPBMGKJZmuxRWxZ4r4Mq7Nl6o4BgyScMvF5XDHGSzNEP7kpuBOi6
         fk7mVMLwE+BVmmFmW3gWrHP4DZHeeDXXygIUpsqtsd76xCCGBeAe2DpQJmI9bhRi98
         k9Yx1QhGE+bChLBcYJGXMv+1n5zAOUYnCWePEvnPZsl/ZeG+5zRFdw8WJFB1zAUpfl
         mq2hs3xm9h/LA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wesley Chalmers <Wesley.Chalmers@amd.com>,
        Dillon Varone <Dillon.Varone@amd.com>,
        Jasdeep Dhillon <jdhillon@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, Anthony.Koo@amd.com, Jun.Lei@amd.com,
        alex.hung@amd.com, Roman.Li@amd.com, mwen@igalia.com,
        dingchen.zhang@amd.com, martin.tsai@amd.com, aric.cyr@amd.com,
        Max.Tseng@amd.com, Alvin.Lee2@amd.com, wayne.lin@amd.com,
        wenjing.liu@amd.com, hanghong.ma@amd.com, aurabindo.pillai@amd.com,
        jiapeng.chong@linux.alibaba.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 38/46] drm/amd/display: Use the largest vready_offset in pipe group
Date:   Sun, 18 Dec 2022 11:12:36 -0500
Message-Id: <20221218161244.930785-38-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218161244.930785-1-sashal@kernel.org>
References: <20221218161244.930785-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Chalmers <Wesley.Chalmers@amd.com>

[ Upstream commit 5842abd985b792a3b13a89b6dae4869b56656c92 ]

[WHY]
Corruption can occur in LB if vready_offset is not large enough.
DML calculates vready_offset for each pipe, but we currently select the
top pipe's vready_offset, which is not necessarily enough for all pipes
in the group.

[HOW]
Wherever program_global_sync is currently called, iterate through the
entire pipe group and find the highest vready_offset.

Reviewed-by: Dillon Varone <Dillon.Varone@amd.com>
Acked-by: Jasdeep Dhillon <jdhillon@amd.com>
Signed-off-by: Wesley Chalmers <Wesley.Chalmers@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/dcn10/dcn10_hw_sequencer.c | 30 +++++++++++++++++--
 .../drm/amd/display/dc/dcn20/dcn20_hwseq.c    | 29 ++++++++++++++++--
 2 files changed, 55 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index 91ab4dbbe1a6..c655d03ef754 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -804,6 +804,32 @@ static void false_optc_underflow_wa(
 		tg->funcs->clear_optc_underflow(tg);
 }
 
+static int calculate_vready_offset_for_group(struct pipe_ctx *pipe)
+{
+	struct pipe_ctx *other_pipe;
+	int vready_offset = pipe->pipe_dlg_param.vready_offset;
+
+	/* Always use the largest vready_offset of all connected pipes */
+	for (other_pipe = pipe->bottom_pipe; other_pipe != NULL; other_pipe = other_pipe->bottom_pipe) {
+		if (other_pipe->pipe_dlg_param.vready_offset > vready_offset)
+			vready_offset = other_pipe->pipe_dlg_param.vready_offset;
+	}
+	for (other_pipe = pipe->top_pipe; other_pipe != NULL; other_pipe = other_pipe->top_pipe) {
+		if (other_pipe->pipe_dlg_param.vready_offset > vready_offset)
+			vready_offset = other_pipe->pipe_dlg_param.vready_offset;
+	}
+	for (other_pipe = pipe->next_odm_pipe; other_pipe != NULL; other_pipe = other_pipe->next_odm_pipe) {
+		if (other_pipe->pipe_dlg_param.vready_offset > vready_offset)
+			vready_offset = other_pipe->pipe_dlg_param.vready_offset;
+	}
+	for (other_pipe = pipe->prev_odm_pipe; other_pipe != NULL; other_pipe = other_pipe->prev_odm_pipe) {
+		if (other_pipe->pipe_dlg_param.vready_offset > vready_offset)
+			vready_offset = other_pipe->pipe_dlg_param.vready_offset;
+	}
+
+	return vready_offset;
+}
+
 enum dc_status dcn10_enable_stream_timing(
 		struct pipe_ctx *pipe_ctx,
 		struct dc_state *context,
@@ -838,7 +864,7 @@ enum dc_status dcn10_enable_stream_timing(
 	pipe_ctx->stream_res.tg->funcs->program_timing(
 			pipe_ctx->stream_res.tg,
 			&stream->timing,
-			pipe_ctx->pipe_dlg_param.vready_offset,
+			calculate_vready_offset_for_group(pipe_ctx),
 			pipe_ctx->pipe_dlg_param.vstartup_start,
 			pipe_ctx->pipe_dlg_param.vupdate_offset,
 			pipe_ctx->pipe_dlg_param.vupdate_width,
@@ -2776,7 +2802,7 @@ void dcn10_program_pipe(
 
 		pipe_ctx->stream_res.tg->funcs->program_global_sync(
 				pipe_ctx->stream_res.tg,
-				pipe_ctx->pipe_dlg_param.vready_offset,
+				calculate_vready_offset_for_group(pipe_ctx),
 				pipe_ctx->pipe_dlg_param.vstartup_start,
 				pipe_ctx->pipe_dlg_param.vupdate_offset,
 				pipe_ctx->pipe_dlg_param.vupdate_width);
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index 58eea3aa3bfc..bf2a8f53694b 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1564,6 +1564,31 @@ static void dcn20_update_dchubp_dpp(
 		hubp->funcs->set_blank(hubp, false);
 }
 
+static int calculate_vready_offset_for_group(struct pipe_ctx *pipe)
+{
+	struct pipe_ctx *other_pipe;
+	int vready_offset = pipe->pipe_dlg_param.vready_offset;
+
+	/* Always use the largest vready_offset of all connected pipes */
+	for (other_pipe = pipe->bottom_pipe; other_pipe != NULL; other_pipe = other_pipe->bottom_pipe) {
+		if (other_pipe->pipe_dlg_param.vready_offset > vready_offset)
+			vready_offset = other_pipe->pipe_dlg_param.vready_offset;
+	}
+	for (other_pipe = pipe->top_pipe; other_pipe != NULL; other_pipe = other_pipe->top_pipe) {
+		if (other_pipe->pipe_dlg_param.vready_offset > vready_offset)
+			vready_offset = other_pipe->pipe_dlg_param.vready_offset;
+	}
+	for (other_pipe = pipe->next_odm_pipe; other_pipe != NULL; other_pipe = other_pipe->next_odm_pipe) {
+		if (other_pipe->pipe_dlg_param.vready_offset > vready_offset)
+			vready_offset = other_pipe->pipe_dlg_param.vready_offset;
+	}
+	for (other_pipe = pipe->prev_odm_pipe; other_pipe != NULL; other_pipe = other_pipe->prev_odm_pipe) {
+		if (other_pipe->pipe_dlg_param.vready_offset > vready_offset)
+			vready_offset = other_pipe->pipe_dlg_param.vready_offset;
+	}
+
+	return vready_offset;
+}
 
 static void dcn20_program_pipe(
 		struct dc *dc,
@@ -1582,7 +1607,7 @@ static void dcn20_program_pipe(
 
 		pipe_ctx->stream_res.tg->funcs->program_global_sync(
 				pipe_ctx->stream_res.tg,
-				pipe_ctx->pipe_dlg_param.vready_offset,
+				calculate_vready_offset_for_group(pipe_ctx),
 				pipe_ctx->pipe_dlg_param.vstartup_start,
 				pipe_ctx->pipe_dlg_param.vupdate_offset,
 				pipe_ctx->pipe_dlg_param.vupdate_width);
@@ -1875,7 +1900,7 @@ bool dcn20_update_bandwidth(
 
 			pipe_ctx->stream_res.tg->funcs->program_global_sync(
 					pipe_ctx->stream_res.tg,
-					pipe_ctx->pipe_dlg_param.vready_offset,
+					calculate_vready_offset_for_group(pipe_ctx),
 					pipe_ctx->pipe_dlg_param.vstartup_start,
 					pipe_ctx->pipe_dlg_param.vupdate_offset,
 					pipe_ctx->pipe_dlg_param.vupdate_width);
-- 
2.35.1

