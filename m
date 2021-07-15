Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8C123CA9F7
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243188AbhGOTLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:11:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:46406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242177AbhGOTIt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:08:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B336260FF4;
        Thu, 15 Jul 2021 19:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375867;
        bh=VuLeOQHb+jdBnhIxuyI7y13YX5R0cN86+8AiJcasJPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NEaKV0eBJDItLHLkCXHzWRxmJy28OVZXI3GYQlk3uiGRQWMBwlrkZfTFU/T2jCiV6
         4PWK6BPUdeoR8A8TTGOlxv2ks7KAfo8xv/4Psnw6Qt/pSxUvCY3/Qb8t2h9AQzoy3Z
         beoovPynmBP75pT6MA9cmtT/tZUXP7slTbh4aC64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lewis Huang <Lewis.Huang@amd.com>,
        Eric Yang <eric.yang2@amd.com>, Wayne Lin <waynelin@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 005/266] drm/amd/display: Revert wait vblank on update dpp clock
Date:   Thu, 15 Jul 2021 20:36:00 +0200
Message-Id: <20210715182614.862015603@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lewis Huang <Lewis.Huang@amd.com>

[ Upstream commit d5433a9f692f57c814286f8af2746c567ef79fc8 ]

[Why]
This change only fix dpp clock switch to lower case.
New solution later can fix both case, which is "dc: skip
program clock when allow seamless boot"

[How]
This reverts commit "dc: wait vblank when stream enabled
and update dpp clock"

Signed-off-by: Lewis Huang <Lewis.Huang@amd.com>
Reviewed-by: Eric Yang <eric.yang2@amd.com>
Acked-by: Wayne Lin <waynelin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c   | 10 +---------
 drivers/gpu/drm/amd/display/dc/core/dc.c            | 13 -------------
 drivers/gpu/drm/amd/display/dc/dc.h                 |  1 -
 3 files changed, 1 insertion(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
index a06e86853bb9..49d19fdd750b 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
@@ -128,7 +128,7 @@ void rn_update_clocks(struct clk_mgr *clk_mgr_base,
 	struct clk_mgr_internal *clk_mgr = TO_CLK_MGR_INTERNAL(clk_mgr_base);
 	struct dc_clocks *new_clocks = &context->bw_ctx.bw.dcn.clk;
 	struct dc *dc = clk_mgr_base->ctx->dc;
-	int display_count, i;
+	int display_count;
 	bool update_dppclk = false;
 	bool update_dispclk = false;
 	bool dpp_clock_lowered = false;
@@ -210,14 +210,6 @@ void rn_update_clocks(struct clk_mgr *clk_mgr_base,
 				clk_mgr_base->clks.dppclk_khz,
 				safe_to_lower);
 
-		for (i = 0; i < context->stream_count; i++) {
-			if (context->streams[i]->signal == SIGNAL_TYPE_EDP &&
-				context->streams[i]->apply_seamless_boot_optimization) {
-				dc_wait_for_vblank(dc, context->streams[i]);
-				break;
-			}
-		}
-
 		clk_mgr_base->clks.actual_dppclk_khz =
 				rn_vbios_smu_set_dppclk(clk_mgr, clk_mgr_base->clks.dppclk_khz);
 
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 4713f09bcbf1..e57df2f6f824 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -3219,19 +3219,6 @@ void dc_link_remove_remote_sink(struct dc_link *link, struct dc_sink *sink)
 	}
 }
 
-void dc_wait_for_vblank(struct dc *dc, struct dc_stream_state *stream)
-{
-	int i;
-
-	for (i = 0; i < dc->res_pool->pipe_count; i++)
-		if (dc->current_state->res_ctx.pipe_ctx[i].stream == stream) {
-			struct timing_generator *tg =
-				dc->current_state->res_ctx.pipe_ctx[i].stream_res.tg;
-			tg->funcs->wait_for_state(tg, CRTC_STATE_VBLANK);
-			break;
-		}
-}
-
 void get_clock_requirements_for_state(struct dc_state *state, struct AsicStateEx *info)
 {
 	info->displayClock				= (unsigned int)state->bw_ctx.bw.dcn.clk.dispclk_khz;
diff --git a/drivers/gpu/drm/amd/display/dc/dc.h b/drivers/gpu/drm/amd/display/dc/dc.h
index 100d434f7a03..65f801b50686 100644
--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -719,7 +719,6 @@ void dc_init_callbacks(struct dc *dc,
 void dc_deinit_callbacks(struct dc *dc);
 void dc_destroy(struct dc **dc);
 
-void dc_wait_for_vblank(struct dc *dc, struct dc_stream_state *stream);
 /*******************************************************************************
  * Surface Interfaces
  ******************************************************************************/
-- 
2.30.2



