Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9B7472FA1
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239678AbhLMOnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:43:25 -0500
Received: from mail-dm6nam11on2066.outbound.protection.outlook.com ([40.107.223.66]:5280
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239665AbhLMOnY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Dec 2021 09:43:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EUUVBbHxp2OwwAyypdn/SXCuRdwSVj0GzyanYYzjIeegOGRzxbkGXrtsH/7UaDeaOMC7rfjUzBRE74t4HNTLW73aB47nxmx5qVofzc56i/hLPSFE0OsW0nPq9396+olgDnwUycwNLZqCXGyrVkkBu69k47PC6yFEFmhT9rm3GA7o6pYfKD4XKqgQ8TQ8cDXvJwGnYR2nBqAAiXsldZzrXA9MP8nRc8abTFtxQ6CdF5HrkFlgsRftfGC5STIBaob0v/z1V+UPnPxG9f7vQnY0pzpT18+PH9ek1fIyeehNb28tg6X3/9UUCfv13y3rPksIJxabtZny4EaMYJJde+j7rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aLrXjZLtKIgHHHe8f++7fya1pIF986fczP+VbaR/oBk=;
 b=X62yCuRjRUL6nk+OJq+czgYR9pndXIcixneaPf7jIyKsYiTIt3Qoaf3EpNknXfTX2e7gKBDvbHT04QZyfFJE1oagvyrHHxdtFI8kd/bumaaL1cPx1o/rzoCbY6i8qWU4J2dBlHiP6Tmx6XfLFmnb9xe6U5aJ4jgIxIeWOr/AjRj79d7N+f53SeSBoZkHHp9IL06zD0tgBBzZDiQL3TyExvVYrPcnlAc5ebLtar9AnmDuq80o9L5CdiQa96v9IrxRUbYZ2AsLMKlncACtUKvVchrHDSSPKhghStxL113C9ruUgOo8Hl0aDVj7QoFWFq5ovqTCdX1FnX6OFZhr2GT4JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.12) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aLrXjZLtKIgHHHe8f++7fya1pIF986fczP+VbaR/oBk=;
 b=JvfdsquC3+lxR4rSdKUhtRQE321f3K68hS47GIpezWBEU/0oUhcAeWqF42N+QUJavk6Rv0Ag0H31ilK7BsuChs/iss4xm5IpN/iB2oZ+TF/F0VXDSL4FADTLHse9xUor8ghAZd1twzBue7li2cvUdpsLYy17gJIm+mWNDqlKyJoy5XUAKHIKDPc7wZ14a1eSu1m5lnJ3hc1jo6LQRivJski08jtzEzMYWqJ/oZybT/Gi2QmXr1mW3ni5+UULMtiXHcS5lXtY7rz/0TOYAm5tyIPDraH5CUjzzZc6kUHK//xk+mt+9p8S0RPawMbUYXSE3Z3KaQT6nPwYSHrYipPyYw==
Received: from BN8PR04CA0014.namprd04.prod.outlook.com (2603:10b6:408:70::27)
 by MN2PR12MB3663.namprd12.prod.outlook.com (2603:10b6:208:16e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.13; Mon, 13 Dec
 2021 14:43:22 +0000
Received: from BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:70:cafe::ec) by BN8PR04CA0014.outlook.office365.com
 (2603:10b6:408:70::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16 via Frontend
 Transport; Mon, 13 Dec 2021 14:43:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.12)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.12 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.12; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.12) by
 BN8NAM11FT030.mail.protection.outlook.com (10.13.177.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4778.13 via Frontend Transport; Mon, 13 Dec 2021 14:43:21 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 13 Dec
 2021 14:43:01 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 13 Dec
 2021 14:43:00 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Mon, 13 Dec 2021 14:43:00 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/53] 4.14.258-rc1 review
In-Reply-To: <20211213092928.349556070@linuxfoundation.org>
References: <20211213092928.349556070@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <8015143316514b149a761ed683b1181d@HQMAIL107.nvidia.com>
Date:   Mon, 13 Dec 2021 14:43:00 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7734ded-a037-4b8a-7260-08d9be46e96a
X-MS-TrafficTypeDiagnostic: MN2PR12MB3663:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3663560916B3B9CDE7646AFDD9749@MN2PR12MB3663.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Ell8SSbX3yVKIw4UK+RqJ02/3dh03jDuGQ7fak8LR5Vf8TOWWgDN4heocgEmJsLPK7gCzfQI05CWasVtDGSVXbNmH5Cowf2OS3jw4B8iqlIEAt8j1ALoxQKKpvarEsXK6ELnUBZoU0zs+0wH/sq+7+yG+KB0ueT32rU2ZuSZ9gM62v3WAU5XmfF0unOF30dhsJVyi3+0UbfYfSIRQpKnzEtFP5/pebFgO55sQLLTB52u6gTZbmUT3GeU3XwfipSld9lXDCZjOd08ft7ewqz9kb05JS6NB2jOM+uc9O3eArWFx6incRDHp2zoCUZcg6XbqCUefi7sKchD9y1JXJftND3fZ+yBzYzQ21JDEhJAxPIHzZKT84hCYl7NG5r7nhru6mMrXmWVVv/zy5ztAdlF2aZhNeigsVpWr/kPYiQ7XacogWaTEEIh9Hc4hgKMUwLszvRCNENhGnlf5maUpj+gVcEusN9lpdWQUYm2QhyAk4DaaLqzza5XgjiH6yEc1eAwfteHBDxPQ9RuepUf89RTE3UlVh6jA5oDff5fIoEjm/y6PCIfg5nu1u303iXzZLp6rPuhwHrlaca164Qy2Bn6/YjNYDfEa1V+TxK7tHfn84vsa7gi2oTvM8YebSljISQoIPO9kXmoCoGnqf8HTZcge2DQJI5Hv/6H6TjVk/v908KB7yU2k1dE8W62DsE8W6OQ2K2knuJpsgwNblDZaY16S5yMA+Xv7GhUICKYnTpHfFJdtcQgWILTvC3+Cmait5Vk4kY0yOz0CMwL+QTBFRXY7JNZEPHNdyir5vNlxfVmoCFT5Tx7tZnfxxGCiWtYJtrYNwz3Xcdcsj3sXXJjvnDmx78v2UKe139C7Eklbpyf0FXChw90TaABtIEkfqZQ3ke
X-Forefront-Antispam-Report: CIP:203.18.50.12;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(508600001)(336012)(70206006)(4326008)(47076005)(70586007)(26005)(8936002)(6916009)(54906003)(7416002)(34070700002)(5660300002)(966005)(36860700001)(8676002)(316002)(186003)(7636003)(108616005)(24736004)(86362001)(40460700001)(356005)(426003)(82310400004)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 14:43:21.7685
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7734ded-a037-4b8a-7260-08d9be46e96a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.12];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3663
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 13 Dec 2021 10:29:39 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.258 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.258-rc1.gz
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

Linux version:	4.14.258-rc1-g5aef54c7f9c7
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
