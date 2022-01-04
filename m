Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7EC484094
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 12:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbiADLNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 06:13:24 -0500
Received: from mail-bn7nam10on2070.outbound.protection.outlook.com ([40.107.92.70]:46491
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231834AbiADLNY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jan 2022 06:13:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ERGzfGwKuDoymNgPxJg5DU4Bc70vxWB0O5LRV6sU+feH7537Bc3ACm2cCSk85Jmm/T6Svq0bGuubE92FQrqr6wV0DDpkpa0M6mNpb1DeN16qpFzJQ7qLuKoR9My83JCg/a0vO4qnKgWUeaK2OyYJ1jfa/W1bctounwCtHXQVfZicg3B+zvB5q9HzmwHopJrAERUrugpWIRLr6ve+VMRiJYRUycs+k6vpl3+knFDOznxsj07yYmIubHLCS1+Ow7I7G0IcqwuJhbgfZ7aW+t29njY4tcR74O1PrcspCIjeRTJ/T8GsQ8SeFM2K9GGqDm+0P2Mh96CiyBI+/E3MOsDRYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fdAffrjm0E0JXc8K5Yk2ckTFyGcQpPnjTLbRgVJa+tk=;
 b=AS9+p+pURKKcz8SNpSczXVRoTLD4HSDLMnw3boPuHiZEpgUYkqVhegfNssS8UAX1s4gjq8R1IncpGkJl+6SXZ00wkMhdpXflsD3JKz0xVZbnerrlQ5tWJ2zCWJWWpgnOIYEcl6E+DbgPgcVVKPODzV2ymMIbFmtpl1Xy/m7rjPkiMPjm2xr2EtfnEfhM95lJRRUb5y4WTNCrILtzrztXDU4NoCN35KqLqEOrkAR3Xbyv68slZA71aMzArK259G3qAdf01O12WkPm0ej5Kq304b3IOi6UfyyllciKSjId1izWkqhcEBOGOA7rFf/Xc54iibc/0loKW/XB9MoGc9Iezg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fdAffrjm0E0JXc8K5Yk2ckTFyGcQpPnjTLbRgVJa+tk=;
 b=mCL1ZRu9s2YHpJyTPEuexGlIrnpiGHDY0L1c+3TU8UrOkwHo9fhuvWjea2zolxpKzkTOnFSdhPy16Vdegvjw0MlJEnZZO/KceQr9ONJMdtvrwFIG5I5eURXl0WnUum6yj40Km2TC+4dyYKt0SM9o4hawk03THfH8VM7WyIEszZo8mdPRnSqGawTbhCOc+oslEc3qfkxme9TcsHOuAQBI7hWq4SPV7ewN0q3pUfYNguyz7jy7AiJUNYDyZRbamVFmlVaBKsOK/EUj+Lk8Wgb1h5ps+1Xx2I7yrND0ibc6Cj5km+M+lZ5atD2nasOTF6pzwCQ0gkdrW1O9UzwJa8RZ2A==
Received: from DM5PR04CA0070.namprd04.prod.outlook.com (2603:10b6:3:ef::32) by
 BY5PR12MB4833.namprd12.prod.outlook.com (2603:10b6:a03:1f6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Tue, 4 Jan
 2022 11:13:21 +0000
Received: from DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ef:cafe::45) by DM5PR04CA0070.outlook.office365.com
 (2603:10b6:3:ef::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15 via Frontend
 Transport; Tue, 4 Jan 2022 11:13:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT030.mail.protection.outlook.com (10.13.172.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4844.14 via Frontend Transport; Tue, 4 Jan 2022 11:13:20 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 4 Jan
 2022 11:13:20 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 4 Jan
 2022 11:13:20 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 4 Jan 2022 03:13:19 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/47] 5.10.90-rc2 review
In-Reply-To: <20220104073841.681360658@linuxfoundation.org>
References: <20220104073841.681360658@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <b20a5a0df2694e60897dd42aa59ed23e@HQMAIL109.nvidia.com>
Date:   Tue, 4 Jan 2022 03:13:19 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0fb89cd4-d645-49a6-19df-08d9cf7337a8
X-MS-TrafficTypeDiagnostic: BY5PR12MB4833:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB48337DA4B158D829FE1C56AAD94A9@BY5PR12MB4833.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g6bYSHk6qZ+71Ns2Hp0X//WZjpXyxEpa8Ms5lYndhNHlWiEaUYBvPgrbfYP/Izsb1LoGIG+Q07GxQCES11i4cu6KBGs/wNlp7etm88UURqFySn9Pc5caZUZXVtfbOavGuUStNpNpieoYp3qg7iHsgERitR7KGYRO4G7GtW8xEBnXQnsYdDs+pRyixu/en7ACeA77forVY+rY01mkZqYFXBLM0u30z/XUi9+mLxZZgyKkGxbc2GxFORkaDLx6xiyRs8GAUTRzHtvuG0Gd14Ndf2oH+Qb8ygV9NNwWpwqIe2MgeGwhzwEyYp9ERa5CrMt43T2YKjQaUc4AFHFLlkytJbg353swKxbK2B24oJA9mANqpndBQZCokDz7VlG4fx3GMrv8Z0pS9DJOM9azNQEXObQV9J0Nj37ojAZU2bdhAuPL8MWC1JK2qlmo1jfLisRC4zky6CxCQdtXMK7wsXgWf8apgwOIqz4zkJNKKwgUKBwaDTC0eIGopdyggoOSlBcVKXgEcwTV2K6ysZJzF67HkEBxSm03qasjLpYDa0IUNX6nYgEWjSoOhhuTM65z0pR+K8y1/ibAQC6WdqSMMNDv/upeBJC5JbPMiI1TuV4mv5pzYmgEscyr+fBm9r2Xh6coRPWd2QM5o+yf0Z38+kXSjxWrwHcwBuO1z/d+1l3yoCuZdiWefEtLXcU6D2dKhOyuKFyMgefcyy5wANGrPcAAaN2M0FrjWNxvuHcwYwSy6dyiEzAULm+yRbN5enhCRfVgdVA5Uk3AJ0K/c++WH0a3R4axGIycgZelUGOwfUTlMeYcscfV7ufLOiX9/jihcqHjS9wq23doVEc3srYydum48GD0aqI1riK+8eAEIZB+6CqPY4UviVl1GjIJ8ETl0a0B
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700002)(81166007)(70586007)(54906003)(186003)(966005)(508600001)(6916009)(8676002)(26005)(40460700001)(356005)(7416002)(70206006)(24736004)(4326008)(108616005)(86362001)(5660300002)(8936002)(82310400004)(316002)(2906002)(336012)(426003)(47076005)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 11:13:20.9869
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fb89cd4-d645-49a6-19df-08d9cf7337a8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4833
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 04 Jan 2022 08:41:05 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.90 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Jan 2022 07:38:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.90-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    75 tests:	75 pass, 0 fail

Linux version:	5.10.90-rc2-gc129f56d557c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
