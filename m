Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 967BD492FB7
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 21:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345967AbiARUty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 15:49:54 -0500
Received: from mail-dm6nam11on2069.outbound.protection.outlook.com ([40.107.223.69]:37281
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345926AbiARUtx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Jan 2022 15:49:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fEty4xEm+DlZl34NdUoo4B3dsbLPM5zNccge9+FO/nf3rx/sKJqzDbM2yLmZ38UUX3ZQPXWWIGSQe5L+NuD2qEsJvBzHD4i0CwFKd5mW0VJ1XB63XF53tJupmtw10iHvA9P5wLVUvuNPtEcMs3cvIxUMqBhsATeWSfmQqGxFboMtugcD+VoQLB9bcetIFYAxHq1KwWxQ3ilEVVcm+c9RhM1W4PAuq5a8Gm7Dn3uWi8MBgJF0RXXEUR/gobPOhTrvo5kmer7j2Uco/BzJxxzcAtLzPaomyoupAnV7FO1OrZpR69kTQWN4LpK9y/rZc+0MDo3X1CMjVU6NDJRvZs4m0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pSE3cuuz90v2hNsnw8XndfOcwUPHh2RelpjX9eBY2SU=;
 b=V3rcBTikLCSKRggog8lYMoNChKFEjolQyVTIX5swCmaLzQH74dtqUOW+IGY7dHZAMd6saDraHgB9VtOXjFKf1jzkWEFhpODuaSZNMBmaX1cTseeQ82BINRhutZ22cwMtSWqRiBegLcrF+qRtEXxhIPdofqtaNiS++F3D9xFIq5XimXp1K76zqDUSuywxdxavMgxbfjjyl4wan8+D4sE6yjhQTq+1D6DaR8aIzMNp4VqWuL2GNAYZ19ac24WDMFeqmYrG1uonxyoqIaswQ7V6s7noBHQa/ogSacM1jIL2EJqEd341yyhxh99mGMfqU2bAjQ23JGdpvfAq5wa8NS6MVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pSE3cuuz90v2hNsnw8XndfOcwUPHh2RelpjX9eBY2SU=;
 b=eiWZia3TclDCl+ruNhOcr2eeTR9PZ9d7L2Tg4AmcZ8MGzpVFdk9/BgT+RMIf+IFCLG2nRL1GvtGziXOrA8UjpzS9ggtu5CbFSXQ+ZQop8kpwR5eLbRHkQKj+YGffZwaKA0pURfVE0/6n/GIxIDhghomYU3fyjN0IkceKjH4UAFFwY+OQasN32A5C4b9E27c3XI7HUvJvXfUP9oMBzZNy3bKB1HwpsJj2PLL+lSF7XZtB1Q3IpSE2OMruzQ5ZqYwy8IaRNC3QGTRNxPd1AIa55FQa4zhuSYiuIvIIXiwDNjwXEzQJpcFsmiThPPht8E2UN2FdhbH/HDOYBYVZIYoRfQ==
Received: from MWHPR17CA0072.namprd17.prod.outlook.com (2603:10b6:300:93::34)
 by BY5PR12MB3971.namprd12.prod.outlook.com (2603:10b6:a03:1a5::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Tue, 18 Jan
 2022 20:49:50 +0000
Received: from CO1NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:93:cafe::81) by MWHPR17CA0072.outlook.office365.com
 (2603:10b6:300:93::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10 via Frontend
 Transport; Tue, 18 Jan 2022 20:49:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT023.mail.protection.outlook.com (10.13.175.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Tue, 18 Jan 2022 20:49:50 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 18 Jan
 2022 20:49:49 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 18 Jan
 2022 20:49:49 +0000
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 18 Jan 2022 20:49:49 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.16 00/28] 5.16.2-rc1 review
In-Reply-To: <20220118160452.384322748@linuxfoundation.org>
References: <20220118160452.384322748@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <630cd19e57a049dc9fc722bc3ec69db3@HQMAIL111.nvidia.com>
Date:   Tue, 18 Jan 2022 20:49:49 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71393477-b83a-46e0-6319-08d9dac4123f
X-MS-TrafficTypeDiagnostic: BY5PR12MB3971:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB3971B267183CE2D41140EA7DD9589@BY5PR12MB3971.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aBNNUDxvnA7HGd3q86i+85sllblds1qLBZstsBjodvZW9drPSDZwBRomcKPt4HQxbTvD++NF1J5WXJlvOBBeGW/Nzum/k5Da+3EuT0dt/NIGYx5IIFtmaWs0jDmsIbekw1kqa3YuaMNDq7EsjyY9OyIvA6ZuWokGbNFKJAtVaU3H5DTEeajhFL/hQaGkUPcjZ6zXNeLV7tZQU7WhCRogpKjDoSngv/2laZQpeHbQAdihXenRaG4xj81DRltnn/6UugEfPCy/+gtB/Ns0aL0rlP2w4u//kkn79PuVv1sLDT4fb1dSBUnDtL/dEy/yaVcavfbvLY45YzsOK+Xb7nLcGAMbJ8ZPuoRK1QiuJn2qXf10NN5rVJXWov/y1T5vqtYz4MnLSsAj012gvFn/4RB75LOueaqyqfAWblK7uEH3O67SnN265a040q6x+rh3cpdy0lDWEd/C0M8/vEDIaVaPwDE6IIT534MZSDKdVwcA9IRKKf8KjI695wWLcPZgXC3PCzG9+WhyO2+9DSfC0vZUuXUBYqj8OUPR9iHE8A7ReuPXzwEACTPdYO0mOerbBiEy97smNjwu8jJPV4NWqhdVs41WaUrPXRkhLLAdAYMfJkXmsFjUy9wg8W9jjVbpdjBR73PjtBT1rhmve+wKFxeAbBywmN5NkVWTVI+afxVc3eREq6F3kaSsxsoRtWhL9owBgwzkTbcdtZkx5+LxqtBuzclOr5H30zHeBb+pcZ3XoggL2Y+zwthoNzznCUvAsua/MUTRd069HczEVh5zVJO/2B52y6HZkc6Cens+WFMB4xGNJ3O6xY4lzejJZsTlpQWJ3GP3LicZgEOS4QiBw9C+DgELw/PFQfSGVIcYo9P+YkhnCa6RuuaOs1Y1/4LH/aPv
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700002)(36840700001)(46966006)(40460700001)(8936002)(26005)(6916009)(5660300002)(8676002)(7416002)(508600001)(426003)(82310400004)(70206006)(86362001)(70586007)(966005)(4326008)(336012)(316002)(81166007)(356005)(54906003)(24736004)(47076005)(108616005)(36860700001)(186003)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 20:49:50.3131
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 71393477-b83a-46e0-6319-08d9dac4123f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3971
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 18 Jan 2022 17:05:55 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.2 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Jan 2022 16:04:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.16:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    122 tests:	122 pass, 0 fail

Linux version:	5.16.2-rc1-g979dd812ffb5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
