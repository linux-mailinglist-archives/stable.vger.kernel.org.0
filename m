Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7285F998E
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbiJJHOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231929AbiJJHNB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:13:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8571A5EDC2;
        Mon, 10 Oct 2022 00:08:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EE1560E83;
        Mon, 10 Oct 2022 07:07:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638B2C433D6;
        Mon, 10 Oct 2022 07:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385636;
        bh=a9bbk+n0W6zEVK5wtX4ovn8t+np19o3n6a3wg1jiUlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IrTWebEBC6Mv83AYdPLHht6X/eDq5LDro/AVoh3akg4MgBWbFbemQ9dss2OM5P+fU
         27L5G9CdV9Zuf0DnZGhKzR8rX8Pys5nSMvIEkP1IT/9I23UED5w5KgvRG8sVqN/Bdt
         4HcUlSA5lz0kxVnkmGRJ6G+O6QVF0AdrbMITwo3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jun Lei <Jun.Lei@amd.com>,
        Wayne Lin <wayne.lin@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 34/48] drm/amd/display: increase dcn315 pstate change latency
Date:   Mon, 10 Oct 2022 09:05:32 +0200
Message-Id: <20221010070334.579591246@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070333.676316214@linuxfoundation.org>
References: <20221010070333.676316214@linuxfoundation.org>
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

From: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>

[ Upstream commit dcc2527df918edfe297c5074ccc1f05eae361ca6 ]

[Why & How]
Update after new measurment came in

Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dc/clk_mgr/dcn315/dcn315_clk_mgr.c        | 22 ++++++++++++-------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c
index f4381725b210..c3d7712e9fd0 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c
@@ -46,6 +46,9 @@
 #define TO_CLK_MGR_DCN315(clk_mgr)\
 	container_of(clk_mgr, struct clk_mgr_dcn315, base)
 
+#define UNSUPPORTED_DCFCLK 10000000
+#define MIN_DPP_DISP_CLK     100000
+
 static int dcn315_get_active_display_cnt_wa(
 		struct dc *dc,
 		struct dc_state *context)
@@ -146,6 +149,9 @@ static void dcn315_update_clocks(struct clk_mgr *clk_mgr_base,
 		}
 	}
 
+	/* Lock pstate by requesting unsupported dcfclk if change is unsupported */
+	if (!new_clocks->p_state_change_support)
+		new_clocks->dcfclk_khz = UNSUPPORTED_DCFCLK;
 	if (should_set_clock(safe_to_lower, new_clocks->dcfclk_khz, clk_mgr_base->clks.dcfclk_khz)) {
 		clk_mgr_base->clks.dcfclk_khz = new_clocks->dcfclk_khz;
 		dcn315_smu_set_hard_min_dcfclk(clk_mgr, clk_mgr_base->clks.dcfclk_khz);
@@ -159,10 +165,10 @@ static void dcn315_update_clocks(struct clk_mgr *clk_mgr_base,
 
 	// workaround: Limit dppclk to 100Mhz to avoid lower eDP panel switch to plus 4K monitor underflow.
 	if (!IS_DIAG_DC(dc->ctx->dce_environment)) {
-		if (new_clocks->dppclk_khz < 100000)
-			new_clocks->dppclk_khz = 100000;
-		if (new_clocks->dispclk_khz < 100000)
-			new_clocks->dispclk_khz = 100000;
+		if (new_clocks->dppclk_khz < MIN_DPP_DISP_CLK)
+			new_clocks->dppclk_khz = MIN_DPP_DISP_CLK;
+		if (new_clocks->dispclk_khz < MIN_DPP_DISP_CLK)
+			new_clocks->dispclk_khz = MIN_DPP_DISP_CLK;
 	}
 
 	if (should_set_clock(safe_to_lower, new_clocks->dppclk_khz, clk_mgr->base.clks.dppclk_khz)) {
@@ -272,7 +278,7 @@ static struct wm_table ddr5_wm_table = {
 		{
 			.wm_inst = WM_A,
 			.wm_type = WM_TYPE_PSTATE_CHG,
-			.pstate_latency_us = 64.0,
+			.pstate_latency_us = 129.0,
 			.sr_exit_time_us = 11.5,
 			.sr_enter_plus_exit_time_us = 14.5,
 			.valid = true,
@@ -280,7 +286,7 @@ static struct wm_table ddr5_wm_table = {
 		{
 			.wm_inst = WM_B,
 			.wm_type = WM_TYPE_PSTATE_CHG,
-			.pstate_latency_us = 64.0,
+			.pstate_latency_us = 129.0,
 			.sr_exit_time_us = 11.5,
 			.sr_enter_plus_exit_time_us = 14.5,
 			.valid = true,
@@ -288,7 +294,7 @@ static struct wm_table ddr5_wm_table = {
 		{
 			.wm_inst = WM_C,
 			.wm_type = WM_TYPE_PSTATE_CHG,
-			.pstate_latency_us = 64.0,
+			.pstate_latency_us = 129.0,
 			.sr_exit_time_us = 11.5,
 			.sr_enter_plus_exit_time_us = 14.5,
 			.valid = true,
@@ -296,7 +302,7 @@ static struct wm_table ddr5_wm_table = {
 		{
 			.wm_inst = WM_D,
 			.wm_type = WM_TYPE_PSTATE_CHG,
-			.pstate_latency_us = 64.0,
+			.pstate_latency_us = 129.0,
 			.sr_exit_time_us = 11.5,
 			.sr_enter_plus_exit_time_us = 14.5,
 			.valid = true,
-- 
2.35.1



