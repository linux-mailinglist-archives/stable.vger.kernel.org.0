Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E9946B780
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 10:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhLGJkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 04:40:02 -0500
Received: from mail-dm6nam12on2082.outbound.protection.outlook.com ([40.107.243.82]:34112
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229453AbhLGJkC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Dec 2021 04:40:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X75D3dsM97m/iaoNvNvh9NXhFd25xgpaxGlb/m2W8cpv8+HUKZMKeA2buyVJlHCBa9ZAa5u2DlJFJguYTZRSHZFsfqbFXkU5Kvm9YUPCL1G888EwNU6WyKy0QhVSVuJuDzNaRR8MGUSRWb71BhPJ10CPrcEGK8bIoIOpkg6z4qs4x5wGHhGKP+aM+yA7/B2voVS/s+/nPnNvRWZGra5Q9Iy2aJVntEuNROkC0NNftCZTy6lC27Om6G9yJ8kQUBWMAhKIywkZfS3ClhBPaivFfEVnbBHg0N/X7RJL6KsHdZiEsfg2ReEAN70R9ZihDiivGF1k6NJ97JcPmPJCLrGO8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DmA2kicIqV/QXv8vY4MhOc48TdOo+ns9ciVzi134HaM=;
 b=GmnZXvvAuDEnCclQPYA+wMauQcVMS0EjttGv549HYPO23GM6MqtxM7tr7D+kRsJHdMH+ggA4MCipVgVvwrMZ3pRKSqf7UJaRMSvUqLjVUAKXmN/RhFNwzCMnmE2aHO20s8JbCCQlzVBWZi150pIUPToXfqluY9R/6bFrXmvlRayQvfF+UbEsum0Wps6V6Wbj08qBn7RpU6H08RIXojMW1y5P8nwcUGEw7mf+YkkCxRB2kMY2F9vxczQcSihCxRHSiJm1C0fsi3hdVX6qmNuIB6nH9alV3W8DzHMQj2EnPgw/Pl7zWJFCgJ/tCh80qeKnOS6AMrUaAME+pv9pSJC52g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DmA2kicIqV/QXv8vY4MhOc48TdOo+ns9ciVzi134HaM=;
 b=Pv/42u+Elpmf4X/j0BPCx0ihpj3/S9YYS255XwzUA55IMrxHhSTp7zOsM6b/YUhdpxEPGQUhIprSykFSmux/Bx1cjm609tub4gk86WRaqbx2jUh9X9lHcvaMCH5Ukh+WQkcXfb3v7k9dOm97dCarAY5ZFZQTnTTvypjgYvdr08gzngt3gV5eUEvwBRF6tfOKW0mwcefCCAfUDcZPfnnMTXba81WC67AvOJZ1qi+teL6CBWX8PLKrl4e/4yNTOUvuNNIh/KpJEkQH55CROxMv+qsWGIVsqu9ULXFKwKyrJ0tgRn3AKaW1hO5BI1XBfHEgrmRPQixLQWOIIoeww2/yGg==
Received: from DM5PR15CA0046.namprd15.prod.outlook.com (2603:10b6:4:4b::32) by
 BN6PR1201MB2482.namprd12.prod.outlook.com (2603:10b6:404:ac::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Tue, 7 Dec
 2021 09:36:29 +0000
Received: from DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:4b:cafe::a8) by DM5PR15CA0046.outlook.office365.com
 (2603:10b6:4:4b::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend
 Transport; Tue, 7 Dec 2021 09:36:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT025.mail.protection.outlook.com (10.13.172.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Tue, 7 Dec 2021 09:36:29 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 7 Dec
 2021 09:36:28 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 7 Dec 2021 09:36:28 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 000/106] 4.14.257-rc1 review
In-Reply-To: <20211206145555.386095297@linuxfoundation.org>
References: <20211206145555.386095297@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <54937ce9d0f24a3fa23b0712335f6a73@HQMAIL111.nvidia.com>
Date:   Tue, 7 Dec 2021 09:36:28 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45907696-5d5a-437a-ceaf-08d9b9650c14
X-MS-TrafficTypeDiagnostic: BN6PR1201MB2482:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB24827F0D8A81614174C2EE14D96E9@BN6PR1201MB2482.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: og/y90+THJ/5aKoP2Ch36thfHLTbXbaHGZHivU9uJnXRccQYIZi+R5DuAu2YVnleKtIsD/2wEK4jafHp1Z0yIcGAHjoJPat0ZLj4e+Qz6vWRkZ2znSiXmwVckNQpA8euRywdwy3gQShSxEv7udGA94VE+yn0wPDlhLMPzaCnfQBi8QVNes1Cj/VfaBvg40qEeHDrQ1vaasYN8n82Xb3jpCT6qBR+1F8iTtFiDIjAcHnRSCVXMrIK6xEZCwr5//vxXR29mQFIiyeDuWa+D0ppjP3zDHf0079rA8M6LROyhRNrwrgH9CsI1r0m3K+Czgow3Vg6VI13DwKSpanPQ3BbLzenUUVyZ2I5jUBfupXjHWJE1w5ksLOWZCax2XLiG7GCzAuRsAYmbBzYMUguUr4y7X33tb8DJtaI2nbVb2t2K2QcCsjJcD0pua8Srdv6kGm1LEbV87vitRD8G73xH9fkKTeXB7wofM9wtSszryJrPbrlqEi7eX6KrxY5tZjxwLnmeCpu43dqyPJ6vaUWOvdt+WbZpyb+IbtRWvrjblLkbHPJQ0qqCxEq8OxFfjgWY2lmhcJ3s2g4pPKn0Expadwzv4rMUdnspYuAad/+dPQ8MD1/g1+SRwNLoC7Ma+3gFpbzxAAExQTAJuS8V62FBJMczfJTmWKxng0+/eAPFFJV6ZdEd5dY59+s4ZgHcTRpFcNY8QYtTbzlYttBCSuAE/lrP5+Sdz0c6DldkH3uwO478NPcYpt1TuCZSz2MFdCwJerAPmXy3dz/yDIbYDsb2OJsty1gRUftBSB3G0+6V/BMmszxkXLEL/V3k4iUo7BOueO6Xtzfve5/LdH2aqBMXWrjsCgyXpwCW5yOlb4V6UMVt/ebF4NsCpaLnOApja2wEVuA
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(36860700001)(426003)(4326008)(186003)(70206006)(26005)(7636003)(70586007)(316002)(5660300002)(2906002)(508600001)(6916009)(7416002)(356005)(47076005)(54906003)(82310400004)(336012)(8936002)(86362001)(966005)(34070700002)(40460700001)(8676002)(24736004)(108616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 09:36:29.4067
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45907696-5d5a-437a-ceaf-08d9b9650c14
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB2482
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 06 Dec 2021 15:55:08 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.257 release.
> There are 106 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.257-rc1.gz
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

Linux version:	4.14.257-rc1-gbfbeffc30386
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
