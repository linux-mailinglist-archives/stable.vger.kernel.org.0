Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5C34E30A9
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 20:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352673AbiCUTUC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 15:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352647AbiCUTT6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 15:19:58 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2054.outbound.protection.outlook.com [40.107.220.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27D2289AB;
        Mon, 21 Mar 2022 12:18:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TZ3QNnWNQ3oWdt9obyofvQb1vLsv/seKQpUraMTZ7jzqp5LR2C0JOh2EAKdDlM3qCAD+uXcF4yUIa2eeTQ8/r2XL7aCbFdkdOXlDFNZjuvPvUGWgelQkGatDLxoWRXuwU0AVXNdsc2DKE/HR1m33VT5vWWe7YH4jbnzyMsRG5WZykn5UomLOGAwBvGZw5GnIEwJxCc7tk+AsDyMkS9bSYiu2V9QFjBX1JIjVIUO2zzDxiaVtSkDtuad9wQZK4t0K4npWIyLrnm81uhXxIy21y8aZOdCseQxARwcGPIxG7+Za9uViqeFbiqB1ZG2s0NnJxahMLdeKxg+r3+0aya/UjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=00D2dTLCGSsqPGb+RkPBVFgzi3U/C+Keu6gByPoVge8=;
 b=oQ4NigeJW4WSoL5+wD0hqKl4VRtzvOzlUUcQnW0s5/YHV7CskyX9JFpN+RNMywgPfUV/WDHGMtGakaoxXwjSTewMCw+QwQk5db8IMT6aZx4nYZPsB6HQJPM+T+gZgBTkceEy9GOBW0QfKUPTd/2RXYOMOsmgO008A4ghSDMtQtYeYLISZrurZX+NT58kYyRh6JQYcE1jiaZfD54hGIyvKD+LxdXeiuEkcROtvyMHp6CjDgitTC9C7NhKf2KSi2gQJQn7Ka4Vr0kNXCIffcyzrkFzXW4a1r3RfnbxXpRKVl7I2QDzjQlgI9x5//+ZPJwqwYbS6knOaDGAdzx9po9big==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=00D2dTLCGSsqPGb+RkPBVFgzi3U/C+Keu6gByPoVge8=;
 b=UCc8ThOVtStISJ+wYmKlGhQFN2PeWvJ3PwYFX9QiW7Zbe2lHJdw4Ex/s0rNUhhzrgQW3N/XlPFCJ7NKIevTufNadOrM/p+6l6dA7FWmMpGVQPXpvORLwf/7B40sr+o0jongDjogTnCUx4C3Jnfcc+e2rGk3MKUYNg+mHZKW0PY3ID0sFSnPDRmzdGsNUYbMV4fhFh2w7sTvuz6LHe/DY/eE2j8DTWpRm5n3gjauiMbms0aiAYV0YcW1b/q0NwyQNdww5puvJVX5Kt3xPnAfq5bjDDopYI6AWButyCuO1Q4m9HzwCiPdjHpLuLXdLzk8AHaBka8ndYKOw5fjXZPSBSw==
Received: from DM5PR07CA0078.namprd07.prod.outlook.com (2603:10b6:4:ad::43) by
 MN2PR12MB3261.namprd12.prod.outlook.com (2603:10b6:208:108::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.19; Mon, 21 Mar
 2022 19:18:27 +0000
Received: from DM6NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ad:cafe::84) by DM5PR07CA0078.outlook.office365.com
 (2603:10b6:4:ad::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.23 via Frontend
 Transport; Mon, 21 Mar 2022 19:18:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT056.mail.protection.outlook.com (10.13.173.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5081.14 via Frontend Transport; Mon, 21 Mar 2022 19:18:26 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 21 Mar
 2022 19:18:26 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 21 Mar
 2022 12:18:25 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Mon, 21 Mar 2022 12:18:25 -0700
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
Subject: Re: [PATCH 5.10 00/30] 5.10.108-rc1 review
In-Reply-To: <20220321133219.643490199@linuxfoundation.org>
References: <20220321133219.643490199@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <f21fbb10-b6d1-401f-a90a-7fdcc56a29db@rnnvmail203.nvidia.com>
Date:   Mon, 21 Mar 2022 12:18:25 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24525715-2961-48c3-09ef-08da0b6f9373
X-MS-TrafficTypeDiagnostic: MN2PR12MB3261:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3261E581F7C39E0FB4EBC8A6D9169@MN2PR12MB3261.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bosjog+ZvAmXYOyLdVf4CyzOLSpH4TvkSKXyxeCTH5BoGrrOKmaMRwNV7lw+hkIKXaatQgf0sZWbQi7Gg3E5jk7OeuxESmcOnwRTfH+z+Z77uV8dY2kyTMf2Z1lwS6Zsb9GkFojxUcn8iQfk24v8h/2MJ7wuMo4SMwJwICKQ0RmqEI/VR+MLPe0njmgjqFywrrgIoy5IiVQ0au3rwfy29Qk1MsMuVG2OUddQfZHcQyd6JbgVf8kvhus5qB5yzBQ9nPnuuHziGT4Rxh/x6fo9c9s44VnoQhLJ5FBrNK4YiP3iL05HYK4fSX1+NjeMTUTSKYTXVQBOhqxPQ/isCVy5JEkcDSFkEh6lGx6723ta3e9Y9TkbJucUVsMIGxOSeOID7mw2JnObBTi6VmOHidy3NAFzPLWWF9muaZHcL2pItP4w/jTcHYqGPU/8CofoVCokRvMxkvLBTYC0NQbVFUQ6EaC8zedNOTzwkmOXdwUvU3aE3uQ6TM3RavD2UD5Hj5kfAfupQ5wrnSuUN5SE7WZVk1CM8P0wKXZRE+cwtkgJqqJDi7UErt6pnSyMk9bG5yoyOFaNNTiZdZAqxrNSWiE9SL1TH8dC5EkLfswvPlbPZeosOkrH2y/atNeSE+DGpeE9OzLRac66Kn3MuDoHuXLdlAHmvQOeoD7PzRsGgqc4qTPc3V1v4oL7xK+kr5Gh+gRB+fHpyoD94pIyPKj+4O7VlMg2J9IZ9YVpyZFF5rHyuQ2P++JysOJ4RfbLbw87OLKMgfsyNxTY2WhIc8gMNydQW+735KrCVC32mkQHzSQ4jY0=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(31696002)(86362001)(6916009)(54906003)(186003)(26005)(316002)(82310400004)(508600001)(966005)(81166007)(40460700003)(356005)(426003)(336012)(36860700001)(7416002)(47076005)(8936002)(5660300002)(2906002)(4326008)(70206006)(70586007)(8676002)(31686004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 19:18:26.8161
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 24525715-2961-48c3-09ef-08da0b6f9373
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3261
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Mar 2022 14:52:30 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.108 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.108-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    75 tests:	75 pass, 0 fail

Linux version:	5.10.108-rc1-g9d7b0ced5647
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
