Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E588045A47C
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 15:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236043AbhKWOLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 09:11:39 -0500
Received: from mail-dm6nam12on2048.outbound.protection.outlook.com ([40.107.243.48]:16481
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235827AbhKWOLZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 09:11:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PFing0uk8KXA70EZHdJC1K7tPVAP3DG0en+bOVtd/Q0E5TDQmfEk1V8HXlNfm2drMUUMWHBodeyfsZBLgTuVr1i8wZBFAuv+2YSirir0Hozp0j+mkwMAYBnCegjJN480BoMBJdnOWxLE3okAh2eWQ1lgVhyo+KTcQTnaM9xDC0bIictDIw86d+YSRmIwma5+xYQTmahv3DC35QMZkEO8ulaDM0QV9/ARghuK8PyLaw2wiulP+EYE0xIhg3p0f0Zz18nlflbz+pQggmz1x2a8YRVGSRiT98TnAEYa/6yrmQCTwvH4QTb59kbbur1QQ3l4GEl1lLMm7BWlNHf1OI3QAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=88HRFlndMgZw+NFWlebp3u5EBaZ3SzxrTK56uBzL46s=;
 b=iJ/Ma2yNvECQC82vMsox6mIp95hnH7vfEI+xdPAUUhzE9rBDx0v9jwJMSSvmK9xVst9ykOLtnmQozuwBIkKg9Cbbgot1BV821wStENWbdmkV8w1UMwL71gsv+IGOcaowfUuw6nfK9rLvJ67om+wf7qzhC9IPGVdtHflYcjBo7g8qBG6cPYlGZUFNiC66tTlZIQ6eHyZt1oru6aIF9bDgHe4+vVCymNVqnybf4RsP5jvaziPAec5qxV1NfJBDNWvOk5JAZ/YSGTHaewmYB3jLWz7SEf8Tpyvco/6LWM8KrpG1boMgRLuC4PJfUfeYQxnQVDn+eoqSN+eAx6Sb9WK/5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=perex.cz smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=88HRFlndMgZw+NFWlebp3u5EBaZ3SzxrTK56uBzL46s=;
 b=UtPVfdaBrJoGnpECjGv5Q88ndZMx+uEoJjLQ6FeKGYisDKKTfoUZOASJBMX5SsuFi/ULVUUkWvuR/yDMEgNn1vND3AVXXwcCo5CgMFJaXi29Gra+QJS8nXK84cryND4BBPGGyEMGqUuastTv1/XSdbPa/EfMPYcRyDODBoqDceMRIsKOMbIlfRur4Uu629ZmIiDwINcmVGDr6EwgvOorzutWpJOIEk5Mjtranerl0s7xKDuw+4YURYYNuuHKJUMj05lkHJeKBK0UUCjlasLmqf6RIDU4C/rW1vmrsol/iXGlwiqc0SO/mXw/NbKCXmvmR3xfvzjOa8YDlS8c73qsmw==
Received: from CO2PR05CA0071.namprd05.prod.outlook.com (2603:10b6:102:2::39)
 by DM5PR12MB2455.namprd12.prod.outlook.com (2603:10b6:4:b7::39) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Tue, 23 Nov
 2021 14:08:14 +0000
Received: from CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:102:2:cafe::9d) by CO2PR05CA0071.outlook.office365.com
 (2603:10b6:102:2::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.19 via Frontend
 Transport; Tue, 23 Nov 2021 14:08:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT060.mail.protection.outlook.com (10.13.175.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4713.20 via Frontend Transport; Tue, 23 Nov 2021 14:08:13 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 23 Nov
 2021 14:08:13 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 23 Nov
 2021 14:08:12 +0000
Received: from audio.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 23 Nov 2021 06:08:09 -0800
From:   Sameer Pujar <spujar@nvidia.com>
To:     <broonie@kernel.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.com>
CC:     <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <alsa-devel@alsa-project.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sameer Pujar <spujar@nvidia.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 4/6] ASoC: tegra: Use normal system sleep for Mixer
Date:   Tue, 23 Nov 2021 19:37:37 +0530
Message-ID: <1637676459-31191-5-git-send-email-spujar@nvidia.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1637676459-31191-1-git-send-email-spujar@nvidia.com>
References: <1637676459-31191-1-git-send-email-spujar@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a81f014c-5068-48e6-7c3c-08d9ae8ab043
X-MS-TrafficTypeDiagnostic: DM5PR12MB2455:
X-Microsoft-Antispam-PRVS: <DM5PR12MB24554ED405F83DE76B8C8010A7609@DM5PR12MB2455.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3E0WSbZNCr6kKt1HsPM0lHdnOLjX9cmJ2aoblHs92Rvb0UEz2XIcXfV423al83yNmc9QinlAOhoUJA+by29U6ZKCsDuHYOG/jmxkDIkFswXA5yGpB0yyhMgxjAVO0BRx4/OpTFPAiyxXirxq7fythd9GVWLkFcaVGEyl3u/F2fYWuszI5oSvoiiswzQXgB4pGv/qCY49xtmzsUO6bFVMF1HgPNNB6Xb4QAZtFWeIvE/Pk7hmz/FE11DnUBpsKLMonyH6jxOWWPO1RFfs37TUrxrVNRdE06fsFGGX7YSxGGLMYh7AJXbE22NdVUNWCeI+iY6mUqRL6dOTOB9pWtlBBaPMzvzacY/R1SuX2DSuqOrca2YJwFBygN0e2jB+8arX6M0aTbzBEyx8PDr4hWviRMCiN4qrJx6n/pPhypNCOxdC5qLGo1jIDBfZ3Hliv2RuBlr5WLflhE+fp7WqhfeaL4jdOoWBd1WrndNLBjH0y1FrBPr6oayaCd3prxHF/KywVuqv/S7XlPOPPKQgduTOI3XIcRMnh1VEWsiUj9WdDwPMaWDUEQmZYEoyJXvYSnt/cK2blUdOwqTEAo7QLIPjil9ppwOP7kaSlN+nZccoTA2P3LO5+rmyONHBNCgRVRwQjXcJ18+KaBvFRPNAaKzkxFC4/B+254o397YIWN6vKqU5yK7DvClg0FrJGKDjZZl4/xkRUA4ZOOQYdIzy5XS3hg==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(26005)(36860700001)(7696005)(186003)(508600001)(336012)(2616005)(54906003)(86362001)(7636003)(8936002)(36756003)(83380400001)(316002)(110136005)(36906005)(70206006)(8676002)(2906002)(70586007)(6666004)(356005)(5660300002)(47076005)(426003)(82310400004)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2021 14:08:13.4499
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a81f014c-5068-48e6-7c3c-08d9ae8ab043
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2455
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver currently subscribes for a late system sleep call.
The initcall_debug log shows that suspend call for Mixer device
happens after the parent device (AHUB). This seems to cause
suspend failure on Jetson TX2 platform. Also there is no use
of having late system sleep specifically for Mixer device. Fix
the order by using normal system sleep.

Fixes: 05bb3d5ec64a ("ASoC: tegra: Add Tegra210 based Mixer driver")
Cc: stable@vger.kernel.org
Signed-off-by: Sameer Pujar <spujar@nvidia.com>
---
 sound/soc/tegra/tegra210_mixer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/tegra/tegra210_mixer.c b/sound/soc/tegra/tegra210_mixer.c
index 6fb041c..9513034 100644
--- a/sound/soc/tegra/tegra210_mixer.c
+++ b/sound/soc/tegra/tegra210_mixer.c
@@ -670,8 +670,8 @@ static int tegra210_mixer_platform_remove(struct platform_device *pdev)
 static const struct dev_pm_ops tegra210_mixer_pm_ops = {
 	SET_RUNTIME_PM_OPS(tegra210_mixer_runtime_suspend,
 			   tegra210_mixer_runtime_resume, NULL)
-	SET_LATE_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
-				     pm_runtime_force_resume)
+	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
+				pm_runtime_force_resume)
 };
 
 static struct platform_driver tegra210_mixer_driver = {
-- 
2.7.4

