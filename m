Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E7C42A4BE
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 14:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236459AbhJLMoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 08:44:11 -0400
Received: from mail-bn8nam08on2044.outbound.protection.outlook.com ([40.107.100.44]:8645
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236351AbhJLMoI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 08:44:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CTrAEQ+HmoiKjjtWN1l/sw12Dx5kwNaIBuFy2CYObBDZjNO+05tW5egEZziJthlxR/rPqqtyGiCS563SlMEnrOja87pPT8YO9o4wBxRQOry/Txx/6+MqjSx/LUXcFXqIwklb46MwWjZieRqieOkAyJcSbaw77YoOVC9teOeF9GjMit9JxEpVLxZuJOinPDEJgOcywofbjk3HMyYWRkrnMlhVkd6gN4Ru3aKhaRRWhmu2FZE2mjgQQEzewPtqTNimv21Hl+NsjArnMhEOLt6DfLdRup/OHRNIXya2o/y5D2t76DPb/7GfhQD/AbOR7NLtfYQA12onhGDDrOoCASpghw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yvoMPUNEGeIFPFUy01/dVsKN2ryouUC/L58dnid4JhE=;
 b=VBTwsoHysFsFPuvEyV6BwJkdyFvqj4+qj2Cr2efuuD+J/yuBYq37gF2XvUhymoOdYoktXYs2rXlYKo0Cihp1qLCHZvwe2f7RXeQ3RYvQQTJCleVyxaE8WlMrMl2yHiN14bqnFnM6cW+wwNQI4s20aJPUWPo7jNvKVl4eg646d1Ph21HfYtl2RpaUZPaZePjKMqJutCf4iPqn2qg3HPdQwoL3gSCjaMaJ/b/UFfYyd5n4lyMTMAPLiy9n5nPm4Q0faCElb10uDkMak4/3hdFe02uzpQ9KTVYX98jC6sV9Ok518d+TMCoraCKdO3hkqwvjXoDQgQH2Eub+C5jkkkNiMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yvoMPUNEGeIFPFUy01/dVsKN2ryouUC/L58dnid4JhE=;
 b=lbokTzPTZhvjyAQoNb85Qp+ClKvCiS4RHwPGH44shhO4OI0kyhLwf3YagY3xhPzsTvM54MNzkWry795tRWBV1SGL18P+O9RX1aZp5SXHixXJf/GEH+x4QawQIqlLen+P3o/86eRjuB/Oa8HJVRgO+wn6x0mRnGm7ZoocgemIm6Ju6p9F/tMpIAYme81SI5IA0ifvaou+gdqZmKnB5dtaolWGzCyBz3ddYWmgP5lRiIeZC+CG5r2T8E1suJ7ie+0CQcWxgSEXzhUGNrOVHffax0EqufWlFLP1I8ZcGinuhROrPYscY8i86GR5EFGPqGrWwc0I0hyDpIdaS40nnlPoqA==
Received: from BN9PR03CA0661.namprd03.prod.outlook.com (2603:10b6:408:10e::6)
 by CY4PR1201MB0054.namprd12.prod.outlook.com (2603:10b6:910:1a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Tue, 12 Oct
 2021 12:42:05 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10e:cafe::68) by BN9PR03CA0661.outlook.office365.com
 (2603:10b6:408:10e::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend
 Transport; Tue, 12 Oct 2021 12:42:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4587.18 via Frontend Transport; Tue, 12 Oct 2021 12:42:04 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 12 Oct
 2021 12:42:03 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 12 Oct 2021 12:42:03 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/81] 5.10.73-rc3 review
In-Reply-To: <20211012093348.134236881@linuxfoundation.org>
References: <20211012093348.134236881@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <63183653b37d4ddd8ec90fbd0e490388@HQMAIL107.nvidia.com>
Date:   Tue, 12 Oct 2021 12:42:03 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a53c5fb-c3e1-49b9-e641-08d98d7db1dc
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0054:
X-Microsoft-Antispam-PRVS: <CY4PR1201MB005457FAA5DFC36695AAE192D9B69@CY4PR1201MB0054.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cag5V/82XiFMig9oH0S5N4KYMxncI8rx4I9qR6VejNnGLQyV5Vr4fM0kQ82zw1LTSfMcCSOZfI3tP/Zx5Fg/pUMMC+kd4mjdyCeFbgV8w+O8UOYcSJKUVzHJjRLS5s3wlG46PEqq8mGbz/6wOLCXJFrojmIuYxZhtDNweCl6JiWooFM9UKkTm+2Oqz/rr9xUuq9eLTLUvtA+ixW+BQICDyX5pML+OJlAQnjYPWv+m12CJU0n3U6FL+akG5b32GweYrxy+mOpFhaFd28hJ0IZfxJ5nwbyDSjPBT128KVFoqVj92bAW3d+9B6kKPiO4eqZBvRrwFhOxJjXEHMnefjSs/kcuw0vvfmXraXuhrA/xa3ry3tvVhZnVDnMESw4OYnYXcWMMPBtS3CskYEEXWiCLi/y2PXRU8CA3XD3idD76nlPQx0wEFRg0X5rJQz/FPBcVsOls1ZFXF5ePzeH2q5SOx3iKWTpwV2rxFXxpiYPAeaP+vef2pe4iEoQHpD26Ps4L5PyJo3VyYMSF9AcD5Bo8C4djjVrer5IKQO0gfz1hhjQTNJq3GKB4GS9w25Cc1EOZUxud5Bb71VmqqGV+CJ5oo+BloyCQgxzWi42IFwrXi4jij7tl82gpnSl8PcgYNMByQz/8JtXzt8EChqzy2r+FJyYzgRDvbkdH1sEd8A1XMxktJ8fkB6LBDbQp6dioedDtlY4LVB1DM9tbsuWlszttFHSVNLeq8D2dPUMAympFfEk/2c6TdUT/xerFbldVVRJlNDjUnhq/mFSuYyakWA7+ZhXK2v8naLqZJmZVaylQWs=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(7416002)(24736004)(426003)(108616005)(86362001)(316002)(5660300002)(8936002)(70206006)(2906002)(82310400003)(186003)(36860700001)(8676002)(26005)(508600001)(7636003)(356005)(54906003)(70586007)(47076005)(966005)(6916009)(4326008)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 12:42:04.1939
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a53c5fb-c3e1-49b9-e641-08d98d7db1dc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0054
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 12 Oct 2021 11:37:11 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.73 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Oct 2021 09:33:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.73-rc3.gz
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

Linux version:	5.10.73-rc3-g29e0360ee4fc
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
