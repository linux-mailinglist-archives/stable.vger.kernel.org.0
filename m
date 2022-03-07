Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 357084CF6CB
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238189AbiCGJmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:42:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241060AbiCGJls (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989916D973;
        Mon,  7 Mar 2022 01:39:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38F65611D5;
        Mon,  7 Mar 2022 09:39:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0CFC340F4;
        Mon,  7 Mar 2022 09:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645984;
        bh=SNmdDb/KWY/UBhJnHPu+wPZKAzGOM7GjBTFAMw0j1cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WvmQHur5GBZsOinvyhJfznJnzrqtiEehXDNQWs95uzQEC+yZmmuItouGJTUf2UatP
         EufewXn1aiYXxfrDydXYwe5LiyQel8ZYu+XBrEnWPPjXzTvzpRHMbGnAv8F6OnVrcf
         HX2bb3R6MraU+KLGU6Acb9wVPKGOwkclOyWBrMjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhan Liu <zhan.liu@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Nikola Cornij <nikola.cornij@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 099/262] drm/amd/display: Use adjusted DCN301 watermarks
Date:   Mon,  7 Mar 2022 10:17:23 +0100
Message-Id: <20220307091705.274209090@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikola Cornij <nikola.cornij@amd.com>

[ Upstream commit 808643ea56a2f96a42873d5e11c399957d6493aa ]

[why]
If DCN30 watermark calc is used for DCN301, the calculated values are
wrong due to the data structure mismatch between DCN30 and DCN301.
However, using the original DCN301 watermark values causes underflow.

[how]
- Add DCN21-style watermark calculations
- Adjust DCN301 watermark values to remove the underflow

Reviewed-by: Zhan Liu <zhan.liu@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Nikola Cornij <nikola.cornij@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../display/dc/clk_mgr/dcn301/vg_clk_mgr.c    |  4 +-
 .../amd/display/dc/dcn301/dcn301_resource.c   | 96 ++++++++++++++++++-
 2 files changed, 97 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c
index 7046da14bb2a5..3eee32faa208c 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c
@@ -582,8 +582,8 @@ static struct wm_table lpddr5_wm_table = {
 			.wm_inst = WM_A,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.65333,
-			.sr_exit_time_us = 5.32,
-			.sr_enter_plus_exit_time_us = 6.38,
+			.sr_exit_time_us = 7.95,
+			.sr_enter_plus_exit_time_us = 9,
 			.valid = true,
 		},
 		{
diff --git a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
index 26ebe00a55f67..dea358b01791c 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
@@ -1622,12 +1622,106 @@ static void dcn301_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *b
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
 	.update_soc_for_wm_a = dcn30_update_soc_for_wm_a,
 	.populate_dml_pipes = dcn30_populate_dml_pipes_from_context,
 	.acquire_idle_pipe_for_layer = dcn20_acquire_idle_pipe_for_layer,
-- 
2.34.1



