Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAAA4462EB1
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 09:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239666AbhK3IqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 03:46:25 -0500
Received: from mail-co1nam11on2078.outbound.protection.outlook.com ([40.107.220.78]:29057
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239698AbhK3IqV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Nov 2021 03:46:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HWZ4YT1re839II+7vQMesn8ODAAy3NsowwfWNdCL2+L+Bz7Amy4uFwDKrvA62lfzo/Z/GQloxRdZ5VdhcfXzYqmcRPqlrIKZtnOtMI3WsWNSviTqWlcGMLRV6pLzfc94iR9WyZfj03pfzWFStabt1XPs7wAgixIFBnGViQDHYSBPuoiQ9EtOBpU0M20H+bvkA1P4YD99O32rnu7Zd3Ac5/m87WPn/1UcI+ZWuQBEzHQg/Vk+NzBtQQyN8pCOkQF+/49G+uMG86OzOXthZMBz7+2ZDp+aP7x7BiEgB2R0wP1K7jjqT69RjlXpFaciLtWFYERIZWToxntPQQawadRjuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/onyrO6G4LyE7igBdw5euIRhY5dCWyfgbkTaB5wqJss=;
 b=iEX0uxDoAgamFLxhG9qwINGRMvENGjltDj4krHmpqgtY+tQvfZmjqCcioZ+PD8xLHygeJA34Nvp6mbm3+Np080Nl/+yqJdF39l9o2QQHhzEObZroYjpp3Q5sopwswfhpOHSHsv4sUR2cuxT0iK2k/ijlNVOU58uzWkav8+iQpGCyE07gDYdLJZ7dhKbSGIqoaie6Z2YUInmGLjMou+ZJoCgIJTTGZzlBVTeRIkVl8ziQiTRm9lD3y92PLMI9qcMEvWwMS60JmLFuJTKG//j5ugY7y+zBNY0TuJFq+RPdhmnhUMcU1+Qu8BG4fOTwCScvCPMl8EX361W9aFr1XwG5yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/onyrO6G4LyE7igBdw5euIRhY5dCWyfgbkTaB5wqJss=;
 b=CZnOMXYFY8GntGzXeiX8duVby/A2rjel/ApVaO8hsDseMe5OUp2PlLl8tHYGVWljgnr8f32P8AOIJThjmvKkhJdxdoHc3UaLihuOZDpueK6lnJv7WWtOfkg5wIdT81TU+jsLSVFr6k250URXPpiWnkk9BAyVRhLevBrTbKxpdc6KaN3hlbuAGI/6c3SfHEEjVhgWoII5qaZr+bYpSsn7byOeTlbU84CT2yC4DX5wVd4QpyICiA9HLBoFwkxZj3nc3+JrOtkR/f3S4zswEkh89878WnmzxS/AGm4BpaS05AIr0pqRvr4wlxTKqEnare5JG5k3BqWiVqr/FJIq2ely1Q==
Received: from DS7PR06CA0031.namprd06.prod.outlook.com (2603:10b6:8:54::11) by
 MWHPR12MB1295.namprd12.prod.outlook.com (2603:10b6:300:11::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.22; Tue, 30 Nov 2021 08:43:01 +0000
Received: from DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:54:cafe::d8) by DS7PR06CA0031.outlook.office365.com
 (2603:10b6:8:54::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.21 via Frontend
 Transport; Tue, 30 Nov 2021 08:43:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT012.mail.protection.outlook.com (10.13.173.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Tue, 30 Nov 2021 08:43:00 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 30 Nov
 2021 08:43:00 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 30 Nov 2021 08:43:00 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/121] 5.10.83-rc1 review
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e01a4face2a640c0bf86c68f15184dc0@HQMAIL107.nvidia.com>
Date:   Tue, 30 Nov 2021 08:43:00 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82aade41-aa10-4918-9cc1-08d9b3dd6abe
X-MS-TrafficTypeDiagnostic: MWHPR12MB1295:
X-Microsoft-Antispam-PRVS: <MWHPR12MB12955905444A46B5BE95CF50D9679@MWHPR12MB1295.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xOOh3GlMd73Dx7a4VVHMIWQ4usSYut3MaXKyrRIAGa7rA2oJEfD6VP1NNmHiqd2GpFXlBT3XNWYsye5Yd7uwqQqL95YGx9iMy12T1dxVat2vEMzqS/dE+iYowxx/7b4TPFLG8vPO5+c6k1q2li5kzgBSsafIL0W70aiw/SdI619XNpvJB/cJyGlfLgOWDf2o00S7GgBlSKoWye42ipEIbnzjzQgwCzkhcOWhPvq8xHqu7NyZfLPI41YXg2YczhJ3FDNf6brS4NpK6wcKchQdKrynRMW/FiAkgOHyMpOvJAOkB5ejEbmmJpz7ijAqX7ZE/gulpcc8pbkqRdGvz9l3CiKnXkTGTxYBNS29F7jdLSnZiZwKtYMBRippyoMrXxk0qA95NfirYHviUw1VxSScvQoCKTDevTogT0H70KbDbecSabhOdU6Gwl9DZfhY76XbiWG73G6SvsXYKvy6noRyhQUt6YvLXI0psdSzpCDmTthO1agqCDvmbk9HICnpIRPzXEfUTslUhm5PrjtyUUzGih5Km1XUhYEe9G+K9GganXA1aKFCUdh+pqYEwTO1GmxZMlVSdi7q8qLMv2kJgtoT9SjaBYc/gi49KSurCQb/XHifQ6xufvqba9AIhVTAbF1wbHYF3EqyG4Fw75ZEhcU5RA5/ewcty9tt8gp7eZR+0CgU2YpnXW7woglT7V2pjH3XjLNn06RlIYdSAsWSMHBld81/DKdCvLYyw8CWfZ6I3pVFdzd1NcRa3ca4cQwyNMI+QVrRRz90vkOgp/bYgX1Pjhvy+996EXjW2XeE4nrgjIs7eZFRg5Ge7i1h4JzAYiUGxemRB9Cc7UviROmQ3QAf1CHqO6JSB4mLZOSUtR6qZ8k=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(5660300002)(336012)(70586007)(6916009)(70206006)(7636003)(26005)(8676002)(966005)(316002)(86362001)(8936002)(47076005)(24736004)(4326008)(7416002)(2906002)(54906003)(108616005)(426003)(356005)(186003)(36860700001)(508600001)(82310400004)(40460700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2021 08:43:00.8567
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 82aade41-aa10-4918-9cc1-08d9b3dd6abe
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1295
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Nov 2021 19:17:11 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.83 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Dec 2021 18:16:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.83-rc1.gz
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

Linux version:	5.10.83-rc1-gcd4fd0597d37
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
