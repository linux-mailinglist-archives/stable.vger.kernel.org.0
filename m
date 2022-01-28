Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFF049F812
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 12:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348110AbiA1LSw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 06:18:52 -0500
Received: from mail-mw2nam12on2051.outbound.protection.outlook.com ([40.107.244.51]:40800
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348078AbiA1LSu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jan 2022 06:18:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LAbF1nKbjZtTX19rIfRYhnoYiR3kF4slYGU/Yeg4ltzoZBf3F7C3w775r5efE5AMeKhhoJQA90OjccKs9XEBVI36WTm0iF7BnAyQK5rxPTnmgpw8IDkMXUOhc1+xmMVXCrRmcjqMNMMRpzTWlud3Rw+TI5YFz0y3TcjffmgQL6Ph5rrmu/+mtfCc72vANNmdsZbxbDDLO5KyhlqyA4g9mFI6s4vFramOoTY0vHEEgzMlbrsEdvMijerp6+/gGdVsw6mGxLoyYolU/6nvY1KE5Dh4leoltmOs1c9YC1B7DVvsdvGxD/uFvjgnMgo8v/Dcas5Bu5GnUL+/RvpoHb0uzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1MulCvkDXYpUfWNCjxqV69DVx1s3my3e+Vhl+a1B1qw=;
 b=I1poDj/ltXwY3/WK5sJRAHCxmDg80ZUCYBdrzu4aRW/gxv6s382u+7T3WkPWvrj9NI2la5tr4rxJEPLQmB0FNP5hTwDWmnEyJ9ykKv2y1RCZNLY/kYS+Cyhu6OBM5B57wu1K4eluDijOLmtnJgirPu8p9UmQay1MUb1OYB8j0JDURO2tqWp0R2t6b/m6cPQKZMY8vTLN3e2/TbiP+QCqTf4x0HoSNG2iOealxepMQEOcb6sMtOQjpq3CsUwFFCuOUu2tEsSKaB79ipuyVw4+td3MmnuLeRzlP6ZN2YV/it6j2ba05BDq+CtCQX79gLESHltuLPxubfEczqExIQ/8yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1MulCvkDXYpUfWNCjxqV69DVx1s3my3e+Vhl+a1B1qw=;
 b=sXo7N6RlcI54UjIgig+ucRLziDhxEuxkC/zGAMeNcffMNsx5VCot6bgtHzrT4RDEsdZEOASIdJB7WNhSej9y4cygAHbaqpd12uQsF2KiZsPJfcropvNuK2WYBft9nCxHDQl9oOqJi7b/84utYu7zRc6mKB4uj1R4MAhDfUBkpw2Z4Jr+iTLSOecbS2sCNDeSsiZPCKBmN+Y3+CklAHaLB3jrAILRy4qmeGlItWB6EaH+91Wrqjv7rElblGGNEfPIQQxedePFX/qGrRvqGK6FhEkL+Clxc6G6Wj1o6LlP3mQ0Lu5ZjZfUfhNtoOsnKaoivK2QMc/agFrnvkqYFQJpPQ==
Received: from DM6PR08CA0019.namprd08.prod.outlook.com (2603:10b6:5:80::32) by
 MN2PR12MB3615.namprd12.prod.outlook.com (2603:10b6:208:c9::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.15; Fri, 28 Jan 2022 11:18:48 +0000
Received: from DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:80:cafe::bc) by DM6PR08CA0019.outlook.office365.com
 (2603:10b6:5:80::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.17 via Frontend
 Transport; Fri, 28 Jan 2022 11:18:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT054.mail.protection.outlook.com (10.13.173.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Fri, 28 Jan 2022 11:18:47 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Fri, 28 Jan 2022 11:18:47 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Fri, 28 Jan 2022 03:18:46 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Fri, 28 Jan 2022 03:18:46 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 0/3] 4.19.227-rc1 review
In-Reply-To: <20220127180256.837257619@linuxfoundation.org>
References: <20220127180256.837257619@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <86a49d25-601f-47cb-b326-aa84f7dbd31b@drhqmail201.nvidia.com>
Date:   Fri, 28 Jan 2022 03:18:46 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83a44f02-96c4-47da-8fea-08d9e24ff441
X-MS-TrafficTypeDiagnostic: MN2PR12MB3615:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3615FC97CDEEC873A9E839A2D9229@MN2PR12MB3615.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aaQo/2p5ovS2JZdMeeZtucesbo6kxbn51Uevs7lmxmrxm9XA4Tw6J0fxpsGB3/GWFOx01IdorfBuBXoiHtZGQhFCeOdQSvwi2noebYKMX8XwBdtY4ufSMys8FLUgubWf9QeiYPsDWoIoJ2+at6fkYGJzxhu+XqDGyvvJJjCf9ZJUyB/GSIwVJvcVXKsGNyJuqLEexaU2QHY8P5FrC8OgR20mkRbvbIKMbP1LHuvdIVXxFM4d8FlNfxzANFUXVJYOnB86eOP2ZBC1uc8TmV7xhtDiZBf4q7QFsAa5mNfs3K13zvfXqvcOS77ND7WcZSnpXZt+bjhDjkUkOvyDaivYFStxYmsJprCO+t3nE9ewnholo852hKcr7xU1CQBcj51nlMexq3+U40/rqFxLv3B5jHZjkZF313NJY1HqY82Zr7/jvEWfW+xG59PUJHRFsli1lDqSuMqk6XQpDzwjG4vByik65LnInvK5OMAj0WiEeZdsaDDN32BRuz01rh++kPbM9OLkajQHF7Qfsv0TEiIkhOiLpmysydAD/VTShILZ2fwj6in35cgUn48gVFYDTZzKUbZTF4E1qtHUNHhSfTnC6ISnS0VgCGon4yxsYs0G81fYgRz0JgMVhTNOZLK9WSiiz9uONa4YRupXW/QMv9IkzHtcJekpsbK3u1jaLqMW90ym3YWAic5IVE2osxD2p9Xiy3c5uhddfhpu2p2xy+lOMrzF4rLM5Ro2yrtZ1UFNbhXSfzwmOQz8vs7drrz3fGLFoO/vLOXDrULn9TW66DYBapzMjhdMgqosgfmgaT9/2Ts=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(5660300002)(336012)(81166007)(426003)(70206006)(4326008)(70586007)(31686004)(186003)(7416002)(8676002)(8936002)(31696002)(40460700003)(2906002)(86362001)(356005)(54906003)(316002)(6916009)(82310400004)(26005)(966005)(47076005)(36860700001)(508600001)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2022 11:18:47.6460
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 83a44f02-96c4-47da-8fea-08d9e24ff441
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3615
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 27 Jan 2022 19:09:00 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.227 release.
> There are 3 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.227-rc1.gz
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

Linux version:	4.19.227-rc1-g0f7abe705832
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
