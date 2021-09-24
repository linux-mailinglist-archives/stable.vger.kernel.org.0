Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAF6417A45
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 19:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345373AbhIXR6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 13:58:53 -0400
Received: from mail-dm6nam11on2046.outbound.protection.outlook.com ([40.107.223.46]:49665
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345188AbhIXR6w (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 13:58:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OoCExEefGKeSYNgt/3PzeNgyBoRYNXlObO8WQAfUG+XoF/kPTnSAQhS+7vcfXmUgC3E/IWhcAjhHBEAVfF8bEeJktS7sOQfqX6M2KxpW9yCmZv72HticUELKns0akgnea5Gdt9B3JNombXfdWkuCywzlYR8wOzLI4Fexf4drJEksXj0vxh+laOEdo8UyJxh9wK7c5Goep13sMPA0lH2KFDL8eH/0Wcy0rEn/3s0Wz7As1MEPlg3AeLUDycYLoICAQD6gIFgYnBsik/P/ZLAuI07B5wZIqH0irfmKd7zfZQ5igkNrHXi028jAtsLGKjistEQv3/CwQD9uzmyHeNIQRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=TozeoWiaPaS9qLZEdRSHegcMPLp367W8IvM4FKWTKo0=;
 b=LxIalxDDk4FmRg+n62oltO/Xu0DuA3VXwdfdn2CH/AhdVQCRQ+wyFprjc3dC7vTajFD7iunP2O2C13CCQ81gVoXsq7AmGFboZdqcihQMk5Peqygtc3igxMYSZuTuF0XCUsyevLXN7sfZnMxgsegnT6QP6ljWzYQuCWZdvzV7ffS26H+DzfBpkrcOIJdN7IBmTNB0Z1rOnRVjNqPicVqwtHGdwOetkTNrtm2ZNKP6aFzFduAxDLM7nhVT8Uchf0hhd4GcijTm2sXkRW3BHljmP7vZFiTufatAu9CZnQU9PqyV9A0CQxotvVOm3cKntU8ZJDcQA8NqdlWbbwZqSeYTKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TozeoWiaPaS9qLZEdRSHegcMPLp367W8IvM4FKWTKo0=;
 b=kySCv/6Pgi1rIm4oEeCPlSffnAwFRyTfqVt1yBTnMKG9yeX08t1x/uEKGqN+okqkSGuPMw4YeAgjHtkfjsainGDs20wJLYhjWAx/D5spOhwPgs8DxdDDprVHhr49huoglQ3eNxY6kqJ5q4h1yK/jB7FneOBYiHcNpv7sUh5wzZxc9/8zwLxR/kGPBaebcSu74gSs0qj/TuDisdWXcadpwO7rH88TRVWQ4C8FzQx3rHx1vHcJesxcWnMZl/KdRJ9XjILpO3efBMg8XCdEOAwdee+Kyisrq66yGsZDiP0xCkjo70BSd9eu3XcXt/vJrguhMwwpWUe/1GliAQV456dF3g==
Received: from MW4PR03CA0094.namprd03.prod.outlook.com (2603:10b6:303:b7::9)
 by BY5PR12MB4132.namprd12.prod.outlook.com (2603:10b6:a03:209::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Fri, 24 Sep
 2021 17:57:16 +0000
Received: from CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b7:cafe::28) by MW4PR03CA0094.outlook.office365.com
 (2603:10b6:303:b7::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15 via Frontend
 Transport; Fri, 24 Sep 2021 17:57:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT020.mail.protection.outlook.com (10.13.174.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Fri, 24 Sep 2021 17:57:16 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 24 Sep
 2021 17:57:15 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Fri, 24 Sep 2021 10:57:15 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/63] 5.10.69-rc1 review
In-Reply-To: <20210924124334.228235870@linuxfoundation.org>
References: <20210924124334.228235870@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <275048ec5a2b4bb3a1ef66a0cfc21266@HQMAIL109.nvidia.com>
Date:   Fri, 24 Sep 2021 10:57:15 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d68dfd0-980a-41e3-ea06-08d97f84beb3
X-MS-TrafficTypeDiagnostic: BY5PR12MB4132:
X-Microsoft-Antispam-PRVS: <BY5PR12MB4132FBE43D3405CE79D3F45FD9A49@BY5PR12MB4132.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l8kvOwlzwSk8u0xk+j4PlEXF2PypYpK/4l80Wg6jQVDHP0pGHYpyvKO6eAA6JnBFmUVjcfV1a/hbT9e8xWz6v8W8bkEO3cVtK4ilfGSLbPCj7DD4a/Q3FeKtkVOOeVvMgWSle9ZVzr02qfb19IXFySMyzWV8NzS5priWlYWmRuDdgYE6tFBb/HrKhBr5+xu1j+9MM793p65pWQ3e3JQTwtm4u5tfC9KGckDd4bLwRFr+/l6cMbO1nTh/U9drd1mUAY1MzmnQANk0FvwstNPtZYTnBYsxoVFOWXRLp1itKFMjXwlVTzL+nhz3eGxc4fJYiICasGBrjyTNIpPUSuCn6nWFSJg0j0RYOhyS7Ym6pk3Xn1Ndd8s+5daTYbss+/7qJE65SEbq5TGxD8Eypy1xO055TEGMrTFiHY+6zTHAJsp0Cd3R2n7KqgOkIOCABHWd2qNXkYTfRQMHEJ5r5/mGygfY29WQKmY4v/V5VXdPbxoDZ1jshxkw3H39fJD1sakpSllMuUJmXX8g+NGBaRb2mFRWWKEDbr1/ZXgZ2bKna0cEeKvDWlPQrXNY/802NwAWBXq3RdaBlnYLw4ip8AvvAWU4r/R3CKXxncnAe/y5h2TWWNmghLnBBjXa4tVvS2lMMq+oNEYDjvXlG76/ah2siqJ0Nc/1aNh2VqmwFr0/qFfPg3DDO7HNWb8xN7dpPuJaVZ5r+4zc2wfSgMszMfEbD0ElBtvZlx4hromE+vy6OyMGu4NoLH8Mz39YDh35SGcyJAsucPclMdbaX1zofDRCRZd3LjNPtPDNVY4nk2L3vCQ=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(508600001)(26005)(8676002)(336012)(70586007)(86362001)(47076005)(36860700001)(186003)(966005)(8936002)(426003)(70206006)(316002)(4326008)(36906005)(5660300002)(2906002)(24736004)(108616005)(54906003)(82310400003)(7416002)(7636003)(356005)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2021 17:57:16.0478
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d68dfd0-980a-41e3-ea06-08d97f84beb3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4132
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 24 Sep 2021 14:44:00 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.69 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Sep 2021 12:43:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.69-rc1.gz
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

Linux version:	5.10.69-rc1-g60451d2e78d5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
