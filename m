Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF583DF0C3
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 16:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236532AbhHCOub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 10:50:31 -0400
Received: from mail-dm6nam10on2059.outbound.protection.outlook.com ([40.107.93.59]:46721
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236554AbhHCOua (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Aug 2021 10:50:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WU61/qMcjwk7J77pqeRXPxnOCtKZrCvnuJnTuHR46HMCabqNV0y4fSYt0iEd0nVtfr/Uw1MwWZpTrTRNwj1RULXOq1wWsGMcvEc9aQGYQ7qxjgARW1Zw1mhMwAwktT68Xe7cO2WWlUMnuq20cx8L8JnJEyJZnmyjWibscqqN24hWl5TdRH2Go3MinWI83tFFPkDgAMpsIT4hCFzD8n3oHuDd7bQI5TTEhAlGuU/LgA+I55j7EhVxF8pMVyg426tDiGZJ7CnafOkiaPdZ+ltKws+TRcDjPO20fSrqvOd461JLlIgZ5mevbA7ikXYsUl7OIy6jK2twZ5icBmn4NwYqmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FQf99G50cMUSxCym0YJKEe/oinT4fgzf/O0h1MagluA=;
 b=Xmxjmp6njyvCAzpXdVP21jnVojLujpZTGy330kgYnNGC48WtuvP/FxefkWHIEvhr5pdnu6i2amqsa+8NzFwyu2fQ1EmKum4q1udMbGtRI51gJM9BC0l7SR3UZMz/jOZLgA+beB62ZUk2nc0lA+OYo75/LrtGr91GCyCjbYa7w6OLkx8mB+3JmVPk1kZbLU4LHqfhOxTKcZgdTc2cKk72zX0nY49yJ/v69p/GyT6FBOU4qPUcqb1VxgKQCwI4GOLcVritxPeYqMtdv7ZKTTEJtvZ73oFZJw2Onxe3vqFjzGm/9oNGqWGxBSCMjxqRDg1pJERKL+jXMqjCZdr2P0j9Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FQf99G50cMUSxCym0YJKEe/oinT4fgzf/O0h1MagluA=;
 b=fKqqIC1MJnhHbPhreF52iyYIGm0sb7kyKRdzS638j+rLNaAS9l5IBNEAQmDdRbCHPmdpIkCMKL0Ea/R/rOCDIH2Gsn2Hhck6YBT694tqKABR9Hj5pR3rxdB6SKfYDc92sqqGXcQfcfWY70pfelSxwRuGBp5+VFzRJbmqHDVlYnH1YtH5enbYcj8hdNWdLi5fUZtVG3f+ekp62A4/qj+ue7vnICawMdackhJmVYYGwBGJI06IjJ17lRaj+2xKqrBj8701fK2wBUSeO9vKRJxZxl+6XauEHCKm12tsE42pL5M/T8qO4Z5WYUoCrZIPx7n1feOHOrDVlvEiWwZYkuy/AA==
Received: from MW2PR16CA0002.namprd16.prod.outlook.com (2603:10b6:907::15) by
 CY4PR12MB1224.namprd12.prod.outlook.com (2603:10b6:903:39::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4373.25; Tue, 3 Aug 2021 14:50:17 +0000
Received: from CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:0:cafe::46) by MW2PR16CA0002.outlook.office365.com
 (2603:10b6:907::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend
 Transport; Tue, 3 Aug 2021 14:50:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT066.mail.protection.outlook.com (10.13.175.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4373.18 via Frontend Transport; Tue, 3 Aug 2021 14:50:16 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 3 Aug
 2021 14:50:13 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 3 Aug 2021 14:50:13 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.13 000/104] 5.13.8-rc1 review
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <da6a42a286d9475db80a2a784a235cbd@HQMAIL107.nvidia.com>
Date:   Tue, 3 Aug 2021 14:50:13 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d6b2a54-893d-4c80-5304-08d9568e020d
X-MS-TrafficTypeDiagnostic: CY4PR12MB1224:
X-Microsoft-Antispam-PRVS: <CY4PR12MB12245F5EC6ED1C22618C36A8D9F09@CY4PR12MB1224.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T4Ca2U90qSs+PJwiUglnOpbZryX+/00JtlEH0lat9YoSm/c/pMeJPHHx+d98As4e9YsICHxZR5n8CZwE3B8facaGwiG04nMbJ07s3IYDV5gBDaPjS7fE36jX2/Fc0DPLqBxiA4ZD3ADLiGA7PdeZ39WM5/fdjfbxKCS/YMEDFCFAMHeLxJEwGCRGcyHdzBkMm/VSyNW3dSCXPjPtjtqxUm3UCEgelBnIaYj+i2GcKD9DcNmkukKC0nJ+FJ6lxmyMVI42al9C4eev6CdxQWIxl4+B5NWJmCbFAClB5N8A1sXlh1aAWGwr9tz3ggOIZMAozrKJok3u7r2hOa/4xps4fTUePhPqLaMszsmbQcES18JUOmtkNTtVhfc3M3CPIYiiW0hiCcssszEyx9m6hQ6rc959V63Sm7BxDvtHLoo18xaITi2VED1BQYZGeJdtLWC2YQpfps1e1aSQgkgS/lFYzhCWVGWTFQ6k1LNFsrSjJu/tbDnzcHL4wLtt+JO7katjt4O5mgDraMvrfTOCOCvLrxKvFD9Ykvn8O4PJj99bSOdm7QLB1Tf5kZUpMsqX+U0BzLjoKNIzbwngLVMN0mVPwvcTOKECYNHlXQtn0KTFGwFuSDZpt2W70KzF7hWUZ8YWOQmNVmH9xE7jqwV//ql0yu8h31QGqognR15KqohSPwj6S2gSJvwynQEYszwjIRh7x9PWEYM+CHyYB/C6Rx03FJE+O3gNillL/6HvzgqltTrdkSkZRff/nMcKilByADaocSlIqVoYjRaza4yf7wl9ZPN7L151PZDhfhnzGFgC3IQ=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(36860700001)(6916009)(8936002)(108616005)(8676002)(24736004)(7636003)(966005)(508600001)(54906003)(356005)(7416002)(4326008)(2906002)(336012)(426003)(82310400003)(26005)(70586007)(70206006)(5660300002)(36906005)(86362001)(316002)(47076005)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 14:50:16.8418
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d6b2a54-893d-4c80-5304-08d9568e020d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1224
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 02 Aug 2021 15:43:57 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.8 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Aug 2021 13:43:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.13:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    110 tests:	110 pass, 0 fail

Linux version:	5.13.8-rc1-gcd55ef855022
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
