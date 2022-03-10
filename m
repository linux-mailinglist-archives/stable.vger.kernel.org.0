Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C55B4D517E
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 20:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245588AbiCJStr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 13:49:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245590AbiCJStr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 13:49:47 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2076.outbound.protection.outlook.com [40.107.96.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CF44D9F0;
        Thu, 10 Mar 2022 10:48:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OzX3iGA5naGAalsxhQtaSBFHXNcymz4KorKU451c9VGWdJ9OtuYQ42fXRw97wh6XBtNKpSSK+fL3Ea0/3rF2V0jRsjpT3Hgbr8HxOoy9jX/TyQp1ht/20THoFuZGCbvM6QD3QEXZc96n4iD3kOCV+GE87RiJbacMENH8afx7SmAmXvrLG5zw6ELxhTPkrDK6h2F1agS/8GxSKmtFR4mnkrmem5etwzUrBiCMTxyQ6uwI6En9GUD9sCj9mBOLexvUxS4tOgbx7/R44mOYY79/v0ld+BUPvcQoQrGgGcGZl8ZATTeiuOACR3qE5nEXRrnCqTkobtmDgE6xK6PL+iq2JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VQu6NBX3Jw9DdPvNGeTSKl/m1pBcVIz8p6JNgcPBKEs=;
 b=KD/xhJYWBpkXCSeMHRXQSnIbTioDwQ5M0Pdon/gEMckNCg/UjZp3PmdX97Zfs+xY9E5D61cKKExzHREmSib8so6Q5lB4hcuQiQ3Hojv3+a+LTN9EmuItSUIea4a1VmMbMiVg9O5SUD+xzcmMt9Q7s7iJ6qXP68rWjb6CKlkg2exsE3zXArMQWFuw4ZcNnex0n8imPEK97evrPlJxlxGzC5qwFPAJ/0KjoieGa/KqxtXC5E9FCvlq9WiTlinajhGwLB3fcCyEM20k8qmTHfsg0rAi+DaWE+Xtu7S3R9oz6pGvIcF1uglttVXOU1e9lAcQukuGwE6b7qp1AaczGp4cCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQu6NBX3Jw9DdPvNGeTSKl/m1pBcVIz8p6JNgcPBKEs=;
 b=Ot9zm0LwG0l0ZOZcwPdyx1HnkVZcrdJkU6lfIOv5OUcSiWrJdtEssZH8//z0bll74lsgOMCda9yOxH3dssOuB6WceZ+kdqg3kypTTzyTVE0RXB44vveZA+224MEAv+KaH+tV2z9MSJf7ru+GY0vEgkwXFaajrR4vH4ZS4iGgTeruoOIfhVQ248Qpv9UxJBiEJ9p0NsDp4uk1rL0jCBVhiUq2svx1oB/y4x3GPDHgKHZ1cwetAmsbP0jISYiluJeRqOq5EXg3jvjYDJS6bLoFjeycAbzL+0Ld2ddVvBuCfUmOzIVbAfj1si/Mr2NslLllYKF9L2r/9R9o0TQCUANJwg==
Received: from DS7PR05CA0083.namprd05.prod.outlook.com (2603:10b6:8:57::29) by
 MW2PR12MB2459.namprd12.prod.outlook.com (2603:10b6:907:c::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.19; Thu, 10 Mar 2022 18:48:41 +0000
Received: from DM6NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:57:cafe::21) by DS7PR05CA0083.outlook.office365.com
 (2603:10b6:8:57::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.7 via Frontend
 Transport; Thu, 10 Mar 2022 18:48:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT056.mail.protection.outlook.com (10.13.173.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5038.14 via Frontend Transport; Thu, 10 Mar 2022 18:48:41 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 10 Mar
 2022 18:48:38 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 10 Mar
 2022 10:48:37 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Thu, 10 Mar 2022 10:48:37 -0800
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
Subject: Re: [PATCH 5.10 00/58] 5.10.105-rc2 review
In-Reply-To: <20220310140812.869208747@linuxfoundation.org>
References: <20220310140812.869208747@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <3759a4ce-24af-4f30-9742-7d22fa203b0e@rnnvmail203.nvidia.com>
Date:   Thu, 10 Mar 2022 10:48:37 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8aec8df-3ba8-4569-161b-08da02c698c2
X-MS-TrafficTypeDiagnostic: MW2PR12MB2459:EE_
X-Microsoft-Antispam-PRVS: <MW2PR12MB245956A488EF2368F3E82C67D90B9@MW2PR12MB2459.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5URzo1jy7MNCvPsVyoMxg+QBVYMjH4QRUP5/xfr9vjpxvI4zkFIk0Bm1nURw9UEF5LYZTRy9flcMUnIaNdW+F8JpS43A4JKY6Mxv9sNrIOArzgi9cATG74eYfErX86QDWzN6ZrIk/1COhyOT23W8OH9wa2HYSjc5O035PK3bIyGCa1ZNz7m+uDmVK1tKu54unVcoQYzqBHLC5QVZusdE/jM/JxEURD20rI+vO0kRRAjeZUpDkVak94OPZ6Uc/QEUroPduETCWLIggoJWRF2xFAePSaLcfM8ydobvx27KpEU0JslE3r6GJWgRLdYKyM789niW8pUIjkQHYIZCJ/7n69Vt0fZR0ZEsCoDQ4ZuzfCiQBppMTt4WcgRgj4YgcYqhuJ008PDXOFEKKhiFm688PqSC77SlAqyBr5DwTstpaFIrlrPrF9u//Psymu1ZHMpxoFLi0QqOp4GXcPlCAj0JrWWCcLRYrrK6heY1jkDLdXKtRm+adkrH5bsrHqwhooUdxIoVRGHgBmk8pldDfpmWk20/Jsk7f8RHOGWi4mO6yyajuf1btBnKy5oY7rmlGzkDgwSA6Qdg8D/mDZ54vkP225CPPl7tu8106kqL3ckE39f9RHRPALBYdIaUGWGKtDj2AMcXmvnaG72lVjarn50wsHTnJtoUbdSfN2vaFgwewZaSNNOoRJ0FW5Dqc7tG2XNeMDZXSDB/l9lEyFKQSI5RrrgX4Seq2b82FY5MyPZnj4jneA17a3e0y7WigJFNUMbWR2Z/dJOoj6FirfXviLk16VYNGhwsANVo39D7r35asvk=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(40460700003)(2906002)(8936002)(5660300002)(8676002)(54906003)(6916009)(7416002)(31686004)(508600001)(31696002)(966005)(26005)(426003)(336012)(186003)(82310400004)(4326008)(356005)(81166007)(36860700001)(47076005)(70586007)(70206006)(316002)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 18:48:41.4576
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d8aec8df-3ba8-4569-161b-08da02c698c2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2459
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 10 Mar 2022 15:18:20 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.105 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.105-rc2.gz
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

Linux version:	5.10.105-rc2-g222eae858936
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
