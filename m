Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63394426DEA
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 17:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243308AbhJHPpz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 11:45:55 -0400
Received: from mail-dm6nam10on2076.outbound.protection.outlook.com ([40.107.93.76]:44001
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243149AbhJHPpd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 11:45:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IE60ik0Gq3xZgWapfBPb+NWErl1d1Pv0OEPiI1iTJiPC8D7RzLwy6nPpuI1V64aNQzZNCnCRWzUOwOyxEzsMO2QLWTfu9zEDGhnk/YAvEm5k6icPGvj6C+DfHCrN25+mjXrKFRecComgxj8iMPKhYR9rG0IxJok0GCtB41D5zc7VSLTKlyvIUapaWUjE5hbj5HZrGPKZeXM9uCVQX2o4WBIAwy+f8REaLr4GGpWg6jhA72+N9/vdifGuytlsjqlxLBzfp7DRwBeKq3t0bxGdMwYrN5pp6SuemCcA3NlGZRxLdC4Yl06ejwkaezJeHFqWaNKYyNjajmFNq4Aq3GKpWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=geuBSpQ7zYEjOn7HT1KJgZzdIXIvr2oYG38wdtAU7ac=;
 b=oSJQJ9sAXK0vqrZdCn6ZksxRpVItD0R1emtGI1aS6qG064TSubssMQv8JVhFDOM6GUudngvfWDqyXAwdr3gtO4TlF03fqQUCE1f0ET2q2UUkCOTFpAcNbpBqJr4HtR5/RI1Trl6qVC80Avn5yomw3Feoffcm4DeWqCA9GML+VZupRtBC3UgZdVLo7V6lISJM6vOtzG87lsFHwP/qkoh+ZbyLbaqcuRf18bsa6g4bkz4FqXqa9b7hngTK9qtl9bhoXkB7A3s8JBYlFHycX7SMEndFfrADyNbz8UA3QgLi4Xn/INci21VfWn3s0HC3zlCuXdG1WnBOBvfRvrGIfPOZsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=none pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=geuBSpQ7zYEjOn7HT1KJgZzdIXIvr2oYG38wdtAU7ac=;
 b=OhUGwmp0vX3RC7lNAiWN4I6CncKSvQG1FMUJQYPtKxaniKrWkrPkP2NgcNQQdUWr21ljtsCdI8YG9YlBv65EdBjlW3H5Dk56dj3dPrhiDy7dVWgr1+eptsvJdemAK83nvWKS9II741UYacCLfJdDpa4FS3B727q05pzfh11x/Gl1h+eXFkysCaYJJMNLr09D6NEw6xjfwmeYasZVUswMVdByvoQ67w1HOJfsnU2b9Zr2uNKGd7nfThNPZXVDK+5shKSNFV4IzD53R9bPFwzZMvFpBz6CJF4oDqL/7eHHp7pOjH3BzSLvne/j+saCu6+oa51Vd4ml4Bo7CdzueqL69Q==
Received: from DS7PR03CA0274.namprd03.prod.outlook.com (2603:10b6:5:3ad::9) by
 BY5PR12MB4920.namprd12.prod.outlook.com (2603:10b6:a03:1d3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Fri, 8 Oct
 2021 15:43:35 +0000
Received: from DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::86) by DS7PR03CA0274.outlook.office365.com
 (2603:10b6:5:3ad::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22 via Frontend
 Transport; Fri, 8 Oct 2021 15:43:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT045.mail.protection.outlook.com (10.13.173.123) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4587.18 via Frontend Transport; Fri, 8 Oct 2021 15:43:35 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 8 Oct
 2021 15:43:34 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 8 Oct
 2021 15:43:34 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Fri, 8 Oct 2021 15:43:34 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 0/7] 4.4.288-rc1 review
In-Reply-To: <20211008112713.515980393@linuxfoundation.org>
References: <20211008112713.515980393@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <6ddb2b2da77846fb855c9e0f54495a03@HQMAIL111.nvidia.com>
Date:   Fri, 8 Oct 2021 15:43:34 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7eafb1bd-9185-4e99-f0fe-08d98a7263b0
X-MS-TrafficTypeDiagnostic: BY5PR12MB4920:
X-Microsoft-Antispam-PRVS: <BY5PR12MB4920B5592ABA53BFD347C7B0D9B29@BY5PR12MB4920.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RKsyFQT0C7xVQT8aGS6d+0+k1DS3JP088dXI4enJxsJeU/qm17e9BRnnaXG8TPPIrFwDCDjs7X/AOZPkAV7at7vmsiUs1X/Cz1zwUiiFGuAlXgIdsLttJdFJO5A63MMJWGRazuqggncFePlyfiPq5ucWqE2xVj9X+PQQtrL877Dp8JLBKpgOu0v5TUnbkdaCDjsG+YJ2SsKfcQ9s6h4agudzagLDlqiX5IBuGokB339Xv9dKHlwlg+/bGLS39h78jWIE3qig5ATtybgjBuXgPUHHf3SClVE+0/RmV+bq/V4vGQeFv5Pa9MPs6NjBbFpZjodTmsbmZtT4ruK0wSfHfAwlwRaJNPc1JBRZ47g0dlhnwkRfC4sM6jAhW6cZahF/xrN0YIx61afVwy9IG0Jvp9vp545kE9xBPttArdD34khQ35GBedp1sKONaqpoYpGNw91DCkiD1VWzlgKh6Wms2m1vJNIdZnEI+90LGZyDtTAV9CZg1EOsHjIGxH27CXWiNk2ZV8Q+gWPfnp/+nSQA4l8PnSX9sDktcqSkjPwCUtkC5LmpW3xeA9drAxdo/WzUchBvCHywg7TWVuA0Sohu/tV17deCMX81z/0o/KehxQjg13EQPMJxw+N7TYnyLoGRb9N4b4XZPhP4pWc3ad788HAiZff1w9Js6+093fkCD8eh11tLEzbkT3sukZ8z3yKmUDGrpBgaElNxqgXx176Mk7PjRVCeswLN3msbI96Q6keXu+HnqzHkYxbAc/aagqmP5uuW5eEFKTmnIHcGQjbZIaEPjJHWNhONyawY7sPaAuM=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(316002)(426003)(6916009)(36860700001)(2906002)(5660300002)(82310400003)(4326008)(86362001)(7416002)(54906003)(186003)(108616005)(8676002)(356005)(26005)(7636003)(24736004)(966005)(70586007)(508600001)(70206006)(336012)(8936002)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 15:43:35.1991
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eafb1bd-9185-4e99-f0fe-08d98a7263b0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4920
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 08 Oct 2021 13:27:32 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.288 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.288-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.4.288-rc1-gc9a8123a0640
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
