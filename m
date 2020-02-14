Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9ACB15DCA8
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 16:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731382AbgBNPyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:54:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:33494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731379AbgBNPx6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:53:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75A042465D;
        Fri, 14 Feb 2020 15:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695637;
        bh=j0ecz4Ik4NMLL9kgzq4YLNjoyq9+a+XaYhdyqFBoVvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mn9yO0iAfLfZcik0tAOpsg6xV6GlgfMaahjp3lGdq9XG0hygmKlEPZJTD55O9BshX
         UMbyW8elwTy/Ph1rFqHUDP7k2qnHJxsCjzKraG1eRxzMH3snHkTlmINL0nFLR5AtR9
         I3i+hevagEXeNWYImkDxoDWvMmoeAUSCCv322Jfk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sung Lee <sung.lee@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Tony Cheng <Tony.Cheng@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.5 233/542] drm/amd/display: Lower DPP DTO only when safe
Date:   Fri, 14 Feb 2020 10:43:45 -0500
Message-Id: <20200214154854.6746-233-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sung Lee <sung.lee@amd.com>

[ Upstream commit 5479034576ec8b7166a66efe5de1d911feb43d4a ]

[Why]
A corner case currently exists where DPP DTO is lowered before
pipes are updated to a higher viewport. This causes underflow
as the DPPCLK is too low for the current viewport.

[How]
Only lower DPP DTO when it is safe to lower, or if
the newer clocks are higher than the current ones.

Signed-off-by: Sung Lee <sung.lee@amd.com>
Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Reviewed-by: Tony Cheng <Tony.Cheng@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c | 16 ++++++++++------
 .../amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.h |  2 +-
 .../amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c    |  8 ++++----
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c
index 25d7b7c6681cc..7dca2e6eb3bc9 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c
@@ -100,13 +100,13 @@ uint32_t dentist_get_did_from_divider(int divider)
 }
 
 void dcn20_update_clocks_update_dpp_dto(struct clk_mgr_internal *clk_mgr,
-		struct dc_state *context)
+		struct dc_state *context, bool safe_to_lower)
 {
 	int i;
 
 	clk_mgr->dccg->ref_dppclk = clk_mgr->base.clks.dppclk_khz;
 	for (i = 0; i < clk_mgr->base.ctx->dc->res_pool->pipe_count; i++) {
-		int dpp_inst, dppclk_khz;
+		int dpp_inst, dppclk_khz, prev_dppclk_khz;
 
 		/* Loop index will match dpp->inst if resource exists,
 		 * and we want to avoid dependency on dpp object
@@ -114,8 +114,12 @@ void dcn20_update_clocks_update_dpp_dto(struct clk_mgr_internal *clk_mgr,
 		dpp_inst = i;
 		dppclk_khz = context->res_ctx.pipe_ctx[i].plane_res.bw.dppclk_khz;
 
-		clk_mgr->dccg->funcs->update_dpp_dto(
-				clk_mgr->dccg, dpp_inst, dppclk_khz);
+		prev_dppclk_khz = clk_mgr->base.ctx->dc->current_state->res_ctx.pipe_ctx[i].plane_res.bw.dppclk_khz;
+
+		if (safe_to_lower || prev_dppclk_khz < dppclk_khz) {
+			clk_mgr->dccg->funcs->update_dpp_dto(
+							clk_mgr->dccg, dpp_inst, dppclk_khz);
+		}
 	}
 }
 
@@ -240,7 +244,7 @@ void dcn2_update_clocks(struct clk_mgr *clk_mgr_base,
 	if (dc->config.forced_clocks == false || (force_reset && safe_to_lower)) {
 		if (dpp_clock_lowered) {
 			// if clock is being lowered, increase DTO before lowering refclk
-			dcn20_update_clocks_update_dpp_dto(clk_mgr, context);
+			dcn20_update_clocks_update_dpp_dto(clk_mgr, context, safe_to_lower);
 			dcn20_update_clocks_update_dentist(clk_mgr);
 		} else {
 			// if clock is being raised, increase refclk before lowering DTO
@@ -248,7 +252,7 @@ void dcn2_update_clocks(struct clk_mgr *clk_mgr_base,
 				dcn20_update_clocks_update_dentist(clk_mgr);
 			// always update dtos unless clock is lowered and not safe to lower
 			if (new_clocks->dppclk_khz >= dc->current_state->bw_ctx.bw.dcn.clk.dppclk_khz)
-				dcn20_update_clocks_update_dpp_dto(clk_mgr, context);
+				dcn20_update_clocks_update_dpp_dto(clk_mgr, context, safe_to_lower);
 		}
 	}
 
diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.h b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.h
index c9fd824f3c231..74ccd6c04134a 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.h
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.h
@@ -34,7 +34,7 @@ void dcn2_update_clocks_fpga(struct clk_mgr *clk_mgr,
 			struct dc_state *context,
 			bool safe_to_lower);
 void dcn20_update_clocks_update_dpp_dto(struct clk_mgr_internal *clk_mgr,
-		struct dc_state *context);
+		struct dc_state *context, bool safe_to_lower);
 
 void dcn2_init_clocks(struct clk_mgr *clk_mgr);
 
diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
index 35c55e54eac01..dbf063856846e 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
@@ -164,16 +164,16 @@ void rn_update_clocks(struct clk_mgr *clk_mgr_base,
 	}
 
 	if (dpp_clock_lowered) {
-		// if clock is being lowered, increase DTO before lowering refclk
-		dcn20_update_clocks_update_dpp_dto(clk_mgr, context);
+		// increase per DPP DTO before lowering global dppclk
+		dcn20_update_clocks_update_dpp_dto(clk_mgr, context, safe_to_lower);
 		rn_vbios_smu_set_dppclk(clk_mgr, clk_mgr_base->clks.dppclk_khz);
 	} else {
-		// if clock is being raised, increase refclk before lowering DTO
+		// increase global DPPCLK before lowering per DPP DTO
 		if (update_dppclk || update_dispclk)
 			rn_vbios_smu_set_dppclk(clk_mgr, clk_mgr_base->clks.dppclk_khz);
 		// always update dtos unless clock is lowered and not safe to lower
 		if (new_clocks->dppclk_khz >= dc->current_state->bw_ctx.bw.dcn.clk.dppclk_khz)
-			dcn20_update_clocks_update_dpp_dto(clk_mgr, context);
+			dcn20_update_clocks_update_dpp_dto(clk_mgr, context, safe_to_lower);
 	}
 
 	if (update_dispclk &&
-- 
2.20.1

