Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 399124BF7DA
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 13:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbiBVMI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 07:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiBVMI4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 07:08:56 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2078.outbound.protection.outlook.com [40.107.220.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63ADB2D47;
        Tue, 22 Feb 2022 04:08:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dWzL8Ip/ZbJvpNswDS5XYLrgXUIx+dcZ9HYoap+sDGG2MGHgTK/ziNQ7yuf/4BDLYTTCcUPSGvXnAhctgkr88ywcVkSfb/Xe3asvXmb36GOF4Tb/S48a1/fAfngD+kEczgFgEWS/fRpi5KNixkV7frGa9xzUxGvam7pNDS3bWfScdebNuxc1shKsL81uN3nDj6jRL40ucY2W6xzSwTr+3ZyZq0TdEOdbgE37VaP6kUJpsAmwwuLLL7sUbAdw0tr0HQngoTp5KSVvWDdqR86fAUnMvXmSiKChjNMj/yDgoafn2E/DMiaGP13FFl+LayN6+AEbnbYGrSsBo4gbR2BKvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FCJorY1r63gZu37H/VRfV0ewgdNqLPgFUIHTlXV/6V4=;
 b=mDmNKji6jOVbq8DLdMJbb2IjiwHPNB1Nqo+31fGZ8LeYpQjnvlfWPnjbW0B4nTcZNtRqJBlxlbUKkeDzWUQND1g4Zl2WYoLfWy7PRwdifgZllY8LL+2gl8Ub6B4q3ilgJrHOAmXDrZfVnHd1iOOnmaBOfuaDjpy/rEPBkGq5SGMvQBDPf7G13Sesi5m25qUqF+5XembkTEjIxp91AjabFmKPrNXJ545gT6b6XyOqgi5MAKR0M6RpQofYt2FuWHcvOVvu9PhN9TJAYss+/HUACpr9tzXf/NLSbGGQeC50x2vhoFyN91LrJUU7XxPbz5Ci2AU3u1ElYCUfAl1wzf5RKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FCJorY1r63gZu37H/VRfV0ewgdNqLPgFUIHTlXV/6V4=;
 b=a8Xhsmg5AwAJb4oLXa44N2BZ07YoB3Lx4wj10ah7gXf50EWqH6jGEd4WfTGhoQ/gP2If18Lj7KEODdlmyg+RgGOcqUSPy0i0zCTiE6jOM4beJa4Zv+SuTtDKlGtFYDpiIEn/tpjfHnMQAYb2LLX+82O0KOGwRMC6gT0/sOrmwdHWl7kew+CuaGlHcZzAMH2KOGXTI6vsDzMtHwdIYa2RLkU6s8SA0+ixHmKkB/n7XR53w1AC2x5jJI8BJwC6AVYLPXSU55l7qaWw2k+L8ArVQ2/w97ZiYiZLqOecDXKd/UkQfWSeKUsU2prIsznslPBBMJFO16ONkgSm3czIG5sXng==
Received: from CO2PR04CA0072.namprd04.prod.outlook.com (2603:10b6:102:1::40)
 by MN2PR12MB3824.namprd12.prod.outlook.com (2603:10b6:208:16a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Tue, 22 Feb
 2022 12:08:28 +0000
Received: from CO1NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:102:1:cafe::6b) by CO2PR04CA0072.outlook.office365.com
 (2603:10b6:102:1::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21 via Frontend
 Transport; Tue, 22 Feb 2022 12:08:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT034.mail.protection.outlook.com (10.13.174.248) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Tue, 22 Feb 2022 12:08:28 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 22 Feb
 2022 12:08:27 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 22 Feb 2022
 04:08:26 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 22 Feb 2022 04:08:26 -0800
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
Subject: Re: [PATCH 4.14 00/45] 4.14.268-rc1 review
In-Reply-To: <20220221084910.454824160@linuxfoundation.org>
References: <20220221084910.454824160@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <dfbf5cbe-974f-4ba5-89a4-ad3d02718524@rnnvmail202.nvidia.com>
Date:   Tue, 22 Feb 2022 04:08:26 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 616c6a70-0a6e-42dd-ad2a-08d9f5fc090f
X-MS-TrafficTypeDiagnostic: MN2PR12MB3824:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3824F06F01E5397B85C9EF04D93B9@MN2PR12MB3824.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aLctBctoz+0iLW8HGDZvFjOpFQPukuZptp3o5c7/qfrvMnKVOWu/RzmH4Z1z6432tOqP7kvYPAymvyWnIhXCriSl4MY++YqKTO4s8tfBbTTuhEC+RUdvKn0IaKloUoY37nIrqkkqkpClzRhECvRLBEit6BginjMrz5eMlhD84vuUIDVNiGAOJA+MfSFJ1AI4voUyJjT5rSGMW0qOyJQ29tuHM8YJIjCJ6FVybwCbe1lrUtU1V9190iqBydeDb30C0HOTXtFbok61050mQEMbNJAWJxymzJlCGX1lxlP5Bug3qzhZFtnwehzaeFuK5ennGbBPd1zvKW1DAWJgelUWjJreCRXAwdwF8UJ3MDrxOgfh7LRsz2gaRHfwcFyEuRg5bJl0FxZ815tl1qf8rWTJ1BoRGEbyT1duOG0R5Ds3gaRp1f6h4nCqd3yR4J4/JbW+qihFZ/cUS14PXEhE0fjlc/i+NNiXUvF7dq8K//YFlyYTd5ccXGP4ahIGBVCuSxGvhmKhVmTksR8nqSd6FlpvSz63BPXbLss2gMKW8GCoDu/X4SM7sV1dKgIgT9sUf3wIEraXBEO1LOQLeToxpty2TrkKARv0eO4mSYtMwhd5C6NgJEOyt5ojKpAGrBQcwfi+8YBPrhHlQANMFcQ1x3zuCafIgd/VE7ySsvTVfhaoUsKCbTUAdWs1EiWDgK5WLaCT59L5urOHJWcMBw4hoqZCe9pxsK1savbymY7D5THMATtfy8khW89g4RI/2g+/fvxJWTY3aMhZ9rd+QYOkeZgZcGzLS0rIoFN5AcYRZYhMvYs=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(5660300002)(82310400004)(8936002)(7416002)(70206006)(8676002)(4326008)(70586007)(40460700003)(2906002)(47076005)(36860700001)(31696002)(86362001)(356005)(81166007)(31686004)(508600001)(966005)(6916009)(54906003)(316002)(26005)(186003)(336012)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 12:08:28.1284
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 616c6a70-0a6e-42dd-ad2a-08d9f5fc090f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3824
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Feb 2022 09:48:51 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.268 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.268-rc1.gz
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

Linux version:	4.14.268-rc1-g94b121cc896a
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
