Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF7646B78A
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 10:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbhLGJkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 04:40:07 -0500
Received: from mail-bn7nam10on2070.outbound.protection.outlook.com ([40.107.92.70]:3282
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229940AbhLGJkH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Dec 2021 04:40:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q4cst7ap2E42GJEVxc0C12i+4lnyJLn7mM4s8FAWktCCjD9cVxv+V2qTWHiQVq8drbKKkmVG5EkCFpqpCQCwgCSRwHXQB0D6KdjNNQak8PoFL0BR+9FUgQabzCHjj9pFyerF3mjiiGa+vZ+jkwKjkDGCx+SBANs2C3udbF692XSwX/Tm36RxLJOOVMZzjvfA9lEPlp8LQ1SrIZ7JnYOfAUNL+tRcJRnYOlBIZpUqEQ7n/d2R8JKB4V718pQxj/d67kkbPHNaQdCMV9fQH+/559/Bro7TXqxHt9Tl+6mey/QWMq8MESAiA3FjYOAzwyYJxRI6I/Qv3Zz6q/XH9cTzmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D+sSXQutEKc2MG4KjY13baIQL3zgTnZeJp/NVRrd9C8=;
 b=bqEqJEjsKl6+FuQuG5g1YJFKuZk578b1rl2E4alfWYuCvG24cVgBHjMzVg18+UBhYL30nJaHI+hWclr2TkTXSwQ/zsIsJnpeTwh32sS9t6cY2Xe+iPpdSi3qTqnY0DXqNmypqU5EvKrpjm9sxlLFva1YpER+HrRjflkleYv2Ak6OZDVI2FPdUUe6BRMyaEgufseUi7/HaswTWQOqEGggM8NePhA7AyV/JBoEuC0fechlcrcGGSxEL19XEamwYmLd0vZ2V0GzoOSEakdWbqrenwfetp6bX3ahreUhfANmtCvgD7g8G1ADTMSYe8bWTGGimydZkJ4QiD0BTSYpI+n93A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D+sSXQutEKc2MG4KjY13baIQL3zgTnZeJp/NVRrd9C8=;
 b=jA92TmatD3tVf+ou5cF4sbJfKbFQQmZPPjT2uUgYrP0GPoKDmiakpdoMS9uPP5ZTq3cZzZ+ZfBVNIfQQ85bra8hJvWA0h/zZ91RpyzYe1mE2kiff5qnYOigukFQ3+Ctav1jryc6Mhs6auF6WG53Jgvw6fr2xlu+3OA0Nv1wFC0dJBaN371IsGegHlJ40ESqBE27PVI3IrctqzYc7vnD5cHOfv2OYVZhwnF2m7mhTK4zghW4NBs4neKxjpOBnvKhYk8rLuXXErif/D3IhCsVDvmLIKOtU/CmQLBMo+cSIKitdwo/lWObdK3+0I6M5WOaJDje0xqRILvyuSZ96axazmA==
Received: from DM5PR16CA0016.namprd16.prod.outlook.com (2603:10b6:3:c0::26) by
 BYAPR12MB3493.namprd12.prod.outlook.com (2603:10b6:a03:dd::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.20; Tue, 7 Dec 2021 09:36:34 +0000
Received: from DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:c0:cafe::8f) by DM5PR16CA0016.outlook.office365.com
 (2603:10b6:3:c0::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend
 Transport; Tue, 7 Dec 2021 09:36:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT068.mail.protection.outlook.com (10.13.173.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Tue, 7 Dec 2021 09:36:33 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 7 Dec
 2021 09:36:33 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 7 Dec 2021 09:36:33 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/52] 4.4.294-rc1 review
In-Reply-To: <20211206145547.892668902@linuxfoundation.org>
References: <20211206145547.892668902@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <522c96c38f724c80a012a522ebce5eb4@HQMAIL101.nvidia.com>
Date:   Tue, 7 Dec 2021 09:36:33 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29e9cb31-bcca-4d0d-aabf-08d9b9650eb9
X-MS-TrafficTypeDiagnostic: BYAPR12MB3493:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB34931EAC40CAF314876C56D4D96E9@BYAPR12MB3493.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g2noGUmmFHslbKVDIp6nmZMEvI3j6PrrcFVaZmXSoB5yHW6CfXJ9BCa15qEZ/B4aLkFxUeKq69KL44usGcy1Xr2gL+vHkfF3PAgPINDuDETzhEMMEhX2MUR7UIjcnhIZm+bxD2+uTqks6Dv/l4g8o9kiSXbWxckvAqlrNyPttZHMrybc3JD3nL+3Rpaw90DIXTHkmFSULYwH7xF30acliIopib4qIKdKkXFJeDd6GWtjaI2Z8ZoRd/bFgy6oVRmx9yqoB0K7E+7SelyAyE4f8MOtA0k/Y4Tqj10A2njwNwYEgwBGz3VqMsU2tk82wVNDF10wrO9hN7yLJFK52Cm7mLGJJOfOcAZ4zN5L2Uy9DgudTMvoHYXxUEsjLELxno++Ld31I9AhkhFJkcqYz7YxfXcS6+4qSgJoUAJZ+Q/Tab79LWlnSSNTXcGPsHq5Pup57Yy/5W+FcMx5T9MH0ZKbyytN8RVERviCnU9lfw4KrESLZbwZeOVY0hebrK3BLU/cBN3J1aH3/yNUDvMF/ILwlKw8iD8502Dqn9CtHNn7+xVAy85diBGva6soHVSBeLacb8s3J5rXKN26y48UN7jo3V1CvKvmPGQjxTIISpCrw7YMMR9NHgn7Yoz0HSq1I5H3ldUjmBQmAIzVHthBAf6ggRt4nAl3je5aXaGsMo8ns+CuIOmPmG+287cwTgQPjOUuGMdkEEsjSbc/ql4l60XLPguA2Lsb5/fTknYjSkeGeDfFmF8Ya27aNHvVnd7McvJ/2M9YEdC9+vDqNdf1KXUyxvn7I/y/MDcyY1UK6MOPwFTRvtfurbHj3Wd99hjdWB0twD0X7zol39h7YwWD3HRNtfXpk7qzVogFTeBKYrGt5D7ew01l8Wi+sLCfnZkeahEv
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(7416002)(508600001)(70586007)(2906002)(966005)(186003)(108616005)(8676002)(24736004)(70206006)(82310400004)(4326008)(36860700001)(26005)(54906003)(426003)(6916009)(5660300002)(356005)(34070700002)(47076005)(7636003)(86362001)(40460700001)(336012)(8936002)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 09:36:33.8426
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29e9cb31-bcca-4d0d-aabf-08d9b9650eb9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3493
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 06 Dec 2021 15:55:44 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.294 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.294-rc1.gz
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

Linux version:	4.4.294-rc1-gf5b0b7aefd9d
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
