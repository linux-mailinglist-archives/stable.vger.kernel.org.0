Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC8FD6BF8B3
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 08:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjCRH6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 03:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbjCRH6B (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 03:58:01 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C7C6B5E0
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 00:57:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bYS5FY9S/FVPsLOPWV0Df69EZEJSd5RSoCAtFEE2KgBbxz1mrfPYfyqo6Lini8FpGX/w0e2RcGykCLUUj9CZMU0o/cZwtsZDD4Y0aiaTuQMRtmhxDShJGfuc7EO25QrDpLYVGKyb7jgYJ+KI5mCkXgByHW8bZwpB7fP0GuPMwSFuzbswIN2Cy+Zi6sIbNixXYLnTrodQhAVe6rUn5XZk88uW752eZfIHqTiQkIlffbxBBJWrBDKbFuA5qllUDUTat6LfumoUZB8ZFfY6affiR+aJzobBW4bx9tiEV492ByqA2+DQ9whQEgKXNWWqGloSGJTI80WzbRLNNmiEZ5vnNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=auNQtjzloAXrGfc2DkvblvPW3MUIqiN3jfIKHploqfw=;
 b=A0+PVie1Fke6qxni/hWhVbenSEGpeHcUjMQepvR23dvsDUT567u9jDmDYHnYFYt0H9kXy85lcdkCBF50ylyLX+bgMrTYYz1CWo5F1dKxkOYDn4jft6zklgv2kuHsWVFw4vHkupP/CMz4yOZHKtu2VfqGlyQIaF5KjKnnkfmmx837LEUaR6jURtXs9nRfymnGp+43UItDSFPuo0RM7t/2TycH9Tn0GI4Yqc6LkV5lKxu5hDl9MxYbfUWdSGwJdaVmwI6PsLcnQNYJZUDTqSqDIa4k78x5uqjwpBauKNhtsp1hrolRZgDClrJEsiYj+uHvRyE9c2Ph+6JYJROU32gbGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=auNQtjzloAXrGfc2DkvblvPW3MUIqiN3jfIKHploqfw=;
 b=wD/aOKmua/CECZ3CmW2CPKPFjg35XauaaaDyh3o1QeRtsTD6woGXu5Xnngh/aOMVmyiM3UoVkHW8sjpZ0xtBbFyXXKWCUngXmHCa0LfQN1rkTfk4uT5d1fYVjUNgvvXL+VpYx4L341WOxel56+o0wj7IVnWNWmPJTMiOFMpROHg=
Received: from BN9PR03CA0357.namprd03.prod.outlook.com (2603:10b6:408:f6::32)
 by CYYPR12MB8730.namprd12.prod.outlook.com (2603:10b6:930:c1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.36; Sat, 18 Mar
 2023 07:57:53 +0000
Received: from BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::fd) by BN9PR03CA0357.outlook.office365.com
 (2603:10b6:408:f6::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35 via Frontend
 Transport; Sat, 18 Mar 2023 07:57:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT005.mail.protection.outlook.com (10.13.176.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.11 via Frontend Transport; Sat, 18 Mar 2023 07:57:53 +0000
Received: from localhost.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Sat, 18 Mar
 2023 02:57:48 -0500
From:   Qingqing Zhuo <qingqing.zhuo@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Aurabindo.Pillai@amd.com>, <qingqing.zhuo@amd.com>,
        <roman.li@amd.com>, <wayne.lin@amd.com>, <stylon.wang@amd.com>,
        <solomon.chiu@amd.com>, <pavle.kotarac@amd.com>,
        <agustin.gutierrez@amd.com>, Hersen Wu <hersenxs.wu@amd.com>,
        <stable@vger.kernel.org>,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 16/19] drm/amd/display: fix wrong index used in dccg32_set_dpstreamclk
Date:   Sat, 18 Mar 2023 03:56:12 -0400
Message-ID: <20230318075615.2630-17-qingqing.zhuo@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230318075615.2630-1-qingqing.zhuo@amd.com>
References: <20230318075615.2630-1-qingqing.zhuo@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT005:EE_|CYYPR12MB8730:EE_
X-MS-Office365-Filtering-Correlation-Id: e32834ba-c753-44b9-fc08-08db27867a46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DUxoCjB3bu9uYVv9+Z+Z6Uzdy6zj1AETCunUKOssJCQN1C8TQF4d1SCcmwr38cFJJGw7i9dP58h1GfpSwmfYkNP+WdNRC0TrNfR4+e0PEBp/UKGW3WhvBJuLRGULKfDfuUH7OMM+SeKdBcqwndk8t832BugFFrIwduQTVekzDuM5HK/bJ/7/JG5aznvPCpMifJQ6qUAg43t4+BtsDnM0UhAoGdabZX3t6W5rxs7xb6wBX51uNRqLAlkSfVPgeGO8vMQUlk0XZ7P74MqwE6SdyBVaRoIXLWYHIE9MXWMVNXDygLkqdjqc73B6O6Zg1MZVyf8rmjPkFNq5WpD5ND3t/JFtVG0NR2ItHr9SZVaJYAiuODbszlZf/8imScY8mW1t9t2a9aE1W6M5L416eskvKerjdfkovozgEVEwnVE8y2Exi+VCzIu5QfbC/wAC8b3B6uUp3fsHf7rKAwGV55w6bvivNe327JFARcfFDEV3oDOg+u9rMEbtJc/Rj5hB5IhgX03Gp5Tk4CpnWujxmIJqNcang0cmYLsqp4SwN1F05vtWyVEsqdeJMiTyj/yDqOLWXB/xECHKV38kr1MAXVnxSgFvYK7WCweE6Iu89i6XOs4t5y6mrvnOUfNCnlJyTuDZY0rcl3lqYvGiNblcAdcJ+ob2Ze/baN2WvjUDNX2DcLEq3HE9J4pV2SqPbW17x0VhnCUuKfnH7LICjTZpRGlU22XH+tWekzdk5mrtBPBtgH4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(396003)(39860400002)(136003)(451199018)(40470700004)(46966006)(36840700001)(82310400005)(86362001)(40460700003)(36756003)(40480700001)(316002)(70586007)(70206006)(8676002)(4326008)(83380400001)(478600001)(54906003)(186003)(16526019)(26005)(1076003)(2616005)(426003)(47076005)(6666004)(336012)(6916009)(356005)(44832011)(8936002)(5660300002)(2906002)(41300700001)(81166007)(36860700001)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2023 07:57:53.3161
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e32834ba-c753-44b9-fc08-08db27867a46
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8730
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hersen Wu <hersenxs.wu@amd.com>

[Why & How]
When merging commit 8f6de23e03f1
("drm/amd/display: Fix DCN32 DPSTREAMCLK_CNTL programming"),
index change was not picked up.

Cc: stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>
Fixes: 8f6de23e03f1 ("drm/amd/display: Fix DCN32 DPSTREAMCLK_CNTL programming")
Reviewed-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Hersen Wu <hersenxs.wu@amd.com>
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c
index 5dbef498580b..ffbb739d85b6 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c
@@ -293,8 +293,7 @@ static void dccg32_set_dpstreamclk(
 	dccg32_set_dtbclk_p_src(dccg, src, otg_inst);
 
 	/* enabled to select one of the DTBCLKs for pipe */
-	switch (otg_inst)
-	{
+	switch (dp_hpo_inst) {
 	case 0:
 		REG_UPDATE_2(DPSTREAMCLK_CNTL,
 			     DPSTREAMCLK0_EN,
-- 
2.34.1

