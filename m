Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB084476281
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 21:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234274AbhLOUBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 15:01:05 -0500
Received: from mail-dm6nam08on2070.outbound.protection.outlook.com ([40.107.102.70]:8288
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229699AbhLOUBF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Dec 2021 15:01:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fx+ucVdnND6Ty3Ap1VL1RmvXytkajhR0gqp0Nb32xrfUHKiKtFVRWjbGAhpNIRJP9KZ2G2fplXQhVrTz/d1/HPFiE6og4bZ/9GcpEnEDkgSe9zimZ2IhSwBoLF0gTw1rvn9PrFeOprxl5mJFlCD4SJLJJ2QLOC9Ds+yoDi2lVRBtyrFEUjvxJiG3Ik81l02cpVEDNs3cCajYvIvfOAOVA3a78vy4zfryzoTeyRVFKgLyn82eEcqaz0RNQ6p0bg+0SOMuNVK/dqEqkNqUiCXlDzuBW5x3RqOMFFFP5atS3JaWpICDYUbhRXWUiURD3yQXTleM7ZbNv63cq1R2rXVWow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hmz8lVzt9pduuDR3zaxOSGKguOmrvUjGnXPgqflgK24=;
 b=T9DvcrL8IMfVoyRIfK/g90/RCuOcB4B7dnxhmiPNgplk8dFU/ez6xzqMQL2vXobjLTdi81vboibOoc+iaIROX1/ly9UpekGGSQG5c4QJpOMQr8OhY4O2IVBao6jK5AXw7vfjrzTkhB4dDjr2teDyKYCnQ0RElNF5XWfKk9Refg8z98xqxVZTxLvQgD5bFFh0zRnxvwUWH4HKFobLB5C0QpGD/Btrh8cjdNH0aw7lzB/c6wVVVrbO5U+RxAEa1dO781vc1B651N0d4txtLvhaoj92k8Dyh0l/asFhR26ZMw9l8mq1G/fb/TlUxcmVVXKlkUyHOrMzYI8SumA8m9iiEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.14) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hmz8lVzt9pduuDR3zaxOSGKguOmrvUjGnXPgqflgK24=;
 b=TUoCnT3MJmJ3Utkml4ISBgP9Yo+uUMXlec7mgzHb170D8rPqylAfad+TCnMvUTkS6BxnedWHeEVcoaIeF3XevTNPYylrNcqipHVxSmeQoKBTvxwUG3lyhktQnueOlzLQ1E5M86VdWccq7sO8MrKjZglQvdPjcVL65cg1K71W9S2t0HKWYT3NLBZqcDy5QMfWMxqhLVx53Vx0dK+ARHYPEFCfpy18Lq88EOYpnq30xZE27nwYDKuYNvgs0Ecy88GDSmdw3QBAM3QlqIsC76F87M+7+a1i7PjSjgSUwr2hFPGdOap1s3+PIAhE936rViz/J0kpSmklRbHv/LJUNQ5Hbw==
Received: from BN6PR1701CA0015.namprd17.prod.outlook.com
 (2603:10b6:405:15::25) by BYAPR12MB3349.namprd12.prod.outlook.com
 (2603:10b6:a03:ac::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Wed, 15 Dec
 2021 20:01:02 +0000
Received: from BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:15:cafe::72) by BN6PR1701CA0015.outlook.office365.com
 (2603:10b6:405:15::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14 via Frontend
 Transport; Wed, 15 Dec 2021 20:01:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.14)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.14 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.14; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.14) by
 BN8NAM11FT034.mail.protection.outlook.com (10.13.176.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4778.13 via Frontend Transport; Wed, 15 Dec 2021 20:01:01 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 15 Dec
 2021 20:00:38 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 15 Dec
 2021 20:00:37 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Wed, 15 Dec 2021 20:00:37 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/33] 5.10.86-rc1 review
In-Reply-To: <20211215172024.787958154@linuxfoundation.org>
References: <20211215172024.787958154@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <2224085ca16f407dab16a15686a82c3e@HQMAIL107.nvidia.com>
Date:   Wed, 15 Dec 2021 20:00:37 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b256a994-95a2-420e-4a74-08d9c0059ec6
X-MS-TrafficTypeDiagnostic: BYAPR12MB3349:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB334995F77D687D7FEF2A12CED9769@BYAPR12MB3349.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JVyvc7lnBTAmDFIPMN0drFMdRFQ+MOje4retnJi5ntnt0IuSnxUmlWqLrGkzV4dJzqVwD3e1CZcofS+s7w5f15GacAcyzT+/fFd49b1p0NbaIRUPuUkTvq6la6u7TdZPm/3MMJekOl6uIdJnJk38k0nyNxYC1Ww8Ewxu7zBGndErCpfyPNi7GbfOoPTxzQnUQpmm7rrJTQuz+5J3vxQ9A45810RLWRxGlOK96IxlEjVUMll9LlduFW3jHS0t0wlPsXYWtQSUsE4lOAxyPZIlXsyuLfe2NkmVWn9x1PhCyWX+XPCy1WPN49L9KZXmSVpaKmUr4K0W716r0ofItza8ze9pH6Sx8hP1zksfm5T4d0h/2UYpM3MU+RLg4FeH8NWLvaEn/NBI3Ukg1odJEZA+L7HhYPUcl1RVOPM3izUfLa9SUHKPP29pPUlaKubK4bxUK3ZGeOvpaUkfPtqwPOgGz292ITPp/DMGleY8XjTXPGEYUKqjUML5YzzAQMg3JPV1f+tlVM9jLfXEn4qdL7lwHuVK6DtfCiYz6c15QH4AO9YV03z/z7kKx+DC9Xh/qOzecm4u9c1hitN0SW7pyTBzPByQ4nReoEf4p0S//e3nverV5cGPBXjk3R5mOW4Q4kAxJN/SPF9uj93XhuNKbWcAaS8VT6x60FgOzge7r1M72pGwpx89SUmyRkytExM8AuZoDffv5373RWC7XYKpd9uVFjMgQ+cW6KPZd56lCB4eW7kfbjIM3S1IUcwML9kDrfXKgg9hKLdWa83nnIikW0sY207uypGIyyZ7h5B5hts9/KwKSwBiggqzuDoK6GpIRdl8CnhEC7WaLVzZ6hGMwjYsYcV3tV1OW5Q8J89CNL3611WsXx4T5EmrASzebEdebjqQ
X-Forefront-Antispam-Report: CIP:203.18.50.14;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(5660300002)(186003)(8676002)(2906002)(508600001)(108616005)(70586007)(82310400004)(26005)(47076005)(966005)(40460700001)(70206006)(6916009)(8936002)(24736004)(356005)(36860700001)(4326008)(7636003)(316002)(7416002)(336012)(54906003)(86362001)(34020700004)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2021 20:01:01.5332
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b256a994-95a2-420e-4a74-08d9c0059ec6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.14];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3349
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 15 Dec 2021 18:20:58 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.86 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Dec 2021 17:20:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.86-rc1.gz
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

Linux version:	5.10.86-rc1-gfb04daaadf03
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
