Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E578042A4BF
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 14:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236351AbhJLMoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 08:44:13 -0400
Received: from mail-bn8nam08on2075.outbound.protection.outlook.com ([40.107.100.75]:61409
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232900AbhJLMoJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 08:44:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RD6vV040m1MPJOLAADMd+ENrlGaBBrev9L9Rpn7T7llrGFvgxbSQ5QZWUiqgLcD43WR2GczAYY/F/3GAzRmD1VkF4+gBVpXZ7PsEKEikCr/mU34B5MG2sY+W7XvmU6frhgwTeu8vPuTFOolxu2bEQGOV56P/I+z2QvXaXU0Lng7SSuiuCjVQ5zJFj14TYkTevvnIcLx0MOTokRIvPznN/CNitYcg8CF5CtLbd4lXjFGOPBsToc21K0fw5V/68zf6CktQT+Mb3DLLDD6HnwFbmgiFZdSStvhnVvtFqWu90w8LEoTnzPFTy+ymburjdvv7BSOKVGVc6kemhxPfp14L7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I3Jyvkf/NsqEYUc0rYF8E6+zARodCNXz2sD7rMbe0Ac=;
 b=ngiTkzv5WPEHCfSNG8DR1ZVBU4b9kR4EH4HremN97G5KYpladBeG60IAyDCIFMMw3RG4Q/LT3DvMgjZGM/f+QnkjM/cp0aKKEotkD5NNH+deeOWKxAjh5lpZ5PkhYYpaEDPHgwPtwM8+8v71+LBQpGd+Ygt4o3FATyoerLbGgeF31i0iLxOq5bqV3c/D5e/pr7MpYpwyw4vuJ3QxMYp6JpYebsmHxBDfwkXdAo1sgM8AMC9tyIgocbL1sjJIS+JIkCvLT3jcW8zZnJETiryFY3YwfDq5JnIw43cdkkkwIKbvDoJyAc5buWtLG3S1o0fWNyOsekR1FPhaeCJp828cAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I3Jyvkf/NsqEYUc0rYF8E6+zARodCNXz2sD7rMbe0Ac=;
 b=AgqOfrDzYpV8hTY/66LV9bpnNvXDnYTcWxJGxFjoLb8j0YHs3SXQetlmkT1QPcymluFxk+vxRTDMwD/955rjmIjpx1hyTt8SF4sdbJl3v3KFhca1mXMUATVLgf9ot94QgSYWQ2MZkSdlTeYPKdxpm2xgVSBJ2YmvCvVJE/eqFqx5trDRhFPNkxP1AYMP8uR70LrCVvID3rsJM+fy/c6rHv5cx9dQQAYc4nRcu9OY5uojV6uIUR1e+ZQFXuky+9q3KICG9XCHcbrrf3KJJZShm+FXMRHrOrMSg8sO14JMcf+ojE/Ea7gUYjQCpM6tN6PqEPcdsJoyCCExH/ANf7KVQg==
Received: from DM3PR08CA0010.namprd08.prod.outlook.com (2603:10b6:0:52::20) by
 MN2PR12MB4333.namprd12.prod.outlook.com (2603:10b6:208:1d3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.24; Tue, 12 Oct
 2021 12:42:06 +0000
Received: from DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:52:cafe::78) by DM3PR08CA0010.outlook.office365.com
 (2603:10b6:0:52::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend
 Transport; Tue, 12 Oct 2021 12:42:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT042.mail.protection.outlook.com (10.13.173.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4587.18 via Frontend Transport; Tue, 12 Oct 2021 12:42:05 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 12 Oct
 2021 12:42:05 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 12 Oct 2021 12:42:05 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/51] 5.4.153-rc3 review
In-Reply-To: <20211012093344.002301190@linuxfoundation.org>
References: <20211012093344.002301190@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <a1a61e0fa93a4755887b534f50f12bea@HQMAIL111.nvidia.com>
Date:   Tue, 12 Oct 2021 12:42:05 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24ed5523-7c14-420a-ff68-08d98d7db298
X-MS-TrafficTypeDiagnostic: MN2PR12MB4333:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4333705BA66D7716F2B90B57D9B69@MN2PR12MB4333.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dzMBabO/LpElVq8LRZOR3n5TI/j1aqhajRHqlcdnnNP70fLM3OiA9+vix3IN4jtR1WyW306dGGIGDfES+kE4pOuBzMggYPJtttKxwgVNvZwUVyzHDEnBNPyUd43SLouQ07OmS8X8n1lJ4BmprHDFyQ9FiVWI/qLCfnnGBkHyrMBGTCZUu+wuLuJemHAgTtLWZVFd8p1vXNmP8OLFTPw7CcnFEBR95nio2qZ6R3V5DqsilfgwQ7t9OfBav/upVdtz2E6Q8d8iuFb+mCa8OasnTwmVyGOO8PI8+iLndUEAj8d5xXySEK8VO/mBl/eySuIDnmcy2REQp3jrrQm+CtfB4lVTFx770PfJ6Dlyb+e5uiGV/LGkq+V1v9j2KlP7NTEjqPSsG9zzNNcZXWOj86OqcrHkeoFmNBhfZYv0WVV4V8MbEVJnMxAe9s7yRQND4aHTXiCNRQ6ESQ4A1oOHViqIjhdE6TWOU5tcw8bCrm9OV6NsM85Y/9ptkjzMyHcFSA1dbP4OHvpYT017yfu0q3glwU7AZ/ibYjnCtkBteRO5IlEPCRU3ARonI3nBgSbCBSbhR0jORMx3x6F41Ry42brz2XJkt0G2nVkas/0S2/ya0B9ITKyUPKpB9qKzh7PkSQAzRuYHuDrvMhvSUXBSMz32nugwdwPMawUmOkTJjF8al3YpO03pLxmFZBAXQiX77ZLBReP93P//iqg86vMuOfztSS+jXdqvGLyNt3lsN/76OXsx5jaHMc+XB0DLLk+6adjiv5Yd2z38r5yAd1CHM9x16cptAyVRhDiDsMVPHgMpbQs=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(36860700001)(47076005)(54906003)(336012)(426003)(8936002)(86362001)(4326008)(186003)(8676002)(108616005)(26005)(316002)(24736004)(7416002)(82310400003)(6916009)(2906002)(508600001)(966005)(7636003)(5660300002)(70206006)(70586007)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 12:42:05.4886
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 24ed5523-7c14-420a-ff68-08d98d7db298
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4333
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 12 Oct 2021 11:37:04 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.153 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Oct 2021 09:33:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.153-rc3.gz
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

Linux version:	5.4.153-rc3-gc20820e7fdea
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
