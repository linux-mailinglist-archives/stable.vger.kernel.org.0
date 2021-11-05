Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08D74462A9
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 12:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhKEL27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 07:28:59 -0400
Received: from mail-dm6nam12on2071.outbound.protection.outlook.com ([40.107.243.71]:56672
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232409AbhKEL25 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Nov 2021 07:28:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JIJ4lfKJYCZfbqZ/hSeb0YSdRGXTVIiTwtz2Kyj6bqKh/Rynlep1pnbuUlgxNrib8xivesm0pLzDuKFpYk+Mcp+i1xYU181sklAM3OSCR+1HLGzThLGSBWasmU/yj5kKifYvZLc/tOLfT0V9r7vr8/iaXF2IIesDOZnvXsSNNkYPtWwdKAUORalK2AvjOzM1l3O4uLr12strl2vYNLiJa2P6/b1Mpha++7+OxRHv+EEDRHbSJUiWgrVOm9aOrbP8i6yLSvZYyIz2M2Fos024ZOmPqZCSWZ1I9521SBHewInadZtY3Kec+88vgA5acaOEaOCVFjFrqReG1j1GAJXXFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9sz2NGN49jo+1yqzSy7Ch7j+oYcYfXoMufyGtS/+ZK4=;
 b=IENrnHSafbX2ni4joZHXQLj3eJ9AaMTi6U/RGFnjVgR2fyekLr6ZQQH7MygT1VxDgdOkXGhr5Gb5bk5nzqUXiJUfvPv7DYsJnCBpEbXNTXEucL1qs1JMk/UDN5UICSshzxKEAJtUt7NJ3BmftDJrFLbqY85faDAJ93NZmpEysZy4tYIaOl0VFZubYpwqSO8hWvjjnh4G/Q2Zb7hXt1+WDA1l2v6b2TSGTpYOHO+k+PCw0LWpC3FzB+YLYZMGidwBNgZGnfcsmG+r4MC55k6zZ2pLLsnoRFkTvkuUnOVpmy65F8R6e/sncaUz082LK3UdwH7ua9AxEhg8yHe1zkc1yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=quarantine pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9sz2NGN49jo+1yqzSy7Ch7j+oYcYfXoMufyGtS/+ZK4=;
 b=Lym0ghaeDLVSLdxYsFQl92awTSm6vVmM2z6mhYOlx8Hz46g0/A5Z3QDizLCdfvpDwiQHXiFUQKTFuRVhlQr0FGkn/SLoqud0kcWJ40aOQUCcSzU/SJGaZl6yTZhBN9RM2zXtdWlNZuHWL5oxSEK0wGPaKTUpN8wXSEk/1QCM98NE5cmgzkolAbcyROHBJ/HBwnf0tXFv9P62XcecDJj+JaI5zDLQC+7eg52E+/r8zIbA6yG2aukWZHSa+16kH8kekbhzcxguhokdmoMqUZZfdSFtmpzB4mwI0hddxj5jQh1vJ1DY4FeZgpPDkfgfpsNdH0hIyqxLr66nWYVzO1+LCg==
Received: from DS7PR03CA0105.namprd03.prod.outlook.com (2603:10b6:5:3b7::20)
 by DM6PR12MB5550.namprd12.prod.outlook.com (2603:10b6:5:1b6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Fri, 5 Nov
 2021 11:26:16 +0000
Received: from DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b7:cafe::2e) by DS7PR03CA0105.outlook.office365.com
 (2603:10b6:5:3b7::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend
 Transport; Fri, 5 Nov 2021 11:26:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT052.mail.protection.outlook.com (10.13.172.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4669.10 via Frontend Transport; Fri, 5 Nov 2021 11:26:16 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 5 Nov
 2021 11:26:16 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 5 Nov
 2021 11:26:15 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Fri, 5 Nov 2021 11:26:15 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/14] 5.10.78-rc2 review
In-Reply-To: <20211104170112.899181800@linuxfoundation.org>
References: <20211104170112.899181800@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <b0ccf61c80b1445fa18c338b8d59db26@HQMAIL105.nvidia.com>
Date:   Fri, 5 Nov 2021 11:26:15 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2252b322-6c5f-4da6-615c-08d9a04f1513
X-MS-TrafficTypeDiagnostic: DM6PR12MB5550:
X-Microsoft-Antispam-PRVS: <DM6PR12MB555037B7F605D9F49773A84FD98E9@DM6PR12MB5550.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4YakYoA+QfILIQYwsgmuU1GfWLGHv9S4zmzWS5sYf18dHYEc3bzIxXBsK58xRdU3lea08WQwQGtzre8uij9nJpLNnQPdQU15mww8aSEB84z89TOoY5dpDDE0VRRA4EuA6Gy8/FAi6/t3qw3ejW+iwiNR89PPfVOZSuM4X4QPRN7HLjx3hMxrMvocdZSFIgG0D8aJBviQsT98k/X/BOnR7qFrs7XlRvvqDk3eek1gJWg8tkx1G7SHUJEny9UfaEw0Je8aJ8HUQKgdke/mJhp/AGVOeGHZAfIE0ltuHQBHygyU20az3S6Y2238ktmhbHdTit5lZJOireQUpxuldNZBpVx/qU8D2Ax/yhWHarMpjM5aw3SOQseyOqu13zXX5wWYNOW+f1oEGBHp3RTIAHBLMOQuWIUF+0MKSf/OCz6+MqFHZBcFfYnYoMdqxC1BQUYJu5szELQxDvyGQ47qf5g7ivi8qjHJZqvEyBBbvTzjRyhldA8iWbT504qAjhBuq2RbIyTcNzWXBWgZf90jIzEM8ujFcpfNTKakgAhoMBQTASaXGirc6CBEsE8p79l+Gt3KPTdkDeUhlgZWGchUnNnuk8XTU4sAIgU1Abe7Q4Y0B85Fp+tmokuI49o2OqvKK39d6bwYv93cdiC8tN+443PSds7YdYeiRGk2XqiDaxNzQdoxBGzQXbr5bDoM/lVms8K3hqoHCY2ocTXuDfGvySIIFo4xdHpC+de0JpMtMGhEveNDpAc3SduXvbP4mpcJBNjgtgaaV5j4wzsGO8B+pfdccIVHgBXL3sQEOP5OlXGLUCA=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(5660300002)(186003)(336012)(70206006)(54906003)(26005)(86362001)(426003)(2906002)(70586007)(24736004)(108616005)(82310400003)(36860700001)(36906005)(8676002)(508600001)(316002)(47076005)(6916009)(8936002)(7416002)(966005)(4326008)(7636003)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2021 11:26:16.4948
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2252b322-6c5f-4da6-615c-08d9a04f1513
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5550
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 04 Nov 2021 18:01:35 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.78 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Nov 2021 17:01:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.78-rc2.gz
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

Linux version:	5.10.78-rc2-g2bb5f9ae86fa
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
