Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A10B7668457
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 21:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232609AbjALUwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 15:52:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234650AbjALUwd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 15:52:33 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2087.outbound.protection.outlook.com [40.107.243.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E9F1ADAD
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 12:25:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C34jOMLEfrmbYnjGJQYXtYXac/CWOwX/SEG3cw3LNy/SiH+zar/Kz9rjMKYp7pLz88bGl7xqRXtgNr7tO1g7PkUvIZyF1fTdjbE8923dZ361adJttG2rh72iEjXopwXTh/UXfRdTXRcWssoGdJzr4IvCvUir92rkR2X/smQ2vyYV6as0+okWL/KIL6p6a509LwaaspCuIfPobAuMH0M3QtOeVc9iGq9fJGFeg8XbCEXNgf7WdrtAiDOaqc5c5aLytb7PRlAhO2Bem3/JIilEbJbEsRa1wf0n5FJ/NehgfjcCGypZc1WPnqgrw48AQPV5iW9eAek3d9M3CUrJQjeEKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BqBPqYiQkqaUm4DJtdYiDd0fvSeJjsUDh09IVk6ROWw=;
 b=WA0gQXTR583bKJ1U7ZlIwaLI3RHXyfBTbKHppXuBTS/Ehylar0JL4qB4ygDIT0kWuRlCtAVq8ev8jtKpStYOGhyCPeaFpOFJUuTS7LJv8FUYdy9h2uaBvsgJN8ej2nagUphXepW5FyzkYvICV8ZzuboozCiqD8K2t8VT3yutOl5Kw1OWSZK9AS/K6LAR2imCFbkfCjT53VzzMntmO4i55VZ4OFM5ONHFwIGrw3nWXBRry8yXVawxFtUxtIA8inF4Rtbzvur5f288sjuGYZyPkB8R221p06cgRGWM9r2vG0bzb7H6wNxFKK7nrZC4AhmfsuDFwc74Pch4L5QyjqIbtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BqBPqYiQkqaUm4DJtdYiDd0fvSeJjsUDh09IVk6ROWw=;
 b=GbflJ0PZpPKp0w4GgOV0BmhtAEEXZsEe/DaVLlq9CU+evRKq8I56Gx/yic4IxNiBqY6P9jWWImzycDv8+6mlXc0ZEjn9/wtBVYhShzO7Z50tEMJdsNZlc1dnXeEfQSNP9jCoW9A2cymZmx2+B3X+l3BYKh0Y76JxeqE02CuoL/8=
Received: from BN8PR03CA0021.namprd03.prod.outlook.com (2603:10b6:408:94::34)
 by PH8PR12MB6916.namprd12.prod.outlook.com (2603:10b6:510:1bd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Thu, 12 Jan
 2023 20:25:01 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:94:cafe::cf) by BN8PR03CA0021.outlook.office365.com
 (2603:10b6:408:94::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13 via Frontend
 Transport; Thu, 12 Jan 2023 20:25:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.13 via Frontend Transport; Thu, 12 Jan 2023 20:25:01 +0000
Received: from tr4.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 12 Jan
 2023 14:24:59 -0600
From:   Alex Deucher <alexander.deucher@amd.com>
To:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC:     Ao Zhong <hacc1225@gmail.com>, <daniel@octaforge.org>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH] drm/amd/display: move remaining FPU code to dml folder
Date:   Thu, 12 Jan 2023 15:24:44 -0500
Message-ID: <20230112202444.2008744-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT019:EE_|PH8PR12MB6916:EE_
X-MS-Office365-Filtering-Correlation-Id: f460796a-7ff3-4ec1-76c8-08daf4db152c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lLSdgmZrHirHiPgelh8UAzpDPV4Nvfq+l2RiITYKieDx3ISaK8NfCYj+inUZ/S78dvPU+FZzCTslHyc81QS708z4sPR7Ri7LF2t5trce9dGDZ5gQeuxAYUqw2ilFwFr3eFu4iWXDP6C+6IOssx8jxLFFJrLJ4jyUN9e+YZtNUEPC6FNPt9/NqryCWV9gHkzrtgnCEMNe1VE7SkvSSpaE6spCMSSf+EvJy7x9JnWYVw3M6WP1pUKOQ13pdtBv2z9lvC25WUt6UM9cCPhFTVGYQwe93hdVpYtnz7t6Wd8EJSAJckNp/ZEVBjJB6+2EFuaAKvPWAIwoM2b1ffZQGE1IrNArj5pTr2KKBgEHcn01wZ4rPnDnX1gmhInzPbCNBB0Bt7G0HKEleNuBH0PbKpFMEQVpfTgocwmL4c2a4vwkRvZ3hhiAXUr9mjF9WI32sWqUoVPbQ1FNW37Q/QX3muJI+SSgGjETDclX69HhG/VzoQd/PqTaGiNFg+amwrZMt7TT+RuNAXk6/PJBK4dlGWb0zCua2Wz7m81z+XPMSv74r41/LGMLrebKk6AgwX863xQEgkzFvR+aqK4ftMbxhEa2474maQxi0w1oyNjul5rUjCGyIIPYq4QCdEALG6l5KpRO2G0NwXsMBly0ua7OtR+dUHKU5N4vPDM4MbyxWJhR95wfCV2Yji7cayLVbvQywEhS
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(136003)(396003)(451199015)(40470700004)(36840700001)(46966006)(26005)(16526019)(40480700001)(478600001)(186003)(966005)(336012)(1076003)(70586007)(8676002)(2616005)(7696005)(6666004)(41300700001)(110136005)(316002)(54906003)(4326008)(47076005)(36860700001)(83380400001)(86362001)(82740400003)(81166007)(40460700003)(356005)(426003)(70206006)(82310400005)(36756003)(8936002)(5660300002)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 20:25:01.6128
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f460796a-7ff3-4ec1-76c8-08daf4db152c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6916
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ao Zhong <hacc1225@gmail.com>

pipes[pipe_cnt].pipe.src.dcc_fraction_of_zs_req_luma = 0;
pipes[pipe_cnt].pipe.src.dcc_fraction_of_zs_req_chroma = 0;
these two operations in dcn32/dcn32_resource.c still need to use FPU,
This will cause compilation to fail on ARM64 platforms because
-mgeneral-regs-only is enabled by default to disable the hardware FPU.
Therefore, imitate the dcn31_zero_pipe_dcc_fraction function in
dml/dcn31/dcn31_fpu.c, declare the dcn32_zero_pipe_dcc_fraction function
in dcn32_fpu.c, and move above two operations into this function.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2288
Cc: daniel@octaforge.org
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Ao Zhong <hacc1225@gmail.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 58ddbecb14c792b7fe0d92ae5e25c9179d62ff25)
Cc: stable@vger.kernel.org # 6.1.x
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c | 5 +++--
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c  | 8 ++++++++
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.h  | 3 +++
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
index 33ab6fdc3617..9919c39f7ea0 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
@@ -1919,8 +1919,9 @@ int dcn32_populate_dml_pipes_from_context(
 		timing = &pipe->stream->timing;
 
 		pipes[pipe_cnt].pipe.src.gpuvm = true;
-		pipes[pipe_cnt].pipe.src.dcc_fraction_of_zs_req_luma = 0;
-		pipes[pipe_cnt].pipe.src.dcc_fraction_of_zs_req_chroma = 0;
+		DC_FP_START();
+		dcn32_zero_pipe_dcc_fraction(pipes, pipe_cnt);
+		DC_FP_END();
 		pipes[pipe_cnt].pipe.dest.vfront_porch = timing->v_front_porch;
 		pipes[pipe_cnt].pipe.src.gpuvm_min_page_size_kbytes = 256; // according to spreadsheet
 		pipes[pipe_cnt].pipe.src.unbounded_req_mode = false;
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
index d1bf49d207de..d90216d2fe3a 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -2546,3 +2546,11 @@ void dcn32_update_bw_bounding_box_fpu(struct dc *dc, struct clk_bw_params *bw_pa
 	}
 }
 
+void dcn32_zero_pipe_dcc_fraction(display_e2e_pipe_params_st *pipes,
+				  int pipe_cnt)
+{
+	dc_assert_fp_enabled();
+
+	pipes[pipe_cnt].pipe.src.dcc_fraction_of_zs_req_luma = 0;
+	pipes[pipe_cnt].pipe.src.dcc_fraction_of_zs_req_chroma = 0;
+}
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.h b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.h
index 3a3dc2ce4c73..ab010e7e840b 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.h
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.h
@@ -73,4 +73,7 @@ int dcn32_find_dummy_latency_index_for_fw_based_mclk_switch(struct dc *dc,
 
 void dcn32_patch_dpm_table(struct clk_bw_params *bw_params);
 
+void dcn32_zero_pipe_dcc_fraction(display_e2e_pipe_params_st *pipes,
+				  int pipe_cnt);
+
 #endif
-- 
2.39.0

