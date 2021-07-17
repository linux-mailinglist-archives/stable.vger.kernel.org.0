Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A933CC1BF
	for <lists+stable@lfdr.de>; Sat, 17 Jul 2021 10:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbhGQIG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 04:06:56 -0400
Received: from mail-mw2nam10on2058.outbound.protection.outlook.com ([40.107.94.58]:8545
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230419AbhGQIGy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Jul 2021 04:06:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SZOxJQKM96nC42KxhqGJoiD2QK02d2lvy/NNT8eomHuAzTfuevzjvT4aA/c1h54hYGFVgzJTIWQHz9aiBvCr5drE5aQPQx7+lyhVNMCymyLcY07qKhx+Re21D8sPKiAaQcJODPou1MnbAbpnEkzDGReArF2zZUjcu5GPS5fMpWAns9EFG5PIGC2H+Wt4cwyitxwnxlC9Clcm3OAEYwGbfRTVT/9Ol9TPQ+cxoYpJyxw1UEqYMPVGe+w5a9dJRyWwEXZZ//EQawrSgErydYcDzhbNoMqtyC0TwJ48V/SwjQcvi+T1+pf0ufAX6wWKy+yRBEz3eXonqXgw3i36J1pl5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oO9+MbtyiCyBTxtj8G7YSzwK6YNcMOAkORlJxvglTow=;
 b=AOPQJ1H2CQTiL3+K07DNzXRMy9Qy3bYKgdI98UheQQNx4wcs+6fpYWWk2IYYx2ZPc6CIbzQaMdnXDQjp+hpilBdCJAsWm1C2WS8lZ2gPUoW3G23MWvE4wVyUC5Nn3d2k5g7wzd99q7bnNk+dcpx7WohmQchwh5TzD6RWGXx2l85Lsu0pFl6SNdGyNAPp06lGm2I2eBln98LzHDu8r0kNW1TBWeabwN7XjPhEPftfhSWzaObUihdQxgJi0smcBzMuj4/LywqKBL6qQ3cQNu3aBjp62TjsDBzmxjkXgOSJauMxFz9LL1sSSslQ6j7yFUqrId2oSdcZKYLvJTzZ/tjBzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oO9+MbtyiCyBTxtj8G7YSzwK6YNcMOAkORlJxvglTow=;
 b=sOGW7/K51hP1PW15fNaSp/HFMB4BCTiegZ//LaNE6vCCJPbErhJnSb6ABFcY5ooOtclJWB13obQDsl8RqV//YbgJeVTq6wFLtme3xEfr+iWYnSU8yfHSVzFJhBqmDwcctUXw0+DxYJv0MLtogkjLvITK5gsvJrjczdrk5enbtetO4mYg0ScFKUe5ZPlzaTlbzweJjPSZR23TpO0vX9d2IVE9zaPPRLgvvpM70OYZO1xZDE7yfmfskQCazj8CKvxU7ArcL8k6RYZi4dpfNZ47DjLBQ7GeezCEx0fhFYd3tBWT7+5fyndpF/ocXSjoUCELylfb3dJGiZBOrmBLkYY+rQ==
Received: from CO2PR04CA0057.namprd04.prod.outlook.com (2603:10b6:102:1::25)
 by CH2PR12MB3752.namprd12.prod.outlook.com (2603:10b6:610:15::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.26; Sat, 17 Jul
 2021 08:03:54 +0000
Received: from CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:102:1:cafe::69) by CO2PR04CA0057.outlook.office365.com
 (2603:10b6:102:1::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend
 Transport; Sat, 17 Jul 2021 08:03:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT040.mail.protection.outlook.com (10.13.174.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4331.21 via Frontend Transport; Sat, 17 Jul 2021 08:03:53 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 17 Jul
 2021 08:03:52 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Sat, 17 Jul 2021 08:03:52 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/212] 5.10.51-rc2 review
In-Reply-To: <20210716182126.028243738@linuxfoundation.org>
References: <20210716182126.028243738@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <4b54e67fdc9f48c3910b8db85ac53c5f@HQMAIL107.nvidia.com>
Date:   Sat, 17 Jul 2021 08:03:52 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ca7b5fe-4643-4667-6250-08d948f96b59
X-MS-TrafficTypeDiagnostic: CH2PR12MB3752:
X-Microsoft-Antispam-PRVS: <CH2PR12MB37521BCB65321D189428AB00D9109@CH2PR12MB3752.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zHK1o6+uI8x9vzT9CaVQmSyU0Wq9tIwy0fiWcOM2j21t7twuxVrU59UW2aMzemYjVq6+18KPmW8CKJvxZv3sbo19E/3lmPAIjxxhBBrOxlAf+fZ9ZLkZxy6mv0c/2diECtrSOgQsyapzXPjXP3kO+CXFh7aEwA5G3r9UAtatXn/22cUJdW7QM0He4qrOwoSL6JWqvoTLSRu6zSj52iTMEcUfnnw97jGLqqZ6v7qg3GKkgeLwTUU8mbyMPywqF3MUK7J406NqCjgbEFo7ETRMlG7iKrMMEeZsKRGGvSSKZ3A3csh9BmAfVuZs65Ansk/m2sojJI1GSs2u9bnkC1POebMwBqu9irUxcee0ptqXmTGBY5RlYTQR7IMmyLUQWwMyKUti6GpZi2fbQD3s02T0rcycMqIZLQYLEZYI2hUAgBLx+Gwt3Bv5wNS/zuTY2zqmBnMDDVCiwJ4sBABmLgFIPSvXR5zs+MSKtntLXgdtX/GYWQ2FAussX0gvhmSmKlEQpP3NcKp9AkxdCKs0KdFKgvkoadim4zJ0vuQhdvvsvgjW8sfOyimDN2B4TX5RcAtYH5qiG8J5+wWLYAR7pFUgWxtDwldUWwtK/rxeZHPFlVU6bOAcg1Aw8Un8byOi1rXNZ6sOTXgbHlodCipQHflm4BCK8NIqrYwMlggxqcQlqSXTWUNCLLx1XTUUqDJqbiyMVcQBZcVEaDSH2ANgghq4nGnBIKfs4MaJeq66BuwZ4GIuv0XtkYNqEH6loWjSXBhgDjSJBYdA5T3RnWxSnpsIp1bp+A/oiE5NUc/b+7BGPdpnw2Kr0obRlhNHPUszkF+f
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(54906003)(4326008)(6916009)(5660300002)(82310400003)(34020700004)(316002)(36860700001)(36906005)(186003)(86362001)(8676002)(8936002)(966005)(26005)(7636003)(356005)(508600001)(108616005)(24736004)(70586007)(70206006)(47076005)(2906002)(336012)(7416002)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2021 08:03:53.3623
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ca7b5fe-4643-4667-6250-08d948f96b59
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3752
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 16 Jul 2021 20:28:45 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.51 release.
> There are 212 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Jul 2021 18:16:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.51-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    75 tests:	75 pass, 0 fail

Linux version:	5.10.51-rc2-g852cfb3da450
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
