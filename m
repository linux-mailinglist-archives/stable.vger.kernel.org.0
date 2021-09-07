Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 796D6402C30
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 17:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345457AbhIGPyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 11:54:43 -0400
Received: from mail-dm6nam10on2073.outbound.protection.outlook.com ([40.107.93.73]:12256
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232935AbhIGPym (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Sep 2021 11:54:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cuVcK/9w86fT33QeUasrbY/iqkaNhLTNSDNoBy6Gno3rExgNOvwPMBU+rSEZnIbPiAVUpjZovU688Lcij9N+BOSJhZJtUYNzBSuYDdfnG0W8CwUBTq/qFhn5RitpuKrrrqh9xbOge0r+bfqH0QnF2Wwni0P9efsfFrilbUwoP74FeDYuNjG2uFmu/ki4Ax+uBpN2CK1Lw66zbP8SogDIIUOzMvcpB0i5brSvc89C7+I+y7MqnkmRONHbrBfUjZ6DLXkbFeZv76Yp5OEKAtfwCPh2nYOryUJSB5x7SO9xn7qFngdBCM0OVQ9Xi5HT6u0Nl4eTRcyWkqPBHyamKqn7YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=p5tEHObkrWnIKMoi8zUCwfhsvpFydVrSh8w7dwk6ojo=;
 b=CdFcx5GDCsWhVbDrxv1wbJ32mwvLAAUGh2sWpldbjIm+PGragPND2VCIF1Ohb/0C0U2svBhx0vf96T8s89tWYdIi3YxBzNO470R+ziQvyE+Hz6Zrhak8+CK4QuN7ajo2YGGzLoNC9yh8+1xyhR+YzdAkyfTfMb1WLyJhV99IuEGBan5ZY1x7Z/LGtXxWOvGYgTSzokc2VE6RK76NrGkUufopG+zBYgBOupEDdot0+LN0X5awjRL8czwuNuUA5n2zB0LoUyVrhGSJd5wSpWMCVmpetwBX0emquxAwvMCr2hQiTkQgPD6115o0TaXsQ7BvU8V8pH+bszXKtliK8Cod4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=none pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p5tEHObkrWnIKMoi8zUCwfhsvpFydVrSh8w7dwk6ojo=;
 b=d/5KagAUZoRvcAhmIay+U15VT6TH+jMWM3jbLp5WmEbOX4ccyMYflnrh2Hkk1+dLfvUllOjAqqQGhXyKiJbfx1KUw7bls7yREQ11UxXkAbwNaFMhb5aK5nziLaQLBd979lhXkHMU2pDJ9mJL/lHWuDDAu2YGwb/sJ37l3R0QylBIczGNWxW7cPJ9MLabvYN1owKpZnjx1BDyvxT6kwg+RbyFvtjf+1sSKVfuaYBq5+KSITpHDIbXHwhhqxkEYpsLDDZo38BQaYT4To5PqRRx4OVspDnSins5qIxtbiEZuXjTIkzUdNDdPmOzclwzUW16CmUGK1brETPLMIztaiCatg==
Received: from DM6PR11CA0044.namprd11.prod.outlook.com (2603:10b6:5:14c::21)
 by BN8PR12MB2994.namprd12.prod.outlook.com (2603:10b6:408:42::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 7 Sep
 2021 15:53:32 +0000
Received: from DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:14c:cafe::f) by DM6PR11CA0044.outlook.office365.com
 (2603:10b6:5:14c::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend
 Transport; Tue, 7 Sep 2021 15:53:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT067.mail.protection.outlook.com (10.13.172.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4478.19 via Frontend Transport; Tue, 7 Sep 2021 15:53:31 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 7 Sep
 2021 08:53:30 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 7 Sep
 2021 15:53:29 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 7 Sep 2021 15:53:29 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/29] 5.10.63-rc1 review
In-Reply-To: <20210906125449.756437409@linuxfoundation.org>
References: <20210906125449.756437409@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <0168d6f8f3644f008e36ee8a6bef708f@HQMAIL105.nvidia.com>
Date:   Tue, 7 Sep 2021 15:53:29 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cdd61339-db1a-409c-ebea-08d97217a48b
X-MS-TrafficTypeDiagnostic: BN8PR12MB2994:
X-Microsoft-Antispam-PRVS: <BN8PR12MB299409785AD9A6FEFA3C30CDD9D39@BN8PR12MB2994.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ybRlIa86Z9tu7h40ptOB0c6v/PT2YTa9c1blwdSFflRVWI+3/svKfS/iBd2UkA2RYnkHEwMGze/SoI8Mbmr4rERrShBi5b3a0zdYcgpfb5pMr3flvs+cITZ1l7bkJSU4E3TbsHLOOPeaZtXL75bhtRKHU8+YoeSLzBhaejE0br5B3QbBurzcnEw0rSEYxsr1Xe8bEDByRENpQcR+ZUKC1YGbU/5w2Q+PRVlmq588Ggl30c0dV7epil1MXE2J6ciPijwmfPsI/oX9TvfC495hgoNnqSX2yqotEHRWKSptVIQFHwszWrBcls/gnsM9Hvmeufc+gqtJyNW4VfKx8PKz5DFzJ8iW1Tz8+6Z1Brp5oC7uRr5HHAw1f4uY4AoK36wggxv48qWkYYl5Ee6SdwsYK5AVyDhBHNo9w58w8qqqvq06vEg3XKd2Q2Hpz8qbU9GdsZ9ZfgyrYYrRA/02OSHAemqYjJYN4gpvHwdSXYMiQbEtUO/TxU0dNDNFUyVzYG7zgJQS+r7Co7Vz5Snl/bkZ0ZB0B9e92x6mMjD6zlZW/MN9KjFNw5jigX9r3iLQ7HT5Vk8JLSwekHbSHQh5+4q05UEwO7ZGmU/LjWOzTgcP84sv4Aw5ZvbBBbrtTYzHDoL7K4Ibu4QRNasLjbl4bYBPOGU3GILiSsSW2vHMjMwQU7VlGfCrvK15BHF+p50t7T1oxDmGquBWEuSH/5MxCcZ6yVvyPo0DzSBrm5jcLUqq6T1dtIf1PyVTf3rMSAM6jGvxBhCGFann9uLkoIN/sEvbQpJRYK4AoSqKCOxoqYgse4k=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(186003)(70586007)(86362001)(5660300002)(82310400003)(316002)(8936002)(7416002)(356005)(336012)(24736004)(70206006)(6916009)(36860700001)(108616005)(47076005)(7636003)(508600001)(4326008)(2906002)(54906003)(26005)(966005)(426003)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2021 15:53:31.8984
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cdd61339-db1a-409c-ebea-08d97217a48b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2994
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 06 Sep 2021 14:55:15 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.63 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Sep 2021 12:54:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.63-rc1.gz
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

Linux version:	5.10.63-rc1-g49a2bcaf11be
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
