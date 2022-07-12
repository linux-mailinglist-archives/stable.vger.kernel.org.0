Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D90957158A
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 11:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbiGLJSs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 05:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232705AbiGLJSp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 05:18:45 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2DA11145;
        Tue, 12 Jul 2022 02:18:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C0JeAa7jMp1t9/sxv8F0MAVcEz6wUqT2KNZNIEhh+WYgfZas+jigFQLLEmtodsugfVpkFM2KK3sW+SRV3/naVOxWJotGby0wBEcBBlljbOsh6OBhphzvOXwh1NWZCdSiNIHIkwW5nwIdSb9y/oRCcOn2YW1N3Af3XlHw0ucizRQCumbmubhqZi4qp2sZQ6S2ctvef1pxw4EQDqQ5F7SeA8SY+yM6BJu5OKVr+XfDBmwckxgylSCR8/jTeSJ1mO0iCqQaTKN6WkoOc9TRsTfBMfzFqBY0Bii7c8T1dV8ELTBeVn65MXuqV0gY/KGmlbZTRFQJQSfX5mVeQ4giNw5wUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rejzVgYRtOfWhW54EVXu0iaeGPQ8WlwDEQB45wiLThk=;
 b=dAW7kyrbezKRlLfwuLKJJYSE2WGOM4LMMQkNsMYs/hvH5NTQVYwN/3jqWhT+1CRDaIN/WZGoBM+IG+XhUC0R3Gu7GiuUCzNqG4gVKeW7Bh+K/EdoUTJR02ArWG19T0+WoK2u10hQBSBjExeVXBhNofW+bi+Rs/sMLcou1+CGVmIdO293TBmZ3Nj8L+JXTq7jqfNTin9+Gl2fe4aMVO3s/pVCo2Fg2x7O4Wdg413SZrLvsnh0RNKdLFyw+bcckIEAsBAJ+WNIOufCMUyKc67LkXpZvEURxpJE+H9bwZcD3njOHFBxk5ApnWI3hZh1EuP0bq7pQXKxClizuoz/d3g3Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rejzVgYRtOfWhW54EVXu0iaeGPQ8WlwDEQB45wiLThk=;
 b=druBdp9VKUF8B3QosmVaNz1jl0V13WGbqpYQ/KqmeblV4BzRQi2Gq3tJanneyjVoJhRATyUIhlHg5AKX3yPy8EzcpJxNdLIMMSigsi7bjSxbfp+KpppJRvothPOVxH+6zXSu6TfR55YsUPfw2C67C2OsOP050zPIAmHlZcu7deQ8PsD/GXBX2JZYnyd3tBjGQ3+vxmeGAnmcdcdEYP3zWmkURhKvDkvjoosipFXhiBFQ8LOgR2lMmAU1zkpP5wve9BuEL6WFfTSFhi1Y/grGPZoVQXCb9KIXZ2sj3AWbdGjjxQSsq1Q/WFuJsKJ28e5mQ0eBl0JbuF08R5RHZ7XaOg==
Received: from DS7PR03CA0342.namprd03.prod.outlook.com (2603:10b6:8:55::14) by
 SN6PR12MB4750.namprd12.prod.outlook.com (2603:10b6:805:e3::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5417.25; Tue, 12 Jul 2022 09:18:39 +0000
Received: from DM6NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:55:cafe::6b) by DS7PR03CA0342.outlook.office365.com
 (2603:10b6:8:55::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.19 via Frontend
 Transport; Tue, 12 Jul 2022 09:18:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT032.mail.protection.outlook.com (10.13.173.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5417.15 via Frontend Transport; Tue, 12 Jul 2022 09:18:39 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 12 Jul 2022 09:18:38 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 12 Jul 2022 02:18:38 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Tue, 12 Jul 2022 02:18:38 -0700
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
Subject: Re: [PATCH 5.15 000/229] 5.15.54-rc2 review
In-Reply-To: <20220711145306.494277196@linuxfoundation.org>
References: <20220711145306.494277196@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <cb848410-6e72-4c5a-bad0-55d9a9d6d971@drhqmail201.nvidia.com>
Date:   Tue, 12 Jul 2022 02:18:38 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a1d6618-a881-4f10-eb0e-08da63e781e5
X-MS-TrafficTypeDiagnostic: SN6PR12MB4750:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /cK8cCykumtdXHVlJX90iQqu3NlrHcstyqQ5DV4yISDCyooWPItFCQjppq82EZMnc/GBVjhLFjtEMcTLmx+f67q8NuzNsE6P4wkHaWU53XdHDcAcy2ZPlfGjd5R5puLIBOJDg5qq1U19hYL4vPzGgpzcHf2gqAaSdmpBrVGo37+CSDMoGugeUzgWlaw0ANGJ/EapJIFPWD+0lYBJ09v+PCmVP6KW9xcZR3gcSon2e9gqoKIJHuLFIseH2vL+OSK81x2t8g12ooL7+diAVkeY45QPniH6oSdhaAcmnSHm/st7b/CDjxOKKXOUAK5IaVRdbs8YE6gP+sxDdQ4Iw3INoo4TjrQXpnRAs3BCwn5JcQUGqsQKepNQR7mh9u3+KvxzOi6guFP+b3bi+vky9m98kL4Fn8ugvwCaehJdDBLPV0hgzCSKVrRXI9JQs2+Rf/Yjoi77J5bIaaw+A6Bvsd9nIpk0kWFBWvVLE960VHM9idKzZ3lyLUxikieMQUZ878+//xT/wP+2yHOzl2i26q/62hnxFr2dwhqBTsXNf3G5WknJyWaT8DcNE513AdCdpY2X/azkPUIgrOYN3P4RsN3rdYIJtj9VxB4knkaDmCpwSMceBfOVKEVaJI+s66iMV1XPBT/Gg5U3ew1PAvjptABsju0BngGJmgcNs9t69B5n6dk/YtJcBsqte5z1xn6Ppt4o3kAAfJLlMaVf/CZxckvMhL9Va2ZYoq+U1XhsnjTRX4kHzq3PfdZpEazrdx4zyCyHqGre0CcpI3T4P702qopCLWf+/dyeT+7WSMnJGz+Bu18SaeWm43dnxUdxsMH+QjKOCtrSM7eRN+rFO/OuogJnWP8qDqgw6qHzkJhuLlTIRi/Gc2qGMhvVX71X9zywKayd0NyGJjiuWK6jogcdn7w80WCFhZFh17YMzBSCjGzIjKW6Y8CHQVEgGimnPsVllmjL
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(376002)(346002)(136003)(40470700004)(36840700001)(46966006)(70206006)(2906002)(316002)(8676002)(426003)(47076005)(31696002)(82310400005)(86362001)(26005)(336012)(966005)(186003)(478600001)(70586007)(7416002)(5660300002)(40460700003)(82740400003)(356005)(4326008)(8936002)(81166007)(31686004)(6916009)(36860700001)(41300700001)(54906003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 09:18:39.2864
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a1d6618-a881-4f10-eb0e-08da63e781e5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4750
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 Jul 2022 16:54:12 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.54 release.
> There are 229 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jul 2022 14:51:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.54-rc2.gz
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

Linux version:	5.15.54-rc2-gfba36d04986b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
