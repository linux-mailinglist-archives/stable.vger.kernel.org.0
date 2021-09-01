Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8A63FE2ED
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 21:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344330AbhIATXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 15:23:47 -0400
Received: from mail-bn8nam12on2060.outbound.protection.outlook.com ([40.107.237.60]:28256
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230380AbhIATXq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 15:23:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P7rWMY6i/aSsn9AU5T3Ze4goc6p1lidQ/KPbgK+JNPSIH4qnwccC27MRvZz8xgm3T1CAuHUNkUoYhAwW02C271H6bzw4hCaUrn1SbtNKh+4Wu7NIoXwVWxbxHuCkjI9zn77UXL5XvUcL55R72+XM2PtI2J8OuGeZxttMVolp/N5U8RBaS9PwW/v1mtVD7NKhOsqKjI5a9R4yJpq8Z3Kq66R0LZk8dooiToy1xdkhQR+aoc3IBhPtgDihRRToHLWpgH0ExaJCKRAn0VtS9hC4pp+3zsVGbQL8UXnRwigEnbtzbi08RwHq/6N607nQbT1gWrgM3WMlbjt4imUMDtT24w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zET26H5U/7FTjExkbxKUHM8b3SMz55sSS7IcdEtOklI=;
 b=C6XSvqJ0Fdvr7vW7wcrsuaoq3GtNXLy8/uW2Zv3Cyuk9ulfWeRrg1BMWbMrg2eonzU721TJrnCiK4/U8JJ5I9nKY79UpaW5pjzA5ToIIcL0PqHry2XJzhFQIN9DfuKYVXwWxRq+yzYkZWsBdRDzf8SPgaWo8ve+LgbQTSoAgPcvVjBrlQaKLB5GG3SaDocP/h/T+WjjRSpOizrib4ASju3P3+9/bAg06swnibGTuYZh+ASicbiSh/3YlC81cT3XT+uLHnWL48YQeTVhiE3SN96KvwlTw9MKPbQeMnO9m4jcR/CSfj/E4ZUtGWWQFcU5kyC5vV/62aKcZylv5dz6X+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=none pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zET26H5U/7FTjExkbxKUHM8b3SMz55sSS7IcdEtOklI=;
 b=gdukmIiqKCOl8Zr1hWSD6Ph5lUWWkw5bcazvmnHZC+cyNmv5R7Wa/1MXBIVGCWYXNOK/piko91ijGV466Qp08JZMtTPvApwggSPuIrqPJWbpHNmVG67wbFOATFAD8TpNKQ4NlD9SyB+T98qn6DeEcN2bbgJgL6GJfROnJBFZl9fRmnEy23c67KcAoShh5ZYoVpGqUDOWJWlqDPIMYZqyFJmoY3lsfv9pzAJ9A3DuHzPE5qtkMmTK7Klj7o4ZxuDPrJPNmT7Ka7IL9F9Q0zv+aJwUZILQMGZ28cI6peDoSAAHPovTPyrUFYU/b3PesvsxFEeTHOqTrtHo9TR+P0ta1Q==
Received: from DM6PR21CA0010.namprd21.prod.outlook.com (2603:10b6:5:174::20)
 by BN8PR12MB3108.namprd12.prod.outlook.com (2603:10b6:408:40::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Wed, 1 Sep
 2021 19:22:46 +0000
Received: from DM6NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:174:cafe::82) by DM6PR21CA0010.outlook.office365.com
 (2603:10b6:5:174::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.5 via Frontend
 Transport; Wed, 1 Sep 2021 19:22:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT063.mail.protection.outlook.com (10.13.172.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4478.19 via Frontend Transport; Wed, 1 Sep 2021 19:22:46 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Sep
 2021 12:22:45 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Sep
 2021 19:22:45 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 1 Sep 2021 19:22:45 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/23] 4.14.246-rc1 review
In-Reply-To: <20210901122249.786673285@linuxfoundation.org>
References: <20210901122249.786673285@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e5da4e63d4ca4e9396bb320c123df27c@HQMAIL111.nvidia.com>
Date:   Wed, 1 Sep 2021 19:22:45 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46318209-f20f-49ea-5ffb-08d96d7de124
X-MS-TrafficTypeDiagnostic: BN8PR12MB3108:
X-Microsoft-Antispam-PRVS: <BN8PR12MB3108450A63EE4F811DF9DCA0D9CD9@BN8PR12MB3108.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YFin334uUPxSECcI/eG0+eBWm61yuGTQGQw5iMZ1mjOB6aycDOxwMjcndndHnAhCNTCBe0NVB8fnulstSQjwj+A93j0Qg/ZgOkZ8gXqWocPC2/EvokxbmNb6YSSdrNzhGopqQ5Rj0t4Mz4QSRxq4taBrsSbEMxxOzmdN1Ji/RBRemLVEqvWHqbgTEqdJ8KL0wxgWCiJtsXUJdELNAOkMOGfuFleYUlFRFXWk/ilKclAoRVTWbYEMbuA2MJFhD3m+vGAgnbjHyii9/2Kz9hTILHIgzV2I3Sv8bXL4f6IQVCnQYoR8LBreJ+YqlNWpLU1yEBVEubO2UnD3+bGIcX8GwyCmGNSCWxLcOXV8uVu1Ka+JBuD44D/gcu6b7B+XEBn8AEf1/+uNmrAR4bJGgbnvR2ha1u34wlHW/gOQPsgZPHCvTEAarOrG6/diTKexsV9CCbtX6LCjws5UbPGgXkA2MCGUpTMUIfkjJjErEpA8uyvehYzT3W0TPVJRTae9XYqorrc9Qsrks6nhqedtwhfABPVReCgJtBq3e2qBcv2mquSt+WcSvMhSI3FhtMkXFk4UdmXEXupuIb26SMfvVyhVx7bGqr3CSSzcK0vpfnUMkJwnskStgp056nRIyTRGHoxOriqnh77FTUeY8YS9POxkCl1Mnq9a5aDPzOTMeyOaLM2cHNJCmKWMpa0isNBARu3SiGYdVF7bPnMZepcULIo/Z/h7VvB4qtkmsJlrz4PQIokULGkgc3lLqhAofHQQH520xeipL3dP3G4+dFz6uyMWSgTYuja6ZSu+nCjXinw+tkA=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(396003)(346002)(36840700001)(46966006)(186003)(2906002)(316002)(426003)(82740400003)(54906003)(336012)(86362001)(26005)(8676002)(47076005)(82310400003)(70206006)(70586007)(24736004)(6916009)(5660300002)(356005)(7636003)(108616005)(4326008)(478600001)(966005)(7416002)(36860700001)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2021 19:22:46.3583
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 46318209-f20f-49ea-5ffb-08d96d7de124
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3108
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 01 Sep 2021 14:26:45 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.246 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.246-rc1.gz
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

Linux version:	4.14.246-rc1-g8626d0e3c8af
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
