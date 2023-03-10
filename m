Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15A786B3AB0
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 10:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbjCJJgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 04:36:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbjCJJgO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 04:36:14 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B2D19109
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 01:33:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=atQHY5uqZ/sQXzIXzhzQXSGZDGphyDyc2Fl0JbRZMEpBFRnqVcIQ5oMP6DixYBOVT7SnO6jGSPqHUWNGg/49pLITk075HpdWaMq2byQ9sRY8LfdsLF9lBMbxfI5DwvyzInSwgajoeHg9XO2OetBcYy/WZdZCL6Ug23Y5AJcSUNYszQmxJqvUpdpFwbnC9EvGe/PoOQJKnMZ00NkF4S6XiVkYKQx8vi02suBotKMKQGfUnJeGwCcr42c7lkEaLOwsVAlSC0i0GziUKpbc+b70nnQG30Co7/ZNE0hBqgWSPBX1IusigBtxoeQWsoIWPygSc72hNU+J8Y5GiJ61i3kLLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b5irmu7Wg9bfpqlxPk21xMZR1ZYmSm2QaVjkCpKUpcE=;
 b=DtmyEbKwL5fniIpXG0BDmN0E6701oWZxpOAdJClemg3Qz5m4k/CCJ6jLvKEcBFMW67OfYgtgTjGlj9agf8PakS2BmO+UW7hVfAY6pvVgZMG0amDmrLwTzAI4nJ8aVoP2pQBojPVL7kPpxkrpATtQEs+Z6ZuQ7au70E9ELd6Vl7l/1t7wPIVMjq9vokqqv84nzTxOrRkJaQNZd3qRxb8Jtm3m27F1M7rhXRcJM/hUa34X6WIwkATxmWiQC0rXLoAipoVwoXvp7uSBQFe1gxDbHHKWCMDwgKBkTVX6/nBJ+949DBiRbyiu5dOtfsu+3L8Od+BwmpJq52QNPoHu8Hq7VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b5irmu7Wg9bfpqlxPk21xMZR1ZYmSm2QaVjkCpKUpcE=;
 b=DU4gIfW2ESx5fRVTBqkExOEZ3sczEVUsUQiwduv425eMEq4iE4W0eTD4DBqPhZu+x1klKC5HTVq2FBTD8v2i93dd0uYGFWh+1YgYHAebHxXRGZbEswKr3KEpBIxGf6fP1fM9/2PsJuktqwX75JPaD4+S1vTgMV92Mz1xH+Zf8TM=
Received: from DM6PR12CA0019.namprd12.prod.outlook.com (2603:10b6:5:1c0::32)
 by PH7PR12MB7114.namprd12.prod.outlook.com (2603:10b6:510:1ed::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 09:32:50 +0000
Received: from CY4PEPF0000C979.namprd02.prod.outlook.com
 (2603:10b6:5:1c0:cafe::94) by DM6PR12CA0019.outlook.office365.com
 (2603:10b6:5:1c0::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19 via Frontend
 Transport; Fri, 10 Mar 2023 09:32:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C979.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.13 via Frontend Transport; Fri, 10 Mar 2023 09:32:49 +0000
Received: from localhost.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Mar
 2023 03:32:43 -0600
From:   Qingqing Zhuo <qingqing.zhuo@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Aurabindo.Pillai@amd.com>, <qingqing.zhuo@amd.com>,
        <roman.li@amd.com>, <wayne.lin@amd.com>, <stylon.wang@amd.com>,
        <solomon.chiu@amd.com>, <pavle.kotarac@amd.com>,
        <agustin.gutierrez@amd.com>, Robin Chen <robin.chen@amd.com>,
        <stable@vger.kernel.org>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Wenjing Liu <Wenjing.Liu@amd.com>
Subject: [PATCH 11/19] drm/amd/display: hpd rx irq not working with eDP interface
Date:   Fri, 10 Mar 2023 04:31:09 -0500
Message-ID: <20230310093117.3030-12-qingqing.zhuo@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230310093117.3030-1-qingqing.zhuo@amd.com>
References: <20230310093117.3030-1-qingqing.zhuo@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C979:EE_|PH7PR12MB7114:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e6c708c-58b5-4e4e-433e-08db214a6a52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Swvtif1/7TJO/NSw9hUGXTBDEQkd5fdihdvIudrkcX+sdV55rmHp55lnfGNL9RT0GVVq/ZhvRjLAUb5lRvNE6p2jp+5PWO90g1RhQs7dBxc9DsT7axPp4hedU0cXuzOTaL2TxpJrBnCl9X9+FgWI6sWyzJW4qlT7/ADfes/cJUreDZKFf/UbgWyZBkP2CurPt+30rCbxEwHj6sRFv+E4wy7RBmh5ikMHuS5NU8NASQkNI+8BZNimsSw74h4Mf33o8KlawgMDonOTMk/kFoAZlQsimFN6sCJ81EGC/y7BgoW21P9bebmHEDhIw9NOzHABDKDJq6yqoiY6Oy+t0ttaqTPS7lKRfBFhbCstxDBGIyj1QEuTPvXSvWSx+XZtp+kSQr9m351b6O0rU6ljIwEr1GLlrKkF04XXtO7XhLO/5xI4bX0Q3Nx+dgxCZEFOYm478VoQez+u1VZOG4N6/c7AVjZm7lNKLG2idePfIGV4N/zbCkC7UGjGnoQ35RR2vbkqKbH8G39U+7vh9+vPtsAcjo/kSYTZYvrCXvPQeU+fkSRU90XCfxmfS3jyZeUB3cBuI/NxggWpEW8z3H1gES3QLzXU/IluWeyltxCG4F1ZeTyBBdgWMwhOdME4DA6G0ELFMdUddnR3kBFgHU29qnlKUlM0eUvhwBLbHn2sFiQnlqL0EU4lwmF7a0MiHM4GXNAC4dLkffkIXeOdl+B/zjj6wd3DMWvh98P0WM2BWyVFoz4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(376002)(39860400002)(451199018)(40470700004)(36840700001)(46966006)(8676002)(6916009)(70206006)(70586007)(4326008)(82740400003)(5660300002)(8936002)(40460700003)(44832011)(36756003)(41300700001)(2906002)(81166007)(36860700001)(26005)(40480700001)(6666004)(16526019)(2616005)(356005)(478600001)(186003)(83380400001)(54906003)(316002)(86362001)(1076003)(82310400005)(336012)(47076005)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 09:32:49.7035
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e6c708c-58b5-4e4e-433e-08db214a6a52
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C979.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7114
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Chen <robin.chen@amd.com>

[Why]
This is the fix for the defect of commit 11ec7d8f2263
("drm/amd/display: Allow individual control of eDP hotplug support").

[How]
To revise the default eDP hotplug setting and use the enum to git rid
of the magic number for different options.

Fixes: 11ec7d8f2263 ("drm/amd/display: Allow individual control of eDP hotplug support")

Cc: stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Wenjing Liu <Wenjing.Liu@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Robin Chen <robin.chen@amd.com>
---
 drivers/gpu/drm/amd/display/dc/dc_types.h          | 7 +++++++
 drivers/gpu/drm/amd/display/dc/link/link_factory.c | 9 +++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc_types.h b/drivers/gpu/drm/amd/display/dc/dc_types.h
index 4b47fa00610b..45ab48fe5d00 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_types.h
@@ -1080,4 +1080,11 @@ struct dc_dpia_bw_alloc {
 };
 
 #define MAX_SINKS_PER_LINK 4
+
+enum dc_hpd_enable_select {
+	HPD_EN_FOR_ALL_EDP = 0,
+	HPD_EN_FOR_PRIMARY_EDP_ONLY,
+	HPD_EN_FOR_SECONDARY_EDP_ONLY,
+};
+
 #endif /* DC_TYPES_H_ */
diff --git a/drivers/gpu/drm/amd/display/dc/link/link_factory.c b/drivers/gpu/drm/amd/display/dc/link/link_factory.c
index 995032a341b3..3951d48118c4 100644
--- a/drivers/gpu/drm/amd/display/dc/link/link_factory.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_factory.c
@@ -528,14 +528,18 @@ static bool construct_phy(struct dc_link *link,
 				link->irq_source_hpd = DC_IRQ_SOURCE_INVALID;
 
 			switch (link->dc->config.allow_edp_hotplug_detection) {
-			case 1: // only the 1st eDP handles hotplug
+			case HPD_EN_FOR_ALL_EDP:
+				link->irq_source_hpd_rx =
+						dal_irq_get_rx_source(link->hpd_gpio);
+				break;
+			case HPD_EN_FOR_PRIMARY_EDP_ONLY:
 				if (link->link_index == 0)
 					link->irq_source_hpd_rx =
 						dal_irq_get_rx_source(link->hpd_gpio);
 				else
 					link->irq_source_hpd = DC_IRQ_SOURCE_INVALID;
 				break;
-			case 2: // only the 2nd eDP handles hotplug
+			case HPD_EN_FOR_SECONDARY_EDP_ONLY:
 				if (link->link_index == 1)
 					link->irq_source_hpd_rx =
 						dal_irq_get_rx_source(link->hpd_gpio);
@@ -543,6 +547,7 @@ static bool construct_phy(struct dc_link *link,
 					link->irq_source_hpd = DC_IRQ_SOURCE_INVALID;
 				break;
 			default:
+				link->irq_source_hpd = DC_IRQ_SOURCE_INVALID;
 				break;
 			}
 		}
-- 
2.34.1

