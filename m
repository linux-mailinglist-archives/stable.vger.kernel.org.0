Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B58432DD8
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 08:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233540AbhJSGKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 02:10:53 -0400
Received: from mail-bn8nam08on2070.outbound.protection.outlook.com ([40.107.100.70]:48736
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229742AbhJSGKx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Oct 2021 02:10:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b8SjLHsJtkK47fWpcIrmv4UmFnn2IahhZ0I1EqFcyqAM0svsDJKJvmoNsjPWpgT+c5+nd0BbTv1t75GSZMeo6d0j0p+NaDVMuWLyPwNw7Iv4RfpH8ggVjJSK4Hr45zz8+dKCPayqP4VZP9vUIw7qIksekxL/3YTg1KiKkWPWrZOxxEoHb16gelSpAIWpOIOQKICEhgxJsPwkdoKMsMgOa392pi9JvYFwAKUO64eJpzn0pW9e0UCOBTAq/ImoJJlRInK0ISB+1rwJUSzc4/aVkD+g4C/xnosLLDY4BwIZAovm2umSiEU1pE4k08EEdPq5oXcJXnxbaTySROBY8GaZSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u0A/Dx8AlLiwCchwQ78uGh1ayIbSGwxlIzvqzlKRMyI=;
 b=cEagkXfUpBs94AA4b/hs1qlAT+FDS54o+6IhQ10gnbBKcjeT5esGQCKE5m2o2LrE0cxLVmpA89pH79LfNWjadRO+XD2WjDDO2hpat0q7SbIzpeknrYWy6VZ8L89HE3pHPKWAyKoVRHs0SEtwNdGqjjsqwVdhgs/GDiY21TdoSK461G8VhlUlcXCK3dpuJag7o1Z51sioDzO+83dbVGoUE6tGKaKSmtRQNA8EzkJ+VATfknG6XLsjOpbcJ1784bC3YWZrHB3FjfSKvq6ZeWL/IbKzQxdovCzg4xzaMzfkEzmotp+CWtVxeUPN9k3WuEoSBsSNYalpmJhcEZARArAEMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u0A/Dx8AlLiwCchwQ78uGh1ayIbSGwxlIzvqzlKRMyI=;
 b=aJcxrccnUPEltwZQvjk7at+Jnf5PWgivVbLI+vx6qN6EFTL4bQGvUk+G7YqvqTavOa+oW5XAXnllcaUwFxMmdoBMTupjfQLemF1knTa3sQIEy44alJg8KttGAUWaaOj6XyFhW31ac6zOfui+GqD1Xngukr6NJVaABXKBLLZPFlCOsOEwwDZ95mcVd304SG6hCIf/SEmSJ3bLpDD6EmAnqbWeLrDamN58tf1jyWizLk+56epB0yEmYUoj5ou1cbrL4I8aFT3VJNDB9I9oo30qVn37Tq1SzKWr0I93gNa1Hmj3UydPXmsWb5gHmbz6VcRCqo1Pll9e0FBNvBMiBku5Nw==
Received: from BN8PR04CA0060.namprd04.prod.outlook.com (2603:10b6:408:d4::34)
 by MWHPR12MB1903.namprd12.prod.outlook.com (2603:10b6:300:108::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Tue, 19 Oct
 2021 06:08:38 +0000
Received: from BN8NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:d4:cafe::da) by BN8PR04CA0060.outlook.office365.com
 (2603:10b6:408:d4::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend
 Transport; Tue, 19 Oct 2021 06:08:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT003.mail.protection.outlook.com (10.13.177.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 06:08:38 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 19 Oct
 2021 06:08:36 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 19 Oct 2021 06:08:36 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/68] 5.4.155-rc2 review
In-Reply-To: <20211018143049.664480980@linuxfoundation.org>
References: <20211018143049.664480980@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e43bf13b57044e5bb16118eb4c4143f7@HQMAIL107.nvidia.com>
Date:   Tue, 19 Oct 2021 06:08:36 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 007f40c2-4484-4c0a-f400-08d992c6e47e
X-MS-TrafficTypeDiagnostic: MWHPR12MB1903:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1903FE3417EB0085D22E4835D9BD9@MWHPR12MB1903.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vF9uHddOwD9znnWcgplcJOC5BX8dk3RqI+fzO46/3wrJqUGyWo6wbbAl61GD2E6GPUbyj6BIFD51ZN7JLPctUrvw4Q7F102k9XzLop085uCcbXTFbEK3TEIKaw1zYFRYOuNv9DNfGEgscyqA3Y9PBq5OQeE+Vssc+iKsNPdkii9yYTtvbwzErlkgj/uh0UBPfVsn3B5fnEdx8YDyT+4bMbSuWx6UgZiYthzUlKLUeX88hGGIOqIA1NYf7K5vp88vaMIQYae7Q7n+QTmryDY9PXeHOuLKsvyGF41Av/H47ipQSLp18UU3bhFCRECP62/V14AOrXaufKj8dtLeQQ10M/gzDZpAgGatekSTF2QkA+ATCaeRPUHdMucNTbOLH1K2Li8XxNI6lZkBJ/EDZBb8+jZ+gjBbM0nhss96pDeczpUd1YXwq045yB8umzqxXppY6JDyycptel95/Q75b1/nActBlE9LtggNF+hwBZW4AQtwS3hBwBTTmiWvI7GXyAC5pwfDRGmxpQYNgoInxrRy8Y42FUnDq4efHWTY3YPJoXGH1BujCnYX9mbsMujIMzYEgL3I7XNpPBvWxlAelNMwCjvuPMTSKc5ZVAxvesqeQkfI3vORg8xu0ElWNT46JaoEoEfEI70hXvDBMsoneyP2sDppP+fgWATotUVA7RcHz6Tu51w21yKkR4cwhVh80f7vZj1uHWcqunR+gGxPYdN8fURQeIizPKrQ0AcJQAyUGoMkqA+eQPIWWMHiM/c5O4HRXXLaMBMTPpdlEw5ZR47ZBwt6mDiGQh0mlJSiyqrvWCM=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(7636003)(82310400003)(316002)(966005)(108616005)(4326008)(5660300002)(356005)(6916009)(508600001)(8676002)(24736004)(47076005)(36906005)(86362001)(426003)(36860700001)(7416002)(2906002)(186003)(336012)(8936002)(70586007)(54906003)(26005)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 06:08:38.2681
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 007f40c2-4484-4c0a-f400-08d992c6e47e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1903
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 18 Oct 2021 16:31:04 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.155 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Oct 2021 14:30:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.155-rc2.gz
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
    59 tests:	59 pass, 0 fail

Linux version:	5.4.155-rc2-g35f96c378e36
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
