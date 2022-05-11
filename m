Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D247522F35
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 11:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbiEKJUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 05:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236591AbiEKJUC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 05:20:02 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135039B195;
        Wed, 11 May 2022 02:20:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EfTtEes8VQZGHqPVxHnscwU+QritqXYIcc7bGdnJC00eLTD0LuLvJU/cZyWwDbZdihQMXWkKiXKSr0qW9/izxhUZ9f2ncT9y8KeNUvexxJocq6OcvDYhI1DdkqhBUDAZ/2n4wk2VRTqUdiwiGDMpoSYpBK26D8AWVKUU/q9D9b0RHLSriLI5+bDAKrAh5rLiLwQ8Fy62m5TbgQrpVtgnsFj+So7RB/b9sMHTOlD1YMCGhc3FgwH/bxDdVgKM5bJUT0Agm9Szr3w/x37eGJVAPOMn+q9V6yyKEEsxDOEBPX2QdvR3eb3XXmoqJsc1RHXSXUomdQ3TiTMYvVzcT8qiSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ikL9kdWQu8PCG9A5r7B1zxgGpdAZxcttzeYEEntYuqw=;
 b=LxsApjExQmvqgvJOhNSugKHuOwqQhTpMKnINTyjo4Ja8ucZqkHrGHFem7LerbGcD+loU+bQlJxUDhnZpQIvTX0qQXO9ZWM0kPtw+aKl0a6RXD1rJhlfIvklIDJ0+T+BC8aCJmp7k/2ICjV55xuvDJ4slkRpOOTXHnBqwdjXvktJQsXHIwhq3pbZ/FtYxN6M24XprkNS9Ggga9DL6zp/VL68xLqKregyKPOfqh6TvITPP6OJkAFoE164P//FZGIfOfd3ln9wScHdqN+tRy/GZp2VNab5busqiGvibgF0U2wTNcIL3WEX/jPxEk5HDKZqokJhGrmXMwMk8TFUps2f06A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ikL9kdWQu8PCG9A5r7B1zxgGpdAZxcttzeYEEntYuqw=;
 b=OshDvB/G2XU9+HCTnNxzxP3bItw6y6WwueADXYh+dGZidEZmUeW76uMKQgR2k1p7il4vzl3K6ZjDQgtw/SSUwrdsF3R8Lzgn0+WO+QBouar7ZxW4/bjc7ddDsZrDG/25beuAnVy38F96OeKwrl7nF/Mu7AZ7nO670HjJMnBP7Mr76dqK+Eu4jN9ByrqvPiBf8YlDtCeUt747A3ZLLQBkc6nLxkZS/m0E3EA5EweSBF2YV/nbt0VE4VjECoLKuaK67sZAfYCW5pXSyNF1e9ToX6AIu+0gnYoJkvMtrZ1NdPthETc1B8npLGR/w7QIdWyAaNYlb87x8JcW/5POIXi+Lg==
Received: from BN9PR03CA0270.namprd03.prod.outlook.com (2603:10b6:408:ff::35)
 by SN1PR12MB2528.namprd12.prod.outlook.com (2603:10b6:802:28::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Wed, 11 May
 2022 09:19:59 +0000
Received: from BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ff:cafe::9c) by BN9PR03CA0270.outlook.office365.com
 (2603:10b6:408:ff::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13 via Frontend
 Transport; Wed, 11 May 2022 09:19:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT050.mail.protection.outlook.com (10.13.177.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Wed, 11 May 2022 09:19:59 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 11 May 2022 09:19:57 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 11 May 2022 02:19:56 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Wed, 11 May 2022 02:19:56 -0700
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
Subject: Re: [PATCH 5.15 000/135] 5.15.39-rc1 review
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <d90a7f92-e825-4a10-9164-48038b6bf37d@drhqmail201.nvidia.com>
Date:   Wed, 11 May 2022 02:19:56 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9fd6e4a6-0c98-4129-dd48-08da332f6beb
X-MS-TrafficTypeDiagnostic: SN1PR12MB2528:EE_
X-Microsoft-Antispam-PRVS: <SN1PR12MB2528C188A4F453CD394D8EDAD9C89@SN1PR12MB2528.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s+nA/XJrHJzI/VhejhUfSWQ5N6Vc8DcZcs0za1BjQNhRab5e9qVq6LhRV9xiuqk0cGFOSfc3vQsxk/pqiEttLDLxvHZa/BBFgA11p+h91KQcvBGqNeSvUmJfwBv2Q+HRqj5HZGPOQcDsJsj1XrAlhZfmW0LHDJ305TxB9OTQt7jTAdTBzt6IZjR2J+5a2d0PzL5DNY/tqY6ycCnp2nbZEnCSkVjuK+OX5dmhJYT4TFYJaY9+eBwAfnJ8spgyd5IrMkBBdlWHMYLNYlOE+UUd/sdjwksV3Dy7NGxbMJuJ3kHHtFbrTJEaz6h5Q2SZunwsGhj60MMZYUeeGEzQShVEadIvXGl4Bd/0PusvP/fUWF2WLewUVVqijPO/YQqXF74SZTGkoeuzN0H23v0ejn1odClusswTHCiNrajg5n12p7o4cvVNzY52pIWPMGHjSLAe+Qh7U0Qz5HaxMcr4Dovyf1s29aytiiv/dlH4nWB82lhTV0am3y/S307ZJ1MHOhgSuEaLIz4Mz8dlRJmwUksR3CAdWwOtJKbeYKt+w/rsOEtEJH5hYNbyeVEGHWrXg8zo6+uMWHekga6HX/wg4PVmu/c4a3dgdV6W+CRmnmOCDYHoGTho0I2z2qvORu3w/G5hNkBwnwebziuMEoOe5jALFI268FPzX8gb8XDtcMY7vOrD38Zvux5Y7EOfEDA6EEEXatEjzApwv3FERMPw+Yh5mOaw4xk4Sl14KrD49wS/8VWTaqvcMJxZjZa5wIlodUerISCfM25Y8oM8+Os+hT01FNEKsqmdDzDKNDX/E9xX/p4=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(47076005)(426003)(336012)(82310400005)(186003)(31686004)(6916009)(54906003)(316002)(26005)(40460700003)(86362001)(31696002)(2906002)(966005)(8676002)(70206006)(70586007)(4326008)(8936002)(508600001)(5660300002)(36860700001)(356005)(7416002)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 09:19:59.1727
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fd6e4a6-0c98-4129-dd48-08da332f6beb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2528
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

On Tue, 10 May 2022 15:06:22 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.39 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.39-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    114 tests:	114 pass, 0 fail

Linux version:	5.15.39-rc1-g60041d098524
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
