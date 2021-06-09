Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D453A1048
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 12:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238049AbhFIJjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 05:39:00 -0400
Received: from mail-mw2nam12on2065.outbound.protection.outlook.com ([40.107.244.65]:61089
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238044AbhFIJi7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 05:38:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kzM6wVUEsr2gFmXFCdu68e2WbC7qTq/Xw5hIih8EnZsQ1VavBOf6/bQc+J9RJYex0XYg9d93D8zC1p62x0r1LJtFcBIfeXjwfSNIJvvmXTKYxMN+zLi7Sx4OiaxUfdo7ixazvAAMaK3Tf58pKl2Po+o9e9sHtkCexfcch6MgrGLFUnmGaiGX/PGmNLpuoqdIRCD55NzESAjlLgIS1sZeb+tb6KS9BifU69dDM9fM/Uccg+bAPWyl/v4Hip3WzEhWp1ZlL0mSQjPoHNXlIXdch6MKg37ChzJ/wVmuhrQ8wmaMEQtUgEVToZOfoWlZdNoZzoOJn5DYpMhwWPYgcXan0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vG5K6qd41Q4EsrhR4kmXk+SxNUkBE4YkoNVc9pC0N08=;
 b=SN55KVyGjY4jaq89ZeaDILwBY5sRUkRkJNBRe21sAVovtlSr/3Hv9BDiAMci2jtEVSAtx5HWlF/M8BR3ZwelO0YK2rsc9mMPwSLGZ0HPjcEuFhNde+hysw+9F+WeLezH2avzQphnhGSwECKStb35/Euuv+s03K1rb4VdlnWoKer5Gtc1ESBhLjzF+mn0NcXHut8aBuT0Az8PnfM3ylodkNfqWEPJl2E7YKVfghsJci+eKT13KeQjfeXJz/fY9rtJJmFZMCN55YTSOLV2xeN0lWYe32TVQT48rWDrD1uHV4aSJkii8njMuLhrT5PDcLtXyn5M8PEQRricXVbFsBfX2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vG5K6qd41Q4EsrhR4kmXk+SxNUkBE4YkoNVc9pC0N08=;
 b=qxPvCLo81TZJIY8uNjWxQB7J5MU/+XRDn519V7DrVn4F3cxIwA1SXkqPepPKVWv1xT6rVHvYKpFAnGA65KNbrl+aOQV+snPcA2xgCKcKqOXBnYDqjequdfhWSI6vvcjpEPoBAXheF1Cei+xNWEVNtRi5tyHm3NcyW9eQjXu0AcqUJ0Hav1haqh86PJH9bEZFCeAOw2OQFICm5hGSOtJN4MKjQbOkUGfFZfGiyf01lIksyN/d7SWDMPX7PdxSFp5eNvwQ6sydqxl2pyHNpGA66CCyeqgg4+gaUYkGMvfI0lq8Wpq1p0Za/pAEaFAVfjMVjlZl+mGagwI/u50e2pjQew==
Received: from MW3PR05CA0028.namprd05.prod.outlook.com (2603:10b6:303:2b::33)
 by DM5PR12MB1211.namprd12.prod.outlook.com (2603:10b6:3:79::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.27; Wed, 9 Jun
 2021 09:34:00 +0000
Received: from CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2b:cafe::3e) by MW3PR05CA0028.outlook.office365.com
 (2603:10b6:303:2b::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend
 Transport; Wed, 9 Jun 2021 09:34:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT043.mail.protection.outlook.com (10.13.174.193) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 09:34:00 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 9 Jun
 2021 09:33:57 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 9 Jun
 2021 09:33:57 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 9 Jun 2021 09:33:57 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/137] 5.10.43-rc1 review
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <7a4dc36eb70a4672b28f54a8f2197d3d@HQMAIL107.nvidia.com>
Date:   Wed, 9 Jun 2021 09:33:57 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8437a789-77a4-44b4-92b0-08d92b29b69d
X-MS-TrafficTypeDiagnostic: DM5PR12MB1211:
X-Microsoft-Antispam-PRVS: <DM5PR12MB12112254D7469FD68BF5B58FD9369@DM5PR12MB1211.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j8kNCl+YHfNxne9eG58vhJoDhI4sxNrQMEUbLiSm8yYHBXUGV9C0n5KseEJNPvMw5MuSRbivtdw9FnNw0MhPlMmPQDD2OzjB9cuYEunGFVUpKEmToectKqFGzGdjW+5d6C2+Wfro/WFGfiFb1OBS0PB1+lAIawVbjIw+x0KZ6kH61iMoT+ff8+ZvG8w7EUULQe1ka2I8pSX2hhLZMwO3NhwkuT8zeKX8YuaFiT4Juae/4UqIKFnHRWwPWhqbt2UtirLRldl8bTt2xijgKv3IB7DQnh4ONKBrH5wIRUsLqgAf0MLeaH31uRT3SwWcFRMXOhTjTTafgFhtegYuRT+B1hhOTgaoawINUJjmXH+eTVi00V2gD1AMtrl9BY7dsgpQcYthbLIef2y5SI3vX3wXtx3qSPKrXuu54tL97wvhRzb9Ky14TGR+uESWpVcQiKx4ie8aCd3hAzen2yCUnVpdCZ0/8G/x1Df5pRH0ih32eFfpkygoYbBgLyP+oxrgyG4Zi+csikqW42RwuUuIG+f2mjOtmxhOlhaigafKhyYJ/MDo5P9CtSx7gcyVQlF0h8mFgKDSlhUfe9F6ZERyjhCkekNprnbfkvQqG1oy3xT6Cf5aj6pwT2RmuGWpZnbS9bG3inoA5cdpAsQ11gsIt65qyvAO1hIVeXbXYPv0NvvE6YF8oDR7hREi1quGBLm4fb8JhShyB4lU7by+6R9n/xq8KBs+huj0+v+yGCIaaMAksPRSXE15/ZYIi7uexwWAswPAuON3x0eDm3ejo9AD5XotrQ==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(376002)(396003)(46966006)(36840700001)(4326008)(966005)(36906005)(2906002)(5660300002)(82310400003)(86362001)(26005)(336012)(316002)(36860700001)(8936002)(186003)(70586007)(8676002)(7636003)(6916009)(82740400003)(356005)(54906003)(426003)(7416002)(70206006)(478600001)(108616005)(47076005)(24736004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 09:34:00.5930
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8437a789-77a4-44b4-92b0-08d92b29b69d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1211
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 08 Jun 2021 20:25:40 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.43 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jun 2021 17:59:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.43-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    12 builds:	12 pass, 0 fail
    28 boots:	28 pass, 0 fail
    70 tests:	70 pass, 0 fail

Linux version:	5.10.43-rc1-gc108263eaf06
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
