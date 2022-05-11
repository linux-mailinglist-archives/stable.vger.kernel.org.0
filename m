Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5198522F17
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 11:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238055AbiEKJQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 05:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239183AbiEKJQB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 05:16:01 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2056.outbound.protection.outlook.com [40.107.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB78D5FA5;
        Wed, 11 May 2022 02:15:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UOsQHYCccr7efiPPoyd9YzFUr0L05fM51jIxoMhgthUkgV1HTkgbwwjyAI62NarMMaFRPgNyPEtiMtBU2aiC01P7tALf360Y2ln/4b2KEhIgh+mL2SeEVcTu4CF06rCo5Nwxc4+81ROtVy2LrBimr/C2nu+TOJ5dxnFLmQkEKSUgHe+54mMVN5l51c1wjQXJ5AjpBNDzEHv6NdiVylfCyEjGnTETFR2wV7vZyEsV6BS8EaOEC01eBRUCCzu42Uwe/yyFaGX2wlKz3qEjIzPOhKlQM06+G5UDA3iUJoJ7FjV9VeyD5roRMMMIXhsifyqU+SpfSno7gGBzMeS0azfAHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h3M17uZOkX4Vq/oP0oBMAqkzZxuqTUWHZPWxQ3T9k4I=;
 b=ditkZkECp/5dM4upP0czPxdWsFN3WCQdjVu72lg1BwhYSkkdUGVst1CzCxzUz8i6d//ZAjxLIpTvIB8p9p/tFfwLA9S2OBHQGTCv0i7OBI1Jbbxg123I9jNb8sexdgoxbhU0oKkzbjeZCPsm7bm3zgmeA4SMc1QAt5iOqw+BnKoFTm1AF1gHb5XRyFjkdXM9HAcImA4CZHtwbE6+o+WN6GXLXmSunKuH0E+Pfh/5XuIwhAE8jjPTqk9stea8MQN+fcWXqQbNHIipnmXY7Y5+jTyigL/KJ97aZUDmBLlkqDJVtvolQz4x8gZv3t1NkaT+whG6x9ss9n0ZFabgNrpcOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h3M17uZOkX4Vq/oP0oBMAqkzZxuqTUWHZPWxQ3T9k4I=;
 b=d+QOysU2dSvrUAJHT8i2LF/BpdBNczVQDQhQdOQR/xgLHi/7GkCmDicY0lrHcwrER6iUXtbSdCUjuS6XUnOcaQlOqEeBalGeDlAqd1dlAU/ZiaVgdohjmd97ldCcJmWDOfn50FQ4tg87V5BiKpdUDNQAHg2h1585CKdQhHlrdd0cSKqYZz7J1FZ040oqNTdG/Eo8RZz2STp/7NKK+qBga+U6527j/NC3ap4uIrWKV5dgfyZfUMyOUETvYA/VzKm89fS4l1JGK5ZTKX5PNRxKoPAlcUiANIyC0Oey6OgE6E3TqVHx4fnDdvWZuneZ0Pcuy2KKSErpUomqgTYWb75TkQ==
Received: from DM6PR02CA0102.namprd02.prod.outlook.com (2603:10b6:5:1f4::43)
 by BN6PR12MB1284.namprd12.prod.outlook.com (2603:10b6:404:17::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Wed, 11 May
 2022 09:15:57 +0000
Received: from DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1f4:cafe::fa) by DM6PR02CA0102.outlook.office365.com
 (2603:10b6:5:1f4::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.18 via Frontend
 Transport; Wed, 11 May 2022 09:15:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT009.mail.protection.outlook.com (10.13.173.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Wed, 11 May 2022 09:15:57 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 11 May 2022 09:15:57 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 11 May 2022 02:15:56 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Wed, 11 May 2022 02:15:56 -0700
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
Subject: Re: [PATCH 4.9 00/66] 4.9.313-rc1 review
In-Reply-To: <20220510130729.762341544@linuxfoundation.org>
References: <20220510130729.762341544@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e0f43e5a-b8f3-451d-a628-42b7e9e0619f@drhqmail203.nvidia.com>
Date:   Wed, 11 May 2022 02:15:56 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd09b9f2-accd-47d9-df50-08da332edbb0
X-MS-TrafficTypeDiagnostic: BN6PR12MB1284:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB12841454131F9F9B57DA7EBDD9C89@BN6PR12MB1284.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t/Cnq9OCy0sS6C9FrPSOqmBCC7SdX/t3RVG40ee/xd+AY/wJlxT3FhssTgqK4p4OaKPGS+94tT775fGlBPE67MqIe3iRXkFirVial61/dLq1SkS/QP1OpI2Nr0jw3kRcY/CbtIdJQWwO6I0MdIkjHe80ceqayfq9wRXu5GSIOkUBlCoEG0keaptAn9W8t4GONfXsGGSaxfgPMLhjwah5XXWwZKAtH9faDddGgLC1k2ATJ1amqu/Tde4NnI8MMvg/as+ArQFiEi5M6/XKklzxKaKi6N7B1GaN5mt1ILdIUnYT2d3xvQQL19HC2yErAGqc6wvH+jPMPtYnkABu644Ga3xKgDBTbIEe7W6b6m4IiUUCAjsr+b+JXI5aTT/aC6PXSa4D+IMa0/hf7qQ0JpWwSreo7/V9DxCNSJScsRmK1iWamayA94CQUjPV0A8/949xjPMd/yl6Y2zwoG1dZ5LhDo9Cnwlh2Ml1yvHo8evg5GN/MNQFTrxzlu6v+KbO5Vv7vOZjNCx28YxHY1zNONz+XldIHBAh8fBzfe4r0XfDkFtzirbTJ9zV2xISNZOUCWfMLczUxS6IApVXyLlQ3L3KXNZN2NcSqzGd+YiZ4kWgE30hM+YZUmALHW8rquXCMdVy1aVbiMxYvrx3DRW6tpAE5wMtNYvyuqe69nrjHiO4Jjt93u4Tjf0Psqi7QJ1o0gS704nisMdFe40AYFxm9PQBVonHdfXu8r7mvPFA+mi5VacR5oSb9G4XnYVxd2YEG5TEuzDxZXthxevKcwk+3ojj9rqlSw176JGIQV+ObhsMFjM=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(54906003)(6916009)(316002)(70586007)(8676002)(40460700003)(36860700001)(70206006)(4326008)(508600001)(7416002)(31696002)(86362001)(966005)(31686004)(5660300002)(82310400005)(336012)(426003)(8936002)(2906002)(47076005)(186003)(26005)(81166007)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 09:15:57.2566
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd09b9f2-accd-47d9-df50-08da332edbb0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1284
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 May 2022 15:06:50 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.313 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.313-rc1.gz
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

Linux version:	4.9.313-rc1-gbc7a724ac0ce
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
