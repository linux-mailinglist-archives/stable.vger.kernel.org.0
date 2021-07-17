Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1743CC1BB
	for <lists+stable@lfdr.de>; Sat, 17 Jul 2021 09:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbhGQH6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 03:58:50 -0400
Received: from mail-mw2nam12on2077.outbound.protection.outlook.com ([40.107.244.77]:5365
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232967AbhGQH5p (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Jul 2021 03:57:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gLByFXAgKh52Q93/iCxFRF2eMhBr9Mhk9GfdZLqxnJqY1REwdijb8ErDAWerNiYH3BSqGhPPvxaxaxlBeqC1fF+13vGnKTwwwM+K0muW3s8swxyspq6tGZiCZm+xiEjR8f24619s02HkRUGwvnWAbUCOHF5FkGHrsFgaCTN9SOGrgqH050+vgQRlvcVYWt9evZ6vqj5dALEo8MW14hmmLfvB6xLlez+esjSWYIkYmXpQJLdXmCJ1/iTql6opNmD/Q3CqHKca14IJX0fdHh5jYqyrtzoN/2k8TC9p4alWcU8EqWcTLc+80BQ6j9NTynGVl3FC3umHBbJDRcCL6EPaPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oee6rn4iOe6xh21yvXmxBL7Z80TP9fl+e/YFYteFunU=;
 b=IN0q9NcrBynGO4VzQpn5dBEZduWz1I6WSBdyGL/YvWeaPj7tXben+1OieyxoBHsvtbRnTmI/BEuBawrz0zh/ub/XN4BOs4vVq2yo002hlpXZAzHOR+/N2AH1voV1osjbzwt7DMBlmVvw6sY22S4ygc/33w/w7w6B7ji1rWVzdgzUF8NGRhiito5ecDDGeKpnkVcadYJhAeGGSO6bd3s5CATSVO88kdYfO0JRXhvMkvK5TUYreso6eBCXVWfMNT/l49mosjod6NILnQ6QfU8QGWU+f6fJBIfMPNPuYnMWxnJFhfKp0+6tPOrMsEGrbMuxsYWGWFg+ufMX0t7C50mbTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oee6rn4iOe6xh21yvXmxBL7Z80TP9fl+e/YFYteFunU=;
 b=H0m1AgOcf31mnYd1udHa4afv6U1HILhihZJTmGRgbEksU3fym1QLu3Jg52pXvooNjOMhXwSv9nD/TL3tUlrVwCen8WJsdLzKxhaTMZoLZrn3tUvJZ4LeDuEfj0+pS8mxBDy9e9c+rTPLbS7j55Ni0ynBk8s7qM/YcC/wc5InqT+/Y24swrFXfv2DAZDfS0PS+vNdUEFlxDiSUdBU55djgd+6KlrV4AnlQE/O3Hk6skeH1Fo8maxEbVIIr1of1/8RUNhM0sLceZFSGn9Uaf0m65H3Rg8cLkYyKQaydcb5aCyjFYh7KxS6E4s3w/hK2KAgKae7DU/j6/fdttHRHVXR8Q==
Received: from BN0PR04CA0143.namprd04.prod.outlook.com (2603:10b6:408:ed::28)
 by MN2PR12MB3856.namprd12.prod.outlook.com (2603:10b6:208:168::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.26; Sat, 17 Jul
 2021 07:54:47 +0000
Received: from BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ed:cafe::d0) by BN0PR04CA0143.outlook.office365.com
 (2603:10b6:408:ed::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22 via Frontend
 Transport; Sat, 17 Jul 2021 07:54:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT056.mail.protection.outlook.com (10.13.177.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4331.21 via Frontend Transport; Sat, 17 Jul 2021 07:54:46 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 17 Jul
 2021 00:54:46 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Sat, 17 Jul 2021 07:54:46 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/119] 5.4.133-rc2 review
In-Reply-To: <20210716182029.878765454@linuxfoundation.org>
References: <20210716182029.878765454@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <72bd57b5808c480a9fecf7664e1f0463@HQMAIL111.nvidia.com>
Date:   Sat, 17 Jul 2021 07:54:46 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 537c06d3-ff3d-4070-9594-08d948f825b8
X-MS-TrafficTypeDiagnostic: MN2PR12MB3856:
X-Microsoft-Antispam-PRVS: <MN2PR12MB385644292F9F3D96F91CE267D9109@MN2PR12MB3856.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NVP1zcqXw/+M1tUzGWFxhPvPiyRx88dM+g/+T5tNkJsR7CAKB46/9P16DR4kiCWHmOfibRq0miJGRiLiaDLhmZcFezhFapHS5KFq8pjPZzkdKM8WDEk1lvDqqj+00Cd6Rr72HFhYhO7OveDmbPD8yZjwp9UUY9wdEpMXkUSalTny6EA+nUA+AR1Y54gAt3sjlTfzaxCAQVuJqYSxRwz9F107ZORoCqJjHtDHu7R3mFl1v07epcze3XMR6B+1LFGB+rq+v/eKE13kTvthEW/FBa7OtDroj/eaoCPQ5xlPMLbZDXbXqvFvI45YcUCcKyHLUtKFqZXNPCWccXf4PsYaYtTpiGynG34PROv70GgErMfL/BBRXxq5ch/GMq87BSLXOEORp26b4t4PxKwY8j/R3Ocm0G+js7I3JKZu1UQI4Y83iWAbjGgn5aeGbyUESP9dt/ohmEdjMkOcDbBn2MKVBWdYURY8nQQ9hY5HTQKaWPLmk5eJ0cf4sK+y0lruTOo/89fu4DKYtA+ZAlGUvEsPdYjUUeKSg+yKTHwEonGFdu1lXQ+MEdQsK8LJJ4Q8z0u81ZJi74Su7MO0iFzGvJu7UNT/lBWXcpCU//1OeFjVLhepcgH5x0MJDKTx1I+8zZWUeHnmJXJWvxaC4hrIp7M7LtJHMPIWb1DRakwON8MPCS90ikFgiIDURLDfZ/vPM8fL0QSpfBQYTMS3dSj3YYDpNsOMPO8sFFobrsPKs8vrbnzGg5nnmyUUKU+WrzlBa59+UlVySUligcUzjZLvDBvPuv61dWSFANxO8WXemYOJj2TfLX4C1KK2e+tx+WwUJcQh
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(346002)(39850400004)(46966006)(36840700001)(54906003)(5660300002)(336012)(36860700001)(82740400003)(7636003)(2906002)(966005)(86362001)(82310400003)(426003)(356005)(8936002)(34020700004)(478600001)(26005)(70586007)(47076005)(186003)(8676002)(6916009)(70206006)(24736004)(108616005)(4326008)(7416002)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2021 07:54:46.9860
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 537c06d3-ff3d-4070-9594-08d948f825b8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3856
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 16 Jul 2021 20:28:26 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.133 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Jul 2021 18:16:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.133-rc2.gz
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

Linux version:	5.4.133-rc2-g017fed873b8e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
