Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8B8857158D
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 11:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbiGLJTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 05:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232717AbiGLJS6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 05:18:58 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2043.outbound.protection.outlook.com [40.107.92.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64039BE2F;
        Tue, 12 Jul 2022 02:18:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fWE/D6JANtTqYKJ2d5oMcimRqvRFnIXHnbV2bKiPvaL/po+v997CeDFodrDs8PTEorrlsv55qsPP/cH5QAhh6jpquMueLA0kdNsJoFbQu99DxwNtSAaE6QmniRkcKC2kEnCIba/6TVrg/SMdcEyw2SGtLNoQY2P1tw0yeJuXljXBugU8a+gWVz/Z1C8qXmXknbq0seZmV0HmPaL+FYnYsklr+HJ/TitYRFmpiwqc53jGifYxmzGRgEM57dHKiDFp3lZr313hEMCbSx7uoN77xaXmoE5cbdNMC8rN2LpzxWu9rCPLOpwky1UneD4yyzH8jVdnj8+uRCiKpHlEjhHRww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kycy1F3FzvWqntuscYv85uu9at1cnm9/yhv8pTW69FM=;
 b=idFanUvm9Vv6aPQ1srAU22VrXhFJcFjI5XGX5qSyDBST1/lDFAIM+nQLpr62g4eivmLaoSeV1IjuxcAf7vs4r8RDJdcU/idjx7BFpwHi7jBJbkL8eRh312tOjVn5ZXeKer7ZR7LUve72XTGejymOsJvFq8Bhh3RD6TmEYMTAcE/DIKkbkcBFFiNlChfGbINnKWOs5exfMwH8kbI49/PB8sDYwjyrwdeZ+6z88DDAXvhilG/6voQSvnpyhlHXggRUHBYD8e/z20tv9UKsYbi3ty6JdBJ0d5VqMIblp1Q9o6IN9PAS3JWHn5ikekwpkMW19Ip+WgyfCTw+KS3z76lTXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kycy1F3FzvWqntuscYv85uu9at1cnm9/yhv8pTW69FM=;
 b=QUyeFbbIsT3b2oqyyByy5qYdxOQSF4TMpl56Hb1CD9LmVDdlz0DEYqEpoBbPRZw0ydvzrHaD/sqM889qeMG1bTU+Sb9cYaNC34p1SLKpIiJLiPy+INJPozTzD9230J1IEB7co6tBLWRrpVtfvajpuQ5mXNRjTZilm6Ii6IF/njmTwAmY6WjjIeEqu+/KkhPJo/th93mt0BQ7VaV2tF8sRnERJGl/bHMjvyv4ezZSM2+2rWHqg/DA1c/3RfCTOnYYidMz99vIGSYBgAvBZ5nbdJS//MKF7iYxcdaLBvT2GqRnGx8ZdzTfpc5vBDy6zlWDIj7RX9aYDaXYibbeICJWpg==
Received: from DS7PR06CA0037.namprd06.prod.outlook.com (2603:10b6:8:54::12) by
 DM4PR12MB5987.namprd12.prod.outlook.com (2603:10b6:8:6a::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5417.25; Tue, 12 Jul 2022 09:18:54 +0000
Received: from DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:54:cafe::87) by DS7PR06CA0037.outlook.office365.com
 (2603:10b6:8:54::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16 via Frontend
 Transport; Tue, 12 Jul 2022 09:18:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT045.mail.protection.outlook.com (10.13.173.123) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5417.15 via Frontend Transport; Tue, 12 Jul 2022 09:18:54 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 12 Jul 2022 09:18:53 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 12 Jul 2022 02:18:53 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Tue, 12 Jul 2022 02:18:53 -0700
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
Subject: Re: [PATCH 5.18 000/112] 5.18.11-rc1 review
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <20852e94-a548-410b-a723-3fb86df76d4e@drhqmail201.nvidia.com>
Date:   Tue, 12 Jul 2022 02:18:53 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77df111a-dfb5-49e7-1a7c-08da63e78abc
X-MS-TrafficTypeDiagnostic: DM4PR12MB5987:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RWtrcMbLw8WqVOwTp3TH/smmiwGcAYqgW/akQ8Ea6c/swY3OxKQMMWBeCUzqTsvWlsdM0R9Clp3+/Xsh2hhDqcNLYh/On/5ObPf25wFAcOPIBhYiKBVC/Gks2ZTrImoxDz9uGyZprlfpSriuqy6gOkQzrR7uorSeHFmNKrq5Wa8sI/lSgUKwC3/t2BC9LD3g7Ndi8r6n/xYpiaSOIZ3IV2Kzk2YaNoUOtZnbjbW+2okma4w/FdO0YOgavG6eUbj8dLz2YmkCX1LHNc2Tpb226+EOupMaZ2/WzV/84YIvJydLX9c15TBAiB8q9MU7jkAN+sDtyOfa4NcoAimImgXf2FZ+4hJzJnFK1t+HsFjZi8JFOmy4Z4nv5PnhgR1DG/2G1KIF4sRoMdkMmSbVw8VdsNf0gpTjV5MUuT9mQ1FzKlyjghf414wLn4n8kgqlN64nP8KYHS1Srv2/1gaa0VCulMIN/5TEjs5oC4jqX9F14FMpDb8Q0bL5NK9ggtq6KvssG9MXhjJr7DhnkFNjp5cBx8VLALXsFOHGw5Ri47OW15g+T2RoGmSTxazE66F50mPeLt01zk+PB632RyPTHs5S41M+oYpVB6EGkhjlBzJjqtn0GeOre3fjEKWA8pNtutyKb35S7AG2S7ipBQVGl1ueVMrfshymGUiisLRHxJHzOmHHYK5pe2DnG3A3LuS7P4JgbWlxebbhj4SYDqgDz5xC2oPor7IGgjS9WP7iN78f67h43lmW0n0XUmn/FvJndg1PXwf+wmeitkieC/Vs2nmnIKluL+bQFETqUA051saHvMGMg0w32zTDJSeLCJgQekb0z4qAYYQ0bRCCu9oT1B7MCxKb2oHM4UvpdhQEbgygoSP8EknAMEgtrfc943Lecu/MXGVqbiJRlv7+5bA1znFsSjjd7JUyR7FkWvy0pdEDUDXO+nQtKkFtUwgyS3J1xKLy
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(39860400002)(376002)(346002)(46966006)(40470700004)(36840700001)(426003)(478600001)(26005)(86362001)(336012)(82740400003)(81166007)(966005)(47076005)(54906003)(31696002)(70206006)(4326008)(6916009)(70586007)(186003)(8676002)(316002)(356005)(7416002)(31686004)(41300700001)(82310400005)(8936002)(2906002)(5660300002)(40480700001)(40460700003)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 09:18:54.1118
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 77df111a-dfb5-49e7-1a7c-08da63e78abc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5987
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 Jul 2022 11:06:00 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.11 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jul 2022 09:05:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.18:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    130 tests:	130 pass, 0 fail

Linux version:	5.18.11-rc1-g3c032a4d5696
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
