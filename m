Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C73D56713E
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 16:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbiGEOgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 10:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbiGEOf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 10:35:57 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF6C5FD3;
        Tue,  5 Jul 2022 07:35:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LWPGxBMu4rvTPjcOrggRmA0Doh0GdEzB60SqSO1OPa24zB8MZECkRk0xNmR07UICqtNbwIbO64ftV3uo5juVaewR4ty2yp7WRjsOp1WNj1q6HkiWiysyTejm7PE49BY3jYradq2+pTcGdO4ti6TV3AcZwm4oM+LvO6gvZumiWVFpposdGW56M7fP4ptBKRUIzKlX9RCnosjC9jFaWlcA042twLtbgcBN5AdmO6LHXU8uQyJEq+fdeb1Qp5gFaG42+V0fzfRhOXN0J03qMxAj9ZoAPhlU+ex8XxkL4kTags4127c+jIn98bvv4SRH7/tG7B6zIJc2jKvlXfLkn18Wcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=waCDcD42TmtCFGYE+fbRGXCLEtBn2mqjaQAyCEX5CxA=;
 b=nBSmO7kxh5webnQkv2BkEL6AncDHMvh8M0nrrK25undDE8OZuAhtKQ33gR7VIrpxsF0hm19Y09NA9QUD0wWQWYX4s6YjIBGqQDOX2GPDtVeZBj89i1OO494JN5Lw20LJ/HKF4aiHyYgtDTifd2oeXj3rFSH7ffLNfXI06lS4SBTssnlei7ESO6yOrYz8Ga+LUJFA7n/Idjn0jm6kfSZtv4YjtI3KLah36umWx12JJIwqPBqMfD7uUSXRRzd0FP/pykXhfabf1qR7KtMQsJjyss7pVew71jbMxu1nYgW3scEqs+LftNDCaDCD3grqqHigjgQ+HLaWxjTqZcxoax3kAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=waCDcD42TmtCFGYE+fbRGXCLEtBn2mqjaQAyCEX5CxA=;
 b=OUSvMgp1P0xa5Pm2YZwpG/mxYK6CbpkMBzDgp+ig6noZDSbgedxY15KV4W2rQw3XS++c70S1tdXtvlLWpq0EYra/gSNaIJ+LjqV744kOSXE11M1jPc7w/0RJNgumT9r3p3ICk5IVvFgRoLsq995TOLcusp7Z/gNVH/9SWRq6mCIi1wYwJHjxP+IDdPCa1SU+oecIacUsFsqhv4DDv34TXKEs0mOcn468ZpomuCd9dTCfBWk6WnYUOA0TyylGDJMR75MRg1Ttt2uHgH0XWB3yymyey3CoYOWn/svQzAFAQ0Cm28xBy1pRdz8ntDIPEFlXxwbpJKmQlDyhJSYcswGS7w==
Received: from BN9PR03CA0473.namprd03.prod.outlook.com (2603:10b6:408:139::28)
 by MN2PR12MB3855.namprd12.prod.outlook.com (2603:10b6:208:167::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.18; Tue, 5 Jul
 2022 14:35:54 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:139:cafe::59) by BN9PR03CA0473.outlook.office365.com
 (2603:10b6:408:139::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15 via Frontend
 Transport; Tue, 5 Jul 2022 14:35:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Tue, 5 Jul 2022 14:35:54 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 5 Jul 2022 14:35:53 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 5 Jul 2022 07:35:53 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Tue, 5 Jul 2022 07:35:53 -0700
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
Subject: Re: [PATCH 5.18 000/102] 5.18.10-rc1 review
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <2ffcc794-60cb-4465-aab5-f5cad7695b86@drhqmail202.nvidia.com>
Date:   Tue, 5 Jul 2022 07:35:53 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7906f34e-bd7a-4b17-a902-08da5e93aacf
X-MS-TrafficTypeDiagnostic: MN2PR12MB3855:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RkiQDxVmh2nEKKu5BqU+ISyQ2Dj17RdbdMkxFHpPK5Sle8XKxmkY++PiXgvpW9gLgOKpJyWCEN1ldNn4wsb3WA4cQ9BoAbDKYzfmThfy/pntnCUGBoehBptd7HajEsN41K4wtsbaGBAh0yL655rHWkG4aFkSveGiGivzJlzZx7yv5Vqx/zfhsYt7LhyfjzxpCQdMr9oudzCNFP8DBRXZb19ISvpOoLu1wCIVfqrlmtZX87++BTLP0AsLA6W9KCjIVG7UwvJ6j4VCJC08QkxpPv8XRsbk3Gi3rhAGWcQjNq/bhXrpH8Yupt7rU3Z4ZsaTnoyZljwmT8xIZwlWMIongeTDp9yEE1CD/x4YW4R7rMt2xZbBxKM1wB+1XxgLF6rNM7W9+NY3EzWCNsLY+PaULuTOFrpzuZJiExyZP0Qy/XEDe//6UwyFwVnmEf79nYrSgu7CVv1ZrLUyqTrOfyzMkVq3hpXiQWWxrg+nUhpXzYwYIzsa9bvMkn/WhIxME/ilWl+52ShUFaP//NFDzq0x0WUN2pdh6RGqs87eNmxtRYvScSwrZgV/8Jr6LU0PN49tpthGLQnVj4eG96lM0LWf5HJi/lmFpX9pP/tIDrGE01FrMzPt5D59fKlP5TtmZS63ebZZWe2BBeWX9HK6JB3T+y+iCRTzuO6wMDAYqvs0U+tLFLQ764QB4GfqRDYB85JLp+aS1qk/wpDIyt+ypvwLsV4ARRWWq2XLlNqRH/9unYWf4i62YPWrbhRD5Qki8aBu4Tm1Rj/4utiSV4YJpLHVqn3ZH3T6LMQEORiRlYS0bqMz6Mj41GfUalTRlwH/jRplTK/iPE4T3AMc0V6/s6ipzGi4nGz+6xJ1sbi8TMNgJp9S8vlvGadIT0Lkd/Cz8A0dno0w3zm0LhAQWvFdtrlrjv+9GWIIVPFjWxJuukyi6i6OmXcC3BwNNOHlQ+g2DSUu
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(376002)(346002)(396003)(40470700004)(46966006)(36840700001)(8936002)(7416002)(81166007)(426003)(5660300002)(54906003)(4326008)(8676002)(70206006)(70586007)(86362001)(41300700001)(82310400005)(31696002)(6916009)(356005)(316002)(47076005)(36860700001)(186003)(26005)(40460700003)(2906002)(40480700001)(966005)(31686004)(82740400003)(336012)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 14:35:54.3567
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7906f34e-bd7a-4b17-a902-08da5e93aacf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3855
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 05 Jul 2022 13:57:26 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.10 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.10-rc1.gz
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

Linux version:	5.18.10-rc1-g7622cfa48fbd
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
