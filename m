Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 137F43FE2E9
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 21:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344484AbhIATXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 15:23:16 -0400
Received: from mail-dm6nam12on2067.outbound.protection.outlook.com ([40.107.243.67]:22401
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230380AbhIATXP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 15:23:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M8BdA3QsMJq/aeBAexNUHjiCUuKJ+YQ9mQBZN7+fFtNWvT7hGFavgI4Ixd3wZg9/icmSNwfDwQmf7qvt7IpySWgmliDQS1TyJLHeqhOxQiL36zEzqgAEXVfIt58u5IoxT1Yq9O8ZLm1fLJ6Erv8AFMBr2YIMLqJQkP04PstsFn9H4yNZyz3Kmv1pl/7grGRYZrXrqiBhslRAPWlo+TUSPg5/ifhuBK/u62+L1N2gV7M/kuPHwWvyQmDBIy3KlcCqHPY+XmfGRTU/+CHQ4rWN718pDTcL913sCC2mvFy+KNkOBlCcnQepQ963/N2oBKzhXQG8uIAE6qOscksEl+bHSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=CCpP/RqEYaRQdndF3zs2l7GGKpwL+wf5pn0JhfNu87g=;
 b=FPJMBLMfKpnM8WiIBNd18csh4TYVy5xZpuPK0HxQ6rM7WAe9BF22QntKaZhHg0bOLVI4E3zRq8m/MrCg6+3LXkZS+qNxi8MR3VY2RT/nd95EwhOZlAhsY3sCTS65IGlF9tAG9kZt/ALdah+gHnHbOfymtf/npM77gZ7+9/7RW0caQcu9hPwPVS7tSH+hBVdTcS2U2y0+A02qW6g0WrSbJk2IPAEcXiGGJakgZjOiCe5ahf6HJwzc8SYz6YzCaannSLHy3xZwH/LEUEcGWQ8+OV87O57PhkTxLY2aYxUqsmmm+IG11/yqJowFvoSPR/P2hjAMIubBXFGeor1WWtwaQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CCpP/RqEYaRQdndF3zs2l7GGKpwL+wf5pn0JhfNu87g=;
 b=AEpqxNHyE9P5ganGmXnFwgEvaHrU7CyAhcozLLD9ZrRr2sLsrO37q35V0LqjiJh6mTAM0RwfFmFN0LjGWBQDBZLpiT5yqq/M1XI4iOFRgmYWceujZb6cFYw3HrAXcrQJS8AUOTK77ecOeT265LbtZWICspVvwFVfWsI11Pe8QGRiyK8TTRAXg5GM6+Ese13mbpb0eboBbkDUNE8Fg8zvO3mbwzQua8SBPubtZP4qkCs32IgGBMlzP/fZYV6734hhpz9XfWxf5UvCagmo+lccvZh633xXxss8aETAWW4f6kYE0ks+iMa9Hdz91hj9OoL44KdjvUnwd+EVAlRU107XOg==
Received: from BN6PR14CA0001.namprd14.prod.outlook.com (2603:10b6:404:79::11)
 by DM5PR12MB1449.namprd12.prod.outlook.com (2603:10b6:4:10::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Wed, 1 Sep
 2021 19:22:17 +0000
Received: from BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:79:cafe::5d) by BN6PR14CA0001.outlook.office365.com
 (2603:10b6:404:79::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17 via Frontend
 Transport; Wed, 1 Sep 2021 19:22:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT024.mail.protection.outlook.com (10.13.177.38) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4478.19 via Frontend Transport; Wed, 1 Sep 2021 19:22:16 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Sep
 2021 19:22:16 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 1 Sep 2021 19:22:16 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/16] 4.9.282-rc1 review
In-Reply-To: <20210901122248.920548099@linuxfoundation.org>
References: <20210901122248.920548099@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <d1200151fb5a4356bb16499dc05d39a6@HQMAIL107.nvidia.com>
Date:   Wed, 1 Sep 2021 19:22:16 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03208822-dae9-45d1-c919-08d96d7dcf87
X-MS-TrafficTypeDiagnostic: DM5PR12MB1449:
X-Microsoft-Antispam-PRVS: <DM5PR12MB144984F978417270A7A7BCE7D9CD9@DM5PR12MB1449.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EAJq5OAeNjcyAL6QPAC6DcBTGTjvZSCHgDiLgqOCuWIr+BJlNRA71Z5X1uNc9O97LEuUaFlL0PRHs/WMW910j2zVGdWXTKPVmy4yZJ8otkFSHY70TOIkCiTaqQePyTvG9NMlt1tlVE4ymNgNHXubZB0yjhKytLIHrJ4BrHDYlCD8crYvG9/ZsubBIZXVos3jN17m0ouPTYih7l6r38Yxp0cDW3kUJ68l5ZnVct7wYfvkPOHLzKZP/pyMbPVsV77mbFMSEdf9vGLuDMU3hqH8Svg5cvWtMvy8W/0AI9lln+S8UodzR07OM9sit1eQt5YnSzqc+d/uuoiFDJdML+VrXJb0l6gByKchPHgHIFPxnNZsFrqkinMKvT7nw/iFj+3rStW4GyPNkAS0ZbgBllDVxHFlJoajtTM9OEhUdXPd22mXH98vJ+mk3ohSug+AnEylo7JRMmJS906DaHhGcjmD5vDToGCk2kh2MJ1b5uBRnhJmWtA9p9uEUJk3jRuJ4XB3odUvxitx+2pS5hSy0/awyStWPytVQX47+tAp7/5kJCBJaMK9jF2yLAzECBb1ugXYLLMOx8jq5VDt8NNJ40wrPDipkJlLcorn2GwSQQY1Kk8oGjcoSqMb+XvehXSfu35MIpNNGseU8x0q3LLO/MSxaQ/yIh96i9u5yM5Iv66Rh916Bnrtgg7pAzqh+6kmKMMB8HndiFmO+64SETuiSIK4pa824/ExGAhl82/uC48JV8zre2TIso7jcmg9eaBmHWOh4RKtrzDPxaqtZeXtUQke6HuLqTeqgWbfoYdXfF3O7EM=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(36906005)(186003)(86362001)(8676002)(54906003)(316002)(2906002)(26005)(7416002)(4326008)(82310400003)(70586007)(8936002)(47076005)(336012)(5660300002)(508600001)(6916009)(36860700001)(70206006)(966005)(108616005)(426003)(24736004)(7636003)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2021 19:22:16.8048
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 03208822-dae9-45d1-c919-08d96d7dcf87
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1449
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 01 Sep 2021 14:26:26 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.282 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.282-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.9.282-rc1-g8256eac05712
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
