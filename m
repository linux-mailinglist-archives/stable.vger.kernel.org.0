Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A517143AED7
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 11:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234330AbhJZJTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 05:19:06 -0400
Received: from mail-dm6nam12on2087.outbound.protection.outlook.com ([40.107.243.87]:9025
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234327AbhJZJTA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Oct 2021 05:19:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W/sKdis0AxI7+mS1s5nBNFsEU1rU68C4b6GWZXyoKZdl62WB/UFZTtxQDmKNprWgSH4AizfW0+tf9MnK1FFXHdvvAIxKsqLX2dop2xzqpP50iXyLNQKD1sH7KdEmtTZdWeDvgtnzsnhSYmDtYEnCC86I1X3Xu3wjtAiT3Ui/Wiwq3P7yQ+0XEjZ8lLy8LRdH16Xcn/YhLguk8h6ePvmBj+mIUg5x91hr/LL53vA48qRIFgRphuEo2h2Xvj6Ji9czvXA7yB49M2hpcfC5jecNw+sIQVpUGv04X+EKslmVSgjdJAD7niOZjNw3UZfVvgGCgxWMn5UeOEuHo5EYlaq9Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BtT3sQVTQ80RhIg/NIQFAypOajy1v3GjYzNUBaOg3Y4=;
 b=cz6dFnT/Qc0yGpE/AJCzimGSlRxUr44IVJ/tVe1UuRvXRL+4iU8WB4u1CZ02nVwSS08earjdjAP8Bg8qNWAxJW13HEcnoHp83ruiCUpKF0vHnQXwRhZl5b5PlZKkeG1obvIHPUjfDkIiBbbHfv5XE8YlGFzV6V124snUCf1jPjQQnTa7+zcJvkKpxZV59VAbOZzHO+0sxxNZDxUc3I5sLmCgqwQ5SsOuEgfTIQc70/qoDvTYl+N/DgBAKoDDg4qcAoO5UphxV4xdeTLX5C5yJh437AlR6nUzruuP7GkqbqbdHZTXdXi2bbZQaRVsnLlgwLI+906hrAX9Fk743/Gvag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BtT3sQVTQ80RhIg/NIQFAypOajy1v3GjYzNUBaOg3Y4=;
 b=NaDiZf6TZ3oHTXx1UGTLi5oGME3c+Nny1zy+G5NHWVqTh/fIBA2xDIhXqGOEjmskwv/sNDZuCYSTdq1GZ18YUDejZ4YlYNqivhqq6fW80sw+2AkusBZdMK7ihjAo8XknjXFZd+EFFnok8VLK/zDGSWuPwRPuM0yKCSrtjZf+SmToTThKLcIIcBZOFJxiORotTA55JRZPjRKBBZRXjBNZYgjX63SpPtDiwF+amqQ6CPa7oA/TPZNwShwiEEJT5tPDMuKEepSqeDGrHrA7WfCl6QYz4ggsLenObLAhxQXgP43UiyRAqkMqg2SF8f15KI5EcQBIEp7Jm/nZJU2anJyoKA==
Received: from BN9PR03CA0599.namprd03.prod.outlook.com (2603:10b6:408:10d::34)
 by SN1PR12MB2559.namprd12.prod.outlook.com (2603:10b6:802:29::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20; Tue, 26 Oct
 2021 09:16:34 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10d:cafe::3) by BN9PR03CA0599.outlook.office365.com
 (2603:10b6:408:10d::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13 via Frontend
 Transport; Tue, 26 Oct 2021 09:16:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 09:16:34 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 02:16:33 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 26 Oct 2021 09:16:33 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.14 000/169] 5.14.15-rc1 review
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <22848012681243cda6d82a04ac53817c@HQMAIL101.nvidia.com>
Date:   Tue, 26 Oct 2021 09:16:33 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b39c2b6-af79-4796-ec97-08d998614e84
X-MS-TrafficTypeDiagnostic: SN1PR12MB2559:
X-Microsoft-Antispam-PRVS: <SN1PR12MB2559939A85C7C53F7489D883D9849@SN1PR12MB2559.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dusx7XrkovGDF1+GBP3u6GNu73NOWopDIwraq340pVb0xovXqRuXygUrGg76/CnuQx9Estyaq3fl3Y68Ufsb5PV8m1zndl/W+MmqUjTw+muEIdndPGl+H3gCU8tz2oz+h83WBBTwXWYlX/pAz1HAX9bmxJzY5Ow/6G17vxyHuspQ0AgQZ4oW6ROOmsOYuD9+2tkrJ6nNvo3gIYfdk4SH51Xfjt4rdKdaobIcIZgtOD3pWrxNKfaOTjKJzbTjSFH5ED3HrEH9fZAVaJ5BY+hYDpX4/1qgp51urw8NzDHklQAwB3lKVBsCzMVG6+3rmJe4+PJyvDABks12A4euQzc9DYWbo9ae8rxyC2BSc+UoEI416IGflywhAKyGMgVRASaprs3MgUlrtP4SwfxaRCbc/L/Lz0m6jh9iSSLhFtE2BD3UOt2TwpDeazjyeso74pe3dAQ9VafjNgOQmE4U3PI/v2vl62piH6Y5ioiwO/zrEcz+IoNlD47C54kxnVBPDmfQY4yOAgp5Nzl2DvDUP9nAbsuC20tHfLxpocx8BJCpYxJaCPoaFjmkLFwKQf4i2eY5FSUwgU2+4ntiDiVG/5CPaTQs17sZlJwomce7GeKjXtD5NEHfbmWOfw2zUh/owI1qZF1bGkABXIYSL9ws6TIi06O1aH6RL0PWtuPrsLd7LypfRTcBhFInLUcmvE01XPiFfqxNw5jMbJQOHZ3A+ZQrBniUSITIhSFK0gfNDQhyQegBhD6QDa1IAvGnnmC+6ADdnWcmvI6LtaUU2NsfXjAKseaRVqVTMmZ6jFd4h4eIquA=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(26005)(7636003)(5660300002)(24736004)(108616005)(356005)(336012)(4326008)(316002)(7416002)(186003)(36860700001)(70206006)(70586007)(8936002)(426003)(966005)(508600001)(2906002)(82310400003)(86362001)(8676002)(6916009)(54906003)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 09:16:34.4470
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b39c2b6-af79-4796-ec97-08d998614e84
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2559
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 25 Oct 2021 21:13:01 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.15 release.
> There are 169 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Oct 2021 19:08:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.14:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    114 tests:	114 pass, 0 fail

Linux version:	5.14.15-rc1-g359943f37028
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
