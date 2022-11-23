Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C89635DB6
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236969AbiKWMoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:44:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237559AbiKWMne (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:43:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296076B383;
        Wed, 23 Nov 2022 04:42:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA00D61C77;
        Wed, 23 Nov 2022 12:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039FCC433D6;
        Wed, 23 Nov 2022 12:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207324;
        bh=1Rfb2oc7NrSB4db+j1UuO7mUlYzt+qjigoSBnL2+3Ng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IomrmY4nk6xz2vOfwy+4+S8rqoFJHkK/h2Cv31c3YqHt3e5ESPM23fAZYJbwfyevT
         pSYasLFpiB3tv+eFVRM0ISLhAf06vxYBWKT15PxjN/g+2GGCFaQkJ6UsFODNp/T8uK
         C3pCgGmRYt0Iadczohd1jCBsXMX91G7wElba9AMHS1evSsD2rbtGUciqAqFCMUSf+Y
         m//SHea4ZeTYkbYx0JMSc/YfoxIiw3d5sESRenCKeHOU2St8itgsO56so4IJMtx+NS
         u37qkYjC2NSq5KTK2Vn3kGIcb50XGdpC1/cShM8SBCaWdgW62Ptst8ZFdSXnuPLOWh
         MA7bAgDXvOArw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dillon Varone <Dillon.Varone@amd.com>, Jun Lei <Jun.Lei@amd.com>,
        Tom Chung <chiahsuan.chung@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, jun.lei@amd.com, Alvin.Lee2@amd.com,
        george.shen@amd.com, samson.tam@amd.com, rdunlap@infradead.org,
        David.Galiffi@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 26/44] drm/amd/display: use uclk pstate latency for fw assisted mclk validation dcn32
Date:   Wed, 23 Nov 2022 07:40:35 -0500
Message-Id: <20221123124057.264822-26-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124057.264822-1-sashal@kernel.org>
References: <20221123124057.264822-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dillon Varone <Dillon.Varone@amd.com>

[ Upstream commit c149947b188c651b943c1d8ca1494d1a98a3e27f ]

[WHY?]
DCN32 uses fclk pstate watermarks for dummy pstate, and must always be
supported.

[HOW?]
Validation needs to be run with fclk pstate latency set
as the dummy pstate latency to get correct prefetch and bandwidth outputs.

Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Dillon Varone <Dillon.Varone@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
index b9d3a4000c3d..6ed76e194423 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -1700,6 +1700,12 @@ void dcn32_calculate_wm_and_dlg_fpu(struct dc *dc, struct dc_state *context,
 			 */
 			context->bw_ctx.dml.soc.dram_clock_change_latency_us =
 					dc->clk_mgr->bw_params->wm_table.nv_entries[WM_A].dml_input.pstate_latency_us;
+			/* For DCN32/321 need to validate with fclk pstate change latency equal to dummy so
+			 * prefetch is scheduled correctly to account for dummy pstate.
+			 */
+			if (dummy_latency_index == 0)
+				context->bw_ctx.dml.soc.fclk_change_latency_us =
+						dc->clk_mgr->bw_params->dummy_pstate_table[dummy_latency_index].dummy_pstate_latency_us;
 			dcn32_internal_validate_bw(dc, context, pipes, &pipe_cnt, &vlevel, false);
 			maxMpcComb = context->bw_ctx.dml.vba.maxMpcComb;
 			dcfclk = context->bw_ctx.dml.vba.DCFCLKState[vlevel][context->bw_ctx.dml.vba.maxMpcComb];
@@ -1879,6 +1885,10 @@ void dcn32_calculate_wm_and_dlg_fpu(struct dc *dc, struct dc_state *context,
 
 	context->perf_params.stutter_period_us = context->bw_ctx.dml.vba.StutterPeriod;
 
+	if (context->bw_ctx.bw.dcn.clk.fw_based_mclk_switching && dummy_latency_index == 0)
+		context->bw_ctx.dml.soc.fclk_change_latency_us =
+				dc->clk_mgr->bw_params->dummy_pstate_table[dummy_latency_index].dummy_pstate_latency_us;
+
 	dcn32_calculate_dlg_params(dc, context, pipes, pipe_cnt, vlevel);
 
 	if (!pstate_en)
@@ -1886,8 +1896,12 @@ void dcn32_calculate_wm_and_dlg_fpu(struct dc *dc, struct dc_state *context,
 		context->bw_ctx.dml.soc.dram_clock_change_latency_us =
 				dc->clk_mgr->bw_params->wm_table.nv_entries[WM_A].dml_input.pstate_latency_us;
 
-	if (context->bw_ctx.bw.dcn.clk.fw_based_mclk_switching)
+	if (context->bw_ctx.bw.dcn.clk.fw_based_mclk_switching) {
 		dcn30_setup_mclk_switch_using_fw_based_vblank_stretch(dc, context);
+		if (dummy_latency_index == 0)
+			context->bw_ctx.dml.soc.fclk_change_latency_us =
+					dc->clk_mgr->bw_params->wm_table.nv_entries[WM_A].dml_input.fclk_change_latency_us;
+	}
 }
 
 static void dcn32_get_optimal_dcfclk_fclk_for_uclk(unsigned int uclk_mts,
-- 
2.35.1

