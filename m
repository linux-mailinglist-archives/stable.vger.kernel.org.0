Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B26F559698
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 11:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbiFXJ35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 05:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbiFXJ3x (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 05:29:53 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2085.outbound.protection.outlook.com [40.107.244.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FBF29817;
        Fri, 24 Jun 2022 02:29:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DqhnUqLl6a/J3wzvfO6BI+CEs34khWPc6haKQKkReXiei9KIzfGdhyGXaDtmf5SWVuqNi4va9XImPL6oM77hGSnM8sqhHwEwjvX7k4Whi/qqwWfvB29txMZ77rdfFwRFvqT/frlMMRMQiR0nbZkDR0tXulQ+b8Ygq+OvyB+RZzJVYKynPlx1svd0glYQhbgEsmcURDKj4dafrF3+D9PIM6rqLKyXitPfYdNxGabAdkw+4TuVvAu0oM5T61NTEVwLuaI21yUCtapBxrUkDw72IG6b4kMGzTNbSR3fE/Bd1m/7kD7i5XsoY89VxK6Pb/nysT396/5I30IRWS4g7pWaWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zJ64BETKf4Flad5L/+YiX951gXU1DAqu8km+Owd3HVA=;
 b=BCgWYoV1VSSF8bsglt1wDjRYMqBcvyKQ12RUfJUv22PG4Aqm9cfwS2enLutzCXrSFR2XZ4AFCcIgRtvbhr8NKahH8vVhCmxoZTUvIwsBzZH9SGCMU0rPCoUSQrk5LODH2A6YxrIPsHBxdewuHDdyayYHgg9v+9HTINgKsuZrEWdDrtzUD/EHNkHQOBXlFx5kx+eo0O5oUqMNlxGZad/4w09yeepOt7NnyB5SEuPHqv/LoH64aBPW/Ihusx2fvMIHiGpLPba33C2/ChLO5B/zuQQjPUrcxBWxRF0nQy0OEqFmGE+Ttf91a+fcwYjy4y9N05lV1ByEtM1JorD7DeD1qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zJ64BETKf4Flad5L/+YiX951gXU1DAqu8km+Owd3HVA=;
 b=addfyfm8Pdd5/YclvBGmnbae6OkUWEYej0v7ulC2QKOVJi4XgoES/ScaMeHifRRqS3gThbb1mdTAm3NUPVb+HHakcRxB8vNQTWvNvt9J1w8qQoVTw+btfEQYvVdAeOfSAOUKFCy2HdiOoCozt/HWxaf/xwNyfmpy60ovJX68H3y2ETiIKfZPrDSQbdDDZHjIZ/q6BWImwxFNygGYjrzLrI6X9PT8UWFrPHZSL7IZyt5nqkCDgtrXF1x2Q5r5HYIOe3ma9q2Hr4JO3XgTfYsMlqXKhNPeAfo9nMvWy2uWU/LU1QYALAIM7whOc+UqwSt59FuUSAzeM/mqhNrVDMlD2A==
Received: from MW3PR05CA0022.namprd05.prod.outlook.com (2603:10b6:303:2b::27)
 by CH2PR12MB5020.namprd12.prod.outlook.com (2603:10b6:610:65::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Fri, 24 Jun
 2022 09:29:49 +0000
Received: from CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2b:cafe::7e) by MW3PR05CA0022.outlook.office365.com
 (2603:10b6:303:2b::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.10 via Frontend
 Transport; Fri, 24 Jun 2022 09:29:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT067.mail.protection.outlook.com (10.13.174.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Fri, 24 Jun 2022 09:29:48 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 24 Jun
 2022 09:29:47 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Fri, 24 Jun
 2022 02:29:47 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Fri, 24 Jun 2022 02:29:46 -0700
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
Subject: Re: [PATCH 4.9 000/264] 4.9.320-rc1 review
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <75338392-2d6f-43d6-be12-8464fd76f3f7@rnnvmail203.nvidia.com>
Date:   Fri, 24 Jun 2022 02:29:46 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39090b13-da33-452b-1f53-08da55c4156c
X-MS-TrafficTypeDiagnostic: CH2PR12MB5020:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 547mZ2sUbeGKNewVfbeO1h8j+menaU72h/xCsInLlntSQ/mtAmc7h7Bt4BTSqvL3GuIIuxOT4tKrZDhke+lixg6vndbV+imvBu63uwZRnmKO7acS2JdSt94ScB22m6MQJCaUsEbzk/PAbQamwFRhadwYZMeHuQnxkKnoxQL796Ap7voJjejUN9bzaKRw+El/wNZ6HjrU0eQgIsQWrP71My7EmSNxojn+2N9PqPTJOMggRwW9lgs17UfI+ej5xe/FjccMyShOY80zWvophZGeRxegxl7v8RhBVPySq9b41ZZiZ9kbUs9wiLyulm051agIGDazC0RFZDD6uO+IUDMEl2yP0jG2O9i6D4imtL0suhRpzIaPsFIb/ir4sug311tvrRr6AM1NR6zFfcv191AXn5Pxjnl1teF/FtDSe6mNU6erobtA9TY5wVgLQBp8D5L48DycTc+nWn+yU1fblHGLy00A/tMa3a8LvTPzH1J5qvuVLGzE3cR9sefviWwDlZwnMJRO5XLpnCJHGwbYyWcSgl3TL1uGK5NzOYg1i7XHHxzuMZDIEbSW6ekyuMmwO+MVXTRLJuIB2nz3YZwz9aTkbjAk1Zlm8+VqJU0xc7gVq3NPHtRbQF02CO+9/yGwMkcOc6o9w4s5vZBLdTXy/zh00fXKd7oYpVLDOaxy9YsPG0nKG+uUC7dROstBlf+LYUzYrJBSZxsg4ZP/JqvRtAd8E8XVx1pq7/TWFBNCF6xYcDVxWEkTf7/wpG7OGCFTjXutszovL4WB5j5Scw0+5mBSZXdSMFI7ONocVUndnH4va6TCNZTRwNJ1JpJlAYyDAf3dGqU2Z8jZ0il6QiMjk7x5cg3WCWurdkcHwDhj0YlACrtkuvFhNwQdRGtRdt6Cd8F9++qCIYH/10h7SuzNkqGVTCztp9uMHgbgyzkXTA0hVGA=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(396003)(39860400002)(40470700004)(36840700001)(46966006)(40480700001)(36860700001)(336012)(82310400005)(31696002)(81166007)(82740400003)(40460700003)(86362001)(478600001)(356005)(41300700001)(966005)(47076005)(186003)(26005)(5660300002)(7416002)(8936002)(426003)(2906002)(6916009)(54906003)(316002)(70586007)(70206006)(8676002)(31686004)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 09:29:48.6611
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39090b13-da33-452b-1f53-08da55c4156c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5020
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 23 Jun 2022 18:39:53 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.320 release.
> There are 264 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.320-rc1.gz
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

Linux version:	4.9.320-rc1-g00d9858d20e4
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
