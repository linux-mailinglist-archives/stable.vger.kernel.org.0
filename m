Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C641E33E3A7
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 01:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbhCQA5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:57:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:33804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230094AbhCQA4d (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:56:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 280E964F9C;
        Wed, 17 Mar 2021 00:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942593;
        bh=5rIhYsyhLKT6aAO0BKtbxp2bcFQuLbnBCgGvZd217ow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nc8nOI4Vpsnh2R/oamEd7onMSZH504Jgfxfv69QRJPnPjDXihrLqwx/aW2TSn+AXO
         Jik5WnPB1IUi++/T6jVN7n9uW0TPLN25t7TspFZHgDgajRbexOXzjfVSQUCXQ/tV3a
         d0krwJCS6shffbQMoHevFa/2wXgR3DBKtKLdL7u4tNOTLg+svO7/FQ1ADkxT+mT5rF
         8SwuwuFUvRNRdxAxhZNETCvgTsC6sQgITISsy5oiXV97/AY1N/RWS8IKP5wBlJP6WI
         0j8BcyMvrAYyah4dKnimpgMyvDiclyo/XB3Og9Gx5H09bYOWcEZTlum79Y5Oj51RbJ
         FucLaspOyE1/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhan Liu <zhan.liu@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.11 46/61] drm/amdgpu/display: Use wm_table.entries for dcn301 calculate_wm
Date:   Tue, 16 Mar 2021 20:55:20 -0400
Message-Id: <20210317005536.724046-46-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhan Liu <zhan.liu@amd.com>

[ Upstream commit eda29602f1a8b2b32d8c8c354232d9d1ee1c064d ]

[Why]
For DGPU Navi, the wm_table.nv_entries are used. These entires are not
populated for DCN301 Vangogh APU, but instead wm_table.entries are.

[How]
Use DCN21 Renoir style wm calculations.

Signed-off-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Zhan Liu <zhan.liu@amd.com>
Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Acked-by: Zhan Liu <zhan.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/dcn301/dcn301_resource.c   | 96 ++++++++++++++++++-
 1 file changed, 95 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
index 35f5bf08ae96..23bc208cbfa4 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
@@ -1722,12 +1722,106 @@ static void dcn301_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *b
 	dml_init_instance(&dc->dml, &dcn3_01_soc, &dcn3_01_ip, DML_PROJECT_DCN30);
 }
 
+static void calculate_wm_set_for_vlevel(
+		int vlevel,
+		struct wm_range_table_entry *table_entry,
+		struct dcn_watermarks *wm_set,
+		struct display_mode_lib *dml,
+		display_e2e_pipe_params_st *pipes,
+		int pipe_cnt)
+{
+	double dram_clock_change_latency_cached = dml->soc.dram_clock_change_latency_us;
+
+	ASSERT(vlevel < dml->soc.num_states);
+	/* only pipe 0 is read for voltage and dcf/soc clocks */
+	pipes[0].clks_cfg.voltage = vlevel;
+	pipes[0].clks_cfg.dcfclk_mhz = dml->soc.clock_limits[vlevel].dcfclk_mhz;
+	pipes[0].clks_cfg.socclk_mhz = dml->soc.clock_limits[vlevel].socclk_mhz;
+
+	dml->soc.dram_clock_change_latency_us = table_entry->pstate_latency_us;
+	dml->soc.sr_exit_time_us = table_entry->sr_exit_time_us;
+	dml->soc.sr_enter_plus_exit_time_us = table_entry->sr_enter_plus_exit_time_us;
+
+	wm_set->urgent_ns = get_wm_urgent(dml, pipes, pipe_cnt) * 1000;
+	wm_set->cstate_pstate.cstate_enter_plus_exit_ns = get_wm_stutter_enter_exit(dml, pipes, pipe_cnt) * 1000;
+	wm_set->cstate_pstate.cstate_exit_ns = get_wm_stutter_exit(dml, pipes, pipe_cnt) * 1000;
+	wm_set->cstate_pstate.pstate_change_ns = get_wm_dram_clock_change(dml, pipes, pipe_cnt) * 1000;
+	wm_set->pte_meta_urgent_ns = get_wm_memory_trip(dml, pipes, pipe_cnt) * 1000;
+	wm_set->frac_urg_bw_nom = get_fraction_of_urgent_bandwidth(dml, pipes, pipe_cnt) * 1000;
+	wm_set->frac_urg_bw_flip = get_fraction_of_urgent_bandwidth_imm_flip(dml, pipes, pipe_cnt) * 1000;
+	wm_set->urgent_latency_ns = get_urgent_latency(dml, pipes, pipe_cnt) * 1000;
+	dml->soc.dram_clock_change_latency_us = dram_clock_change_latency_cached;
+
+}
+
+static void dcn301_calculate_wm_and_dlg(
+		struct dc *dc, struct dc_state *context,
+		display_e2e_pipe_params_st *pipes,
+		int pipe_cnt,
+		int vlevel_req)
+{
+	int i, pipe_idx;
+	int vlevel, vlevel_max;
+	struct wm_range_table_entry *table_entry;
+	struct clk_bw_params *bw_params = dc->clk_mgr->bw_params;
+
+	ASSERT(bw_params);
+
+	vlevel_max = bw_params->clk_table.num_entries - 1;
+
+	/* WM Set D */
+	table_entry = &bw_params->wm_table.entries[WM_D];
+	if (table_entry->wm_type == WM_TYPE_RETRAINING)
+		vlevel = 0;
+	else
+		vlevel = vlevel_max;
+	calculate_wm_set_for_vlevel(vlevel, table_entry, &context->bw_ctx.bw.dcn.watermarks.d,
+						&context->bw_ctx.dml, pipes, pipe_cnt);
+	/* WM Set C */
+	table_entry = &bw_params->wm_table.entries[WM_C];
+	vlevel = min(max(vlevel_req, 2), vlevel_max);
+	calculate_wm_set_for_vlevel(vlevel, table_entry, &context->bw_ctx.bw.dcn.watermarks.c,
+						&context->bw_ctx.dml, pipes, pipe_cnt);
+	/* WM Set B */
+	table_entry = &bw_params->wm_table.entries[WM_B];
+	vlevel = min(max(vlevel_req, 1), vlevel_max);
+	calculate_wm_set_for_vlevel(vlevel, table_entry, &context->bw_ctx.bw.dcn.watermarks.b,
+						&context->bw_ctx.dml, pipes, pipe_cnt);
+
+	/* WM Set A */
+	table_entry = &bw_params->wm_table.entries[WM_A];
+	vlevel = min(vlevel_req, vlevel_max);
+	calculate_wm_set_for_vlevel(vlevel, table_entry, &context->bw_ctx.bw.dcn.watermarks.a,
+						&context->bw_ctx.dml, pipes, pipe_cnt);
+
+	for (i = 0, pipe_idx = 0; i < dc->res_pool->pipe_count; i++) {
+		if (!context->res_ctx.pipe_ctx[i].stream)
+			continue;
+
+		pipes[pipe_idx].clks_cfg.dispclk_mhz = get_dispclk_calculated(&context->bw_ctx.dml, pipes, pipe_cnt);
+		pipes[pipe_idx].clks_cfg.dppclk_mhz = get_dppclk_calculated(&context->bw_ctx.dml, pipes, pipe_cnt, pipe_idx);
+
+		if (dc->config.forced_clocks) {
+			pipes[pipe_idx].clks_cfg.dispclk_mhz = context->bw_ctx.dml.soc.clock_limits[0].dispclk_mhz;
+			pipes[pipe_idx].clks_cfg.dppclk_mhz = context->bw_ctx.dml.soc.clock_limits[0].dppclk_mhz;
+		}
+		if (dc->debug.min_disp_clk_khz > pipes[pipe_idx].clks_cfg.dispclk_mhz * 1000)
+			pipes[pipe_idx].clks_cfg.dispclk_mhz = dc->debug.min_disp_clk_khz / 1000.0;
+		if (dc->debug.min_dpp_clk_khz > pipes[pipe_idx].clks_cfg.dppclk_mhz * 1000)
+			pipes[pipe_idx].clks_cfg.dppclk_mhz = dc->debug.min_dpp_clk_khz / 1000.0;
+
+		pipe_idx++;
+	}
+
+	dcn20_calculate_dlg_params(dc, context, pipes, pipe_cnt, vlevel);
+}
+
 static struct resource_funcs dcn301_res_pool_funcs = {
 	.destroy = dcn301_destroy_resource_pool,
 	.link_enc_create = dcn301_link_encoder_create,
 	.panel_cntl_create = dcn301_panel_cntl_create,
 	.validate_bandwidth = dcn30_validate_bandwidth,
-	.calculate_wm_and_dlg = dcn30_calculate_wm_and_dlg,
+	.calculate_wm_and_dlg = dcn301_calculate_wm_and_dlg,
 	.populate_dml_pipes = dcn30_populate_dml_pipes_from_context,
 	.acquire_idle_pipe_for_layer = dcn20_acquire_idle_pipe_for_layer,
 	.add_stream_to_ctx = dcn30_add_stream_to_ctx,
-- 
2.30.1

