Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC3C5B1A74
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 12:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiIHKuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 06:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiIHKuI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 06:50:08 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on20623.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8b::623])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7423C155;
        Thu,  8 Sep 2022 03:50:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Deg/9egzv87hCx6ZIZSJ0O6T5rNFzAzb45pp4+Ql9FtpVZI3LA1TSpQfddr3JlDkCWi8UBf0DlxubBHjQ0Kn6m7yQeMQ4kQsjRKTVNCxAHhH42my/mns/votg4Dxcc8bCOJAUEySPuDAe3J/5EuxhbOLJPvIjMw3zYHE4Q6Z2r5j7QUCuhkHmzUJeJlvBRBM7JYhls2kdk0XIu1BDij0eRSPUZKGa7uWuU4sLV36J+hEjnAyEyNiGiCkKRC5BB8g2FRaYo5cSEYNDq0mYGQCLcl/pz+skw/hEhxY4ED7ZfdWch7ETPriUdI4o+EHV4UUS7vZ4pWJ9vPzPdWaSA1rbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5cdmZyHza+sihQhvg6kFxfWwJbE/AwLk+vNi9NjLMSw=;
 b=feg4Mg2is6X/x6ZDfovV1OpUYrP0KHXbzIy5WHXT0oZ/q+T/rauOuj+dnuIxJkE5FQNlSjngTTvPUyFN8QRYfKYCx0BiDH29WwYgvVx50JBeaumPdndPwQtgazhQAb4nn3Idok2OUIUVI2iS0mZSQ6TmZRHNChNUg8T2gqS31xwWKJ3Pk6xjJSLo2XK9lihoDZ30EJnOnoKm7zCvGis7oG2MQBQ6JdhLz2a2z2GlOln1HBIci3RHn7OiUOgk3XS2EHZ3Ay3bYaSI4hcmo+rEf5snNM4YRX2Gt0kAJRQkJPI+UHfrPBJb6iskObdZlJGiXngyzZoACPb2emEDj0LFyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5cdmZyHza+sihQhvg6kFxfWwJbE/AwLk+vNi9NjLMSw=;
 b=F7r5tKq7cu2bGsbM4NLozU2BcO1kXwbaKILBtFwglAq7BJY4D9pfwS1MmT6sCC58Af9vNvVDJR5GwCfyud1RBuGuEU6FSn6TnFHiGnCWoiJJebfvmsytEvO8dExZj+6bBM3JdUkgBC9VKz5OxMHTfGHWI7onvC2pSZMPemNQOzcKcxPKXR5LF3JS9nsEqfLXvnuiUA/3DFQaDaJiq7YnKcef1G/OP+vpmyMU1hK2l3Ax+elmOwKazEag+hg6xAGXt5IaRP+e54tGiF8KHidEHC+KEwxUCLU5ax/TpfTfzkgSOBkrYNCnvgOv8eQ8z8SbD9FjOwDjuHKOEt05yCsz9Q==
Received: from DS7PR05CA0052.namprd05.prod.outlook.com (2603:10b6:8:2f::30) by
 DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.16; Thu, 8 Sep 2022 10:50:05 +0000
Received: from DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::f8) by DS7PR05CA0052.outlook.office365.com
 (2603:10b6:8:2f::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.5 via Frontend
 Transport; Thu, 8 Sep 2022 10:50:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT016.mail.protection.outlook.com (10.13.173.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5612.13 via Frontend Transport; Thu, 8 Sep 2022 10:50:05 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Thu, 8 Sep
 2022 10:50:03 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 8 Sep 2022
 03:50:03 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Thu, 8 Sep 2022 03:50:02 -0700
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
Subject: Re: [PATCH 5.10 00/80] 5.10.142-rc1 review
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
References: <20220906132816.936069583@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <02aa87df-06cc-43d1-b12b-d5657ff12fc4@rnnvmail202.nvidia.com>
Date:   Thu, 8 Sep 2022 03:50:02 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT016:EE_|DS7PR12MB6214:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bad388b-7704-4bf9-dd5c-08da9187e3a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3AlDDGRaVvlqO+lYlWAqupr4BipXdNDBh+x0ZXTSFYrWmd8KPBltuWpg5UXaYCb6heSLJvhIDpvGutkxUtL4FBY7hTnyExzIZlGLGix2yZwVWpwQt7PCaeKe9l/sMKjlgjjXPoew7wuwjtIAdhrjjT/b3pbx8AyJKZZEh/7qJdduYbh1ZhjRgkQZpd/Apld2CeudPHXODaRpmn62lZKLpbiHYJ+1x7KKFXmLS32+QjjQE6+mu3HWI3ucxOxlvv3czvefYABgm0XUeYWseFIRtLBkgajX5rEqYL3l4sBrOng+/Tpcwm6dMOHLmW+SsVzcgBgpHKkkquZ0NXT0TklozZ5fvLaGimXExWFcIJXMDdPqzXPqAMCrdjH2o6SMTZ+vtMldubXyBClig3kSXCuuTkssq3gRW0V5j+ZOX0TpiZuSrzGhzUne8tf2njXDO1cDK3Q6acrepTSbLyGkMgCHcFTrRIvxDVerQkrO+SKVif+6us5GUSh+HpPMVQvISXAElI6jzQFAwoJbfgPEMRVukmYl6hCTwfRwC8Fiu1e7C6qduiHz+7j20A76wOu/6xP6YPAVaxKDwGH0RAkIoQGI89OQaQbUB4twft8cKxdNV0Pj1aomrTJ8zso3xmYuszpqzZs34FwBJUox92qSp7cY9x1+Y2cNtvF2ooTKXPgh+uXJqt0gBzWYm6H2xWwH6t+yegYp6rgubXRBwP8/LoOxeYs2TmKpJvA8iPz4/J+kQuefvVhTSTSb6oX/Lm9FTpUEIgW/Tcfxg/RpFHc6ykxu4RsGNz5PFamjlByi5p+4MopMLOVWjbyVr8cfYnR+jXbcpHZ8q6MsG349nCqD980Wvg1z8yC1GVYu7b7y+hYtakvF1Pk/iH3nF8lKX+QJh5up
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(376002)(346002)(396003)(46966006)(40470700004)(36840700001)(31696002)(82310400005)(86362001)(478600001)(41300700001)(966005)(26005)(356005)(81166007)(40480700001)(40460700003)(186003)(336012)(82740400003)(4326008)(36860700001)(2906002)(47076005)(8676002)(6916009)(70586007)(7416002)(54906003)(426003)(70206006)(8936002)(5660300002)(316002)(31686004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 10:50:05.0810
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bad388b-7704-4bf9-dd5c-08da9187e3a2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6214
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 06 Sep 2022 15:29:57 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.142 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Sep 2022 13:27:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.142-rc1.gz
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

Linux version:	5.10.142-rc1-gc5039c99f555
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
