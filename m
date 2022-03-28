Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 752374E995B
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 16:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236954AbiC1O01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 10:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239756AbiC1O00 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 10:26:26 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2087.outbound.protection.outlook.com [40.107.236.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA281EEDA;
        Mon, 28 Mar 2022 07:24:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=afJQKqfg8E7/+Vqj3+p256I5vt4DXfN2w92CxdUtUXPcZIIGIqnP3WbFSpPj6s7T5HYhEEzQgG2272DILoTHbWu00QsDTY5krxp/0fJ0yDXh/rKttJpqHBitdKdJ38+m5QuGGieSatKCXJiYPixwtfupi9RMj4e82ZnJNuTsM40AR4ZDFfnnt8nRW94TqKAcslqXINazv/EMBVWtZe7wOEeHQhj/7TUB30fqqbvtKxdATIJ+N9XIZay/iIhCT/bg44kPfPkRYCskbBb1HrEkaJPpU1JDPZlS3uZPky4U1W66AtHh7pgxLOtYLrTJQgbhus05rldHIBuyMaxV/8Kp8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=paKv20TuPrzmj8kNnCBfpe9dXcbod3XMbqWWqukhPCU=;
 b=GMI63ps0eP1aW8Z0SoXghQyPehBF8od8IOGCRFKtiFRT6+IhUuCniXlLryNyPFvoSxSTOkpDSXaS+3QE6lqq02XK+PbewnFkxjzYWwHRXAItqMbdTYJcZecW+D2ubjij3Jln/6D9DCJlSIc3qm8WN8YlQ/ghLrU0B9IyNSGixlNt4VKxHfimwCKMBemLY0X8yaaGuQwUbgM3+R0iheJz62o4TEoZhVttZhW3ayIk/cpeUQjtdrixJCPLuJMOxwCeGGeZ+LOQnGw51T960x+TV4aScRBfLkQZKG0qPDQAfVNDwKzTz6bUSSIquOrdeB6Q59INvglbPPiWqJUZJjFyCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=paKv20TuPrzmj8kNnCBfpe9dXcbod3XMbqWWqukhPCU=;
 b=GhwjTpQnCEoFPbXqPXSWb/Xv4wvvCIDZvymNOB7Y3opHLSUoOwtPR6/tsHYlJgADTK1Hs40MDmzAeXhCd4MkJYTouPXBTsLoVsGCwMc+cCSVOqpY/Obx58HiqLevW1bmMphGn1ssoPw/RO7Jp8wFoAQagk3QqZiijSaA5waa6MkDq1LIDjSXhvi9RTDfQWgMxl1B3kX0A0B8lYwRIaH0gsM9NJSVefi64RvEjBP9RYcpYB4cS+mGcfNvzzi/W9fgJcbHCM9CGDxzcNCk4ZLOCAM57q0M5vgi5X15yjzJTBgILcS8WU2kEipe3f5g1QraEibtQl12rPczJ/50uxuq5Q==
Received: from BN9PR03CA0087.namprd03.prod.outlook.com (2603:10b6:408:fc::32)
 by DM6PR12MB4649.namprd12.prod.outlook.com (2603:10b6:5:1d1::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Mon, 28 Mar
 2022 14:24:44 +0000
Received: from BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fc:cafe::7d) by BN9PR03CA0087.outlook.office365.com
 (2603:10b6:408:fc::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.18 via Frontend
 Transport; Mon, 28 Mar 2022 14:24:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT025.mail.protection.outlook.com (10.13.177.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5102.17 via Frontend Transport; Mon, 28 Mar 2022 14:24:43 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 28 Mar
 2022 14:24:42 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 28 Mar
 2022 07:24:41 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Mon, 28 Mar 2022 07:24:41 -0700
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
Subject: Re: [PATCH 4.14 00/17] 4.14.274-rc1 review
In-Reply-To: <20220325150416.756136126@linuxfoundation.org>
References: <20220325150416.756136126@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <b1fc9e90-966f-44f4-b008-fc27a9d74921@rnnvmail201.nvidia.com>
Date:   Mon, 28 Mar 2022 07:24:41 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d76c412-0706-4bf4-e633-08da10c6b409
X-MS-TrafficTypeDiagnostic: DM6PR12MB4649:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB46490EA18AB47880F683B442D91D9@DM6PR12MB4649.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2zCdK7+1JP7WUg6St2RYOz7GgN+WU9kS3ScD9AGKZR5oNuaSTwL5VHWpNRYsoCc9qtmSE0PtomK+u64yyQl/rNvGbQ6al9XeVaFZHyzxeb6uLq3/szCtcQo4xjS9dpJA3MqhsCrcadM5+dSUbYC6KHjOo1ac47oFT4c2lH7H9dylsnWdOyw1MXgLmA7zXq7NcQjPA1xqT6egXLbGBOFhmeOApqhbC5O/Jpe/jWYd/EsjOADIVCwSVr+0glCTqosTSx5cgsjlpbBvzGNRs76mvHaKaZoPNzz8NsAoRjoz6muNHDYOHz5y4XH+tf/Hj1/mvFymole2g4Gu10/3F+Z92Vq/oozHdSMws7Kh9sGzliksN/PLALAK57NatzM0fPG0B0yRsUTEGEDt6ZOqTyubVxpaMHreDRjmNq0PiaY1B6l4cGwY0kRGMYX1gaTvM5h0yiQzaa5/YG6JaswmjsCedA6uHfIYYiJa7NPdPECBS5oDqgKQup0JU23sI7X/687YFbpbaX1LLwYxhMwGNgf1Kx25wvCysji9wUi3KKDhfNdp9FnwNqkp7BbRHdeeLpHAmWCwVh+Q57rdcxhk7XH80Ra5yqKbbKodGUApACJT1Ezw5gUjkFbUIr9RJU2wGOcK5Th04/sm8gLtUYoPDfGHMr6ORG5gdruXHbAE87dJzK1w8LsWct90n1ZO0Lrq1JgTOStrdUQM+TepKXsuU0tzXTY2KoZoPR1JvCCiaZWqddvCtfisPIL4mHHZ67Hf6XAQfGM3JDKjFHNwQrUfyEvYEIOALl2lzSeh4RE9c/CqiwQ=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(81166007)(8936002)(26005)(186003)(2906002)(356005)(31696002)(31686004)(40460700003)(86362001)(966005)(336012)(426003)(4326008)(5660300002)(7416002)(47076005)(6916009)(70206006)(54906003)(508600001)(8676002)(36860700001)(70586007)(82310400004)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2022 14:24:43.4744
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d76c412-0706-4bf4-e633-08da10c6b409
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4649
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 25 Mar 2022 16:04:34 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.274 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.274-rc1.gz
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

Linux version:	4.14.274-rc1-g9907232a90d4
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
