Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B628B422861
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235335AbhJENwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:52:20 -0400
Received: from mail-bn7nam10on2058.outbound.protection.outlook.com ([40.107.92.58]:45920
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234961AbhJENwP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:52:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=igKyGknQsCukBOFDffK0vL2BiyM+sQBj0SuYLsDO6Gj1mXBo9/HH+w3dUVrc8RK3gJuduBHdYdVq3MVSUjecutNLe7w/HW/J2rsZWDmEXh9ZratrhahpqDAdMsyYuJiN9H6LoJxMC3FNa2BFXooKrGwqrh/5ut16mNRq8n1rKE50J2Hr9OkWz1/qFUtGQkAHxNWpozxZdO0gTA+O2TF3WIlsFSbc+hkOFM7j8DfFqBgQS5krZkLQMFlRFcbEeH7RCBQbBooP/d3VxvFqZp5le+l1attS0XQhGscvmqmrV74mWgJQrXKEKmLLHD9uqBRFfS2MedU9/RGlwQJsY6WFvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SYkRDqcmw88uqRnqTtRalsKaX4XIq7SrtT9Y4fHJZW0=;
 b=nPwxAyzaC5IUrhXb3KtmQ2+BrUvAZ3oSA+dTLlfRlbq1cteuPml8DqgbwZtfLn5e8LsR106Pnq363LJN4lS4nGh2AW8lkj2TXCjmH8uaWbMK83iebe50CBw8KQSIqmK4cI0DFBvBDnD16ZVUMwHqmc3CFRZbBT7uPVKmbpiUTWwGUKN4M+2ayUQy27mu1gJBawilfVwFnzx7yhDd90+BFgaJPCboZ+oUAkcPwOFhj0DtClVci06c4toFSU3vwvwg/mgCS5GvQRqa09xhsUEQe8fzZ4ZLFWFdj36r6wO5UGOfqez1/Mn96FkmhYhXCsJk7V/ESxE1M9fGBg8FV634xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=none pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYkRDqcmw88uqRnqTtRalsKaX4XIq7SrtT9Y4fHJZW0=;
 b=o8knEHPzD/hBPxvbPVkYVqSrGSZVV2Ike1ed+BpRu9y9JfLS5Q/k0VTb+XrsMYiYOs6w2HKBGwR/Hee1DYniucKAfzOtZvSyrONlFwYOE/2/iWdzwCF1Fr/GUjdSsBDJ1WzCGzMaDM2oBhkQrh/OI1SMPlsUHgCIZnfAv9JaupN6FSulDWo0gMv1uyyYOxe7M5RdNUaylj3MxQe2nJJUKfMbt7PxNVaDEoimtxZFceEoJHKJfBLFKWBs+oZeuo1BD198oS3AOTPxKgQhYZqRwE/M9fS97ba1mdmg9h/C7/v5UtD7KBFOBhTcFE5AhtVlbdXlfuCY8s5mt7bXv4phzg==
Received: from BN6PR16CA0031.namprd16.prod.outlook.com (2603:10b6:405:14::17)
 by DM6PR12MB4515.namprd12.prod.outlook.com (2603:10b6:5:2a1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Tue, 5 Oct
 2021 13:50:22 +0000
Received: from BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:14:cafe::68) by BN6PR16CA0031.outlook.office365.com
 (2603:10b6:405:14::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend
 Transport; Tue, 5 Oct 2021 13:50:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT026.mail.protection.outlook.com (10.13.177.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4566.14 via Frontend Transport; Tue, 5 Oct 2021 13:50:22 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 5 Oct
 2021 13:50:21 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 5 Oct
 2021 13:50:21 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 5 Oct 2021 06:50:21 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/75] 4.14.249-rc2 review
In-Reply-To: <20211005083258.454981062@linuxfoundation.org>
References: <20211005083258.454981062@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <782a8d15982a4e1cac87abb701752568@HQMAIL109.nvidia.com>
Date:   Tue, 5 Oct 2021 06:50:21 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 97887005-fc54-4e7a-a1c9-08d988071397
X-MS-TrafficTypeDiagnostic: DM6PR12MB4515:
X-Microsoft-Antispam-PRVS: <DM6PR12MB45155CD8551AF08C362CCFF8D9AF9@DM6PR12MB4515.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fsZZR9gCDm73PWh7FsWq5KbwoCYV9Dyw+i/IsLdBJPEg31MYHd4h8Iovji0wZbR5FGI6LWjIx6us2w4XTwclEKPpRVVlu5Cqh6QTac8y00UfUzr6EwM19++H7a6TEL48yLq5+bzd1NTCKYNUPJinfSrdQmnPbyLetpUWrKauixWRQ6jVAxQelS28mwZ4sqY/i1u0qQBV/YG7ethWVh8NGvqM4vhP/vxo85kzeBKYivydfINUGCGswkeFToK6oKkkaIPvQYKqJbgKeS6VfVBaXjotq3aN820S+WRLIRJ8ZZngqcztpyLfd7qhdhr7TTHTxYdeYKZmXXw5/CXNTDeOGcYJmDa9nwJyyC+fZvM3WBKpx+uYCFmmqVsBAA8J4VH7Vgo6op1iirV2C4/Z+GWyXOO2JoGIFTujAXILGAuYE+FJV4VJjH6B5dXe2P+88TjxgpX86G1FPQRYCx2Nd/Twx3i9S8UnuYT65TAxjsM/GY8mfQPD6m0tANPb2BG4FutI80NA6QtoLSa9dA3NhabYy3oNuuxldmri0zF6q4Ofe95zG4FRk9yNU+QbtJtr7aOJAyDFXcjv/hDir1sOTfXs2MWk7+XX3xComSWLEQ+u3G3rdz92Zv/Gjhcj9tCnaKvYHpZq2cxNjH5tJ4DTrxu7gHJ2fXwWrdzAl2a+Z312wJTCcWSDyzSyAWMZ6Hdz/Dv8sIW/VgrdNJUHhVGbzgO+3pSAgYSuBjUVLTFRw07iqYqLpnK+LPWxlo/edKctr2bZ/RO7/JwDLyCO0fAphJBzro7vkoipKJxVbiZE/WoMPVg=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(70206006)(508600001)(86362001)(7636003)(5660300002)(8936002)(966005)(54906003)(36860700001)(70586007)(2906002)(316002)(6916009)(4326008)(47076005)(7416002)(8676002)(108616005)(24736004)(82310400003)(356005)(426003)(186003)(26005)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 13:50:22.2709
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 97887005-fc54-4e7a-a1c9-08d988071397
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4515
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 05 Oct 2021 10:38:08 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.249 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.249-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.14.249-rc2-gb56df9ef1a53
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
