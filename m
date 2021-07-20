Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E003CF6F6
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 11:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235048AbhGTIyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 04:54:39 -0400
Received: from mail-dm6nam12on2064.outbound.protection.outlook.com ([40.107.243.64]:22755
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235367AbhGTIwv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Jul 2021 04:52:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=npbap9cN/C71ZaLc670kZTzxl7gTfe5D11jOzMrtdC8uI3Bbwuhf/MBLSx3mUthC5rOEPKsRcikMKJhBv7iTOddBahSx+qbXTzOAaBFwxq301YyUzGzfeemsFH343UqLjetEjeGAGLc+PF5TLhqt3eUCcG6gaLQ8PwDlHj6NrdYqsfMrXYgKc6rPpr8Y+r5n9MTepPNZZNcgw7sfeckHuEzXRKXPw6g2beiTZKMRugyvMdgZWxGo5dJ2kp23Veli4hStOLNQYvnGBqOTgYKQXwsC0PLLUMOqBamhucy46FNIoTrFQ2StOA+Q3xlegbzHZkY0P1Mgh4++xyfJrDuknA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xEou1QJlNZE7Iz0wDhkRHh+x0QXQa1taDVOzr0mJJhQ=;
 b=J8N4LXp9Dp5AAMn2ll7NFmzhvuqtfD6oZ332XqOjo1aMDd1Il9fLskwAW56DpopNu3IKh8St37mmRKgd4vtRb+7or66E5K9aYlMvMiQPLwCm/PYBKS0t/pw3NrMY2ACqgzLFkMR6ToMT+DEz4A2lcYz5czuqoS/yOXYlUV6lvqW8wPIdYCgKa0pUwaEx223Dg5KKlOOSaMItgio2uoM8xn2DOhT/0LvGzJGG3e1ahgs2b0cJwpo6cwQR83q/QHgG3sO6zgfN6/0Eu1ODjDx3JvcC7koXZmLf5Skxntw5VtMuyQaiMXVweLk6UMaDurkyl1yabwJYJrg8T0Mxxo4e6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xEou1QJlNZE7Iz0wDhkRHh+x0QXQa1taDVOzr0mJJhQ=;
 b=LPJuuuPCfttpZlj2QGTY6yloTADf9sFgD6Yhkgqvj45b3NYRUmCn/ofZJpr3VIFalfCJdaQe/zervXsCJGGzSqkIVNN9yeeCkqbFE8+IEr1Kx8tP3VoCTPkd8kmiEKtrwl8Io4mCDQuAxX7wSI8GvLtuMBDnvh8fIFtF03Gho8/QoMNcZ7ljPBIR1nCRcTCa4fgwIa32Gy3nV8YwwrylCwLNU66KTKlinqKW+5nxTm+Jr+MjjMT5/ESAUbbndGltc/WP9Tf6SOue9OCd0x1DkrBmrLJ1uyLPnYf/yFoGZN/n3CobtiyKcFV7cDvheMJFpo7za5dXtw09fWp8oqCKow==
Received: from DM5PR19CA0003.namprd19.prod.outlook.com (2603:10b6:3:151::13)
 by BN6PR12MB1876.namprd12.prod.outlook.com (2603:10b6:404:104::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Tue, 20 Jul
 2021 09:33:27 +0000
Received: from DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:151:cafe::5f) by DM5PR19CA0003.outlook.office365.com
 (2603:10b6:3:151::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend
 Transport; Tue, 20 Jul 2021 09:33:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT046.mail.protection.outlook.com (10.13.172.121) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4331.21 via Frontend Transport; Tue, 20 Jul 2021 09:33:26 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Jul
 2021 09:33:26 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 20 Jul 2021 09:33:25 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/420] 4.19.198-rc2 review
In-Reply-To: <20210719184335.198051502@linuxfoundation.org>
References: <20210719184335.198051502@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <7af3f7b0be814ae68d6e786245296657@HQMAIL105.nvidia.com>
Date:   Tue, 20 Jul 2021 09:33:25 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 448ec542-a229-459e-259a-08d94b616d47
X-MS-TrafficTypeDiagnostic: BN6PR12MB1876:
X-Microsoft-Antispam-PRVS: <BN6PR12MB18764D227ABE315ECC3F05E8D9E29@BN6PR12MB1876.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /Kb6ZM/Y3WG3a7F4UBqpQB9N+K42RiS/Ayu6LHC+O/tyPPE7mnSqqgKHLO5jxfqvtCgWGbExqefGthAorobD+98SRDA4HnGFTqTycKWpXEFlLqboHC/dG4v35X1GZO5603uxt/Gc+wO65W3z71uhYKwN8ViVEGR7/f5PnkiPjJzgtXs0UZz7mbKQ6d5zC8uJzRchGsguswFhuMwT9bNLCf+ZzJzzX/T3sJnOyaA6mHPd9bP4Kdhkg6n/qYfuwma7ObsAkyAEXRPEFeJ0z4u5KRNj4NIYfrElPy9JRAphS14ODZQdVh+/pLORxwV5QBdw0iZRtffGG1nT7cor1pO2j1orK6Q6pKnWNodXRt16mkFhmtxwowB6PhCMrXcuZZA2A8WhRm7eD8jHBw+tMHMdWKzt0QIqHBaTqkABeAAaZzIutF3yf8G5XWV9KXeF/b757dORsc+NoHOx7pzZB8efgXOnJQ7yao+iyLGZyjaRAxDbG7SkEKCckMQ7Rh0o9e6tBySYML9xO6wdc9ECK8WSfHdO/p39Pp1eCuYtSLpXqWEfvJQZRHTVkYCy1lONh0W4mT6wAZsTvDT5y3InqpUAhJPF3s6wnm8ssnp454qP5r0QXL65vrOWH8yqqbLmdwmSN4Qd6xnXXWZ+9KAJdngAGNKmk2JHg29MR1RW5Y0eMOuGJ14LVm4BD8HyukLidBx6bWV1T4pBTfB4cURIdU5+ElGwgISAJqS70mXGZBeDIYZG8tfQ1AaXY0Mj6K0/IM3hI0Yut73xUAQpD1gLB4MhScOFWkt0lIhLt0tSiLnyqxY=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(46966006)(36840700001)(5660300002)(186003)(47076005)(8936002)(7416002)(82310400003)(4326008)(36860700001)(86362001)(26005)(426003)(336012)(82740400003)(2906002)(316002)(356005)(54906003)(7636003)(478600001)(36906005)(108616005)(8676002)(70586007)(70206006)(24736004)(966005)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 09:33:26.5426
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 448ec542-a229-459e-259a-08d94b616d47
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1876
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 19 Jul 2021 20:45:06 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.198 release.
> There are 420 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 18:42:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.198-rc2.gz
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

Linux version:	4.19.198-rc2-g9ec1965d618f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
