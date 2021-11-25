Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4355145D914
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 12:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237852AbhKYLW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 06:22:57 -0500
Received: from mail-dm6nam10on2076.outbound.protection.outlook.com ([40.107.93.76]:63712
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239821AbhKYLUz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 06:20:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gzpVXv0U+vOiVYlNDC8ZM/TfCKlOkdcEbQVd6pN6ZOMHwhZqq2L6kx1rP65qmqY7pgUEIjMLWtYgjCCAsFZuAKrvoHP/RZ8T4i6CDh1IART2rddaZz356cHkWcoUaTzcwyY2Ma01QhG+VyxvDYKhb5Zgr0d2P4YpSqOVwsXy1Y8scGR8yrGT/rl2r7gH7Ci/NYrnGs84M34oayFK6aN/21cMkDDRKw7HRrf5oJU0BrFx82HP7NXwnjbyh5lAS5dvw35khkhGEdf9Y8mWOw4sGdnG9t0yqEWjrGXylmT00OuOBxyQcsjhgI14OIq64IeReMBlgj38Ik4WXsAyC/dWUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MUqR1yvG1ovp8GT9ym6vlBV3MG+unffuO80eNP8iEYM=;
 b=S3ygNwJGDr9bwIPNkGddC0FqnY7lyaHeP7joCovcSnSL3IPoQ6YotVszCbtx1ZtGhmnGYZ0HgfYKMSYr4h0IACr3Ydg2+18SWKl3D0OrMJsfzKR1Y5nbHs8Ss4zh58oswb+epRLAW2XQ4lHNCMloDxeFs5i1VuloO7rWGJdORyFY3/jahBlpgxdZqHMOv7YT7VJUF6krzKB6b/qjFBeNSvedQoj1PH4bCLp47s/r78QkpFRyUXHffTAnN6ArlyakDgHgQCX0RH3PCDuFkNuBllM/DhnZ+SNU/aN5+sFxDFz2MHUjKrtRzdqbBKsAco7qj2qYrvyoaSgibmGYd0vsbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=quarantine pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MUqR1yvG1ovp8GT9ym6vlBV3MG+unffuO80eNP8iEYM=;
 b=MGFBz7mxp6Wn6H3IUrjW73Wyd47oKTQBK6wsVJwQ5lzlQYZo3q39NFFheTcp6wUaSr4UH0vJG141bjQkZpRbfGYe0ejRho3PbDXmGarLs/po/OJuijZ/jYX7hVtmswmwqCQI8eLGo0zh2QfDrX9wQDt/s7LM/FqXNVmdsdaTrVM7hCQO4oEoZmrv5VkSAEWipKCSeX/4NwqXgoisa2X21G6MU0AdEBzDCoe71FX90J3x/rk7cqIH7DVqV9m5b8tRZ7X9jbHyXZSw2EDHjlgrpoIQnWF/M9iwdTljJjfiMZkgq3j5FJ+XWPJBpgWFEYF00f2vMs3g1zmsSqO272vBgA==
Received: from BN0PR04CA0003.namprd04.prod.outlook.com (2603:10b6:408:ee::8)
 by CH2PR12MB4823.namprd12.prod.outlook.com (2603:10b6:610:11::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Thu, 25 Nov
 2021 11:17:42 +0000
Received: from BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ee:cafe::17) by BN0PR04CA0003.outlook.office365.com
 (2603:10b6:408:ee::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22 via Frontend
 Transport; Thu, 25 Nov 2021 11:17:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT059.mail.protection.outlook.com (10.13.177.120) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Thu, 25 Nov 2021 11:17:42 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 25 Nov
 2021 03:17:41 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 25 Nov
 2021 11:17:41 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Thu, 25 Nov 2021 11:17:41 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 000/251] 4.14.256-rc1 review
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <fa33d3432cfe49808231094e6b7e36a3@HQMAIL111.nvidia.com>
Date:   Thu, 25 Nov 2021 11:17:41 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f8d4c18-7206-46c7-25d7-08d9b00532ec
X-MS-TrafficTypeDiagnostic: CH2PR12MB4823:
X-Microsoft-Antispam-PRVS: <CH2PR12MB4823AEAB3023365A74C54B5CD9629@CH2PR12MB4823.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vqojwecae9Hflf7WEcOGNImx0+5Hy9OGkIrd4tR3/1q1AVP5LCl+HnPkoo5IMNjr2B7YcqqP7WnEaE6c/TEZEsfQUQJkDgqYrbLZGVBO30slpagR/Snki6wvho0pd8G0N7ptc48JD5qDBaWdiwZqMKcQEmkgB1zB9vygcb6gHCgpg32W4MAY0pp2tQjduMXA2kB6NuJqPCxysVu3V8027KsACh7eEgZtm4LDEZykiX0sxFqt5UHwgF24i2FxAKt3QJdLHisesx7FktPxcRtvR1k91wjkkJ9ABIv7y9OhLTZbLzj2zKBvICcIce7mOhroucRkHd/L+5BqlavO0/LOQqfsROYEj3DYuT3+LIyHW5S1Dlj42cEuVEbJmyRC+kEZk/grbZFTw19e6isfyWAfjr+DC4bCNd8wZadHW7OutGWXeg+xULNxuOyRzWogkQ+EYS19XWt1Itt9x5ujZhNboXLWrvu7PTTxDP25QwTNw1tFOWcVgnbG1ibsFT+59FjLSN5YorxDAyQhSh1dpRBuIWY2D1tv3xBiwo4OEhCRk9+ypmY1fShW5bAgojZN2lYp7TWozkz4KnDLKZeGqt+XBZUBUL2g5mQI4YptwAs3bvJ+ECvQnTDLw+ttgfW+0QsI++wzp6t1pt9hvX1gPImebkF7Syirh/2CzYKKZ0d1a5VFko+5kNFntTMa1I3h7bOm79Hx4Azd6rNl0+jOuHfai5Y1phyLDhA4ZZYn24+rBEEgpBYs1d1oAQDmPRf+dTUyNYDO7rIkiA0RLS+kcAy8RqsOSuAF48K8Mejb/qGQ/Kc=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(4326008)(70206006)(8936002)(966005)(86362001)(7636003)(336012)(8676002)(5660300002)(186003)(36860700001)(26005)(356005)(70586007)(6916009)(426003)(2906002)(108616005)(82310400004)(316002)(7416002)(24736004)(47076005)(54906003)(508600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 11:17:42.3658
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f8d4c18-7206-46c7-25d7-08d9b00532ec
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4823
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 24 Nov 2021 12:54:02 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.256 release.
> There are 251 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.256-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.14.256-rc1-g520f0138724e
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
