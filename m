Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634CF45E1B5
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 21:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357105AbhKYUll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 15:41:41 -0500
Received: from mail-dm3nam07on2082.outbound.protection.outlook.com ([40.107.95.82]:35169
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243540AbhKYUjl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 15:39:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kNDlHuWpM4yyhVrUAnle6/n6iK7xDr0ckWR22iMicxxBn9lq+UoTfzWGgPWyeH7CBTElY5YoTCSWEclXHslKS9gZT08VvHGdXftCjN76p2iS9T/m0i+KFFJvlVnzfY6rkMamaVkBP+CpExu06aXCpFkDh6RAtq1AVKTY9kgcwmU98QiXWb++65iKgh4+9X7v/mdbOmolo1GbhCoc87jCNF2gcs/tapiJN4ccaGCSObJg6zydRY7FSuH5kf6aWM9DrLrUXwHsGUD+9RxzmTWMCvAtTTLIlnqofkAR9FJb2YFcLvWpVLAd5Mcrtks+K5a0jQOvK+UgZYlNI0B1XGmlYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ct+XYdI3wMh1PVROzAEhZsXELDdPJu8fBy3A8UV0Zzw=;
 b=iunK30MiTieLu+nn7FEMws3cqnnEZycaj6DecblzNNFmT7VLrxwJKjL7Zv+DxXMBLDNzGtQOgEx8HtecxmPBbmR8e7JdAB3NFwfKTp3Z6azqh0+wTZHZKJnsUctp3702MU7522mipNp+oBCEF2bvbSC5Xcp/LvDy+hTKnT/j5tBFpeDN/nnodcKV4K1nctv/MdmUJpr6Xd/POeUBNsn9ebQUpQjsF8FV6Yiy2CZyiMB/Txd01rxqXTR6xD5OJZsUxoV4LmwkHla4Zrut0JCwa+EmeSsnPVxegGXv5tMUznxD7NUdSpY77AzTuOL/28bavFoiHLGtrKd0N8EXYYryow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ct+XYdI3wMh1PVROzAEhZsXELDdPJu8fBy3A8UV0Zzw=;
 b=mLj3k3kmBcrdrShLJ19GqU/RUW99HhexGBtwNWMYpfrfTbxUzTj6O5Nb+8QjfccAeJvnKq+dhABF1a6YlNGaox7Sa4KBwvXlLAwHBsO6/+FJS4uZgaqbVU3tXohKoEixk5zXgjU8nIRKw89AsLjq2guET64i9AtY4kM76QCKKCq3tSCapQlzj+kIFTZYxhFFK4RsVw5zjJYYqGnLVDIPos8Zc+2ojpmt/+i28Mw9dBSIuHKsmSp8R/aVe6SHq9UHibT/1hl2iv6HSf2MwvCAEO8yxtNBywYNDNlbJ3QCRtOOLMqc1lRK6USMJRrUUAPJUc8jcpj2PlZE63uZlYEqxQ==
Received: from BN6PR19CA0063.namprd19.prod.outlook.com (2603:10b6:404:e3::25)
 by BL1PR12MB5189.namprd12.prod.outlook.com (2603:10b6:208:308::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Thu, 25 Nov
 2021 20:36:27 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:e3:cafe::c6) by BN6PR19CA0063.outlook.office365.com
 (2603:10b6:404:e3::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend
 Transport; Thu, 25 Nov 2021 20:36:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Thu, 25 Nov 2021 20:36:27 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 25 Nov
 2021 20:36:26 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Thu, 25 Nov 2021 20:36:26 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 000/248] 4.14.256-rc3 review
In-Reply-To: <20211125160530.072182872@linuxfoundation.org>
References: <20211125160530.072182872@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <4a8b6fa5ca5c4e469f7eaafc04831f1c@HQMAIL105.nvidia.com>
Date:   Thu, 25 Nov 2021 20:36:26 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c85cb62-e746-4aea-b540-08d9b053412d
X-MS-TrafficTypeDiagnostic: BL1PR12MB5189:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5189DB57C3DE9559B44A5BB3D9629@BL1PR12MB5189.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tJ50uw6LTgXYs/q0s8ruyteRAQ4li7ERhxtFC7doOBK01XeiPdDJbNbP5qBYXq+tyZUjbxVtGCkTSr38RCczG62nviqsBxr7yIbNhBVjFLRXQMY2Uojzlt4qvqUiWFRyMnU5YqdSI9/hv9bZkb08qOyE2wV9l8Kt7lmbZsBEREjShnAmOyKca2wY+XZMkHOua1Phas6Ix0n0gmTFX/jQgGgUrh1PO4M8hKITPYaYiQgXfp//7ku97yl/FvcZ6R8yXHGHrO0CIwv9R0ZHgnqYvMi/cKyMZyUVJGOxqvPm81OIilVsNzuBu1788pMOzthIKRDuNwxT8caTMPFde4N4sgJN8FVhacqq2EKCwhlT+vISj109dMGrStcXy0DJuT3J103VtiQ1uNuecJX7d8srC+YCaoIZ6pjwgDoBGizlRcWJUW4w7u+hu5zXaM4fmESdjTmXfAkxlpRFJAlw0k1WvYS0qO8JamW6fcTWvZgrjlCQNOG6jHv6V87Fa86+fPaozVNfD7bRfPRkkuGVzaYClhUiDGT0B59h4hkektNOCkyJ+d05OuQvrrJn2RNDdBLXDUEQiNwy8FfyuGtIylycys2YecCTa5PG+hMh4uA/nW8PchKfynhqqv3DgdPq2yyiPelpSFPSI1lK304gdXM44AzTRsRvX3CVP+9OayVBS16S+TPJmlgY/IyFxvR4y+9h3MOv4rPCsJPJ9FRiVqXb4RUoYCBtA4xpD531MAfYDSUWQgyvUC/OSsyBu/tGc/Ws7TnwXqwfvWgVIJ+gRHPkdEQIYvm2bHAScl//Hbs3d9s=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(7416002)(316002)(2906002)(5660300002)(54906003)(70206006)(8676002)(508600001)(24736004)(47076005)(86362001)(4326008)(36860700001)(82310400004)(6916009)(426003)(26005)(356005)(966005)(186003)(70586007)(8936002)(336012)(108616005)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 20:36:27.0285
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c85cb62-e746-4aea-b540-08d9b053412d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5189
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 25 Nov 2021 17:07:22 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.256 release.
> There are 248 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Nov 2021 16:04:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.256-rc3.gz
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

Linux version:	4.14.256-rc3-g84f842ef3cc1
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
