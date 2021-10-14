Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0935D42E156
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 20:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbhJNSed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 14:34:33 -0400
Received: from mail-bn7nam10on2060.outbound.protection.outlook.com ([40.107.92.60]:49761
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231725AbhJNSec (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 14:34:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LKz3D2n9373lckzXziytAvUPix1Pcd954JITVMOuXTl/IFXw3tB2UF2esRb0MV4OB081m0GiHnTdcBfNJNF1wQ1MQpAyKa9L8W+SowQp4bQTO5K9JFNzksIxG0IkxONznT7eZ1qn+lX1kkbUJWrFg5cdKtWgUISL/souI+vzJFm6AGsIaQlX+L6Ggz2yT17b2cplYRRXDG1gp04nGGyGYtf4bCTaHNTjoZI+SJ5qyYA47fZVJkOG05Syd3dj0A+A4rMsZQ0aJcz+zXQLE9rnXoxS+2jeG05ryHCzeFmJt+gDddUfyFE7COzrXp6zIRvzskYYtW4rJUjwMtdCLNRVsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=guCtgWTbmv8gDkOt/8yrlEhd0qAUY6uT+QwWfhzFReY=;
 b=guscKDUagbENsItTKatjb8trBEikIl7gTaPa0yx3+SjmW0+cFTkvuVftR0lZa+RNy2lhSbklB3BlF3/L1K4Y+lNg0pm+mV+yJw7U48bX0jVSWrLzkyzwLXpzZ0X30d3ZMl+liQsrQ2Q9INgsVPFCBitocNojbHd+HCo8yIzr+BCJDN2xpLowapHO9Y8I8cWpRJ6tefWFMxqxWwHHUdA3DTldeAfKVjPcKypHYzWDE3qQdg4od2TVSuUGsitqBzro0jFaL9P9PbgTs+qo1zeuj/Z7QC1gkZ/OWbk8ttKB0UIGiLL2bnwnhG6YLn+BdCksoKoFOlKke4iwmZ9AQ9yLUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=guCtgWTbmv8gDkOt/8yrlEhd0qAUY6uT+QwWfhzFReY=;
 b=G3bVv98qNgwdyKgqzi8dH/Nti7AhyhCpKiSmkAqF4JXjAQdQ6qv3JCvc37hYAvanT6ieZKDpg8tyMb/C0mv0AnsHkitsIqsp2tRJWa0KPb7aPrDBI/acG74cf9WF2ydqehsGqGrIAzraLstsvHfleA+5oE/V1LBFuVhtFcezapuHie0SXFtxk/5q46K/jd9xyWA61UJsPKjASg+MExBQFs2Bfb9JQs9/4ZGX9rdsQ/MXm5ELLGmtsjbabJh1JABKFLC05k8yRJeRD/DnUlUMtYxfp37JvuPU7S/A/y/oWRwLvGGKhsVhDkyt5Y9VHgR79xifXlcXGGzZXUKKMUHFrg==
Received: from DM5PR06CA0080.namprd06.prod.outlook.com (2603:10b6:3:4::18) by
 BN8PR12MB2929.namprd12.prod.outlook.com (2603:10b6:408:9c::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.24; Thu, 14 Oct 2021 18:32:25 +0000
Received: from DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:4:cafe::dc) by DM5PR06CA0080.outlook.office365.com
 (2603:10b6:3:4::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend
 Transport; Thu, 14 Oct 2021 18:32:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT019.mail.protection.outlook.com (10.13.172.172) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Thu, 14 Oct 2021 18:32:24 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 14 Oct
 2021 18:32:23 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Thu, 14 Oct 2021 18:32:23 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/16] 5.4.154-rc1 review
In-Reply-To: <20211014145207.314256898@linuxfoundation.org>
References: <20211014145207.314256898@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e3993405b2bc4027b091c8dac89fb393@HQMAIL107.nvidia.com>
Date:   Thu, 14 Oct 2021 18:32:23 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de7da358-2769-464d-89d3-08d98f40f7d1
X-MS-TrafficTypeDiagnostic: BN8PR12MB2929:
X-Microsoft-Antispam-PRVS: <BN8PR12MB2929906E6A70228914F7468AD9B89@BN8PR12MB2929.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n9/q/vWGBsvnqwCwW7niVq6ZU3JLhapZ2XK1vFZwqnTGcxjPCNj9Z8qobtrQM2ybxaCgg+Jq/NsSGx1A5esyvTyWbxndv1joL3VHWbnGP1cAJEey7y/dy4SER2jbKRcsywhoMGd7gYwXEiStwI6TAtSGUxYJkg2mPA7MxmjQdLKCplOJWkoCdX857MSALh1n07uJrb/KdaA/SXD6mBjqOSwr+31QvtyrYR/VesrKypkH8kAJ3cBxF4jTIfgyxirKuk9DZLJp7Q+p8k279GLch0D7sP2gSyzKQLroi+yRbA5V7FjE4azVoDlbA8bTPfdHJyiwEp3Mn/BoWWG1n+WLGZRnnPmx6bw7Nuav/ZMDxGBgYdgbKD9j9oymbHSpFlMM32kwoj0STB0hhBsOv1ARL8zW/SM5J5o6i3kZKJsawmwk/E1rA/93QNAgGGcDMrRYR7i8cjVcoedahxGakbUCCKWb4YyU1ceiMbbiM+4eG/eBR0GxTzA4WbxwMLBL4DEFPhE7tSsiV4pwXI+W7FLrdcH+z578dIJzpm83SQqw7+D8kKQ5NuMmcs0Fh4FTGazVzCgyJJb4Eiaw4+wXYULkGF2F5MwUM4V4K1a9Ap+UvO/K+U0giLglcQcKsDUEm16bI5C29gNj4rK+GvgvdF4NeGWTF61Dqyfdh4CM0E+sCDg7w+/XM4TIj7zSKS3KK8sz6Zx8VBhVc9T5uQPa9fqesIUzWtHsfOqLhvtjDq80k/YZybYUagMhfpVcjFovDXTVYGdgV3n18Z9zff9saXPNuBzI8t9F+Tj4RN1eoidRZGY=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(5660300002)(6916009)(70586007)(47076005)(8676002)(426003)(7416002)(966005)(70206006)(4326008)(54906003)(186003)(26005)(82310400003)(8936002)(36860700001)(7636003)(356005)(2906002)(336012)(108616005)(24736004)(508600001)(316002)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 18:32:24.7019
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de7da358-2769-464d-89d3-08d98f40f7d1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2929
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 14 Oct 2021 16:54:03 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.154 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.154-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    55 tests:	55 pass, 0 fail

Linux version:	5.4.154-rc1-g8f48de738cda
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
