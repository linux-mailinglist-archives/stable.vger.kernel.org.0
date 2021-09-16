Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC21040E42B
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343702AbhIPQz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:55:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244039AbhIPQxo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:53:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44A6961AAA;
        Thu, 16 Sep 2021 16:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809785;
        bh=0GwvvP46Zyz0mNfzThYXUff6tsrhucZGmH8nfJY0V5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cihp0ptFHfcdx6mAaUHIPDU5ZXyX+eEFPv4gBIeX0hnLLKpJNd4zDrP4SpFXOCSKC
         6OrsHkdnzI00Xm4MepHhiENKimEsepSMFcYel+bjtCOMPxw9EHVC74o8YHMl/fmDZE
         4xl2Jdn/nnPDF5EFgh6iZasJWF/mg7mHL6uijoEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anson Jacob <Anson.Jacob@amd.com>,
        Roy Chan <roy.chan@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 251/380] drm/amd/display: fix missing writeback disablement if plane is removed
Date:   Thu, 16 Sep 2021 18:00:08 +0200
Message-Id: <20210916155812.625424440@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roy Chan <roy.chan@amd.com>

[ Upstream commit 82367e7f22d085092728f45fd5fbb15e3fb997c0 ]

[Why]
If the plane has been removed, the writeback disablement logic
doesn't run

[How]
fix the logic order

Acked-by: Anson Jacob <Anson.Jacob@amd.com>
Signed-off-by: Roy Chan <roy.chan@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c | 14 ++++++++------
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c | 12 +++++++++++-
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index 793554e61c52..03b941e76de2 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1703,13 +1703,15 @@ void dcn20_program_front_end_for_ctx(
 				dcn20_program_pipe(dc, pipe, context);
 				pipe = pipe->bottom_pipe;
 			}
-			/* Program secondary blending tree and writeback pipes */
-			pipe = &context->res_ctx.pipe_ctx[i];
-			if (!pipe->prev_odm_pipe && pipe->stream->num_wb_info > 0
-					&& (pipe->update_flags.raw || pipe->plane_state->update_flags.raw || pipe->stream->update_flags.raw)
-					&& hws->funcs.program_all_writeback_pipes_in_tree)
-				hws->funcs.program_all_writeback_pipes_in_tree(dc, pipe->stream, context);
 		}
+		/* Program secondary blending tree and writeback pipes */
+		pipe = &context->res_ctx.pipe_ctx[i];
+		if (!pipe->top_pipe && !pipe->prev_odm_pipe
+				&& pipe->stream && pipe->stream->num_wb_info > 0
+				&& (pipe->update_flags.raw || (pipe->plane_state && pipe->plane_state->update_flags.raw)
+					|| pipe->stream->update_flags.raw)
+				&& hws->funcs.program_all_writeback_pipes_in_tree)
+			hws->funcs.program_all_writeback_pipes_in_tree(dc, pipe->stream, context);
 	}
 }
 
diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
index d53f8b39699b..37944f94c693 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
@@ -396,12 +396,22 @@ void dcn30_program_all_writeback_pipes_in_tree(
 			for (i_pipe = 0; i_pipe < dc->res_pool->pipe_count; i_pipe++) {
 				struct pipe_ctx *pipe_ctx = &context->res_ctx.pipe_ctx[i_pipe];
 
+				if (!pipe_ctx->plane_state)
+					continue;
+
 				if (pipe_ctx->plane_state == wb_info.writeback_source_plane) {
 					wb_info.mpcc_inst = pipe_ctx->plane_res.mpcc_inst;
 					break;
 				}
 			}
-			ASSERT(wb_info.mpcc_inst != -1);
+
+			if (wb_info.mpcc_inst == -1) {
+				/* Disable writeback pipe and disconnect from MPCC
+				 * if source plane has been removed
+				 */
+				dc->hwss.disable_writeback(dc, wb_info.dwb_pipe_inst);
+				continue;
+			}
 
 			ASSERT(wb_info.dwb_pipe_inst < dc->res_pool->res_cap->num_dwb);
 			dwb = dc->res_pool->dwbc[wb_info.dwb_pipe_inst];
-- 
2.30.2



