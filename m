Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5A53477B9
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 12:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbhCXLvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 07:51:15 -0400
Received: from mail-bn8nam12on2083.outbound.protection.outlook.com ([40.107.237.83]:61067
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231425AbhCXLvK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Mar 2021 07:51:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LCP0+Y3y0WeOGKVFe8I6bsQ+5vJUjbz2qgK4hXZuZiP2p80kf9jG87nYP6nNum2Y7My60cwXsPiihVuxmGyU1Nnvt9dkYo/Q9tXWrXg+JTseIVXdZ70uSdnQ2CFXmkkxPMoB2teJDduMZQYc6EhQaz71Wk3SRb4XiNL0uj/nOmvPBzTjLKGlz6dMgYjNteeartiLfYnrtvYUnrRKIJLSwgEzMMnjja7v1uxfM0J7oS90W5GAC5oH8rXOdLsEWE6I5BRoGpzFNTy5jvz1YACTSHIkF/q+QSn6cChc5CMaZdAeoX8dpVcctn48SM4D/l0lq1neGZb//80INF1NnYwjtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MK68+58fDhQGoDQKd9F+RNJVnq5t6Tz+rje9utkJfBA=;
 b=VYw7u97l0S4c+wPrfg25ea/nPpAiK9Oqojb5y0UdHrtxBqSjQrm6h5NZIXWwJsUErd+9/zwybzYzfXiANpSlWqE7/uySsHdmpxtJc1MY5HPj2zbUyjlsE/BQBrNpAwN3Ko9AUl3m+/7ZFY7KiCx1rJC5tJykcVxVLOkWEqnXsjzYLmB9L+ck7UopQzkHgC2XAlrG7qALKNFLmYAlxGd0j665ftw2Qq1R7iWBfc2pTgGD8ZKVOwSCdLEEVH/hbVSgSZeOp38i0NpsyWVvgvTnAK7vIVdgmJE9EzH+hoXIita7FiZw/ar1BoXLBR5mPcfVDogp44QK1ou1c6JULmUKWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MK68+58fDhQGoDQKd9F+RNJVnq5t6Tz+rje9utkJfBA=;
 b=Kpt9A8rdf8M1Lvj/S9MJJ2s5wi7ek6JS8yCZynFdEuSwQ4PIJywljTr3GgBy/C9TYvMRtz32pxZMlfHbiKWZEtgzw6HVXrDBQNkFqVUQm8iDONPCPFxDQqkgvDjgBZX3sUB8q/9wSTXclQK+MzQmNm0iLsPNnxL8/vveX3hASVHxrnUDTCL7LUJJm89+C17pW3kSJ3BAXL+EmVZiiysps+gfcMXz8gC9j7PZKuV+qiaSxxD3sM+48XNxwCd0bNtLi1nOWssaH8LT1Lhmnh4kiZdgPEuhba0RmzSmDkYkayzLYobTe6wM432drN//TbzXo1bIeQsk6X0747ikmOCyrA==
Received: from BN6PR1701CA0006.namprd17.prod.outlook.com
 (2603:10b6:405:15::16) by DM6PR12MB4010.namprd12.prod.outlook.com
 (2603:10b6:5:1ce::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 24 Mar
 2021 11:51:08 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:15:cafe::6e) by BN6PR1701CA0006.outlook.office365.com
 (2603:10b6:405:15::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Wed, 24 Mar 2021 11:51:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Wed, 24 Mar 2021 11:51:07 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 24 Mar
 2021 04:51:06 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 24 Mar 2021 04:51:06 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/150] 5.10.26-rc3 review
In-Reply-To: <20210324093435.962321672@linuxfoundation.org>
References: <20210324093435.962321672@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <13fdb47de47d4b5984f1cee069fe99e6@HQMAIL109.nvidia.com>
Date:   Wed, 24 Mar 2021 04:51:06 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91f5fed5-8eb9-414a-6325-08d8eebb1cb8
X-MS-TrafficTypeDiagnostic: DM6PR12MB4010:
X-Microsoft-Antispam-PRVS: <DM6PR12MB40109AF37E597D946FFE845ED9639@DM6PR12MB4010.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TjX5y1Qn4DpZszXQEhAEmvmx3yIZjzo+eAoG36ywI0vAPN1TbYety969wVmwVdWCoVXS4s++EdD0rSsbHT//I8f8cUfdOYsEReaIWbOk/drGXoqtZUwSaWsonOLdBsr/cxNLqEpGTCoQRGFe+J93YnH5IpbTODk1LfIU61k3yT0FdCzBRE9wMxmoJcve+7OrZzRZROIJZ5Aq72p3KJo4/glEDo1SHXL3mD0MsyBu7yg8YqGnAlNbZnWASOsqqeoW+2m8aIC6iRs6t8dA6GeTEOjtClfwwJ/4OZB3POSCUAbqqDobXOqqQqSebFyywR5z44jayyCLcDTMQ23FCGBy3f7ql2/wGq8RtB5ZDVZSHnP3jEu+2ZWCPIMMqCMgOJ+a6uQMS6/p+cf5E8MERHyg+tY61wuTUSgj2/EMfog/b0TuE2nwn64dAbcuofXHcKY3323tZ8+zDRHEKiI4fZqS6EN7kDSYKpWmaAAJavqVQSOR5CKhB5TrX0mwzup9azs+pRzzhDNC8o3o11DjOxhlpkx6NvHJyBh5pSJAhbKPiANVe0RTscCRAKXHzVaPP2uPkWVew+MZBROPpKLs2nQ7996O1MzjwCkUcYB1xr1PRJZAmTi6DCZAbWSil+1DAID8fdq+iOTleBXKwLx5QeaXQIWXbQWIJtLpSNCI6SYRg7Ivt1tlph8SAPBg21exefSQ4gHVdGevoO4RB1z7gwhFgHwUiTTLOU9HOQD1bMC5i8s=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(39860400002)(46966006)(36840700001)(70586007)(478600001)(47076005)(2906002)(70206006)(86362001)(426003)(5660300002)(356005)(24736004)(8676002)(7416002)(82310400003)(108616005)(4326008)(82740400003)(6916009)(7636003)(316002)(8936002)(36860700001)(54906003)(186003)(966005)(336012)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 11:51:07.9417
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 91f5fed5-8eb9-414a-6325-08d8eebb1cb8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4010
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 24 Mar 2021 10:40:21 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.26 release.
> There are 150 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Mar 2021 09:33:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.26-rc3.gz
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

Linux version:	5.10.26-rc3-gf6bd595b6fda
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
