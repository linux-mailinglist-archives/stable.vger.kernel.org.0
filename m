Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D58103CF6EA
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 11:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235929AbhGTIwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 04:52:21 -0400
Received: from mail-mw2nam10on2059.outbound.protection.outlook.com ([40.107.94.59]:31840
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235590AbhGTIv4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Jul 2021 04:51:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mcZouOCs6uXe9dIC0muwCemnSRnS6O1qbzjBMFc8Bl/NqA3b3tZoQ9laVOZ8+Z4uP+MYmmFqRWkHFhNPgswDOmPV9UhqLHx6tcoCrsbXyuMnlnvk/XMlJLe1Ab3mKozvvQHEeBqhTdfCE6Ju+YKP0M+xfpVWfZozs3kXn88HHpIN9MGsS2mtODdlU87jy9PnbMk39RP/Ehc4UfblzBC6cuYYEHbA8N0XsFFe9Cr68CdnvLwcaWpB10hCE7wmzQkvElkc78gDtPZZNGntKvG+ygK7swdEYdlSicvbBcdnJC9vSmgF/gUBArTPpFDlGw1WEc3jU5Hri+g9XT8duRjPtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TwKbKWm0QPwzVt9n7TiFV7lPAx/jK03s7u2P8XksiWg=;
 b=ltIxSPqsD8tRRS03s4uLveS+OecfBBzwxula1KZtXCFzTmcruxOT1PV7pr+SbT9jTJmBTcymL8PzFpEW1MerKSti9BoTtiO297e+4hLCODsI9FyeoqNwqnUWjNGElOAILKAqWuzkkfBnlKwWuIicBu0cg680Lyj6gCpDiPwui2hu5K0/2ASOWwhLAkjC1+3n7M4MAeapLJoaH9CvZyLpNilz2tOtoyu9lrAC/SENBPZTCbXTTdY7hGzw5hIuilvFlA60vrTynw4iaAsguUqYxEkTTWSL+fzyoAXv0iPKa/cNOf5+cthTjS1ZcDXRQ0WhFJ/07Ib5LtXpcIBjbmUk/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TwKbKWm0QPwzVt9n7TiFV7lPAx/jK03s7u2P8XksiWg=;
 b=XwUTko7O0lMxnYXIN6vn72ScDMWD3hggxCvWgkKjs1XoZuMYin7OVHEBXNFl3w9tN8K4kxrbfMYlmIK8g7Jz/EAU1Xc1v/inP4JCKnr5CCi74WSZDCGO7+lcjrZU24j7FExAoL80g8tdiN/S6NWHcpHIUPgsHmIdyh88HUWBfx+5bfGhIlhq0miPaNe37td/L3NdWcPFAZYseXqtBoZIkoV8Flambpvh+AU/r7SeIPszvA6d1ErUMtnppl/LbsaICPU1QtG2EytYfFv61lJH+oACa6WHT+Kuc2LxKiOvRse75Osrrjng0+Ip8CKG8MxMaJ95FTaheY75uwiU3s9a5Q==
Received: from DS7PR03CA0057.namprd03.prod.outlook.com (2603:10b6:5:3b5::32)
 by MWHPR1201MB2559.namprd12.prod.outlook.com (2603:10b6:300:e0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.25; Tue, 20 Jul
 2021 09:32:34 +0000
Received: from DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b5:cafe::27) by DS7PR03CA0057.outlook.office365.com
 (2603:10b6:5:3b5::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend
 Transport; Tue, 20 Jul 2021 09:32:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT017.mail.protection.outlook.com (10.13.172.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4331.21 via Frontend Transport; Tue, 20 Jul 2021 09:32:33 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Jul
 2021 09:32:33 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 20 Jul 2021 02:32:32 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 000/245] 4.9.276-rc1 review
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <ec7e9aead1f14fd48bfe2d8c0a3b947a@HQMAIL109.nvidia.com>
Date:   Tue, 20 Jul 2021 02:32:32 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b435f0a-26ae-450c-3bd8-08d94b614de8
X-MS-TrafficTypeDiagnostic: MWHPR1201MB2559:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB2559C012B545F5BB872FC295D9E29@MWHPR1201MB2559.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VaRyTUdcxJFilU4XwNhnRIts4bdlg+JJ9bQR2ouITlRb9eaVnN9699JH6aRmSVat9xpWrDC/0SZ3+rvlvQjjDpPL+wwlr5mtw8TcTNCowwy9Cp3nmRhOVhIbX9zJMxw5wiUbps2IsnJ06f5/aploQg2Vj0gTN4KxMolIAZw/YBE6EzN78u/QV8euGGXkoBErRxt/9Cv1AbEcVnO2tSvz8k/XpZ5f5kXSa51p3qT7FWF1jsd8ixC5te3iapnOiBLHZkHlDGjybzPmYu8geSmcSuUZ5RtTIG/3QbVMVpuYxpvQBdbTBARea2khQg9DHSSgvRSozCE/Bb0m6R7zk3u3kQUXOPdsPpaz/wlfwh4IRC+JjRA1N18t/5xu5Zp96i0kJRLM9ew1N00/3ylEKrs+u8x+velXs7NzK9dk8wZp7P0gGPuwJTpZ2oIdKeqLFEX1Kf7Ajo6hgrIB2F5xbRxvrsYJ79oafIseIyg1CMvtwaxKnQbZ2NsaGro1Ou0kbBeNiuArNmI9TqnWSvq8cnM4V03KwOLf4VuMvskciKpnT2xacGevk+8V+A5h+lIHhN6EKde6ro0ZCQ4TSWCfrK2cz84Jfqb6RIQh8bsszO9KA+EUCsJsxldvEgVyIctNuEEoVP3XS7wUBBGfYaUK7bF3pfRI0kMwL+31m/pVEC3/x1x71Vs6ik9aqHXNzxgw+Y4Jl/lg0gGTXPNqASqxU4N3tV6lbkZBO07R0VtDQwI3dk/4wQZsEN5sMksK+PirUBkLxc2G28Ct3gmizRyHytvyLu7IsTKKHYpDoJzdWSHYQmQ=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(4326008)(86362001)(7636003)(316002)(70206006)(508600001)(36860700001)(24736004)(8936002)(108616005)(70586007)(54906003)(2906002)(47076005)(5660300002)(26005)(356005)(8676002)(36906005)(966005)(186003)(426003)(336012)(82310400003)(6916009)(7416002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 09:32:33.9532
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b435f0a-26ae-450c-3bd8-08d94b614de8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB2559
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 19 Jul 2021 16:49:02 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.276 release.
> There are 245 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 14:47:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.276-rc1.gz
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

Linux version:	4.9.276-rc1-g04afcb7e33f5
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
