Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0FF746B788
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 10:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbhLGJkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 04:40:07 -0500
Received: from mail-bn1nam07on2052.outbound.protection.outlook.com ([40.107.212.52]:18149
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229807AbhLGJkG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Dec 2021 04:40:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UA2I/55AjjU78MB09SkWj3BAsYlzdOasED+0g4AjL2Y2xqd6K+CM6upaV4ijU89TEM4S8cVHIjHGMX2Ajh18b8cxnkQdk2oOdwcDJlnDy24nm4qAWIErXIENBVmjUVgN0tdrO/xiRX3azglZKOMDB8zoPRyVuu/9vVERuuP6YQAEAF/S/pvplkBVmvbUVxePEQYWigTJ7xfrxLTGp1qXqdQjh66aHVkLVKGN/i/cMNyPjSJo9BaPj8XjD1zN8YoI/WHpgOBjl5CwYe26arD6pZ73dPHivMtLkXxfRXysj4UlODo87hxRAntx0/KuXe5EZco5/d58nKnzcw7ZuApisQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ykYlEbb2GajeFZkClFd/KXfqcEdei9XCayW5STJ9Ylw=;
 b=nHi6Ts0Mm+A0iLS/YoZKuHWDk6qbAa8C9n2RxUkZWnxfXR4IW26T35mMFeDMNT4FT5raMB2qbW8veZfcy/w7Y4VKRynX55In/Jy4plPeoILoAKgfQRV884vtIctqOAQMfI10h5FTId72YA8NB1GIrLw9gXsxwIsQ4HDvbxdmLGulMKYctzFo8t4ClTVs/I/p1Mi2DBaCv66GGJRlTkfdpqS2K/xWkPQItXIMJoZpriDlII7fpmrM25PCwAMKwRQ80ni+SWicwzK/5B0NM0wqcIHLu+wVOW5X/ONyJAHF3McuwB0SCWPweJO9dOOEfQNZ/KcYjYupMytHzelCytGi0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ykYlEbb2GajeFZkClFd/KXfqcEdei9XCayW5STJ9Ylw=;
 b=amZyoXm46qKg20r2H3tfERKXakRWXeLKJcmqbxL2U5NU0k8kTAxyxFe4vgf96WCDfVqbtgYtLPpT2mbUhv2K+8LXvW0vazYHo+074soyBtLcF+kL9PA4gVSeWYWbKaMdXjdPFhC4uaSBA3XOha7CE00vnBNX0TrG17VAKm7Xj/1GBq95BF/EUH7UEwJ0LSVM1i5oY1xq5OK6wrCDUdM5cr7SEy9IX3vcvZBtGhm1+MlEfaUb/5LLUWX3kSKJTdRmEQftZ9ychsLfWQE+V4NWcDMz7McO+nhXZp9Zf+0GiFkm0Ji+18sCrvq9oQM9vuwIZQbvMwfxGrucC53fPh/Hxw==
Received: from MW4PR03CA0348.namprd03.prod.outlook.com (2603:10b6:303:dc::23)
 by CY4PR12MB1783.namprd12.prod.outlook.com (2603:10b6:903:121::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Tue, 7 Dec
 2021 09:36:33 +0000
Received: from CO1NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dc:cafe::f5) by MW4PR03CA0348.outlook.office365.com
 (2603:10b6:303:dc::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21 via Frontend
 Transport; Tue, 7 Dec 2021 09:36:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT023.mail.protection.outlook.com (10.13.175.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Tue, 7 Dec 2021 09:36:33 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 7 Dec
 2021 01:36:32 -0800
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 7 Dec 2021 09:36:32 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/130] 5.10.84-rc1 review
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <eb0984d95baa4377a061a35dcd858266@HQMAIL105.nvidia.com>
Date:   Tue, 7 Dec 2021 09:36:32 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69744169-e7d1-4b28-2bac-08d9b9650e3a
X-MS-TrafficTypeDiagnostic: CY4PR12MB1783:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1783B6479E0A288041521D1AD96E9@CY4PR12MB1783.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GH7n/FeX6R3bo2dw3dEcQzbPI4lfxhXH5A339A/4sp1vblxoOp1k6JcqQP0UCIs6kP/WcAk56mw2qBHNNljlzqj0Kz4o9KkWQpkn9decFKkAao3SW79TlSTxdXVCiHFo4UQs0yap5Lwi5HXEtBas3rQ48MoCo51XC/4SHhA/j3K8mrLmfz6qrOVqnnJFz4wU9bnTHT3Jo2WdZkge7/018f2JjEf71VEUW2AH1lAfZpumN+Np5whNb2jwoj5irJJSd0uyFKEspjAn59m3/g4YD1M98FVuDiX6bPgWwXfTsW5qC5QCgoH3AJXAy0D8xGxa6N4BV4Kr2mPOqHVhPnHe4KwiigZk1ePuV//t14TspVHRKo2Wm8mQX68lb9B5ZyTG9K0fkPxj/ap7iuPZF4xffo6eLZY3MAjV4N/7l4pEYP1zHWDZBO04xWuA3gWksFOvxjsql0uQQbXiN3KwcZPdwaGCZiFY/G2QAf+r2ZOZyFIe9OdLHHDv+EZxoP5qUPbJyrwyE72GjNT0WvmntRaEauy6w7n9I/cpwm6KOiQBEuuA1iLC5rNHWHQ3Y5w3DHovAcreY/F9Dr9lEYKcNgF2+aEzEWR7vegrQZdutaKve++oYft6rfNLNnJlZENEIbQrA3SmzL8CELHO9xxcOss3sLe6WoUFdWguawlcEfr0ytX7AzfSH90SI53lViCm30DjSAvMzghAhLnJSqD76olgAgYAXrqslN89N3h0TFNGpohG6SdBPSY6Uu+mLAfVHqFNl0KpsNvmvOcQDZsBjE7vxP58Lw0fD/J3GH+b4cB5vrHe27AJBN4o8uVLEqaO7tBLTWfQ+AElTZ/3tWJVOB51wcVDtBrIJoHUzY0DFBDrOD77kOYlFYNEgLRpVTciX7qg
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(8936002)(2906002)(966005)(82310400004)(316002)(40460700001)(6916009)(24736004)(70206006)(36860700001)(108616005)(7416002)(508600001)(86362001)(47076005)(26005)(356005)(5660300002)(8676002)(70586007)(186003)(7636003)(54906003)(34070700002)(4326008)(426003)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 09:36:33.0070
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 69744169-e7d1-4b28-2bac-08d9b9650e3a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1783
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 06 Dec 2021 15:55:17 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.84 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.84-rc1.gz
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

Linux version:	5.10.84-rc1-gea2293709b3c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
