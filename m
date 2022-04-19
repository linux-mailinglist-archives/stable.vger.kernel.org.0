Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79A5B506C34
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 14:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234378AbiDSMYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 08:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233378AbiDSMYD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 08:24:03 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2078.outbound.protection.outlook.com [40.107.220.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A042A245;
        Tue, 19 Apr 2022 05:21:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CI6bRUDlfEygbEyONDRh/zRMsj4/iWjGFK9GXzBtxjT+vIfRVQGG17zt+DhKcLcKFQiP8wNaRVWd2nEnyopEzVixiLWm7fX2mmEEs3uJiOyaFNxedW0L/s94r7ZJPMo0ahyjyE3wieQnpjqNpbjQhK7ZRZrtWpm4RDfcZCCznLoOYPdo9iqytmm56/ntw0BtbQEzwpo/gNgfJ9zX0n/r0GpiC19cpAGLBTDDJ3T6en07JNM4sjhxZAqBZunweQVbWryq+3KKKQ56zUxk/ZVL3vKlGpv2l+GyNnykKWobP6Bk5c+IVJhpbI/SCQ2jKoctvrAnxI+Lp/EIDbFzY1JG8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D9TXjy6PumAslVbzpd9o8kO2B7dW2MJgwiU3pwKQKe0=;
 b=LaqU9cc4VMkmb6Jg5KJ6LgC/FBPzUD1kWWAoF2HE9wvn5kCdTbFht5hpC0x843wDNogHJQeqCa+Jd8TrNvyz+J4L596p1QbDgtpKXEPWuAWAizeo8ABed4nQUCo2YtJ7zCudAFvmDi8GwY4l2cBg/VQwP6zA3E23hX/Pkqd5r5XfhYsPx0+wL5u05qFp5syzqRWOyYzCzCURDkrycwAkGiMQ9cU8KO5A0kjiJ1AR3w2SHJKAtszKF6EWVSR0OOc272X0ALqQVGOikNj5huqIpa0p7ENncmGY+0O5+T5l0O5igX3ZnMGH3KpafgHfKvtJWC6ra7awmYwGe4htpTfjYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D9TXjy6PumAslVbzpd9o8kO2B7dW2MJgwiU3pwKQKe0=;
 b=BxMMcFAcThBrYeRKeYGb0DlOx+b4CUCbHjNNuiwJUMxJAGfQ2EuKjeDNeGu9pe1YZkk1Jwi1ea8k9ugmdA5d15uPqmejcINTBeXb64+t6jBYHWa110SHrWqApH/G5i8OuXjC9kgoS6u1w7M8zS59rl90PPxGraxsGXyxyoYrjXXxitenEJPF/WKU474oq/WMPAcAPI7AKcr+x+VptMyTmYrFuRH450cZbZ22cdFOm5mowZ0Zo8+kRwXSG+EXL6hjwwwxGHhsrg2XYlHJsHzFRm2W7Abl/Zz24qKHc07bX7Jr+AVe+jdQktGGHDGwi/3G5oUEM4t0cuHBuvX1pKvOvw==
Received: from DM6PR07CA0110.namprd07.prod.outlook.com (2603:10b6:5:330::26)
 by DM5PR12MB1356.namprd12.prod.outlook.com (2603:10b6:3:74::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 12:21:18 +0000
Received: from DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:330:cafe::f7) by DM6PR07CA0110.outlook.office365.com
 (2603:10b6:5:330::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20 via Frontend
 Transport; Tue, 19 Apr 2022 12:21:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT044.mail.protection.outlook.com (10.13.173.185) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5164.19 via Frontend Transport; Tue, 19 Apr 2022 12:21:17 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 19 Apr
 2022 12:21:16 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 19 Apr
 2022 05:21:16 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Tue, 19 Apr 2022 05:21:15 -0700
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
Subject: Re: [PATCH 5.4 00/63] 5.4.190-rc1 review
In-Reply-To: <20220418121134.149115109@linuxfoundation.org>
References: <20220418121134.149115109@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <6a04254c-f37e-47ca-af18-df7b405b888f@rnnvmail201.nvidia.com>
Date:   Tue, 19 Apr 2022 05:21:15 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 781ddb4d-eb3c-4610-bed0-08da21ff1ae9
X-MS-TrafficTypeDiagnostic: DM5PR12MB1356:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB13569D8C89E5CCF0F17A8B60D9F29@DM5PR12MB1356.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hDt+DdQeERoaHB8Cbx6q3q5pHVpEWMqhl/eWCoZdFZFZfV5hgKzf/+NUUxodeJ8W3NrW1kCHXZtU3ZJbbAb/1vILZXu9TIAhx+X7AAshfPa2xy9gTw/dWzJ2kBhxbF5/Z0WSG1xmywh8uHeMdj10kkqv5mhVc0QvTmyV4CNj5XU7HjSSh+tWxjgaCB1ztkSMduwgDayeTTS3mBIENiHC0bMKqY6n3BL0fXieZ+doSm4nV1GfkfiA6aS/hBlwEW/ZVo/J+6DJbmsA+vMJuJ+T14DvyHpUyDB/WvHszKFqup1TD3QGkjwgFYTENGGViqL9vTuNIhmtLmsaytu2qgGFEsWfM/Un/285zwvNgNVxfn2OaKKk1sK6oObN7bFjsJJwgc3Jp4C8lkwZ5vSEkJ04f9+BkrgtxhFWKKLErqMT5CScAZ+/7928wZNVUUN+J6np5J5tnU8fVBBeStIijRc0DFbwa8YiXAodWsHVtCy83jC/ofrkMpJmyYzxWUQelumgJZJvasJGvBdWUErFglY5emWV+QLD4e6YX/XtC30AOXrETyWih28H6ngt2WGGJBNLBhklOFVsCwOphz54RoVlcVokAHva7QVuxdDpV/mbt+OPPPJA1CeDTcnaV2I5MDPxPDnzEbuZEe7/6/YxuP0a/N+15/QKoqjF5fS8+uHrc8Bmpf2/Np4TnTD8SqCv4ORD2k/FFoMdH7Wv1nEPqgvxn6bt8bktYjxAo9T3bLVMdLjEiQuB6BhR9CcqHfNwtMehWeUM93gZT5s4+2/YJhVmWSw3nm/O6EzaCJoQgjXpeBQ=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(26005)(336012)(82310400005)(47076005)(31696002)(508600001)(426003)(36860700001)(31686004)(6916009)(81166007)(54906003)(8936002)(40460700003)(7416002)(186003)(8676002)(5660300002)(70586007)(4326008)(70206006)(86362001)(966005)(316002)(356005)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 12:21:17.7000
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 781ddb4d-eb3c-4610-bed0-08da21ff1ae9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1356
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 18 Apr 2022 14:12:57 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.190 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.190-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    59 tests:	59 pass, 0 fail

Linux version:	5.4.190-rc1-gab5555379339
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
