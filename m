Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4135051BCA9
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 12:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354797AbiEEKEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 06:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354772AbiEEKDs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 06:03:48 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2058.outbound.protection.outlook.com [40.107.92.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70949506C3;
        Thu,  5 May 2022 03:00:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zcca8R5isH9UteeFOx9nb26tl4RvT058LYoyOdrbJrwI60RFtnk46/+xBVV1LLRUmPCTzNnloBOb3m2Ym7fM6P5M7mclwZdu3Py73sM/qTBvBTFHA7JeCbTB2asmrhLr/s4q1qzvuQ9FjRlzsgMhZFdF1GuFJzJRGUEj9fCB5d+5/oCpo7zDAubtwJxUqzR0EKCyN5Djv6SvGa/bEMA3QM5LsRkfz/lxdsmovBsnYngmOcUYvZZ5GcLsW78hJExH3PpYBbw6IhkBVKjJD4Dg8Ppdn2aC+x452cu6nRmk0oCN/xKTvoKlnIw7Q1oXeA6BPwIMogmuSCdFlxLIlH3Lkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J+nyUQSvGuPfSFxD3/WHGJUhMSPuuh742ATlH6hIG08=;
 b=AqHM4LEMEKhs+7TDk6xfsA+dURyTx+waD0rc9ikv0AVwvxvi8YHiABmZWk3L6eP5Rhpqx0w0GfJF0gIjnWBiPGUh972eK2bBifXc7wxLXwwGIj77z69bLW0P+EAkXqjlD87mC/w+QYF3gd05fndQ+sS9FEnzLd/IhMFZtOkpB9Mk85dGkeibCuWIEpdGjPjIxEN/JdvxZZaRitt8tFERmhjG9N9GMMqJSq2putHB6MR5jdbluzq/mPnuG5uQOSKvq21YI+AmfRfjtYRWwFsr+ai5WgG+XrL78Qi+zparRtoigXkleZoy/VQDw1e1xvfmCK/1uR35vbxgc3DZ4qpeEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J+nyUQSvGuPfSFxD3/WHGJUhMSPuuh742ATlH6hIG08=;
 b=AbN7ZN6edKZ2Ek2VGQmbDFRXxzvu6BS4Mnddp2sg/gUdAUK9h6xpNl3gGd1O1GGpNZxPsIQ4RIrRIPnFnKfrPNia+aiXXHk8Q6ZGhJNobYT1kSYHhE/gnnMxnQHgAJ9d6Pfe3XoyM2/QrXQ0NyiBUTJJ9h3Ucf24NiluR4NJUmm4FtRrEEybRnI/9+dWIT/4WJhUuZHBPPNXNuPXNQeQ66jd1WTWBEvwfKisUp3+H5VAdKG04UTfMM47yArJCiBWQs07i0DC0r6F3/73fB9QYnJnWQdNWWjLc6D0EWFtIhUKqQdI8puUKExrzd4xGRkPVpv1FRxlS1NK73HJVCqL/Q==
Received: from MW4PR03CA0119.namprd03.prod.outlook.com (2603:10b6:303:b7::34)
 by MN2PR12MB4191.namprd12.prod.outlook.com (2603:10b6:208:1d3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Thu, 5 May
 2022 10:00:01 +0000
Received: from CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b7:cafe::db) by MW4PR03CA0119.outlook.office365.com
 (2603:10b6:303:b7::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.12 via Frontend
 Transport; Thu, 5 May 2022 10:00:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT061.mail.protection.outlook.com (10.13.175.200) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Thu, 5 May 2022 10:00:00 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 5 May
 2022 10:00:00 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 5 May 2022
 02:59:59 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Thu, 5 May 2022 02:59:59 -0700
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
Subject: Re: [PATCH 5.15 000/177] 5.15.38-rc1 review
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <3b2c2d62-1e05-4a41-9d73-7bec2e63f8e7@rnnvmail202.nvidia.com>
Date:   Thu, 5 May 2022 02:59:59 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b0ceb70-fb15-491c-ca3d-08da2e7e04e3
X-MS-TrafficTypeDiagnostic: MN2PR12MB4191:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4191D0152E581F904B0D3F4CD9C29@MN2PR12MB4191.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xx3oO1nmKe4gEkrQo8D0ZzF6UEUthicYY3Vud85vgR/eylnEvc5ptn7tZXKQTCZNvZqsrEVTd4G/jyVx3WuT22lltKVVffeuBd1EMWVOO43I6nK1D4S2TxZVkfymgvkDbPj/VhWpKg9RTccxHENobSDssvETxEFHTfbEDmPM+aJwE3FreL+/tr+0D/Jy6bLa9cThLqfBuCW65aqVMTUDOQue7QfoDccWhMhC/UbmvlrAZ/7R+sEfcvtDEizmjRWtwfoB46b4D94hIrxmc9GS0g7+RuBkgmy+e5ssGTTKs8fh/YS64jj8CJLx3GyVEppa4312d44/GUrhmdrDhkpFG7tCpdjhybfWjZJ715j57vMTj+KRMVMDkTNemALk2IcJy2Y/ncKv4rmlFCb/x94tIigG5Z/CrawjPpbUrpvxWmvcmw7MFeqVRu/T4bgkxVmfkd+WAvKpWWzkbwUQRUrukcxpVZYOUuirFDGpO+/wtGkE51soffAzjcOUolDT3psiBuQqem54Hfk43+AFB8H9cumr1Lzqg6rwax39QJ6Fs/c25WvVLoXyRV4xjAQ2lBlkw19gRRss1NMYax9EdwxawaRqD6FGnlDuElrHtB3r6vsCl4butSngAWqaOdrPeziYbt8pSj49piyGn9/2CYHeHlwZhnpwDov1+KKf3h0Rz+Zq/VMchPM9es6ajOrO58BsayLcGuWkLv2bvPY48CyxwtEKaACWtDTCP2FjcPTjh5Sscez6U2DJ658z70KG1Skaul8XrH5BdxW+wJuG08yTEw/crkIckkWK/KJ57l20o10=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(8676002)(31686004)(4326008)(70586007)(26005)(40460700003)(70206006)(2906002)(7416002)(82310400005)(8936002)(81166007)(316002)(5660300002)(356005)(36860700001)(86362001)(47076005)(426003)(336012)(6916009)(54906003)(508600001)(966005)(186003)(83380400001)(31696002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 10:00:00.7890
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b0ceb70-fb15-491c-ca3d-08da2e7e04e3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4191
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 04 May 2022 18:43:13 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.38 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 May 2022 15:25:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.38-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    114 tests:	110 pass, 4 fail

Linux version:	5.15.38-rc1-gc8851235b4b7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra194-p2972-0000: boot.py
                tegra194-p2972-0000: pm-system-suspend.sh
                tegra20-ventana: pm-system-suspend.sh


Jon
