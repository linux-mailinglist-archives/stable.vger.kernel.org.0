Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757734897F5
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 12:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245147AbiAJLuh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 06:50:37 -0500
Received: from mail-mw2nam12on2061.outbound.protection.outlook.com ([40.107.244.61]:60192
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245032AbiAJLt1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jan 2022 06:49:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Adr/3HI43BhZh3ZMqvWjuuPPlTncjaxi4b4g+lfOXor7LayvojT8SCH592Jy3fNYzPhs3Si6uZ+zIp4Y4EQuh/SzEXkfVMrJOgqUiZFTD8B8DpLCpeTM4KQgZBvbGyXBQUzJpB/9HO1l3V2AUYzBZ+QZP2RNBJZo8jk24Wb2gpK3QbfXEfeagLKTVyFVFXvnaEEYjg1T4FUkFVinKcMhDEcqa8e/jmt97ohvIwC6f/0HpqrkDGyvxxWguXS+GVOGIMMVlXI2tsU5NHZJZDDpEnRCNsMw36IQAyeNyFJVyEdbu21J/fVxXzPudbPrlrtwt2Oz15ThRUbOWhIa5yF4Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N6hz4fYJyS6Zxosc9rZNPUHaZZVtKPsJY/zvL6TmGcQ=;
 b=fbfaSWVCSNKFt+M/SbOAuQGDFuhoG5dojIY6ii7qLtefy7T3oH3cbyR3cEEekYKRPSVJCWRlvJD7H+B1s8Axpi3u8yV/Ow9PwQCjnuuosDV/QmzkRze66oRK9ki3QFzXrTX4wJ0wFw3EUiazEpOmiBZHxA4IAROuEiDamoILqNNGAwD2IW5jxIY5EqXV6LaXhSL6whTZfM0TPRZMf+mxzbQaLPcKeu6af26SMPKmcbH+iyQ84HRPGB4G5RiDjY5AgZhvNv6z1jurQy8XBRyIrLIjnIJosth90s2fa9u/euRRcaRKOuAW8BMraDzdjCGuY/WMwpKdMaMsybMP+WONmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N6hz4fYJyS6Zxosc9rZNPUHaZZVtKPsJY/zvL6TmGcQ=;
 b=g/LnOcW9dSNV5LMaRhN+BhXifM7N8PQpGEXlKdF1Vmh8vF50vuprxjxd3TZzWSJo/rb0mt3yIHyFOQNFxdM81lTSj6V1yOvc+hCl0Ds6d1N/o+pizC6i5lFogZUcdUKlRfGC9loZc5eq1EShzEqW6pS0DlJ11fTCmCNeZreqjXnmBOE7MiMWgyxpT3Zg7qaYpWZ7N0YGDZKFGuIE1uFgKQU/xkx41I8I8oHfZRlKg0lZJOoeGmyI7KVqxhIa7y+6gKN3YS2ESB/CscRzz0ikvjVJwLZwkDOLBnEqGWLcX3f0YHTaK+d/eT/OqWJeVW/g5caNpZZwytIAd1ArI6CD0Q==
Received: from MW4PR04CA0085.namprd04.prod.outlook.com (2603:10b6:303:6b::30)
 by MWHPR1201MB0094.namprd12.prod.outlook.com (2603:10b6:301:5a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Mon, 10 Jan
 2022 11:49:25 +0000
Received: from CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::f0) by MW4PR04CA0085.outlook.office365.com
 (2603:10b6:303:6b::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9 via Frontend
 Transport; Mon, 10 Jan 2022 11:49:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT028.mail.protection.outlook.com (10.13.175.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4867.7 via Frontend Transport; Mon, 10 Jan 2022 11:49:25 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 10 Jan
 2022 11:49:24 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 10 Jan
 2022 11:49:24 +0000
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Mon, 10 Jan 2022 11:49:24 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.15 00/72] 5.15.14-rc1 review
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <ad21ceb39ba54ea9910d733584da6661@HQMAIL107.nvidia.com>
Date:   Mon, 10 Jan 2022 11:49:24 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ded8c78-a4c9-4be3-3c06-08d9d42f402f
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0094:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0094803EEB2DE806EF55087DD9509@MWHPR1201MB0094.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: td5dBMNIwlWi7UDh+0uTWXNLEbaYgHXLNikjwYU3pmpd5RqANdMFptfm4int36sBFRSwVp0WhwfKabUogF9CSku+Qab0I9gVX31VsbT8JneAsgxG1cvVYtvkTKTWZULpweFjGY0fhGx9Fk9o07USxm4PfCzzHwDoLB1UYruRgeBvPtGLs2yN2OIIXxY1Nar3i4A66Y8b3x1t2pZ1LBbNU9jv6id6br7q34iJz3qDaQlXDRe/yZNspVEOSPFIXyZ5iYTqA+R/YiESrnIG4ftzpL8PbRCIz8ZhLAndCrpVkVSt0Z+7L3GyLNlCm5WO+irZWu+3NprlAvEozYdlBTfCmbR5v50N22OeTBm3otXcFV7w9F+0GSUkOHdLFPToEQvYNK+PWw8KRe8ikSSw/tnCWpwx6bE6J2F1vQzCVb48NS39S4o3FSsiUT21vDTecdNooae7rQ8ys0ORruk2h1p8UISje49ZemaHKtM01rJuSHWM5ErARrzRhyCsnoUHZk3DIjAlv14BzlBEtGbH4CEW7Xil7lvAJpABPpmBjU49W6X5qBPK/V5igVQszeuTlmMzAfprJqKUpe1AIjjUQd3uehiH54xmLxQf7BzdSP0olalB0D9exw7toQOQiPw3CmFwGRhXDsBa5N4nquZrVuPUBO3SxyacIZ209WlqOvGo0SPwaNZ+4qqzA5CdtWFDsTVfRSJyjzsfveNwCnHl2vlHHjwN9SgahxIyVAy6d7ZCuCsPSLQHWHCKTXOAoPux4D+WaTBlPYybwY1MYzRQKHyVlWMx8JQoGDlyc+PP117xh9JtbRHRog9nSxNSj3oK7P8G4lyFTnvQOFcgrmNhhR/ZY9xHjDvXNoZ83XMYncRxIl57izHkgT5l9xp0Izv5N4C7
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700002)(36840700001)(46966006)(36860700001)(316002)(40460700001)(82310400004)(54906003)(70206006)(336012)(508600001)(2906002)(4326008)(966005)(70586007)(26005)(47076005)(186003)(5660300002)(6916009)(8936002)(108616005)(7416002)(24736004)(81166007)(86362001)(8676002)(356005)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2022 11:49:25.3930
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ded8c78-a4c9-4be3-3c06-08d9d42f402f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0094
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 Jan 2022 08:22:37 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.14 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    114 tests:	114 pass, 0 fail

Linux version:	5.15.14-rc1-ge8d40b0a7738
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
