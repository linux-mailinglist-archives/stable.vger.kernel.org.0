Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 240DF5ED780
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 10:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbiI1ITj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 04:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbiI1ITh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 04:19:37 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20600.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5E5BAA;
        Wed, 28 Sep 2022 01:19:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GplS5bbjUjIUkdHP1cxQ0iyEHTNdp8deXGI02dj8zrn8VIhm1noEfvFFWBWDBVwoGT1/v5Pg3mVEX1w9as+JvCUeRa+p6ZDO9pxFM+5NIXVH0X1/pZ8CNmwIr0aZJvRbv8YA8H9bl2Ort2MDsOPD9ZAwk9LHV1jT3vWk8Pid/e5D8QlrWY56f06PDbmtAPWGZewcDxr6DL6kBpPMBw10urnOlj3i16Z9/OcgHXL6sis/z/RQksCja5lia5v74go0k5QxQknoTM3nR1fmOn+VVE+MKYA1DH8mnAlDh4wB5W4Au3AU9YxvRkDds3tvz8Rpw/qs+I7M9cFaG8uoBDTKIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IydsbuW4AK34Km4r+auvB3wNt77W9UlBzNbqT6PowiU=;
 b=U+fP168TPC8hGLJwFAHVJ5CFx6LXmgHPrTfCbZzDxefBEfnI/qxxevdJrv7C0pYya7YyMn/TIhAYwd6YoKrRimkideslQMeSVDoo9/4+dHSLAoMhGKuL9BHZQzwncgf33J/4E44Ul863Tx/kiMLURvcqsukNWblbh1UVWUUKU+E6vYxDusWFCdniIW78R9wQZkLHfujvj0SxJWJUQ7L7ChuxzWfoctnLAzLgJmZlEH2vwmUPhhPVdz/pfgF3WvYv1iWnG1VaiSuue/Isf4iEs0TTDVc0sT6guwMOEVJmX/3cflVvuU4HZ6hZr5NQF9EfGDqrF6/aSa4nmKJZrv6eOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IydsbuW4AK34Km4r+auvB3wNt77W9UlBzNbqT6PowiU=;
 b=VK7KE2PY2HwRTXfkl4wms37+xWqC4uHSYkN7H6yBYTGw8DPMqu9kRSQIKwKhGLK/Xtww/3xOlMPGS4VFYRtFb/1uvrTn4nqes8Bq5JM7dxx2nY3GEL2X0OFEeByldjiZ7/CyUFTE1LJgGB/cfiHbGifV8e4x9dmE6KKIteQEFQ++/Ubw7F2RFxLwp3Lwl8VyXGx5/06nNLgy73oCSt/VfueE9qEqbytzzF3zLpkrwbau5Uy2a8XE06ASEspbxRzS14Uebo8I1rEDKuhKLyZQ0fFoMPONeF4wQDpFx7h2mzoLT7Csx7Sia9DV3iTa1rG2BVFPRixMtYdkz/O3985utA==
Received: from BN9PR03CA0176.namprd03.prod.outlook.com (2603:10b6:408:f4::31)
 by SJ0PR12MB5676.namprd12.prod.outlook.com (2603:10b6:a03:42e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.24; Wed, 28 Sep
 2022 08:19:29 +0000
Received: from BN8NAM11FT070.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f4:cafe::45) by BN9PR03CA0176.outlook.office365.com
 (2603:10b6:408:f4::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.15 via Frontend
 Transport; Wed, 28 Sep 2022 08:19:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT070.mail.protection.outlook.com (10.13.177.50) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17 via Frontend Transport; Wed, 28 Sep 2022 08:19:28 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 28 Sep
 2022 01:19:11 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 28 Sep
 2022 01:19:11 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Wed, 28 Sep 2022 01:19:10 -0700
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
Subject: Re: [PATCH 4.9 00/21] 4.9.330-rc2 review
In-Reply-To: <20220926163533.310693334@linuxfoundation.org>
References: <20220926163533.310693334@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <f293288a-7d00-4315-8c62-bd404ccbe89e@rnnvmail204.nvidia.com>
Date:   Wed, 28 Sep 2022 01:19:10 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT070:EE_|SJ0PR12MB5676:EE_
X-MS-Office365-Filtering-Correlation-Id: d5b36448-4be8-4c93-694e-08daa12a2993
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B+hHw816GuYabpbo+nMqDkv6Nvta6IdF//tmwl8wWy7b7UtVPOQuMZDjIuLmlr+QOG/SmA8v0isPYmzaV+9ZKE/aq4RTAZhsavlKGRo1Bp2hggZJj1txeqI7WnAHW7AWci+GTku2NYWyC/kslBHVisSw92nNN1Hf834V04Z/B1pdyl6d1PTkC+q2VpRLIk/GUFP1nHI/Ka4B7Gc6aGma2JKBh23QSD+yk7c8pgocr/+tZ8nDGdBdpepGSF56aJQ9BySYEstmGjBrEIQBpMPJPlQJGdSawU/jJJmm7gI9IZWt0LriYuX7H5XEHNjs/l80U2VYFCQGF/pVjEO3I+ANWNWuB7Mz86LiPXGMaJpnUfdubg4tbMBWoR7O/pF7rBFQ6faS/xWHfr+dS/0JiBIN23fR/0wRohOMJIFaJYBuLfKT9QchLlK7jNBfG+l+zNhU6UQYX7so5cPpT8NP5hF/29sidRnOhTECc5mJcyFDbgLyOQFm/OYmkyf1AorlAvYAGpbk7LbofIfzYKf27l9OURx5fvgfZBIirAvFHOPc8HYPBBqgRdC0L4LATnLjNz4vQtW4GECqOzFQO0PZJuo1VkyyJaUJIZdsTkSFzwrvadydUM5H3DuoXdBEtINsZkKll8ppPp8W21oTwSBWiko4kIJF9bxWjp6zc//FIeWGivk4mKbH2DL0r6I8ryRhGPQb8eradEmsYf6s0nNn1gWdurbio0S6uibgQasxyDls3ry2v/D5wOP3CRin23dNcwejhokW58ERJSw25RhZsYJfNH5NDDCYbbMC0LXr+J7E8j4tcxsnb+IIgoF/o0knPapcpqazL+YxGDAQk8eDG/o3p8IREDudggV81atFXJU0BK4=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(396003)(136003)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(54906003)(966005)(31686004)(4326008)(6916009)(316002)(8676002)(478600001)(70206006)(31696002)(86362001)(70586007)(40480700001)(41300700001)(40460700003)(7416002)(426003)(5660300002)(8936002)(26005)(336012)(7636003)(82740400003)(186003)(2906002)(356005)(36860700001)(82310400005)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 08:19:28.2384
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d5b36448-4be8-4c93-694e-08daa12a2993
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT070.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5676
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 26 Sep 2022 18:36:31 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.330 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Sep 2022 16:35:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.330-rc2.gz
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

Linux version:	4.9.330-rc2-gf631754acd7b
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
