Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A82A432DD7
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 08:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbhJSGKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 02:10:45 -0400
Received: from mail-dm6nam10on2069.outbound.protection.outlook.com ([40.107.93.69]:39361
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229742AbhJSGKo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Oct 2021 02:10:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PTbF089UFfjTTIZ12anGfUev2tGox1eQIH5gM+H/5zx7x3Magmd02Sd01ZocJBFh9brajnKle0iSHij6gnOsVK/7g9vsUkeb0L7fqiuUuF/onXTo39EUgW5ry3HDwD617faMx/sRAX0X51mFNFjCVXXmLZO9P4PLyxP1v1zV9QoFyBZoPaRawdmoj+QfXqqYeEFHHw30j8E+/uYzKoFU5aFX8y0MGrI3YLiij2GpzGxPUIkkJg22srPx71aVL300oLu1D6cDk4ZucKvZ87Nl/LfQma+ZoZOcLNc4QyXeGQz5x+7PFkuaQxPo/wFSMVccMViuipw20Artqe3FfGgntQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8typdrtiMULmw6WTRP42FtPmsHPybPUD74mDPAL2E6w=;
 b=FpKSbbIlnOQDztTKNFCPXX5Wo8QfBjdRi9Plf/HFzqXZBwWWKHp/TPhj9D+hX2d2A2EQEPMHIR8ZgpTVjoq1wtMHEwGt72LXLyMQw3jr9ET7CV+wuCA/APnllcZwSHL+8fypqI1zBSIfGdTe+zB1D8lbsbsqIXrBcr9FESerylrA1mW/sXQRnEyTDhMym7VvlxuodvUelloB46sIoN/APhddSh2E5JPKT7z2UO4zzAUZi64cxNjQUvQlFGQVQgc0ffCPX0QkWfllPN0nRYpkfz3+OpBMoQjc45NoX0hcm7DxLAoI0ZN1wX1aIKC7yytC9m7jolIheZOUz7nChTZ2sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8typdrtiMULmw6WTRP42FtPmsHPybPUD74mDPAL2E6w=;
 b=n9iqmvXbEQ8qHXymY814tx+pVTTc0hmhlP5OgyTR+AoKd/8pokFkT8Qe0jaUi9d+37THeTi1IMRFA4mmlRp2i9Won6D2Mjyn4/lL+qgm8Ubz/CNNdKKIZagD+pr5b8/7e2PfXOwShF9HP4ckXA6k4V2VZPn71HwRm1g8zLdYWsBFPtIfQA4ZfWw2udOYq+/x72RSmiWXE1pNqfrQqBFd/PGfRdOT9q4VzhXSirx0fZ0g0uCEpbIY6s7T+x7P+rhNetJnBXvSppOX/7dENqYdsW92YFzMKdDSGH8EFGPKYnHXWIFdiEbLv9VoownAM1x84G3QnnMmKd8MWD6SKPSi7Q==
Received: from BN9PR03CA0346.namprd03.prod.outlook.com (2603:10b6:408:f6::21)
 by DM6PR12MB4636.namprd12.prod.outlook.com (2603:10b6:5:161::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Tue, 19 Oct
 2021 06:08:30 +0000
Received: from BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::ed) by BN9PR03CA0346.outlook.office365.com
 (2603:10b6:408:f6::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17 via Frontend
 Transport; Tue, 19 Oct 2021 06:08:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT025.mail.protection.outlook.com (10.13.177.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 06:08:29 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 19 Oct
 2021 06:08:26 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 19 Oct 2021 06:08:26 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/39] 4.14.252-rc1 review
In-Reply-To: <20211018132325.426739023@linuxfoundation.org>
References: <20211018132325.426739023@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e0755150259d406a8ef8e91754140b17@HQMAIL105.nvidia.com>
Date:   Tue, 19 Oct 2021 06:08:26 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 039da1f6-cd34-4ab4-1153-08d992c6df72
X-MS-TrafficTypeDiagnostic: DM6PR12MB4636:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4636D909ED0491264E9C4105D9BD9@DM6PR12MB4636.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XpvfvYo6X6Ld+gk9hDjjp6QQ5gAns8wZ64l6sHP/An+LwvsGAJhBW/yf/BN7zWypucy/8BUnevSSECgg8PXQfpqfYGMlgArNYFGvBXyyNXVkkdyWj2GQq166VFufi83bnjID92QQ9ve+USvCOJ42d+C1L1dNXLMRqHqfvklWvbFPnYUqARX3kENVS5/XzfWPlf4a6/aKjGh7HWM/B4VwdGUZJ34GnmyLpf6zWzuaGEimOsAdD8Z4BrRdWbQrkOx4N/abbYWWGTTn0HwACIok5gc2WKgZwL6R5nqMtwD0MNINhGiDpeok5MBl8sfCWh3y4xfFNHFNkptIHBhUt3WlC2GHlv6f041oonxafbldzaOjjqLsSu6a82LxP5UQALUl7j7DtZXxD4q80xfAN51MH+6dIG5g87fKsU1kZI85n+WzVRlhPuYNTREgLC/inQkOsOCBWyB+dI7P8MDbK+ps8QGcnJr4EIZYgRagYBVov2HtboJtomPjuapCWEjbJXL/roYFsS5X0LbFNZceuUcXvlikD7zjua2SW8O1SR7P1qmpJTksrDW+LzGi2ssNVpncCEBmr1cXwCEBteQsCX94dRWEbWN8rhdM06kQdLl1wgQQPJK3y+glDaU1x6HI7REvWIlxSe0pNVMc4rKGg4agGpl0qYgcxI0Ftps+9N/iAjD3SjPwKjcpMwmEHVFEj15ZvjvE6RyrHDwQcOR8SFbp7RO+B4Ccwpa4uS8CAO1QLz+2droRPquzQa47+XcEc0+9sUQxQjTMnevIEKwZ+WsOejttsBFXCsfQVJACjdT787w=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(26005)(5660300002)(4326008)(36860700001)(54906003)(316002)(82310400003)(47076005)(108616005)(7636003)(356005)(2906002)(86362001)(426003)(6916009)(336012)(7416002)(8676002)(508600001)(24736004)(8936002)(186003)(966005)(70586007)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 06:08:29.4193
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 039da1f6-cd34-4ab4-1153-08d992c6df72
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4636
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 18 Oct 2021 15:24:09 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.252 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Oct 2021 13:23:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.252-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.14.252-rc1-gf772f5cdea86
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
