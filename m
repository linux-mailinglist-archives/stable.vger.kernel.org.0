Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2BC744EA9E
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 16:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235165AbhKLPnk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 10:43:40 -0500
Received: from mail-dm6nam10on2055.outbound.protection.outlook.com ([40.107.93.55]:50432
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235382AbhKLPnb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Nov 2021 10:43:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jT+s5/FKvkihSJm/COHvWG2vG8C7tA9eDiFaScHHr6dVuF0UzgMN0vMW0Cn5tRQAZtyv0oHFAeG0Oy286d+1Ce8szINd7apXwlGGNUCY3I0AQEouqBxDHD99B/zbfdIyLHpEtk1JoCDOgMJGsbRo07JdkmfS8kAgfXZO2piXxA2vyeYr2Pl3rBHc1W9zU+0+hL2jjQc85Q1zValJ//9exKlusJU4b7QZ6nXH5KXTeQEMItlQ+7AIyk+qzYJuriwvy1tET9knjL4wNBzbZPasxcLNGKZ078kwhX0B0ROdujS4e9hv0ukBareReyNs22txJVLra9mKlJii9glRckgIsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9sdTcZXnJo5lJLbaCh7QvF3kWOTlVRoq/9QAAXBwQKc=;
 b=X+uEVKKczl9dq8RJVgxDCN4ZYjJuPMHjfK0WOVk5w6YKJTq+WTkiQhv0tQByJMhyvkw/VS2XDTeHrx3d12B3FW2It3HlLXW1cTaemPFbJROO+0s1mCDtuTI4PDi0jOC+aPLIbZ8l2uZEgedURAlv18ZHicXxu+NKJRPl6VpEu6DtMEckBZ9O9Tu5YmKw1zBoExLGcp3rpNErxp5lJP3udZNQgXEHpMDWcToGTdC2MEgosvH8tckAr9ObBl7D0ckeQhP87P4qLATX7g4c1tEChVCiXvXS9nn6hcvVQMLbRnPnDLsEgqcoWoB7D4pyx4ZUQFjHEEIwFH3breOyPvl10g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=quarantine pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9sdTcZXnJo5lJLbaCh7QvF3kWOTlVRoq/9QAAXBwQKc=;
 b=a3lrW611N8DMo4JpFJF0cOh9y7zol5xXQLL3Vg2dHAG4vS3f9EGrQmX+9dGuN6/QjC5C4/FhHWe1w0nnDdI4ehDt8NVN5f6jFlUN/2gZfNlbPeuC8GPJJjv144h8BGHObCaS49Zb/XJTDT5fceWVm0HtWsZDqewvF8jcuffLuSciww5ENaxB2vFIKMDZckP+R/j2sOt/vaNnt1kR4Fpx1oLyExya/bkHZOm+cJI6wQkFtN9r7ftvqlWsTUEyoVDWqqZn9bIY2/PMHXU7+c4XfJtmxA+jFCPH/dJoWFrQVWlQfzJkxmpsrxI+ZQW/PyVGyAkBhC35LwQoiL9Rp1TiLQ==
Received: from BN9PR03CA0911.namprd03.prod.outlook.com (2603:10b6:408:107::16)
 by DM6PR12MB4531.namprd12.prod.outlook.com (2603:10b6:5:2a4::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Fri, 12 Nov
 2021 15:40:38 +0000
Received: from BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:107:cafe::ae) by BN9PR03CA0911.outlook.office365.com
 (2603:10b6:408:107::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend
 Transport; Fri, 12 Nov 2021 15:40:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT025.mail.protection.outlook.com (10.13.177.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4690.19 via Frontend Transport; Fri, 12 Nov 2021 15:40:37 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 12 Nov
 2021 15:40:18 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 12 Nov
 2021 15:40:17 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Fri, 12 Nov 2021 15:40:17 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/16] 4.19.217-rc1 review
In-Reply-To: <20211110182001.994215976@linuxfoundation.org>
References: <20211110182001.994215976@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <b6d4b594416d4439a7a8e07c712e2aa2@HQMAIL101.nvidia.com>
Date:   Fri, 12 Nov 2021 15:40:17 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc464e9b-5b24-4e26-5905-08d9a5f2c66d
X-MS-TrafficTypeDiagnostic: DM6PR12MB4531:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4531C02AD029BEFB574531BFD9959@DM6PR12MB4531.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZWU+45AY62QqVPWzfli50LcMAUOT+/txQ2M2bBCyD9MuPZ/Hno5pg84v2rW+4pgnO0o/ypwFjcv+b7y4oo7qtVB9YnhWvjyNGAFNSItWS+EJEOGjs2uPNLB9g7DCaD1X1SzMSRYybCImeifoHL0Bwb4KlrBdlxYgqjOegc90hj1eZk1kCYJ1zP/qOAU284NU0hXptJViB61z3d6qWv8mJqlgd9OQuzfsag2ThS8h9e/B49QYwfGQS4vepNpTWp63yFInIuJYoB/32mj0GIwVqPV0whG9Ox4xjOOUqOnMNpKCyQ59MPJ3AG1lbSplhsMwvjoJpOS2M/wx1Q4NqUe/9y1kO0J1Ws2oAXwssU/YSmCa6huxsvetsDumdpYkcIbZOD5lUFt40YJARUrq288691A4IYoOh83ivt4N5i9pCiUd6mxCEyNszRMo7dSbq6KVsmMbQPsgxCVUmpoaDKf3rw1krQVczgQvmlDN4Vxa7JZE9dC97yjtiFatR933fIw57FvT7S6dDrr75l6bbFEiemn2GvliHMxQQoPYlYbs3w9XiLeaf7s4Lm/+LsK4ooljxA4vAxN5t244tXxEKOW117Pp6rlksKD61olJfSMwgfqffwaimKl9frxHHwNCrGH+LxStfRLh96VORPOVOsloG2iiqto3AhxQh+xlfL1ryt6wGgTSaiDf4wD8oPnQDVEyBwnWOgRWpRzNrofsaLWLrw/99oXMuWVyxEonKTGVrVV9FeFsoRr0/Yfz7qSgCEIw4PwSgnL+vMBE1huXZd/8i7/2TqUIn7m4Rw7ZKVwwoq8=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(70206006)(24736004)(966005)(8676002)(508600001)(108616005)(70586007)(426003)(336012)(82310400003)(8936002)(2906002)(4326008)(6916009)(26005)(7636003)(5660300002)(86362001)(54906003)(7416002)(356005)(186003)(47076005)(36860700001)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2021 15:40:37.1993
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc464e9b-5b24-4e26-5905-08d9a5f2c66d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4531
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 10 Nov 2021 19:43:33 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.217 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.217-rc1.gz
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

Linux version:	4.19.217-rc1-gf1ca790424bd
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
