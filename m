Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4B5627FBE
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237759AbiKNNBr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237720AbiKNNBd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:01:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF73929369
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:01:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F9DBB80EAF
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:01:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E8AC433D6;
        Mon, 14 Nov 2022 13:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430890;
        bh=D3VFXOxIudJqBCNOO6QSrsWWxRkpTu3zW45bzqMdI4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RPi7KIiY3V1wlyoKrvXV0NkbbIiY2z7+XFgAOceHixVM/c5FfcyLGYwBVwzpghb05
         l87m0be0rMB4RTloH2TeNom8NIjlKOwCPhgiGGK9rIdPGL5dE0DJ2HioqOruhj/B66
         3eEqvUmFy22qncgAgEMz7++btoLtDLmD0+/DuWZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Daniel Wheeler <daniel.wheeler@amd.com>,
        Jun Lei <Jun.Lei@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Dillon Varone <Dillon.Varone@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 008/190] drm/amd/display: Acquire FCLK DPM levels on DCN32
Date:   Mon, 14 Nov 2022 13:43:52 +0100
Message-Id: <20221114124459.153939004@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

[ Upstream commit d6170e418d1d3ae7e98cb6d96d1444e880131bbf ]

[Why & How]
Acquire FCLK DPM levels to properly construct DML clock limits. Further
add new logic to keep number of indices for each clock in clk_mgr.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Dillon Varone <Dillon.Varone@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: e59843c4cdd6 ("drm/amd/display: Limit dcn32 to 1950Mhz display clock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c  | 41 ++++++++++++-------
 .../gpu/drm/amd/display/dc/inc/hw/clk_mgr.h   | 15 ++++++-
 2 files changed, 41 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
index f0f3f66629cc..f4c7bbd9961a 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
@@ -156,7 +156,7 @@ void dcn32_init_clocks(struct clk_mgr *clk_mgr_base)
 {
 	struct clk_mgr_internal *clk_mgr = TO_CLK_MGR_INTERNAL(clk_mgr_base);
 	unsigned int num_levels;
-	unsigned int num_dcfclk_levels, num_dtbclk_levels, num_dispclk_levels;
+	struct clk_limit_num_entries *num_entries_per_clk = &clk_mgr_base->bw_params->clk_table.num_entries_per_clk;
 
 	memset(&(clk_mgr_base->clks), 0, sizeof(struct dc_clocks));
 	clk_mgr_base->clks.p_state_change_support = true;
@@ -180,27 +180,28 @@ void dcn32_init_clocks(struct clk_mgr *clk_mgr_base)
 	/* DCFCLK */
 	dcn32_init_single_clock(clk_mgr, PPCLK_DCFCLK,
 			&clk_mgr_base->bw_params->clk_table.entries[0].dcfclk_mhz,
-			&num_levels);
-	num_dcfclk_levels = num_levels;
+			&num_entries_per_clk->num_dcfclk_levels);
 
 	/* SOCCLK */
 	dcn32_init_single_clock(clk_mgr, PPCLK_SOCCLK,
 					&clk_mgr_base->bw_params->clk_table.entries[0].socclk_mhz,
-					&num_levels);
+					&num_entries_per_clk->num_socclk_levels);
+
 	/* DTBCLK */
 	if (!clk_mgr->base.ctx->dc->debug.disable_dtb_ref_clk_switch)
 		dcn32_init_single_clock(clk_mgr, PPCLK_DTBCLK,
 				&clk_mgr_base->bw_params->clk_table.entries[0].dtbclk_mhz,
-				&num_levels);
-	num_dtbclk_levels = num_levels;
+				&num_entries_per_clk->num_dtbclk_levels);
 
 	/* DISPCLK */
 	dcn32_init_single_clock(clk_mgr, PPCLK_DISPCLK,
 			&clk_mgr_base->bw_params->clk_table.entries[0].dispclk_mhz,
-			&num_levels);
-	num_dispclk_levels = num_levels;
+			&num_entries_per_clk->num_dispclk_levels);
+	num_levels = num_entries_per_clk->num_dispclk_levels;
 
-	if (num_dcfclk_levels && num_dtbclk_levels && num_dispclk_levels)
+	if (num_entries_per_clk->num_dcfclk_levels &&
+			num_entries_per_clk->num_dtbclk_levels &&
+			num_entries_per_clk->num_dispclk_levels)
 		clk_mgr->dpm_present = true;
 
 	if (clk_mgr_base->ctx->dc->debug.min_disp_clk_khz) {
@@ -370,7 +371,7 @@ static void dcn32_update_clocks(struct clk_mgr *clk_mgr_base,
 			/* to disable P-State switching, set UCLK min = max */
 			if (!clk_mgr_base->clks.p_state_change_support)
 				dcn32_smu_set_hard_min_by_freq(clk_mgr, PPCLK_UCLK,
-						clk_mgr_base->bw_params->clk_table.entries[clk_mgr_base->bw_params->clk_table.num_entries - 1].memclk_mhz);
+						clk_mgr_base->bw_params->clk_table.entries[clk_mgr_base->bw_params->clk_table.num_entries_per_clk.num_memclk_levels - 1].memclk_mhz);
 		}
 
 		if (should_update_pstate_support(safe_to_lower, fclk_p_state_change_support, clk_mgr_base->clks.fclk_p_state_change_support) &&
@@ -632,7 +633,7 @@ static void dcn32_set_hard_min_memclk(struct clk_mgr *clk_mgr_base, bool current
 					khz_to_mhz_ceil(clk_mgr_base->clks.dramclk_khz));
 		else
 			dcn32_smu_set_hard_min_by_freq(clk_mgr, PPCLK_UCLK,
-					clk_mgr_base->bw_params->clk_table.entries[clk_mgr_base->bw_params->clk_table.num_entries - 1].memclk_mhz);
+					clk_mgr_base->bw_params->clk_table.entries[clk_mgr_base->bw_params->clk_table.num_entries_per_clk.num_memclk_levels - 1].memclk_mhz);
 	} else {
 		dcn32_smu_set_hard_min_by_freq(clk_mgr, PPCLK_UCLK,
 				clk_mgr_base->bw_params->clk_table.entries[0].memclk_mhz);
@@ -648,22 +649,34 @@ static void dcn32_set_hard_max_memclk(struct clk_mgr *clk_mgr_base)
 		return;
 
 	dcn30_smu_set_hard_max_by_freq(clk_mgr, PPCLK_UCLK,
-			clk_mgr_base->bw_params->clk_table.entries[clk_mgr_base->bw_params->clk_table.num_entries - 1].memclk_mhz);
+			clk_mgr_base->bw_params->clk_table.entries[clk_mgr_base->bw_params->clk_table.num_entries_per_clk.num_memclk_levels - 1].memclk_mhz);
 }
 
 /* Get current memclk states, update bounding box */
 static void dcn32_get_memclk_states_from_smu(struct clk_mgr *clk_mgr_base)
 {
 	struct clk_mgr_internal *clk_mgr = TO_CLK_MGR_INTERNAL(clk_mgr_base);
+	struct clk_limit_num_entries *num_entries_per_clk = &clk_mgr_base->bw_params->clk_table.num_entries_per_clk;
 	unsigned int num_levels;
 
 	if (!clk_mgr->smu_present)
 		return;
 
-	/* Refresh memclk states */
+	/* Refresh memclk and fclk states */
 	dcn32_init_single_clock(clk_mgr, PPCLK_UCLK,
 			&clk_mgr_base->bw_params->clk_table.entries[0].memclk_mhz,
-			&num_levels);
+			&num_entries_per_clk->num_memclk_levels);
+
+	dcn32_init_single_clock(clk_mgr, PPCLK_FCLK,
+			&clk_mgr_base->bw_params->clk_table.entries[0].fclk_mhz,
+			&num_entries_per_clk->num_fclk_levels);
+
+	if (num_entries_per_clk->num_memclk_levels >= num_entries_per_clk->num_fclk_levels) {
+		num_levels = num_entries_per_clk->num_memclk_levels;
+	} else {
+		num_levels = num_entries_per_clk->num_fclk_levels;
+	}
+
 	clk_mgr_base->bw_params->clk_table.num_entries = num_levels ? num_levels : 1;
 
 	if (clk_mgr->dpm_present && !num_levels)
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw/clk_mgr.h b/drivers/gpu/drm/amd/display/dc/inc/hw/clk_mgr.h
index d9f1b0a4fbd4..591ab1389e3b 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw/clk_mgr.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw/clk_mgr.h
@@ -95,10 +95,23 @@ struct clk_limit_table_entry {
 	unsigned int wck_ratio;
 };
 
+struct clk_limit_num_entries {
+	unsigned int num_dcfclk_levels;
+	unsigned int num_fclk_levels;
+	unsigned int num_memclk_levels;
+	unsigned int num_socclk_levels;
+	unsigned int num_dtbclk_levels;
+	unsigned int num_dispclk_levels;
+	unsigned int num_dppclk_levels;
+	unsigned int num_phyclk_levels;
+	unsigned int num_phyclk_d18_levels;
+};
+
 /* This table is contiguous */
 struct clk_limit_table {
 	struct clk_limit_table_entry entries[MAX_NUM_DPM_LVL];
-	unsigned int num_entries;
+	struct clk_limit_num_entries num_entries_per_clk;
+	unsigned int num_entries; /* highest populated dpm level for back compatibility */
 };
 
 struct wm_range_table_entry {
-- 
2.35.1



