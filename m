Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1AB345A485
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 15:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237371AbhKWOLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 09:11:45 -0500
Received: from mail-sn1anam02on2064.outbound.protection.outlook.com ([40.107.96.64]:54400
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236151AbhKWOLb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 09:11:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WEZjtI0HT3gRqIVoVTb+7ERDbRIGXyoK/Vdc4dY9wROdADfG231bEFWOpyM+IBiMQulhw7674wd8XeSLiIuubRWJbUSRtBRl3EN3m8ei63U3FBPaDdl/Ng9RVh0V0R7XFF5hsKcU0WPiSTnrNRWH+5BMW1ZVEnWJ4ewzdwwQJ6wV7lWv5CF7gY351xkqEHiHRFYAVKPoQ4fsDGVZTjQf/FAuGmfkviymedAc6dPBPt9UYLrzv6u7K1KvVCm8QQrsKfPEUxbZ4Nt2pS7+IrngmAu3jthEcY5bYWZ+vp9b3lQ1LRYqYWTq+VhNKxjMAKO4EWjNzKz2AJal+1iApSOU7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bPRrGyNhCl8uFotwftWP6yziSsSLGlkVrguUbOHeRvI=;
 b=UWzjlgbE2jEKzkCtuC7LB5rPK7GTq5EqR7gx1kWFvKw6Zv7qNO4v8oO39m0urdWGJQaBzPUe6s8MCEcpJgOJSORZr4EE5vkkgBqbBMAvagLlG6Vh7IV2ppsIPbj1Bo2KebB1n9HU2UllkG9LhB2QMGQvBIxwt+wPY6+9B+e/zKvsQPTcFw6Mvk0AmEMMBdyeYp3SHN7Lj50zEFBNiZ4ACUX9b7W+tk3NwS+0d5aVU8COrrVg40YEvfmgV3wfgIfvZgPbyjWq4ApQw4dPVZplQFYkgvVMWPHDAZLL+VmULFmo6AzPZWvjpWQN7/zBs18AIGkERe+MKZjBzzDNgIP6KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bPRrGyNhCl8uFotwftWP6yziSsSLGlkVrguUbOHeRvI=;
 b=WjZSDnjPllf1uBkz5oePDH3Azlb98kdu//QtABZwMvoiHeo/cZJeZM6FJY5Fz4HDKoQFzFNDGgze61DimQmD8MdrdSgQHR9KZ/bkdETEEoJgZLD0JjrO74KmFlL/HIyyCcM9JjAz+7sRgr8kxpDhnwgci1FMgMTmLrcg7SeO3FeSkKwH0UZXM0UYMSXqlIHt4cvxY8jtE2++PZKbdQVfgwqz+JCa7Hqo1SGzTHqd/5I1C+Kkkwuuc4jyvXiDUXZPe300COT57CDLjb+06hm96x4DKYyNqUGgBAXw6BdldzQkRc7ozzFeHyXmBflzQ0H1GbLsw9vSfIXb5yh8ClIhAA==
Received: from MWHPR13CA0003.namprd13.prod.outlook.com (2603:10b6:300:16::13)
 by BN9PR12MB5258.namprd12.prod.outlook.com (2603:10b6:408:11f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Tue, 23 Nov
 2021 14:08:21 +0000
Received: from CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:16:cafe::9a) by MWHPR13CA0003.outlook.office365.com
 (2603:10b6:300:16::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.13 via Frontend
 Transport; Tue, 23 Nov 2021 14:08:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT067.mail.protection.outlook.com (10.13.174.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4713.20 via Frontend Transport; Tue, 23 Nov 2021 14:08:20 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 23 Nov
 2021 14:08:18 +0000
Received: from audio.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 23 Nov 2021 06:08:16 -0800
From:   Sameer Pujar <spujar@nvidia.com>
To:     <broonie@kernel.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.com>
CC:     <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <alsa-devel@alsa-project.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sameer Pujar <spujar@nvidia.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 6/6] ASoC: tegra: Use normal system sleep for ADX
Date:   Tue, 23 Nov 2021 19:37:39 +0530
Message-ID: <1637676459-31191-7-git-send-email-spujar@nvidia.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1637676459-31191-1-git-send-email-spujar@nvidia.com>
References: <1637676459-31191-1-git-send-email-spujar@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5f21540-525b-4024-d71a-08d9ae8ab490
X-MS-TrafficTypeDiagnostic: BN9PR12MB5258:
X-Microsoft-Antispam-PRVS: <BN9PR12MB525853DC3A733CC0DA327986A7609@BN9PR12MB5258.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s4WjAGFzduXIFsUuoq4v2goEGXeTwy8SNtFL3qYSrnhsu5vsaB8WWYa0yvb90LauZ8q0cME+jqPN3wFYVs4sQ0oPtbbqsK0a9C0sfW6pA6O7YXSSoTS+rttYcEj9wkVwma3paGucpM8PjF6h3W/M+IMJrC8fmmH4Ga8OKCyahAiOtMm86DFZ/ZEVURVuZhN4TggM2QuL06WIKiz3KIE8mr8bdBupz7/YMw/EF0YWQpEWR8Jgq9jpDdR6WR321GqFcrHCttC2R5xiw91U9wUveCPTrFjwb2VzecYBl3UoxOzZZs0RHSpeujBr/yc61zJAJoKBFamOihKtIv/56CgJOiG27rT6LIZwCAWUpKgmvf8Kd5sqe0PffTZvoU+BJIfznWa/qifBPwWAhKkm00Y1lmUX5H4w4LZwGNV/sYZpf+ripZ6dGUfsYETCTTrwNF9tNCbfHG1Bwt12Rm+Y+OTIYS8dDCYE5Wz+DECTX2utJlcQuVhN/xgHCdfuFP/o/l/dQVSMRDs2dRqJGSdHjY5NqYStXMcki8ofrVfDKmj0YVjlG5h1ydaf3KmzTlI9ZoqNJEQqfY/tQ4x1naGHRjGYpxkGQVAjUEl5P8P/+a8SOoh9qUWcgfsC70Qi/6qLzDp1gg7idrojpiOUonayZHKwA6S2uHZo6kdPr8BNwjZf6O13CNhEXABETdUBBEKaQZarksG9NROzgW7Q9gpbYxtFCQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(186003)(36860700001)(356005)(8936002)(2906002)(7696005)(86362001)(36756003)(8676002)(7636003)(4326008)(316002)(508600001)(426003)(2616005)(5660300002)(70206006)(83380400001)(26005)(54906003)(336012)(110136005)(6666004)(70586007)(82310400004)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2021 14:08:20.6727
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5f21540-525b-4024-d71a-08d9ae8ab490
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5258
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver currently subscribes for a late system sleep call.
The initcall_debug log shows that suspend call for ADX device
happens after the parent device (AHUB). This seems to cause
suspend failure on Jetson TX2 platform. Also there is no use
of having late system sleep specifically for ADX device. Fix
the order by using normal system sleep.

Fixes: a99ab6f395a9 ("ASoC: tegra: Add Tegra210 based ADX driver")
Cc: stable@vger.kernel.org
Signed-off-by: Sameer Pujar <spujar@nvidia.com>
---
 sound/soc/tegra/tegra210_adx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/tegra/tegra210_adx.c b/sound/soc/tegra/tegra210_adx.c
index 035e24e..69fabf9 100644
--- a/sound/soc/tegra/tegra210_adx.c
+++ b/sound/soc/tegra/tegra210_adx.c
@@ -518,8 +518,8 @@ static int tegra210_adx_platform_remove(struct platform_device *pdev)
 static const struct dev_pm_ops tegra210_adx_pm_ops = {
 	SET_RUNTIME_PM_OPS(tegra210_adx_runtime_suspend,
 			   tegra210_adx_runtime_resume, NULL)
-	SET_LATE_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
-				     pm_runtime_force_resume)
+	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
+				pm_runtime_force_resume)
 };
 
 static struct platform_driver tegra210_adx_driver = {
-- 
2.7.4

