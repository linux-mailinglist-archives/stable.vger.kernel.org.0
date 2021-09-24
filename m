Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6891B417A07
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 19:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344397AbhIXRwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 13:52:32 -0400
Received: from mail-bn8nam11on2048.outbound.protection.outlook.com ([40.107.236.48]:19233
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344309AbhIXRwb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 13:52:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VEXZzlg/NOHtUDYY6J07LpT8VSIoQWMs4NZnCOCN5VL2/uGtBX8lxd1J8HNriIWPPhexxyDJT02kaGK2T67heyOWR3EJgtn8ArYq80viANuLEIRV/UTKSLIulCdgpy21agjVDa4KqiGcx6WmRN67A1lKlajqvzWCnv4hO71a8idrRQKg1wntR8aIAJFMl9Cn2VGqxsa6pOTJ0PQR6Ly/5Q1bB0Vv/MdMk+1eofzoKIPLuhLxA/LvP32ZWvWs2WRwuJZ2jgi/GKz0pHlL7RU+2ns+FM+6mLmhhHCbkMV3OIMoVHZeAp5Ha5Bo2k7tBeRDIWKe6hzO4BaqJliurVt84Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=7+7c86BWMpePZWlrT3Sl47rCO9RwPx6e8gbBRAtvCuc=;
 b=W1oANWBaEm6z/3xp9xD74tQqZ4Gk2oayO0/x4vsxqcVbcu+aRbYn7Mz2dwDVbcW3eSJjHYAvl1CatRbBjVqrMbs04Gitz22atMXm3heP0wOpu8/NgK3Pk/buQ/zv6IT4pT77ldJJ2It54La8ksaFBBesILquPCXfQ1fx9Y8S3f4ULzJa6Da3eJBq2+NIDKgqyZLTWITt1vkV+j92o7rz+cpIfl1zr5Kj0+2/+rfLi1qrbBlmINGj8HhILRGT94QYrAItfpWs3AjwQUwUcr0CELX1ZYSOo5gI3p0hEjFYK3TtQ9MUX36QppiHGoXjCHC6dXAO3vP0EgkrZHnuX4a+MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7+7c86BWMpePZWlrT3Sl47rCO9RwPx6e8gbBRAtvCuc=;
 b=AoS2JlwZTxx6REjoINOlZQY9bKuoP60iLORs6Gp0Hg4LyDv99EqduWpiPQ/Ctu0mtRNU5gtTj7U4cbYyPZijKDKkd3rNWSP8vge1J4896pztchspkGc62ndl0ftmOenk9ylhr+E/VWhKSuFX7z0t5xh+5tx069SBEUWpie1LnrnpzIrYQVm6x4IDw/Lhi3YImajAshKhP9K8fUq8H6wELDE204YqwDA2Dvl7c8fFMF6kU9YQj7whR8IeDRmS2QS32fnPGoXViZKHRjrIqEMih31RwJuRM5jdzWI3tCwz28peHRYSwrQK0trNVNi8y1uB8mGLySJkuamgIbTC6f6cHw==
Received: from BN9PR03CA0124.namprd03.prod.outlook.com (2603:10b6:408:fe::9)
 by MN2PR12MB4159.namprd12.prod.outlook.com (2603:10b6:208:1da::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Fri, 24 Sep
 2021 17:50:57 +0000
Received: from BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::e) by BN9PR03CA0124.outlook.office365.com
 (2603:10b6:408:fe::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend
 Transport; Fri, 24 Sep 2021 17:50:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT007.mail.protection.outlook.com (10.13.177.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Fri, 24 Sep 2021 17:50:56 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 24 Sep
 2021 10:50:56 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Fri, 24 Sep 2021 17:50:56 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/26] 4.9.284-rc1 review
In-Reply-To: <20210924124328.336953942@linuxfoundation.org>
References: <20210924124328.336953942@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <5bb413059b7c40e19cfba338a21e33f4@HQMAIL101.nvidia.com>
Date:   Fri, 24 Sep 2021 17:50:56 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e568c808-9b7a-444f-9529-08d97f83dca0
X-MS-TrafficTypeDiagnostic: MN2PR12MB4159:
X-Microsoft-Antispam-PRVS: <MN2PR12MB415950B63F04F4FBCFF3B59ED9A49@MN2PR12MB4159.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FaWxwlTuzO2NnVqv/dp4OjWATzousepVxjrKJqBUY7jC3xO8mMULaqU2WZPJcuZt26cD8oVFQxrVxPp54erQXyrYlL8IB1InRnS4sbAWdknDF/iWw6Dx6AoSFsqOoOcBJKiA1J2dp5lZu1hCUgZCvwhcjfX+/lvaYBv30mJP9dG11pDKCA9q+xvohS3WdwnZU67ShBrHO2yHYW3dduPF9O58fb0qAWoSjPBwR1YEXIBF0b0bTIWD0b+7irnCkVTSoIGOVNM6chQ+TDN4swiyh12ZDCDjIbuD8qENrXU78lWmic0ba+om7q4TEAWhOmkt5L9UCNVXR7UBrxSxCH0iHV9eGpOuXWK20E+Kz9L4veI9tv6ntTYP6gMUGoplodkeOHP1MUZFr26mYzcf8IQ6gfD4wj9hn2DffDkRAUC4ENBds5glec9DJ5km2BqUUNUw/M7QlhZGOqvy9bcAcyVsivBomx7uWfHz2uAIgjOMFHjor3f9skiEkGEm7GVO2bfN4GCWIlcLaILw9umz6vuF3z8Dl+QZcOqc+I/n3jEzEvIK98JQ1m5wtL+A6n+Ae3+r5KcZDrXxUHnYAcL1lDSji5wVp/M/UPfNJdTZHcSfFKm1exKQGUaQo/Aunct1XWDdfAXxjvfpwwViTqj+Fvl0YSTDQdXlV3ysaGeSH9vwHK4eWCtxS29CEk8HfbikhSYIT7CN5Sn5NkWUaElYi+5fNhZy2wjXMIcXBfa27oe/06A7m3pJXhL0OF58RY+zn0LHI1totuCZDqqkZgB0w8A3vmgAvoae/qrhFVwjUedKggw=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(508600001)(2906002)(966005)(186003)(7416002)(24736004)(108616005)(5660300002)(47076005)(36860700001)(86362001)(70206006)(54906003)(70586007)(7636003)(4326008)(356005)(336012)(26005)(8676002)(8936002)(316002)(426003)(82310400003)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2021 17:50:56.6771
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e568c808-9b7a-444f-9529-08d97f83dca0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4159
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 24 Sep 2021 14:43:48 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.284 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Sep 2021 12:43:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.284-rc1.gz
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

Linux version:	4.9.284-rc1-g09643351c2e1
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
