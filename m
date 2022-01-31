Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA844A48F4
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 15:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350872AbiAaOGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 09:06:37 -0500
Received: from mail-bn8nam12on2048.outbound.protection.outlook.com ([40.107.237.48]:4150
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240723AbiAaOGg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Jan 2022 09:06:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C9PXm61mbUHH5TntdGF43J7rdEzZZFqoxnhLNgpE7evpD4ag3t9BgUcUCprJT0U24YDqSLcilTEAMf4e48V/wAEbkFXhtvyZiNZPR37LmROCoWu13vPQYAmzP/PXd3t2dj/DLGMe/ZNrXTY/TGRTKltN2XXwGgT13iMQHbeKglb4xKv4NJfajtc8T5wnsT2Y3jkJA9OaKRSE6dcyjmflv9yoxpm54PoBv0PjLQLXq/o6KE3WHMj0jL2wsLt5Vc/iIuCVouyKYH6jPjr+h93MXhCCF6K8GGwC19pKg8W2UDIDYkh8wJk8rvEoqnseEBX+GtfY3+MBhmnvdA1fLGwZiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5FYhdURJ7HtEqbbXd62NWrjXu5t+hJeTx1tGVhix9h8=;
 b=SMeg3wvYMVl8SHExJJZXg2L6etmb5nhyGUijwd9mlCcVvP+pgF9egGjR0kV7fL8M6tw8QeYmYRGH6w5J3lWPKvcfpm/58QCYi7f3bxsU/IIudtT/vteL2jjAsG1A5daNyjSB7ByaK//VPfSukv3FK1s6H/bMffK6k734ko+k0dnUqYf4ApN540l1pcDqPqlaB3oJQddLgAbPooI61hGBSEY8/kP6ZG4fF27TM9U8mlRCDfUV07vpQkB8zXaGIbRkKuE0Y21kktUqjl1fLRFBNXhoflUh/tkbs269dWo660x5F0mCkmsqrEExMP0JOhK0SzcJzu/wK+dETIsiv8IP9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5FYhdURJ7HtEqbbXd62NWrjXu5t+hJeTx1tGVhix9h8=;
 b=a0JWB4tAoxXbcTksAbbsDODo4Zm9w7Cc0XPzedhzjrL44LU8hE//NRsvctwfdNecPb0uLK16RfzexW5DqfaH2cMy0Ccpss1BdWeozC207CyAkM8txFLwnejjxLdcMH0Iw6Wmz3n2xR5ydq3nn4QMOOSFN2r4nD3FwXOd83B+U1l7rO76+mYdFIzxyroL+D1wCv+GJFawDd8V2i5ArabSdsRyzNbb/aivjLelky+IoTNK+Tcukadfmqemp4GMvoRwfRE3wnpIHpYPwSef8/N9m0mLXinXLQMWcmjA0lTB+Rls/ZblktgsOxj0tF29RsmICejGfI2j/ZyDgssdU1OZMg==
Received: from MW4PR04CA0285.namprd04.prod.outlook.com (2603:10b6:303:89::20)
 by MN2PR12MB4504.namprd12.prod.outlook.com (2603:10b6:208:24f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18; Mon, 31 Jan
 2022 14:06:34 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::d4) by MW4PR04CA0285.outlook.office365.com
 (2603:10b6:303:89::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.20 via Frontend
 Transport; Mon, 31 Jan 2022 14:06:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Mon, 31 Jan 2022 14:06:33 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Mon, 31 Jan 2022 14:06:33 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Mon, 31 Jan 2022 06:06:32 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Mon, 31 Jan 2022 06:06:32 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/64] 5.4.176-rc1 review
In-Reply-To: <20220131105215.644174521@linuxfoundation.org>
References: <20220131105215.644174521@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <9fccf577-7d02-44b7-a80e-79a120c7d437@drhqmail202.nvidia.com>
Date:   Mon, 31 Jan 2022 06:06:32 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 485a8b42-2fcb-4714-771f-08d9e4c2e32f
X-MS-TrafficTypeDiagnostic: MN2PR12MB4504:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4504A486412ED477203F4F16D9259@MN2PR12MB4504.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NQ5bf3fiOMKDgTLMQQQC1l8w9GqOuPFi8U7/Bpaq9p8XYdkBmHalCywkbixx9Jd9rubuPafWYl8W83Gtt9yyS6Pm0ighUkv1tt/6/7F1tdMWXUF/qGsh7goVpLSkNRSVJNAE1Qkweh6uYDH+7H5XpvVxMU5q8Src5waQtXAOns7NvLVbA7z3PPaGNhvcYQ2Jt1Kj6bKhdDB0vN5tQGNHjgTzT7fayRio9aQE2IffV772AWpRlCuJfzUr/1quY5Sd2UUQcAL2oafptTyzXDJyyzH8tZl0s3jGEAaa6JQop0q1j+NVKGhWLWG8R52qv1b2CJHu+GuaJMfNFYCHDbJRLAZ5IN5aHtjnt3eYjusRVHG7BQrBOqGYTHOhv1yHRsC/hMj/IzTjXQUp9E8vqgkn2Uk+K/prC+9hR0fXH+i8Ceem3e7Sn64mCs3JliQ1GxD4lzbBppSLzBSkJq2ofeChQbaAepkMF8IrWwqq96s4DJ0L050ZKA9jYuJXyLnQ3cA/ESu7uCO476Wr+uaNCBaJzokkyeZ8jfdL6JUsVE5n7fgf0wPunVBZcEkTb/FOz5e4/J310WfLsMWVWkj3z/Fz3TRjdmmLpoELufDk4KX5Y7kv0Jx3lctqAYP4OIWVh83mBnl4XRhtJ5XCFxY1WoN4HKbHCoJ/8LalYyjTofGw2ino4NkuQAC3UYsVvcofZw/spXI9FKsnKpHhpyrZJjy/Wopr2yeQgDTzNsfHTjkUzyLLIOaNRdQd5zzYT3xYvIoJqWNjR9mI4u1cA+75/lFMd0DWPkmqfBtMsVuja6M43zc=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(356005)(5660300002)(81166007)(7416002)(31696002)(336012)(40460700003)(186003)(2906002)(426003)(26005)(31686004)(8936002)(8676002)(4326008)(70586007)(70206006)(36860700001)(316002)(86362001)(508600001)(82310400004)(54906003)(6916009)(47076005)(966005)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 14:06:33.5025
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 485a8b42-2fcb-4714-771f-08d9e4c2e32f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4504
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 31 Jan 2022 11:55:45 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.176 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Feb 2022 10:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.176-rc1.gz
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

Linux version:	5.4.176-rc1-g67819ded87b7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
