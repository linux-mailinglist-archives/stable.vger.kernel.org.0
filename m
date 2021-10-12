Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89BB042A4C2
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 14:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbhJLMoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 08:44:13 -0400
Received: from mail-mw2nam10on2082.outbound.protection.outlook.com ([40.107.94.82]:51745
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236402AbhJLMoK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 08:44:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nubj2t1f9MxI/JlzDUFSiwTUZya6NJ/VkxkelsU4uSvcY+x1LVbKN7Unzowj1kp2eCPMmp30JoL+vl+qsuOzLvf7k/vkajZctQApX0mzSlnfa1TOk2+07oOME+HVxMlmmO16XaMQ3H9CFTBwy6EMzWkF/VchrNS8nXpMXt6yXT9GtptMktD4xzURoa2utbmVMOiI6dtfvKBBR+X4crZJoU8L2GiLGoAeYDdmpfBpCByllV9U3YPus2jO2LcPPRULvd9zuD0GDWcAyjjjFsiXT9tzj9LahzXIFxVQo5KWLlOVDahftXIJSPQCNLtV7APWB4RiTypZ7zYXP19MxRaysw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EOhJ5BJO02Q3MD65VTzFO5uGgO+vYM+dqUbnB35HED0=;
 b=bVvdSvs8dsrbRDwi81IWHa1SCIVk1F9J5GqyW+hfoB5dKGO8skEhuBdfnW9W2ix46xiJPa2UsLSElHp+vdpMHQaGBrcwsAOexJS2YtX0ciWP38HoDj9b0oGLTp8ZtDM91fQgWRWoeIgPtUMhMohhT4vBA2FCcdi3wK8/JpH6XDt3UpiiI/2hfyyoZY/c9bmhGAPBxqNTo+UBFCUkZV0gLNQQ02j6svXO4EsgGfKjKcBvqPMGHd3ajzRUjB3MhfGBy7vyVfEkiAtPp2oqkt+pUzlZrcA71niZ8irhfHw8hUFgMfC88B79IP1s2f3B+nRHr8+/toFK7SMfY4HPk2gJug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EOhJ5BJO02Q3MD65VTzFO5uGgO+vYM+dqUbnB35HED0=;
 b=QwNygxxRnn34fO4SSxPC9HaHGkPplfcG9fQ1IwfapK44LW8j7NR6xnsmiG0CmnzS/EsrGplbR784Do/yS0xGALDJikPBfzDJ9YU8oYqoXmgmW8sj67vWxcQsQI7NUPqXb4rGYqF7ERxV34LxgfLLLN8f8Du2DhvuXWA2g21q79GwyWHJvcjmzO9MOxY2X0mPuQ11ypmn2aG3z54uA5Wwt8KC/7hf/FhYaBrmrBkG4foDtqQhA59soFgx0BxnMW8ZlVdwbG+nZJxvEkx1MM1D/ddCCiato+akiXqeTZaFl9EMVDWxRMccigcegOV6IpviOv+STiYBX101pz7d7diIBQ==
Received: from BN9PR03CA0400.namprd03.prod.outlook.com (2603:10b6:408:111::15)
 by DM6PR12MB4418.namprd12.prod.outlook.com (2603:10b6:5:28e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25; Tue, 12 Oct
 2021 12:42:06 +0000
Received: from BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:111:cafe::94) by BN9PR03CA0400.outlook.office365.com
 (2603:10b6:408:111::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25 via Frontend
 Transport; Tue, 12 Oct 2021 12:42:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT026.mail.protection.outlook.com (10.13.177.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4587.18 via Frontend Transport; Tue, 12 Oct 2021 12:42:05 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 12 Oct
 2021 12:42:04 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 12 Oct 2021 05:42:04 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/27] 4.19.211-rc3 review
In-Reply-To: <20211012093340.313468813@linuxfoundation.org>
References: <20211012093340.313468813@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <b40a421d7680417687800aeab68604b1@HQMAIL109.nvidia.com>
Date:   Tue, 12 Oct 2021 05:42:04 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be1c1723-47a3-4ce5-069c-08d98d7db301
X-MS-TrafficTypeDiagnostic: DM6PR12MB4418:
X-Microsoft-Antispam-PRVS: <DM6PR12MB44185BE12C130348282BC084D9B69@DM6PR12MB4418.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hHq8rXSHCAn5r0mBd/K8hQsafJcDlYw9HwI6g4ZlbPTGGP+rIiHQMrs006/fQxZEtfKBY0IkrcZ3A0KQXFHQZNcKuxjFHc1PuuHtpUVnKtnhw1zvWJVOyftoYn5J+7fiKv72s125FIq7ia5D44HnMw7I8vN+/9Q4BLnyU3Swi7HlHC5g4AMJodJ2sySfJxbNJSzX9AUnIalTm2IbKPp0Ft4dd/vecUG700hMQuuKjlLmWFclAyYW7ZRcFuqk8SKnddF8NI8u6BFOZLxCsNFo2pBhtjZjj6E43v2PbGrWQ7O+z+lRL/+Xvqh8kSR6tAgsDfkrc1MtFCASbNnyRW6K0anF5r0VEyVCW5MXt/NgEZyoA+Zi4nGdtPAAONhMa7dG8/LvjPi6xYgwq6DpNEUxEmAL0UjsDCYfyPOtrpZ2sGF692wbBT6PoE2pwptnLdrhrF+KmUgLSY5GSISZ/YyiiOcOZRKCQx8wlY3dXdiM8OPaYzeJlgJwAkCWwrjBxAvt8gafg8WRftIKFJjY9TQ73cNg2LabUbmTZSOjMq4Z8l9+TNHP/81v3XcMNcj1GyZ6/T/rm8qCaJXjCeQ6RLSUmo0DvpyfijfpCTGO4HnoRmGoWCn1zrRFFMxEmgpmPsmVAAmfgunxtOs1mReGuTcFn9NjZcv5aOI3exR+zjVoq5Okjd07fLR6oqaiYJTf4+4uOfR82TCHINkcFSyUwqbfl7a3niZCmRV0CEQ3/3c7BslKYGBzgkuVKiKyhZ8/DiV57wVo9IC6b7hQ1u6mmX0NTglgASPJSo6u5RBBevgPQy0=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(47076005)(26005)(5660300002)(336012)(24736004)(508600001)(70586007)(8936002)(186003)(8676002)(108616005)(54906003)(7416002)(82310400003)(426003)(356005)(36860700001)(316002)(2906002)(4326008)(86362001)(6916009)(70206006)(7636003)(966005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 12:42:05.9775
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be1c1723-47a3-4ce5-069c-08d98d7db301
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4418
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 12 Oct 2021 11:36:57 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.211 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Oct 2021 09:33:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.211-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    10 builds:	10 pass, 0 fail
    22 boots:	22 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	4.19.211-rc3-g9d7f82841498
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
