Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21D76441C07
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 14:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbhKAOCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 10:02:19 -0400
Received: from mail-dm6nam12on2080.outbound.protection.outlook.com ([40.107.243.80]:19808
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231366AbhKAOCT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 10:02:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a9DgHCZFR6tSsgy2+cwuXPJyeroM/uWRPkuqitMLdovRgSPR8LsOzen9AuglZilkVbgonjirhK6ILyf7RdM0Ve2IcNhxCd/GBaCS9Lxq9SFVgFVfW3kmDWlrMld8y50fyulydgqUqq/YG509pH7PYACbXtvl0jC8uOfFCr5y4FCSNk4QiAsCXJXUCCTELaeRnykM8IYKHuTG/bSUkw2jTPpFiUzJs9lBrqZPv2GiHaj4STC63kW96fUHsEPXJ55R/umDfJ7nC8aWNwc/6zeAhfLYYKSU9pVIclJ06lja7dJMn+CqnYRKW2muWCbFRUTsfyjEaHOae1vb6OUQO8tIfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mQTQ8+ABun5mdBdS6ni43Sv3T6GhlV6JXn1Cl9ISN14=;
 b=A3tb2LaVU6nhtCZ8yoiH1YW8rni+pFKos1c8JlTrLLoF7vNjDUko6B+ktpSRmDXnWnD+D9/q9ghBUCU1JB1gjNhTtJjpvfq5Ry9CUpVZ6GXzzvBnyTHdh2HwoC9yG2lmkCzZ782XE0Tx3Qkqunr+E442wAFC6e6e7FATOJyPaENmdeEVrnSaOay95sKZ+VsIzv28aFk7nZ/zX2MDW79UHbtkk1EFAtoMg46p+EujEwmOa0SG/oUT1OsON2m2rYvdG26g328UT1x7yxVtaXLxHS8FPXiK3myoI0L29koG0EAYE1Ro/k/7rQJo/oXEOuqTguHtnkagwj8lq46HMXRbCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=quarantine pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mQTQ8+ABun5mdBdS6ni43Sv3T6GhlV6JXn1Cl9ISN14=;
 b=sFWT+eqE8Td/Bm2epS8p+Vz6e/GWar61nR14og+mV6eInopQFd/xUTi4Sx4maM4m0tqDIkeSUJ74OsAePbEY54vrNd20ZdJBfR6ukDG/IZjqdH1GpADLe6ScJgdae1UmDu4KOw0C7+H3EA9Qvj8TiF/1XpTxz4LEA/SKsnD7/PHE6wFJhbUmDd9j49CXCYgcf+ew5LlsMLSa7UKGuXHrFF/EMZjIr0SEEQMabuO+MLZRHhbtc956uHhHwv8TQnbSzAl4N46ggWTcx3O54nxmuTDzpSc7J+hwYjt7zYtjwG7/Db7WYiqBYqWwYRBXLC418GJY5J8OKr/nzGDPN6ofbw==
Received: from BN6PR1701CA0016.namprd17.prod.outlook.com
 (2603:10b6:405:15::26) by MWHPR12MB1424.namprd12.prod.outlook.com
 (2603:10b6:300:13::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Mon, 1 Nov
 2021 13:59:43 +0000
Received: from BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:15:cafe::a9) by BN6PR1701CA0016.outlook.office365.com
 (2603:10b6:405:15::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend
 Transport; Mon, 1 Nov 2021 13:59:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT028.mail.protection.outlook.com (10.13.176.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Mon, 1 Nov 2021 13:59:43 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 1 Nov
 2021 06:59:42 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 1 Nov
 2021 13:59:41 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Mon, 1 Nov 2021 06:59:41 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/17] 4.4.291-rc1 review
In-Reply-To: <20211101082440.664392327@linuxfoundation.org>
References: <20211101082440.664392327@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <924ff02c853248f58fd2a1d958b410bc@HQMAIL109.nvidia.com>
Date:   Mon, 1 Nov 2021 06:59:41 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5489f4d-7261-4461-5fd0-08d99d3fdb0e
X-MS-TrafficTypeDiagnostic: MWHPR12MB1424:
X-Microsoft-Antispam-PRVS: <MWHPR12MB14247F739B240C468235F434D98A9@MWHPR12MB1424.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lEnRg9Xr9la1y9QBt7Yx3MpvYmg+dcjJJCDY1AUFvmEj+5jz17Ao1W5pfUQyr6ZbU26sWR8KupHLFuj1y7pHM9TfsA9rR2VVwTfAz2J2Kno3uIyTFCQiVw6XNl5YNZPqVWvQJdN5gt7AiD3KzUhztTaIg1VrrAyzxOIcMjjPxAc+nMdrMQX0YImke87S8NaPv8fnKiK8xO+mVIXvmc01W+1a9p2+UhUuiLSuufa+Q6lA6xVKcQ/xbLiwcGYui4ru7JqpItVf0b/SUH6cd34euIbkK6VKGbe1ujFRXFe4YEdC2MhJKxh9iMpmNYK6Ec2SaA4dAhOqY9dSy8BwrofWI69B0S0fgA7fGwK9XGnnMoghujqWB1iDSbVcMCcqp8thoWCZIJGeSh1P0DsOnqIrhSqKR0B/vvNLliPnZWasqmHXcrAugRlgyFHwmfOoIVukqNS71DzCN+O3u+iLCRXQ7AH8xus91vN+kqzitWkuiXZOlsSXC2vQivpQx9wKzYrd0QTtBiIA2vNEM7mUppQ3lP1wZiP0OsRNfYUbmo6trPXk5ZroHacAx09Af5+fhmojI+708IyXuLSeV3aTHaFrSH8zTbPrBs69Bd2tJhvpxB3879TUr93XUgisa7ahrm+hLqM5L+DuPkBOhRyoEtuAzoSo8ZxMBB94dst44rGkZ8pftaA6G3Z9Tb2nhINHXi6Qpp7Aq6SlvoIbuA1dvnZbaYtquFr/Rt/b+K0TpywKXGVs7zybgDdrWSZOJNusltnjg+ChWWlBDZOpY7tLEyk/VnWLV8O3cRAzugU4lynjZE4=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(7416002)(186003)(336012)(8936002)(8676002)(426003)(70586007)(26005)(70206006)(47076005)(508600001)(54906003)(316002)(966005)(5660300002)(86362001)(356005)(82310400003)(7636003)(2906002)(36860700001)(6916009)(4326008)(24736004)(108616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2021 13:59:43.1519
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a5489f4d-7261-4461-5fd0-08d99d3fdb0e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1424
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 01 Nov 2021 10:17:03 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.291 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Nov 2021 08:24:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.291-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.4.291-rc1-gd0c0f8a764f8
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
