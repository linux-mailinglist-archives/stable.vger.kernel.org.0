Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E850258417A
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 16:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232651AbiG1OfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 10:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232623AbiG1Oet (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 10:34:49 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE13675A1;
        Thu, 28 Jul 2022 07:32:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K6V9Xtg0FIpPIp3tJe2REK5XFfM7SD4o8yiV0vvt7QRSujh/aMC+P8tWyizYJEwQyt+HO2PYpC6GXNZ1gAp7HkR1Lem8+dp63iG2jBpRZjwlkrvGVbqYKRYLUHKnU8KonooDGyB1MtAAqby8ouZLwEQX/I+J1aQFKhndRXocBE2Q+LhSpxZeqSJZnHfSpDhYlkMVVtD5SyRRM1REClDxLeugYF404XlBAeponDpRLRqbTxSFphtVgBOgA3qF2NmEzYpjg8/mQirxJftDt0aSAl0i0rK+bhhD9cI/ikg8NbFPCz9K/NY6wJAlxwXYjsbMLnvpxANyb0w6PV9v/N4P2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WHFmzgF8AL3vTFSPTlLaE70KLB+YhrI1S+7Z5OA/L6Q=;
 b=YVt1gHnltGBRYQ/6HgXwjLO5uVAWZhWYFALcyvwVRWoeYOo4YkGyKQCeyL6vk3SaabbN7zmrOiry+m+mN6bovDIH3BewgaT1iz1+YkAy4isWPyjEstGfH1+DrEGfEMjRSdUn/ulJVZxZWQ1l3U8gQMskI1TPIPJG7+eZ1BMJFy+ECyewczOtxBPXkRII91D34FgCcjBr71M4Y4Tu+SXH5P2+cgMM/GcLzM0ojRlMoIdvk1zF1wlUawOMM8HB2U4p6xG2YEZK+BOcqeJGepYAeiE9U5NRjU7udRm6VilyfRBnvEHqeMDMYOo7DWOE3V3o04/DNJdVYkgIDdAwxomaPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WHFmzgF8AL3vTFSPTlLaE70KLB+YhrI1S+7Z5OA/L6Q=;
 b=CgqSRa17W4zP7Cfp9LckAiTq0O3FiWzDUxlI9JCTVDNrU1f7bZk54+dPJuEQjOgkzMGN/u8MAgiHgigGR/z6nh8WX6wYLuyaC7hlUaTxikwyFVP58yOP1ZqBPfKeimA34CyyoJF9JFFaQjhO6+B1mnB2unBLhmxzTqFM2wI+r0JC4E8ElIdHDJ/L+Th1p/eglBOl9hw2Sol3PfsR/hU1rOuzf0ae7vP7KnBHQMdwkVzBV9U2e5LSiZwYb3ebg1eH2QMdUNGksTX5pxj4n231X6JXS9xFu/X9p0Lx76fMwm0AT6zP5LcQb0aeX4myCNLkbhnLBXZcFHOrtR9DJVvBAw==
Received: from BN9PR03CA0648.namprd03.prod.outlook.com (2603:10b6:408:13b::23)
 by SA0PR12MB4415.namprd12.prod.outlook.com (2603:10b6:806:70::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Thu, 28 Jul
 2022 14:32:14 +0000
Received: from BN8NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13b:cafe::ad) by BN9PR03CA0648.outlook.office365.com
 (2603:10b6:408:13b::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24 via Frontend
 Transport; Thu, 28 Jul 2022 14:32:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT015.mail.protection.outlook.com (10.13.176.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Thu, 28 Jul 2022 14:32:14 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 28 Jul
 2022 14:32:13 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 28 Jul
 2022 07:32:12 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Thu, 28 Jul 2022 07:32:12 -0700
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
Subject: Re: [PATCH 5.10 000/105] 5.10.134-rc1 review
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <34ad3db1-e41b-4cd5-a608-8ba17726e966@rnnvmail202.nvidia.com>
Date:   Thu, 28 Jul 2022 07:32:12 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3bdbfeaa-66b5-4f84-72b9-08da70a5f70c
X-MS-TrafficTypeDiagnostic: SA0PR12MB4415:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: huoY4TEk6BQ4f/GlK06tXrfkX9N7wn2nGfboeiUxBHGi1+MZAsctgR49Azu4iutghfyi+6L3TSELFC7Ht+EjQ48m3HvBULJprtQf+aHN1XYzUL32CAKi/xBjjmcFM/dkD3xiOMF1084nVt77OFTZ44lOWst7e82tsVlEzlVPEfjsLBQuWOjk6Srdyl7O9Tfz/tJOvnr3dzDnu3UWAbbB8GD/DWGppt7bAK0WDRFAlxzjHrLp5XQIYqQ+4qPMc2cnRDcYZWWup+aGJjR0Jl7Ue4iiMPEg8T8SS9Vgu2XztUPo/EXhZV7wv3Z4mDRkyt4604pAjqS0YuS7VcvW51Usmc1jFS/aBGmA24StDMWREP13+qmAmVJWuYv8gTDJjlvYSr8CvHCFOHFCzqBRTR29ADgNEQGPdOcfxnl7mfZg4po5VX7wLyDIQ0MQq7EaN4zE1plYJ9NXi9/X+euWswqeYAqdr/EmdHhnAf2woPiiwYX/Bc+Y+ONixqtelJ26bGEKxueOs3mIckzeSSCOmpHJAk03eiGi58f8u0O/l9FOO90SKtkSRpuDJ5nB8fge9lX4kOFNmq32HSihYqChIg/s1VSaHcIQacSN3+KnufZhc2c3/I9eVwiMY/x/npZH5A7iDq8pS0zKRVOvl4WroZ+NDQvWXBjDYuWkD9mjafHQ0+IrQ3nz+MzqqAjcykCYOZVkNVC4eqzA/mkqfYtFOe3RH7uEMQ/XL+LPRFzfiTeHah4LMQcUWQ+U67Z9P/wQZJ91JzCTsDF6lCQJ/ITlKOFGPNACQ84gfxf6alYzDq1HCLVqTmOuHxdeoZ0jx1+mcr0tE/hIve/62NzQX5DsZ9g2aytCUBIrHGTR3NmysEu2EF9IW18hAcE/vQbX0V/1zQ1+N9G3vmLNY+oN42m/ZgqhK1jSKj7O5OeigavQDqQ08MY=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(136003)(376002)(396003)(46966006)(40470700004)(36840700001)(356005)(336012)(47076005)(5660300002)(426003)(8936002)(26005)(7416002)(82310400005)(478600001)(966005)(41300700001)(31686004)(186003)(82740400003)(81166007)(40460700003)(31696002)(86362001)(36860700001)(40480700001)(316002)(4326008)(6916009)(2906002)(54906003)(8676002)(70586007)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 14:32:14.1174
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bdbfeaa-66b5-4f84-72b9-08da70a5f70c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4415
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 27 Jul 2022 18:09:46 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.134 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.134-rc1.gz
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

Linux version:	5.10.134-rc1-gd2801d3917f2
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
