Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB3C510338
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 18:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352948AbiDZQYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 12:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352941AbiDZQYN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 12:24:13 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2089.outbound.protection.outlook.com [40.107.236.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26CD51171EA;
        Tue, 26 Apr 2022 09:21:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JsVPOnKyJQKXFPnl7qk9oJ6IX0ft8wMxdW7eb8dNoCnq49Y8QVQ8IiqyISZr+ME1f0Fzxk3pWWtl3vSyWVy9DQdfHFB2Nqhp+jX8jCoRfsQoPHrB628kLyBIG3EGwOG4CsNw3tmO044Nq66WmKPCx0ggLzpCv5YXGm0lb6du4AP6hJ3HElM9bOmUoMUdPEz4x7MFFhnwmAdynE2aU1Lp5w/rvwVWvCV+IcQ5gxmWD63nSp9e9KueRr+D89z/fMkLCtahkMSP5cJ/q7nDeQeTfyClz8WtpF6p53gx0Hjo5BqCTA6gRVgMky8Vpa4Zv6rvXbFtpz7jcp5Q7uZPdBWNlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sRwhdA2qEXN4jEF59kgnRW6c0oxJr3GRdu4nfk79c1o=;
 b=Bx3TZ8ScnZtJc1VlBgMd1H0pcshj2PpxDwoRZjkNpXQls+w4XZ971b8FCsbgYe2SRkE2d4XxGAUuNeJA/8e0U/JnEkz1e4+hY/ou3vYYysbm+F92HevJHvDx0w65KTMR6LVCld+22ABlLS8HtDNb7vxm2cvF/W6DAu4hUYRPHlI84BsFSfQctHH/he2TdTbn2okd05brIbhj4+58lEr1J7eMFAg2D/+TyoS1pwB3h2eZETOLOrxvJ7W1haYb/vzWJDFLTdFU199rvJuJxmIwjU4JGHOtncu8EG/JThhr2v6GIAzoQYxnHdi2WPdyNs+7uzbvSbyemaYzZ/j4SsOLZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sRwhdA2qEXN4jEF59kgnRW6c0oxJr3GRdu4nfk79c1o=;
 b=Ek/F07zR9h5dyZ0kADMV7YPv8GkGYwYNU0vn3vQCOSMVG15D36RuEhZP5t83eyRqzJtND0U8cJZuG7z8YthxwwiRJB8UJ99EhTLE/7SaotNN3xwLL8FB6JD+VVnZw5n0hffcN1Jrg/CeIiDHx71Uv62tJQiarqLE+xHaiIIq8Wo9BxS6qYbCImqjko5njuyLmZTqqKfpkXVXTjh1Sac6/8n27gO3b9+7OrwSmlzYXFIc8DfGdpwwSxS7oW6O95k2kK7M1mNqtZgdtX+h8b+ei8ost64UReofs4dKyRi9cCXaqXJQwlAfmtpeGGxkNyGF0akhhG4qTfb8zCOmL+kVhA==
Received: from MW4PR04CA0115.namprd04.prod.outlook.com (2603:10b6:303:83::30)
 by CY4PR12MB1511.namprd12.prod.outlook.com (2603:10b6:910:4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.19; Tue, 26 Apr
 2022 16:21:04 +0000
Received: from CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:83:cafe::84) by MW4PR04CA0115.outlook.office365.com
 (2603:10b6:303:83::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15 via Frontend
 Transport; Tue, 26 Apr 2022 16:21:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT027.mail.protection.outlook.com (10.13.174.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Tue, 26 Apr 2022 16:21:04 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 26 Apr
 2022 16:21:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 26 Apr
 2022 09:21:02 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Tue, 26 Apr 2022 09:21:02 -0700
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
Subject: Re: [PATCH 5.17 000/146] 5.17.5-rc1 review
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <4e9edf61-f780-46b9-b91a-813701fb2483@rnnvmail201.nvidia.com>
Date:   Tue, 26 Apr 2022 09:21:02 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4b4c458-edd6-4809-da2f-08da27a0c2bc
X-MS-TrafficTypeDiagnostic: CY4PR12MB1511:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1511AA039840734722158E54D9FB9@CY4PR12MB1511.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EyAPMdKPZwYC0u+tMOEPc3DL5WGl++2u0roiou/z5jKabH4rRe5myGPO55fSzRGmfoO86qTUjbDMSL55+P2wZEaRSGB5Nx/GfL/VTHSDbO0p+dCkqlu93kzvBjn2A0VmItfe9li903vJ15TEnqIkJI/Myg+W0pYFllr4ifASmJ4LjCHs5e8pIwvUQaghw/2K7aY6VekcnCvkF5ZAUfTE0XTazktLPTG3U5U6qg0m4RdFPMk5A/u1CEMP5oDTpZtq4+QssWX25Fp8lEuSoH/zobdq2WEwXyyzh1ow5f68Aet2ElyJckp3pw214b+weu+JuFYJzo6G8rbzx+D5xIo+F9YVbRroP7RR4C4y9s3Rzl5jd9vhkddtKpU85mpiu24xv8F80oNI9K4G+g8uqWJ0cpsYddsZVe0Wt8of9VeSuRNPZClTxXTytjYkEEyg2kok+anSxaf9e0YB7dZ99zuCUWf6Q6uWz3Fuu22rBQmZvIejFvtjXAb++mqtY9Wbzx3iVxDSltTOGmRNxwI2oFFPqpQI+35c6NENTUsgzAgk+5s0NYZuhX+QPbq269CXC3HHhBqlG8oofShXz58qXNzTMyM07FOCS3oOROe0g42iNYcCwPVBmNwXCAoWWSFct1tViC3CIUf7guRqy9VCsV+7ZQXR2mdJEYv62EX7/aKjMmPrpvpLqL+wmDBNS6MbwmgE0O1AyUQduruEzoo41LykIflwnWae5u0M3ARHTF7uUNRXsktmFHmNGuaWBKswxi/kTqU0alRhKitgl81aSZdZ30GrSD+2XYaKMpZ0pGGx/r4=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(356005)(316002)(7416002)(31696002)(8936002)(186003)(86362001)(426003)(336012)(47076005)(81166007)(54906003)(5660300002)(966005)(6916009)(40460700003)(2906002)(508600001)(82310400005)(8676002)(26005)(36860700001)(31686004)(4326008)(70586007)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 16:21:04.0659
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a4b4c458-edd6-4809-da2f-08da27a0c2bc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1511
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 26 Apr 2022 10:19:55 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.5 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.17:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    130 tests:	130 pass, 0 fail

Linux version:	5.17.5-rc1-g97b613308515
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
