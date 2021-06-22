Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E41FC3AFEAC
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 10:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhFVIGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 04:06:17 -0400
Received: from mail-bn8nam11on2040.outbound.protection.outlook.com ([40.107.236.40]:59416
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229677AbhFVIGR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Jun 2021 04:06:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=chcEshUsEYGGlvhHy3ZOaDlRtuXPocXEsZ0eMklpTK0t8ju2mHxewI/GbJ290JrGiEu5Tt6jSwzwc4UAG7j/20Kf0zPAw1qFniHrmPeMLeeoaDvbCrRI3+wwuLJheB2eKJQ9iqklYjAXh7m0+r8qQj0Xx694zIH74Xm59BtPzL+xDeWkk20X9LACiDWtKMvBaW3ICStfRayWxzJerc0A3f7J6s8JhhL0rNCdppYN7go7netz021aVdWtDzMsbLp2qCnwm2jXqcPU5UJHMJ0qE5+wyqivgAHbE16vKA7gBebvNDelMiCz0y1HJ8sCvVmH+lf8YKxin2MTub4AV2h3ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UFf2/Jlfeaq7sADjAT9eZCNtZrw9/oJaow6ucL/erAY=;
 b=O/Pv95ofO4iuU7djOcp55+TEAEl9zBTh2fs5dkKz3B5v4iT58ALwHE2sFr5L6XIzOrqFUCgYsRaKco7oorpj6zzQ5PvvCyI1mjOAC5VtgoAYZDw8pyrVgVmbZBYj+AQVMdctwzHMofAxsUDJiFvnMW71UtF4CYpls9moH/1I/ruyg2xzEJ+IelYefElOw4ynD5HkZdz1iuRi7Xje+uxherSXeOXE/EPqGgHXEFoWSVKHFzf3bz14e8xHKJAddD01gHHQXE7+edztDKtNYlv3S4j7vpEEeEgICN/VYp+FpjimfX2FiB2Y17a8XEYXcKGBClJRGy1PohtavKRvaMTD9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UFf2/Jlfeaq7sADjAT9eZCNtZrw9/oJaow6ucL/erAY=;
 b=nazifxXix6YKugs6OwxyL6yIrMo/Wo5sgis4WooDCf3eel1FiBelR6zUWAO7Y3Lc1p3GoxCeh5h0Db8cwsQfqhHgeaueTXr3XmrZ90wdK/STEHm2WMVilZXqLdo46mIlRqkHZmd/bIxpNlp/kBKH70ouF83p/Me5jUyxOV7kS02GDqap5Q8amf75TXyALwQQBLYpLS0/DXp6w5zCjhsz171uvpLpeUiJJnQ2Xpjd6acrH5ToxxJw9VH65drpZa+2p8aEVrLTGxXZOteUTMyqDWhojKx0sCA3MQRNzM9wRM/BqP5Agk9iKw8aV6+dRgJ4FUt4hs2O+GGbCD+rSmF1Ag==
Received: from DS7PR03CA0049.namprd03.prod.outlook.com (2603:10b6:5:3b5::24)
 by SN6PR12MB2845.namprd12.prod.outlook.com (2603:10b6:805:75::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Tue, 22 Jun
 2021 08:04:00 +0000
Received: from DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b5:cafe::6f) by DS7PR03CA0049.outlook.office365.com
 (2603:10b6:5:3b5::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend
 Transport; Tue, 22 Jun 2021 08:04:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT017.mail.protection.outlook.com (10.13.172.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4242.16 via Frontend Transport; Tue, 22 Jun 2021 08:03:59 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 22 Jun
 2021 08:03:59 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 22 Jun
 2021 08:03:59 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 22 Jun 2021 01:03:59 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.12 000/178] 5.12.13-rc1 review
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <deb9562249ac4a7ea69bd0526191a4a8@HQMAIL109.nvidia.com>
Date:   Tue, 22 Jun 2021 01:03:59 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b563144-78cf-4a11-bec8-08d935544b06
X-MS-TrafficTypeDiagnostic: SN6PR12MB2845:
X-Microsoft-Antispam-PRVS: <SN6PR12MB28451827173FE999C59278E7D9099@SN6PR12MB2845.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p3bh1zFnbmsg6Qx0pS5w798PHlVE5lg81K1vYQAWe/usFp7n1gialK7aaz3y2kiCOrn+nVCLLrj7OAvC/izkJ2GQ5s73tyjOhOvFjhyPUty8De4uNmALpPlzKbEK7xOfAdofxS+teDhpsqJsY8Bdmcq0GAmq+LNe3H5x7WaGHtkEqXOp5M7jiXOjHrIrAeOkZc4mnfzuVBqEpqZwGAhf9RUK2VtcqD94TGPdOhaZHsKFZZhtYY1jT3aC0Yva2pu+sNnuSqPOtE1OoxEI+6LxsYC5m+DOVpPclNqgHXa11Ztnt1XG54UyhyQ/Fg/hLrg5M/s1NxA7aPBTzUL0OWPkLBSi61A19RYSf7z2j5ScRrCPsQS7ZGX1bLVCb7FsyX4sQbc2uzoD248I4vx3lEvmsdr5YvhFVfRTw/Vn2UcNhikZ0UwK1ir3rcjs+6rYK7Ny2blzsYANgPGqRkYv0vsTmeAwnTSO93xEAcDWpLkgX5NJ+k/bgsZBcKtYaXuxp0+weKuGK3brBCS9DV1s7XHFTrPEpz46uH2h7n6b6bZzrRiZbkgf5QW82+LLT5PRKA1El7PtBkWeRt6dKGu0vSegn96x4drhdjRjSOKoEOIFYIm1gk989kG0HYLhxVvjzTF7vKM2cDdRYZkZLnC2Zue7dEK36wmAGE+E/FGfw2yJABIX4cNqwAffxyqT3hZekn3DmeHh8MxunIeMowE7oUjYwSxdqi/rHt4lEVBgUJw3+s27XYrcOmkqt8VK3Xhwyy0o4YHJJnL+pDxO1Ps/Wzoh3w==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(346002)(36840700001)(46966006)(2906002)(108616005)(36860700001)(356005)(4326008)(24736004)(82740400003)(6916009)(7416002)(82310400003)(86362001)(7636003)(336012)(36906005)(478600001)(186003)(8676002)(316002)(8936002)(5660300002)(966005)(26005)(426003)(47076005)(54906003)(70206006)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2021 08:03:59.9965
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b563144-78cf-4a11-bec8-08d935544b06
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2845
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Jun 2021 18:13:34 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.13 release.
> There are 178 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Jun 2021 15:48:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.12:
    12 builds:	12 pass, 0 fail
    28 boots:	28 pass, 0 fail
    104 tests:	104 pass, 0 fail

Linux version:	5.12.13-rc1-g88a915cf22fc
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
