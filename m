Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10FCF5901B7
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235751AbiHKPxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235877AbiHKPxR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:53:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B1397D74;
        Thu, 11 Aug 2022 08:44:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3FAB616C5;
        Thu, 11 Aug 2022 15:44:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E8BC433D7;
        Thu, 11 Aug 2022 15:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232689;
        bh=lUIIInpb1mZbIG1/Rqh5tRD1Ox6ZtSk+BkiautnqUFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iVXRkyzaZbhSsghWeEZrRSdd1mJtCAd5pgaBqTMJ626kvMSGe+FteDAGsN2tTi+1D
         617Zveavva0kW0I1CTUQV+Yw7ycbznPnGDIfLjGtGGSZO8uAyjGaMBNh1zIWuRS5fy
         sYxaYv9cYubfTlAsGte4Ww4t9o/p1Glm4vu1sOQULfRovpqJIj8CsKuJ1VL5kuSQPU
         dDS0s6j+yHnaguBWm6Ns3JNOfAFGZOpxfQZG7a9UMS9TEFN6wI9Qp+c6ftOe1I87bh
         tlP2cRX1CG5K6aQvlRv7SlKU5kn/X6ohbcmEXyYzBtT5n8X0oF4JRpVCE6yiDwvQRa
         OFu0US22MG9DQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Hamza Mahfooz <hamza.mahfooz@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, sunpeng.li@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, mwen@igalia.com, HaoPing.Liu@amd.com,
        Nicholas.Kazlauskas@amd.com, Eric.Yang2@amd.com,
        gabe.teeger@amd.com, qingqing.zhuo@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.18 17/93] drm/amd/display: Reduce frame size in the bouding box for DCN20
Date:   Thu, 11 Aug 2022 11:41:11 -0400
Message-Id: <20220811154237.1531313-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811154237.1531313-1-sashal@kernel.org>
References: <20220811154237.1531313-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

[ Upstream commit c55300ad4a1814bac9191a4d2c7b0d74273aec7c ]

GCC throw warnings for the function dcn20_update_bounding_box due to its
frame size that looks like this:

 error: the frame size of 1936 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]

This commit fixes this issue by eliminating an intermediary variable
that creates a large array.

Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Hamza Mahfooz <hamza.mahfooz@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/dml/dcn20/dcn20_fpu.c  | 38 +++++++++----------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c
index f93af45aeab4..c758f84baaf5 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c
@@ -1430,21 +1430,20 @@ void dcn20_calculate_wm(
 void dcn20_update_bounding_box(struct dc *dc, struct _vcs_dpi_soc_bounding_box_st *bb,
 		struct pp_smu_nv_clock_table *max_clocks, unsigned int *uclk_states, unsigned int num_states)
 {
-	struct _vcs_dpi_voltage_scaling_st calculated_states[DC__VOLTAGE_STATES];
-	int i;
 	int num_calculated_states = 0;
 	int min_dcfclk = 0;
+	int i;
 
 	dc_assert_fp_enabled();
 
 	if (num_states == 0)
 		return;
 
-	memset(calculated_states, 0, sizeof(calculated_states));
+	memset(bb->clock_limits, 0, sizeof(bb->clock_limits));
 
-	if (dc->bb_overrides.min_dcfclk_mhz > 0)
+	if (dc->bb_overrides.min_dcfclk_mhz > 0) {
 		min_dcfclk = dc->bb_overrides.min_dcfclk_mhz;
-	else {
+	} else {
 		if (ASICREV_IS_NAVI12_P(dc->ctx->asic_id.hw_internal_rev))
 			min_dcfclk = 310;
 		else
@@ -1455,36 +1454,35 @@ void dcn20_update_bounding_box(struct dc *dc, struct _vcs_dpi_soc_bounding_box_s
 
 	for (i = 0; i < num_states; i++) {
 		int min_fclk_required_by_uclk;
-		calculated_states[i].state = i;
-		calculated_states[i].dram_speed_mts = uclk_states[i] * 16 / 1000;
+		bb->clock_limits[i].state = i;
+		bb->clock_limits[i].dram_speed_mts = uclk_states[i] * 16 / 1000;
 
 		// FCLK:UCLK ratio is 1.08
 		min_fclk_required_by_uclk = div_u64(((unsigned long long)uclk_states[i]) * 1080,
 			1000000);
 
-		calculated_states[i].fabricclk_mhz = (min_fclk_required_by_uclk < min_dcfclk) ?
+		bb->clock_limits[i].fabricclk_mhz = (min_fclk_required_by_uclk < min_dcfclk) ?
 				min_dcfclk : min_fclk_required_by_uclk;
 
-		calculated_states[i].socclk_mhz = (calculated_states[i].fabricclk_mhz > max_clocks->socClockInKhz / 1000) ?
-				max_clocks->socClockInKhz / 1000 : calculated_states[i].fabricclk_mhz;
+		bb->clock_limits[i].socclk_mhz = (bb->clock_limits[i].fabricclk_mhz > max_clocks->socClockInKhz / 1000) ?
+				max_clocks->socClockInKhz / 1000 : bb->clock_limits[i].fabricclk_mhz;
 
-		calculated_states[i].dcfclk_mhz = (calculated_states[i].fabricclk_mhz > max_clocks->dcfClockInKhz / 1000) ?
-				max_clocks->dcfClockInKhz / 1000 : calculated_states[i].fabricclk_mhz;
+		bb->clock_limits[i].dcfclk_mhz = (bb->clock_limits[i].fabricclk_mhz > max_clocks->dcfClockInKhz / 1000) ?
+				max_clocks->dcfClockInKhz / 1000 : bb->clock_limits[i].fabricclk_mhz;
 
-		calculated_states[i].dispclk_mhz = max_clocks->displayClockInKhz / 1000;
-		calculated_states[i].dppclk_mhz = max_clocks->displayClockInKhz / 1000;
-		calculated_states[i].dscclk_mhz = max_clocks->displayClockInKhz / (1000 * 3);
+		bb->clock_limits[i].dispclk_mhz = max_clocks->displayClockInKhz / 1000;
+		bb->clock_limits[i].dppclk_mhz = max_clocks->displayClockInKhz / 1000;
+		bb->clock_limits[i].dscclk_mhz = max_clocks->displayClockInKhz / (1000 * 3);
 
-		calculated_states[i].phyclk_mhz = max_clocks->phyClockInKhz / 1000;
+		bb->clock_limits[i].phyclk_mhz = max_clocks->phyClockInKhz / 1000;
 
 		num_calculated_states++;
 	}
 
-	calculated_states[num_calculated_states - 1].socclk_mhz = max_clocks->socClockInKhz / 1000;
-	calculated_states[num_calculated_states - 1].fabricclk_mhz = max_clocks->socClockInKhz / 1000;
-	calculated_states[num_calculated_states - 1].dcfclk_mhz = max_clocks->dcfClockInKhz / 1000;
+	bb->clock_limits[num_calculated_states - 1].socclk_mhz = max_clocks->socClockInKhz / 1000;
+	bb->clock_limits[num_calculated_states - 1].fabricclk_mhz = max_clocks->socClockInKhz / 1000;
+	bb->clock_limits[num_calculated_states - 1].dcfclk_mhz = max_clocks->dcfClockInKhz / 1000;
 
-	memcpy(bb->clock_limits, calculated_states, sizeof(bb->clock_limits));
 	bb->num_states = num_calculated_states;
 
 	// Duplicate the last state, DML always an extra state identical to max state to work
-- 
2.35.1

