Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542E649F80F
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 12:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348117AbiA1LSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 06:18:24 -0500
Received: from mail-mw2nam12on2059.outbound.protection.outlook.com ([40.107.244.59]:65120
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348130AbiA1LSY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jan 2022 06:18:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lnmG1p3xdgJShd95k5yP9yE9Greuw675EG+UNUiORmmTAYGCPI3z3qEfzdCsyFoj7FqcPk6dCGLCsFciEevTEdQbvWMmz6RoV1tZiFT8pY9FyUgyOVil+wJD9ZaOu2L25kHZNUjXnkA1l7P0lIUjsbPMNdtj1mrPRpWjcXOhdszLAkJEqTmVh3k9Of19PvmFk2UB9w2Pd6r1RUza/CwVNyrRPrccr2n/WqRkESLG2QTO2nC4+T3TriZBy4JYgYK858tBQTINfIRO7KZ0bx9+gqiJEb6ipeauyeltYFHWq2iyBdS/BEW5jrvsE6IxABBmNHCoVy9ZG1/2B3bZJU0RuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yC4/C1ECkRamnFjEaqOrXN1l0Qb3kE7c/x0Z8y8r9jY=;
 b=nPtmLIZBQKd9P8t2v+Q86D7nbdUV0a2wGrSbC2aIWeL/NMfDMCuOh9+FpGSBrKA5McXH169oATl/rKw4f5WVMQWMGNtCrAnsbvG1Dvqh66kDm2fE1bBCTrmFIHns4Wg1TXgTo5q+csNtiPp1dPfU0PbIsGRs78TJGs21umNSJueXKulVkDqMjAripLGc60m04W9gmUoQxiCbfz/qUnhk16th5BW5Nt6Q0/GW8Z3dSe+Ex+EoQCl1oDxRXns12CG3Ipm0/xWWyv16OBHiYstOf4PT3gctMk0EYIw4O2gxZ8N6lrZjnjvDL5eAxgPGkP/BKm6RfDO5+X3XFmXr7ffouA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yC4/C1ECkRamnFjEaqOrXN1l0Qb3kE7c/x0Z8y8r9jY=;
 b=sI/wa2ek55fzs3EeJSSXNMpeqBAsw0vNKRFjLqhfoWgtjOcm0KoKSI+S2lRiNZy92ZR2RqrC17dFuh1TIVL63jKkpD3JuK0Vh0tBpovwdBMcJ7aRuXIxjM46a1x//uGNwNnAIjZhcBKr7bOavUFu4ymbPSfqWCvcSLYoBPlAV0mRIsDWVMk6Z0hLJ2ZpGSB8kne4jKcH6xkSBvfgry+wpkd/iRCHAh/87IwY/Z3B5cPPv0daACwBX9y7GjTW6Cr5AkshhxEy62qv5XMk+WvEsRdIj+yWMu7DoR6/PIqwMdN3R9CyzikyXHSemsJGlEz/pWJWqED/ilBhhMIZhCmjdg==
Received: from DM3PR12CA0092.namprd12.prod.outlook.com (2603:10b6:0:55::12) by
 DM6PR12MB3500.namprd12.prod.outlook.com (2603:10b6:5:11d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.18; Fri, 28 Jan 2022 11:18:22 +0000
Received: from DM6NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:55:cafe::b0) by DM3PR12CA0092.outlook.office365.com
 (2603:10b6:0:55::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15 via Frontend
 Transport; Fri, 28 Jan 2022 11:18:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT061.mail.protection.outlook.com (10.13.173.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Fri, 28 Jan 2022 11:18:21 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Fri, 28 Jan 2022 11:18:20 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Fri, 28 Jan 2022 03:18:20 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Fri, 28 Jan 2022 03:18:20 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 0/2] 4.14.264-rc1 review
In-Reply-To: <20220127180256.764665162@linuxfoundation.org>
References: <20220127180256.764665162@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <fa541ac7-cf03-47bb-b82a-a2274e619c34@drhqmail201.nvidia.com>
Date:   Fri, 28 Jan 2022 03:18:20 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c61af54-e916-485f-cb6b-08d9e24fe489
X-MS-TrafficTypeDiagnostic: DM6PR12MB3500:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3500FF7F197891AB219667DED9229@DM6PR12MB3500.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A67IteRs0k1lS7GMBh9vjsSdZS8J7YxwXGdcl+nYMRcaoN3UPMvZy7HN17hCXA556NYLGCeRwO3anSd0k+neQ/C7OcZNspgRAs2nJnKsDSLM9Ks+O0RS6wNvVyv+R/amMVHZdr1SzOFYQXX6HwnwmYvVu1UPcyKUo3REWtsIoC8QxqbHLC4By8BuwrvEEcoDMr/h3oC5keo6ovcItdmcXeNPI8o1cJnNkuCyw5VMnyyGSE+ir5owdMzZhtiorGtlhWfAovF8L3asGD7W9v3wMvz1n7RXsrqchoqx2rIZy+fb3TbrM7eitwjX6JVSriusMrT0TK/bWAOjlKA3gP3k4EDq9GGqFmlPZIlBG6COxidE+ubMYdmvur5KPpXEa9Ly5Bnyl10KvgSMPGJaVnBQWDE5h2oxF7p1rZ1N0Ygr/fFeVsJLQiBmMb3D4TtWsLp451+6zwfuvUooXMt9g8Mw428UNLwwkoimE5N+1NEmdAViKTnTA+FloZAV/AULZYgwD8JZDXXkQT8FpfP9puzfaWEU0tad6V658041s8yAqAH/qBVwU+vIaONOvNiSaCu7pmSLTgeaIEBTRZE8Yp5ddpfy9bB3izJekoP8lPnFSoX7m62z+im5n8/vk9lbF1KERr4ug+cBEgnBoiL3dGsJ6A9Bp19mv0J94Jya8zOl75JcmecR7JMw3IeoRJxZePJbNTGEVr6B7aGrgz+eIGRTxtFjgkRhHjoVx2eWMYMNo0w0QpQ5rK2GbWVOESmZA3xSquNR/ZSH0MX7eYgrypLKVUdGstiHOsg8MtyQgcndv1w=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(81166007)(70206006)(70586007)(5660300002)(31686004)(8676002)(4326008)(40460700003)(8936002)(356005)(7416002)(47076005)(86362001)(316002)(6916009)(54906003)(36860700001)(426003)(186003)(336012)(26005)(508600001)(2906002)(82310400004)(31696002)(966005)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2022 11:18:21.2759
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c61af54-e916-485f-cb6b-08d9e24fe489
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3500
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 27 Jan 2022 19:08:55 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.264 release.
> There are 2 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.264-rc1.gz
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

Linux version:	4.14.264-rc1-ga816c082cb80
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
