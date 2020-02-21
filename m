Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF38A167131
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729853AbgBUHwB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:52:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:49656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729849AbgBUHwB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:52:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA30B20578;
        Fri, 21 Feb 2020 07:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271520;
        bh=j0ecz4Ik4NMLL9kgzq4YLNjoyq9+a+XaYhdyqFBoVvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Jl5FeQMmBmPCLgQ9PAJFIf0AmKxw6WciTYkGpZA0ISKjHerLFanLvqleLHjtIxDK
         LSjyZtKeqVelc6CYtblf8S3KyHhxxcj3Ki7wwmlUd1jDd1UYvXb85ELcmGK1XohKwD
         bMUnWVjNUswxlXnToAhEmdRqNCEvvkFQWzirXdrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sung Lee <sung.lee@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Tony Cheng <Tony.Cheng@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 160/399] drm/amd/display: Lower DPP DTO only when safe
Date:   Fri, 21 Feb 2020 08:38:05 +0100
Message-Id: <20200221072418.113155311@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



