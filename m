Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86AC343AECE
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 11:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234250AbhJZJS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 05:18:59 -0400
Received: from mail-dm6nam11on2089.outbound.protection.outlook.com ([40.107.223.89]:29450
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232957AbhJZJS6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Oct 2021 05:18:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZJOLDpr8FIsdRwqWdgzCZ0oJ92EcNBB8kXuj9OZgyNC3jOXIf6r29VBb8c/W00Cb+NFa576+9szcYbcoyTHeKRKm1igCOQsbifRqcheowoE6rjL+d+F4/s4nvNOMwWQEO2e/cErAn4Il3Az4h/rTBTMLs5XPmDRZvP5O0SgqD8zk0kr342J7OFTFxYx7JJMZ+3l+evVihRhCujNCLktvRJ+aQvlbyFZC2cvYdagmUN8Il7CGsCZD/uJMXU0RI+jKffEHVesZWYDQWyIXZhn4vPd9frAZOkfn7sOqW563PxC1d6em0QzoccOXuagD9SugLHNCWBf5G5bJvG5pQUs6ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JIXA0E7DLgZ+XvWYU8B2LR3RQwpXSncPgIreOYIjBeE=;
 b=k91jBphvc69VUZWx13SDD7o5uUIeadhfgRqvEFb6EfGOxashGojhss5pJgGtZ1rUA8C317dzgicX5yR0Sv/dm1P4BG6GxE2IGdQyxDK4aOLV/YKdiS9SB6A1B9q9dXC5yTgRcvH+RNCDObe1WDRW5de+3u+kIU5Gw6Bbc59GGEZN6LC5IxY7tFCqeZJwmloWbo3BnhApfYRyFmvTN6Q1Qd3CjzvBzWptuA5iAkFVZ2T1qejJvv16KEWmobo6ULkmmlMBEpSKCs2SNp8vGy9O+3L3qE6qfbGapfRXxQObC514HnVy4rejv9oMvVfEr5Exhzpwnama54I9ogwXVVTGpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JIXA0E7DLgZ+XvWYU8B2LR3RQwpXSncPgIreOYIjBeE=;
 b=ZZDGW8TjYYVh+BcyLeWYy3TZrEaTq0GqPZKXRJZ97ydgiwFGmaXGf8rRJZq8BqeJrH8/Zn7ftWFst1VI5/vpXqsWN3N8ZZxivo55+B+toX1pyZpQ49GrRqI1fRxvCN2nSulinAMNDL6I3XHGPeM4xr0WJDWeBvC6eGAGmqIZJVBr8aOv5ySM5HwjFYeaQOKm2p4QsO49mux0e7Bc7EUI6yokej28cMOYN3G6jhShsx3h20G7kUc3Qdl5uLS3w0iW/34HJ0lcU8OfF9nMu5tV4MCGoIAtIQLCK1cznq3TaZyON+axfJ9DSGE32MTfkBzmsnxJtocsrpTbtMQe/Hjq1A==
Received: from BN9PR03CA0440.namprd03.prod.outlook.com (2603:10b6:408:113::25)
 by BN7PR12MB2641.namprd12.prod.outlook.com (2603:10b6:408:30::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Tue, 26 Oct
 2021 09:16:32 +0000
Received: from BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:113:cafe::db) by BN9PR03CA0440.outlook.office365.com
 (2603:10b6:408:113::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend
 Transport; Tue, 26 Oct 2021 09:16:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT043.mail.protection.outlook.com (10.13.177.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 09:16:31 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 09:16:29 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 26 Oct 2021 09:16:29 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/44] 4.4.290-rc1 review
In-Reply-To: <20211025190928.054676643@linuxfoundation.org>
References: <20211025190928.054676643@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <cf534ee9ef0d459ca1761059cc5ddab0@HQMAIL107.nvidia.com>
Date:   Tue, 26 Oct 2021 09:16:29 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd253778-3689-46ec-d9a0-08d998614d1e
X-MS-TrafficTypeDiagnostic: BN7PR12MB2641:
X-Microsoft-Antispam-PRVS: <BN7PR12MB26419A3819F7B68C5AC06715D9849@BN7PR12MB2641.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: txchqkVMZhWGOhkc+kp6nnzeojBqjJlL8X3Z4d7D0utP4m/dTMl3TQPtee6y5P6HSEawsApsv9IzbFQMXtz99GiAh4plhsJW2MNJqNszZnsl/b/H29HN00vaPp1xL+7z5VyD4uWlrlZLpR2vVze3Pdf1TP/NIz+b+NNiPhQbJOySlkxL1MHaL3l74WIY/LK+KSbrpr7shFSNUz9Y7BtzMKY2IX9VZZWBy+97YrKfXJeUocI4vv1H/5YZhQ956fCOnFEjoiGYS0EPaH9Tcy9jV+ng6dlp9UxTVC3jI0i8/SBiPeIaP73ov8jyAfOtPUoxMzBg64s2XvJp/qyNNaiPrQzI0j5iypM7Eb9/6GpTA//NbWCu8AxnGEQ6GpQrOAi1/qat8LrYrJQmFtlzjv8HJgVnsoHmQRH39iy60bs3BQ90Vda92G1Vph4IAvZwzXciDJFUcU+jsIQnhvpCNWSqkC02fi86CYNPCpktwEis+7QnA+8QypSPQVxqwnlVHYD2qfAmcb2Q0FmnnNIfB7P+rKaQaKgY98EmSwfduFnVZSsBJev/0+m8tM1zKwB5Lm1FYAlBiy/Jq/RG1vbtCA8nbhpRNjTEs1Fad8Ps2eaYG2FDWZf9acpzCLSvXds1jBTa4+QCMzyMslq7kffHHEYQcRfWh4uHUe3grWXgydJ7beNnMdYI/ln3nkbFTpWt8TNfeJaCy7Wdqc5ggO2+30pQkO9c+i0+S4fuYk3hlc1T1axMIi4PWKEh5L3LiDHNmToLfIJRMlKQm79cKF269en5cFvOMFLhmolM9V+tqabK1PM=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(5660300002)(508600001)(36860700001)(108616005)(70206006)(186003)(86362001)(7416002)(336012)(47076005)(4326008)(70586007)(54906003)(316002)(2906002)(6916009)(7636003)(426003)(356005)(966005)(8936002)(82310400003)(26005)(8676002)(24736004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 09:16:31.5637
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd253778-3689-46ec-d9a0-08d998614d1e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2641
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 25 Oct 2021 21:13:41 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.290 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Oct 2021 19:07:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.290-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.4.290-rc1-g7d5d802dae8e
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
