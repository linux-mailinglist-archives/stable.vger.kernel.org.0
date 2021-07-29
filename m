Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD6B3DAAF7
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 20:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhG2Sf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 14:35:26 -0400
Received: from mail-bn8nam08on2046.outbound.protection.outlook.com ([40.107.100.46]:28704
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229921AbhG2SfZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 14:35:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZgTbdXZIoy63X0Aun1zI9+b8ovXOxma4EIHiEMhBrIMFoIIkw9agftZtrilHafGDhdxdw25Lwfkzred3Rrhb9Ep/znf6dRpYiXYfA2Dub9pysDN8VKKdMFKvOrCMJ/RevSPvW8g7HLJHMp/hHXkBWnIcaurHETVas2jZMppUnyQ0MIKW8uRYWCJyJR/2VUMmDOddKm5RDei2w4PayOAKvzFRRBUNGPy5lIQzym+K4vhwzgSnd2dn3gGlw7L3g8biIdTnF6f2yNBvnv/zWUCRl4Fegma5HmbG8smCvjkveMB0D20ujgtRxRgL6jU2xtSTX+Rv2oL/bmi942bJzX0BVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rDvvM4+ThnVbvyofADCo2OUkcvGGBI3SGtiWyXzfAVo=;
 b=SnPdbCF8oPjiN8BznJmhCZ53pJX6F0X0UEwvGxM659ISSDlashcDcrSKddqnYL8+CL+lidXguEgzbYibRVhKTcKxeuAxvogRMQ7Sv4tC+et4vWi535lvf0VnVKwXi5JMXTEPy3sRmFFJh+ZQiOUSUtLiVVcmS+2Y9vpCIlR2XEpJxRUMCl9l9C6E1kyWPULXBqU3qbbh5DRsnxsO98UvJXy3UrMcbYdyM49EALeANo1YNSm3vHGhJrLWgxyiomZBwyr7Sy9ZwjewgMBwmzlWclwmYPlokwEOZKzr9pvXC0ck1N31ZrOWPDT4OncFgNzit4ryyZJPOVea6TAEcVlxMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rDvvM4+ThnVbvyofADCo2OUkcvGGBI3SGtiWyXzfAVo=;
 b=soXO926VcnNK8WZHtS+5McjvO5qqwzz9zJed+kXrmbkKvVJsKLcVp6DzD+DyDzRNKq+b1jZVjQekQf236DiprGOzy8OIjTuV0Gtttq83ZuEdonJTzYzAiBBrbBeESZb8PQNlsh+VRu4iVi0D+maQemIEYL/uUuS3BYPNrA74S0Ll286hEJyTZcfC/xlJjCPDibeNQL/a1uHFHuTtjK6kf2L+B2N4Kd3WH2m4YIV8pTP0P6JtJSLlAb52QZgvy+VKiGkFHQdc3N2CNDuOhh1/OIMK+mRYhyocKNchLhQfh6Nlspn0TUT+2Ub0zJpItaXhf7X/EM28nRahkjnRjWFRTw==
Received: from DM6PR07CA0037.namprd07.prod.outlook.com (2603:10b6:5:74::14) by
 DM8PR12MB5399.namprd12.prod.outlook.com (2603:10b6:8:34::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4373.21; Thu, 29 Jul 2021 18:35:20 +0000
Received: from DM6NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:74:cafe::65) by DM6PR07CA0037.outlook.office365.com
 (2603:10b6:5:74::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend
 Transport; Thu, 29 Jul 2021 18:35:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT065.mail.protection.outlook.com (10.13.172.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4373.18 via Frontend Transport; Thu, 29 Jul 2021 18:35:20 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 29 Jul
 2021 18:35:19 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Thu, 29 Jul 2021 18:35:19 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/17] 4.19.200-rc1 review
In-Reply-To: <20210729135137.260993951@linuxfoundation.org>
References: <20210729135137.260993951@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <ea85a466be2d4537beccac4591330fe6@HQMAIL111.nvidia.com>
Date:   Thu, 29 Jul 2021 18:35:19 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d4e9121-095e-4358-0ae1-08d952bf9ef6
X-MS-TrafficTypeDiagnostic: DM8PR12MB5399:
X-Microsoft-Antispam-PRVS: <DM8PR12MB5399BF77CCC2F203C7E4440AD9EB9@DM8PR12MB5399.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0IfA6SYO3f0kTHc37aVvDD1R4AicG1HTtaEmXGU2BFxhHeVIMtQxScmdEB1xTauR+eWrTaqo3JtwVZzJ5BGJEnEcuBIHul5Ca/ep32jzD+syt2S5bjVtKNKFDpe1/nRTrvB3iYTtcYJSDJnS4R0G8FRsz2QtoekwdJEOJNW+zceBp4nL/HSTEIhBz1gfWnTpbFSqi7zlF7LxWETvgvBTnPqx4pFx+wG1oG4QqTNdU91D7YVUXsUXLFUfD2YcZzsMihpmS18vXViXtu+ZcLoizti50jnjaiehtOQ8v23fQZh9nkhaPYH9azGdf09bTk47SakFboohEQABvnEjqYlRDhSekkDfMoEjap41JmkEjlA/i+oyKDqbpS+xBCCT/szwWbaSsgp9BGEChXckr9WsyRVZgrU14d0eqEzL0srTi7q74jHM97+C7qGcDmGeu2R9z2ISQvBW6zZg2ex6MAH5mTJ6tXZ7Vb1kbKnDPHujOgb/oaAOdiVuF8xsiadlJlwovs4c0Nrm7U6smfFxVjAyHWXouaFjRhzqHY35x6ofNOIjykhRUmUf70tr4FqO1cXgo4sHMHI/3n/W2YMCTsOUkyDCXa3BtTWglwI9DO8oR5M01lI1/049QKyLPMVTVfoNi0J3ltXWdUvih4sg49lnzHyUuj06ifDsjFSaf7BM/SA27qKzAH3JxOmc+iBnrSUycQ2bGdxY44v3UARvia1h3iTI14xigl1/4iFGKF2B+yOGv33tJY9bw1A2YmZP1+rEZnciLo6RS6zywaZ9Vq8aYGM9UskZC+cWzdwbkIqO0Ks=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(36906005)(316002)(36860700001)(54906003)(7636003)(47076005)(4326008)(186003)(426003)(7416002)(6916009)(966005)(70206006)(2906002)(82310400003)(70586007)(8936002)(26005)(508600001)(8676002)(356005)(336012)(24736004)(86362001)(5660300002)(108616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 18:35:20.6822
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d4e9121-095e-4358-0ae1-08d952bf9ef6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5399
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 29 Jul 2021 15:54:01 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.200 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 31 Jul 2021 13:51:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.200-rc1.gz
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

Linux version:	4.19.200-rc1-g3b0f6d777e85
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
