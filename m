Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFEE58EE48
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 16:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbiHJO0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 10:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbiHJOZl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 10:25:41 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2056.outbound.protection.outlook.com [40.107.93.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91FD15FC8;
        Wed, 10 Aug 2022 07:25:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IoJpKs3+CpLejPpM0fBJBrj0gpKZ97w1zUQJmJfymHPYGPK8kbJiCg8cD6+xAxPOMWf4/eLKvYfnBvyp/PSVg40tj+BtguVKMtrcd3XHTSOwAdaCl8V20cVX2nPYb28JvIJN0UssL9LFWmNL4YGyviTw1jsCLsX7x4WQgm0BEMpYXWIcFbCvtB7nNsckFZJbOwd7jnj2CWBUqE2xZfhie3jh9cyV3hHjeXy3+3zrkOMKbnYZ5T9yG28JSm9SpQIjCKYt4FbsgtPi3kVNAf6VkL3nWiduqFTwuBWryceJ9dcq+UvFMlTmdp6Flhv6lFyT/S9y3FDjEB/bJmIspdk7Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vZodCoR+L8O7PadtbIVAvaTZQsNY5ZUVLWxtZHccWRo=;
 b=k/c0xo0g3vOMTmaISrSijHuP6hOOMTgSjDRgWTQYc0sxCnFuhvKVD6rwcwJkfzutdcPdeyJxiIqwZZBozmP12vqIjZkXP25FC3Em+7q2bea5xJJLu/S5CFUNgEXXDsFuVTMpOX/2l0ih/ojOUm38lWwON79Tlhto3+ewmVJ/X0jzWa3Sf8z76z8MdxGdnRwCWo4fsVxCtRBZdR0MfubpJQztmgC0WMyhOoNwtdv222TwoVjU6ew3K36A2PLcIZZfFhuZdlWHQc4WGai71Mc9HG8xFj5JBRV2YtYdxfUiXf52XgLrqV6tRWGT8J1WbGEfQgzzpfQovVtT9zxAhBj7IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vZodCoR+L8O7PadtbIVAvaTZQsNY5ZUVLWxtZHccWRo=;
 b=VunRuH6WP91sWRVfnwBPtWm/7ZscTy0jaGsDUqM6rlPDMiHymus2AwDiWrIdmKqidsLLYKe1hyi+1wvHGc5I6c7L1r7om7YVB3cenhXbvgReAkaMM/76VAOTmWbb9FJ9/bFRwvdKQtvaxYqJqx8Y1QcsojR2ZzGU8OMCvOJ05Rw/mWpTSiufB44gL1KPiP5vZuH0RrmQLBuxUGcMJ3658ly54pWr5QZmQdlxzx7+sTCU5fGjPEFz8vbMf8LBNRDNq3TKV8ZjPCVxvh6Z7kxTsZwqI1BAYZsZAG2INdU49vxLnjbbO1K/CzaC6pRww27iDGGDblxt7dAIxDl6p7ae/Q==
Received: from BN9PR03CA0187.namprd03.prod.outlook.com (2603:10b6:408:f9::12)
 by DM6PR12MB4827.namprd12.prod.outlook.com (2603:10b6:5:1d6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Wed, 10 Aug
 2022 14:25:39 +0000
Received: from BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f9:cafe::d7) by BN9PR03CA0187.outlook.office365.com
 (2603:10b6:408:f9::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16 via Frontend
 Transport; Wed, 10 Aug 2022 14:25:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT038.mail.protection.outlook.com (10.13.176.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5525.11 via Frontend Transport; Wed, 10 Aug 2022 14:25:38 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 10 Aug
 2022 14:25:37 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 10 Aug
 2022 07:25:37 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Wed, 10 Aug 2022 07:25:36 -0700
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
Subject: Re: [PATCH 5.10 00/23] 5.10.136-rc1 review
In-Reply-To: <20220809175512.853274191@linuxfoundation.org>
References: <20220809175512.853274191@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <2051f9d9-3acb-42c0-bb51-15a2fec583c3@rnnvmail202.nvidia.com>
Date:   Wed, 10 Aug 2022 07:25:36 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6e35668-8ff3-48a1-5e5d-08da7adc3293
X-MS-TrafficTypeDiagnostic: DM6PR12MB4827:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6MfeCBbi8uQ44m8S74ay1x8sngtjPSUjj2R1CFzW03zsHkzB1oE2ZKtsZoQHBNEkrQ8fHCRqUBpqEJjE7IyxA0vLO/28JFysRAvTv6EAE5afA1ZN/AiHa82JKs4rpVPlEVB6YC/T9KWwEp/VnJxqwlakym9KpHMWzXkVpDjGPVFWIJEfQd0rufOPu/00mdTW4S836QD+Y7OhNmDY0+mgqA8kR3JTXIJV5w6oI7QrQQ4d7XK1asg+XuOEVGtuz6UCr9dDaWW6eQUT7+nOv61xstKt/x73FNg57c8ilOhA6XAMSeY84xk+Tc3ts2bBpmT/WMqtURgCQ/L0S6mr3cprbBP//HwlZVXFByayyDQLeVpVpYK/GdZvgMfux6rpvucMtegE2gLMPzOHPXF9N/dY6GElAOPPJxyRFIZhYyBoDhpxgVkEdIsukjogIaVHhxqcpQwlzLjpwV8KNJPfjvIwHsH4wDnM7ZzMih17cSj4qRk5JyuuMo2+MePz7gl1FItuM0oOLGanIWZfjjeCx6FBCMOe4E9kJneQuY2Ht7ZiA0ypXcY1GTSN+nXbf3BRyoAWNsdDjvrTOq7GRSVjfzVYknfz/jhUFaR0viy/6VRa810sLZSra/rDzL4ST2z9WZfJ9DD3P5nF7fOQA8JS29r3ix3va+RfMPhRhHoKHCywtpeSv+IvnXiVSK1HjLuLSW7B812DN6h5zO8fY7fqYXjwrHm2Yc4F4jo3zIOrqvP/U8Kx7rgH6+O4WVi0ICXsXT7OtfG65/Noi2NxBVNpPtZstBNKZ9X91A4Uw/Sssd9rnXbhqfR43KkdF/Y0Yb10PtIj68UxT8EVarwF9IJ+rDBw3SKK9YLtZ2Rd+rTotrJiGYff6CmEWE4fVmTfhGrgQDKQrvwhsYk9VRHvFiZK2no4zLPHNcLknqLHGQDNrUrVwno=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(39860400002)(346002)(396003)(36840700001)(46966006)(40470700004)(31696002)(86362001)(41300700001)(81166007)(26005)(356005)(336012)(82740400003)(426003)(186003)(31686004)(47076005)(40460700003)(36860700001)(8936002)(70206006)(5660300002)(7416002)(40480700001)(70586007)(8676002)(4326008)(2906002)(54906003)(6916009)(478600001)(966005)(82310400005)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 14:25:38.4696
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f6e35668-8ff3-48a1-5e5d-08da7adc3293
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4827
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 09 Aug 2022 20:00:18 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.136 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.136-rc1.gz
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

Linux version:	5.10.136-rc1-gcf6f87a93412
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
