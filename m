Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1585B8BC3
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 17:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiINP1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 11:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiINP1V (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 11:27:21 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060b.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::60b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88377C32E;
        Wed, 14 Sep 2022 08:27:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gWzF2xBIC6Uwsbep4PGm39jr5KIhiVJwTLFm/IBPn8xrLbGaZHZpyHkiuDLTr3n0xfgrS8KDkhFf7unt3NjwAY1o4DxK72+SxjaplrRwsK1SUm5mCwGkjfA5LrDCYhhUkPWe5J8UUoWQ05dLn65Wr9A7+nDd3D5XEgJ7hfivyGw2FLt7N1FDM7Ut8yny32b0OChFbvjrEnZn4OO+ysI+7FUuv3ku8/wvAxXHpFj1zIidPki/hgaRVXT8P53PoQsogOU6OnrS60zkDnx5RxWO16ACl3y0CZiuiaNci/4qDeAXy9rsH98GGprv4hYYBq8d0cZI4MDXAqnSpnp/mbSkjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZqjbuTO22j6x5A2zFdw/110ftXn3gFlkaZXyz588lyY=;
 b=CxfMEhnVPXaLaQ7FS9THYgZsfBV+HtMC8HD0pMBPCCVaKkkJSfBQimmTjTEatLQhQdUZvH7wJGOX+T+XiX0A2ehLs37L9jCq3I1LMjK/OrdZWF6kjAAds1n9zcP+oLQMdOMnbUMJ5Hk4g0AW+gADd6/KcU6ZJ5KNa7K72gWwJhmIGPJcMZ4E61Y/dHPpYr2FH6TXS9jQfVVFVI65DeFywOYwUpwKjElTm/gtgTNAb6a+PuVTI+9yOZ5ROZAWJaEwX2TwaBqLw6TIJTHuqzVPXYh49O5D+EV7xXi10oHnVyfyxE3xe8a7qZ+picOXIto9iipmgJvYImRoqMcxbDkcrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZqjbuTO22j6x5A2zFdw/110ftXn3gFlkaZXyz588lyY=;
 b=tFSeXiP5yxg0BhFSa8dSFaSSPgXwn5Y428zKTYKZme3l0QWxPwQRN5FXlcrlhhUHQS4M+iJZcbIh+0bhC2U6VnHuRwTQvoa2T2x1pHS1PnXgoTFG9XFS1CHL1Wgng95lb+ech8Noi8OWHttveG5f3BNxAd95YMoQRjX0sWESE1NuuviOXzo2n/v06ARZ/MXZJHBjNLPe0vkGI9i8xx4mA1dQMT254UJQBcLXEE+aR2zDUwilqyip4QWodjItoTT554qz7RQVZtV7v0jUoGAhRiQTutKFT5Y2MOsaJgldfEKcJ5FY5401J4qYBVtcB66OJj529YgoA9N2HQzHjT1FXA==
Received: from DS7P222CA0024.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::13) by
 PH8PR12MB7208.namprd12.prod.outlook.com (2603:10b6:510:224::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.22; Wed, 14 Sep 2022 15:27:17 +0000
Received: from DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2e:cafe::11) by DS7P222CA0024.outlook.office365.com
 (2603:10b6:8:2e::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.12 via Frontend
 Transport; Wed, 14 Sep 2022 15:27:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT026.mail.protection.outlook.com (10.13.172.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.12 via Frontend Transport; Wed, 14 Sep 2022 15:27:16 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 14 Sep
 2022 08:27:09 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 14 Sep
 2022 08:27:08 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Wed, 14 Sep 2022 08:27:08 -0700
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
Subject: Re: [PATCH 5.10 00/79] 5.10.143-rc1 review
In-Reply-To: <20220913140350.291927556@linuxfoundation.org>
References: <20220913140350.291927556@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <de27f357-fce1-4f33-a801-8b82f269ee45@rnnvmail205.nvidia.com>
Date:   Wed, 14 Sep 2022 08:27:08 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT026:EE_|PH8PR12MB7208:EE_
X-MS-Office365-Filtering-Correlation-Id: a55f9000-1682-4326-9fb2-08da96659b5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /I3ko5x7rBn4gO8IsenYJ4VnTxALD2ymAtkWA4ezvNnQ97oS6SFYNoX5N9DAhLvT+9DVrs/IyeHFQhx5bEJv8Fpt7vY98SZPYXJrfLUCKh9N4T7vpt/zUK5Al6kr2gux7f7tmOtk9RwmYXpUk4X582ulc1m8mcciY8/qSDM9ykxEvBId2egOnrVMKfB6h/l8XQja3TIPZtzW5kZ9UNR/zKXgeMfTByMit21409pPnruTZTA9/8/MtlvqZss2PuK/85Ibb4nUc3HULNmTVqlH41NkOYxh6uZEApH99EqvOAZvin4C9hOSKOl8pseSSVBUoFWVUZRyjopEz5wqXAmlxrjvBPzj353/s8Q81VLh1N5d/6GLYhu5swPHRwAi46ionLcF4lUDGNvpatA1HV4b/AsbUhntY7h9XEtWNkpO5QVf6TGsEXI230Ka/dXaIbxVNJKIzdi40y8+gcvRfbPqBqRzb7i3hj06PUdvYAFYylcYi+5oBzsGKbLcHh4JwkJJ/K9J4ZV5hryFxQUWVWsHJ/ULZ3HrkbgB+HqihmCWFvaGQ9r/cvO7YJc95ZX8fkCfDTmmb4c6NGgd4LnyS9/UH3bwyghZeZWMmNXySFNN/L+sohuH+KJ8W0uvOQfOQLcz5MwxP0sC9KdXb/Q32c1eHHm1Hp5IwrJALBwCiyb3kmI3iFlytXWQGBrUS13Jf0Ybf32dp0LYjqnkQiF4s1q1ZjpDJ+De3lItgf/ifzTiF0VI17BomRGqNKOOtb/hYFrAHR3dSFvGnxcLPq/2BF1rGfxj5/8DI2u6Vcn0bJvMbUGgtiUK92tG78wA6gJguMKh1dqGIcT6pi1qwf/dyMsmAxUI5tnEhsiFOqTAseBVI9M=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(136003)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(31696002)(6916009)(2906002)(966005)(5660300002)(426003)(86362001)(31686004)(8676002)(478600001)(356005)(316002)(26005)(4326008)(54906003)(40460700003)(40480700001)(82740400003)(186003)(7416002)(41300700001)(8936002)(47076005)(70206006)(70586007)(7636003)(82310400005)(336012)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 15:27:16.6848
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a55f9000-1682-4326-9fb2-08da96659b5e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7208
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 13 Sep 2022 16:04:05 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.143 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.143-rc1.gz
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

Linux version:	5.10.143-rc1-gb99fe4c8b8d4
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
