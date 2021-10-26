Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 654E043AECF
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 11:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234359AbhJZJTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 05:19:01 -0400
Received: from mail-mw2nam10on2063.outbound.protection.outlook.com ([40.107.94.63]:49214
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234204AbhJZJS6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Oct 2021 05:18:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T3CaC1hvfiLoOW13KJdG5EqujCYUs1tXAs3MBDHUTnv3RIBw3RGmAki81YjS91Xjx0Edhku9BTmRzSq2CXZI38tfA66DjokEHajGSznFGtzzqdYkNt7kEhJo1a0Twv4mGedqdVhdmFNoiC3/nZwiE8+uK/Ftgt5QulqRAsixxvbkUhIQzT/t86x8m6BEO42IO2oK7gC6dRhEMXL++TB0FL69rCRK/t7jqIwOM5hyMpwdRJJeuzZBt6pdE0tOgbzRY9dEitZrcWuqjWYh0dOdaE2iEAnSvTlJefSi42xkuX+twBP+DhiNoMo1g0txn6eh4B4A6VZ3vFUpfMY4WLGYDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pF6HUXAN5bJZ1T/XkfO12KE1S2XvV91BqvcD8D5eqVI=;
 b=b2WmOUQRDe0XGfTy7CyrK0bFvDRtvppsSUYLbPZO48QqWkCYlFLjbKPJq8NylavHEwoCr1P822cnx+1sh8ITR3t6050KchWTesuEN5ZmO775mkArwdnz5Akx5G2gyZyVSmx3G+xizC9qeYnLZiJxgKeUSrn9h1FBjuA/0C6PStw3DEybKAJHFkgfbtTMNSis/2fnzs/8e/o2GSNPYazHqn8OO3kwjyEZF6V/MeqQ/ltWmq7HuA7m/NkQ4LBivsc8YubNM8s1PAIR9RjMXzEgN0jzlbBBXuKOj+Kb97QUzu3uRlYLb3zcIqXZHzBBwV+BHMtVbm0fqxy9ofZmVfbpZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pF6HUXAN5bJZ1T/XkfO12KE1S2XvV91BqvcD8D5eqVI=;
 b=gn7Nz+RHdv9m98n+WBJHtWOL1IQFmnPCyNWUUPSH0ylhfPA96+JdR+mTBofOIsqbb1u3UgWeHB4gZ7jRkEGwZmbyWtEJi85s+lJHFUZd5I6kZZab5UKPFjXQYIZssaEYqMyLg2lsZ3+zlX7Zpd84zQe4v+1he4+ebsIZ5zTKuM0Zf7LN1SotFa152bwVNCveSTdJwTWmgljNsL0hjzq4XGik/Ho30zA2cQ/EcC3xlASspqt+3lI9q3wOBLzUsa/hdB+MAttKPkhXeDFE9y3+g4GjzYtsAhDxHK/JEA3lXlKZ2HJsV0/F8RI3+QVZy0MrI58lsIw2hCXnUmR6f4V2vQ==
Received: from BN6PR14CA0047.namprd14.prod.outlook.com (2603:10b6:404:13f::33)
 by MW3PR12MB4522.namprd12.prod.outlook.com (2603:10b6:303:5f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 09:16:32 +0000
Received: from BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:13f:cafe::a9) by BN6PR14CA0047.outlook.office365.com
 (2603:10b6:404:13f::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend
 Transport; Tue, 26 Oct 2021 09:16:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT005.mail.protection.outlook.com (10.13.176.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 09:16:29 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 02:16:28 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 26 Oct 2021 02:16:28 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/50] 4.9.288-rc1 review
In-Reply-To: <20211025190932.542632625@linuxfoundation.org>
References: <20211025190932.542632625@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <d1a6c76bc8f842cf8d039c0fbee87a4e@HQMAIL109.nvidia.com>
Date:   Tue, 26 Oct 2021 02:16:28 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8fe50caa-7a3a-4346-c3ae-08d998614b9b
X-MS-TrafficTypeDiagnostic: MW3PR12MB4522:
X-Microsoft-Antispam-PRVS: <MW3PR12MB452268FBA1B75244C4335F2BD9849@MW3PR12MB4522.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tj20NQyjuKyqFRls7S3BvcKb+bA683/UcNJccev30GOFwg6+wWrAxpiOrFs9AZomcUhONz9tuipzv4cdddbLpzAPGllWBcCNrctXM9jDrVAsahXSjOUVZuTaRpPRbVNiIi2mobA2dxTAK2J/4v8TahTWfIsFtCqfxtC7RfNU+W2DiXnBWi/TzqzLaxJRlNZq30tDlHviw7uYGZIXhZzLZ0t59t/fLGLt5IK5smlwLczy/FoQ5KxRkonRlRUegeD2Aw/GH4jaAgffqEs3DerxW22XnQGQsi5UGluIlW38TSalgUCNA0iSEFJkEI+R6AmUxENpc2dJHmx8gOR54H6wt4vzyxsJxuvRCRKghrZysbLova3KG1qloHeWS4jbsyAoGP9PV9Lha5G+3KxQ3W1L/GhXMnKPH0rhZAgWIJpVsujXJzvY35dVg4KGKugrDBzVk8E6RkTv/XcFI5zmijU3duoenJ4WyaFEB8DmEORvL79qLYqgOXfnVe03vb2GwlLFBmjzM7oUlw1HYyTyrLy8XOE+3oKxFRVzoFrHByzVNcBdyrjHZ8ebFd3FCtPI/TCU2QeiGIRpjmHexY4Vi+ST8dBLgfDjK31OvEHqNWkq6o36PvUBaL9c8HAZls+LTS60EV2URnDkjgCZrK0MqiajdcDRjhM/AM58jKeTqa3PDdHlGzHf0IWUr//4HvPTIwCBaGL2QjdHpMhrHcJ2tDwNVJqF2bvEkFIc0HLmLLN7e7EQPmp44aMdAfhIZMV0XS0w7CNLvheS3FeLCDCKCkYVOeMYwyskVaXcyjNXFqEcgGs=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(70586007)(8936002)(24736004)(966005)(316002)(6916009)(2906002)(8676002)(508600001)(54906003)(26005)(5660300002)(108616005)(356005)(70206006)(7636003)(47076005)(7416002)(336012)(86362001)(186003)(426003)(36860700001)(82310400003)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 09:16:29.5675
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fe50caa-7a3a-4346-c3ae-08d998614b9b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4522
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 25 Oct 2021 21:13:47 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.288 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Oct 2021 19:07:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.288-rc1.gz
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

Linux version:	4.9.288-rc1-g668dc542cb38
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
