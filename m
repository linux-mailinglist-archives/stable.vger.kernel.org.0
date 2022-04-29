Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 207AC51516C
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 19:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379114AbiD2RSe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 13:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379100AbiD2RSd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 13:18:33 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2043.outbound.protection.outlook.com [40.107.223.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F101B27CD1;
        Fri, 29 Apr 2022 10:15:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZIHs+Qd9UtwU+XHJqt1YsbExrRZ+Lt+X5B1QX8IGqx52HeflApBl578H0DQYnPW/gJTtoShYm5AD1bX8a9HdIo258mYPux2F/FX0U0Q34OmRFBZPZHhaLNBxi0EYm+XeOgGQqLSAIHeHCJU58PACIf79vl66ly8qQiS8U3SzAvGpQFsHMvXW8Fm3GTooNSAkZKpn5c6C8+PnFDoA/6CfCmxAjJT0O4NT0qrg3OOMXSqi9k3HoulPCzVVosI11ujd9Pq/tKf99WiCNLRYc58m4mcQefYRRguXKpT7lkA9gCer39ZwRvm21YjGDfepfHoaSRfZ+R9HhdkQ7gdnIDAxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GCJFx/a80+jjaCllfl0NMVSXnPVheUG33Wa870czTN8=;
 b=bJpUgI6QB9LQFcbgNCD9TqGFnMf/ZZER4+77RhNRUt4e1XlJ+GUKnJUS9NPECmDXgK0ibjftHIb/Rnb1VoPXn8DVeD8LjIyp2dZBXKvr0yspYvDvMzlllPLzLd9Zij/DlF5XNknaG3GmDN1qsyiBdV22TJKFbhCNoVbfhAtlQLHQ3ukm6uPeO5OHHNXnFz0QJV065w5L3AobLLHvf350nkf2uRYGd7uhivANjBrwxYW8B0HTv1SRoD5b0MM1k4bQe+w1wnAtAwZJyhq8WUn/NJp/bS9dk5sj61WCghf8e6whDvv2kDlTGfwVd66ce47qxsarvxG6wgimXELc4rK6hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GCJFx/a80+jjaCllfl0NMVSXnPVheUG33Wa870czTN8=;
 b=O/dbeJcOFBxanOisy726KnyvjWRYLWsxT1fBtRelpVZPFDbBjojlZLN6b34lMq9mjcvUMN5ykVA5UQN3q9lL8y5TGveOGp9mNEYGXWAGRLaQL1AUiAhDs6+cq7zLhxh4ZHzwJ8u2bGoqtcxe7K1SBV3dacKnY2bdZSupU48hLcd+HrOUHo+QBCyO16gBi0Gy0lgEDHqJvporJlImfosF1iCyiGeX0ey0EikB2s3LXY5zAn7/LbOlz0DrYea07FMZLBwAbuliElTMAYxuYQobLVVukoo/Iq7ciF2gnqlhGUxnQZk+L+e664ToR9cWrYP3JILhsbmvxbJlCYyBmxWpxg==
Received: from BN0PR08CA0015.namprd08.prod.outlook.com (2603:10b6:408:142::31)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Fri, 29 Apr
 2022 17:15:11 +0000
Received: from BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:142:cafe::a2) by BN0PR08CA0015.outlook.office365.com
 (2603:10b6:408:142::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15 via Frontend
 Transport; Fri, 29 Apr 2022 17:15:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT012.mail.protection.outlook.com (10.13.177.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5206.12 via Frontend Transport; Fri, 29 Apr 2022 17:15:11 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 29 Apr
 2022 17:15:10 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 29 Apr
 2022 10:15:10 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Fri, 29 Apr 2022 10:15:09 -0700
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
Subject: Re: [PATCH 5.15 00/33] 5.15.37-rc1 review
In-Reply-To: <20220429104052.345760505@linuxfoundation.org>
References: <20220429104052.345760505@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <865e0cca-09a9-424a-be0c-f5c6ff742370@rnnvmail205.nvidia.com>
Date:   Fri, 29 Apr 2022 10:15:09 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5dfd0c5-eaa9-4f3a-d884-08da2a03d198
X-MS-TrafficTypeDiagnostic: SA0PR12MB4557:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB45577810D856FE32C7486D94D9FC9@SA0PR12MB4557.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r+2y6ZijPeq5RxLVTXZegNhaMlkUz+WLUhQXKMvgDVhR0SGyTQ2GrM5F/JQYqHKPc1Dc/BHbh80DjIWefz62RpLAV9op7f9UjvJVGhyjby8cUGF0cmRA9tQkcBSl4hBDU7lNJnZFXvZQsNZc6SShAFedaCeiECgvaB74ocuG6TWxp4nrpD5LO71oCbcDX6fIo2YgyDGx0y+fCea55LJdCJ6TJTqvFv+TWb2XAWiC9pAaOc5mdv6yvYr3LNyIovwmLsTKP2bUGwpvG+dS1nnHGZfBZIMrRilJvzm1GZa5xJMjjZVRwLKrVN2Rx0kCaqYHtjGNNNvk9EjVRTgdSV/EikteZLagEzvu4OKJw69VyhCoPTt3jmOyFEZZYCtyNhk173deTfhMaI+hND1suME70qY7pkntmgNIw6BO2EB81AXGbAHjrmreQVw3wimGZz6eKmQwOZOLlVgLiZ9ZcoQf3COXHAkl+vmfy5D8FmQiksYGYJ/gr5ENIuFj9qNmpsUbOQeABmj6waovAky+MmP03R0j/p/Kaa7rQt1xduJ5NfigEPQRKuyM9GL5wIhcFvKmLS/heOGMFd+EaoTmQjvi3iDCBr3qprKZY9CJzI9T64SsFqyAj4OJw3EiH6wFR3+Bl+6NUbAewxk6iaXnpVlTiHLNHO4vksHVERUMR7kKjQVRDJ0IeQL4xaShCXCpW49mqBZgRx0zgYZ143G9W1SaIGqhfnYB3T96lyD/K4WmccO3uEeMtLwpZz+18H5GYJmkZVCH9acY2JjjCNxQtW9wpcrPUTZXNQGUuOXBU0kq8C4=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(47076005)(31686004)(356005)(2906002)(81166007)(26005)(426003)(186003)(336012)(31696002)(8936002)(5660300002)(70206006)(508600001)(70586007)(7416002)(966005)(40460700003)(6916009)(54906003)(82310400005)(316002)(36860700001)(86362001)(8676002)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 17:15:11.4351
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d5dfd0c5-eaa9-4f3a-d884-08da2a03d198
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 29 Apr 2022 12:41:47 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.37 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 01 May 2022 10:40:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.37-rc1.gz
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

Linux version:	5.15.37-rc1-gff3177a2b8b3
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
