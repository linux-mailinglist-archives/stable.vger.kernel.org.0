Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110D445A474
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 15:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235896AbhKWOLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 09:11:18 -0500
Received: from mail-mw2nam08on2070.outbound.protection.outlook.com ([40.107.101.70]:13920
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235672AbhKWOLR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 09:11:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mST+NzEPmLVDv4cIOcHdDt1j6VeZB+Kd9lGUqF2DiyYHJghOElEEyWdIHtcrtoBBKiVMMiiDnQ+SECas8pbrbK1CRZkY8C06Bjg/0po35Sog/xK4n6jC3h+LWgWaE/l5DFn+mZnoQe3mw9AS6dEp1Iro4qx5JfS4pHH7ujO5UMcC+WgJhhTNSdRnZ5HHXGaX5SDO2JoaZvvjKwkwmRs2TuLMjxTY7DhYWsA5DpYtMtRrSGAubM7Ca2oEDjd5IKvmazorQBtWU+gswrVlzkjZeodn5p8fyLM2Y5V87LLMvQ8S5d4DZE8JSz00RI99MZUC5+R0hlnMpVn8LCHxEcveGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1BVQqbO/azsP7xH9wz7q70yDkNkHpn5tWo3o3k6/IXE=;
 b=eBJMru0p9E2UHRpLCE8C51V0vbGmbQ8Pfv9vJd/z2thpdM7XqOSokQnTkM/2/l42vNuupX401SbbFfOJGb/Z3Ldp94aVXl9fJW/MTSsNLL4QbtNWQCleFG4ll30kZ5VO/ozFAJYLIEOsuAQphJ4ljy0G1ndPYcJJYUiABqJWYnNqu1lx7blfzPlFrr4Q0Bkflvgfa9hpwukHvQ+TA06BydWzg9nYuTRSpPBj/Jafe2q8UkYxhsa9STx5IjHbNAl7dFOzkSxC3ih6XgfI0PDO+JunKvjfq03Hxif6th2rCKCdn5VbRrS69J/e30pxncIx3R9aqFUQ5a7HDHOU1Gn4Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1BVQqbO/azsP7xH9wz7q70yDkNkHpn5tWo3o3k6/IXE=;
 b=fRT/KxftfCBhHIAy8OWIvpkJYgieB1QHM6i8rglYRxfXR7JNq0aqczRil0O5+QQaOjVY6te7c4GDDHtDRr0IUUNMxhS6Ny6JtyTZadcYbmnAs1dQjQkFe3xpiZlp4m9wt+eymMqqHa7B+/lfFOgOO6DYphU6B0ob3eny99AuujD1nXtRsSG7G/2olVp8obquN1LsL0dc+ylrXE3WnrUmbPf2I6yFsCicJUyq0Jasqhg317FNc0K1nfkszb6VgcALshsGP5lQxCgLF8HFyfNZQMawW2+CZ9l16vVXyTKJs8T1m0bQalq2lTqTwpOAI6HjnbzxmRvMBhHm4XtMt9I4GQ==
Received: from MW4PR04CA0038.namprd04.prod.outlook.com (2603:10b6:303:6a::13)
 by BYAPR12MB2870.namprd12.prod.outlook.com (2603:10b6:a03:12d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Tue, 23 Nov
 2021 14:08:07 +0000
Received: from CO1NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::b6) by MW4PR04CA0038.outlook.office365.com
 (2603:10b6:303:6a::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22 via Frontend
 Transport; Tue, 23 Nov 2021 14:08:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT031.mail.protection.outlook.com (10.13.174.118) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4713.20 via Frontend Transport; Tue, 23 Nov 2021 14:08:07 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 23 Nov
 2021 06:08:06 -0800
Received: from audio.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 23 Nov 2021 06:08:03 -0800
From:   Sameer Pujar <spujar@nvidia.com>
To:     <broonie@kernel.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.com>
CC:     <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <alsa-devel@alsa-project.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sameer Pujar <spujar@nvidia.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 2/6] ASoC: tegra: Use normal system sleep for SFC
Date:   Tue, 23 Nov 2021 19:37:35 +0530
Message-ID: <1637676459-31191-3-git-send-email-spujar@nvidia.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1637676459-31191-1-git-send-email-spujar@nvidia.com>
References: <1637676459-31191-1-git-send-email-spujar@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b30f193-d12d-4158-813d-08d9ae8aac7f
X-MS-TrafficTypeDiagnostic: BYAPR12MB2870:
X-Microsoft-Antispam-PRVS: <BYAPR12MB28704793F5836262F814FE95A7609@BYAPR12MB2870.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R9tVB4i3pS2WbUxg8hHpXMjyTv5jMK6XSVUJJ/wop/mldxDIDYPLmwgNhMlvOkBWC+Q9BomToMWcifa8aJcYQlCuZt5peeCqBGoCe1PYWzQM1x/K/1KMhZMEt39QzrrLDBCd1ZM0lcs9ubmQNeJzNlmYJoP6mYBdEuDfwaTsPXOO4h7P8ZuendY20ZRkGYTCNMCpwwWmegMnZ2qYDVT7nKoi+cBQmknzcFj7VDFuaJ0n6G0s7/z9y6gZOUIKlulIQIJHiakSBEu05z8PLHUVBu6XBrcQToQr9b3VreZ+dkfaOC00dqYvXO7mCkVZGajALAGLOC1txFTmHJpYgWml+yHcnpxwqA/47WBNTDmxpmWLcFfSPsDtXHJiwD1x+inUFPv+vA9tFyLHgCh16R4FFmXg5FSYG/EN0ZscpNGxLwLToCYzbNZifcpI7WKYoWHEIULJFFk9N8LFDNo1hV9KKp1Bhj1/ZscwxcYkOBynA9g1YeR1e3yznq6yMMRkx5FKj++25V2i0Ziw7IMZRdNCvXU1c5SFnZ8pMEQuzcKn9MhpZHtzNjSC7BvPiAxWk33aszC/o+Ok1yDTD++ZtXww0/V+en7dzdD7lea5jeJ0U//THOpQ4iEVG7x42IWQ5VfJ5xRFtTOQ14e8UU/gBRW6HhihzJQk67stS4MsSZuItAKV5mHonrKqrzzAmdhNfom1aYMCfVHXd7I926lrp92jCw==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(5660300002)(2906002)(86362001)(110136005)(356005)(83380400001)(6666004)(8676002)(8936002)(7636003)(70206006)(186003)(70586007)(2616005)(7696005)(47076005)(36756003)(36860700001)(4326008)(426003)(54906003)(508600001)(82310400004)(336012)(26005)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2021 14:08:07.1273
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b30f193-d12d-4158-813d-08d9ae8aac7f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2870
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver currently subscribes for a late system sleep call.
The initcall_debug log shows that suspend call for SFC device
happens after the parent device (AHUB). This seems to cause
suspend failure on Jetson TX2 platform. Also there is no use
of having late system sleep specifically for SFC device. Fix
the order by using normal system sleep.

Fixes: b2f74ec53a6c ("ASoC: tegra: Add Tegra210 based SFC driver")
Cc: stable@vger.kernel.org
Signed-off-by: Sameer Pujar <spujar@nvidia.com>
---
 sound/soc/tegra/tegra210_sfc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/tegra/tegra210_sfc.c b/sound/soc/tegra/tegra210_sfc.c
index 955cecd..af33bf2 100644
--- a/sound/soc/tegra/tegra210_sfc.c
+++ b/sound/soc/tegra/tegra210_sfc.c
@@ -3602,8 +3602,8 @@ static int tegra210_sfc_platform_remove(struct platform_device *pdev)
 static const struct dev_pm_ops tegra210_sfc_pm_ops = {
 	SET_RUNTIME_PM_OPS(tegra210_sfc_runtime_suspend,
 			   tegra210_sfc_runtime_resume, NULL)
-	SET_LATE_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
-				     pm_runtime_force_resume)
+	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
+				pm_runtime_force_resume)
 };
 
 static struct platform_driver tegra210_sfc_driver = {
-- 
2.7.4

