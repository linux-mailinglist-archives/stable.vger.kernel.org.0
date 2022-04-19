Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456E6506C3B
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 14:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344187AbiDSMY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 08:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352247AbiDSMY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 08:24:57 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2058.outbound.protection.outlook.com [40.107.244.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6935340C0;
        Tue, 19 Apr 2022 05:22:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=In6dlSdAf+kdYwba56yxavtxQRSqIFgfsxfqpxlkd/1r5+wRDzsoXFG8HoWw/uA32NnoYoBfTXAwLci+zBbjypb1CzCsyus2E04HoR1cG/9Ps+a8sH4A1WK4isjt5GCy8Iq83HjYY5GioKUX0ns8069V/3H+7yBBPXPe5UWIQwByViO1N/DWCV5FAVshZ0Y+ZbuUPI80chx42b1ellrNALQwtGW1JgA6E7lblNZESlv0QGSxqOAPcOckWSUCiLMPHXWaRQuLJ0OAnayzivXpSurKCP1oA+Cd4MffEsGjJUsihlbvGhgW36sXmbDbYl9NET5baZ5vKT0Z0G1M1M2/qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iiq8jOpnJUfacBNz+E+vb6ljdkfTR/Bgpl8X8GA6F6o=;
 b=emZBmARvhtdPf2IAXq7IfmIGjRE+bxkHfkT/6pZ21EkOV2yD1z2s8yCPQd79/GIhIpgtINzDWN8Z52G+9B1LeDIsUEiAphPsITpvU0kxu6zQgWCd0MzG7wW4YK4zdpX2UA6SZUEAI4KQ32fEO9cejPHlEN/hBzlKyBIpL/SaqngcB+VHv5+iF4l2ir7NdbUnlEYvknSAZ6oqG0bvhV8zNpT05221/+nRl2ltlk68cZGdnXBxJLBvElcUoJRkgPXaK9f34FKYApMiGIKie5rpYztglVgW2kKoSUJkPUytaduh5A/tj7mqtyP0ZOct3uUGSghXA1trMT8wfgszXtehDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iiq8jOpnJUfacBNz+E+vb6ljdkfTR/Bgpl8X8GA6F6o=;
 b=jZ8wBWb1t5/eQaIr0wpf+6e0ugDPvuXrPnCtqMvNRbiu5GWxdiW60nsk59LXXM8LkpqR5NPoj1Rc1zQohrIcWm80kfqQSV9K5jv7Xl2DD9jxeYbZqaddeLB8JK3p4yGSZFTIbPZzS0uso5hsoEVoOM9yOgik8vgwCWBYkbOt/0D7kxmuR3Y/zTmKjoQfZUkovQIPKBLGT7mOPA+b5Knz1VAuNinZ9x+EtTT/eFCWiK54Oc5WuOYu9p3T3EHDF8CDNVu+2NrpotGQRyLh7XVUIeK3IejoMtkeS8zroBmWDhC3kcQENzk86xWGV8Z4PLn/UZwiuaXplg95Kd675rThag==
Received: from DM6PR11CA0047.namprd11.prod.outlook.com (2603:10b6:5:14c::24)
 by DM5PR12MB1642.namprd12.prod.outlook.com (2603:10b6:4:7::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5164.20; Tue, 19 Apr 2022 12:22:11 +0000
Received: from DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:14c:cafe::ff) by DM6PR11CA0047.outlook.office365.com
 (2603:10b6:5:14c::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.21 via Frontend
 Transport; Tue, 19 Apr 2022 12:22:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT064.mail.protection.outlook.com (10.13.172.234) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5164.19 via Frontend Transport; Tue, 19 Apr 2022 12:22:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 19 Apr
 2022 12:21:31 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 19 Apr
 2022 05:21:30 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Tue, 19 Apr 2022 05:21:30 -0700
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
Subject: Re: [PATCH 4.19 00/32] 4.19.239-rc1 review
In-Reply-To: <20220418121127.127656835@linuxfoundation.org>
References: <20220418121127.127656835@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <9ddb8dc5-bd82-43a4-a6b4-da78d960e5be@rnnvmail204.nvidia.com>
Date:   Tue, 19 Apr 2022 05:21:30 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0291a842-0874-4df5-6dd9-08da21ff3af0
X-MS-TrafficTypeDiagnostic: DM5PR12MB1642:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1642884B832725E18AFE7A92D9F29@DM5PR12MB1642.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ABIGxG4GjpTA351Cwr+QR9cEV492eXk7ZdwZzGJxwgcNzXuKfn6kCNqR+ZiAv6p0nSR6NVk0UXUHNSmDK8EXQrhqjeHRaxFox3w/RraLwkdPNmw2yjo8wRzWY544ZLSUcmyD4Bm1O2ZEan6zYpCj3RDh3KOwa7XqikjTQClLvAGkx+2BXL/jnrd4Sp0JHXRUq75gci1sgwUyw/XQfogi1VJlXxnY7MtQN2FPcA/YR6wfaVSEpxK6Jdgt5CMk6zpqVGo0R8l4ldi4Lcn986vZU9rUTR3UouWmoflF7uCDYKJqDaYaJ2Ai6Q6GBoRyj+JKupvwOSDu6d1XHhD0TiTj4kX4u2lQ6tNdIp3ZrOyPTZX8UsKfAOGRXEl+gq2b6jiSlem/U0M6IQjxrLB294VsptlvzsQu/u4uCQ35BR3egGsy4unS89Swz6ez4zk9MCMGHeHOLS2Z4IBr21lol/nMMufmhcPZr/w8K8o2CTMrjqg5sYkAVq+9kjxlJ3Ce60w8smJjno0iKiP1ygxHYcThXB8+S/M1iKl//G+iv0YKwNSjYp4MWXdk//CM/QAlZsBnSuV+tqjPHkkxlIMvYLqZWFpXpHsYKe4Tl+HIpdc8KA9mdJ/sFcPBr7vuF+LWbQCKYqrhWBwS1QTwCa4LEqm7paKgHLuf5WMZcDUGfeE7iA9Yqaa2pFvSPrSuWIBIUu8q7RIfjc6W8X2UQAksAV5suv810J6AB95ilfzmBSMSTpu0roQ5ULykdi1aT4GhEFTaLlMYz+Xg3IU33z6Ll+tQ1/bEbKbmkUoMhzCj4rHkSzU=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(82310400005)(508600001)(8936002)(54906003)(356005)(6916009)(186003)(26005)(70206006)(31696002)(70586007)(86362001)(4326008)(8676002)(316002)(7416002)(5660300002)(81166007)(31686004)(966005)(40460700003)(36860700001)(47076005)(426003)(336012)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 12:22:11.4308
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0291a842-0874-4df5-6dd9-08da21ff3af0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1642
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 18 Apr 2022 14:13:40 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.239 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.239-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    10 builds:	10 pass, 0 fail
    22 boots:	22 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	4.19.239-rc1-g6124afa49867
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
