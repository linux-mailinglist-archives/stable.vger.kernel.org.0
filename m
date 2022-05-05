Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 032DC51BCA7
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 12:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354806AbiEEKDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 06:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354963AbiEEKDr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 06:03:47 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2067.outbound.protection.outlook.com [40.107.237.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97E2515A2;
        Thu,  5 May 2022 03:00:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TlY5447S8oF0s9F00HjQ2wekUvmNVT55w55e/LaC7psRya9BxpeLGBUQV4y2oKMkJVlNzXLwxCc83ofC/YYTXCamzyCm+dEbP9RJ5BECIeJftNLR5tvHdyixg0AjVMbvjfilh1uhdI6C6uOzfpmhSqakxr+mv2zOwlXy/FuhHRuVHZopW4cQg4rUE/Uh4SzD0JwoPEkl3Exe40t3sy9TZ6ixV9LiV4+J2GW4DvmE72M/sY+itr28k5d2P/3qVKijguBbRDAFR8A+aF5eeMuYga3HNq2Ok7peWW4yHBdib3YSmbG04Gsq6LjCDxGSuHFGzBFIodvxt6+MX66lbIy4uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fh5ZJSSAxFnRMt/HG5QeoT/GVIr7qv07t17V/hv7tMY=;
 b=dGQ3OC5Na7LlrO/MlhJWpAoLlnnU2Iq7P64THdbOKu4LCXrdS2vPCbWMKpKRGbT8sKzWjxoLehY82TbALTy5zCQ75PZfU6Kqc8eF57fagf6uE8PGdccOGShKZ8K0k8IqMcntidubjGOPO0l7dBeI5DhU3Xt5xhKT6QHZONUUcH7LI5ctdlxqNJ8vHPebZo3cLQLTaVbydVdOsclP7e2Eyfl0FSas7WimsWZv9k2DEscuKnCWzLVj7iRbkhEIbMEfNe/eQLLER2ALzOA7AcsswoApMq6FX6CLyC85nvmoIDlxGkWxsrD7BJTp2G+PWEXfLo0VFO0ONuCXe4GT+fbM8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fh5ZJSSAxFnRMt/HG5QeoT/GVIr7qv07t17V/hv7tMY=;
 b=bxKX58/at+oh+Mn1X6P3RtzEQH22+IHj4UikVREBvogCmyoq4++N+ua7rryiAu7bI3rC+hZueecLqMxTZoiHblq7BL8dhqqxFtMZuhd5EKKT1qE/Afx3DYmPytq8c5Xnn4U8ere3wY3+02oXFkerkpfkxM7tXPi1fu+tnecE8duYbSwDIM/bnRvzzuEkL7kATU1PwdtOYii+r0P//YMhjQv2eVJhIUj/+xbkY9T8UlV7TaYXKBxnCpc0td4WBGAmMxVtVAp0Orsypx6SmPjBjb4imPkcgftRUmKr5TiN98vfUp+2FhyCfVy9pZtu5ovOdnG7q4WxZgkffITMoNG7ZA==
Received: from MW4PR04CA0219.namprd04.prod.outlook.com (2603:10b6:303:87::14)
 by BL1PR12MB5970.namprd12.prod.outlook.com (2603:10b6:208:399::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Thu, 5 May
 2022 09:59:59 +0000
Received: from CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::6f) by MW4PR04CA0219.outlook.office365.com
 (2603:10b6:303:87::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24 via Frontend
 Transport; Thu, 5 May 2022 09:59:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT017.mail.protection.outlook.com (10.13.175.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Thu, 5 May 2022 09:59:58 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 5 May
 2022 09:59:57 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 5 May 2022
 02:59:57 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Thu, 5 May 2022 02:59:57 -0700
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
Subject: Re: [PATCH 5.4 00/84] 5.4.192-rc1 review
In-Reply-To: <20220504152927.744120418@linuxfoundation.org>
References: <20220504152927.744120418@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <578f802a-9072-42ea-94a2-e9b26c0a0477@rnnvmail205.nvidia.com>
Date:   Thu, 5 May 2022 02:59:57 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d1082a4-ed94-4d5c-8643-08da2e7e0368
X-MS-TrafficTypeDiagnostic: BL1PR12MB5970:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5970F9EF5DA92E4F2A7D5D55D9C29@BL1PR12MB5970.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y0cZ23979r8q3+lAYa4/AQObyt5Z9Q7ymcbsbw/oXjoLJ36ceFxEn8yPS00QKAoJPYv+1FJ68l0xDVqJwEnvFXlagtYejJfXriHfY+a2cr/gJz8+xN5KW/hKVzgsLyJaMmKyaGifoCWUcQPDorNb6TXL51IH1gTcH4JI3CH+dHmFBROQJCqi51Q9r0nm4aS+DP3Eu7wPKLk5rL/Xs8BQljfZlBT520qrzkVgg4Cq4xKOISD3bGlP+t60dh36w9Dth1gn93f0l2LzA8GUhnjaiUCUrSKhkanF9a7w10ZhiPjZgf5KNaVBZQ+iCwZpBWwvc0ydKIAEZAx6YaOOVP+vP4bNMMIDDoplxsD5O2l90iIYOb5/EfUl6XWP6EJaBXG0BHLaL7f+/AMulm7xu5YoH3UgSJP3BG/NYpBdMqTY5V5z6mMt7Mn+jg5JTOapO35RH+xVqYbTmi7s0xXu0Nbkjsr+jcHHkvS8MHwLlYp7jxJGGnt8RI8UFCqVAjwmq68tsXHRGVSqMfiefxsM1FS45dfHFYBzjW3C62CD/Q+IRHNxvpzBrfZxL9e3hk5S/bhP93adFL1UdjCAerFJ16t9ToL0ei7IRFpvykW9LbqpuZApPjONq+3rb4o+sJItKy2/vp6sp6vKRRjS0lwaySEpnmCI+Vl5hM+v9w2ftLOHJE5XUmJjUDGRJT8vKNrO0JYy8WDwnNZiOjFDzUfUqtrKEi4PEvICPWXdYpjx6DfwYlIZBnjuUr49oNMc4d0vPmbKefYwv5GxJVrZNKt+8Je5jR6uhxrIpp+EZVRibjPayQM=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(70586007)(8676002)(47076005)(31686004)(40460700003)(336012)(426003)(82310400005)(4326008)(70206006)(81166007)(7416002)(6916009)(36860700001)(54906003)(186003)(316002)(26005)(86362001)(2906002)(31696002)(356005)(5660300002)(8936002)(508600001)(966005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 09:59:58.3347
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d1082a4-ed94-4d5c-8643-08da2e7e0368
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5970
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 04 May 2022 18:43:41 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.192 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 May 2022 15:25:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.192-rc1.gz
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

Linux version:	5.4.192-rc1-ga4a4cbb41380
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
