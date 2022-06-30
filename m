Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 050BB5620EA
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 19:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235234AbiF3RKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 13:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234431AbiF3RKY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 13:10:24 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2070.outbound.protection.outlook.com [40.107.220.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7535C3ED0E;
        Thu, 30 Jun 2022 10:10:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CuoPR/rinZVj8FsvuCELOFjfKOqsOgMwFnCgEFHgWpzA+ebQDUDrIIolp8G0b7NCkJrtRMpmxJldqYqj9ynxbNg6JWqNn1j98XfPHpryie9nr3an1ADM2OIAO3I4OgSYotUGxJhy+orp2MVG7d2jxJ2Fi65zKg8a0bmY8gEGZFXL8VPqK4P1zNr2YNXDDZ55WA7UulLICrJYcuOF2aJ08EEmR3MbJnbH5rq07Q6SzUuFcYJbOb2G4+MXmUmqtaZvYT91jMgLV9ScvMR8k4SNKzHReFr46NAdPxmpq3UZOYhrNI/+q6jDohFu3eub54t9dUQA3UvNtcgwb6l2g7sCeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tcUh72MqpRK157gsMqlsIkgSDK+ePUxO9PgFGeCu7Ns=;
 b=gxSFSkaFOFBdL2CfW4VqOfNJWyFbcaUJNtHzSIEjsIXghpEb8KsLtuBDXlZLwNvBMLdXP2KggAWlpzOg5UclPRJZ2VvbcTTNVI5f/DXjCy+MjWHy2DjSf4WG4XaXHEjFhAgDNBmr5DLgz2K6ZLpHMFj9CUPfg7F5Oc9KzGH/PKQwB75EQHHMgJzgSfu6SJVBFp9fiwQ4g8qV1f8WflH/vDYqUB4d3W3ELMfx2Ruv7R5flRrlR6fNtH1WCwHfl1TW15h8V9L+TpyZ0AHS2chrtRre7J3mdIxc0srOsvG6BrWB5D01WLOPKDoiM/H6MmZhYsJp8l7NmPX3oSuaczvvbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tcUh72MqpRK157gsMqlsIkgSDK+ePUxO9PgFGeCu7Ns=;
 b=k+fjdadgR+PzfPrXp5E3T77YtUESFN7v4jhBcmcYk32ANhI+3gexeXJP8nAv+AP0lEth8DA935gR5CMzT0EsbTcnaltd+9COfTFQUA5GO5qNBB1Ifjy86EoeV9YhDVfjgNI6gYLJECmsWP6rFzxIstE/Erdoo2i6FZTut33oJ07Zv9jdk/TOYyMOnnpFtJ3yHehqRVfY2Ie4Og0sDGxRRDmZUApG0MiUgPBu7Y1/EnUR96QQR/eMwY1ynxz5IWFzI6o5zvICyKcOq53Ujfy0XYcdnUMj9vHmjpHsc+C11M4a2nDLYmQRjmNh8mWGJ4gWqFO+8akkOTCnX/TVnUT2Cg==
Received: from CO1PR15CA0101.namprd15.prod.outlook.com (2603:10b6:101:21::21)
 by BYAPR12MB4615.namprd12.prod.outlook.com (2603:10b6:a03:96::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Thu, 30 Jun
 2022 17:10:21 +0000
Received: from CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:21:cafe::4b) by CO1PR15CA0101.outlook.office365.com
 (2603:10b6:101:21::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15 via Frontend
 Transport; Thu, 30 Jun 2022 17:10:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT042.mail.protection.outlook.com (10.13.174.250) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Thu, 30 Jun 2022 17:10:20 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 30 Jun
 2022 17:09:52 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 30 Jun
 2022 10:09:51 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Thu, 30 Jun 2022 10:09:51 -0700
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
Subject: Re: [PATCH 4.9 00/29] 4.9.321-rc1 review
In-Reply-To: <20220630133231.200642128@linuxfoundation.org>
References: <20220630133231.200642128@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <fe5375a1-9631-459c-ac72-f9f1d12a07b6@rnnvmail201.nvidia.com>
Date:   Thu, 30 Jun 2022 10:09:51 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 501998e2-5518-44cb-1642-08da5abb6a0f
X-MS-TrafficTypeDiagnostic: BYAPR12MB4615:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mHHO5MmePQTaRaFNIP4YrExwKqp5/AkXo4bTLfCvpYIuLgAvQVXFEARB9ZCu8hYpG+PqssA0dX+EJqJwgOXJeMI5fVTNwT2wKZ0Kl0alxIGIdIX72t0p6QBgncZ0Z5LeW5ou1p524RTSuyLPHfrqHd4MQJm8Cja+/sVYpgOE2qc+UwPqs2I9ng0/uFpUS+U+Uc48fJ64OW6OubjGVIHXRMa3mQiSJoGe+IDg1mH/WEPhScQEcM+cD4eCgWS5jS533UX2zQvrbU+QD8RCbZoIgLRWYUocd5/cGXiE6nWmKwcsa4tontwvXvNIOvSSp5W+/ik5xX23WH4cHQ/ZEYbfgLitbk0SxRBNqjxfoBbirWmJCdCbV9TtY0XMst+S8mWDpg1AoCoo4/KxsLwgZGOND/oYb6vhg97wAoxOS99phXuVKpGQnCqamZa3DBQjNXyZjx5z9CvSM5hlnbjxOuZzuuNIPH7LtH3UN8VRElSmExdQYWyPK9pbvsd4uvYq6cKzV3rpcktm2efVlV/AkHYF56T9LexeYO/0vRajgjPXIvY4BcN/zBv9zFuZnG08c19ZTKGr8J5mO14HJFF4lUuoC2JOpKadVrRkjoJ1KLgZXh5ZQ15ItDYkmKGkvKsLRzwcffnXM2XZts6mkl+0/1K41sL1lfJu6FOCZVi9dschhR2UdYLAm/JSX42cu9yj5D4UrxL4CnCc/Zyna/1VAGKDWhgx2TmV8ubpl6fyKjT/iKnDNbOe9VTB4td5vmoZA+3qkyQsXtWcZGVXCCQXabXnpaTbymQTAYNZ6QubSIFfazXBRVp0IO0WMr+0ftw5abGK8in0cVmJ3pUhcY6TOva2cyaB9J0AhKk8sTy6dUI/guIjY0O7UKUthgCBliL4LUGcQjuiJhE0yPOngN7wWkxzkE/e/DD438Q1N1ACrHpu+LOtbNsACuckAsdPp3/3fltd
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(396003)(346002)(136003)(36840700001)(40470700004)(46966006)(6916009)(41300700001)(8676002)(336012)(5660300002)(70206006)(70586007)(31696002)(316002)(186003)(40460700003)(47076005)(81166007)(426003)(86362001)(26005)(54906003)(966005)(82310400005)(7416002)(82740400003)(4326008)(40480700001)(36860700001)(8936002)(31686004)(478600001)(356005)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 17:10:20.9854
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 501998e2-5518-44cb-1642-08da5abb6a0f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4615
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 30 Jun 2022 15:46:00 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.321 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.321-rc1.gz
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

Linux version:	4.9.321-rc1-g32e401239471
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
