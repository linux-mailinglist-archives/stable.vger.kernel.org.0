Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 163C357B31C
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 10:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239665AbiGTIlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 04:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239416AbiGTIlP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 04:41:15 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2089.outbound.protection.outlook.com [40.107.92.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1062066AF6;
        Wed, 20 Jul 2022 01:41:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g/P+oE933mL6MvzWfSNew5ysw2hoZTv6uY3YEQCeFefy7TfkDZdx/lCEPPeyV6U+xudLJ/ZZYnsScBbhKlZCFCr6BADyTKtxRj2XC9OAuQ5Zu+6YIC75lPTYDTcAcAvgda7hD0tFD+vxD5vWvQGPj4H93LJIiIPcHO429nfLZ8RSEuKdqenymvF0weaZbWnkSGnnF1Y9hhZhUmY2jkw78UymPUS2tX6lBs9eQ5ZP5HzOxPXDrbw88ODYu2a8bNDxN0YWhx+R2/ahkdGopAzGXIiYsY5lFLGhUFzPuTqb79BbpakIp3Zi1RsJEjCgA8/CCsiP9TkHvTAsYoNUTXxL8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ZSdg3Kqea3K07X4p9kmHljmzIyg+HNpXcDwSGT3Cg4=;
 b=b1P8+2zh2kDGUrQMUK83jlb1u1NltqF4xwm+gwW+3ZvDnBuZpb4RykkZWZqE3SOtxwRt7BhrCVlvyj7kbq48h6iZtOrd4w0v/6i/aGUaB4UC+cVyi9yz8JNcBIic6IpXz4K/8zzm2EQxrAWEeRKHMCmN4sU9UB+Umxfr5A5B2dfGmCOZ4MdIBJao1Gvr9uxMap6TZwndPmhnZZahSCd+7KlusJypB806hbpR6FyUnYnYsWjQLAYPhxVTebyqOinIplIgMN8qoTQsyvM5EgqG21UjsxmBW1IHrDP7L7qgS71yqicOUfGD5kvR9srtIcbtLKzm6pQsVxcJPo7+UwWopg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ZSdg3Kqea3K07X4p9kmHljmzIyg+HNpXcDwSGT3Cg4=;
 b=LViwMz9s5MBHvBq36dinhII3ASNipNL7cgjGFsHIoKpJTQUOT/hZ6jSJk43YQAmvQac4QNMX1DcO3xi8S1h5Ll6vBICKuhOROhhbSqNcIGmJpNPymsiLVKSu4sIk38BU2Hm7RlBbCNoOAqbmPl3Wmuc7yK7cZORnNHSzlmAb/2nAFF6QBxS6ZriwTwIJ1i6VKeAZLn4c6k2I0dmMbvRXzKTxet77vE+7CiEBrv+QG+Uwd856tMe2bx2rn7h1poOabz06zKYrRCf/L29ga5UrW++yuMFsYut7iqpASTrU52CHmEa3bf1V9sQ7pc+siTbTRaIZtt4GnJwFRS6DOXy1Rg==
Received: from MW4PR03CA0002.namprd03.prod.outlook.com (2603:10b6:303:8f::7)
 by MN2PR12MB3021.namprd12.prod.outlook.com (2603:10b6:208:c2::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Wed, 20 Jul
 2022 08:41:10 +0000
Received: from CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::59) by MW4PR03CA0002.outlook.office365.com
 (2603:10b6:303:8f::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20 via Frontend
 Transport; Wed, 20 Jul 2022 08:41:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT029.mail.protection.outlook.com (10.13.174.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5458.17 via Frontend Transport; Wed, 20 Jul 2022 08:41:09 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 20 Jul
 2022 08:40:16 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 20 Jul
 2022 01:40:15 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Wed, 20 Jul 2022 01:40:15 -0700
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
Subject: Re: [PATCH 4.14 00/43] 4.14.289-rc1 review
In-Reply-To: <20220719114521.868169025@linuxfoundation.org>
References: <20220719114521.868169025@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <9be04af4-b75d-4d1c-9b8e-a6aeaa08a33d@rnnvmail201.nvidia.com>
Date:   Wed, 20 Jul 2022 01:40:15 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83ac845c-e0bb-48c8-6d41-08da6a2b9839
X-MS-TrafficTypeDiagnostic: MN2PR12MB3021:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zoLswznIchsOyM+HrHWllBX1L6eLPSixdeNq2kOxCCBAJ8W1CZgstCOEuYZH/HIQfVloxZDmYMMRp8nUaus8YJmT+r7aAUsztA3MTJiLp6mE9jQEgLvm1prz9Sp6LqJN/fdYHfvdTvHyyoW4QZFgSLQp2qLBainq1CMZIMd2F/LD6nSnj9bNhn8Bs/eJWvYnBqYsZpoFtLAQ3KHTXLJ0BiHwpYg7rHzHn8lmXTkj0n3x5RKP13R1ySYdHeQ9Fp/LS3AWsXmo49Zn1XYIxv7j1eFe4SEapetFm7xoTiwi8PtlTF2ZWKoQgzf6NjrERXRWGTIDmvSPLQA6CAzj1WA+EcuQ72bvdd9kwC4MR5MPxYFe2QVloXvRjLkpmiZ2rOYBmI64hFIjqosvMamP5oDA5O3VuDlnW3Qd/B0CCubixOGTvkIYWTQBDY9R+15PVui7cU2Yn3rXBjdyKV1fqD2a4Mce+X/Bbo5CnKXafKy4oiDCM0NA25fH983Qs+1st121RovLhWmvlOB+ipXXxWe01yeA7oYuV+5YrWzSkOzLaNw/jzM1XLmMxXYjHcb+4jUZi2RmBcY7qutIv41hNB1OewSVggQtgqMc6i8ZS8G/uRFkEE7ZkBlOwwTZV2/F1VNaZeaWcCBGnKs0f6h0KdOrY6vWOPlr+FJAfqYZBR8Xwn/2UIuWq04S7v/9bVrkX8GeaIcuXa6CIwrlgdziIGzEtA3g5DqIpoxw7HVZ90NDrnZoaNoHimbCFp0CHe6y8EzuLFJ6OBT/3V+sqvDZVahOfs+wlpOS4j7Pe+l6U1Mt+9AnG0vpHyOJ5PDXv9yN3ZNOkaze/7w+yiWSHajlFgOudIiS569Ds62+LDpcWuGEB34m8qWoW8PmzsvjP+MO3BYfN4Eec1/8EPBG9vnYrmwv+2abGlEsfyOJRpQXCdBmY2A=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(376002)(346002)(136003)(46966006)(36840700001)(40470700004)(41300700001)(426003)(186003)(31686004)(966005)(40460700003)(316002)(26005)(7416002)(40480700001)(2906002)(47076005)(5660300002)(336012)(478600001)(82310400005)(36860700001)(81166007)(8676002)(4326008)(70206006)(8936002)(86362001)(31696002)(356005)(6916009)(82740400003)(54906003)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 08:41:09.5291
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 83ac845c-e0bb-48c8-6d41-08da6a2b9839
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3021
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 19 Jul 2022 13:53:31 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.289 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.289-rc1.gz
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

Linux version:	4.14.289-rc1-g5bd8b9267a7f
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
