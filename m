Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4592845D91A
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 12:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbhKYLXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 06:23:23 -0500
Received: from mail-mw2nam08on2046.outbound.protection.outlook.com ([40.107.101.46]:39296
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1349867AbhKYLVV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 06:21:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yc7Xh8X059ewntaSNODHinSjYKnn3EG2jSghsqL/Y5QANJXkTNoTTWPYnBjBJOC8jgQ0jolOozqoTwKdsK/BRbKTfgTiwArCpvMpaehaIK+Em0QrgDzfts7THCwG53bYzTN2srz5QD0YcsdA6UP17M8bxEeSI0RyVnpE4XfVi+XiDOh31X0cCcNvwKgQYJ+Y7ys2vfqUjCONWyP9Iol49gZEc7BuRPjRIpdmz/yMdqwj5nIfrvoTP3nBIbqppL57BqE3ZblIvatqY2DZEci0MJkh564rNYnd0SYVXOeMbF0XhHNj+2Gp8gZfRmNe0sFt4dlAJ5KQJJgpiO1ZQm6wFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cd1aE8K2rwgx4i9GhYysHM6LrnBpLt7sdbJW0UUTxmg=;
 b=QW2FOUKiJyKajVkasNia8WFw60ZqIVupnrp2x/22ZFQzbyA1SG+h19SdT6BbT9h0iK4jQ4MuihQ+AyeskcInP44wJ1DzEA0LNC7Kg1yxgllJWYJWxr56vZHsMn+vguut/dJIwIR9AuUSUFVOJkThwSZYX50ThL7G2pyUbG1R6g5YTdBrPOTsU40lY1Ui2Q0McbQ4HLIn58eBonggKVFruDqBrDbwTKRKLyVQaeXqz1F2IueljR8Tr5BLSuQckQsTmB9HXS83d0QvYvcAaOlQMomLLrmV7yCvv1PZc4xCsTiI71R2ZHbdoEh0aTcx2DWqrRnIYYCcKmgXTzpDKdortg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cd1aE8K2rwgx4i9GhYysHM6LrnBpLt7sdbJW0UUTxmg=;
 b=VBWLqClXOUEb3fH6jkyTllElmE+98Ir4iB++9M0CLn9FBG12W2BvIHtBmoXQP5srhZc31mBqbN0iX7lKnFXMZMt1iKC0CWNJi9tn11F+QuCtaAzhCsu5p+d3C/JSYVd0gg2zT+LQw7t1rfmkVL3WxMOFqxlbmvxxCYRKsg5jJVIeebsHbhGxavnnQp7KlcksKybWbhH4K5yjZhXcI9d0UTJwiQh4UJy0MsNmM4h4u65lRwgQ5hWzCa4sNK5lq0yc7XLFkdDAfiwSgIkVtvGDT8OWwvB72kDnsrYhxbftTERExVNSBZ84vDGwFJcW//wHrlhfnRUTkARzwPkLygEBIQ==
Received: from BN6PR13CA0036.namprd13.prod.outlook.com (2603:10b6:404:13e::22)
 by CO6PR12MB5458.namprd12.prod.outlook.com (2603:10b6:5:35b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15; Thu, 25 Nov
 2021 11:18:09 +0000
Received: from BN8NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:13e:cafe::f9) by BN6PR13CA0036.outlook.office365.com
 (2603:10b6:404:13e::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.17 via Frontend
 Transport; Thu, 25 Nov 2021 11:18:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT033.mail.protection.outlook.com (10.13.177.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Thu, 25 Nov 2021 11:18:08 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 25 Nov
 2021 11:18:05 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Thu, 25 Nov 2021 03:18:05 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/100] 5.4.162-rc2 review
In-Reply-To: <20211125092028.153766171@linuxfoundation.org>
References: <20211125092028.153766171@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <6b681f32c7664d5b830f9fb5f229b1d9@HQMAIL109.nvidia.com>
Date:   Thu, 25 Nov 2021 03:18:05 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47eccc7c-4293-48ca-4190-08d9b0054285
X-MS-TrafficTypeDiagnostic: CO6PR12MB5458:
X-Microsoft-Antispam-PRVS: <CO6PR12MB5458A0AA0EEB72CDCE8E6F9CD9629@CO6PR12MB5458.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o6y0F/zE12+Wtf08tShZ7jOg/xEC6PtFFUx60212a8VWnd0LeI81W735sIrBh82cVMhZCOgmiUrUsPXujBARXxmcpUMsyF62STQKr4tcljQ0ej1bvA61j6oHngLz5T9VuVutCJkbeHNubqb0BYiTT1qOjA9AnAwXbyH2/ZwejnowuIsVmCdomdrYxoSC9n+MQuDmDtYonQg6BJbuhsU8iJL4+07B9EfXhVMWIleKBpjZQpEycVysYajexHbvypKe8KMVZNcwexQBoyGs4QPPEptmM3+87Ef2zqyp577QZ9WjGOpy6Dkc9aW4PoG23NEn90GC9AiJC9JcpGd9lnim4KABJRtkd61+tMWG9sHwsCDss/b8/j/GN6c2ZB3KZz1c25DrSSufwiUS/Tg0KtOnln8uHdJ81oiUU0fcWToVAW7o59uVF6GCSIiZogpIuXcpLehfdwxrb/PO8SSI2vbAQo5Kq9ty/Ui7qzG/cprX8RTa7wnoFRcvDc6YFhfYZuxgh/JUpW6CQ9zBgOHqyGs4g0gVe5W3OWQZNqqLMxZocXW+d7Tip3QhPLTHBxFlmlyArlsCBkaW9kOHwZ2uB+AvGChKpLXF1QT1xGmUYwFSA2cgjt4oCdd2SgCFsWiXmqQfYssH0Yz3p9+kGVNYu+Udtwmbbs4q/YMTqi15BFu2AFBYoAEAgD4JwYGSm47KCm5haRPHY2ampLQZJl3K/FyM9C5mXokyTl6SIqyv2BmyM4kFLbfjaN2mpX/HPbbRq+hbjT5gs/ePQMw7sr2XNPvPOMtZo4RBy3em+dYniOXuf8M=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(47076005)(7636003)(186003)(26005)(356005)(316002)(426003)(82310400004)(6916009)(2906002)(70206006)(4326008)(24736004)(508600001)(5660300002)(54906003)(966005)(36860700001)(108616005)(7416002)(86362001)(8676002)(8936002)(336012)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 11:18:08.5231
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 47eccc7c-4293-48ca-4190-08d9b0054285
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5458
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 25 Nov 2021 10:23:51 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.162 release.
> There are 100 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Nov 2021 09:20:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.162-rc2.gz
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

Linux version:	5.4.162-rc2-ge0db70362c5c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
