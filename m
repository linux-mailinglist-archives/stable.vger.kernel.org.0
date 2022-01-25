Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC2B49BCC6
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 21:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbiAYUOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 15:14:40 -0500
Received: from mail-co1nam11on2087.outbound.protection.outlook.com ([40.107.220.87]:14352
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231527AbiAYUO2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jan 2022 15:14:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AjHN8taOFNUI6WnLtidWS1yZ2fiinvlOMUEQoXDEAdU/mUIxaDHqe0/4wuIZHNy/vjrEJ1EBUPQAGbxAarii21l1U6X+BWcVMK20K5npfj5Lx1gFGBI024Sqs+66olHdXA+NaqheN348K1gst3/p4ma9zm3kOSHqyrQAQ/6gr1j5ev+uxbKfoq3nnQOIs/ZVL09ZskBqQUBEj6NWB91e+GJfGsjZYqUvisfeMI3Qof1wpEEW0thBjsu8ESmVBPFF+19rs21VDFWr1kofL2MadScGgg4j8vcaiOIbp2YvAu05QqD5tEmkH/dNuS5lG1jSub3Rg0i6UMPClGRUILwolw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GdkgYuTHo0h54VtU2B2aZjvURmApzq2C6fgrN5FpHc4=;
 b=SMNqCFQIRlvvFJkx1Gex8p4ll1hVeC2v4NZwvVnk4DeUQYFod4FFFf2mlrFnRl16x7EEYHt4KRRKOGczZP7q/IxwMOU5xj0f209wXoXyjAgzK29gM9mB3N3iu3E0kmSXOYpoFRTu4FHFaBY/D/8MrZA6HxnvAs1heVrjpkVvcSSHeMzfgT6ULcPn/VuaBNyQ1RQAHUa5FJKLlan9e8ZIJawCRURcPULiNKQpBpkDGrR57JiCJkp6z3Cta28A8XxufXukQAhMuHGZJ5NpEC8OCQuclOwkGgsNrEp/DB0HG+pYWkFmPHG0ByQSF0s5KC3B83oYCN+bhQXXtr216J9mMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GdkgYuTHo0h54VtU2B2aZjvURmApzq2C6fgrN5FpHc4=;
 b=WtOVvpKM2VT/6WEjfPPDHZZhqLB6IVSv04G+XchVapscd+N1YwWynbF7ly0cqemLY2dNuosODrRSrS6omPFneozBV8H6iLERIK8R2UqozMkcROU+ipNcxKcpuWEJi8FNexqiN4xmZkzAGm2kBo0Ny0qOa/d9iB7dh17Se2kAoAi0euJGulTrckVQr1IUxcpTe3jiTijyI7FQhwf7HmBnqUGyMmQWPaEGq1GA+RuJcTuh1U72zijZVomQjRT0y3UoGcoQW9WNvTH3uyqP2fLmfZPYrKTYDl1JCtGS4qKgtNgJy8DJ4h9vpZ1GOoGrPf/bpgVeqTGQ+2AiD2BWOnx2gg==
Received: from DM6PR08CA0045.namprd08.prod.outlook.com (2603:10b6:5:1e0::19)
 by DM6PR12MB3260.namprd12.prod.outlook.com (2603:10b6:5:183::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Tue, 25 Jan
 2022 20:14:26 +0000
Received: from DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::41) by DM6PR08CA0045.outlook.office365.com
 (2603:10b6:5:1e0::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.11 via Frontend
 Transport; Tue, 25 Jan 2022 20:14:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT045.mail.protection.outlook.com (10.13.173.123) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Tue, 25 Jan 2022 20:14:26 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Tue, 25 Jan 2022 20:14:25 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Tue, 25 Jan 2022 12:14:25 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 25 Jan 2022 12:14:25 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 000/155] 4.9.298-rc2 review
In-Reply-To: <20220125155253.051565866@linuxfoundation.org>
References: <20220125155253.051565866@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <ecf61d46-3cac-4e34-bf66-5cf47fc6612f@drhqmail203.nvidia.com>
Date:   Tue, 25 Jan 2022 12:14:25 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3647dd86-d2d5-419f-373e-08d9e03f4925
X-MS-TrafficTypeDiagnostic: DM6PR12MB3260:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB32601D91A5EF61E8F37B4ACFD95F9@DM6PR12MB3260.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /+JXC0ZDmQsy6mpQJhUJGNtNlNE+NBlwbme1VZl4Bgb1UdkbV8iyVkzHG+BEbzqKyBrBPD5S2D30aMze1HfvtMkPfgzy1F7FHgAzeoopgUHurAN14hAgZKl6A5hPqq+xsvmrG61rfYaoF1STU3zW6F4TnIsI/XlKCFnwIOsJsI0SkKeXqm6nd0az8iHA4jheao5iYSAfYcw30Eh/8lZpM2E5npwft7rNrXsTZ+TYgNdOfVHaAhA8QnWp486EtVIJk3pg7WYsED9H7noP0ZERKeUTT7h71IPNMmGSTrlAZoWW1HMu5zIEZ1xyfrmA/byJjm9Lc/minE/Enfuljs9TdnHbRjLDCUibfm+zhw7p9qyL5Bi7PIgmLGxnRZV87aNJPCMhb+/1Fq51524OCrpgRXQyoxlxTdtZmarfYaEqP6e6odUaXh3EShhxJDAtL2qxg9404youW0nDNm8uXiqj3HhTGztFLrHpu+jbNiJS86aCAbblnfFWYI/bgbe/sYq5oBj0LRYkNsVBht/JgZnKoTVzWC6/JfXWMF2iBmyuSJr7yj6eUBgoWItpJ69sNBq8LHSxl1w/FqXn+y8Mq+F2gzA61ncTg4fo86wFWBqXvFvIXha14Heg2sCPFv9lOotpB9mF6qmg5XgzZdTzMD/p0hTzsAb/37N/Z45Oebq6eI/BM40WSINB2D+JCkEmFPEY+lvf1VYk5li2R9ZS6E0ZN79WYoAMBTd+KArfbEATvnYNPec0vukSwF+2kOO1SUw178Re1svV6R19ne7TJEaSkv3XiJZ0yYCPAhbFRjPNj0wCj8VI8IbckG0FE5lPAfg6F+yUIg/9Z+iN9yZKc0HiIQcXSw43jGcnYB5+doXtL/IEKqlFxOgQUxNSvdIHbwCDXEj5EtebAHxRKUEGkXggrg2lmNfdUpz7xtfRANfio8ofWVtvnyApjPoy3XyO7El6
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700004)(36840700001)(46966006)(54906003)(5660300002)(26005)(70206006)(7416002)(508600001)(47076005)(316002)(336012)(4326008)(6916009)(31696002)(70586007)(356005)(2906002)(426003)(186003)(81166007)(82310400004)(40460700003)(36860700001)(86362001)(8936002)(8676002)(966005)(31686004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 20:14:26.2966
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3647dd86-d2d5-419f-373e-08d9e03f4925
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3260
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 25 Jan 2022 17:31:50 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.298 release.
> There are 155 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.298-rc2.gz
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

Linux version:	4.9.298-rc2-ge1c2457686e4
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
