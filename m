Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58ABA43AED6
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 11:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234095AbhJZJTF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 05:19:05 -0400
Received: from mail-bn8nam11on2057.outbound.protection.outlook.com ([40.107.236.57]:2785
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234330AbhJZJTA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Oct 2021 05:19:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cK26scqOfTPB67jyeQJx0sX1tP3CcJdtGM9h2gkRHjx/Bk+1ZsRdCeAXqePOA+JjevzdBT6KkrMhWv/k7vVwCIja9dZq5sGpYfrauZVrvJ/9V+S4b/6/CkePS0NMNKj1sww4mm9j7yJ/C3kfwwnQtiItDVK1fPLcoWncNtiwKusD1q+x8p/bDtWxGoOaYBhPP9QtLxvNlFAcrwlm4lI/0+2fEJ5BFzguw52AT8qPh8GI/ggwmnHrLU0TGuRikpDX5IA+OM6R5BdFZX29vsoTTY8atCpbBPflYODLuiWL5P3/tn9LLpJV5yWm8W7BfzCuX+WEOO1z3C1Havo1g+0RyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NMJc4ws/5T1hObpZXPY96eBOxruPcn3ba2j2v7qhRng=;
 b=TyFDBKeq8c7J1dBgmC3+V6FT5CjAMIVCPlxffxLX/V8kbEibyrw9b6JxsAn4LyEVJcuX1emuvR/B4G7rONIntyERtg0fKFsEUsKYQoh8p1O9DKzTq7/ldglAvCmw8DksvcY2ay1ZLq+/9+RhZIm5JyeRlY+IZ3GJSVVEutgnAbWItmYhoInz3uNWMV1O9ocedpaRVrcYSkC0PS2cRgXZH2DmASOIEv9j2+nsifg+uvQBccuc8GA7hH6m9VGE8WnTjfOw0A8Jazh4lBoojrGUVAHLYj1sWgHLRQYKvLrli23Z4OT5sHxthlMZXisdrOCKZNwAfbtArdSLNRgWux3fqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NMJc4ws/5T1hObpZXPY96eBOxruPcn3ba2j2v7qhRng=;
 b=dvCVyKIezmvTn69kwk0vx26W+BEbthSZEVsudIYC7KHdGnJk68q1Eq484mmCKHx64bIj1r3y/Q37sVAjw4o9bE7Glfo37qabfQLlMmJWQjIQZh4qNow4teH9BcDjZtz1C0dMg0EzR+EZsquAUxcvAHk9togqUFjpt733Vs0d6Nig9I/sUQXgC2rxSD4qJDPgTN6M6eAaQzGZcJhz/p3f6QOTJiwzHkibfZ1St4b7BaU49vteBHw0RbMfu4nnmS2Yz/XvFL6Dt5n2SpDWyWkVNRYoYD4MBi6RQO09t3TVWK3ltQfngI9jbPidyNb7Bn0Tr9Ral1erMHFlS1DO/P6zFw==
Received: from DM3PR12CA0114.namprd12.prod.outlook.com (2603:10b6:0:55::34) by
 BN7PR12MB2804.namprd12.prod.outlook.com (2603:10b6:408:2f::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.16; Tue, 26 Oct 2021 09:16:33 +0000
Received: from DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:55:cafe::bf) by DM3PR12CA0114.outlook.office365.com
 (2603:10b6:0:55::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15 via Frontend
 Transport; Tue, 26 Oct 2021 09:16:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT045.mail.protection.outlook.com (10.13.173.123) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 09:16:32 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 09:16:31 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 26 Oct 2021 02:16:31 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/58] 5.4.156-rc1 review
In-Reply-To: <20211025190937.555108060@linuxfoundation.org>
References: <20211025190937.555108060@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <c7d7b1ba975440238f1f8eee126052a9@HQMAIL109.nvidia.com>
Date:   Tue, 26 Oct 2021 02:16:31 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f357a35a-017a-4673-33e2-08d998614d5d
X-MS-TrafficTypeDiagnostic: BN7PR12MB2804:
X-Microsoft-Antispam-PRVS: <BN7PR12MB280453CD513B3F62DA7166B7D9849@BN7PR12MB2804.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d7Ws09pGqZ+7MEmTitFyeaSbymXq08QAWTkqwhvnE0rtSir1dMLd4xoXn038ibJUfQ2d5+Ha8IPMu9UMXd4J+jsDxXc0skSfEnL0jUR7VgPArh+ZR0fiwhl6Q1zjCNsXRWw2w1zJKJH5TH6o/xunmfdpGDDub72YVZ9XpBeWJtamf/IKosUbOHL87F+TaxuDImcHEo3DjEKxe7o7EZBQdYhKGlZAJZOwMJ74ciDTy2T9NjSZjjb4i178+PPgoiXX+xFyojLmw5r1u72PHvGmj5Sod9JIWLzFv8qF9hT0EFoGzDVmDlcFVBrvAJcrn1ZppeWv84UFSidk2zhlyJ14qb4R1YmtsUfjGwfHRaOkGd8Bt3FMlrJ2oFFlNDMQgQb2eAry+Mm8Z6tEXzH6vyavMD2l45JtfASzX7xVhm8KnbrnXwkR5MUo8eR8NKmv9ljnXmLQ3FOu62hyBVyRO1537YUx+yndwYR9GAuVg17mULUMHmVHcU+grnPlea/7WQq9yLfDTY7llfjVjr3H/aCmLxxNjXaGrcRPRwDxbAQBOExgiB6UEkePJM0BMpWLzQtKmvMu7BWplhSwZgxQy3LWHBL0egDL73/8VfwVRn8KaK4gZ4TpjZlRE7PvnXegsHZkcg10EnyCPIh9YQQ8BXWoA3BRdFyOE6bkiozpsYMK5OkCN3m7aaQeoYPp28lPTHPWffSSzqKX953CCMmD7mJpDxvaI+f3/wp6e9UO6bBQMVKzM9f9j4eOR89n5hqMNzcUxZrYABQqL6+8VrDTt5HPqtIyVgpeZ33iuH6puaM9t0g=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(108616005)(966005)(7416002)(70206006)(36860700001)(70586007)(26005)(508600001)(186003)(6916009)(7636003)(54906003)(24736004)(2906002)(356005)(86362001)(316002)(5660300002)(47076005)(8676002)(4326008)(8936002)(82310400003)(336012)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 09:16:32.5759
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f357a35a-017a-4673-33e2-08d998614d5d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2804
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 25 Oct 2021 21:14:17 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.156 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Oct 2021 19:07:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.156-rc1.gz
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

Linux version:	5.4.156-rc1-g392d7d5e7dd0
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
