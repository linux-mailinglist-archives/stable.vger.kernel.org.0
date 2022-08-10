Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 386E158EE41
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 16:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbiHJO0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 10:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232593AbiHJOZu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 10:25:50 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2067.outbound.protection.outlook.com [40.107.92.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5E81583C;
        Wed, 10 Aug 2022 07:25:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=igV0ymsEeV8PBpRGvDbRPj1xlyiCd2KW51oGhGfefN9UjQa74dCUn1Fq3LylKnvD1/8h2izLxtgZ7FOJa9p6s0f14XjjyVSw0ALCwxJC0Xr8sq+P8G7q8JpcBULCGHCuZjbgp0PuhXTQrfZRLuL6kA90C3IXZVguESzY+9hamgh/SwCiOyXogMem2LZTivF7gR/C1Ay3WJNIeYopjISU39D0gYYc8T2ChtfwdxAC/GnnUDg8NBThhjw8yvH5b3hmyu3OVWnPxjyjDS4aiSPIUJz0gpbHUPgr4abG9ZnJ9hKeb3RtQlcWKhjDyoFwdW6h4t4GI/blUQl6rqVuKKdrww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J0Ki/6g3P8R6F3u4M42YguhMbsqec3ttxR28EwG7gbk=;
 b=m7uEBN/gybyb1LFzRj0zL4oNDi8H8unsDARwbIvqV9UlmNxhMAR+T89Vra2wW96BbMI9+HdjGPYb9WjYs5vuiFeJhp9ULswl/RnMkjESA0kE1TAy3U31BX796sWZYWgXep18mCTqt4XlrBojRozbWN7utfbGVtvd/1QyJuldIL0n4hg/AdOy6O/A1AaCDE0n70EbSUzYWLj9ajo/CN6XV/mVVtV8eLw/z+pXWH8PmylTZB1BvHbsTcQY6DYcefFTCB55cJNFc5ADZsYNd6rFjjxJzdjFIsaik5vIbiKeDZrDhZnDHfqURB6PItJ05Rnfbe/hrysGwR7uhAebfE0Dxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J0Ki/6g3P8R6F3u4M42YguhMbsqec3ttxR28EwG7gbk=;
 b=sB2qnnM/OXnEptarUXdjVcpvHsvW6lLAo3B1/p713QA7NaTdM2UmO6Ngpx26tcWMUhHlMJ+vaqvh3T2UtIGohA+cY5lAXETHmwexgbzoWHsSlW+S56ZMcEKdHykIbHHqr8rOkIeNF2QTMORxt5DH4fkD5SLaJl0LQhv8Ttv6C+45D917ha4pL2BkhQJMfh3oiNVlY3QPGew9B5QRQUHFpvD2AOZePtlsV4/ovCTovxKoKIvhPC55IbedUX++rKiCI3xNllSinqEg8Vskd4PlgDKDksSgN1jOZ1Yr1ADZ0bsPgWMfa+o+9sb25vJ4vZyTh/PCkjAKctBUUh62+v9IpA==
Received: from BN0PR04CA0204.namprd04.prod.outlook.com (2603:10b6:408:e9::29)
 by IA1PR12MB6530.namprd12.prod.outlook.com (2603:10b6:208:3a5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 10 Aug
 2022 14:25:47 +0000
Received: from BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e9:cafe::5f) by BN0PR04CA0204.outlook.office365.com
 (2603:10b6:408:e9::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17 via Frontend
 Transport; Wed, 10 Aug 2022 14:25:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT022.mail.protection.outlook.com (10.13.176.112) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5525.11 via Frontend Transport; Wed, 10 Aug 2022 14:25:46 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 10 Aug
 2022 14:25:39 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 10 Aug
 2022 07:25:38 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Wed, 10 Aug 2022 07:25:38 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <slade@sladewatkins.com>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.15 00/30] 5.15.60-rc1 review
In-Reply-To: <20220809175514.276643253@linuxfoundation.org>
References: <20220809175514.276643253@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <10af92e4-3b93-45b9-be0f-e5307c0e3bf4@rnnvmail203.nvidia.com>
Date:   Wed, 10 Aug 2022 07:25:38 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92f1ee31-52ed-4c18-4cc5-08da7adc3771
X-MS-TrafficTypeDiagnostic: IA1PR12MB6530:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: koTz2cZgm3RLJw0hFa294dY/WE5YyIiWHEO11TnGBAzlWOyt94uZxQAYonprfPEiXotDP1NibSTPup2rhUFdnbU+bRALWeMUB9w+afNlKJewcgaAuQo4t4uFCvpWDGDlTMB7wc2evV4LlabvFjouVDUTDjZvnFGjs1A63fUfZxAf7cDv0CTYguTy9ZgLZj8xqIYK/8Rv2Duy8YiHZkwR/LYWJu0wdft639qBA1EKzlO9wAk77/k34h1otkzqIsnNPU5l2vOvO6L/wevKWVyi4T7oFR3jf86rTxPctxNGmpvoEfFutva/Chd+OVlTqeb258xYN0NDIGSvsC+CcXxAoRbXbBgHe9aniwYGVdhNWQHG5HBZUsAQigACf8+azz8Y9cy6UA0PAOTnqCRJFwPFzaSUYDo+M1G5qeelJwTpg+5xKf4ZNvIGAWMxHPM2bmstmNBIdhGIdsRNRIOJM83UoqDTOQLwgDMMIXwWdbdx9GBbvsgioVkykOOzzGSlf+QMiLIOYmLXzDYyTivx+7ZLvyewkAfFmQu+M+PT1U0y1+J2WIBAq/tbTCKyxduNcXt+ZVz+liTDNpl8fq4ClQblYh5tcKGrf5Ht199yS+iTKr8nEUHIO7ZFIIIMv08uwCoSyuA9Ujz3dIN1nZ6/asj6xiLj7To+oW/Yx+vzu8x9cKHkg64wIaj2IVY8l9WHsAhi3fdxOb3JZ83llBtRkTvoKRMhZCWe7QbjZoXsMY8JYK1xXp0ehcQ059dUPOzegDJB4INJxwxa2Ve5QVmL3OZIVpISHk7INXO7KRun4LlJ/4CD7mku5ZJWTbrs3iOvBf/H2O/6Evs/6+Eh+yx17rNCJUsDtn1V7qDqwASqp/ui3ZE6p2KSIFNvGwbhZR+i4G5jaZlSgtruLQHP3SM6zQGMjDm5SsrJpZ/WlYMk2lh81XA=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(39860400002)(376002)(396003)(46966006)(40470700004)(36840700001)(478600001)(40480700001)(426003)(40460700003)(966005)(26005)(186003)(47076005)(36860700001)(8936002)(41300700001)(2906002)(336012)(7416002)(86362001)(82310400005)(54906003)(81166007)(316002)(356005)(70586007)(70206006)(6916009)(8676002)(31686004)(82740400003)(31696002)(4326008)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 14:25:46.6349
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92f1ee31-52ed-4c18-4cc5-08da7adc3771
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6530
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 09 Aug 2022 20:00:25 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.60 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.60-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    114 tests:	114 pass, 0 fail

Linux version:	5.15.60-rc1-g9c5eacc2ad1f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
