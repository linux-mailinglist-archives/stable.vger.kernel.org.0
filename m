Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305F1472FA0
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239672AbhLMOnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:43:24 -0500
Received: from mail-bn7nam10on2054.outbound.protection.outlook.com ([40.107.92.54]:37600
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239664AbhLMOnX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Dec 2021 09:43:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uu1UP3NVPbi6pzXnlqDmjjQ8So55beNJcvn3gBJdcJCGQgBvXCGu3uxOa98UaOZWlOmRxaRKQJ+beU+VfwudMvDYt/V3JFaiaujMUK8BdAXrvv3VLm9vg4eMeYX1j6ecN+8BWIFpO5LAANrdVjhbPKYMoYmZJj1hjFbMZ9g2Dwse6rrgoiuOYj+PfNfJR0ej4LVy2ZcNPGCIrizhsgSATxTrmttKoJLLZdP6nQXmvTUe2bw+gxFzr9CoqY6B/tkJPW2c6OTX1CVN9t0VN293dJAyyimB4EbD0YO4GHAHoIq7PZfWmmRJTD2cMxqUSOMahy2QwqPayRsGzBVl0T89ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WtsYqbrLf5xk5TWTL5qJ73PDqfz6y7MowR0tS84vZgs=;
 b=eOTb9mMlS+Bf1UROXXmUom/lXxCm+b0Qf2al0phbYqlYaHSYeuggAV9r2W5ztgal1vuUr/taDcridW3Sc5GfpHFB8d02T16IQjI0YuLQE3uZgyUqv2EGW49veqBEiFgJVIElL4gF8Km9U3HmILDk/kJxN64n/9PU7MhAlqK2H7pUUSRMrM53/tWL46YbxCScmggJsOvn0a4G37j315nF03gFIzTo62HcoTiMNi0dty7qf853XLInH6Eu3V2tu7U15unZc9n1rPYE0reYiKcwNG5/KZT7jitcbTYdHAR0tZ+ojP+vEZE6r4bH0El+LlzTTLCW/vbdM6ubDYMMG7I8sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.13) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WtsYqbrLf5xk5TWTL5qJ73PDqfz6y7MowR0tS84vZgs=;
 b=SA4AKBrbbqGn+lThhsq3ZTwsx9IoD8dHSDkZhLVRfJpWE3Sm0nDcEwPJciNapPw1ubiC/8STVgupn3dvKNJBsN2QTtWmujhs6cFJy7ajR9JTl+w9hmDgQv5SrSNhxczJ0uJ44CyJmVkrHr8NSArrmplcl9U/pFraPe5XwdsHpmVkS910x+0+wOrmLMbUaYk8PFUVqbVd919IocXq5bxTk6619IED30UjKBxUoJCQMjRuwVAmfpphys20UacnrWa+N0g6l7huVvj//tBba1Sz/ASVS238YIDJcA8RMPKrDPiSc+F14NR1AX6bEwwPmbeyDPCZw03Ci7CyrGAWKYIQrQ==
Received: from BN9PR03CA0383.namprd03.prod.outlook.com (2603:10b6:408:f7::28)
 by CH0PR12MB5041.namprd12.prod.outlook.com (2603:10b6:610:e0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Mon, 13 Dec
 2021 14:43:21 +0000
Received: from BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f7:cafe::21) by BN9PR03CA0383.outlook.office365.com
 (2603:10b6:408:f7::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.13 via Frontend
 Transport; Mon, 13 Dec 2021 14:43:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.13)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.13 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.13; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.13) by
 BN8NAM11FT058.mail.protection.outlook.com (10.13.177.58) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4778.13 via Frontend Transport; Mon, 13 Dec 2021 14:43:21 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 13 Dec
 2021 14:43:02 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 13 Dec
 2021 06:43:01 -0800
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Mon, 13 Dec 2021 14:43:02 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/42] 4.9.293-rc1 review
In-Reply-To: <20211213092926.578829548@linuxfoundation.org>
References: <20211213092926.578829548@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e83b9decbd5e4d029c4f27b443e40fa5@HQMAIL101.nvidia.com>
Date:   Mon, 13 Dec 2021 14:43:02 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0227e6e8-1be2-4905-072d-08d9be46e8fc
X-MS-TrafficTypeDiagnostic: CH0PR12MB5041:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB504142E4A3BCE43751F7845AD9749@CH0PR12MB5041.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bs26LE5zncswN/trUdsm2TqfYxUfSrzOz7hoozXElpVMy35yU8DymO3A76RdjZ3tGTW4PKN1da3WL3xBnn/9lDKC+0B0bEbI+9096aixL6iw1G2tOA5uuVMJtgHmRnLHe8kW3JrHWn58QI9VBGNMey2ec2rRscGeubwSg2bGKws5Mv1+kwg+Fyg4gFycXKxj3JiR/kSEs9CUa43TtV0Xetpc0Ssn3rEH3U9LMCOl/CLYXjfOS0nxejT5VdDz6dqt0n+NOLEYK3Nulzp0QL91ShdqW8Lys47MEzzMXEaIVndlwb1S37mi379fiRFH43biBRWXlCsunPQEkpTscAZ9XwtfWE53h2DAFJtfn5Ws3OxoNteUYiC7tKDalvz65dUsRy8Chc64qD+tADSHPeOqf24pmC4YQj/NJLzIFij+jM9rJbVr7crrkVOe2GZxWJgMIx+lm97gJxSB6P6nzkCK/IM+Ip+WmfXNv3OoQrQu2sumIcPI8J0nbfC/hcqaCuuucdZAoHKROTUchztPsZFf83V3W80gayHGbzJzVMoDFOgY+4BP8QF0HCixeXJEjNx5x5sSp2LQw2GuWy46S3N+eWXoEOP7RE3z282jCUbkkBz61eg35NPh3UxWxyr71iyga3OWnQsRAsiebyWwRIoCAIF7W9XWQm4s3dbo0x5jm2MILpxj/4nBmrFqaQnmkGownV6cExU7Unfhtz2w6kh+pwIpwTBqM+RkdcNVRhToXmUQHgYVtna8XiZDHxKT23NdJ4YQcjzi/nRvjEigvhC1R1JsH8F4zcBlG3SMXCEza+DFIEZ4yCdheIZYWiuDod2+u42IubwqWlsoJYRbZIXO/NRTFaoeH31Oe6Z4V5v2SVV9zLdySc6/IwooOGfGGJ44
X-Forefront-Antispam-Report: CIP:203.18.50.13;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(24736004)(966005)(6916009)(508600001)(2906002)(70206006)(86362001)(36860700001)(70586007)(47076005)(26005)(34070700002)(108616005)(356005)(4326008)(82310400004)(7416002)(40460700001)(7636003)(8676002)(8936002)(5660300002)(426003)(336012)(54906003)(316002)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 14:43:21.0624
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0227e6e8-1be2-4905-072d-08d9be46e8fc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.13];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5041
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 13 Dec 2021 10:29:42 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.293 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.293-rc1.gz
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

Linux version:	4.9.293-rc1-gad074ba3bae9
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
