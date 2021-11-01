Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99980441C0A
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 14:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbhKAOCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 10:02:21 -0400
Received: from mail-co1nam11on2068.outbound.protection.outlook.com ([40.107.220.68]:19819
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231366AbhKAOCU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 10:02:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I9mVvOxjpJEXwwHK449BJklUkYl4p5JUEeWXHjk2QG9TtL+Iejc7WJhZBBEWztoi4+il5C51lSBB5qAQMxpRWHRQqYkEXx44lb0DiBHNDzkp9xq/kyOySU7+AzzmiUsJVol1udrelU0C/CkXaZu0+kgHxxl4qmJjXMC5N7sKp1BmX81GCyNZ12XJWkux68Aw4DbwyBm1Pd8u7mjknmWo2Csllhpae7btK/S08gOjIYQGTiUZPgFKZ1tiFFeNscaz/oQp7/WNKJ9eb9/oCeE2hDPAcGQMVCHFcsjB8fjnnC/TnnQ58RFnTO0dNMfNmpUp+ZoH5ZhAQM0iKrdpemniVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o0DzMcUrv+m8zpjB/7h/dei3qAf1A+Om7oRrs2iyClc=;
 b=S0WctCcYEdKhqc9nGrpoDaSdAWt9DDl31hTMrEh2cwKmsKZjGvw9qAotpkvTQvRg6yVbtCxXuBjB/eZGN88B8IjXl+VX6/HBlmX/YJZdoG49WyIp2oHgAxBn0KI6VPYZhgfVq3fRCeehDpU1GQd8hSS/HMIIIxKRjijE+X9w+afm3UjzkDpokPqDuNKthbU5JujbaQt9+7H614TD4Que7vPaRe5eFTRcBDzz1tV/NXlmWQWwGA1n+YndNknYB9MrfP+Slp+uOHzeX7tpVmvBfQwDKzUo2g796Vgj1geubVywj0affe52FAxZgOmsw4eiZ7fuLwv1fwjKYFabPwF6wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o0DzMcUrv+m8zpjB/7h/dei3qAf1A+Om7oRrs2iyClc=;
 b=UEHwIxEOZA3Yx0VRN99OmtoqbaivOTIdXsEVP+Z242y032pGK9Mc9YgNLt8s6Vu6371YF3DmwZ803MT3rSO+JmU52cMw8EBsb7uTS6ElvtOCmQZE0q+n2Y8jEM4eujrsi6X777O3AMUgKXJ024xc6fbuyUfxxe/y0K/dkg/3e9gm1K+Q+uOuwKr9MSl4scd1kCunw5/pkiuhWRioQ1w5lwDEmWGHiKiymPRTPlcpkH2AQ+h3sjMn9/+Vh8+0SeKElvMm9d/pJCHpGl1sEQvWWNU+X6ix8U+mqPJW6rYV5SJREGhPije0Yse5KDne3f43Uwy74cCApI7s+VWWBC0/3g==
Received: from DM5PR1401CA0005.namprd14.prod.outlook.com (2603:10b6:4:4a::15)
 by DM6PR12MB3546.namprd12.prod.outlook.com (2603:10b6:5:18d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20; Mon, 1 Nov
 2021 13:59:45 +0000
Received: from DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:4a:cafe::c) by DM5PR1401CA0005.outlook.office365.com
 (2603:10b6:4:4a::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend
 Transport; Mon, 1 Nov 2021 13:59:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT068.mail.protection.outlook.com (10.13.173.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Mon, 1 Nov 2021 13:59:45 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 1 Nov
 2021 13:59:42 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Mon, 1 Nov 2021 06:59:42 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/20] 4.9.289-rc1 review
In-Reply-To: <20211101082444.133899096@linuxfoundation.org>
References: <20211101082444.133899096@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <bf35922611124586bdc79c7d86371eee@HQMAIL109.nvidia.com>
Date:   Mon, 1 Nov 2021 06:59:42 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 424cd51f-6bb1-4d90-a35b-08d99d3fdc74
X-MS-TrafficTypeDiagnostic: DM6PR12MB3546:
X-Microsoft-Antispam-PRVS: <DM6PR12MB354650A5004E3CB36E993AF8D98A9@DM6PR12MB3546.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RNZecXSYA669no7Rv3MgxtEz6nVtNy8kQdwZgkIEHBZlFT/GuSkOZAaoW/NFbrHhNzIC1t3+TaTUkYY8FEqHx6gElN2n+eCWbEwbiJPfQSpNDaURt5Jgz1k5nCl1G6CjrVr2XenNBEG1yvF5keUJDmTxK55me9bSisMZ7Q46gPI8L0ajGtU42wzUOTlCcISNZoQIVZ+wDPUqry1HyL1Ti8GpMVmd1PaC3b87jP/yIHgdo7cHD98haRI4USLXl2fbDQml3va4iJDOiWakYN18R0+2j0Pr41q4rD0E708XwUG5zgv2/DTH4KliN5NI2nV295N4PyMkjHE+jp4Gfy5USMXvEea39QXGw26uvibsEgS+ktB/KSiaOyhjbKIilCDIIRCXPE2dgeVU2NN/A2FKkj2IvK6pseWczEED+R9cwMsnAJC33yyNutmVYTif9sdJ41NW+7izd4JFmQj+yW7YkpxqTrVi24ddalmTKgBgWSMmDUARcwVtR3dId5tlmXuADy7Dt+noTgermHUa2Sew/SkMBfNxrImMDs1BGXV2jk869H5ykonqvwSxhZpCmxwXvWQiScAO7qfLE35gqMDV54MzhfXk+zWcwrvDkaXuE4l6M0RAx59tDYJq/1X5pX4kACWiRnVj5CiI7MNWNRzrEFSomGyYDjL8bl9+2+EcBgBvqONY3DdLMqg3TtW+h7VGZXy8FgdMTFBm+45XIRZ3jJP6fm040qU13NFvR50pdJr8j2SEqZ7C/LqY2F2urVYGJglDOKFucZlujmOtnzWh4hP4F34VST17937iHhXIHDk=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(426003)(26005)(7636003)(336012)(7416002)(356005)(36860700001)(8936002)(108616005)(2906002)(966005)(54906003)(6916009)(8676002)(508600001)(316002)(4326008)(70586007)(186003)(82310400003)(70206006)(47076005)(86362001)(36906005)(5660300002)(24736004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2021 13:59:45.5798
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 424cd51f-6bb1-4d90-a35b-08d99d3fdc74
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3546
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 01 Nov 2021 10:17:09 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.289 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Nov 2021 08:24:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.289-rc1.gz
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

Linux version:	4.9.289-rc1-gd353d4ac36c7
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
