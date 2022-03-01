Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2891F4C877E
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 10:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233626AbiCAJOf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 04:14:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbiCAJOe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 04:14:34 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2074.outbound.protection.outlook.com [40.107.237.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BA755776;
        Tue,  1 Mar 2022 01:13:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vk2JdB/s6c1VEyhTuFCLaSOTVLNZ31caF/BaEcMlh1NDvWpRN60UTh7yJiSdiO0sv1aNFgVF6ljj3mrj2AM6xNJQab03cp3S/AUevPccLxfH2lRoJwzY5odUAYZyWkXSaDdzF4l16aeujuohmWbUtrFbEkX4yWxGT6nxVVTXb3Itt0/kg3xfSu2r8CdDT+ck22d4wMBaBBDloOixndyAZYD9Gmyo5o1ftxbb9r6rBQc/l8rfh6zSCqPgzRwz9Tf5RpQDjbwZAJbXeqQLyG0RigT/3Hd6SyghMa3KbJQW8E5c0QyUYqKODJOG2avna7IQywuNdvzTIvUgkB2SkfH//w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pMz6LbWHgr2pfqGwdm1V/IdiP9z9A8cW7Bl8WapbHb0=;
 b=E/XDvvDS67aSYGRqKtjiZOQu+4sc6o39Zjlwjx7rW+PdeLXc6ouuCRdcJetr5k52uGEi5jNqXJdb9l0toTbJhPc7dz+ysmt9DuJBumys+ZUquWqiKkPcNfNVF9SPvhRmmbbHvbkbkvZkFm4aR4B8pfQvs1ewsTxaVQFJlbbHdGmMhcKxhW11es5f0BiCp27Igd9Q8uUn53QgFIDOujRaA/283l7m+obQdr6HvAq5R4a1YBFxc8H2zU9ApWonXn8LRzoSuZ+sWbFIjkwspVF0Hu2nrlfk4h8YFsPACm3gl0Dd70FlONink0kXs086exGYfOQzo+z5t22yr9NSYxFNJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pMz6LbWHgr2pfqGwdm1V/IdiP9z9A8cW7Bl8WapbHb0=;
 b=IxE6P8R5ETfy/IWuvPCfdLoAZXW1qV1bU3CODLzhsko1VUAWrMJA9xUGij00IaHxNDQXQ6Idgxd+csWWWASIoSARfCJs7ANSvo4buqlSqpUI5czYwQYHkfyz3bO1Jo6nhe0FyVsturIw+RcLVWaPbqJzm8edjfIK0VtmVhwSA1wlg0a6uhyueqaeZd2lTFeLXwJI6USVt6PeBWbH3ieeNiZwww+nbRV9X5JMg2pzWK80UAhbjIudfW8EPIUt5ieZa8SMi/txcZnvvoxXL+BeOIW2BHEIf2vR6ZvJcJZYDYBY/KCWhiXQr0zQSV3xoFejLrd7vdlUky0d1am3qxowpw==
Received: from DM6PR06CA0070.namprd06.prod.outlook.com (2603:10b6:5:54::47) by
 DM6PR12MB2956.namprd12.prod.outlook.com (2603:10b6:5:182::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5017.26; Tue, 1 Mar 2022 09:13:46 +0000
Received: from DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:54:cafe::71) by DM6PR06CA0070.outlook.office365.com
 (2603:10b6:5:54::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23 via Frontend
 Transport; Tue, 1 Mar 2022 09:13:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT035.mail.protection.outlook.com (10.13.172.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Tue, 1 Mar 2022 09:13:46 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 1 Mar
 2022 09:13:45 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 1 Mar 2022
 01:13:44 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 1 Mar 2022 01:13:43 -0800
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
Subject: Re: [PATCH 5.16 000/164] 5.16.12-rc1 review
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <6c484644-e956-4d17-99dd-a598789bf1af@rnnvmail203.nvidia.com>
Date:   Tue, 1 Mar 2022 01:13:43 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d47d00c7-dac6-43fe-65b8-08d9fb63ca5b
X-MS-TrafficTypeDiagnostic: DM6PR12MB2956:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB295652D5C12381FF393063A1D9029@DM6PR12MB2956.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CJRuI80O3q8kgf4MC7ZBGM1N29xaE2UyHocBRc77+Qj7474clhQxpuA+uWE+aqOC9AVc3OHeGbZtEBwFZArDZtfaV6pitV2Bvdjvho60arZwC4tfsXIHowVWsDpFqhmBjhHU5kCuJM5X0rcYwawHvcFyIkgmscRDH1vZ64h2beH+JT60b+NYR7aMPbSqgXgxnlhB/enQOHs0mIJmjlYzNWfsE3ci/RchL6h0Nhfssg83Q8zyshRIIHEAebDCMemWwJvq+YyTswnw49N5GzrdstNaAEW46Mga7jETfXciaY7LCNG2DLY12cURg/Wih5S7lxprRaBPUpJMSTmpopemsGcDVA57wl8KCqDM0fzkQbAPuhLZietS16o0Pjh8r6DuVa7PAAO/IGksbjb+hPAJtyQ8X90GU0d0XXOeDNcEkyj/P4uuS3+qj8lXCE/Ydltn5dNsyksZsGk1kZMirCfk4evLNTjeo06BuypJP05o2k37DRn2KloUeeaMhaMcfHQ8wdvzALAGazBQXDQYliv9MXNvQkM2zikwgo0zlptawT7Q0Q/AycLEpzmGD8zAEeYp+fhlfy0MWoDiNPjHlbcoaT+H658B6q+WY7dJBb2QwloBKUnXxRYSYD4xjbeZxdCn16LYfOum2kUdGqHNh7JvuyjO0SGXfXc9OCPjrA7ai1UnBHs+69CGHE2TJIS1ttZc1R/0gWdRhNFotUA2RgKObgI2uycRv0jFInQB6ryYYCDPdQZRgtQvQsRliLkzxV+DcrbKPa1Dz11kTGx/OsQr6bp8rREFpv0BLF99ay5pAt0=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(40460700003)(8936002)(6916009)(356005)(5660300002)(54906003)(186003)(26005)(86362001)(70206006)(70586007)(966005)(31686004)(47076005)(426003)(508600001)(336012)(82310400004)(7416002)(81166007)(36860700001)(316002)(8676002)(4326008)(2906002)(31696002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 09:13:46.3707
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d47d00c7-dac6-43fe-65b8-08d9fb63ca5b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2956
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Feb 2022 18:22:42 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.12 release.
> There are 164 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.16:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    122 tests:	122 pass, 0 fail

Linux version:	5.16.12-rc1-gdc69c736a403
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
