Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFDE404BCC
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241213AbhIILxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:53:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241446AbhIILu7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:50:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 966DB6127A;
        Thu,  9 Sep 2021 11:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187841;
        bh=qMBC1L/AVg6yHH1DMtljl6zFQJ6blv5t5dZtGJ+J2Zk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bGntK3lCHqz1nJ7ZzSgHOTMMKbEgJ4ZcuSP4iXMk3EFW9dMcfGbhvJNwTt6kazig3
         9Jqwohl5DrEn3ctm8S/US3XPfXPCw5Rj2Ilf2ct83YRtEbNewm/A3e/Du+E/riAooa
         513+PprW0KwPBXS/twWEIZxunP8OLxm3oraz7gHpA8Ruo5MDp1HJHNRgA7grBKPimx
         rsCgg+JgSlvtvLOB2+JS82cyZTJiEVr9w+4CbUBsDuOnhNNhREfRAz2ZZMBVP0CjTZ
         UFnddSvV9Tvjhy46t9VmySIznIRaDGb4uXXX8z5DvFAce/86bFY7AZbIWsTtQUhbGR
         KyuqMHLgMPwoQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roy Chan <roy.chan@amd.com>, Anson Jacob <Anson.Jacob@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.14 135/252] drm/amd/display: fix missing writeback disablement if plane is removed
Date:   Thu,  9 Sep 2021 07:39:09 -0400
Message-Id: <20210909114106.141462-135-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 5c2853654cca..a47ba1d45be9 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1723,13 +1723,15 @@ void dcn20_program_front_end_for_ctx(
 
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
index 2e8ab9775fa3..fafed1e4a998 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
@@ -398,12 +398,22 @@ void dcn30_program_all_writeback_pipes_in_tree(
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

