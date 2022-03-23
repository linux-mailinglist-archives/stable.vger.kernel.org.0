Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B02FB4E5A72
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 22:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240884AbiCWVK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 17:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240889AbiCWVK1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 17:10:27 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2042.outbound.protection.outlook.com [40.107.236.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A716D36320
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 14:08:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AjZO+fAKeSfc1goOfvsULx6QmI9OOgn7F+UBdIt7RoDi+HOcSXSuYLaWjc4Q1nEviBT+ouFHLcCirKv3KvAeqnsXMJaYDuLK2AKa3scl7kSBC/tCf2631bwPbeDnIjCCDOc/CSX78wefufXbMpnJ6wlJ4R0M75Y3PlFQxH7uWWPrs/Ok1URjcA2J5kBB898yZsHA5OJBwD3QSCe8cBF5swrLwTfNX9xHcy81cLEHUaZJhwPqZLuX9RU1w4eGlvbgG7u+VwEMHmMmB/64FYurWsmjtvQ7WWHFEwua5ZmfIcpYItY09xHjvwdGWfOvrE1v8aj+igm10sQQdwj9EyhHJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M5vc/udOTWQ869WQPumMguwpJZ1nq825BAEDhXqLbJc=;
 b=czcKUGA0lBhumXfu25RkvPsi65k9/TG+bTlmpSSwOtUG9VynUE9BSGoTNk6/ZvxnJxE+SySEziOtIZOhPSegvaeLeS/LaPTYGpIrAZ3w04qDwYlqpd8aPmRd+xh8Rainc8v+Lj/1CpfnIKDaCDuxBtJyjTtFH1IhLVVlvQ829JV+0r23Ev6IhPiKFNQc+eQnGUIjQ3XqUMzhDdvmO4e26QIVC1AJ7ZZ5q4jcEq5L/PPb8nwdtj0sYHAbk1NaSmdrlr8gKl70j6PyCQC0pvuJuxPn9x5sNAptq64hRar5ZoXEsaLy9a/Ra2IPVVswmKPmaN3dpUuOLISmcXvXQA7rag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M5vc/udOTWQ869WQPumMguwpJZ1nq825BAEDhXqLbJc=;
 b=EiwHpgGYYKhmRL2kFUCS1P6PhrnF8XeDik0xzWv9a9Uy9r3189c1FDayWyXzvdPU9zCkI32ilulQ/stMzf+V6VtE1XCDoV+QvlaWys0qU2to1D6roz59DGpqx+DBk0L62F6TVbQb9ts4GopKBSYjUQPRZ+3unUxawCPbmC3S68M=
Received: from MW4PR04CA0376.namprd04.prod.outlook.com (2603:10b6:303:81::21)
 by SN6PR12MB2608.namprd12.prod.outlook.com (2603:10b6:805:68::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Wed, 23 Mar
 2022 21:08:54 +0000
Received: from CO1NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::81) by MW4PR04CA0376.outlook.office365.com
 (2603:10b6:303:81::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17 via Frontend
 Transport; Wed, 23 Mar 2022 21:08:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT026.mail.protection.outlook.com (10.13.175.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5102.17 via Frontend Transport; Wed, 23 Mar 2022 21:08:54 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 23 Mar
 2022 16:08:53 -0500
Received: from hwentlanryzen.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.24 via Frontend
 Transport; Wed, 23 Mar 2022 16:08:52 -0500
From:   Harry Wentland <harry.wentland@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     Harry Wentland <harry.wentland@amd.com>, <stable@vger.kernel.org>,
        <hersenxs.wu@amd.com>, <Ikshwaku.Chauhan@amd.com>,
        <Nicholas.Kazlauskas@amd.com>, <CHANDAN.VURDIGERENATARAJ@amd.com>
Subject: [PATCH] drm/amd/display: Program color range and encoding correctly for DCN2+
Date:   Wed, 23 Mar 2022 17:08:45 -0400
Message-ID: <20220323210845.182507-1-harry.wentland@amd.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1eff494c-3acd-4972-5a67-08da0d1156a9
X-MS-TrafficTypeDiagnostic: SN6PR12MB2608:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB2608BEEAF927929C570C800E8C189@SN6PR12MB2608.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oDA4vyADunnJbRnEfllRzEUR9YAhxaIzt+lDFBJUC9dZseZv0Q4/wc4jLOZmkCzkxjB1gbDtJl4fnM7GbHjYDuBCM2uUFRgLvG+sDaAhtYGWGJJbG6wcr4AZZ6rZAiFG+14yVusK1Iy+nOzzhSQOFND/aGO8455d0XSN+UKaS4V6R5U+3CR+hcWTkp4E9ZPazsdMwKepVkV8qFhM0UGb/EZK2WIBITDTtL5Wof1VarY49CkRU+VVoOEKwr882upmdSlgfa3oLnytAgybTuBp8/2+cyZHhiZZKszYxDD0ZBC1JXdUDZsqZ1/pdqcKUBYTPlkwK4ssLJ30V1ylGPgBHICFOppIovGW/rFYaU3iTHjPaJTyLJPPkgfpbG1wzO+q7K811adtw+G69cQ9v5YUSPLh8/2iy3HuaC1Dcw/bqXMdcHU0uEWYbE2cWxRbZB0WoCiXz0jkS4Ri05PljqFWWlSllMn2jS3eWpeW5qe2pNOJUmLzaROhvAqdatNVrEH892FenGchoy6pdEYoQLtPRh595bJSFFe4p0m0zKiLRLbHVhh3qrFjZRwuVzirtIruEIZUiFCgkSWQir79pLONl6ZIn//Ztyhlu40/+f7oRD9FB2AQYj/aBxMbbYKe+nzz8kCjjFjHAJ5mtQjQjGcXT6VbrRc2WvxHZyIl6a2/7e3i9mlr84oqX81aX94q15jcPuUPMyQJ8fNybkavS88Mzw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(86362001)(83380400001)(47076005)(426003)(5660300002)(336012)(26005)(186003)(8676002)(7696005)(4326008)(1076003)(2616005)(2906002)(36756003)(70206006)(70586007)(36860700001)(6916009)(54906003)(6666004)(356005)(8936002)(81166007)(508600001)(40460700003)(316002)(82310400004)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2022 21:08:54.4016
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eff494c-3acd-4972-5a67-08da0d1156a9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2608
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Why]
DCN2 CNVC programming did not respect the input_color_space
and was therefore programming the wrong CSC matrix for YUV
to RGB conversion, leading to a wrong image. In particular
blacks for limited range videos would show as dark grey.

[How]
Do what DCN1 does and use the input_color_space info in
dpp_setup if it's available.

Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Cc: stable@vger.kernel.org
Cc: hersenxs.wu@amd.com
Cc: Ikshwaku.Chauhan@amd.com
Cc: Nicholas.Kazlauskas@amd.com
Cc: CHANDAN.VURDIGERENATARAJ@amd.com
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dpp.c   | 3 +++
 drivers/gpu/drm/amd/display/dc/dcn201/dcn201_dpp.c | 3 +++
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dpp.c   | 3 +++
 3 files changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dpp.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dpp.c
index 970b65efeac1..eaa7032f0f1a 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dpp.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dpp.c
@@ -212,6 +212,9 @@ static void dpp2_cnv_setup (
 		break;
 	}
 
+	/* Set default color space based on format if none is given. */
+	color_space = input_color_space ? input_color_space : color_space;
+
 	if (is_2bit == 1 && alpha_2bit_lut != NULL) {
 		REG_UPDATE(ALPHA_2BIT_LUT, ALPHA_2BIT_LUT0, alpha_2bit_lut->lut0);
 		REG_UPDATE(ALPHA_2BIT_LUT, ALPHA_2BIT_LUT1, alpha_2bit_lut->lut1);
diff --git a/drivers/gpu/drm/amd/display/dc/dcn201/dcn201_dpp.c b/drivers/gpu/drm/amd/display/dc/dcn201/dcn201_dpp.c
index 8b6505b7dca8..f50ab961bc17 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn201/dcn201_dpp.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn201/dcn201_dpp.c
@@ -153,6 +153,9 @@ static void dpp201_cnv_setup(
 		break;
 	}
 
+	/* Set default color space based on format if none is given. */
+	color_space = input_color_space ? input_color_space : color_space;
+
 	if (is_2bit == 1 && alpha_2bit_lut != NULL) {
 		REG_UPDATE(ALPHA_2BIT_LUT, ALPHA_2BIT_LUT0, alpha_2bit_lut->lut0);
 		REG_UPDATE(ALPHA_2BIT_LUT, ALPHA_2BIT_LUT1, alpha_2bit_lut->lut1);
diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dpp.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dpp.c
index ab3918c0a15b..0dcc07531643 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dpp.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dpp.c
@@ -294,6 +294,9 @@ static void dpp3_cnv_setup (
 		break;
 	}
 
+	/* Set default color space based on format if none is given. */
+	color_space = input_color_space ? input_color_space : color_space;
+
 	if (is_2bit == 1 && alpha_2bit_lut != NULL) {
 		REG_UPDATE(ALPHA_2BIT_LUT, ALPHA_2BIT_LUT0, alpha_2bit_lut->lut0);
 		REG_UPDATE(ALPHA_2BIT_LUT, ALPHA_2BIT_LUT1, alpha_2bit_lut->lut1);
-- 
2.35.1

