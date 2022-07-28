Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09558584177
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 16:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbiG1OfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 10:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232617AbiG1Oes (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 10:34:48 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4926AA0A;
        Thu, 28 Jul 2022 07:32:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A830IPkYXTiVfGgy+TgY5Yn34VrLi2tyM1WOWdrskM7w1uXAEza+xprzNCpZtpn/6tppqF/2LM7QzrH/omNuUuWa4wsORjMcdgwbAB69/hVqG1dnGkhqNfevGMdEOElQ/CAxtqy/dUaeFGBNeR9kJifMah1KElziRBY/l/cRpKy3DD+WvxfgLzIInROhkwSvqagOOiWJ/xpdLRl+r0SVFCqAqClPL2+1PDBqblhVRBIih0+QeLyuQy+XKaBIwQHeTqXx6Jv8Qo5K2Heiu35gDJh2sJwF6kLt30USEqFzQIC0Lrdad8EaThsPpfGkuakEmwGttytbr27JmMGvkp9NXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rpEYS9NsVqMmIjbS9qHP85b7qJ2O1fOHHa3F3WTlzC8=;
 b=hQkgausefA691FM2cVl7+vEa0F2ELWRE34lgtgMgn7JKmKHsJwD302EPuuSk+GI4Mrd3J5KJTX6LnyGGGohc87dLYKS/Nm/4JFpgJmG7QT1I1RUDjxfKDxf/Yirvuga7KBC7Lih0ffAAIydHD3JJUUdNLIxdFfzgI6c9lnTVCyuE+6KWpbEdGbTCMbK/hLZQG1EGFoWyfy0Um0i9CgUPKsjYYkBmG89tW+kL1zC/BrCRJcStaN0S6jpXGel0tVg1ig0u+7TDDSkvErw/Rrr2h/sYl80stHRf71x/MnpnBBQQ9PoTJs4f3C8+GhzBTqdDBD0Flh2U2xiyrSg3qFiJEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rpEYS9NsVqMmIjbS9qHP85b7qJ2O1fOHHa3F3WTlzC8=;
 b=Q9htgl1jiz+WTUqGtesFNlhFh7JYalXmq5Os0Md0Iskh/gEigUL7HemsErk5RDnUg/MInmCV5KD/zTFHXxcf9wfaOKPYZFwZ42eA5yqGnf4Qz/zY/5eBowE8Jgy2F8ktRUHEBEh/VoJ7rIQWnv+p/9k715fbdo60BvwJK/6mkdc8yTQrpgxThIC8eJdsJooytacxq0uRyppgMAXRqstVnPrAeVh2V1OsGauDdRhoD1pfyEMqMDXyEir266ooI7bNxg/ZqnHbMNrZsnlCHsEA7nIK8JifwmEAhAJ9B+0qs1+cDPEON22wabJ7QI3UNQIQjR5H7YTtTItOzVnMgkxV5w==
Received: from BN9PR03CA0925.namprd03.prod.outlook.com (2603:10b6:408:107::30)
 by SN6PR12MB2816.namprd12.prod.outlook.com (2603:10b6:805:75::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 28 Jul
 2022 14:32:12 +0000
Received: from BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:107:cafe::b1) by BN9PR03CA0925.outlook.office365.com
 (2603:10b6:408:107::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.7 via Frontend
 Transport; Thu, 28 Jul 2022 14:32:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT018.mail.protection.outlook.com (10.13.176.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Thu, 28 Jul 2022 14:32:12 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 28 Jul 2022 14:32:11 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 28 Jul 2022 07:32:11 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Thu, 28 Jul 2022 07:32:11 -0700
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
Subject: Re: [PATCH 5.4 00/87] 5.4.208-rc1 review
In-Reply-To: <20220727161008.993711844@linuxfoundation.org>
References: <20220727161008.993711844@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <7f066ccb-476c-4aa4-a869-aab0c28d97d3@drhqmail201.nvidia.com>
Date:   Thu, 28 Jul 2022 07:32:11 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b1a03fe-ddba-49b2-52fe-08da70a5f5fd
X-MS-TrafficTypeDiagnostic: SN6PR12MB2816:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LkqEnitF3gU9lUb5rPIkaT4WgItrpHKXZ+56zrgiUnuVC0mS4Bqe+lgvRj/XN+BppO3jh8QD8ZEc4hzFCGVzIbdv1Yl2DWRXd5PIF4cVb7UPmkQ5al+UdQpxbaNGrO7fALUgFz36pTsBlmo6UW4llzX1LRpMmMLCk1bypNxUvHqCuzVjQXsi6FIzHF8xprJ6e08OV42fYEqlSaEFleAsLv14JRnGWepdU9/HC/xRHnxzWEMFItke9oggiyufpVVZ9wMG5nrHJaQNxkx2hulBeTpLja/xa2DuA+WLsDL7G4KydF8Oi+IyWap1mxo7ZsAddtZuh4vmleXmKFBZXJBLd1yKjoZDJ2HMDrwfaSvFiGnWTmNla6WOG52tOeYRMEsNQGTI1OSe01bipGAW3dgnbt1RkPaS2H/UxpLTucM7PQLnWsW3ocUxlxptG11bHCw0UTHKNPeiXbFr2QtDCFnobtAnm93TKQI6M2LouOhDqxq11TvnuTtDW2SPfQvZshd9iCuF+3B+FZPDZLiW7JWa/SDBSEGjrt5FSo+JT18AosmwAl3rvbaEvZtuPpKECfmMFltSYdIbGJWbRjauUeY8seoZwGKOJeI59M368EqKHZ5GOMOfAtCpMsqbqbEqe4TuBBrr6Sl7yS7qn2ercD/Zn1XZTDnPJPR/B1j6a70gWMtxjkdF1BcMrv8mum+drGPvWYjQPhkc0GbWJSxgxS6JstgiaKyhllaMrRGT+LeF1J6MN8wF5RdufmX2BtrQ0w1vPawBv71oKGck1CTTLzqSSqZM7tLrAITK0Po0/1kcviiXEYZIHOunZo0Gsy1pjL7tIxG8MCUDeW7HGKBxTwTlX2AXO6fvIf6vGsA0UMPlm6dmXzdSMKGcQ0b48aId7UgvX+N9ZzdLulxLolJNHvnb31j/fHpTOqFaB5rcfMEF1Gc=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(136003)(39860400002)(376002)(36840700001)(46966006)(40470700004)(31686004)(36860700001)(478600001)(8936002)(7416002)(186003)(316002)(966005)(5660300002)(70206006)(40480700001)(31696002)(41300700001)(2906002)(47076005)(70586007)(82310400005)(8676002)(26005)(336012)(426003)(81166007)(356005)(86362001)(6916009)(4326008)(40460700003)(82740400003)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 14:32:12.3718
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b1a03fe-ddba-49b2-52fe-08da70a5f5fd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2816
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 27 Jul 2022 18:09:53 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.208 release.
> There are 87 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.208-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    59 tests:	59 pass, 0 fail

Linux version:	5.4.208-rc1-g048552f118bf
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
