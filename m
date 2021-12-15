Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB0747627E
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 21:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbhLOUBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 15:01:02 -0500
Received: from mail-bn8nam12on2085.outbound.protection.outlook.com ([40.107.237.85]:26646
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229699AbhLOUBC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Dec 2021 15:01:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XoEHgxj+Myt2pg27RJ3Axz0aARU4z4UYeMvUcmUQ/rjhuJImzHHkR4UsrB0phffMcjvgNJC/XQGrMUHTMKUMV3MExFF/vV+nZlFNQRm+Gf4FIC7UrYyWk4Xf7DxH7Yyh8kWc16ujGqQjaLgU54rmL3mcdT2UbtOG0HFHqwZtubQGgiZvUsYdyPlG1aqRlnvaMGNKGEPyiZnMRENbq13Z0PsQv99Qb9Ukb1a8pSxdCvRy1C4GkykuhThAhVh4ir0dKvMKRtLU/8c/QqazCfkSU7HA8qAKRuePysNo4PQovfcpWhCBgU0ejXeM+t2m0//yRuzIwE6yK0BFD3TpDua0gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d6HAPPerDuS3H/S3hxB4ArXy0GyrP/qmRaVrAz/r9Bs=;
 b=PpRLC0VX8StO5fZBkm62rLNc22hRWntty59fWJYPfWtu0mLUCqEJ1YQy6n1+siLdf7CHVtkoNBiiQAuRbvOuKTRx9fdkAwUaX7y7qzj8bwOU8oZrTsoNsFTNA2BD7cNEgK/kvyH2CmNIOLdbB4HouerkgcREEF/ePz2vOCoWZFPaM29kkX76esej7PMARscCnFuj7zvRoPIXEixNtxHI2wGMz72MdtxWXuv4CVPxeucFldgVmwgokhM/5PDAzicisQFZTGawvWraVO7dgyT7/xAKE6DK+BRSIu2n2rKHtC0WxHGrgFfkbRDFGtRcs3RxE8fo0eJltPPOMeVogrm3Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.14) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d6HAPPerDuS3H/S3hxB4ArXy0GyrP/qmRaVrAz/r9Bs=;
 b=TIqMxdKniBjZRTu6CDdHgx91cOH8ZVok2ZxE87GMsF0TIFe32ujV/mrcqazfFEGS5cfswFszYWF3TfMKPoRyijreWtqHBwNTcyMputNGEeINhYTQC8q1rHOHmeXvgQ3I3IJoVXrwuRbBup0RULLRQmKBr8MimFgjnUVhu5FUnBu/lzTGBN98OnGz64YwcHrrL1IarpBqKtqyqZpHJ3NRazaG4rf4G63qddC1VEMVkfs03eGGuOPoAh2cr3NTPEpxydoE547BDAykJR4TrHAMvd5ziGBRh5X5NCP7RxG4d9Sc63gHrorEEqRy134G0WOHFF2OrIBGIYx1oddUl1u7rA==
Received: from BN6PR1701CA0011.namprd17.prod.outlook.com
 (2603:10b6:405:15::21) by DM6PR12MB3419.namprd12.prod.outlook.com
 (2603:10b6:5:3c::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Wed, 15 Dec
 2021 20:00:59 +0000
Received: from BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:15:cafe::b0) by BN6PR1701CA0011.outlook.office365.com
 (2603:10b6:405:15::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14 via Frontend
 Transport; Wed, 15 Dec 2021 20:00:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.14)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.14 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.14; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.14) by
 BN8NAM11FT034.mail.protection.outlook.com (10.13.176.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4778.13 via Frontend Transport; Wed, 15 Dec 2021 20:00:58 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 15 Dec
 2021 20:00:36 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 15 Dec
 2021 20:00:35 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Wed, 15 Dec 2021 20:00:35 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/18] 5.4.166-rc1 review
In-Reply-To: <20211215172022.795825673@linuxfoundation.org>
References: <20211215172022.795825673@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <2ed7761f645f40538a255a4185a70200@HQMAIL105.nvidia.com>
Date:   Wed, 15 Dec 2021 20:00:35 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa82f857-2fa3-4537-65b9-08d9c0059d14
X-MS-TrafficTypeDiagnostic: DM6PR12MB3419:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3419E427E168DB1D47850F45D9769@DM6PR12MB3419.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gU4bCnC6ERhWo7kSZNY2DWlqqZho1P/zp9RurMoTtsQaUdMaBqY2GxIM7xOBHivgM8exlkjqWa/AcpMPsTFiKpHQpw1/Ldo4UhZ71LhSgPpQ2oPy+oKhp/NFA5TwGLCJr+tkfraHxtl+CU4lbYRGMNfrF3XxL1cBuxbmfcwAnSmPqbxKAmgcIEF4FUaBe1zgHVBjVU7r8LhXHdl9sjQ4rnqR3+9zMIMVFMTZC8nrKCM4gMOhh6bBNjGaS5AvrVk/4Qb5iaSvZ0CHnXGoyXxenStud0aTPOL1poj1PCwkepHyLkGt7K7aEtm7Od+ryuLiZG+S2XH/kQRlJBEXhtdqGfigz+CmFyjqh/vdOPduWkrYFLSJ5yqsmp+FeK+QnM8cnNHHGBCQk68vEO2GcfwwbX/LKfoDsK1MeUGmEOvgkPhl6nbe65PeWpF0S3JlrLqAiuUl1LUlf5IbUWoCyQl62xfjbuu5fBg3VpXtF1btPHIqRXnH46S9NcSDaY3E78cUTBekQtpCbUNe6KD21qdLKfYOfxtdtz1oKT+m63eV9zeOCXCJk2w275ecEUQfsfnOWWl39p0OTi2vWH0cief/JhHB4I5BmmXNjSZKlJkmQFn2fhbzd8jAaDTyb4KBLp3P+apaMfHaIwmn11YEMJDwlir+bTpiVNEx71fZ/hlKSH5GlPqT6nbn+oHz63rSrV6Mn10gezfSpPtJjW8SOu80afp1hL8ceGHRw5h89Jis9npNdJ8PZ0irPCl60w3VBAfVwcinN6xArgMcS9PWgWdOdhpDTyKu/0N56GbWlaFr/q4++VXcSm1fjNJMgpFtf/Bw1B8es+SOhea3s+heozU3lJtwYhdJhjDtu0iMpHgOfJXiEVgKeAJffePLTW+ayNYC
X-Forefront-Antispam-Report: CIP:203.18.50.14;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(336012)(426003)(186003)(5660300002)(2906002)(47076005)(70206006)(7636003)(6916009)(34020700004)(508600001)(36860700001)(82310400004)(8936002)(356005)(40460700001)(86362001)(26005)(8676002)(7416002)(316002)(108616005)(24736004)(70586007)(4326008)(966005)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2021 20:00:58.7521
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa82f857-2fa3-4537-65b9-08d9c0059d14
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.14];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3419
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 15 Dec 2021 18:21:21 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.166 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Dec 2021 17:20:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.166-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    59 tests:	59 pass, 0 fail

Linux version:	5.4.166-rc1-gb780ab989d60
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
