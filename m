Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30AE1483F71
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 10:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbiADJxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 04:53:18 -0500
Received: from mail-dm6nam10on2050.outbound.protection.outlook.com ([40.107.93.50]:57125
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230308AbiADJxQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jan 2022 04:53:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eXnvlcCtYBq/clR060M21rAOnJdXqtVNGtd6b9Gibx8M+4DnOiM4rY4pUq09OgX07HjHPLQ9PQ5sidrsUJqPtOIYJ04oNFQqEYPf5ky5p9eafesyfu8ddkEr+hxJRNrcLyTbvrwmdA6o5OboaUJM/snzFQwdzE5dGtvC5QRgeAC9nALrks7srn1boPjFTpIMxTp6qSha3wPQZEPxJuSHoQtyJpH4fiMJnLpPUfzrNOMOOsKoJO09uYZrMnsEAlkNDbATp87NpoYMWn0Lp+5B8hAoteR4SBXOWBjnKRiQhsZOL8RolrNRirfpRWmERcyTOlOyduafZTqdGCrMReKUow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CoSVLB04k0yKh+UJ3D4CZikRxTcjQcTGdC/Km9yBT4Q=;
 b=hyHE6WLLidXE7kanXy2pRfnHhiOaSCrerYhKURiftHRanx02H047Yy9REayikstIhueyJOGhlyWWbETmGKI+9wCOen8wisd6Y4cp/vu9/UO8iUl8np7sCNMuJhfEd162r2dT5mGcV6QhI/ezAqhgWbmIXWYpQkfeC3YM8IY5cbnjloKbHV3x0JJ1wSbkFBlfFgONISbSkyJU2AZrPic9vg8s3h0gomJ0CpvY/7dQoBBHSUUS8SEd/uxG6mYna/0NthcL6RcDo9slDC2ghrhDTCD5G0kcZ1RHI5UTyDKTNxNXQ3k4LVoGNVG8bVWMreTZGTgSsU3g+rVyhsiQMU9hGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CoSVLB04k0yKh+UJ3D4CZikRxTcjQcTGdC/Km9yBT4Q=;
 b=LfZL1rx9Zkks/kVCvlUTN6vR4FvAcKF2UNLk2c4LKpC/mM39LLck/sf10pw/T9aL060hjKhwqKElVHLI2pzHuHz2YJZLIy2/Ho67V9XYfLdGcDx8EDI543KqLVHZH/AiHEPXQ40klpW3DZrDX2PAZKeVsZ8t6uXcYVFYwSlvoJaUNQ8Tv28dltMWSVuUbF+SWphGjeMO1Qzawerj3DnwmSICFUi5ZE7kP/AqXOszsFbzQffispk+SzilK5nD6/SRCeBqrV0/dmzjfLaPaJ3dP07LURASXX6sHKQZPaeM8qmJis59u7JEufr1M0OWvu+wXVQTgm0ATrNrmvwsAkuRRg==
Received: from DM6PR07CA0065.namprd07.prod.outlook.com (2603:10b6:5:74::42) by
 MW3PR12MB4571.namprd12.prod.outlook.com (2603:10b6:303:5c::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4844.15; Tue, 4 Jan 2022 09:53:14 +0000
Received: from DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:74:cafe::da) by DM6PR07CA0065.outlook.office365.com
 (2603:10b6:5:74::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.13 via Frontend
 Transport; Tue, 4 Jan 2022 09:53:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT021.mail.protection.outlook.com (10.13.173.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4844.14 via Frontend Transport; Tue, 4 Jan 2022 09:53:14 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 4 Jan
 2022 09:53:13 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 4 Jan
 2022 01:53:12 -0800
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 4 Jan 2022 09:53:12 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.15 00/73] 5.15.13-rc1 review
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <592296fe8a2242c0a3e0da0ab02f9aa9@HQMAIL107.nvidia.com>
Date:   Tue, 4 Jan 2022 09:53:12 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b416b831-4efb-4c80-ce68-08d9cf68067a
X-MS-TrafficTypeDiagnostic: MW3PR12MB4571:EE_
X-Microsoft-Antispam-PRVS: <MW3PR12MB4571D07BA0E1CD9DC026B436D94A9@MW3PR12MB4571.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zjsyghx0EZqI0aTPaAv64Spj/htI6vTTar6vNQu/mMM5HFrS895ubtQ6txM5vW126lxOQjFfadU7ihtHdMXVrNvt0qmFXzXZLuUpjb5h5H3FyFs1o2VsYWrv3v47OfQd1JPc3IJvMdSW0IgMrbXS05xEOcRHEbHpiriqNqKcTC+kDXS38z+k6cVo32EvbW+okp5ygZlQCUPrzuzoNPcnFCwn/gdYUcHMqplM0TcCa2+kQjO4aq6eraarIb4F0nS+xB1lOhFwKRkI3esQQ1kD3P8RT0X8hVzBWlhAEgohO87Dr77QpY7Bg+WSeBWmJ022px7Z+ewlbdkslwU1yuTH6AsILr/Uz3qaKpZbppUNVSkdvF+qBZYo4TtALxvdsVqpm1vBmwfbcnp4rgLcrxk8PsVYMqAL80oJybpHYo5bigQnL86p/fEdyiS9ax6eI861SPna6FABEXQ+fDwpKkMb6xa5pU4iBrlkuyoMiFFRg7i12KjMzSZwb7lV2C8oF2pSlGCZGHzO6Dj+SeTWus659HgJI9LshAqVeNpywGuSfAAfHEJHwaOzCnizwl3cgCBLjIU/+IojKdjXGiJQB3TI+qwab2MGT+N7fL1WdZNAEF7k2uOYFrVkILfO36wit6sclKIC5EzcoY+Q6h5dbi0HOp1Yoz1prJWr1rAgHOaTUsnsqetN0Rz3Ec6hdSiZ+QBJeR6KKpcezKgco+HQM1wbRuMxtaGAE/Gzj/rVgxzfrKgo12uF9eT13N+3Gz/K7c99SyDpqvfsaIlWpZEwjhECn/F4u2J0AnmCbDtKfAt9pj/GwpQg2IZCpcHm2te3liuxz5rwdytOcHj0wlmsnbeFxkkrROzupGkW/HeAJBsp4BkSNBnt8cR3V07KPcNhyljv
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(40470700002)(36840700001)(8936002)(81166007)(2906002)(6916009)(186003)(86362001)(316002)(47076005)(54906003)(336012)(26005)(36860700001)(82310400004)(426003)(356005)(24736004)(5660300002)(508600001)(4326008)(70206006)(40460700001)(108616005)(70586007)(966005)(7416002)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 09:53:14.0489
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b416b831-4efb-4c80-ce68-08d9cf68067a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4571
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 03 Jan 2022 15:23:21 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.13 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Jan 2022 14:20:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    114 tests:	114 pass, 0 fail

Linux version:	5.15.13-rc1-gfbfd9867da50
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
