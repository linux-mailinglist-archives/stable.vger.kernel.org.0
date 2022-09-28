Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C90D5ED77D
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 10:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbiI1ITc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 04:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiI1ITa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 04:19:30 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20604.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::604])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DDCDFD;
        Wed, 28 Sep 2022 01:19:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R4qoqcsEpbpkIxwagQ03+B6y18ccyWE0ckthw+wx3AL9M6ekRHCpTlCXMWCiMuyShYaqppBK6ViYQ1FXW5mdJ7Pji7Rr7u2O40BzI5HdTrW1531hxWHh86s1klttgrA80MqG5j++pm8lv3sZTEa6Hs+UEhSpcD9dRGHkOWf+NPRwyfehrCZ2+dDoq2Wd7d4NFWOGx5ziPctYYEoFFtDqB+jqYnyoMd2rWUQxz3fl8JW1Z8yMk4GR5wUChsh/Lzd9eVzfrfDLkn13bjfNgLDJ2so4x9Tm3CruIrppKskRQee/zjbSUWVF8gubY1UgoPS3HRFq4d167P31Vn1loDElkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c023h3If5IhLiM2FYHoymbV6U51oyZjTe1jRGpwbOFk=;
 b=aH8AzZ5qg9f+4SAQ5zkIP5/k7vhm339fO2VYwDolgr0lk0kZACTWcYp81kkAHyZV+6rMkTS54IZoxs6f//5nyN6a08QeG44cTmrNU9jQdb+Vfdq2otn4T8A6N0DhGKZcRiWzxZ9eOtt348T4dsZ7NeDjFSXPo2n3RT0ussMrony7opM5F3E480mJoAdC9a2fCieh7iUxI27+NM44LyMO+o4VJyaJ1eqDcJO2OPbLuECc+iqy1aKdfBhd07BZsLA+MWf7G2ZqaSG9PuEWe0sJAj/yTJC6XyI4KALrvuggQLFvUgZ48so8SpmBZrBH51wSHbAffokXxlx6RKkcwn8Rsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c023h3If5IhLiM2FYHoymbV6U51oyZjTe1jRGpwbOFk=;
 b=sQvqTnWYzbpQ9uI7RSAouTCD5fYW1T66FyNG57vh0CsJMttdO4DxGRWxJhjTu2MAiFWeVanP0oDS7tZWtDr3P3WjFCobdtxPtZX4S4V9TpWu4K8H3QjZSA5eP9roE8s7JoSrMHSL8Wvntu2rfLvbNw3qG7XyzzdD7J2OZXCcPLGZye0w7OiuimOL6AHw+Lj2lm1liHzI+7N4yA3rh8uCaZa67peCyhLn7r9B9IA86H+bE7m89n6SkXfOxRsSP/KQyK75sCUTlCspP1npoTE8Zt4QotyIO9VHsMxuUHmRrPCbkhJzlnEenN48vVCwyl6T67LyPUYz+yjrpsA5l4YRgg==
Received: from BN9PR03CA0283.namprd03.prod.outlook.com (2603:10b6:408:f5::18)
 by DM4PR12MB5769.namprd12.prod.outlook.com (2603:10b6:8:60::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.24; Wed, 28 Sep 2022 08:19:26 +0000
Received: from BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f5:cafe::f5) by BN9PR03CA0283.outlook.office365.com
 (2603:10b6:408:f5::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25 via Frontend
 Transport; Wed, 28 Sep 2022 08:19:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT036.mail.protection.outlook.com (10.13.177.168) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17 via Frontend Transport; Wed, 28 Sep 2022 08:19:25 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 28 Sep
 2022 01:19:10 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 28 Sep
 2022 01:19:09 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Wed, 28 Sep 2022 01:19:09 -0700
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
Subject: Re: [PATCH 4.14 00/38] 4.14.295-rc2 review
In-Reply-To: <20220926163535.997144838@linuxfoundation.org>
References: <20220926163535.997144838@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <de92cf5b-884a-48ff-84f6-0af3e9577892@rnnvmail202.nvidia.com>
Date:   Wed, 28 Sep 2022 01:19:09 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT036:EE_|DM4PR12MB5769:EE_
X-MS-Office365-Filtering-Correlation-Id: d23240ad-c6a6-4d19-bb56-08daa12a27fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cP1izICguYoTTlnm1H/q0njQILlpTY2UMsSOIewgIBtZiyIdQA0N3rY+J463VG/LRPJ4pPggyAvZDT5tv7k1tb6MczJ0EUYDOcHpCcvanapgmIhqqFCb054BKYelOpmcdkgoBJNiVQBKcJsVaA2n2tw0dKUnyiKId4npDWUdTVkxrQiNjagFnyAU+atv+OTegOPejt3xTu6WDmCCKBm7Z+i+L17hVbK39UqPUu55ILPoLgYXsgkKYSWdtrwllJOl5nueu9wBET8UQGW6/XJNOGxWbO5RBHS+8X2G3sW7jTAv9FzrA2484FlWb+ZuAnGHaGLQFBMacSHsN68hOwB0vwL4RKI+I+t4VvPw6ZznQ9zhJIvXQkzneCU11NM0OZpo2NXghf6Q4fRBw23M+C4VENNkBgq6Kdfav/X1NzXd45oT4Bq68a7yQ8q0TC1yHdQszsrBNt7mNmvQTWu6rFT4McKPJtC9wjMw6dfObFKFxOIEjl/fPxTO0NpWIYi58IiMjKwTHJ62tL/O8QtK1enbyfgXe75Ka1yE1Y1423n2DJUbDUkLp9Z06941b5UtU4VP9nIFbfckIxGHn0o1iGvWpwvP4JbkO7G7THcxeRtolnFftgGmVRdeSpLQJV9EMr/FhCOLYMbomM5sdPkLE0d6NvL4zMJ4ptSq4ALuM20+itwSYiZcOS5ALzQNP+V3E094chszJjv0ZbX6Bmr05az8mZDLD8EQPMjaJ4hP3YTMlb1e/FVAzJoIoXJ3zLuYEFWQlnBoEBLEisb3UbUK+3dTuuZ8SU9T7V5EhIq5FDYeeTJwe+oeSViFyeLvuOWN9Lz6PFvGVKLY9rq4GmUe3N+K6NoBghDBhxAoaaTVHYEegU4=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(39860400002)(376002)(396003)(451199015)(40470700004)(46966006)(36840700001)(47076005)(82310400005)(316002)(356005)(6916009)(54906003)(966005)(82740400003)(478600001)(31686004)(7636003)(186003)(26005)(70206006)(40480700001)(70586007)(8676002)(40460700003)(4326008)(5660300002)(36860700001)(41300700001)(426003)(8936002)(7416002)(2906002)(86362001)(31696002)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 08:19:25.6019
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d23240ad-c6a6-4d19-bb56-08daa12a27fe
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5769
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 26 Sep 2022 18:36:37 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.295 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Sep 2022 16:35:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.295-rc2.gz
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

Linux version:	4.14.295-rc2-g82b142ac4360
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
