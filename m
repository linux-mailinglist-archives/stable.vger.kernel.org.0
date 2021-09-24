Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA33417A32
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 19:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345208AbhIXR4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 13:56:39 -0400
Received: from mail-dm6nam11on2057.outbound.protection.outlook.com ([40.107.223.57]:48033
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345150AbhIXR4e (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 13:56:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZEAP6RcEjK3UZC+O8r/fgYf9rBBmAYAL+h3KibIPxQYPkiB8xUzc7i+2eDDZsUIVE7hLd3RJEvLs10LASuaFcviF38SsiYPnM6E0ab9BKgZAXiWR3EuA1SW9c46E69/pAlVJuEr34VzCQcQ13ApLzH/nN/8hrH6FQXOE0ahr+6G+GDZkEKGLUI6R3mahpwZZWGpaYDCKk6YYNmF/gNODmhwCcW9SQzeZ2UxKGfdY5v+4S3mTec92cUb1YO0hlFqY4psu9QhOBaBkpgyw23sat/Gq3QFJGudlu2fImcv9Hp8wXt8voCmfx5S2y8M3/ZDDck0mY/Mou02FrUWE/crPFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=b7Ma8YTWHk/m0YQoKp3NL+Zg0TFBDgBcFiUkjrvwHSg=;
 b=Ha8NcKbzb/J2IasdkpGvcts5iYupINiA/y0KfPcLnaRZuHPh1IzM/NR5Io8qqvV6T+gM/8TEdP3I0N7T2pfsoWJyf0WYaWd+AUgh2frCBwYPoHpc1YF6wInKVTQ24ctE5G68cfc+Jp6F7mwYDBw7y/vsAYbMkZkE4x+n/L95ytCHJC9b97XkrY5HbbGtV81rqQrrCsGToABBVd6xtDvqAszKJUgX5cUYneIQqW8KCuRqcz2Bn8TTE5ny5YWEs1ro8sx/HW4bF7N4RvXbGuMUXECTBSopaUVedy2lcy/NYWO2VtjSJeB4BPreOASi9qssJsKPRGpw1ybp4+TepUEOKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b7Ma8YTWHk/m0YQoKp3NL+Zg0TFBDgBcFiUkjrvwHSg=;
 b=mx5EXaOGq26hSzCw2T5FwB0yno7P9JIW2Rgbei1hUljhiaNgJ38xk8Q3Do7amK9SZJaoXpUgY5uaxh8F1rEL5ZjkHnVJ1U817KpDqnrhP6IePY3qHweVXBF9jzG37XNo99H40ZaNjFqeQgxRMVaDHvgnQU6aAn9pGWbHJcJl/bnK1KUKtAY5Y1vJDe8GLysA7j9Uq+RgCrt5hxl5w106yzyMbuQgjAbtVfGlA9PbT/5q3Uh7QqrvC7VAngQ80Ss4L95QovWOGv+5+OPqG7KzNL7u7tMhXO+hVtlHEcoNpr6XFBuviCFPggbydSJt1iLDRdDf0DqjEya/f35+fRiNyA==
Received: from MW4PR03CA0122.namprd03.prod.outlook.com (2603:10b6:303:8c::7)
 by BL1PR12MB5029.namprd12.prod.outlook.com (2603:10b6:208:310::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Fri, 24 Sep
 2021 17:54:59 +0000
Received: from CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8c:cafe::eb) by MW4PR03CA0122.outlook.office365.com
 (2603:10b6:303:8c::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend
 Transport; Fri, 24 Sep 2021 17:54:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT036.mail.protection.outlook.com (10.13.174.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Fri, 24 Sep 2021 17:54:58 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 24 Sep
 2021 10:54:57 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Fri, 24 Sep 2021 10:54:57 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/34] 4.19.208-rc1 review
In-Reply-To: <20210924124329.965218583@linuxfoundation.org>
References: <20210924124329.965218583@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <2e7f9ecb44924357a4f1e9a773028e2a@HQMAIL109.nvidia.com>
Date:   Fri, 24 Sep 2021 10:54:57 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e7844cf-5666-432b-0e42-08d97f846cbf
X-MS-TrafficTypeDiagnostic: BL1PR12MB5029:
X-Microsoft-Antispam-PRVS: <BL1PR12MB50292BA4ABED1861CD0305FFD9A49@BL1PR12MB5029.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zRGhUDR+ME7cOSrPMlk4KCjmD0t1KbtVUlbcc656BWdlBnehfzSt/hTmSF5g6fNVy5CygqfJOJlSI7MN7gtx6ohrJkCbb3/ZUAYnI7fln6QwQvn0YKsbLy4JlXUH60l7jZ69KYKMaO6fOMb9HHGmhPwbbpOKWhTRrbUcIdGniuiEZK1+Obtca2AEhkzdVdPF4s1Qgjv9l7+x484rOEsW5WY5oQCvttIeXIc4KFrkH9p5d1OB39ZDywXzTT8Wod6bACunWzQ1B28y4U3bBsdvKsVacMpJiiCQ40RJKV/8zGv+oZnHPz9Rwc4u0UeHtE7J4aXwvZ0ADEg6/UFGuuWJAL0WoEsDL6moeUwDygi/uaTD9vjil3KbGPCHJtZdx84Gx1Neys5p0DF0pfZDWBiRbLdyGfbR9I7a3beHV0swBV9oYex9vBMgrZCy/h3SSKEE7wMKY+LxMNz91x8t7+hfieuB4niOEVCyDoBC3o/Xmfl05oiWH78zOWFFqI/YAQRHCV4cwfpUVFzpSVs1eUhFdnuuvjzP46Kzbpcz0MZ1vU3ZJoaXYGPyIR1qjG/wie0l6JrAbwX8NU0HZwpfPr3doHEE2Eq3ReceJ0LeHmyxjuH/YQRnfkbW3d2EOHjCUQ51KCXS5NP4UE8Dxtw7FFY1SLZ4UuQY7tRdbXcf1a7/xak4eG+j/sT400UWZ0jjQxWOBYMtn6xx3zviGgsg58/r8Xxhk/zqbn/okeoFJlaawqvHkFmuhCruBHnuzYhN/g6NdRdgiA6zmMH68KvxaUeKjKC+rgmu5J838cQM5Vv7NI4=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(6916009)(8936002)(36860700001)(108616005)(70586007)(7636003)(356005)(186003)(966005)(24736004)(5660300002)(7416002)(70206006)(8676002)(26005)(4326008)(2906002)(47076005)(508600001)(54906003)(82310400003)(426003)(336012)(86362001)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2021 17:54:58.5367
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e7844cf-5666-432b-0e42-08d97f846cbf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5029
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 24 Sep 2021 14:43:54 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.208 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Sep 2021 12:43:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.208-rc1.gz
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

Linux version:	4.19.208-rc1-g5615a99c7c2d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
