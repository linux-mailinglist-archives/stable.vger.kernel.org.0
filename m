Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 288C457B319
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 10:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239223AbiGTIlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 04:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiGTIlN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 04:41:13 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2047.outbound.protection.outlook.com [40.107.237.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80316248F;
        Wed, 20 Jul 2022 01:41:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LJ2J5XSKRnGVa9bbinxco1LC0uFbpNCFwf8yUm0D/tZC//UHLwqSJ7au7aiodBR67TLuatgWT8EbyA/nmlbdlNkdBD6C5UANfNYfpPtjmqRROO5/dfQlNusBEpkWbZ0y/AkwyVYsRtFK8BPA/gE6ai1z7lUzxapuM9iJD7N5+y418dWMvT7Iy6K4Ma0fKw0uwK5jDPLC1d8F57xdFznw9OluZkb5qwEBj78GTTI2GHLXcUI9mEj19sdlyXSALk7aAPzJ2c6znKUDu3I4HSqXpWZ6jPUzh1Zn8uFt3vPAPYwP84hrVHnKuG5mvGzstl/Y5KS6k3mkpbpQpRYvvr257w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f8BdU1nr76AuDUMOpN3kO89xzqkrP6WbcgF1coy5l18=;
 b=YnVH3Ls9XWHbwWbEfm8h4hTpQYJWrYqLQ/sB6jzgdwCzO5Mf0dsXlVChCAUKQjZY6upyO80y7KHUlIfZZrjxclyEwbD25WB8LJ/sWUoKg/O+ZehSpHDpnXLD3Ykoa1dLaFuolDvBvtceCphGt5gCTKIaN6i7IIqDmEAHvx864AWaPgxaPiBLWq3Bb+1SQr25t8xVh6P9YX0Lk7kiSGJ35+uDDaFwImzusJnwlaXIOhU8fAO3WE8q52MXMDL7LKW7k6LJXWLcI8ATwfcOTMMt+H7Z88FNqTMa2k1dI5iOiL8fWP4ddjDW6AukeTZgUmEMIDov9vLYCSNJM0sDHKEFJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f8BdU1nr76AuDUMOpN3kO89xzqkrP6WbcgF1coy5l18=;
 b=KQYhLNoizaiDCrCd9UX1h3QXqEPHIqb2djpAYFIDU8r/if4wbjxD87zDy+odXFerV1guoX2Cb9WRmgUR8dpgr+xWXxoSNvY4wawQvX2tqH1/aQxEl17yi0+M5zG9n7aWo/hTdD6rLBhhBcWOfmtXddnN4j5C1yvfZft10/878fLPiYDF3qC6OCBNictvAamGgmOfJS4CmXuxFBMO8jhf+r66gUf/TS663k1PeHGXL5kfuIK6UQ1CMOkL0kPHMFPXgqIP6OTBftHqz1BiIChgoDY3GXCBxKQfqBCbmtxB+4kqJUydp5OYnlIFoVah8YarzUMpD9gUpjxpqkcz42B58Q==
Received: from MW4PR03CA0030.namprd03.prod.outlook.com (2603:10b6:303:8f::35)
 by CH0PR12MB5155.namprd12.prod.outlook.com (2603:10b6:610:ba::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Wed, 20 Jul
 2022 08:41:10 +0000
Received: from CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::6a) by MW4PR03CA0030.outlook.office365.com
 (2603:10b6:303:8f::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18 via Frontend
 Transport; Wed, 20 Jul 2022 08:41:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT029.mail.protection.outlook.com (10.13.174.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5458.17 via Frontend Transport; Wed, 20 Jul 2022 08:41:10 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 20 Jul
 2022 08:40:17 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 20 Jul
 2022 01:40:17 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Wed, 20 Jul 2022 01:40:16 -0700
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
Subject: Re: [PATCH 4.19 00/48] 4.19.253-rc1 review
In-Reply-To: <20220719114518.915546280@linuxfoundation.org>
References: <20220719114518.915546280@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <6f5fdad4-b464-4c0f-ab02-76b37515a378@rnnvmail201.nvidia.com>
Date:   Wed, 20 Jul 2022 01:40:16 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da37139d-c971-43ca-c58d-08da6a2b98d6
X-MS-TrafficTypeDiagnostic: CH0PR12MB5155:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /Qff2Xxy6CG8v8999XxZvFlEoY9OBNb+p/bCzlOtheBQV4kanaX9KZ17jOv4kwgBMJJmkuvEg87jmO09wiXVdI3a4xqsn87B1kppdQGSQB2RwLcs5gpY0e8ocjIyr3Y3OD9Denly24WP+2ueWw4VYH+1Pr0sOyVozxkVQ1rPQQWaYJkbYvfUGH9yTnRThPHWryigjQtv558HFmTqOWosqG0hzY00ufIKrj/Zy8ct0IXQZSLEGIyjiDG3Cy/4C8Fa8o/RU2bxs/Wm175I15xEhAji1hmKgJnGN3zXi6jnHke+TarJEACAZhmgVMz9MPFXOaCWxYftTnY9vJq0dnVKVLLo+Uv7Mgi9JGysOFypgWbKk+rXpBwmcIMKQIPlj4yV5KGjAFAhMqv3bbWGQbMW2ayOGZrhGWkPhiRk4cqJvtM5ho97HRYagSwqOy6YPxbyQLXSC+tyLpSsmkyoB9yi4YFV70INOqBSIP0LvS099GJL5HkVgb9CbB1Pfh+HBQiJQxhELlOqFKRG7M0cmAwu5N9QhZIjVTFaH+5/bkbR2CQTcBHi3djsOC08/nfw+9VcUnhBMgSLteJGQbk+9e1X4aUW/iLQDRzfAhv9/Lr1EI7G/oM3RiEajMkaYoYL3h8fOgB5/gnJSx75OQnG2oYfqA4bImZCZQpcj38t+WufqlKKe6/K+gkzjefCkFPkhso/7EiEum0vrZUJ7typx1/WYg0tM4fT/aIz/q0jx2YKYWmoKrZGa5JgN5AcxfnTLkI99nr28cdi4hxfh1LchXCg9KzZNh7kTM0OQluJTT0sncZKjE/3agdbUHFbZfFnyZPgKEpSRXj+C9Ji8sUnHaXWm4mf+CpcKLM6TkwmEktqFXjQ79qdoxsj66lEg37f5ga2KrbKqxqXmaKQUPdCv8OKGHMwut2XxuKl3idInq5ewic=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(376002)(396003)(346002)(36840700001)(40470700004)(46966006)(8936002)(5660300002)(70206006)(8676002)(40460700003)(4326008)(26005)(40480700001)(70586007)(2906002)(82310400005)(47076005)(36860700001)(7416002)(81166007)(356005)(82740400003)(966005)(478600001)(54906003)(336012)(31696002)(6916009)(426003)(186003)(316002)(31686004)(41300700001)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 08:41:10.5602
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: da37139d-c971-43ca-c58d-08da6a2b98d6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5155
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 19 Jul 2022 13:53:37 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.253 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.253-rc1.gz
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

Linux version:	4.19.253-rc1-g8b84863f2dd5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
