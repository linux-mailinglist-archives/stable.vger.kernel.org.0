Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F8F423B98
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 12:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238079AbhJFKj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 06:39:58 -0400
Received: from mail-dm6nam11on2073.outbound.protection.outlook.com ([40.107.223.73]:15200
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231571AbhJFKj5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 06:39:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oDweKsAu8ypFtmL3GsgC7+m6GOh81S3fCR2Pk47QgD76QalLJNSxw2030BSyhHkueKTN8eigH0k19dQvHKlepM+7+zZ4+QuQv++aJauKt0qjIQSIuh0pZ0gMrXbQnvYSfoy6rzFkuHmU0jTgG6K5/V41jECFGBozqIzDEbQ/YsVH6mPakRV/BVHMHGv/YVY8jntsiPE1UwS/ZcOd2BHEknXRJgrJgHnwsgtQvWWWpMSEa4RXth3XssZOuoPxMoNEvneQiUVGiS4kerU1swCFvUYnIPeasy7FSdiIofxvW9/RxU51pHz/DlInPEHuV6z4mFdC9//EwUKYLrqp8Jnq8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mcesywnx2xFii3JhX3RuXG+m3XQ6Gl8UlvhXloy6VT4=;
 b=m0JJt0NHWYGV9bGl8qgoTplKz8NWh+QjKGCD7gSym+wU/cyeT02NjKT7MLEjtcXMmN+rLMVoYDCIeBbrEgQaVQhZ5BRLRBAVlLFNQfsUICJKZB4eGIclISoCt/xAW+SzCH9Y1RhgnXKIvZ6q+7DQX/74aLZQ/26HfRUe1dB2ynX9UGCZHdD19XN+6eT8vXn8SKdp/VMvTN+QAFzBaiybhiNJQuLuNcCfdDa/B+sEPnys5QjrY01Fv7C11XO4/9g7RkjhlgEXaKNnHZ/6BIpme44sAgLcsUDlasqcuchQGt6OsW4B5Koe5ovI/C1E2eHVrYLFXQsf+BzXg9OBlYX7tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mcesywnx2xFii3JhX3RuXG+m3XQ6Gl8UlvhXloy6VT4=;
 b=pYp7Vp1RhifpHmmK09UA/z5XTLJNOZ/6/30rfal+oRMfJKq/w+yq9UpuawlKmrzaC/YPm/ln9JiTzCZVGEnG6o6Lopjxm7so+sbEEW4oPopKNSRR3/kTzHvpIw0Xrlu69ytQiW7595vc5exponQNzHrUqYwynOzDu/eNs8yJi3Wxu6qTGB9qondljuQCv7gfpS1boEInhWcm1IjcYCXS077Yg/YHFoCWUOx+aHkgj1Jmo7EKTH/5ZjOPYyJV88hg0J9L5j+Z3KxlDeHWr1BrbOdRkxrKpkyTZRmfP1/yXipBhfdRTAxJgFBJVlHM7NUlaZp1FCCSbgu77PWLtwLGwQ==
Received: from MW4PR03CA0079.namprd03.prod.outlook.com (2603:10b6:303:b6::24)
 by DM6PR12MB4044.namprd12.prod.outlook.com (2603:10b6:5:21d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Wed, 6 Oct
 2021 10:38:03 +0000
Received: from CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::b3) by MW4PR03CA0079.outlook.office365.com
 (2603:10b6:303:b6::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22 via Frontend
 Transport; Wed, 6 Oct 2021 10:38:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT046.mail.protection.outlook.com (10.13.174.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4587.18 via Frontend Transport; Wed, 6 Oct 2021 10:38:02 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 6 Oct
 2021 10:38:00 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Wed, 6 Oct 2021 10:38:00 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.14 000/172] 5.14.10-rc3 review
In-Reply-To: <20211006073100.650368172@linuxfoundation.org>
References: <20211006073100.650368172@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <7261347fb4c04ac4be7da64886e3326d@HQMAIL111.nvidia.com>
Date:   Wed, 6 Oct 2021 10:38:00 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c315aa1-1c56-42b1-22c1-08d988b55ff3
X-MS-TrafficTypeDiagnostic: DM6PR12MB4044:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4044B9A61295A5D309365A12D9B09@DM6PR12MB4044.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EvNFhvpCX44HVtuexvpP2adp2u7kZSMnJPcVNg1mupQ335+TFpB3HvYWw16TSIPhT+qR3w488CTs6LcD+tZfsDRaFpgZgL7Ag0OiGsbmqFK+WHQ9M6FduLQLkB2Mu3hXI5gnITsch6ryMhtzeeCgDHgpTMZVNzdKUWto+ERzmapoejRedxlZeMVJhK7cDv+rSD0SrpXDHWwQx0r68ZSJWQzgB1mN4GF5FRJfFhFB0Cxg7t1ivqIsb+l0RE0MzIFYH5V0uloCttO+rFr351FYNNKMUFgsLBuox/Md/vrmsG6Toh3Qx+0cIAGnCfYgSku8vlMtBU7p64Nb7aGdWJd1lMWY5Wji/N7XGHO/tfCJ6uFuFAO2KHn963cgOO9HDdtY68wPZPdAe+nBZg+v0nGhetWGUirlF/0799m34+HPeQmOPJgLJXyZQwQCLqLuATZiqsgiCnUMqZoALWZpvbiIaCPNRbJOQJ3eyfWSx1zWpjmflszswqYnjGLA3GYBnsSTtsBwHu0U8x85A2RcZiddE13lLDYdfU54FZDRi58Nk+mU/nssLbJrcExky9bMe3gZIXiCIW/kaQHtr+WHi62GUw/MzTrQA+OnCapTsUYlKXtucJHpH+2bDDgcAwAABTN5YHzIhfCjGt3Xu7tRaYVo7u2jSf1x/WBsgA/90lgNUetu9cb+3tlTSxCdz/OLHOke0QgLjoeoBTceNwocOZ9rhlixdsQOKmc5z/Ckf9VBSuBop2V5jte5/CGBTdefqO09wdVP8XfjH+2/cyqojJOPVWGbzYiUjzvMIrDvnJxEEag=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(966005)(5660300002)(426003)(24736004)(70586007)(108616005)(36860700001)(2906002)(6916009)(70206006)(8936002)(47076005)(508600001)(54906003)(4326008)(86362001)(26005)(186003)(7636003)(82310400003)(8676002)(316002)(356005)(336012)(7416002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2021 10:38:02.8714
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c315aa1-1c56-42b1-22c1-08d988b55ff3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4044
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 06 Oct 2021 10:19:58 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.10 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Oct 2021 07:30:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.10-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.14:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    114 tests:	114 pass, 0 fail

Linux version:	5.14.10-rc3-gd1d4d31a257c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
