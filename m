Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E6B43AEE9
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 11:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233882AbhJZJWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 05:22:40 -0400
Received: from mail-mw2nam12on2055.outbound.protection.outlook.com ([40.107.244.55]:64570
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231134AbhJZJWj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Oct 2021 05:22:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DDtuw9zqaJe1MLN/MAWN6z43rZMBxSI6MOFaYm8+7DAxFeznblYCNbi8OdOVXNkwTMhgW17OlH5B4XlnTMxBpj2g0ZuqH3OLS1Z5DDfyVkxUnmFxW405KKjJRDASpP+IFEJUQQejvOKq/smmZIT4FG7iqtLPeUjSmsAkyWj2rm3AbW9G7QGH/PDmvNsFJAO6sTSUYMXlfynr/3kxX+K/b+JobHSl+ediNcFV1vgIHhKML4LiOlQkqDz8pVhalLns5VgDJGguMdUy6mPydDfv2fc1uYsSfmyHL84vd61FrUje223Xg4RxvUY4Hb8LE2WEIi+rCiE4vsQo89hAI2sxHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xek+pcin1zcIavZWqg35cPagbWkN83Cs5XGyJ/4lTp4=;
 b=VAYQYjFPpS3pMhtag5JThRpqXDkrsao6vpMHWgltpOyce4nUhQrQ5uxDfTHILhRngv9VutEJzdCT2mKymzAzVDfVZW0zDcTv+xmu7broleTAhWeokNqLtgLQ3ddh2KgQhg4l8cPqHaVPjfkW8/ThhCGcgf9367ZjeYtMoL4Py5CRVRFH1O0YHmpYFodpLFNeXO9vS5yFZe8BiV8qqdLuMa3iS7FdFsEfX/g0uYmsvh3uKx4HWL7q6JA0C7+wCisjb769BfiZaOKI+uumo2oCBdeO8vpGARJAjjDakP8SYXejLowUqdb06u7AvFpzlFI3IjD0stxVyzbWxVNGmDn2QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xek+pcin1zcIavZWqg35cPagbWkN83Cs5XGyJ/4lTp4=;
 b=CPMx+o06eBA/SREQQUY3i/V19jow4LFrO1kUPA1BqzqmmQanIt2mlGAb0x4p+uc8vjWeTt11Mze35nu9Jb4aulkWeuCWjyfkRLTi58Qo9LZnp5FGlsGY9GsX0kziW9RrifXlsE3MVroC6xOo79x6jbUCzHBc8DIR0AycIzOq8dqrrk9OwhQPiMixase3hIobPffUdQaNU/y7vvOP2x1FR/SZITiLAe647kFNtAXaCKPoR58ERGJto6ivcE8RR8/BVR61rmTaPBdxR5W3JD3Sg88G0yfP8I7hyOr+jOTNXj5hMWDuN+vVTOv8yg0D4KSwohe7STDJkdpKSHEmT3LpNA==
Received: from DM5PR21CA0006.namprd21.prod.outlook.com (2603:10b6:3:ac::16) by
 BN8PR12MB3203.namprd12.prod.outlook.com (2603:10b6:408:98::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.20; Tue, 26 Oct 2021 09:20:14 +0000
Received: from DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ac:cafe::4) by DM5PR21CA0006.outlook.office365.com
 (2603:10b6:3:ac::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.2 via Frontend
 Transport; Tue, 26 Oct 2021 09:20:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT017.mail.protection.outlook.com (10.13.172.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 09:20:13 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 09:20:11 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 26 Oct 2021 02:20:11 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/30] 4.14.253-rc1 review
In-Reply-To: <20211025190922.089277904@linuxfoundation.org>
References: <20211025190922.089277904@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <547a1b3815b94fb7ad5406b3a76ce323@HQMAIL109.nvidia.com>
Date:   Tue, 26 Oct 2021 02:20:11 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 918848ab-5a56-47dd-0e3c-08d99861d148
X-MS-TrafficTypeDiagnostic: BN8PR12MB3203:
X-Microsoft-Antispam-PRVS: <BN8PR12MB3203A9914067C74FFAB50FF7D9849@BN8PR12MB3203.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jTWFVHBqFG0uWnRBNXyyxOStAegW/aBJQaMyss2qkJXb80n66jWnSEIPDuHZResdkmRaGnbNHp/GrIonUC8GSmr2PtC3YxHr7HXmrxx9NDJEX+YXf+E+bmzlI2SxsYEJqFRucGA8PO1SBhIib+dYYs5serRGJeQYOwKB8226eP4Yx6Ku0recNxK84k3TpgvqXS63xrxn023vBZyzDdnBmTCKJLnx1W3scri2SQFhdTbPPd74ukj9eSWIICnW1vEP6JqbR1GQXmNjzRSbOXbU4o0AeWytvVqD/FDkBWur6B4IlC2NB77y4OsSPwEi4c9NCkNfWcQrsB4qu1PNGXvABx6pQvQhjwXv4l0ZwSpupiFPUqYPKxnVF1vTNSS+VKATOs0TyKXEen5Zwpf2ppfnbiqq3esQPVXV+D310XFej3e6JgHkkSQVR9EZMeC+tcC2HTtVFN2JBnyuMRey4OZjDBJ11wtkP+Wx6s1i0ucadRJT+Bv+rtfFNZExBpiSVGVRN+hmFNUsg+MXXii01W8VNryYy6YI48yPEBt41IE9lT3WgGKQLEY47xcG+LMBHg78H2UuJce2gcCu3yuEHXTSViSYpg3BKxPfebsOoWR1gK4Yq0Wj0Xmsj4spCXrHVql/DnEYDKpxeYByXhx12mR8Gy7OOIWxmFk0lHrAQtQwijNyGqE3j11DgO+7eAgmAD60XZlecaTuHGTkgcw4iE+zP6+DfaX+0hQ1oaZy8gEVTiF5c0OPuyRao0/lIQB+A7J717FCTK4Kg7cfLx6v13GuTmTbspAMwT48MiZGU0o7CGo=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(108616005)(24736004)(7416002)(86362001)(8676002)(186003)(426003)(82310400003)(5660300002)(54906003)(8936002)(26005)(336012)(966005)(36860700001)(2906002)(47076005)(70206006)(6916009)(70586007)(316002)(508600001)(356005)(7636003)(36906005)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 09:20:13.8326
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 918848ab-5a56-47dd-0e3c-08d99861d148
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3203
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 25 Oct 2021 21:14:20 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.253 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Oct 2021 19:07:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.253-rc1.gz
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

Linux version:	4.14.253-rc1-g5e416f8aa1bf
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
