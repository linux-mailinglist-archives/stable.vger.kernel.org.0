Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB5E56EA03E
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 01:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbjDTXuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 19:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjDTXuu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 19:50:50 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0031D10F0
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 16:50:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P9ZlvWFTFTuCMDMNZ2LqgITmIyWcdx+P4judd9kGlgsAiVq6a7F0klW8Zr34FdJoOY5wNp1flif+lvx0Tq/a+4jiKxSBNVCzlNLFbkeCyfwOHSwq+UL3jGFqa9KJIIu9lM0beqrfoJuJlb/iBWzKniET9LNc2MlDWvYpRodylDLTIqRWusSvASe5++wt2flHGFI8tYPIko3s3VpsmrLvDP5ZXDHwbbSR6Dwyt+Q5dv0xJ13o9rwBpWm53gyGk6ZRBDiDBwrv3jwJ1jZyW360oqngq4oMHmWEHK+xbxBgmoiRSklL/NCBDXeBLpJMGbVkeGFJgnJjFQaIas/6EIoZ7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rmR/uve7dSOWcouDp5sCeiSUsikvAKFiPTluAzDQrew=;
 b=D8Ucv1R0OamlM5gSfSE9gEiEI2Ya8hk8Y5TZ0EpgKEtM2oEydCnzJIvtd/zb3NvO5pBSqbAz5a+9BNelON5CZim4fY5M4n94ndZzM1d6hLHk7QjfUBgWwpmtDfbR9n8NKKwBfgZC/mc2IpjzTMzA0vmpzBwKzdAL/6vFNtON/Y6SW3WhO3MJ3j1YyYQnPBT1xeM2rertE8NHJarOr3RlAYsXRezDtfe+4EWvM2Vz0kqj2bd/1FH029JA7pVvYpqzb6yiZ2mFts58ByOZ1R0EDAYQCPsvyEMHyqQK23BR+Xy0vPlAxu/yaudeQkHNDkT1lUpTg5ovkAa5yu10OI0Fmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rmR/uve7dSOWcouDp5sCeiSUsikvAKFiPTluAzDQrew=;
 b=RgUQ2RbWp2O6pVqhISOzdeQ/JlB6i0BvpgE7veXZ807pz0vJuDKzxPn8Coc9I3ee+PjCAp7HB5OKbjA4yBK7e2cH0F32n8767xrEY/EErA+BqU6azevM9W0Y4vh92+bWBliuXUFEut+X5u4O+HAjCFx/g17ZrC9pIIuDy3d1tBw=
Received: from DM5PR07CA0088.namprd07.prod.outlook.com (2603:10b6:4:ae::17) by
 SJ1PR12MB6315.namprd12.prod.outlook.com (2603:10b6:a03:456::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 23:50:45 +0000
Received: from DM6NAM11FT101.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::a2) by DM5PR07CA0088.outlook.office365.com
 (2603:10b6:4:ae::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.25 via Frontend
 Transport; Thu, 20 Apr 2023 23:50:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT101.mail.protection.outlook.com (10.13.172.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.27 via Frontend Transport; Thu, 20 Apr 2023 23:50:44 +0000
Received: from smtp.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 20 Apr
 2023 18:50:42 -0500
From:   Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Aurabindo.Pillai@amd.com>, <qingqing.zhuo@amd.com>,
        <roman.li@amd.com>, <wayne.lin@amd.com>, <stylon.wang@amd.com>,
        <solomon.chiu@amd.com>, <pavle.kotarac@amd.com>,
        <agustin.gutierrez@amd.com>,
        Michael Strauss <michael.strauss@amd.com>,
        <stable@vger.kernel.org>, George Shen <George.Shen@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>
Subject: [PATCH 20/21] drm/amd/display: Keep disable aux-i delay as 0
Date:   Thu, 20 Apr 2023 17:49:50 -0600
Message-ID: <20230420234951.1772270-21-Rodrigo.Siqueira@amd.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230420234951.1772270-1-Rodrigo.Siqueira@amd.com>
References: <20230420234951.1772270-1-Rodrigo.Siqueira@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT101:EE_|SJ1PR12MB6315:EE_
X-MS-Office365-Filtering-Correlation-Id: c2bfa7dc-889e-417e-c74d-08db41fa0ed1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jQCIjZvfUU/Z5LvCIiu7vyr1UB8J44mkADZf3oPIUTnXw3qOJQIYQYNv1dVFhUycO40qemTxwXrc3Pppk14adU2NmBIRbK+6+klakeDqxteTdztJWtqfIidIf5j/HLoyMYzoybugrWRhuPKPJUnHx4lWKit40TzMHJt7Ei4MJdBm+fi1PtYdTP1mhj7Qzdmr3YNQwRwoDHsQKVpOoFY8W9cpodqioWtLvOMSIFzgAPYo0JUtnEpBtqRXHxltLcDNydigIqM1/vliCQqHVX2m1eDBPjIw1Yxuw2ROXWmhl71a0lc9FfVsdQZy6T0JG9Kf2McnXs//OymXGRY6wEXZ/cm8uS4L94tLpNoD5bNoWhp6PsyJPmXE6jjPJWTxjeXcoHsrn99nIIYUPE7sUwdlBJ/Q7vSGLPyhIjc1Q6xkne7gOMrfMaNMpWiNnUApDuzfO73diUpnYItwoBjol6cz0KY/PC8bBXnY7dBXu15Fq6JNOpsFuIQGZCxj00+scmMZdh+4bTqu9WsVBvgN/ZEbtCWudPAxdBA1jfSWo4YQ3SYjDp0RGVPwnJPCP8uL68MyiKixgzkTq6eAixiwVMXsQeRqaZHePfqy/BWTY2ouGI9iQ4Mo3M6yIJCz5oX9ORtNA1XmqKPgiioayOnbN1igRBuNnM23MuMQf0F5lgk5pHQMctkd5QRGhtVTr/1Mo4xVbQFPDwGYxUtCtqB3Q1iCRbXLXBkc0BXpssQEfortKh4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(396003)(39860400002)(136003)(451199021)(46966006)(40470700004)(36840700001)(40460700003)(316002)(70586007)(70206006)(4326008)(6916009)(40480700001)(6666004)(86362001)(54906003)(82310400005)(478600001)(5660300002)(36756003)(2616005)(8936002)(8676002)(81166007)(356005)(82740400003)(2906002)(83380400001)(47076005)(336012)(426003)(36860700001)(41300700001)(1076003)(186003)(26005)(16526019)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 23:50:44.8534
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c2bfa7dc-889e-417e-c74d-08db41fa0ed1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT101.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6315
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Strauss <michael.strauss@amd.com>

[WHY]
Current Aux-I sequence checks for local_sink which isn't populated on
MST links

[HOW]
Leave disable aux-i delay as 0 for MST cases

Cc: stable@vger.kernel.org
Reviewed-by: George Shen <George.Shen@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Michael Strauss <michael.strauss@amd.com>
---
 .../link_dp_training_fixed_vs_pe_retimer.c       | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training_fixed_vs_pe_retimer.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training_fixed_vs_pe_retimer.c
index fb6c938c6dab..15faaf645b14 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training_fixed_vs_pe_retimer.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training_fixed_vs_pe_retimer.c
@@ -233,8 +233,7 @@ enum link_training_result dp_perform_fixed_vs_pe_training_sequence_legacy(
 			link->dpcd_caps.lttpr_caps.phy_repeater_cnt);
 	const uint8_t vendor_lttpr_write_data_intercept_en[4] = {0x1, 0x55, 0x63, 0x0};
 	const uint8_t vendor_lttpr_write_data_intercept_dis[4] = {0x1, 0x55, 0x63, 0x68};
-	uint32_t pre_disable_intercept_delay_ms =
-			link->local_sink->edid_caps.panel_patch.delay_disable_aux_intercept_ms;
+	uint32_t pre_disable_intercept_delay_ms = 0;
 	uint8_t vendor_lttpr_write_data_vs[4] = {0x1, 0x51, 0x63, 0x0};
 	uint8_t vendor_lttpr_write_data_pe[4] = {0x1, 0x52, 0x63, 0x0};
 	uint32_t vendor_lttpr_write_address = 0xF004F;
@@ -245,6 +244,10 @@ enum link_training_result dp_perform_fixed_vs_pe_training_sequence_legacy(
 	uint8_t toggle_rate;
 	uint8_t rate;
 
+	if (link->local_sink)
+		pre_disable_intercept_delay_ms =
+				link->local_sink->edid_caps.panel_patch.delay_disable_aux_intercept_ms;
+
 	/* Only 8b/10b is supported */
 	ASSERT(link_dp_get_encoding_format(&lt_settings->link_settings) ==
 			DP_8b_10b_ENCODING);
@@ -595,10 +598,7 @@ enum link_training_result dp_perform_fixed_vs_pe_training_sequence(
 	const uint8_t vendor_lttpr_write_data_adicora_eq3[4] = {0x1, 0x55, 0x63, 0x68};
 	uint8_t vendor_lttpr_write_data_vs[4] = {0x1, 0x51, 0x63, 0x0};
 	uint8_t vendor_lttpr_write_data_pe[4] = {0x1, 0x52, 0x63, 0x0};
-	uint32_t pre_disable_intercept_delay_ms =
-			link->local_sink->edid_caps.panel_patch.delay_disable_aux_intercept_ms;
-
-
+	uint32_t pre_disable_intercept_delay_ms = 0;
 	uint32_t vendor_lttpr_write_address = 0xF004F;
 	enum link_training_result status = LINK_TRAINING_SUCCESS;
 	uint8_t lane = 0;
@@ -607,6 +607,10 @@ enum link_training_result dp_perform_fixed_vs_pe_training_sequence(
 	uint8_t toggle_rate;
 	uint8_t rate;
 
+	if (link->local_sink)
+		pre_disable_intercept_delay_ms =
+				link->local_sink->edid_caps.panel_patch.delay_disable_aux_intercept_ms;
+
 	/* Only 8b/10b is supported */
 	ASSERT(link_dp_get_encoding_format(&lt_settings->link_settings) ==
 			DP_8b_10b_ENCODING);
-- 
2.39.2

