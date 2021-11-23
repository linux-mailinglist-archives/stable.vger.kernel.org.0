Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2C145A477
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 15:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235981AbhKWOLZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 09:11:25 -0500
Received: from mail-mw2nam10on2081.outbound.protection.outlook.com ([40.107.94.81]:12258
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235982AbhKWOLU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 09:11:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R1+hqR7ldbCF5jvtV7h1Mk+mCrFHApF0MDL+kNAazcacpM1U2gIAdSstZ5CFvKa9UUpXDagvcHOVhbGpeSavltHc8cPm/c+aiitOMURElNeOL69SjTdzPDCfmhpU+HM3eD5xHjhWDjd5tMfcoN+0u74J5/nP/MXBYCNVHMbCoamYW0DrjiBx79bHtxUh6pg33Nnydv6za7kZ3t3pz+YMBYTaBSyAhCnQU+5LtAPLMVb43D5Dngfj+lN5RkWSacKdY7yR43FOuIfgEMXruCThReygUFZTSywZ2y+leih59uo4T7woxhSfuiFAXw8Na54cB8WDwDP+jps9PDB0tG24ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H1zvqjdBOifEyewf9xaPflazK2Q3w0w9Jyb8+pb3YUY=;
 b=i55VUlg2Il3yB13nZH/pRIVs5jGMuwW6CAO1AM6JveQPJow7R9qmmyTZ2DOMxXY4J0NqjnzHPr40XhAzwIm58lUEX9eX30JyTST99L++PUX7FLDPR2BmY0J5AVFySD2N9I/6lcaxEd35xZ1ktpThWVhkuqbuhv62vw4a8ZosnBDpwl+D3CkCfYbPl8QHuicyPJkCGsa+iuPeuXUB1ia6qx6tO2D2eSZQu8agcIoDOksY6c6YJJzKmAPT0T6p5YXqi7nMDLsuvMLCsI4ZquJWR3v/jUpCLFsZ0LmmwLn67At1WoDrB7b5sFybJnJXLR41xoP2VLFBXfSyl4NvEq3+7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H1zvqjdBOifEyewf9xaPflazK2Q3w0w9Jyb8+pb3YUY=;
 b=tuz7AGCZ44K16ERb2MGA1ytzv7pIr+h65IGji60GuLftzTug+0z0uKXHKKa3XQr45hS+S+ro/PA+on0KKcJN+Vd5oaMLYG2de75TWvNPIsK3QJO4joZjDXfnqtjEPmfr6zWLWf4UwMoDnJynGINAui3IBeRp0/2F/Xe3NLbTXXy4IWWJoezZJFkA3RPl0vQibSJ5k+WVNJp3t8llFHc98ugdGA1LuWblL2MfJqVdms3sf1jlzhH6AECYvmf2eQOji+K75ODlaYy+HAscCuG9WDZLIV70PKVZ13Nam9H+xBmhtOx+2dK8yX6xi1KK3Uamz9YXSj2sCxG7JGbvN12IJw==
Received: from MWHPR21CA0067.namprd21.prod.outlook.com (2603:10b6:300:db::29)
 by BL0PR12MB4755.namprd12.prod.outlook.com (2603:10b6:208:82::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Tue, 23 Nov
 2021 14:08:11 +0000
Received: from CO1NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:db:cafe::68) by MWHPR21CA0067.outlook.office365.com
 (2603:10b6:300:db::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.5 via Frontend
 Transport; Tue, 23 Nov 2021 14:08:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT063.mail.protection.outlook.com (10.13.175.37) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4713.20 via Frontend Transport; Tue, 23 Nov 2021 14:08:10 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 23 Nov
 2021 14:08:09 +0000
Received: from audio.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 23 Nov 2021 06:08:06 -0800
From:   Sameer Pujar <spujar@nvidia.com>
To:     <broonie@kernel.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.com>
CC:     <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <alsa-devel@alsa-project.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sameer Pujar <spujar@nvidia.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 3/6] ASoC: tegra: Use normal system sleep for MVC
Date:   Tue, 23 Nov 2021 19:37:36 +0530
Message-ID: <1637676459-31191-4-git-send-email-spujar@nvidia.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1637676459-31191-1-git-send-email-spujar@nvidia.com>
References: <1637676459-31191-1-git-send-email-spujar@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b4ded4f-1099-4b30-f8bc-08d9ae8aae73
X-MS-TrafficTypeDiagnostic: BL0PR12MB4755:
X-Microsoft-Antispam-PRVS: <BL0PR12MB4755F87DB97FB2621DB391BFA7609@BL0PR12MB4755.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H3PPRfIc/iEIU+nPqOIjCQtxxjZfU1ZEIsFQIC0oxz3iSDNL3L2+CVR69E09pp5m1XXMhmvUu1XJ9iNg4HjCT8LGz9Fy2VFUIkuKLR3K/SvVDiJnkPIU2L5AJeSaBsuETGrNP45djTMGrpEEvtRyyrVYuNL2C8QAukYjfyV23eVPwEJR9+m4MyOEwslSy8pgDX+cf4YZ+7tpQKdnQSifRlctFeSFb3QijeVLJ40TG9hooy9gfLP43tpJRqtzG/T+JTuzJyeihMsRBXGVH5W5gKVjH2zXtR5afkljJqHxfhLoPxxc9/QjQBA/fGX0+VMGqDVdGf6Kw9RjLDw/FXxk/63o8DV/yxPuXs8sOYSKxhag5C/ztzj7w2aZB3boKKWfK2RCCP6PZZbo5MuUjlFNhx7c3myRHgYZBOx6cgviRj4dPLdbRMMmI27IlZkT6I3SfAslMJWT9977G6VaCf2cVo++4E9GUPu4uuuxve5E4puqCWDbp009qauAv1c0B8YZw0HF/HwaHALVFouTFQg8kaCzym3gMcssMEegjyQUDJ93AnYqWhvYLUrSSpGlfouN2Wm6/P/XRGZzDy87uJnWV0bnE7AJEmLykrZEEl8OLkIW3YtXWQUvEJb+PY6lHAwKdcf+5MU678Cn4rHew/4s13fSn0sYhSvkp4kijBABwlVOstEDKhQhoj2xZtJVyElyQrF849n430XWxgdI4iEHZw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(426003)(47076005)(356005)(7636003)(36756003)(2616005)(83380400001)(2906002)(70206006)(70586007)(508600001)(8936002)(7696005)(6666004)(316002)(5660300002)(36860700001)(86362001)(8676002)(54906003)(26005)(186003)(336012)(4326008)(82310400004)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2021 14:08:10.4112
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b4ded4f-1099-4b30-f8bc-08d9ae8aae73
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4755
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver currently subscribes for a late system sleep call.
The initcall_debug log shows that suspend call for MVC device
happens after the parent device (AHUB). This seems to cause
suspend failure on Jetson TX2 platform. Also there is no use
of having late system sleep specifically for MVC device. Fix
the order by using normal system sleep.

Fixes: e539891f9687 ("ASoC: tegra: Add Tegra210 based MVC driver")
Cc: stable@vger.kernel.org
Signed-off-by: Sameer Pujar <spujar@nvidia.com>
---
 sound/soc/tegra/tegra210_mvc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/tegra/tegra210_mvc.c b/sound/soc/tegra/tegra210_mvc.c
index c9859e1..93cbeb6 100644
--- a/sound/soc/tegra/tegra210_mvc.c
+++ b/sound/soc/tegra/tegra210_mvc.c
@@ -641,8 +641,8 @@ static int tegra210_mvc_platform_remove(struct platform_device *pdev)
 static const struct dev_pm_ops tegra210_mvc_pm_ops = {
 	SET_RUNTIME_PM_OPS(tegra210_mvc_runtime_suspend,
 			   tegra210_mvc_runtime_resume, NULL)
-	SET_LATE_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
-				     pm_runtime_force_resume)
+	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
+				pm_runtime_force_resume)
 };
 
 static struct platform_driver tegra210_mvc_driver = {
-- 
2.7.4

