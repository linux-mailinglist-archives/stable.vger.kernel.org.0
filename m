Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA015620E7
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 19:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbiF3RK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 13:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234431AbiF3RKZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 13:10:25 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7866D22509;
        Thu, 30 Jun 2022 10:10:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XdeFuwPfjfifSMue33LpJ1zqjjsLDym9hTHrwMkTAwyfPhWO4YGmbZqwqy4if28no6usrTGJxHu/H9XpDgOVRHviqpMEryEg5BRv/fl30BKKHvIGvFvIBkoc/ialeFo6IKLJqDruRfkO3Sh8ZWG4r7KckE8qTRjqGgAUvj5Z2cVjYKnQI2wW9h6Uu70d1nOl1bUC9J6zd83zzEpP1KV5X4q9oGgTcSQFIyXkjXl1l5UPb4+884u0ZboYrlF2t81P7lX28YBtIYOAnEjZwAce2ffdOW+hVGnK6OtRUqNzRSnWKWEyUEjpkTLEYJTozUOl23QtRszVcy98tKA1gylCHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OntnNCC1DKRxQMmuYJdSB9It5mKkBXmCrKv5FL7fjAE=;
 b=OkXg5djesFVo2XoS79FZF8KFsBdmo7gAovRi1J+afyZS/4zztzTLWLP7ZOQc2cKtvjH455vyaFr/T+fAJi9D3El+U2fiNTin3tE2zsJLiYptagV6Di0BnXvpx+mG/0vehIm7vtOmFTxtLTl0QqNqApr8klSyM415hckSets8c+i/e9QXZB10G4LDdHkph4iUaj356e2SbcNiIHqZuhpge7QutipJdSHFQa+lsAnY33uhpyC98iM2MjmqKUyWCZaHPwCpSq+1KhY9xdfSkWUYCNOHKBFsSOHjhqJkgLWvCmuVmgZQVW9sHz355cIz7HvtWucVYcHAUjE0WXb6xx4BnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OntnNCC1DKRxQMmuYJdSB9It5mKkBXmCrKv5FL7fjAE=;
 b=XGvlipuZ3eDksKsgto5dDclnDVMCmnPJiG2XCSrAhg3zA20HdMP98SL57J9yNNeavPQmHYjOwwiy1M1dPVb//Ej3OW0iOSMAYmnVXI6FRtgtLCLPK3omJZJu5OpKaxN43kADePQRtqvk6TAFWUYyu+M63Nv43mVLlswbAYZELqxzI4WeviZ7fq+Cl/+FUZZ4OAptZyZacXBe1mX3sElL0pAohkG5RqHMinHeBho0vW/iuoek25KtS4mPNmdlz3z9/Jf1onEHr3CfsyF+l3ZdnRa70Jv+ItzkkooHbr5BdwJXmc3nw3vkR6YV08h8xF3GP0xp/kyYKwKDTGirFzv8AQ==
Received: from CO1PR15CA0102.namprd15.prod.outlook.com (2603:10b6:101:21::22)
 by BN8PR12MB3379.namprd12.prod.outlook.com (2603:10b6:408:42::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Thu, 30 Jun
 2022 17:10:22 +0000
Received: from CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:21:cafe::2f) by CO1PR15CA0102.outlook.office365.com
 (2603:10b6:101:21::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15 via Frontend
 Transport; Thu, 30 Jun 2022 17:10:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT042.mail.protection.outlook.com (10.13.174.250) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Thu, 30 Jun 2022 17:10:22 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 30 Jun
 2022 17:10:00 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 30 Jun
 2022 10:09:59 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Thu, 30 Jun 2022 10:09:59 -0700
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
Subject: Re: [PATCH 5.18 0/6] 5.18.9-rc1 review
In-Reply-To: <20220630133230.239507521@linuxfoundation.org>
References: <20220630133230.239507521@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <8d253735-a184-413e-90da-5103a94a8fa5@rnnvmail203.nvidia.com>
Date:   Thu, 30 Jun 2022 10:09:59 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4c4cfe2-bd3b-40d4-ced0-08da5abb6acd
X-MS-TrafficTypeDiagnostic: BN8PR12MB3379:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t5TWgXU06IwsOJQTUO10jSXEyoXeBfTh5V1uSbicHxkqzsDmGQR/YyCbSr5FbLgyaATJ3mI3EU9BLH26CqLiZqtKDiyFrkD6AFmZT1LM06ObuAEie9gMvgv3A/cBaiam2W9qW6xuhOvfJWuHpYRkRrgB5JCj5gpH98Zbvce4ESipzu4WXzkY6UtmzrNW2+kE+KZBnwdwgzizKjhH6JLnvs+3RJB9grS5yjwM48PRxgHE2bqDrE1RzlPI1uzLlpIE9u9qxvv8YUkBRHJhC+6qYoxVZ3wxxgSOIUTEo+MBhSHQF+pSIN/Pb25K15EsDksrkbCzCb3a0TAwwEEBXX8xui57mQg+HBxqZxkcD648i6n15FP63U8oFAhTDapUEUCrunViXrvIsrqYhXA3spsNrRda/GTzGcg5bW++jB9uCOKSbuVUdkRdmTQ0wHOR+URfyioZ48/sY1q6kKm7qcWEzqqF8OVaW3Iv2K5uioLkJvehKa2IK1U4js7aceTfEsKi0KdQrJ0KmqHDmU28+B3IABwZiuAQrtYM4stWu4fgjuHR9h4qXidVCpsaqrtDjWNFHAqjbYjQZpFMX/kS8mkUycz+KV5OqxjUaYg4GIVEfjh+ME5uj28qmmNWMOAu227LRj/BioZZqaig75Bu/sbuOrmgmSgMvbWwobOi8UUhqcpTz3F0Zg/vENVobtmhamCsvFkjbBPaMIVxnmgEm/hahweNRvIdp0HQ4BoP6P2tcJFCQSJG03eyk7j5yVhOJD8ZP0b1hcNsTgYxY4jw4hEn13KIjBeU9jyD+HtVj3GpN18nTgTiGNeHZnlgf1QR4Ubl+ZL0qEIoZjEdHSDTiIqZTu/0Xe67e81YFjc8Jzh6mzdFOwK0TAiV0XuMgrq0fLNKvHGzyT0tyMSEB4PtAX9HVWkKcQzqZpwtUoxHgdsxHFGWlNVQe3LBRGfs5yTFamgM
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(396003)(39860400002)(346002)(36840700001)(46966006)(40470700004)(31686004)(41300700001)(54906003)(2906002)(478600001)(966005)(186003)(26005)(82740400003)(82310400005)(81166007)(7416002)(47076005)(8936002)(336012)(36860700001)(426003)(5660300002)(316002)(40460700003)(8676002)(4326008)(31696002)(86362001)(70586007)(356005)(70206006)(6916009)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 17:10:22.2509
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d4c4cfe2-bd3b-40d4-ced0-08da5abb6acd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3379
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 30 Jun 2022 15:47:26 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.9 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.18:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    130 tests:	130 pass, 0 fail

Linux version:	5.18.9-rc1-g2c9a64b3a872
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
