Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED25E522F2F
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 11:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234958AbiEKJTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 05:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbiEKJTn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 05:19:43 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2054.outbound.protection.outlook.com [40.107.100.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C7795DE4;
        Wed, 11 May 2022 02:19:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RQzKG+F1RT02a0utK2y3exeqJwYYyvsi7ioS0I0cpzfwQl5+CR52wCqLYhzAHpU7S6kPOV1PS8jmr24csRe5M0oV1vSQKg5gXZSNYjXVk/LZ5+j89leyVYP354Fw9v/g5cFz3d/+2D9Xxr+fwdTw5GunM8p8eUp4Ovz2hpXIK6JAVJ92srmJmnBlEEzlOSck1sdTJHxntC72c0WRNA8p4QMt/F+LTbTEGSofoGgAxiU/KkLOTa+bIU3cFtlKSwcbPdbqg5q5ERZO4djioUed/6RaJPFRUYzkw8OSXuUzrthBWas8ZnxZfRs1ExGDaUc7k/G2X8taOt6OYr7FCIXqhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ktFVx6YCmk0AdzPEqh6rg1bc/3Pzra7232FAdSZI3E0=;
 b=ZUcRDa0M1TobPWZ7lKoubXoH0DaJBIzN5EjLABWKtNjqy+tl78wQUx6BRSr8JjNJQWhvJ/3M/UM46e9ZgDgXfFbofc0TtmLCimWIObWo2L4t4t/KLEWaYlY0na+9hxkkBNLMAxZIv1E7kt6mi9OSVhxbUKgszHJqTmNF9vC7h8dwpbUEGswzDoJfhYitIB0SRBgXnezK92cxoeNI/iQ/C/C/bRhIvyqoMzOX3okRxdQVh/xeXulmMYkwZOtMeuFRQYJ23t8tEwzc9OAiChWHv6IeXaYBEmE8pSbH0zjBHMH2ONmXK9QK/3W+jDoaywGxhyHyxnyJAUa8iygK2SjX1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ktFVx6YCmk0AdzPEqh6rg1bc/3Pzra7232FAdSZI3E0=;
 b=fpIrDDrQmpb6yZK+7cTCClvzbUM0pPgTXYBLy0AfSOqeMAaaTMDSH83w+p37oa5CJM2WeFNnqhzJLIXdwr8GJ21dMNzC13LandmkR/qrcwcvMQ/9aOLX2hdIng+4QUCmzr5Q3tffxu8M+pYRUvQZ+Ydo53Z5mcdSFxG5u339xlB3PEV+LiZv0twg0erAlvklD4PDaQq2Rfc1Gy8dHsA/a7CkN5CNqRqkNA9rs++j8G4VJHhmsT3Xh4Tbp6y97GLgTAbeHTHOgn0TASQz08mS5+quTweAjfWHkkiyXAqHz5DcMtWoW2DJ2hyQXGi1Prs/S2N6W1+VpzDvhEtow6AWww==
Received: from MW4PR03CA0161.namprd03.prod.outlook.com (2603:10b6:303:8d::16)
 by MN2PR12MB3823.namprd12.prod.outlook.com (2603:10b6:208:168::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Wed, 11 May
 2022 09:19:40 +0000
Received: from CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::51) by MW4PR03CA0161.outlook.office365.com
 (2603:10b6:303:8d::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23 via Frontend
 Transport; Wed, 11 May 2022 09:19:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT065.mail.protection.outlook.com (10.13.174.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Wed, 11 May 2022 09:19:40 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 11 May 2022 09:19:39 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 11 May 2022 02:19:39 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Wed, 11 May 2022 02:19:39 -0700
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
Subject: Re: [PATCH 5.4 00/52] 5.4.193-rc1 review
In-Reply-To: <20220510130729.852544477@linuxfoundation.org>
References: <20220510130729.852544477@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <9957a9ed-ab11-4714-aad5-0110aed34346@drhqmail201.nvidia.com>
Date:   Wed, 11 May 2022 02:19:39 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1b44f3d-b039-44d7-b318-08da332f6081
X-MS-TrafficTypeDiagnostic: MN2PR12MB3823:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3823A865120073F1CB51C505D9C89@MN2PR12MB3823.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M64Ylp6187xk17sRHN5WNXdDDxBFa4980QmuZifSYMnqXiD/fMqhRkX5k2ldwvXWjPqvMI8g0w60Ng5kY+a5YWy/iDd7x05cb/aYX7UTzPzEqFCOU3b7Ab65vbddsIU+tNibUoPkgeT28DC5v5Jm2M+6zax/TiWMKvszBSxCRGxtn3WiN2mB7K9UJOJGGQJ7mlNge5+Uv6T66wsrb/V/teakm+HGwzEY/tD+gZh+EgQriXfTu0tB+CNJIG9ys9rlEuqMVL6lIy7FrOp0/TvNXNCiUE+iVrBXd1aCgq4N++O0IZEIndjAxFvS11bYHeYppQfe2k2pt0K9mCqPlk187A5hklrVtXWY4OZnBQF3GuiM22sPJxoGIltM9FkxAwAuKlaMtQD9V4eRhfNtggz4PHghh8BWj1zbKiH4l+3j1f0N6vThUtDADy5mOvWB+GOuVoAGPPOItsCKgVa3+xg+4Emhp5oatNv4m7gZBsky+bribuV5epb3Ti9/eXYNciEj0yi9FJGGP0faPhwslvpFoKI0pxK1tz4yd+fAorADlR/git/dOnkOFxqf/j7gBFplHZIv657S90ccdhJy3LGOikb9zk8SZHBJ47f/k5GvUMs/YFmwTb4S/IlvfR/QQ4VoJg1fbyHlpWZttE+mOQNcrS7h23BAr9pOVplAUAK0urGnbI5EGL0w4iFcI3E3PMhZnFHA7O9Shfxv7XoARJXNVW6bgGGGG482Cpa80g9tfOUNZ09r3Ii+2Fzcujs1K8e8oGMc4idJJteRU3gM5bynnKfvOYWsB/hKxKIdDQWWs8I=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(508600001)(186003)(2906002)(966005)(426003)(336012)(47076005)(7416002)(26005)(5660300002)(40460700003)(8936002)(70586007)(70206006)(54906003)(81166007)(36860700001)(8676002)(86362001)(6916009)(31686004)(4326008)(82310400005)(316002)(31696002)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 09:19:40.0845
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1b44f3d-b039-44d7-b318-08da332f6081
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3823
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

On Tue, 10 May 2022 15:07:29 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.193 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.193-rc1.gz
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

Linux version:	5.4.193-rc1-g52d5d4c85d2d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
