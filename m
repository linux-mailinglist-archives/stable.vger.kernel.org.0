Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A11973F6402
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238467AbhHXRAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:00:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234520AbhHXQ6s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:58:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BFAA6140D;
        Tue, 24 Aug 2021 16:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824242;
        bh=UEKJxvnTKS0O5EcWM3GSJctVolO07IJMO5rjOzwgMNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mKLWxw8gyG1PXPE7Uw214+D+PF8oUd0Czf7zeFN+wAHySTcrkkCpmnSP3KfRV45F7
         M0C+04lh5vajAugjBB//sAb5qT/I471ekwCgQNSn/6p5UQpDq49pGXbhIHxkd65Hbl
         TkD/RpsDLouMc0L4GogTP0oNCDgSsIyHB5DB6bEm4WjXIkuA5KpKTfVihO2P+tsaKU
         iwdrABdlkCaV0ADkKrgl2MiJpSl6GYffLTtkfvfb6nxMGmTzqFeRxlV6MiJN9wO30d
         fzYjQDK6zUxYsfkz4mEjKJRD/IJSvRS17gZXvgwOhvqSzXbkqn3vGrSH6FSSUHUfJg
         phsk/2FDbW3VA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhan Liu <zhan.liu@amd.com>, Nikola Cornij <nikola.cornij@amd.com>,
        Oliver Logush <oliver.logush@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 074/127] drm/amd/display: Use DCN30 watermark calc for DCN301
Date:   Tue, 24 Aug 2021 12:55:14 -0400
Message-Id: <20210824165607.709387-75-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhan Liu <zhan.liu@amd.com>

[ Upstream commit 37717b8c9f0e8c4dd73fc522769cc14649b4f657 ]

[why]
dcn301_calculate_wm_and_dl() causes flickering when external monitor is
connected.

This issue has been fixed before by commit 0e4c0ae59d7e
("drm/amdgpu/display: drop dcn301_calculate_wm_and_dl for now"), however
part of the fix was gone after commit 2cbcb78c9ee5 ("Merge tag 'amd-drm-next-5.13-2021-03-23' of https://gitlab.freedesktop.org/agd5f/linux into drm-next").

[how]
Use dcn30_calculate_wm_and_dlg() instead as in the original fix.

Fixes: 2cbcb78c9ee5 ("Merge tag 'amd-drm-next-5.13-2021-03-23' of https://gitlab.freedesktop.org/agd5f/linux into drm-next")

Signed-off-by: Nikola Cornij <nikola.cornij@amd.com>
Reviewed-by: Zhan Liu <zhan.liu@amd.com>
Tested-by: Zhan Liu <zhan.liu@amd.com>
Tested-by: Oliver Logush <oliver.logush@amd.com>
Signed-off-by: Zhan Liu <zhan.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/dcn301/dcn301_resource.c   | 96 +------------------
 1 file changed, 1 insertion(+), 95 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
index 472696f949ac..63b09c1124c4 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
@@ -1622,106 +1622,12 @@ static void dcn301_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *b
 	dml_init_instance(&dc->dml, &dcn3_01_soc, &dcn3_01_ip, DML_PROJECT_DCN30);
 }
 
-static void calculate_wm_set_for_vlevel(
-		int vlevel,
-		struct wm_range_table_entry *table_entry,
-		struct dcn_watermarks *wm_set,
-		struct display_mode_lib *dml,
-		display_e2e_pipe_params_st *pipes,
-		int pipe_cnt)
-{
-	double dram_clock_change_latency_cached = dml->soc.dram_clock_change_latency_us;
-
-	ASSERT(vlevel < dml->soc.num_states);
-	/* only pipe 0 is read for voltage and dcf/soc clocks */
-	pipes[0].clks_cfg.voltage = vlevel;
-	pipes[0].clks_cfg.dcfclk_mhz = dml->soc.clock_limits[vlevel].dcfclk_mhz;
-	pipes[0].clks_cfg.socclk_mhz = dml->soc.clock_limits[vlevel].socclk_mhz;
-
-	dml->soc.dram_clock_change_latency_us = table_entry->pstate_latency_us;
-	dml->soc.sr_exit_time_us = table_entry->sr_exit_time_us;
-	dml->soc.sr_enter_plus_exit_time_us = table_entry->sr_enter_plus_exit_time_us;
-
-	wm_set->urgent_ns = get_wm_urgent(dml, pipes, pipe_cnt) * 1000;
-	wm_set->cstate_pstate.cstate_enter_plus_exit_ns = get_wm_stutter_enter_exit(dml, pipes, pipe_cnt) * 1000;
-	wm_set->cstate_pstate.cstate_exit_ns = get_wm_stutter_exit(dml, pipes, pipe_cnt) * 1000;
-	wm_set->cstate_pstate.pstate_change_ns = get_wm_dram_clock_change(dml, pipes, pipe_cnt) * 1000;
-	wm_set->pte_meta_urgent_ns = get_wm_memory_trip(dml, pipes, pipe_cnt) * 1000;
-	wm_set->frac_urg_bw_nom = get_fraction_of_urgent_bandwidth(dml, pipes, pipe_cnt) * 1000;
-	wm_set->frac_urg_bw_flip = get_fraction_of_urgent_bandwidth_imm_flip(dml, pipes, pipe_cnt) * 1000;
-	wm_set->urgent_latency_ns = get_urgent_latency(dml, pipes, pipe_cnt) * 1000;
-	dml->soc.dram_clock_change_latency_us = dram_clock_change_latency_cached;
-
-}
-
-static void dcn301_calculate_wm_and_dlg(
-		struct dc *dc, struct dc_state *context,
-		display_e2e_pipe_params_st *pipes,
-		int pipe_cnt,
-		int vlevel_req)
-{
-	int i, pipe_idx;
-	int vlevel, vlevel_max;
-	struct wm_range_table_entry *table_entry;
-	struct clk_bw_params *bw_params = dc->clk_mgr->bw_params;
-
-	ASSERT(bw_params);
-
-	vlevel_max = bw_params->clk_table.num_entries - 1;
-
-	/* WM Set D */
-	table_entry = &bw_params->wm_table.entries[WM_D];
-	if (table_entry->wm_type == WM_TYPE_RETRAINING)
-		vlevel = 0;
-	else
-		vlevel = vlevel_max;
-	calculate_wm_set_for_vlevel(vlevel, table_entry, &context->bw_ctx.bw.dcn.watermarks.d,
-						&context->bw_ctx.dml, pipes, pipe_cnt);
-	/* WM Set C */
-	table_entry = &bw_params->wm_table.entries[WM_C];
-	vlevel = min(max(vlevel_req, 2), vlevel_max);
-	calculate_wm_set_for_vlevel(vlevel, table_entry, &context->bw_ctx.bw.dcn.watermarks.c,
-						&context->bw_ctx.dml, pipes, pipe_cnt);
-	/* WM Set B */
-	table_entry = &bw_params->wm_table.entries[WM_B];
-	vlevel = min(max(vlevel_req, 1), vlevel_max);
-	calculate_wm_set_for_vlevel(vlevel, table_entry, &context->bw_ctx.bw.dcn.watermarks.b,
-						&context->bw_ctx.dml, pipes, pipe_cnt);
-
-	/* WM Set A */
-	table_entry = &bw_params->wm_table.entries[WM_A];
-	vlevel = min(vlevel_req, vlevel_max);
-	calculate_wm_set_for_vlevel(vlevel, table_entry, &context->bw_ctx.bw.dcn.watermarks.a,
-						&context->bw_ctx.dml, pipes, pipe_cnt);
-
-	for (i = 0, pipe_idx = 0; i < dc->res_pool->pipe_count; i++) {
-		if (!context->res_ctx.pipe_ctx[i].stream)
-			continue;
-
-		pipes[pipe_idx].clks_cfg.dispclk_mhz = get_dispclk_calculated(&context->bw_ctx.dml, pipes, pipe_cnt);
-		pipes[pipe_idx].clks_cfg.dppclk_mhz = get_dppclk_calculated(&context->bw_ctx.dml, pipes, pipe_cnt, pipe_idx);
-
-		if (dc->config.forced_clocks) {
-			pipes[pipe_idx].clks_cfg.dispclk_mhz = context->bw_ctx.dml.soc.clock_limits[0].dispclk_mhz;
-			pipes[pipe_idx].clks_cfg.dppclk_mhz = context->bw_ctx.dml.soc.clock_limits[0].dppclk_mhz;
-		}
-		if (dc->debug.min_disp_clk_khz > pipes[pipe_idx].clks_cfg.dispclk_mhz * 1000)
-			pipes[pipe_idx].clks_cfg.dispclk_mhz = dc->debug.min_disp_clk_khz / 1000.0;
-		if (dc->debug.min_dpp_clk_khz > pipes[pipe_idx].clks_cfg.dppclk_mhz * 1000)
-			pipes[pipe_idx].clks_cfg.dppclk_mhz = dc->debug.min_dpp_clk_khz / 1000.0;
-
-		pipe_idx++;
-	}
-
-	dcn20_calculate_dlg_params(dc, context, pipes, pipe_cnt, vlevel);
-}
-
 static struct resource_funcs dcn301_res_pool_funcs = {
 	.destroy = dcn301_destroy_resource_pool,
 	.link_enc_create = dcn301_link_encoder_create,
 	.panel_cntl_create = dcn301_panel_cntl_create,
 	.validate_bandwidth = dcn30_validate_bandwidth,
-	.calculate_wm_and_dlg = dcn301_calculate_wm_and_dlg,
+	.calculate_wm_and_dlg = dcn30_calculate_wm_and_dlg,
 	.update_soc_for_wm_a = dcn30_update_soc_for_wm_a,
 	.populate_dml_pipes = dcn30_populate_dml_pipes_from_context,
 	.acquire_idle_pipe_for_layer = dcn20_acquire_idle_pipe_for_layer,
-- 
2.30.2

