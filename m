Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C10F41340C
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 15:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbhIUN3W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 09:29:22 -0400
Received: from mail-bn1nam07on2050.outbound.protection.outlook.com ([40.107.212.50]:22403
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231247AbhIUN3V (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Sep 2021 09:29:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E5eN+8Qda229LqMmfvY997pBYOm4VloAMB09+UEt8jIsfwME5TPp60yNXmAqAdqgDntoWIHVVvOmqV2c8g+nXLwHArqOS5n2Y0DpY6xqIESUOFRL39wcG2PGr69dweNDl+yKdkAADqdRsaM2D/VnFuumSF+gmSj8yDXZOTikioHwzgri1JjzN+LSlVj0kXmDlBJJUqOU/wTo12sIT4eior413Z/hqUNfdRV7u2dThPwoV3yEW4ITLWpPKWmm4w2emM442RyemCTRWBSaV3SxK6KsAdB8YwakXcSw2rEmrqUn6NbtqU6odwy/w3bkpdXFS9yu9DTFl8DZf0cqbl66kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=l5xSXea3Mqgd61jrZgfjFxu6QqYfzFjCkn0N66UL1Pk=;
 b=Q0S+nQpz/VqJx3DEQp0w9lXG0DkItCIvbjNFwJxE8YDYqVaqYEHRc8P7Ao5BfoMj8uP9UHnVZ1RfExHVwB1Yp8vOf9dHCDitb1lR4N5WSfuAGVcb+5/BZ0EEkBbYeuW4ehLD6JCUqIfkQBIlQT/FXpTGlFmgLOlqjLEurPh/t+TUgjzVi0mpOyMjnOZXwZhsuY95YbagVyWNKQzzuo5hZF/Av5clnRYhjJVkR17nDYtGwKZqziypoDIswopEEX+qQYRrz5/23GiWldXZVUEpdnUsNq55njIdNL1xp0IRN6u0mYk/kjemF/chkNEs1aVtSw4Rj5hWS7/RyZjMQjGb3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l5xSXea3Mqgd61jrZgfjFxu6QqYfzFjCkn0N66UL1Pk=;
 b=XKhHQaQuDzE6+B40tZ+SvsOsjet9M7bUdenARaOyDBjF0xYV8By5rLavOfq6ru8gOWXyw1EzN8VyYZSpp6/mykE9ktWesEd1ncWW7Dv1O1QEFDhoClg4lDGVixDIddgvefTu5Ydo6HXoE5BEJ8i6vEQQH/DLWdYYKkHsq0GG186p3aDDyrTvq17XUR72/oCqHhSNcXiy9itvbI7S0gtuk0Dj9EDaWZJIFuavfZUMQk/NYYMAYhx11ckI3eBDyJDjlnnQfz33yNO+RiqdikuOHdago8MSuq8IEbOESaRq+tIVNlA/vxp+1UVI92TpXRumW9aiV5nFcnJpf8Prbgs/pg==
Received: from DM5PR2201CA0016.namprd22.prod.outlook.com (2603:10b6:4:14::26)
 by BYAPR12MB3479.namprd12.prod.outlook.com (2603:10b6:a03:dc::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Tue, 21 Sep
 2021 13:27:51 +0000
Received: from DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:14:cafe::bf) by DM5PR2201CA0016.outlook.office365.com
 (2603:10b6:4:14::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend
 Transport; Tue, 21 Sep 2021 13:27:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT059.mail.protection.outlook.com (10.13.172.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4523.14 via Frontend Transport; Tue, 21 Sep 2021 13:27:50 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 21 Sep
 2021 13:27:50 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 21 Sep 2021 13:27:50 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 000/175] 4.9.283-rc1 review
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <0405879b32fa49178de13c3d534b535c@HQMAIL111.nvidia.com>
Date:   Tue, 21 Sep 2021 13:27:50 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd65e9c9-d901-458c-47c3-08d97d039c45
X-MS-TrafficTypeDiagnostic: BYAPR12MB3479:
X-Microsoft-Antispam-PRVS: <BYAPR12MB34790D9285E0918CE8B168D6D9A19@BYAPR12MB3479.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WsIEwm2AXD6rmV4nawSP1TPESbI51QDbwyZHBs3IVnqyR6JlqniPgQmQagragj3U8i3n0WzzeqkwZXpSLUm8jVpI1RpipAUIqvt8NU4TCCq36uhT3zhR9B25O+Aki9L4UDI8oYSgLLZ/qEjWsM2vkQhahW2Lm5WGE93bmVREIfuLs5saaVpRhSbywWoFG0GR01B1EZcBKsfZpH0+nv0F4Qzc9IFGZpaETIVwZog5p6hvbJ4Bc3srGgU6unMUbKic1UGXx6gZPcVUUIG1/cduUZya+6jH+vEGeX+9r8/abutZ1S3BXxq9KBc35B04UbwNX4s7Uec2h+C681Qwa+nDEK7NbZpbsVZPsHgj/IRpvmBoQ5XVIMl9GkeMVe6KjgdpneRb9s8Cct5ybtM11P56lGE0Ma9mtv1P4qpIGHPyyVjXCFBVm69BQbQHrxOWypPh7jvIJJ3mWY4ISIJcwba6fEdaAwf90B48JOomxSgLRm5hp6HDQJ6w58BCVOr+1/gbaFvusXDCKs4FgRiHNNf5CBD9inCIBr3IrNSvjn6I4QlvEaF5XT0WmmNwBPLcsJqgfOOMYlvRpLWJEakGp5qDhmcr1KpN77mIMRLt+RmjcRNvHC3+Z7LjS23xMXqsPPxhfSnr8gO+wA9y9gJd5HzjkpiJeQ7csvyI1QNXredwxeKMBsuaZquQ7HGRxXap9oogWT7Gfi4I9oSIII/xec2TST+i4HuPjzhzUQ3pEeTV2R1rMd4IJXvuGtegwj/IDckWnCVsxkoiP0pjng6sw/uUcorJV0EesQMeDAchC5WKm4Y=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(356005)(26005)(70586007)(4326008)(47076005)(7416002)(6916009)(336012)(70206006)(86362001)(24736004)(108616005)(316002)(8676002)(36906005)(54906003)(508600001)(2906002)(426003)(966005)(36860700001)(186003)(5660300002)(7636003)(8936002)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2021 13:27:50.8626
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd65e9c9-d901-458c-47c3-08d97d039c45
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3479
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Sep 2021 18:40:49 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.283 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.283-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.9.283-rc1-gf502d0bdfd9f
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
