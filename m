Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5CD657EAD
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbiL1P4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:56:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234222AbiL1P4U (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:56:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65F61659A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:56:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EA26B817B1
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:56:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D10F3C433D2;
        Wed, 28 Dec 2022 15:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242968;
        bh=bGDsxwRMuhHdwn4tRIuRcfyfJm46g2xSTZ3EKUTpDM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JDRpeMFQTzEt7TUkmF5ivvLk5OofqnpCaLI7roH8+CL7NQ8g/z5mKwLb+9cmCWnYJ
         teLwyMxbxr/T9GFwt5ZpfWKZr0JuxdtOrEBW7aGKOh/7pl5k238i0jdEIrvvQ1MVU2
         J//tNiAeBa8xhmHYI1fZqCKMLGYRkZkfwfu1P6SQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dillon Varone <Dillon.Varone@amd.com>,
        Jasdeep Dhillon <jdhillon@amd.com>,
        Wesley Chalmers <Wesley.Chalmers@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 666/731] drm/amd/display: Use the largest vready_offset in pipe group
Date:   Wed, 28 Dec 2022 15:42:53 +0100
Message-Id: <20221228144315.793995911@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



