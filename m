Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5788742E15B
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 20:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbhJNSeh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 14:34:37 -0400
Received: from mail-co1nam11on2045.outbound.protection.outlook.com ([40.107.220.45]:41184
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232360AbhJNSef (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 14:34:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ns+nngXhFcX/+x4B3+Dzlxqb2jBxyyswHMlgi7Ov1ZnUu1XKnp8diZoMp7IxOiVS+iTLTu7EhmilaSk/JksFAK4KdHkVoC3w5Gfzcz+DuAhssArIBbD6auDA/KvwqTXL/VWm1r609PFj/3NiMCDYuOazhmNfft1nBO0FdXj813qJrnDbWYbqOaIpuMfHhGJAlRNdJ0h8vbTTK/HEpZP/YrIaNQg0NFZh3kfYVjahiGOzQG+ChGx29clGrLpl9E0u6eThVp9pCy4hrKm8qFu2yqesCfGwXuelkU28rjZYi6Ex31ZWsABnJKYk9mayQJrux92yXjkrFK3EWkE0royg7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zGo/QTqHK6HhCO/8dwzCkx5Php9lGpUYSS/sX0tvD0s=;
 b=OLCzVh2YU/foGfRnwKk/a8JKkPaDGkF0AZ3fHBIvDEO2llw9aaJ4duSeMQAwky3JxXpGB61k0/+cbVgyk3FqMqTVoc4MzLSR/g/P1lvZvN1WH+YbS9sQF8WAfPumVKd60bp1YqjLbThki/1O1kGDZqj2i+yGWjLc+/B0mNG1pe4bXW1CuAlspEkZNFr0X4B+3Wgo+RoSvzp94tkZXqK3tWfr+IocwKbvMcYRMnzFD1Q3RP/TMOByaQWz4rfsyC7x5c3kFdv5sO4VGuNIuNz4yfiuHKvpRepK0YrOOwgxenEzEjisPXx0BM5qROxy1h9DUHI6n5VjVf7GeY9T/U+GZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zGo/QTqHK6HhCO/8dwzCkx5Php9lGpUYSS/sX0tvD0s=;
 b=XCkvzB+Qj2jbKxDA6hXL4CqKQu8i79zLlnl2e8Z4CuxLPB3jYUQggewyQY0d0NvKjnZHJw3wWHz11+VAAU6IHPqGbPGlMcb/M8KDY08rgk2+DawDHPaNG4RaH5yCW5Yc5V3hC7ciJltkC8tm1h8Syuz62sO7sieUePlMJKu4Ze73H0jUh7DJf5w1r3mslHX40O0mxHNUPsWNTFEmSXm2Z7Jr3PDTej6ZF1wKt+Ki79RlDya4B0xc7tQ/jqGyBRPC3zQVWDFN0LIxNdo491oPmyNbeAqVEM4s6U/FgrxZlWqjblRU7K6wfJmfo8sbKypM3gAFavRY1iVlBld7ysvWqQ==
Received: from DM3PR14CA0140.namprd14.prod.outlook.com (2603:10b6:0:53::24) by
 CH2PR12MB4152.namprd12.prod.outlook.com (2603:10b6:610:a7::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.20; Thu, 14 Oct 2021 18:32:29 +0000
Received: from DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:53:cafe::ca) by DM3PR14CA0140.outlook.office365.com
 (2603:10b6:0:53::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend
 Transport; Thu, 14 Oct 2021 18:32:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT054.mail.protection.outlook.com (10.13.173.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Thu, 14 Oct 2021 18:32:28 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 14 Oct
 2021 11:32:22 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Thu, 14 Oct 2021 11:32:22 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/25] 4.9.287-rc1 review
In-Reply-To: <20211014145207.575041491@linuxfoundation.org>
References: <20211014145207.575041491@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <5cef280bb20a459ca48ba60ba55ed2d9@HQMAIL109.nvidia.com>
Date:   Thu, 14 Oct 2021 11:32:22 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c33794c7-b687-4435-8003-08d98f40fa24
X-MS-TrafficTypeDiagnostic: CH2PR12MB4152:
X-Microsoft-Antispam-PRVS: <CH2PR12MB4152EF040B54AC2988B7E0FED9B89@CH2PR12MB4152.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PiwshaZhAwrjKyN6aisX/GDr7nYXdB+MWXZ70dL4DOPrLAtOBkGTJmqRSvQxQ6XCpDA3caduATkvvOU7w0z5IZiFp/ZORif8zgaCPzb9nXyH7iQEaoxP7/fozLAikUZr5orXknjDwEZ9U5e2MrGmaY4CS7PzwEJ76mL35w8qSvRiBNdRTcjRCT8jqYmg/zRhEAaR/YjMNgs7iHWO2K6wDPgga2aMeJTcS9zC+tTD4yMxyqau9WlYwatnMwmwADu5wp06/DI318THJlha3ZhU0sHTjEkElKlsa5Z6WJZkeXJT6F/0LeFxCxzw+lvciwM0wEdZ8mI+UKL4PXAID5DeVl97QGltITz0b8bxC7gG0wtVmhe0G8yNcWdJjNDviUpIc7XlqVa99ZJDG8ANV0T7ohZIFGypWyzpJDv5gpiSqfCQ7dhYI5iEfOQPXWbOxZmimFjvU51g1SJfxaz+8+e6umUbqnssjg0Kjq3DVrwvnm7JHoKlGmIG2GTCiraOCxFxK0cjD2VgQEa9ocZsx4bUVvMfsuJXUemx2m/rR7/I29zX/DrLsRgWWvdewupdQt7vAgO+/QXRZG3iH6/Lw9Hnf/4a87N5gDLG21rPXXwKtr6077Yhvk3u/jRzbl6fGpRbRo2eMyC4k+8G7mn8ikNHUvBb+CtrHTIjveCemLEiQitNOzF91ds1YLs8zItrk3cpxgIBD1q13OCVv34BFkvB63ugg81mOokL/WhPY9Rx1M3da/CxbO89xdHtdSdW3XijDgEqe5Bz/+4/Snfx2y2IQf2RASJl4782XHmZNwIO8h8=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(54906003)(4326008)(6916009)(426003)(508600001)(356005)(7416002)(2906002)(26005)(966005)(8676002)(336012)(24736004)(36860700001)(108616005)(70206006)(86362001)(186003)(8936002)(316002)(5660300002)(82310400003)(7636003)(47076005)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 18:32:28.5921
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c33794c7-b687-4435-8003-08d98f40fa24
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4152
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 14 Oct 2021 16:53:31 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.287 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.287-rc1.gz
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

Linux version:	4.9.287-rc1-g2660ee946a02
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
