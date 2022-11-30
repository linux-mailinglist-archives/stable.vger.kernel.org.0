Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF7C63E020
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbiK3Sxw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:53:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbiK3Sxt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:53:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5936C20198
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:53:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C66AAB81CA9
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7AFDC433D6;
        Wed, 30 Nov 2022 18:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834424;
        bh=1Rfb2oc7NrSB4db+j1UuO7mUlYzt+qjigoSBnL2+3Ng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HGL8q/9W7Km1gWngh+nTvBEwOuBqCyhT5EBvccM4nOOsotj8mc0IWsVnfBtz+wmNr
         +B9MnRAwlUts70WvNC3XjybnXUauJIriObJ7V0Kmk75dapOGOq/qbJBTrmUpqC5JAk
         lQeBT3usjl/xY71P/ioExnrMwoG6F9CR7IT6agUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jun Lei <Jun.Lei@amd.com>,
        Tom Chung <chiahsuan.chung@amd.com>,
        Dillon Varone <Dillon.Varone@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 248/289] drm/amd/display: use uclk pstate latency for fw assisted mclk validation dcn32
Date:   Wed, 30 Nov 2022 19:23:53 +0100
Message-Id: <20221130180549.729501952@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



