Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00EF45B8BBB
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 17:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbiINP0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 11:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiINP0b (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 11:26:31 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061e.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::61e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A088051D;
        Wed, 14 Sep 2022 08:26:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lrjAVbdfo7eF5TCa9jzCaNssIlsn6nx6ySmCTmJ0qOEOga6JzQJBhpw/JGLz3e5s1xCd6u2HSdyvF3aac5Ihoj1LZPkUZecrRLK5jhRmvrpLySTEai04fCoUT0bBhzbMEXCtJGnrQc1nXloC+xqEqSW/kqKxKmjgGesIWZgDY2o/u2gVkmCzvJVxu1amK1T4HKuLTu9JA8xFbiNdxyFAbdtm+S9A3RDlxUEV8Cx0C/tGXX8hMZV2HkopfL+vm/0O0/TpXp2/9tYUpyoXVicjoZQ5xKffwOsZdAVTSdPj0tLSD8lxpm0jWCvMV3EO/Mzqforugx/bburgTvbFO+fH4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TJhoJy1DPSVrneOIu+S1Hot/dQtVDneY07NszZ8p0yM=;
 b=Fm6WwtvZFZ2cg3EzdiX7J7cQZ4I2dNFNBufYPBTLBPk/RY+JOxFWuzw1krBgUKcOo07zDbG6exE3waY+FqGwRXwtWS9jXA/NMVM1pvp/2E4KfGw+vxeGrTMTNXqz0fcCCU1LzzHPJ+mBQiBA5D2EIzefaSMNKgjRjrYE++KY7UXzlw/5SoPHh45ztV0Pe3BRQ7PIr0frRikKPFH3mj/HgBo5mI6KlFvHIv5VTNBeXOb1j7aQFtvIiw7+19DmMdLnXFkqjeY1KWHHr9g0g1OuMV/iGqTl44bhsYopdEUhCvcNZJZZfYFQ7BjruGzzUfNykYxtzRhn50wmM9ZKK7yxvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJhoJy1DPSVrneOIu+S1Hot/dQtVDneY07NszZ8p0yM=;
 b=T5n35xs2jEAtQu9YpdNmaCk0HwzFx22+fxYwtMWpGeXy9rUvE6k8nfySoF2I7TRnk6MS8FFcTT+/m2XMX7dxOUqM7QewROAOwQw1kBn/dKz7TXSTxGcfDeQhvQ4aszqJm9awbChTxjAWZw9SFwrKHLtGMuiufGG9+vz7jb1sZbyWGFYYE6egoXL+r0q/CT188+7bpWPNA6taG/s7uEsPPKinryw5+5Od5uWPLnxt6FWKvHKa12Woxs3th8WW9q0zA6RvEmWx+6hROeKlFDbw7IFpsL/7mi1lUGS2rMY1b5Embc7I6Hi+m2gNNCdfZxPH4BE+Jx5iqtqwB1RnUZemNQ==
Received: from DM6PR08CA0001.namprd08.prod.outlook.com (2603:10b6:5:80::14) by
 SA0PR12MB4464.namprd12.prod.outlook.com (2603:10b6:806:9f::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.14; Wed, 14 Sep 2022 15:26:27 +0000
Received: from DM6NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:80:cafe::4b) by DM6PR08CA0001.outlook.office365.com
 (2603:10b6:5:80::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.12 via Frontend
 Transport; Wed, 14 Sep 2022 15:26:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT005.mail.protection.outlook.com (10.13.172.238) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.12 via Frontend Transport; Wed, 14 Sep 2022 15:26:26 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 14 Sep
 2022 08:26:16 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 rnnvmail203.nvidia.com (10.129.68.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Wed, 14 Sep 2022 08:26:16 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Wed, 14 Sep 2022 08:26:16 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Wed, 14 Sep 2022 08:26:16 -0700
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
Subject: Re: [PATCH 4.9 00/42] 4.9.328-rc1 review
In-Reply-To: <20220913140342.228397194@linuxfoundation.org>
References: <20220913140342.228397194@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <23f13248-4b30-436e-b453-aa666133b80d@drhqmail203.nvidia.com>
Date:   Wed, 14 Sep 2022 08:26:16 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT005:EE_|SA0PR12MB4464:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b9d05b4-036f-476e-17e4-08da96657d9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 45LwlOLDiYW/pyhjLfRCZSo8m/PzOqYxv4nclopIeFryCJkRxgwvFfzRgAopQDqUQeo9xkXwPISngI1ZSWFV+GuXcsBSmNvv3HmWClCqm5o0wWMdAYmipuyjsFyHIC4PGtVd+WN9QvBbZolNmTtgxVLLEN+f8HGTGI4HS54dy+XWUcJ3w+D3mbBrn0PT26v4c/5pW5rCjkOSjQ3ePcDV/6IzqrHXKGaoXPDlNdksatGwf1aVh2sZnZwHEI4t+Y2P7nFp2PvrNONU/lOgIdkXU25/7VpeC9AcrU8fBKfLGu08tfWFhGv51vn2WlHH6BvIQhTjhJJDA0DaOSgw/cpYhzHBJAif1jmR7+T7C7fdKQiy+t/a3bJ+RWs+kKcwxhAB6l0wuBx13re/mPJNx4l+JSdhYJU4tUYP8rjCAbIAks/qlo2dyDqzslYWk3x+ynJX4DiLAh22fJW6qPtfh3XPAwi6LE5bTTHbWihIFuNixJxKaRMWkbLpHX6VKFFLvW1oosYPcaTC+plqQyeyQP/OxldJmePocs7cJDHRl6zaKYHTdZg/RIztAnuaErTaArmWIir7z5NUO/Arksx8B+878hldWof3UZqoxTOXkpGVNmzBCMlSelQYDZ5JgaXk5eoB3TgMfjNk6eK05tBnFX1MeKGASWtxEvJu6SZ7XOc96VPRMEzoN73fw/ro3CGuVwCZ/bo+Ddj5fr+jUodHNXSmYaLojVJRXwXpWPhQSOMfnkXaGd0S5bXTmp/GE7MrJ4gMhBUEFsgZU4/1JPbgnEASRetmsoHYTYmdvHCRD3675Xnzx5PviiitslJBYDoh4BD9cOaDEboKcFw5kMNY2dWPSxRw8r29pX4vNRzQIUO8Nrs=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(346002)(376002)(451199015)(40470700004)(46966006)(36840700001)(426003)(41300700001)(478600001)(7416002)(2906002)(31686004)(47076005)(966005)(82740400003)(6916009)(336012)(70206006)(54906003)(26005)(70586007)(82310400005)(7636003)(40460700003)(186003)(8676002)(356005)(4326008)(5660300002)(36860700001)(316002)(8936002)(86362001)(40480700001)(31696002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 15:26:26.8225
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b9d05b4-036f-476e-17e4-08da96657d9f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4464
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 13 Sep 2022 16:07:31 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.328 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.328-rc1.gz
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

Linux version:	4.9.328-rc1-g3ed886339090
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
