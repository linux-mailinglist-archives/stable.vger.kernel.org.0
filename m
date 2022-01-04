Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A0B483F6E
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 10:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbiADJxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 04:53:18 -0500
Received: from mail-bn8nam11on2074.outbound.protection.outlook.com ([40.107.236.74]:31335
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230302AbiADJxQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jan 2022 04:53:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DEOnOVrx1HcL52lRxeUYFAefCvPrDKXGXZfwi+9Y7CRRF7235oGC9Y6Fwo9anEyjgwQo8cscrmm6wH5mS2fggjngPmZKOUFgkRzeWDi902E8uYxLx95oj1tLAzqKy4Ue0QpG+1DYyRo4oAK7/gH15Wwh4UcXaTf3keICUSvwUK+/Szp/EEDIbc9nFqCU8rQlKM2f/GKPhxNvMu1fxEIog429uQAk3es3TakcJ4tsMRNhgY+GfEL8mmE1U3OCB2W+9tPNeHb6AoTRxZrLhrRI5lSMz3KZT1O8U9q7uo31tE9yvmqyZn7W3sKon6fKuZbRsQhRawtm6v01bEJQgoU2zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sqBcW5wJ7epLtVEXPV+bD1mCfjJNc8uuEdGSIRfVuOA=;
 b=nQFjpEV2Jby8X94RmPDcST/3Z9uu4gXuqvaeYWQNYDvQdHb2rPvSvS583Nybj/UPuTzj9ejz3N4ab4/qkWH1I4a46d8f4TUYS5P2TyuFsH9XFLu97XiLFl/F29d3SEpQPsdgCdjD+dXADOeCnrey2h8d3ECVgqdrHHmYT4cOnQHtRlE4fK/wKhlnwJ8jgdqbRqB050A/ii1Dao8cCEd1cHQ2NfLQgeUtJbj7i+C4xguC5y40+GE5sFxsGu4wq354HzpQ9MKVdAJZy0iC8pdwVev6/5WhlEqLleCepbVx7vFQDMC0oQUBOG5OUZQObtKfeJCxq6WNw/PknsyAwkOdxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sqBcW5wJ7epLtVEXPV+bD1mCfjJNc8uuEdGSIRfVuOA=;
 b=U2VSx3kZ8udj5sFeFz+s0kBZ6KlxTdK9nLmaBHUdOOcQilTrdmnpUHC6zGcDveNT9mdvtikI56cvjYRkUAXyRd26h6iueTBM31AscZvgHpOVrJqpGLV6JFlUnIrqKQ4nuudkUgvtt+BT4GchEEqbvtFr6+c1T3OZKJ332CVQEIYZdTc631dylGzk81vMetLTtPx+ilferWbdKHy6xGTNj2nQ3psNtK1DmjGcRl0yL1E3+QiOLmrcUPclUfgIdg6b1OA9Dkewx/91SpZ5kDMKsxwNSIebvfb6LchNA6zxV8o3V2lK99SSsLyEJgCQq5aPlub9EIyZDVU6ObCx6JYTwg==
Received: from DM5PR1401CA0008.namprd14.prod.outlook.com (2603:10b6:4:4a::18)
 by MN2PR12MB2974.namprd12.prod.outlook.com (2603:10b6:208:c1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Tue, 4 Jan
 2022 09:53:09 +0000
Received: from DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:4a:cafe::86) by DM5PR1401CA0008.outlook.office365.com
 (2603:10b6:4:4a::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15 via Frontend
 Transport; Tue, 4 Jan 2022 09:53:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT008.mail.protection.outlook.com (10.13.172.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4844.14 via Frontend Transport; Tue, 4 Jan 2022 09:53:09 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 4 Jan
 2022 09:53:08 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 4 Jan
 2022 09:53:08 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 4 Jan 2022 09:53:08 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/13] 4.9.296-rc1 review
In-Reply-To: <20220103142051.979780231@linuxfoundation.org>
References: <20220103142051.979780231@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <05db48261d344402824635a07c18dc41@HQMAIL111.nvidia.com>
Date:   Tue, 4 Jan 2022 09:53:08 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fdb8f97d-7839-4048-6dc0-08d9cf6803ab
X-MS-TrafficTypeDiagnostic: MN2PR12MB2974:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB2974C6002F620255000C239FD94A9@MN2PR12MB2974.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5OgZGx4Mf17pNRqon6IartogFkQw9EEzMmbg5L88UEr/c/1+aGbH4NTqdKZ1c5YiLmJrbIyFP3kLbaHi3aSUFoaRsBtDmLZlhAi/lDcS5HrS+sTFnT+37SzONIq9giABn29r9GflTJiUi3Y+hGjmg/XGfEwizz4uYZ8MhRbRLxbmj1xvgn2eVnWpbEsybd+P83AXWfGZEwP8wZI0Nmmw/oDU0HdDi/38RCv6JVPHDAv2Vn4Ulxor9BnVKGYxa6O0hs6Qlsy7L+8ZjdoG9D23cxeoCVxXZUu9qddaDIt+azVuAKkO5mLZRWr6n6brGmooiQXzU/QF3+TJQF60hzyGUYg0FEX9E22x5CrfTqlm4ZuJG/q4mu/wy14WpN9im7I61YyTJ8yhm9g+y7w7rARZb3Iu3A/86cYon3bJxrF7OhKAK6NV/8HxIrVj7YwoXxr1k14PoW0zyWtcslGc6rgB5rLd7/HzcvgICGtlyiauRxM+nNDtnCynGAOgmfeGPjyzmxcRR89plUPKhdlT8yx6HLq5HNQCTSqXi+0NZmomOa/5oi3+YjXXy9BL7Rq7Bu1bhTHvpDXvO9tRbIZOL/Twh+UGwUeRr64L3976LUy7kbQO7gvxcFH/aLPIjRAklMjtjCw5q/vp2d64LJFQGR83+KPE6NUF/XU1kgXgI2pnJH6ECtPd2YWOH8saSuOdkRfyiV6dTW3fa+YHsTb8ge47vBjEWDlAkYoaUVv2VoFn4f0BF9tjJPX3k26c0INKDPbQ61Lqmrd889BFH9NqRtWsu/iMSu2MKTc94uwiGW9qcsTrS6CS2xf9aB8q2sWtM2a5dCxXG06H41P2ks6Sy5wHwuH40BJq3XUxed4zFHeEbYBudLtlgHdseiwUorJYl6sh
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(40470700002)(46966006)(24736004)(7416002)(108616005)(36860700001)(82310400004)(40460700001)(86362001)(81166007)(356005)(4326008)(966005)(47076005)(508600001)(26005)(186003)(426003)(8936002)(70586007)(336012)(5660300002)(2906002)(316002)(6916009)(8676002)(70206006)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 09:53:09.1782
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fdb8f97d-7839-4048-6dc0-08d9cf6803ab
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2974
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 03 Jan 2022 15:21:16 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.296 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Jan 2022 14:20:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.296-rc1.gz
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

Linux version:	4.9.296-rc1-gc154c6cb3efd
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
