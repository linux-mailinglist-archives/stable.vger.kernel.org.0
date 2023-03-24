Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 114336C783D
	for <lists+stable@lfdr.de>; Fri, 24 Mar 2023 07:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbjCXGwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Mar 2023 02:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbjCXGwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Mar 2023 02:52:17 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2040.outbound.protection.outlook.com [40.107.92.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193B4244BC
        for <stable@vger.kernel.org>; Thu, 23 Mar 2023 23:52:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XBKlvzpME6T4e79DoYGhKdEFQtxVCu6PVa31AOtw8X62A58Gz7yYTHUqsRsNg1DFzecXJ1df41cGt+3K9S1v/hGBj7c3RvHTmE5z3iRRBQkhBpJ4OiYw+xukA/Q0Mt6wyM+CbtJrdwuPhix4n0ztAqr+w+VSLL3cVo2mdmWu/p6M5YHQ0ZzL85KrInSAzvw7bc40RX8MEaIBXpJdb2YP51QotvLz8lbx8z7easEAQxCuzg5X3xRckAPBqkOQssZT2bAQqEYHpzT/DeiV1wHVfWVPPIoXe+oiRg5hDto5RK2Wru/zPE4YD3pT27siyzfUDEsIoNx82MhM/rMAyAeMVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bcXN5YwHbRNJcvApHSo1ebsQw2cqaSmCk0GtifBGQpc=;
 b=X0fDfo1kW0iOY9aYNybR9Dnu9ysVtV+minEBXPlto5D+LpIocsW1eE08StU3nyvT0aEhZdO+f4HPRkl9lcpKUmHr/KuSH0Ntj7rQJMymnWYY+RrzhnwqE6qWP4Rp6cmU9o7aiwPHynj1z5a8D/xRkbh8By0VVagY+1nnUpePU0GN+5XsmRtCYnL1Vg8FeP8bQ3ymmY8a9QOAgcG8mAWcnBvDl5ypcZQPbIjrXKA1+srZmdWhIRmPVtcytPqhU9y9CEdrgrtqwcgswNB+Uw1ZyKd4w9Gs1F7vdqY4vwHq8wyuUqdPmtRThian3qSrfIghovRO5w/pCPhm9LzyFhVylg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bcXN5YwHbRNJcvApHSo1ebsQw2cqaSmCk0GtifBGQpc=;
 b=jWW1wLxxY242BB+ofTehGTms8518SXB4QzaVW/81jE07Pj5i/BfRYkTdhGkyFjdQzss/PPuVbiFhxmqLv1N6RJ1yiQ3FBd7u7YDaWYDLLFXEicsaJriWVTTOd6p3ZWXZwcQVWQS0QhMSO8e97eiZyT00HCojq1lbylT2OEtJzEU=
Received: from MW4PR03CA0269.namprd03.prod.outlook.com (2603:10b6:303:b4::34)
 by CH2PR12MB4310.namprd12.prod.outlook.com (2603:10b6:610:a9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Fri, 24 Mar
 2023 06:52:07 +0000
Received: from CO1NAM11FT099.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b4:cafe::33) by MW4PR03CA0269.outlook.office365.com
 (2603:10b6:303:b4::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38 via Frontend
 Transport; Fri, 24 Mar 2023 06:52:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT099.mail.protection.outlook.com (10.13.175.171) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.22 via Frontend Transport; Fri, 24 Mar 2023 06:52:07 +0000
Received: from localhost.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 24 Mar
 2023 01:51:59 -0500
From:   Qingqing Zhuo <qingqing.zhuo@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Aurabindo.Pillai@amd.com>, <qingqing.zhuo@amd.com>,
        <roman.li@amd.com>, <wayne.lin@amd.com>, <stylon.wang@amd.com>,
        <solomon.chiu@amd.com>, <pavle.kotarac@amd.com>,
        <agustin.gutierrez@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        <stable@vger.kernel.org>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Jun Lei <Jun.Lei@amd.com>
Subject: [PATCH 04/19] drm/amd/display: Fix 4to1 MPC black screen with DPP RCO
Date:   Fri, 24 Mar 2023 02:50:56 -0400
Message-ID: <20230324065111.2782-5-qingqing.zhuo@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230324065111.2782-1-qingqing.zhuo@amd.com>
References: <20230324065111.2782-1-qingqing.zhuo@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT099:EE_|CH2PR12MB4310:EE_
X-MS-Office365-Filtering-Correlation-Id: 76fd407d-b6d0-4082-392e-08db2c3448d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PxpLqhPdzJwSMwlnQZaCZmemhdr8SlBM8oGahx0D27SYLt8Xy8ztHxggowxjUxcvioavKAKoP6GdEWGK2oxD0X9XhOlxYxLOllIy5xYEItWpyyZGewqmNDYCiIGXE8H2j9uWdBN1mJe84lZCiNb5xFloJu0bbYeRHnXAyOU0G8Z50E5VOjQFYO77nRfIyh6SIzHBCSAj4HM/obLS1/06RttZAM/9/oRTmJw8ixrOv7kOp5LZWMi4Z1dZ3JtBk/+zlBr5yb1nO8TmUBNbyHxJRyKoGhEOu7xcc1CXcayrBNlhncEp5981m4lOaZuq5WHIL0le6NFWwfVE0qaISWVJrxrl+jk5u13SdFlnIBr0nAz85VKx2oi8t/qr6HY5hbWuI2Sr9MWS5bKKL/0Zb/DXs6n2STuskLEg1I69JT/yH9MDCxen4VPgfDaVyoha6dnmwPWR35f4B9+BZxcHHe4A/mN6hYwn0lHJxbat7neehBNHNcaV9iEGBfjk/r+ZByaB9euykwP9W95Tr9S1A93eqYqcmZgCnXPfT0xhDxNQvTQhMnBbolRT3yabsB2ZjtybP6Im6UvTF7eDaWYf2wreVngFnSuWPojDBd3RPsyb+1nkf/EKygocLw1Xc+iTIRU7JsJ4zLaQOFOqgi6AN+IJu5kRI4WX/DA14cQxAIce8CmsD0rGnqqwFbQXmhHe+x9AmPYlBrBEf+X32616N7x9V6/HbyeBhtGDziu0493hInE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(136003)(396003)(39860400002)(451199018)(46966006)(36840700001)(40470700004)(40480700001)(356005)(2906002)(40460700003)(36756003)(83380400001)(2616005)(336012)(186003)(16526019)(478600001)(86362001)(82310400005)(36860700001)(70586007)(6916009)(8676002)(4326008)(70206006)(54906003)(426003)(47076005)(316002)(6666004)(1076003)(8936002)(26005)(81166007)(41300700001)(5660300002)(44832011)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 06:52:07.3153
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76fd407d-b6d0-4082-392e-08db2c3448d2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT099.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4310
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[Why]
DPP Root clock optimization when combined with 4to1 MPC combine results
in the screen turning black.

This is because the DPPCLK is stopped during the middle of an
optimize_bandwidth sequence during commit_minimal_transition without
going through plane power down/power up.

[How]
The intent of a 0Hz DPP clock through update_clocks is to disable the
DTO. This differs from the behavior of stopping the DPPCLK entirely
(utilizing a 0Hz clock on some ASIC) so it's better to move this logic
to reside next to plane power up/power down where we gate the HUBP/DPP
DOMAIN.

The new  sequence should be:
Power down: PG enabled -> RCO on
Power up: RCO off -> PG disabled

Rename power_on_plane to power_on_plane_resources to reflect the
actual operation that's occurring.

Cc: stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
---
 .../amd/display/dc/dcn10/dcn10_hw_sequencer.c | 12 ++++++--
 .../drm/amd/display/dc/dcn20/dcn20_hwseq.c    |  8 ++++--
 .../gpu/drm/amd/display/dc/dcn31/dcn31_dccg.c | 13 ++-------
 .../drm/amd/display/dc/dcn314/dcn314_dccg.c   | 23 +++++++++++++++
 .../drm/amd/display/dc/dcn314/dcn314_hwseq.c  | 10 +++++++
 .../drm/amd/display/dc/dcn314/dcn314_hwseq.h  |  2 ++
 .../drm/amd/display/dc/dcn314/dcn314_init.c   |  1 +
 drivers/gpu/drm/amd/display/dc/inc/hw/dccg.h  | 28 +++++++++++--------
 .../amd/display/dc/inc/hw_sequencer_private.h |  4 +++
 9 files changed, 74 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index 46ca88741cb8..1c3b6f25a782 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -726,11 +726,15 @@ void dcn10_hubp_pg_control(
 	}
 }
 
-static void power_on_plane(
+static void power_on_plane_resources(
 	struct dce_hwseq *hws,
 	int plane_id)
 {
 	DC_LOGGER_INIT(hws->ctx->logger);
+
+	if (hws->funcs.dpp_root_clock_control)
+		hws->funcs.dpp_root_clock_control(hws, plane_id, true);
+
 	if (REG(DC_IP_REQUEST_CNTL)) {
 		REG_SET(DC_IP_REQUEST_CNTL, 0,
 				IP_REQUEST_EN, 1);
@@ -1237,11 +1241,15 @@ void dcn10_plane_atomic_power_down(struct dc *dc,
 			hws->funcs.hubp_pg_control(hws, hubp->inst, false);
 
 		dpp->funcs->dpp_reset(dpp);
+
 		REG_SET(DC_IP_REQUEST_CNTL, 0,
 				IP_REQUEST_EN, 0);
 		DC_LOG_DEBUG(
 				"Power gated front end %d\n", hubp->inst);
 	}
+
+	if (hws->funcs.dpp_root_clock_control)
+		hws->funcs.dpp_root_clock_control(hws, dpp->inst, false);
 }
 
 /* disable HW used by plane.
@@ -2462,7 +2470,7 @@ static void dcn10_enable_plane(
 
 	undo_DEGVIDCN10_253_wa(dc);
 
-	power_on_plane(dc->hwseq,
+	power_on_plane_resources(dc->hwseq,
 		pipe_ctx->plane_res.hubp->inst);
 
 	/* enable DCFCLK current DCHUB */
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index 69ea1f4ea749..9ca162ea0d07 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1130,11 +1130,15 @@ void dcn20_blank_pixel_data(
 }
 
 
-static void dcn20_power_on_plane(
+static void dcn20_power_on_plane_resources(
 	struct dce_hwseq *hws,
 	struct pipe_ctx *pipe_ctx)
 {
 	DC_LOGGER_INIT(hws->ctx->logger);
+
+	if (hws->funcs.dpp_root_clock_control)
+		hws->funcs.dpp_root_clock_control(hws, pipe_ctx->plane_res.dpp->inst, true);
+
 	if (REG(DC_IP_REQUEST_CNTL)) {
 		REG_SET(DC_IP_REQUEST_CNTL, 0,
 				IP_REQUEST_EN, 1);
@@ -1158,7 +1162,7 @@ static void dcn20_enable_plane(struct dc *dc, struct pipe_ctx *pipe_ctx,
 	//if (dc->debug.sanity_checks) {
 	//	dcn10_verify_allow_pstate_change_high(dc);
 	//}
-	dcn20_power_on_plane(dc->hwseq, pipe_ctx);
+	dcn20_power_on_plane_resources(dc->hwseq, pipe_ctx);
 
 	/* enable DCFCLK current DCHUB */
 	pipe_ctx->plane_res.hubp->funcs->hubp_clk_cntl(pipe_ctx->plane_res.hubp, true);
diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dccg.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dccg.c
index 7f34418e6308..7d2b982506fd 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dccg.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dccg.c
@@ -66,17 +66,8 @@ void dccg31_update_dpp_dto(struct dccg *dccg, int dpp_inst, int req_dppclk)
 		REG_UPDATE(DPPCLK_DTO_CTRL,
 				DPPCLK_DTO_ENABLE[dpp_inst], 1);
 	} else {
-		//DTO must be enabled to generate a 0Hz clock output
-		if (dccg->ctx->dc->debug.root_clock_optimization.bits.dpp) {
-			REG_UPDATE(DPPCLK_DTO_CTRL,
-					DPPCLK_DTO_ENABLE[dpp_inst], 1);
-			REG_SET_2(DPPCLK_DTO_PARAM[dpp_inst], 0,
-					DPPCLK0_DTO_PHASE, 0,
-					DPPCLK0_DTO_MODULO, 1);
-		} else {
-			REG_UPDATE(DPPCLK_DTO_CTRL,
-					DPPCLK_DTO_ENABLE[dpp_inst], 0);
-		}
+		REG_UPDATE(DPPCLK_DTO_CTRL,
+				DPPCLK_DTO_ENABLE[dpp_inst], 0);
 	}
 	dccg->pipe_dppclk_khz[dpp_inst] = req_dppclk;
 }
diff --git a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_dccg.c b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_dccg.c
index 0b769ee71405..081ce168f621 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_dccg.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_dccg.c
@@ -289,8 +289,31 @@ static void dccg314_set_valid_pixel_rate(
 	dccg314_set_dtbclk_dto(dccg, &dto_params);
 }
 
+static void dccg314_dpp_root_clock_control(
+		struct dccg *dccg,
+		unsigned int dpp_inst,
+		bool clock_on)
+{
+	struct dcn_dccg *dccg_dcn = TO_DCN_DCCG(dccg);
+
+	if (clock_on) {
+		/* turn off the DTO and leave phase/modulo at max */
+		REG_UPDATE(DPPCLK_DTO_CTRL, DPPCLK_DTO_ENABLE[dpp_inst], 0);
+		REG_SET_2(DPPCLK_DTO_PARAM[dpp_inst], 0,
+			  DPPCLK0_DTO_PHASE, 0xFF,
+			  DPPCLK0_DTO_MODULO, 0xFF);
+	} else {
+		/* turn on the DTO to generate a 0hz clock */
+		REG_UPDATE(DPPCLK_DTO_CTRL, DPPCLK_DTO_ENABLE[dpp_inst], 1);
+		REG_SET_2(DPPCLK_DTO_PARAM[dpp_inst], 0,
+			  DPPCLK0_DTO_PHASE, 0,
+			  DPPCLK0_DTO_MODULO, 1);
+	}
+}
+
 static const struct dccg_funcs dccg314_funcs = {
 	.update_dpp_dto = dccg31_update_dpp_dto,
+	.dpp_root_clock_control = dccg314_dpp_root_clock_control,
 	.get_dccg_ref_freq = dccg31_get_dccg_ref_freq,
 	.dccg_init = dccg31_init,
 	.set_dpstreamclk = dccg314_set_dpstreamclk,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c
index bcc03426fc3e..40c488b26901 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c
@@ -390,6 +390,16 @@ void dcn314_set_pixels_per_cycle(struct pipe_ctx *pipe_ctx)
 				pix_per_cycle);
 }
 
+void dcn314_dpp_root_clock_control(struct dce_hwseq *hws, unsigned int dpp_inst, bool clock_on)
+{
+	if (!hws->ctx->dc->debug.root_clock_optimization.bits.dpp)
+		return;
+
+	if (hws->ctx->dc->res_pool->dccg->funcs->dpp_root_clock_control)
+		hws->ctx->dc->res_pool->dccg->funcs->dpp_root_clock_control(
+			hws->ctx->dc->res_pool->dccg, dpp_inst, clock_on);
+}
+
 void dcn314_hubp_pg_control(struct dce_hwseq *hws, unsigned int hubp_inst, bool power_on)
 {
 	struct dc_context *ctx = hws->ctx;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.h b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.h
index c419d3dbdfee..c786d5e6a428 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.h
@@ -43,4 +43,6 @@ void dcn314_set_pixels_per_cycle(struct pipe_ctx *pipe_ctx);
 
 void dcn314_hubp_pg_control(struct dce_hwseq *hws, unsigned int hubp_inst, bool power_on);
 
+void dcn314_dpp_root_clock_control(struct dce_hwseq *hws, unsigned int dpp_inst, bool clock_on);
+
 #endif /* __DC_HWSS_DCN314_H__ */
diff --git a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_init.c b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_init.c
index 343f4d9dd5e3..5267e901a35c 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_init.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_init.c
@@ -137,6 +137,7 @@ static const struct hwseq_private_funcs dcn314_private_funcs = {
 	.plane_atomic_disable = dcn20_plane_atomic_disable,
 	.plane_atomic_power_down = dcn10_plane_atomic_power_down,
 	.enable_power_gating_plane = dcn314_enable_power_gating_plane,
+	.dpp_root_clock_control = dcn314_dpp_root_clock_control,
 	.hubp_pg_control = dcn314_hubp_pg_control,
 	.program_all_writeback_pipes_in_tree = dcn30_program_all_writeback_pipes_in_tree,
 	.update_odm = dcn314_update_odm,
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw/dccg.h b/drivers/gpu/drm/amd/display/dc/inc/hw/dccg.h
index ce006762f257..09de03699cc2 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw/dccg.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw/dccg.h
@@ -148,18 +148,22 @@ struct dccg_funcs {
 		struct dccg *dccg,
 		int inst);
 
-void (*set_pixel_rate_div)(
-        struct dccg *dccg,
-        uint32_t otg_inst,
-        enum pixel_rate_div k1,
-        enum pixel_rate_div k2);
-
-void (*set_valid_pixel_rate)(
-        struct dccg *dccg,
-	int ref_dtbclk_khz,
-        int otg_inst,
-        int pixclk_khz);
-
+	void (*set_pixel_rate_div)(
+	        struct dccg *dccg,
+	        uint32_t otg_inst,
+	        enum pixel_rate_div k1,
+	        enum pixel_rate_div k2);
+
+	void (*set_valid_pixel_rate)(
+	        struct dccg *dccg,
+		int ref_dtbclk_khz,
+	        int otg_inst,
+	        int pixclk_khz);
+
+	void (*dpp_root_clock_control)(
+			struct dccg *dccg,
+			unsigned int dpp_inst,
+			bool clock_on);
 };
 
 #endif //__DAL_DCCG_H__
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer_private.h b/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer_private.h
index 45d37c584551..5f63b67975cf 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer_private.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer_private.h
@@ -115,6 +115,10 @@ struct hwseq_private_funcs {
 	void (*plane_atomic_disable)(struct dc *dc, struct pipe_ctx *pipe_ctx);
 	void (*enable_power_gating_plane)(struct dce_hwseq *hws,
 		bool enable);
+	void (*dpp_root_clock_control)(
+			struct dce_hwseq *hws,
+			unsigned int dpp_inst,
+			bool clock_on);
 	void (*dpp_pg_control)(struct dce_hwseq *hws,
 			unsigned int dpp_inst,
 			bool power_on);
-- 
2.34.1

