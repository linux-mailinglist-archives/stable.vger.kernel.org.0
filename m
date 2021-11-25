Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5FD45D91C
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 12:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbhKYLXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 06:23:24 -0500
Received: from mail-dm6nam12on2086.outbound.protection.outlook.com ([40.107.243.86]:10141
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1349398AbhKYLVV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 06:21:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W0TPqbmP/rdBCnw9wFCaYYdIlnbfRoLiRrAvOIb5qmn4qMIVkwquXGghK1IUR1SZkdAhEnku9BiEv/oIJgNgu6HOLxq8fJWoDuvzkl+0ckIi7Xo872xkeZmGaX2e2XG1TwvJUwjB9UUGRB4QdECW+6dtMC6kzncssROZC2AVCfW2HaRtM6tRX+3D7FUtkjdGpM+3HYRJbVj1MZ8AYnLsuHj55mV4Wx3ud0A69nn1nNfWzmpO3M1R8AtYiPk0+/SDoMngPdoELXFWHHVZ4y7uO+DbrkRmc1WDlMcNjS9G9hNRul0s/EPJFwIhoAuXsYJ8XRb0tae9RFwL6WMXDGjW3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7s5O1HFFaMX54tfFEKs/QGyt0zsDRNAY1zWMh+hS9yk=;
 b=kjkBndMCDc/zX3UAahUHtNPYK9lh++MiBOpF3ojeL2ebBDsNkn5jhBmW7gKhndYLyfM+Hp5iKWjxBaVbXZkHqH6H1+FelNpD7GyXXI2ayNlAfMO/VtAVZBEA7YWNV+7g2dPb7NHQON1IwtdZ+kvQ7aG9+CZBtTjEpczJADm1CG6BPoQ4LgQtw1aBPBt2ptlUxNBC6HLfDqC3rW7RmyzU9vQRLrM8vL1J2ekkgtVb5DeRudSmkPO0hv0kknPyybS5lcwRgQ19UCCXv0LcAS4joE9K+Ct/InIi1bhyoZaCfNAaYi5rMdL7Z22PFC3A41qsR7uXWIKZgL1CzrhslxqFgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7s5O1HFFaMX54tfFEKs/QGyt0zsDRNAY1zWMh+hS9yk=;
 b=MahGBge9ojT7J80L9bO47kLqU5R86V1DJhh/rbxNVluK7+Cf9w3W+EuDKuSIIRbT+IR4JhOb9MP3Wvf19CTxXICY4jNRmpOZB0Cwpq/ZftR3mo+8m3M2/1ydf/+1CdK6JhgiQFc4mfQg5sUTOafwwoyJM4vjI5XpO4byyTG6QM5w6v5zxlRzSAQMODwATGCklzTsMx4bYrhl5j0W6rRQBTyR2Cg9INEXvsvM3rMDqaJfjFDHw6CFnBEujq1fMHSC0b4ELrdg5asI80Lulx3u8RTe9/7eaqLZfERhj/pqbm+QsNtc1hUGLttat8Jwhj77fnjNwxupV8buwgEVHzj/Kw==
Received: from BN9PR03CA0532.namprd03.prod.outlook.com (2603:10b6:408:131::27)
 by BN9PR12MB5365.namprd12.prod.outlook.com (2603:10b6:408:102::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Thu, 25 Nov
 2021 11:18:07 +0000
Received: from BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:131:cafe::f5) by BN9PR03CA0532.outlook.office365.com
 (2603:10b6:408:131::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend
 Transport; Thu, 25 Nov 2021 11:18:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT032.mail.protection.outlook.com (10.13.177.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Thu, 25 Nov 2021 11:18:06 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 25 Nov
 2021 03:18:06 -0800
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Thu, 25 Nov 2021 03:18:06 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/153] 5.10.82-rc2 review
In-Reply-To: <20211125092029.973858485@linuxfoundation.org>
References: <20211125092029.973858485@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <50f59c3cfba0460f9dc104e357096ec9@HQMAIL109.nvidia.com>
Date:   Thu, 25 Nov 2021 03:18:06 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a22ba0ed-9d02-4c01-9597-08d9b0054188
X-MS-TrafficTypeDiagnostic: BN9PR12MB5365:
X-Microsoft-Antispam-PRVS: <BN9PR12MB5365B7DF9CAE506F8A2616F2D9629@BN9PR12MB5365.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X1JYJ44U/p8IqHDdw4tgR4b7zQitPF6+CUsoYLMDyTxS9Oe1JCkM0lK1pz3ZI/TsnD+ZB2mRW7yakO037C64I7GqoxQ1tNs9cz5MDR2ZCMPdnIPGUkc0Ht7gjGZfjO930TIZJ9VEFQ0ooVcJM3/Ik4IT5y/YOMroXhrHXylsl+nBMEPD2IkR2gUevFHzfaZfSsKTkiZIqTh1j1Wy8RCm2/d6DNMl5GMdJE+Y2nWDuQ0L6GsydbWoNVtFAkY9LXzCUhJa4uEorMFan6uwv6gVQU/YQNa8cn7e7T9DUvYjRPfrSDIotiY6hgfKBGU9ijSgHeMXh/fLTCChMkKIfEJCVe2e7pTydm2eeRtqdNoyKAacDiRSYCkNnLQcK43gO2R0pkttjH2e5VkscIAKr5mIfRUgnUUD1onjJflMh7ZWfla58GMSS3ctEyQwOKT7NoAG8BEZV83GU0uLp7mllrTcMmnSATttDzKsYMoy6IQshypK1dU9enwF5U/bE43hG+/uNtMKjbA6JBlgEK7Rx9mxT2orl4HAFqR8N7XbWXh2182ATJwabCFHhBF12GHYd60P6otTgow7ejSKDmAT1Bti8mg71Y1HWnMmBdFS7Lp3BtBpDPBhoPDGJsY1yU4EhRSEQ7GWdTMkytMnpi44Rincx9qbTq3mPhn2suKe1k+I3lnRg7g1GNjck7WQSZ6DobwbWVt6L9HqrQTqPrzxFA8N2oPsKZtS98rGXgRAZvbvrkYLAMb5Ski8yoj7nfO4Ez3VL3oiGSDNyXQ31g316t8zfZS4QxQ5iaJsUcAOXnsMOrQ=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(7636003)(86362001)(6916009)(82310400004)(7416002)(108616005)(70586007)(2906002)(24736004)(26005)(966005)(508600001)(47076005)(356005)(70206006)(4326008)(186003)(36860700001)(54906003)(336012)(426003)(316002)(5660300002)(8676002)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 11:18:06.8732
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a22ba0ed-9d02-4c01-9597-08d9b0054188
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5365
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 25 Nov 2021 10:23:48 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.82 release.
> There are 153 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Nov 2021 09:20:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.82-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    75 tests:	75 pass, 0 fail

Linux version:	5.10.82-rc2-gc7ee3713feb5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
