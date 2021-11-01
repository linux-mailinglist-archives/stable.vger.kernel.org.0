Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174C9441C0D
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 15:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbhKAOCd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 10:02:33 -0400
Received: from mail-bn1nam07on2051.outbound.protection.outlook.com ([40.107.212.51]:52939
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231366AbhKAOCd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 10:02:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g8/hI3INXAdK5ptWuHjx2tx8+rE7FnpRW+1PxbLdc/9v8NTgNlLxEP/4NPlqK871tXXxaqy9iLflKllLJRspbCne3Tr2WF5onITh1WE9WR/qY9X90MvlwrseFEUi7Y8LvDULu8HiYiQcb7VOJ3Z0H348HXstOOGpMxghGvnPNJDm1PhUtnvHa7RTo8i7r9Dv8Jr8n6UZi9lINhk96fYQkt8FP/azahtIEpK1hQEz2a7lfwxUN+Y0tJ0cK7mTxT1RQ5QaFzDFOYRlHeQfVcKQCkZVOkmruSwGdXyM8d85R7lEs2NrU5lN0BwbqUxFcoL667U+ewC0qCm1Sl+6aVMhzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2GrszD2m4xkKbdl4ozbuBFi3hUp5gIob08uSI7e7FVI=;
 b=oQqf9vcOf0zZh/QGQ/U95IFTv/kT2ZXdyPuO3zIC5CLJBHRpCPR827YEwmWd4Hfopc0oWE5Wy6YOcCPlreyqHp40E/gCpmCGPcDUPlfwrjOiuPti9IrcOc5cNdY92oEpYNCVs9sDymdpggxvdX78snLDSYDLmOlBbu3nFyw3Pd5pgrz4kOOOyBaGoFHWGR4OdB3l3GlUNaIujPHoxTQAuyaP+2m92yvE20w8f1LlGkE3UAJWTSgJhWYgz+0rFxv7rrRAvIPgovEy+p0KQ4qNb42A8Xk6Sv5bmC1ZSUvdi12c+dvz1xx7ZgvRXp7YfyB0Y8M3wZ9uEGKpsNM6GSsa7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2GrszD2m4xkKbdl4ozbuBFi3hUp5gIob08uSI7e7FVI=;
 b=a/R7FDfDeQgFEoHIausdKQ1YH05YrIxUFXIexJJhprJgjxXBozne1NSk5w68G8/jVpKOQ1HhZqJhZsDZ0LXnR5z1pRac2Z5SBdQA4ZUtKJAPIc6kAXTPFh+WdXqkP1IEeJQpJjog0oOvhCTETrVpNqy1/6s22jtXmqZbM8i2XvRt+7TibdTOW3i0SM8BSf9bA6QGXzfpY/uF2GMAyMfLZ5BjQEeCiAAgITrM+7Xotu2r2e+8oz0+r1FqvtxdDLL5dziXPwH22I9bSIVv4kJ2seZ72GbxhYN47XyUxBYAnbxjpq3Ncchr/hDHhJ9sN4uS9cz89Kru9YsWi9pG53my4w==
Received: from DM3PR12CA0085.namprd12.prod.outlook.com (2603:10b6:0:57::29) by
 DM6PR12MB4417.namprd12.prod.outlook.com (2603:10b6:5:2a4::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.15; Mon, 1 Nov 2021 13:59:58 +0000
Received: from DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:57:cafe::b9) by DM3PR12CA0085.outlook.office365.com
 (2603:10b6:0:57::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend
 Transport; Mon, 1 Nov 2021 13:59:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT064.mail.protection.outlook.com (10.13.172.234) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Mon, 1 Nov 2021 13:59:57 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 1 Nov
 2021 13:59:57 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Mon, 1 Nov 2021 13:59:57 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/35] 4.19.215-rc2 review
In-Reply-To: <20211101114224.924071362@linuxfoundation.org>
References: <20211101114224.924071362@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <6ff7a3cdaedc473284d36f7d4c3c1979@HQMAIL105.nvidia.com>
Date:   Mon, 1 Nov 2021 13:59:57 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87b2715e-a957-4c48-ddab-08d99d3fe3d0
X-MS-TrafficTypeDiagnostic: DM6PR12MB4417:
X-Microsoft-Antispam-PRVS: <DM6PR12MB441706193B034B5914BBD073D98A9@DM6PR12MB4417.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Ybk1liuU7sA8jOb27gEvnZvOUzZAH/wIbzCQh7nASiKIti05nRYPX2W1YFjcY7doCt1PCo3xx23I2YykcFwPMdw7izVbMJ4c8w5VexWeyxTIvXFkGo4Vp64uvXI9y6mNM13DqVQjUvjh+8KrGUzzFuERyBRm3zo1j9qyLjrNF7chasea8kapbokJr2e2qLmgU5obHBfrW3gEYZeF6ChU7f5GyCaiME9kcMG+3+uwd31PHhNxxGcHoMPfASiVWF45kAmw1EMteYaQQw2Kjw4ToMsuQ3LGGJsqv4deDHRFsRo4jryksiwlFSBA4XUJTa0dAZKt3VDWtow51tipD8P7Mz485tX5YXm7VrwM+KVkPa3Ig7pAxQhMJwJ/RsXOXD0/oG7t3wn0sUVPvyFHLj4KbvEw1ekSD5r2Rm7cjZjjwCgOjMFJ3M50OlXNXBAkQih3wOFn22rTykWpObA4bvO02GtKNX7JPNjKptsvYImxKriKN+rKFV6lAuMFGBOTDE19Jh86+2ugUrA7o1wbSCPfsNqM+wpBCejhUl7gHcEw0imV+i/pL5vCFeY/euFs36zCLdgFcUZln+FkXHU8/POQ20tI1zxSO4BbRotdVQXLYxWMK3VOcWTVlCqOcyh7MS1ybIx6uYxM1C7GNwHEhKo68EOuID4bdvK1+/3sFsEjvUKieLUtPVBA3Vrw3cfx4glpkGuv11zxmw757U7j3toD62cELJemNbTn451jttxhQKt0D3pMjlVmTViHH6t77nFOzjM3jT3Z8HLuHyCLBSzwZyZaRVmxeUc3rUXRx9mBWg=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(186003)(6916009)(966005)(8936002)(24736004)(108616005)(2906002)(508600001)(8676002)(54906003)(336012)(7636003)(86362001)(70206006)(4326008)(426003)(36906005)(26005)(316002)(7416002)(36860700001)(82310400003)(5660300002)(356005)(47076005)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2021 13:59:57.9103
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87b2715e-a957-4c48-ddab-08d99d3fe3d0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4417
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 01 Nov 2021 12:43:41 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.215 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Nov 2021 11:41:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.215-rc2.gz
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

Linux version:	4.19.215-rc2-ga75679fb6ddb
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
