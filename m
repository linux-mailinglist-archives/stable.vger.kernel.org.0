Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 104B83BCB7C
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbhGFLQ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:16:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231891AbhGFLQ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:16:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C00D561C23;
        Tue,  6 Jul 2021 11:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570058;
        bh=VuLeOQHb+jdBnhIxuyI7y13YX5R0cN86+8AiJcasJPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pBj9mozpuwPmIGtdvpqeOYlfqaZhCiuZZfVxlHEOcPIAgujRf09GkAGDwzP0Wk6ot
         8P7U9VfiS/C5mVc6rFN0t+MvqCXVgqjT1zuTPWGgDSxT8Hv8bNl9ILxToKeadA2Tez
         gE2YVqtJ+XWiXz4vgEl3K/KHXNIUjTA2jflzxsTmAudoRVRLbT5AGWP869vsgLAroy
         srYsU2TEpeHiLv4rhSqTVJ/vIyIQlVEGoaYPiiSMZNx8MZ2rAmoBFxkKX1izq25onI
         qw4eIT3xf9qA4499aVJjHqEoMnW4kdBiVSSCd1xo2xBRT9foROU9MtjhQbIZLmbUj6
         /nO7vE+nzOx/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lewis Huang <Lewis.Huang@amd.com>, Eric Yang <eric.yang2@amd.com>,
        Wayne Lin <waynelin@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.13 006/189] drm/amd/display: Revert wait vblank on update dpp clock
Date:   Tue,  6 Jul 2021 07:11:06 -0400
Message-Id: <20210706111409.2058071-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

