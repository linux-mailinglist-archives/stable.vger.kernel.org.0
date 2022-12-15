Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56D6464E19F
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 20:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiLOTQg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 14:16:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiLOTQf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 14:16:35 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2085.outbound.protection.outlook.com [40.107.220.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934C7396DA;
        Thu, 15 Dec 2022 11:16:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KPTCFcd/pm7NIsDFy+tRHJWbTPRonDZLkDY//cm+E+JLg0Rgd/ANZqdPIJusBWpQcLRRCCrV9hFDk9PfKevZR/4Tw8gk0QtanXmeN8mHj76VzCm31UCdjTQnUV9WBjwEDUeLLDLzuRzlWiAGE3U+v0iupz/O7MPgXh19UieEF3G7JsCJwHaDEBSf3iwKAjRjn1NuuOGUpqI7zKb7kBWQIzBCsTeNk1ReCcZAl/37yMBN8bKE6UopC6P7S2e45MsOdZqyVrUfYIw2tJTa7MiIur0ZhSNazdXH0+FJG5EfSmMLfFS2H6TW30GW03kiVmOlH8LplzT0sMuzeBzwxXu3hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qYU/aBJhmRo7BRSCwHeFe4Wdj3aJoMDsQR68gKU4TRs=;
 b=eFGtzvtpytjRMIEhXUWEN6rtAYkpuxbYeVaVLa8BRsQvNfuDlANJWbvyTikZVd9QsWI8mcowcz378Qn+dwUZ0GYhsaabxOZMc+KUc2h08FOKEiJpr5PSw90vEVN5Fez0iN2nWAgVFoOsdh7bbMJy2s+sI63jFLl1yTNK6ZcHLsR7/tKJP/lMsTzj9M5rgygc2ebq6lWjtn+YcwlP9CFE2zTFn8u1pb5jFCGMOt4Y+1r7e7BOF+lkFfy3WSIqiF07z1yE1zI4caKWc37s8Lk5GjvJSPd9OBltsfmL2qy1Fl/hoq8O8qsYgbydfvdgGxERG9CPlkmCizpOwLbDlXe2qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qYU/aBJhmRo7BRSCwHeFe4Wdj3aJoMDsQR68gKU4TRs=;
 b=qKxjVUaYKKmJQ742AGA9wKTdnvCq4buIzdpSnImFYZSWtjXdkRDAgHHkXPzqXSBV5gVin5sf0SQTtnuUuBk39aRZNs79cXnOVKuRp/yL8G5g9THlt5ghf56RwI1ZMexImOByzhuJCpfYx0xtdi+dMzujqKBMlgJFJHD8+LoSHPU=
Received: from DM6PR21CA0015.namprd21.prod.outlook.com (2603:10b6:5:174::25)
 by CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Thu, 15 Dec
 2022 19:16:31 +0000
Received: from DM6NAM11FT085.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:174:cafe::60) by DM6PR21CA0015.outlook.office365.com
 (2603:10b6:5:174::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.5 via Frontend
 Transport; Thu, 15 Dec 2022 19:16:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT085.mail.protection.outlook.com (10.13.172.236) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.12 via Frontend Transport; Thu, 15 Dec 2022 19:16:31 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 15 Dec
 2022 13:16:29 -0600
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <rafael@kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <anson.tsao@amd.com>, <ben@bcheng.me>, <paul@zogpog.com>,
        <bilkow@tutanota.com>, <Shyam-sundar.S-k@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        <stable@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        <linux-acpi@vger.kernel.org>
Subject: [PATCH 1/2] ACPI: x86: s2idle: Force AMD GUID/_REV 2 on HP Elitebook 865
Date:   Thu, 15 Dec 2022 13:16:15 -0600
Message-ID: <20221215191617.1438-2-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221215191617.1438-1-mario.limonciello@amd.com>
References: <20221215191617.1438-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT085:EE_|CY5PR12MB6323:EE_
X-MS-Office365-Filtering-Correlation-Id: b4ef471a-2612-4f8a-8dc7-08daded0dfbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AjilfDpLCdbJn2DXBP7Pt3LJOmfhuiGqNLXAoLDeAn4+Wxs7BvyIa6NfK9GZGV1oOE2ctR++kkbBe8bvCeFvDUJBBOOUaJIT+t/u5hjmfiBAUldIQ94iBcv2VPCQus1Xe9BlwNx63DMWbFAPSbLsYT0yCA6qK8PxDN4wsckMIsHCcDhBjRGAVfCAz7k/eEirQkMu7cUsWHWEVqPpxSjmDC/lc8ey6ifZ88MD3fe7PwoeL9dAh8T3qN9f9HffrTe4jIP98eddqEVIa0LEi0f2fxTHnj79eck+yubwFqecOZEJIWAepXr/D7B4ddIR1OPM57fKR1CFGxC5FWiv+gJ5oQoYsRvmlQXAOOie1euzefmSg8HG/wd8oiDREwOxiFPmxxm5zgobDz+CWBKv65gI/wTmr2w7hUs/rArRT9ZkkNGaSYeyZ+V/8iB1+yPRDYPkNNgotLp+/+8gw7xjVmUrcJieOxattwvPOHuoSaK14cmD/kO/BX3U013RxK4wsfuy6bAVwkIhdhTSbI43cY/64We273dWQxO7H5PaeXyUdMyB0ZgUzzMMV7dMomZGE0YiHDZKVrbwPgPzFmst/yCz/SE5c4XMTdwb9ne3jX4q0QRRxJ5yB4ub7J64nZRDSlO0eFljHc2qFytEB97Rqh5We+1FtI5xgt9/1+0eEQ8gAR6mA41DN0EvEhOQv503MQtjAu7404kPlXl0jizrwRabGScBOb6H5Xpv7nYQKAYozVs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(39860400002)(451199015)(46966006)(40470700004)(36840700001)(36756003)(478600001)(82740400003)(81166007)(2906002)(70586007)(70206006)(4326008)(8936002)(8676002)(5660300002)(82310400005)(36860700001)(86362001)(44832011)(40460700003)(1076003)(316002)(110136005)(54906003)(356005)(336012)(16526019)(2616005)(6666004)(40480700001)(45080400002)(41300700001)(47076005)(26005)(7696005)(426003)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 19:16:31.3805
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b4ef471a-2612-4f8a-8dc7-08daded0dfbc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT085.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6323
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

HP Elitebook 865 supports both the AMD GUID w/ _REV 2 and Microsoft
GUID with _REV 0. Both have very similar code but the AMD GUID
has a special workaround that is specific to a problem with
spurious wakeups on systems with Qualcomm WLAN.

This is believed to be a bug in the Qualcomm WLAN F/W (it doesn't
affect any other WLAN H/W). If this WLAN firmware is fixed this
quirk can be dropped.

Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/acpi/x86/s2idle.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/acpi/x86/s2idle.c b/drivers/acpi/x86/s2idle.c
index 5350c73564b6..422415cb14f4 100644
--- a/drivers/acpi/x86/s2idle.c
+++ b/drivers/acpi/x86/s2idle.c
@@ -401,6 +401,13 @@ static const struct acpi_device_id amd_hid_ids[] = {
 	{}
 };
 
+static int lps0_prefer_amd(const struct dmi_system_id *id)
+{
+	pr_debug("Using AMD GUID w/ _REV 2.\n");
+	rev_id = 2;
+	return 0;
+}
+
 static int lps0_prefer_microsoft(const struct dmi_system_id *id)
 {
 	pr_debug("Preferring Microsoft GUID.\n");
@@ -462,6 +469,19 @@ static const struct dmi_system_id s2idle_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "ROG Flow X16 GV601"),
 		},
 	},
+	{
+		/*
+		 * AMD Rembrandt based HP EliteBook 835/845/865 G9
+		 * Contains specialized AML in AMD/_REV 2 path to avoid
+		 * triggering a bug in Qualcomm WLAN firmware. This may be
+		 * removed in the future if that firmware is fixed.
+		 */
+		.callback = lps0_prefer_amd,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_BOARD_NAME, "8990"),
+		},
+	},
 	{}
 };
 
-- 
2.34.1

