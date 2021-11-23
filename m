Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D64045A47D
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 15:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236433AbhKWOLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 09:11:39 -0500
Received: from mail-mw2nam08on2062.outbound.protection.outlook.com ([40.107.101.62]:14689
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235962AbhKWOL1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 09:11:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f9vA1dJvY8MM+zu064hrL6qVd2VepbkRV2ldL2wQKTcWfrJzb9gJ7c2qxcBaNDhY3kOZmp5ThcvGXi7J51TE0U8TAnPiMo6ji6JG8MUrN5pnSiYoBNPn1ep061Ka9IU6s1WrVkC1zhj7jqSM1qWUn6j04N+jbWQinRlwFIMrXDbVYbYoL6SRX7YMQr/Dksi90aL1Tx3umG2toQY4geE4Tgk0pjouUbHBXvnORtxwlVNrA8U9+dgrV3zFzfPzM+lDfITjkw+SEhfJ5H6vg2sCGSDBcGeDYn9ZkqwJrB6MMHjvp7IpvX/uU4VI5X5GYvzNq3nOzUTsoIg6iBpFyNLYzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tt/jDR0plueoUqBk8rYHPumqYY9Hk+gpqr5Z8SgzxMg=;
 b=ewMDM6ubx38OnlV4F539/vsCCf3+B5jKSWNrdVlkEK91kr7kKA5LcnBc8CK4qbVvj//qcbQgc/rCnuU4vnu5AtAkm3TnSal+pNrXPUMWeFCJT8Hkz/7A1W/wa3Qs9a9Zo1ptm2IYTx0qhDAweoLJ1w14yinO9wrTxzg5KqTAWJ05kdMuYHcLtrRYLaidwZCZ6ZUbyoyPeDGPt/iKxDafX9kdVmaHhtpe5H+SK/JsnvM4s3PZ2Ve8dvOKDa5mX5RW+/QHGzuHteMFDLiaoY6Bsf+oZHR3di1MXHZAZdVfcXjGmmCEqW95poht+0H7wtUDqebvC8l8iKCn38zOqGdVpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tt/jDR0plueoUqBk8rYHPumqYY9Hk+gpqr5Z8SgzxMg=;
 b=f5LNDJESBBmz73AWWsAytD6VSO38urLgVVhoQWKaXI2P5XAZGF6xTFR/yIsvBNnJs/m/phG4hYESaQLvE/z8UyLTOxJ1xCyn/4flPJdg7Cshn29CIn/63GgMsNq5ud7RtuoF6odeqF9+ntsQnHjarSbFtknxXHurgpH0ppqu1RURUtpSNTYxuNU7cAJEPsQ7f7r+lgcjX9+pDLZgLrUACl23BW8WMA0RLMh9TATWhVRHEHXnUoDG10MJLoHh1q3yxMoyqQBagbZTOJVntxrjwFu2Yzn7sDfsdM96W9p+cWJQ9u4Ji4CWTE1WFj8UMZq+o8tgZQoapzkROwqU/cPEBA==
Received: from MWHPR14CA0002.namprd14.prod.outlook.com (2603:10b6:300:ae::12)
 by MN2PR12MB3790.namprd12.prod.outlook.com (2603:10b6:208:164::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Tue, 23 Nov
 2021 14:08:17 +0000
Received: from CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ae:cafe::ee) by MWHPR14CA0002.outlook.office365.com
 (2603:10b6:300:ae::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.20 via Frontend
 Transport; Tue, 23 Nov 2021 14:08:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT055.mail.protection.outlook.com (10.13.175.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4713.20 via Frontend Transport; Tue, 23 Nov 2021 14:08:16 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 23 Nov
 2021 06:08:15 -0800
Received: from audio.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 23 Nov 2021 06:08:13 -0800
From:   Sameer Pujar <spujar@nvidia.com>
To:     <broonie@kernel.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.com>
CC:     <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <alsa-devel@alsa-project.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sameer Pujar <spujar@nvidia.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 5/6] ASoC: tegra: Use normal system sleep for AMX
Date:   Tue, 23 Nov 2021 19:37:38 +0530
Message-ID: <1637676459-31191-6-git-send-email-spujar@nvidia.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1637676459-31191-1-git-send-email-spujar@nvidia.com>
References: <1637676459-31191-1-git-send-email-spujar@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f20eff0b-6bcf-4360-08df-08d9ae8ab20c
X-MS-TrafficTypeDiagnostic: MN2PR12MB3790:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3790D89965770AFA36DE5FDFA7609@MN2PR12MB3790.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q+T0fXJbeBM6oIoCLsFp8EgEigeXK9U2DAMkbEKApOBD3Taqd4Z2WhfNuBFwZO2J/GnXuEH9RuwvLzp+7gZVmydwVy9CnV3tIqoFRT2pDPppxmhMRORkcd763El+/K9RxiFf74gXrYrMIO8NyF1bI6FY/TBQtzJbUWt7t0jHUhNh85cRhIw5uoKrswvPjC5qxicygtjzYfAv9F1GKlXsPayDoxpv5vFHNP/EJvrqgdQsI1fNmBeFVYJIp26o375+2+YwLcN6LEHwNi3G34e4hs1UspRCaH+rUrDsBefyEIKKmfZRj5gaoTA9ivv8Y3JIkP3PKgZhLRIbWiGtYDbU1urav3Nt+HjhlHsnLyUYpqcynrUhq4HatveqFhn1NqGhDCsmhI4CtRJgQvH9EZSVYZ3EvUbbhVH+BtNbNbC6Ei1ZhAT0ggcuFGM4OeaVlT+/aLij0ymWR4brLi5xbjAHodjOJUaPmkwnd1M1UwLeQb0hfgEtuzp4ULZUxOEn7pGqARbqLKPfdEFzmIadiezCgu4/gTzTeFznOyrxrQJ27aS+OK8PVj5a3xV8NATRSyFWzVTYKNDEkS5+QSyVU/7Iu/32MqadgUGVD8JrvSHLFlQ7L33AVTaGUdn+dGc21Gpepzz1E4lpLP0OBmLV5g+t27LfQyiyar2j3nWZ1KMu1GnIJAg2iLEcVQ6tFmus0YUgNuc6engbK77UvCakUnDkcQ==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(2616005)(336012)(186003)(26005)(426003)(4326008)(110136005)(356005)(54906003)(6666004)(82310400004)(83380400001)(5660300002)(7696005)(316002)(2906002)(508600001)(36860700001)(8936002)(86362001)(8676002)(36756003)(70586007)(47076005)(70206006)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2021 14:08:16.4429
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f20eff0b-6bcf-4360-08df-08d9ae8ab20c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3790
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver currently subscribes for a late system sleep call.
The initcall_debug log shows that suspend call for AMX device
happens after the parent device (AHUB). This seems to cause
suspend failure on Jetson TX2 platform. Also there is no use
of having late system sleep specifically for AMX device. Fix
the order by using normal system sleep.

Fixes: 77f7df346c45 ("ASoC: tegra: Add Tegra210 based AMX driver")
Cc: stable@vger.kernel.org
Signed-off-by: Sameer Pujar <spujar@nvidia.com>
---
 sound/soc/tegra/tegra210_amx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/tegra/tegra210_amx.c b/sound/soc/tegra/tegra210_amx.c
index 86ad550..a10d616 100644
--- a/sound/soc/tegra/tegra210_amx.c
+++ b/sound/soc/tegra/tegra210_amx.c
@@ -587,8 +587,8 @@ static int tegra210_amx_platform_remove(struct platform_device *pdev)
 static const struct dev_pm_ops tegra210_amx_pm_ops = {
 	SET_RUNTIME_PM_OPS(tegra210_amx_runtime_suspend,
 			   tegra210_amx_runtime_resume, NULL)
-	SET_LATE_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
-				     pm_runtime_force_resume)
+	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
+				pm_runtime_force_resume)
 };
 
 static struct platform_driver tegra210_amx_driver = {
-- 
2.7.4

