Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 670F044EAAB
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 16:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233551AbhKLPoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 10:44:10 -0500
Received: from mail-dm6nam12on2053.outbound.protection.outlook.com ([40.107.243.53]:56417
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234508AbhKLPoK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Nov 2021 10:44:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hZ27X0E8ylOVWOy5WmxsQnWbvkm2XS9Jlk67xMV2gC7pSlWZajrDxbO9Aw+R15LLPaQrw4olcfgqMlFh6kdtBkLbbrAhI+bN6xBBEPwBI89ZDE/xy0EsN3xJ8FQoz3LnOCKjGVyZuNENLciSuQ/+FBk+RtMd3CylKsKOylS3l0u6qLzl/PXUPPYho9XX2CJgp3IleBfgsUU2nZQsJNRcdKDSn7pL48vx6vA/JQFVUqiaItX3f3zy5Lug7C1uL9ayTnoTvuY33bhVwTDIjd71ii5IYlMZ2hANNn41ag8a/EIFXJoTSLs7j9E0irYOWYlqWiOMRvAsEjP9hLcrYC/T8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R0GBRVZIr23EMBz8OUHQQPZJ6w8TyWL3hfryEZHrfuY=;
 b=HsGWWeMZvH2gIF7kzVWPGd4oT3igCfCyrByzqQRKCiCKVh72lw6AEufSayEs7wflM07JeSCZaBnJWywo18DfL8OcTOhHbrzxzTJZHyTTj6pouFUTBbaOqUF36V/itIkclWkbqvnIkRzdR7ZWNuj328XbQlKmtV6nXh2X6Ds64magmlzSLNAt1PbNB0tUHNvsaYLwcVMoEmOK2mCgiiQ6pN00HUD4V4SNATlGqSecmLcm4uXI9Am7a8U5ySxyAucBq/ssjBYOS0/ZzH2LnV3G1E2B+5jnRtD0GZCEHwORVBmCkihFIPEJXz7a4NG37S1blT7nUKq7vm++Ws3BYUUlmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R0GBRVZIr23EMBz8OUHQQPZJ6w8TyWL3hfryEZHrfuY=;
 b=DC+3GEiNQH0JUwBWxFPCUf4tfEGnrKU78Q+GEDFOfONqGx24Utrpb5ytJqEyQNpPejqNt8TCIe3cnRmaLc8gP+TQmGXXF0m9bTbktz2Q6c6x4yHSaJX1U1yNJ/9q564JFNUT8J4W3dp4CtkXTEkXqly0Eyz4PYS8Mlr8xggLwmnd1T4bsXdpV1wf3p7RleYhqTINg5KXHzYW4eJl5JdIN+mGffAJkJ4BEOfrlJepbmbWquMXPG4B1hpn01/DdAiqkuFeUMAdqEQ76h+pmz2hSDePBJDt1xrN2Geh9p2CptWkWI45Omhv88ONezeOJ6Ke/cSUJXv3D5We1z11xdyUEw==
Received: from DS7PR03CA0020.namprd03.prod.outlook.com (2603:10b6:5:3b8::25)
 by CH0PR12MB5316.namprd12.prod.outlook.com (2603:10b6:610:d7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.25; Fri, 12 Nov
 2021 15:41:17 +0000
Received: from DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b8:cafe::44) by DS7PR03CA0020.outlook.office365.com
 (2603:10b6:5:3b8::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.25 via Frontend
 Transport; Fri, 12 Nov 2021 15:41:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT041.mail.protection.outlook.com (10.13.172.98) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4690.15 via Frontend Transport; Fri, 12 Nov 2021 15:41:17 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 12 Nov
 2021 07:41:16 -0800
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Fri, 12 Nov 2021 15:41:16 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/17] 5.4.159-rc1 review
In-Reply-To: <20211110182002.206203228@linuxfoundation.org>
References: <20211110182002.206203228@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <5b32621cf3e0435da912babc14091798@HQMAIL111.nvidia.com>
Date:   Fri, 12 Nov 2021 15:41:16 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f00a1590-9eae-4094-4231-08d9a5f2ddd2
X-MS-TrafficTypeDiagnostic: CH0PR12MB5316:
X-Microsoft-Antispam-PRVS: <CH0PR12MB5316E39EEBC7894D202DCA97D9959@CH0PR12MB5316.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uao+sU/Qjg4dPa8iTCIYHEucLp3DzQSeg4IiuKVTmHk45VjY+MWV60dGmliNZIYgA1s7DQ1xQ8Cz4m5HYoh+cTun1aFeE6iJ564UsddzmyZacx3NzT8ieA6braZx/TOLEMh1W8WdPSabIdCKTmvpiiGH6tPdqH7fKAhEjgwIrLe15sxwmwrBNF0O6gGRaKWZqdDZ4t66M/7lkqZhpLUB8Nl3qeEzBRIDHBhR4jS/zrI/55KTAJTEB0DawCKgkjZ0BthCgqEiXnIqQU3F46E3XxqHX30hhZog/TV2JVnwmiBsutW/3Yeijbv1KDCRMdCrZEh5Bn+wqDU6hYaY6i06T0mcXY0jraknEsfzmfV0PD5YDpBmNyJdygSO9H1P1PYUp5a38XKvsJf95fhLL6An5gAjh2TYDvU8kakCtBVckxCYs7OMikZK/tZVJoltUZRbv1DuM0BbEvBARcE5et/FMHq50qcGhD+aT08Tl4DGELrmj6PlEIBBqzkXBZwuqRz5uSXjxxk1UPqt0EKOm0/CzApTs+eK++4Xy0IMR/tWexCOZLhFL1wHGfII4+1DPbsPztGfo5e+cE4pYxHinAVe27LhvvcAJsWycaREixKDM7rn7CFx9snLC8D4Fl9iIGVEzQLQ/uADrEGm8tecwQWwXb6hTTfbP+ie2KXSXNkbMygG+s88jhaAWIczgo5gbvxbPIXBxAtocq23Gn4UdKkOa8dfZ87TtzfS4aXa2vYWLpaC0xlIBXNZvUkRRUCWbNFsVOBLkvNSC63OVQNAppooN5WVzKEy9VFgQQejZCVlPQE=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(966005)(7416002)(70206006)(186003)(54906003)(8676002)(86362001)(316002)(8936002)(356005)(6916009)(7636003)(4326008)(508600001)(24736004)(82310400003)(426003)(336012)(47076005)(26005)(70586007)(36860700001)(5660300002)(108616005)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2021 15:41:17.0759
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f00a1590-9eae-4094-4231-08d9a5f2ddd2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5316
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 10 Nov 2021 19:43:39 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.159 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.159-rc1.gz
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

Linux version:	5.4.159-rc1-g1422b7f3f43d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
