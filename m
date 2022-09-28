Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42BC75ED785
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 10:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbiI1ITs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 04:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbiI1ITp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 04:19:45 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4A12707;
        Wed, 28 Sep 2022 01:19:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ATDz08LdFg5ToFSngAgEnTwylQQXaVFn86RgNe8pLyzrCwACzTNRLJByPrJuE6rZVD9x48r6FMdgW6D04l9I0Cn4iB17zZR9AMCUwFMDURmLIZNejQwt1G3BFnaBf5vJUCaQgmPfIL20L3UT3s7lUFhv2hcShtaOKbfOoBQr86jTFGpux3YxOpXQ4Gu9sG6H2/zalpSnqUZasXjg4/oLF+Q4x0ILyiEgZ1n16dTgSv1BxksIWNc8xAfdBX6noYGdvnd4JDyIipvBkxeKdKUXK/WIAxQ255xVM5qjlpaLBzwBstkHohPpLdBAf6gv5818i3h0I46lqaVM65+HUmgTyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zRJ5PJiLETXfmGjmLaCvls7MnrTy4L69dEqiv6Y9qes=;
 b=m2hUdqwK5ebaL5uCupb2EJ+lv9EEOl/TLH9iOgTWUVtc5vP0+gPJAxGQnNMI1f4ZMQ8PJk+Q4rKbnzYqAnu5Z3aVwgTUr9traA6rWtAORsxMrD4/vT2ldM1EfKpDlKZz4UgkPhcj+0UaVsvmeCDmGn/yC4uPCEHKhN3UHLIjGf4b8ejWtc3OohcOErXHOB/ItGkKT/OGbkt0yTYNIv/0yMqhbE9gB07xlRGCDY6mBIFFmSocr8pmNsPzCDOarL84q0EU3W1F485zzNVdh2o0xjsi8LHbB7rZ94+OCXeMiam6Hc6aDaPeC41TvuVTkJZpd3R2fZgMDV2/Gy0LA7VKBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zRJ5PJiLETXfmGjmLaCvls7MnrTy4L69dEqiv6Y9qes=;
 b=WX/FD8zVX5bpDiCW3sL3RJ2RnKzZHtCC33CSDWdkG7rdnBNTHGx1b3w8N6aiSRJWygpEPDLbUXmCkqYuzTgM1frCN8E7niaKWI9x+gBV+pDKqT5K6IIi+ZpGEkE35SkZr8/ftKnrbdz94/CszoAuEvw2Adacbo45nx7KY1LWXr4H+SfjDfY5m2roGrDZL5l16/fpcu5W0JYKQqCfIblQkFm6DwFEk/2LYH32UlJC5bEyME9J6AYFb5OtYMCu0CSc979dvNFTHzwC9vCwex1GIu3k0sxul70Y17CEaloSiUWn3kxphStP+woefCTyAZf8cfh+3AICsapesU6yfuw8NA==
Received: from BN8PR04CA0043.namprd04.prod.outlook.com (2603:10b6:408:d4::17)
 by BL0PR12MB4851.namprd12.prod.outlook.com (2603:10b6:208:1c1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Wed, 28 Sep
 2022 08:19:32 +0000
Received: from BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:d4:cafe::cb) by BN8PR04CA0043.outlook.office365.com
 (2603:10b6:408:d4::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17 via Frontend
 Transport; Wed, 28 Sep 2022 08:19:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT037.mail.protection.outlook.com (10.13.177.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17 via Frontend Transport; Wed, 28 Sep 2022 08:19:31 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 28 Sep
 2022 01:19:16 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 28 Sep
 2022 01:19:15 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Wed, 28 Sep 2022 01:19:15 -0700
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
Subject: Re: [PATCH 5.10 000/138] 5.10.146-rc2 review
In-Reply-To: <20220926163550.904900693@linuxfoundation.org>
References: <20220926163550.904900693@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <fe640365-cde0-48bc-a117-36baa04cc317@rnnvmail201.nvidia.com>
Date:   Wed, 28 Sep 2022 01:19:15 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT037:EE_|BL0PR12MB4851:EE_
X-MS-Office365-Filtering-Correlation-Id: e2a027da-8df8-4396-cdb8-08daa12a2bc8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LM5n34/NzwJtJgme5hRhqFwnORvhV2tqc5H5/PrqcOUAm7qXg75A606NYsVofhjyGhPcSwrTFbzOCfaa3jD4LlP4G2pGWwRCAmU2ndaToGsRFv89RZH9y+bugWAF+mzkuOmg6Xf/VbHUlpoZmPOa8KGmM/WJKIa/b/TLQJRBhdtEEt7gjB0IaKb+yBslrkDEhEgxSuCS1JWJL2QcwD+0pr+ZhYZOoIb+v/QIdhDgPwC9X5BDTr2dV3xx1t8yj8JUrG1JMU1evONf7Jc15AQ1vvvVwcSLm1BByoBOxtvPKUcsFdXbzeV9S8DMdCMXkPFLlBLeT80q7P3njyYKLc+8Ws6mpNpjmx4+xffyl9RIZfP9J67gWHxkVQFz/L18SD/8IhuEOgXBaoB5kJ6g64K5DzsAXyDc3VcBrilp2oiBsNELGzTh+gpOCWi5Fa8wk8Ntdo9M0Cc+la3+ADTYhWrisNsJXyt2WIXjE2qu1cK7d/PzRrcSO5AO6hTzqOb7BFo7uvNMJlnCoQTsKPdB+WGsAR1tyZhQhEynu3uhAXMAihnDgSY6Carm+TQ9j0pps5mmczfVwDUg7dSaQTqmp5ct1a5t+1I5kW+AUaMJSzIene79GLhWi0ZEw6ucpJAZj27tg9FLr7ZJ94VEZOD/XZKrUn0X1ptjK30juhvQaR6KcCvMye4QA6m1WgZ3UnuhoXb04swkfCRqyjSNGWbRuD+K655dhd2X/zyIHoWJVIEezkS4AlLWySzA4QA9G1SObR5oR6bXIgO7j0hZ/eKJinyggAQroqkoMo6/6QdFcCQ8hGbZUrh71hHY/y0Y1orjICuR6Spd3OtrhUePs/8W/M8qtM1cUhqluc6ZXpl4WTzpsug=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(39860400002)(396003)(451199015)(40470700004)(36840700001)(46966006)(54906003)(6916009)(316002)(7636003)(82740400003)(40480700001)(356005)(5660300002)(40460700003)(7416002)(8936002)(31696002)(86362001)(70586007)(70206006)(8676002)(4326008)(41300700001)(2906002)(26005)(426003)(47076005)(82310400005)(186003)(336012)(478600001)(966005)(36860700001)(31686004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 08:19:31.9750
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e2a027da-8df8-4396-cdb8-08daa12a2bc8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4851
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 26 Sep 2022 18:36:58 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.146 release.
> There are 138 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Sep 2022 16:35:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.146-rc2.gz
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

Linux version:	5.10.146-rc2-g2b148b97fcdf
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
