Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22886441C09
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 14:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbhKAOCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 10:02:20 -0400
Received: from mail-dm6nam10on2081.outbound.protection.outlook.com ([40.107.93.81]:30945
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231867AbhKAOCU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 10:02:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mxTDnQmcxceMKcJws4iQRZzNjw9KkhbZzvkKF5kQzUe22yLIESJnlHPYsi/QRV1+t+W/OZCvygoqxqxC8Vn26WKoiRUd2IW0fHT1PABKFdUuzUugDvOlCQUYA/Ty8jPuQotPCP93xy5uo9X5T0h0u4xeR/9JLaJ+CzYsymxCBFCURYliMVM22Oag8hSQau6cFibbnIvDigj1WKSlzv0vTnCWtYDDlpvHktK0Q5tfWZa9jfF/JogJNzNdffJuYooalQDCU5meOhQhrCUBIU/yajhEF7DjuvhRj4mDWYQq8nRcAOkHCBrkJo1yBlRa4VebF+A2n8y75GmBnXnkJGsGFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xuGO1nfyrSF0ypWDXQMWFFViWTAEVCnViP63PIdXyEk=;
 b=M6PdqWNl7NBC3lulVBdpxjcBZJCn516+SE2/aKMAOykBV47dYncn2ObQ9+WimDds5yQobQBa+KOGLzDn36CzVjiLo8BgM4pt5CSqc1UbR91i8lhIS8BOWg0DAERPGJH8lTek1UXnPXC2gsXTimc1agUFZ5NosTkA7u5gCa+a/ufxuGT6SltBW1ES63BLoA6ta9Yb/sXVWwwYOvaj+egn3J2a5froXc8IYjPPGt92JCUkYe/WLCWRbDArKwwuHLHBXITfetTz2wyXv4dm6j7mDsQBS3YP1rPGhuEIk0nMae8MkZTsx8NmX++SOl+kpswCc4d2UyUG8wNJNyOj0cS6wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xuGO1nfyrSF0ypWDXQMWFFViWTAEVCnViP63PIdXyEk=;
 b=eJ7pg1FCNyf2mVj63tiqSpJyNlMbfZbX2EdfBPdpt5ywRS6r1jXM+V6Ie3Ka3SkhJq29MUvKu0T9jyQYlFpoHXzs6+fnFDiDX4DiwLPGNqb9vNz5I/3PdryQUE1R7RNzVLoq+ZIbdaf2y0Uc6skTQq444USoElgx0ZDcrvCW65yp+CTVAFSTFrIHfXHIeQgc1g8hP1I4XdkkCD7zz8BS7EODVFdkdSBu2bEhr0yOnCZBiC7RU+sjiX4Qs8QU3AzyaYzjU22egO+HVdljqG8gfRgazMcKiDEB8q1hKj7j7GtdJ3bCesbve1Oetvf+27edFZEt+ZK695x1n8RxkHuWnA==
Received: from BN6PR1701CA0003.namprd17.prod.outlook.com
 (2603:10b6:405:15::13) by BYAPR12MB3399.namprd12.prod.outlook.com
 (2603:10b6:a03:ad::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Mon, 1 Nov
 2021 13:59:44 +0000
Received: from BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:15:cafe::27) by BN6PR1701CA0003.outlook.office365.com
 (2603:10b6:405:15::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend
 Transport; Mon, 1 Nov 2021 13:59:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT028.mail.protection.outlook.com (10.13.176.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Mon, 1 Nov 2021 13:59:44 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 1 Nov
 2021 06:59:43 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Mon, 1 Nov 2021 13:59:43 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/77] 5.10.77-rc1 review
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <7eac19b88203440fb9110aed3fe582b5@HQMAIL105.nvidia.com>
Date:   Mon, 1 Nov 2021 13:59:43 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fdb387e0-2c49-4025-f6a3-08d99d3fdb93
X-MS-TrafficTypeDiagnostic: BYAPR12MB3399:
X-Microsoft-Antispam-PRVS: <BYAPR12MB3399949F55F2F06270B70AB5D98A9@BYAPR12MB3399.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jUQ4G+NdF23Ozh6e/B7lykFmTKHGUZ64+EfnytDu9WcqXTK5XlQRC3+jGJ/glsVbi4yt9uuxogJ2+G+bPwC79ckeYnqcUsOM4Rd5upjrytT9Mp9rnbQsodKglPM7GZDyvTEhqnaWNPLMC2NMWduydPMTRGv4fZl9x8HlRd4AGNgPqMQ2Cbj6Whkt4y+8yWDsDETkNJrSOGfSTCiFsRrjgOiEOjXQt5cUMz042JKqgqFhy3aQzJzNis4JKGVLeXoPSQ1zdS/jWuVKpbq+RKZ0j6Wps8mWVG0J73uZPLIfyvhmSNImqf7vLUyRBm1WpkKMiD6AJ7tHHFJ4PbkrZrKCF91XMcs1Z38kE/qe7oQWXHkXgkoMIAl2msC3MseO+zwFHh4UYgsgGd0MxVSf7ojcDWjl6wV63UQ6aLcyqyH0K3dKfKjKk4hlrmLpiq4Jq0gHfzIIbiNFA2Jzjq5y0PB+PG3U0SiQXu5gXWYPBYkHi0ycnxevhNWVyLsN7fykGakfU5EgHOHZQfisyJCAUoZhABO7eMdEnpsiMcHlSwM+2YxMYERhZLbX9yNOopMQWtHQyBd4tEDYIXHPUqshCaUiNV+xGyliM86QbB+p0spF3CkBJmfUpHepaDM5eFcjAjiEP0vOiU95Xm7bedFWArboVQZ3E3SO6NuRDxMDOZKBJGoJktmD4Z/A/3Kw5plM5wgNMhjXFmw+1L4iC1O8PB9qO8EUOMT9V4KcxKHf0QaWOrD98bXdQiQvoxEL76FUQXAlkpLjaswTq1lHQPovVRlOHaV/+k/ffluZ/zhMTMNY0/U=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(426003)(70206006)(4326008)(26005)(316002)(86362001)(336012)(7636003)(5660300002)(47076005)(70586007)(356005)(7416002)(36860700001)(82310400003)(8936002)(108616005)(24736004)(6916009)(186003)(966005)(54906003)(2906002)(508600001)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2021 13:59:44.0364
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fdb387e0-2c49-4025-f6a3-08d99d3fdb93
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3399
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 01 Nov 2021 10:16:48 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.77 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Nov 2021 08:24:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.77-rc1.gz
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

Linux version:	5.10.77-rc1-g18363fa5f60b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
