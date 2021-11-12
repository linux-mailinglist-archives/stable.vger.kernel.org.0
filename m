Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE5244EAA0
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 16:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235208AbhKLPnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 10:43:41 -0500
Received: from mail-dm6nam12on2063.outbound.protection.outlook.com ([40.107.243.63]:1834
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235430AbhKLPnc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Nov 2021 10:43:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EQFO+lVwkdVev+aWCe3MfSxpKNZYNtdVK1SEqlHPiYMofGrQ0Y1LAlYhQ98llqp7P7XvK8fXxI5BQKiTk0VtwGsVaXNF+6tSpsh55UyEdxx5Dwc+K1rZp2EMM1aqnKHlv6RH0bWQby9KFmK8KCbFZyILLMArbVmuBfBbBmnrsU57xU0gHVfFolapko5rHV6pwWzFVlg5YW6XqCtKYZPlvPSZOs3MLxQSpLYWdNSDPhncEy1RhA7VGfNCKJlPm8+p9RZIjWA0k0SCwhAodUWTg4++i41CjNcOBrZpUIal0clpigGWV8tXbN2zOZeYoshlNydhyr9C5cdI0s1rb9m2Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7tuZyxOaw+vwMwj6i4WF8Vee4uubdj4sz2MO2Cq7NQ0=;
 b=F6LHCRu2DCv74QOtPIzCuvf2r01yH+ZZYYZ7glzxT1AweTCqx2BNZiVwE8knVpZWyIM61qpt/Opc4/g+eBkbydG44zMZSh5Yj/U+0chzZ458u5nVQd553elyJp3M/E+1qU+rkUCG0J92BB2AeHmjLK4SwTHzsHnd3sgBSXByK94N5JC12l1BdixQIFxAMrw63IRt99PbR/3xzLZYvPUnVb6Wh0bGEpzCx3XUC/Zf9X0nMnyxLpC9AjG3mYRF6Ckv4ywMk8MPo397fEloJ8X/pPk0nO3ZQAgLsLMm1sEHD6SRBZffTqcD9NGfpGJJJ9il+b9VT5nlIO3DLBPp2mHnXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7tuZyxOaw+vwMwj6i4WF8Vee4uubdj4sz2MO2Cq7NQ0=;
 b=moWT8gj9r3FUHKRyfaC4W4pCryFGvwsjapEnOaAuJ2CCRv0Ev8fHQYcNOwi6/fmZ3SSaLm3WJJF9Ny1bqfKur4r3rEuJv1HkXC1y6PAjc9jceanLYnnkW2hL6gsYYFaPYZGsDi6zEwZTbbOAc/E1azkae+Ed2YN5DAKBIVEXqIPL8yfvLJ8pgty8Gm8qOJyq/M5Nujs2gJPr1UpbQgp7gcMKynTQSxLQ0u9WDA17XdeHqGkyzHhgodbWlJOryUv6oluHm4awo211ooeTnjUbN2mP4DaTBPcsUk93rTbm1Mn+0BNFDKlgtBk/h+rcIGiBkXUtVg8bW5RET3qmV70P2g==
Received: from BN6PR1701CA0003.namprd17.prod.outlook.com
 (2603:10b6:405:15::13) by BL1PR12MB5303.namprd12.prod.outlook.com
 (2603:10b6:208:317::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Fri, 12 Nov
 2021 15:40:39 +0000
Received: from BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:15:cafe::ac) by BN6PR1701CA0003.outlook.office365.com
 (2603:10b6:405:15::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend
 Transport; Fri, 12 Nov 2021 15:40:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT026.mail.protection.outlook.com (10.13.177.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4669.10 via Frontend Transport; Fri, 12 Nov 2021 15:40:37 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 12 Nov
 2021 07:40:19 -0800
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Fri, 12 Nov 2021 15:40:19 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/21] 5.10.79-rc1 review
In-Reply-To: <20211110182002.964190708@linuxfoundation.org>
References: <20211110182002.964190708@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <c0f95d0b3405429bb982e183d1505457@HQMAIL111.nvidia.com>
Date:   Fri, 12 Nov 2021 15:40:19 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c182bceb-8727-4ba3-20ed-08d9a5f2c713
X-MS-TrafficTypeDiagnostic: BL1PR12MB5303:
X-Microsoft-Antispam-PRVS: <BL1PR12MB53037FF8522F7C514FB892ACD9959@BL1PR12MB5303.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iOatKl6rqE0gw4fbtt47FqHv/bNidjFbwCGZlNsIkGNGDbYJO10K3P7WUpLgIKpVLIBNMpRdf1523rUH3auqEhohVFWuDVtusZAw33QzJEsi7l/MoSkNZOmRa48Ah+aG33CSik9n9uxHr+1jSpt078M0Esiih6560oS2GtJtl8TDyTsvOeSQtlUsEyVjQJe6/I7qZI8Jax8OGwD6Nzhaf4R1lGdrWmOM2uJ1a/+mvT/lcRcV3Ss/jWliRO5Ob+sP61FmSy9y5kOIyV8EdJnZxCm3K7MPMvmE8UVLyIxTBT6ST3L3uKkSnTz9IvnfCOHHGmGI+Q6GDOG2HAS/0eIooFz4PEn+k0I8wn26g1Y6C2Gb/bz6Cn37IISbXXgJcx5dGICyLG5ifSZbooz14hVHD4gfMpNYQ1AL+opQR2HIOrQe14hTfkG0mN+ybDRDF56NDkHMn9NtShi1C9S6NADdNcc44qS8bxUHeUyRm7RSmYPV8l/UlrAiCWxn2SbWK6D9tPXkTAd2eSLl6/i7NxjrR3Y2ycN4788xuT0LAF3st5AqKm8oNHkc7ib8h9uA1N0clOC5VDW9zdQsobKETdW2bf0F487X0mHZeL+CHYsTqGGDx2/X58YS2eMWIYfKHQDLFg4NLJ7VK/kC6oNDhiV+g4cBrJjch8fdEWl8mUPt+gKZmM5P07m2IiSvQSK+HHdMMlC9K/DTn6sCLZvfR8cGSfqTDznvVYyPHBJUdvdfe41Z4iLiR0MYp4ODdWe3Re+H7dwOFMu/BsuAZfyViugo0xCNawLY33HiDuCUh168srI=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(26005)(186003)(508600001)(70206006)(5660300002)(966005)(8936002)(70586007)(8676002)(316002)(54906003)(47076005)(2906002)(6916009)(24736004)(108616005)(36860700001)(356005)(4326008)(7636003)(86362001)(82310400003)(336012)(7416002)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2021 15:40:37.9580
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c182bceb-8727-4ba3-20ed-08d9a5f2c713
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5303
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 10 Nov 2021 19:43:46 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.79 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.79-rc1.gz
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

Linux version:	5.10.79-rc1-gb85617a6291f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
