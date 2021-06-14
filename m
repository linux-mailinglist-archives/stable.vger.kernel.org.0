Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4687D3A6DB9
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 19:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234068AbhFNR4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 13:56:49 -0400
Received: from mail-dm6nam12on2073.outbound.protection.outlook.com ([40.107.243.73]:16353
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233199AbhFNR4t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 13:56:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WwpSIZhe+pqvY0q09r+khSr7drtmcz301vh7dkhJPbP3Fo0RKa6k9sm1BilI/90PG/uMg1BTz486vBVoRTzy7uYyXA4PWlQmjDKWZShMMLj0JgMhHdEGso06RycIvd7Ec1i0emv2KfQrDzN0wWMw/g6yWITJJJaK1sMn9elbKCUiT2ohkz7Q0uNyrCUr9HkXrDowTyXQSySX8H16SS7y3YZ/YYaCIaDEEJPZJ9Pxjgfd6SoBP0WqgfUJBY0Y97Hw6DSPWSlS94KnWDDPseNivG+YUZfj3rcI7yStDZiKI41TtkUvtf7UzHnyz+xGCxIzUKnnb96YlmBW2Vli06mWdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y7H32s6MOcjqvsXuAl3Src2d6mjubpaIprokXrEeR8U=;
 b=D8dn9f3O+NGYkIv0bk4waHR1s+74KknUhQclutccV/FBLhnEQThGitXIyzPeqyEqHtJDAhsU4Kfvarf3hkKLDsNJxRIBEAlF6vsnD23mdLCGSRtkRQOCFnHV61Ge8Q0vK7X+/W3ugFPsJBLqPlPV6dcsNaNyB67mrmZ3BWrRcNkb8oRhQ3SBiTklDcsOquA5mhH16CXll3C7A4v4GzCvGadZkbI6cgUX6dO9D/1Y9YDf+B0EySn9G86DGMrGRxW5uTtdLiDi2NYD8piuqTI+i5NoMWN7h/sFOvr4oZYbjIbp7HD1yIisSfRx0JJytBCJ0O2TQre5oKfWApMBpdeOFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y7H32s6MOcjqvsXuAl3Src2d6mjubpaIprokXrEeR8U=;
 b=OfZzEZbjlD0KFiYg5b0TjJ5m54t97XKwMFbK/GcDDTDsX8r6RNDy32Bg/C3DnhVCBf5sHdJrbXaK+qZAhLgfDtROlXHqW2Vg7KKwFzFpWvDCR5lxaC/BeIbBxt0Wy0jSh88Ng5pfsR6jY/Cum6N/cPtF9lKS7+SsJcaCjSi+Irle9rOInwmYZDTjnHDl5SvalhvuWT6J3eZPz0AmTGTek6WcrC1NVzBixG8QGZ7So26/ZbDodLF0V0QN44jKkEnsQssmEZ5Iv/3NkeSEM43yRNjz0Yodq2YbDkoItw3lsaaI1FxjClmodb7Ofq5xLTpW5BaAQ8W98c0VoWz1Y7qxRg==
Received: from DM6PR21CA0002.namprd21.prod.outlook.com (2603:10b6:5:174::12)
 by DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Mon, 14 Jun
 2021 17:54:42 +0000
Received: from DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:174:cafe::8c) by DM6PR21CA0002.outlook.office365.com
 (2603:10b6:5:174::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.0 via Frontend
 Transport; Mon, 14 Jun 2021 17:54:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; linux-foundation.org; dkim=none (message not
 signed) header.d=none;linux-foundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT014.mail.protection.outlook.com (10.13.173.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Mon, 14 Jun 2021 17:54:42 +0000
Received: from [10.26.49.10] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 14 Jun
 2021 17:54:39 +0000
Subject: Re: [PATCH 4.9 00/42] 4.9.273-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <f.fainelli@gmail.com>, <stable@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>
References: <20210614102642.700712386@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <f4eb8896-699b-1363-2d73-dde162375c6c@nvidia.com>
Date:   Mon, 14 Jun 2021 18:54:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210614102642.700712386@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b552d6ae-cd60-4250-6d42-08d92f5d7cf2
X-MS-TrafficTypeDiagnostic: DM6PR12MB5565:
X-Microsoft-Antispam-PRVS: <DM6PR12MB55659BC75E172ECDC3BA937AD9319@DM6PR12MB5565.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jYEdDI120VKFBwqCwur4bEyWiSEH89wdZhpj5p8xEWs443R6xYZxiR5k0Wh/yE39w3/yykDO3LXI/mrrxuB3AgSDBpncZrZWQOAGwV6xI7AnpDfi8wuzpppLzmy3M0teaPgwlW/2mT10fEboqC5x/vcsGtTMYno2VdDIYkBcDvYJIr+tPs6nrLs+G8GDzzABQsWFrCt598lfQ2QB0LnsjEDEhhQNA9OiDV6ZrNjLl2MhFPt71uWL7sKxPws3eZ522paiYCgTKDdd5WY7HIL0lQQE3b+1SuYqa4VXWJ7Rx+JtixcXwn3lYIh2D1Lcw77/p0GF7pAJjl+oNq6AH5eQ4FVHY1tf4ekMnknf8/ZvnmVp6DwmNzj+pPCH2FXuGlZXC9O7yFb8EbFfqFUd/q831hWfCcGhR5jc+Az2xS2yx7Ohd0lS/mQln21GFZuvGY6SsiBV1VOI43CL4cuNqTV5HSO3pu+RQEm01URo4JmbvSIrTH5flAo6txwIxMAvlFzTsrc2OnFKGsZi5joXNi9TbXLzxgAO6296FrJMPXPy/MQCi24+D5aFigvjcNAHp1fs8TRgwWJUxbGC/omE08OLVGUvKzDhOQUZKhJGTTU9/yPwgLPsp9pNDTbzluMC+tVBCyqU2zWSnyn3sad+4IBnbz9v3F+9YAZavvF47nnGauZtfospl4P2L2nBRK+wRXZ93cvz6BGWDZizDYoCcYwZ5PtMPueagBvWttTYPMCoPSVV2+hCo/KdrNUJ1OEC0kwZ7D4wxU/vCbCAEWzXHwwtUQVsqdM6mtsJrFl9EFSaM+MriHGd7nGZw8r8lfwO19Aq
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(39860400002)(46966006)(36840700001)(36756003)(356005)(82310400003)(16526019)(186003)(426003)(336012)(86362001)(53546011)(8676002)(2906002)(5660300002)(82740400003)(8936002)(478600001)(316002)(70206006)(36860700001)(54906003)(110136005)(16576012)(47076005)(31696002)(966005)(26005)(83380400001)(2616005)(31686004)(4326008)(7636003)(7416002)(70586007)(36906005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 17:54:42.3162
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b552d6ae-cd60-4250-6d42-08d92f5d7cf2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5565
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 14/06/2021 11:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.273 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Jun 2021 10:26:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.273-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:

...

> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     regulator: core: resolve supply for boot-on/always-on regulators


I am seeing a boot regression on one board with 4.9.273-rc1 and bisect
is pointing to the above commit. Reverting this on top of 4.9.273-rc1
fixes the problem.

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    18 boots:	16 pass, 2 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.9.273-rc1-gaf46d32b472e
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Boot failures:	tegra210-p2371-2180

Cheers
Jon

-- 
nvpublic
