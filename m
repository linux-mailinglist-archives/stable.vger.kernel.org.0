Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D75378E63
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 15:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241893AbhEJN2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 09:28:42 -0400
Received: from mail-eopbgr770071.outbound.protection.outlook.com ([40.107.77.71]:49764
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241029AbhEJMnb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 08:43:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ULFqVpEl4qhgZR6uITyuRsDx1bBOuMYoOYTdOvWhFr+FkKue5wxyAEtM4l2+GZES/vvOTpTY6LbX8zVjsgqSAQHM+GJNIlz88eV5K7ITz+eDKGv4jPsZGkFDTLEMpmR8A5nxQ3lY5eNzVXUM62+DShuhvxfTWBgDytTkCldMQH131+tGKxV0Xg2grVdyzMyY8wSikJvg5AFlo0g35VMpTJGqga/gHQyHrSpu8id3NoY+Nvg04iM2a5z3d7E5E4LkWWrm0etRELyIfGDPsAVOCeqwPc6MWrqNMYIkacP83n3ctyjCknhhp9T5hpuglTmX584t3LOA3B3cHL4R8fp44g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RVcvw1bjMzTzN/Zre8+4ZpD7mmBx3Rng3G87GAyq74Q=;
 b=iaItXPQqNwaHJK/7VPEsOzIFhUlafo266ydhl0bEmt59eKyvdROoMyirW9UzGGE0nGJbWi7xAm5OXrrqvLmo4yeGUnMv69aKCudeMTz8aIAQg2lgndAmL1FtdWV19C14V0MkURWf5HxXkVjNqpZhnwUidQ4/l1nJVjGDPrEAyJ+g68v7BdrY1EXjir7IjJj54m9941KbkL2WA+TlK+Ee4N3X5XaQ7Ky27IQb+wy0AFHxiSEjpdizLytfKsOWnpT/76ZCEWnTTwpPh8u90IA2hT5EkmUo6WRxwjI9rxel5igctciUgbGntgeumOhpk8GAq6SVWQz36g/gWkreG3i/pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RVcvw1bjMzTzN/Zre8+4ZpD7mmBx3Rng3G87GAyq74Q=;
 b=btZ4eqXeXYZb7iYGd+ef42t5yO0PQ5jrd3ztICtItrRIfgrVl2YUnr0o9nJXBG76o+QxCz0byUDijFeA6n4ccROMb3YHfoMUSUIqi/sbRDy5qYII1+n6NpqIWqZh9hFzfC7AJ28WHc3P04xjmIAxa3S0q+Vmxl55oD6xASrY4BdN3YqH7469fPDXWUdWjW9ysavVJPJRCtqBxplzzIVYmZiBFySIwQ2DWgBen73crocA8OxgbLdtY8qa8uXVn5+ej7u0V1Zv0M7pBdt4hyT+J6nnZ5srJVuj1U8gqYXrNrRdZhWTYg3t34X7Gatw5KmtoOiHM3Fjek6widre/nMCCA==
Received: from DS7PR03CA0233.namprd03.prod.outlook.com (2603:10b6:5:3ba::28)
 by MWHPR12MB1326.namprd12.prod.outlook.com (2603:10b6:300:10::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.28; Mon, 10 May
 2021 12:42:24 +0000
Received: from DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba:cafe::c0) by DS7PR03CA0233.outlook.office365.com
 (2603:10b6:5:3ba::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Mon, 10 May 2021 12:42:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT037.mail.protection.outlook.com (10.13.172.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4108.25 via Frontend Transport; Mon, 10 May 2021 12:42:24 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 10 May
 2021 12:42:23 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 10 May 2021 05:42:23 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/299] 5.10.36-rc1 review
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <0aa5bc7cef3647e79ecb815aec571121@HQMAIL109.nvidia.com>
Date:   Mon, 10 May 2021 05:42:23 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27387589-0c32-44cd-e207-08d913b10faf
X-MS-TrafficTypeDiagnostic: MWHPR12MB1326:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1326374CC5D77BC99CD9D7B9D9549@MWHPR12MB1326.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hyVVoy6fhyOL3ZIb465JqTIDQUNnzrS5IUT7wwoqb20Ea4Gn+RFZ5Gd0LzWARgPlAWmx4g2/kulFPdx4a0mTXJk27oY7hqgFcOUpVe79iOUo7fKamgzCMrKC8triE2sDnJksOcIECKSBvu5FLvMHRwcp0aiCcQuWtoKqepL0jgqQQQfv4gWvOCLu0OywRqeysbSYM66tivBqYtMTB+6A5WqogDdyxfrI6IdfN87S6LrmIFJPecIy7pgmreBZ0zliMpCagj2+eWGwxO7KCJvLtEqvauQWelOVi98MTD3Z7GVtgj3AO7OhnkcA2McCFjVxaOqPqT2UC3+nfGJHKFjsrGiCHTewbRnalmMhCZA2m9Rr0+0b7SzCDZXavaNZOoLFiYiwwmxYrbmYs3chAdM3uLGo2UFFojA096VYnSDfhQOyd9alqc5FdWqYElMUVfozziBqtC0V4HgrFn9UHG9vVTlJoYd/k06sMBJIVacsFBb6bpHX7+XN9CY7Mn7CcmPOYS1bA/gFgzd35zWOFOL3PsuGeSQSBqnIdnl5v7c9YwaYyqHY/aEk0ZkoDr7zExXXEsMIGmexnyjqGs6SXgVL9ilUNFVGGNv0SH2aJCNIi0OOa41TYkNKaPVMSFoJkz6q6PGvfBUJRpx0wqJQzfcu4aRssK1V2ddNfilh3KZ8owIjJWu0wTzh5Zbz8HgH9cObBGO+K6XnCbNF8HvfxfY3fW27K3R+Fym5U4h1l/L/LO0=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(39860400002)(396003)(46966006)(36840700001)(316002)(26005)(36906005)(426003)(7416002)(86362001)(8936002)(186003)(36860700001)(70586007)(8676002)(4326008)(54906003)(70206006)(6916009)(336012)(966005)(478600001)(2906002)(82740400003)(47076005)(24736004)(108616005)(5660300002)(7636003)(356005)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2021 12:42:24.1820
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27387589-0c32-44cd-e207-08d913b10faf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1326
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 May 2021 12:16:37 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.36 release.
> There are 299 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 May 2021 10:19:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.36-rc1.gz
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

Linux version:	5.10.36-rc1-g4edc8f7e8676
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
