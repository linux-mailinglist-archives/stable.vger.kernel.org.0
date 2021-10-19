Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEBA8432DDF
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 08:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233986AbhJSGLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 02:11:44 -0400
Received: from mail-bn8nam11on2071.outbound.protection.outlook.com ([40.107.236.71]:24729
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229649AbhJSGLn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Oct 2021 02:11:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mIUCLOaqbDNhQt+GOnNud7In20wj8TNq6k54Xo5ZBF3zkuFAoHrZ+qFdi/PR7ED/AHrhj4WvpCpoCRWqm9K6a1NK7XUwyJKScT3LzQdGaO783Fo4cF2vILyt5GfVdzp+GXa+9AFFfqtWp95FFD0ATdcmNLtPFiEb4IApTjuBGwJYlWRT+GiA4M1qrFpouyM5I3uYDrmEuLCjg5WfwI4ozxxDegwnHe27mrOvbFM3+rRds2CLeakaKQo5KgVpTA5O8u9zmb03SDi+vCb3qKLRwW49I8ythweRedO1+nKclWEGXApRTZI63IPmp5ihc1MckHN1OqgErddHu2kMyVZ/qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MjWADmsZdal0x7d432Lt/52cugyduDY2dYwI/OSZ5w0=;
 b=P2V9/tPcwKfi0STxvM/Dy/qd65SyHtCfrxvU2ZuhGUJsl2tdZYRodboMKKnCn4LxBV/rmDADfhR+5LBnc0zUVFWooNM8amC0COwCLFwnBkp9LV/6qEVZtPjCpG53J44EK+aU0sfTqmMKHXdiJ4XXYJhsnuIa+Tecn58zK8w+9TRaobE4Awc8u/NaEC54MO7pArHNvctPNcvd2x9bTTSPi8LaRtysWf0m9g+9yaAy4kxJBCxupwes7sa3rlVJ7Q1BIwxMLHkQk6MupFXFbAMCdFDyyDk57/bGcxl64Djin7k5IyPy8CBQwEARbBfDvaOyluM+2VRe9fzfL6nhTPJ+gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MjWADmsZdal0x7d432Lt/52cugyduDY2dYwI/OSZ5w0=;
 b=I2VFAwcGslHNf3YTp4otOuL0yDzlvPLhDW/HTlkszFJQNkG8X7H16YAyKkYbWsAOyPQBl769F5/Jovxlc3e73CUuYhwo1Xj0Z31ddEgGmaXH52wg4w0mhk2L/1++D6HKzYIaBj7IleCzOYznPgXrl+qVHBBw7Ogru5zycNdK3Ivwt3+4i7BuItWeaAnLQNUT/ZgsvdoAttJdybNdApPE0yOkZGZ+FZjejOfXNIuwN2god3ypKLlocU9TRrF5zb+vmvgAXGdAez1KUOWUoPxWkcPqOXP5kXRb6FRFNsofZPUpVdRhdjDfWAcb/2pAUF8zrm1z1FjYOYqS+lnb04FrEg==
Received: from DM6PR03CA0040.namprd03.prod.outlook.com (2603:10b6:5:100::17)
 by DM5PR1201MB0236.namprd12.prod.outlook.com (2603:10b6:4:57::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Tue, 19 Oct
 2021 06:09:28 +0000
Received: from DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:100:cafe::89) by DM6PR03CA0040.outlook.office365.com
 (2603:10b6:5:100::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend
 Transport; Tue, 19 Oct 2021 06:09:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT040.mail.protection.outlook.com (10.13.173.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 06:09:28 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 19 Oct
 2021 06:09:27 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 19 Oct 2021 06:09:27 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.14 000/151] 5.14.14-rc1 review
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <79f10ff60a1a41569f294e4491b30ef8@HQMAIL105.nvidia.com>
Date:   Tue, 19 Oct 2021 06:09:27 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 088936cb-a29c-44dd-992a-08d992c70252
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0236:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB02366C706A26228D5C677C38D9BD9@DM5PR1201MB0236.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 32IvxHfeDq+aXFrv677tJfBdP7De0xb3u/qYCo+oIT12z7RD5eXj5EiSETdO++C88pd5rtoLiNP9WPzyczHMSpaPRS4cscvsKNOltd56Tt350lwHhaww1dHtAlxKelPpBv1pNMmsDHieUcUOftWh9nYvGwHOjXl7AzsOfFL+uKpdP82t4NJtzrHkUtXy+6bgz4u4SaLe2Oh/mT/aVm2LBI+JUFPytBuBH3bSmaYNBS8d+RJxqby3KkHIhcgYXPnjrHJh2A9j+r+/IqZP+lld+qzz7/NQ0HjZKBJ7BB3bXf5SlmwSLWuYlQKe71M9NiTtUFcUu2x96+Y0P4wmJq7ckJ8G4M1kxOOaouMwJ/pyloeMU7QVuk8zl3WpXU/Q4DGadK3VSycu2AbFWY8IYgpoXRsSasx6EekrknjD6G4SYZ8XtSwbOb2sykt8EPgbOtZ3NoVFUJQDGMtMdpzlGO+ZyCxze5Vk+5E6aHyZmGBugYKxSYT3DLSRSSMDm6LAVgkIFtX/AKH1lPm/sjLGUAmBTLpf1+L0qPZVfSN8px1q7mZovtJ/CN75uFpvLrHb5J2U0g485DbwpzsCN8Nw8t4c1hMmLrb2i5LHH/fIygPEuoGt4u6xz8i+oQPFSCc4P2S+Dh4cyNIfIP0E/DL0zgLYiAHZwzyooHDpVCY6PGHdS6uvsRXJF+hgRW04QIszBpGpebrwg/3hDO/5LPQ4a5fDEP1LiLBTb7MB2ZYcMCKR+3hub4Eb5g7BNr7RGfgq5sYlYnRaxsL/QT7t0Y8LhMoNjTwkOOPRIyZ2dUjGOGLCe0o=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(70206006)(316002)(70586007)(36906005)(36860700001)(5660300002)(508600001)(186003)(7416002)(47076005)(24736004)(4326008)(6916009)(108616005)(54906003)(2906002)(26005)(966005)(82310400003)(7636003)(356005)(426003)(336012)(8936002)(8676002)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 06:09:28.3651
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 088936cb-a29c-44dd-992a-08d992c70252
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0236
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 18 Oct 2021 15:22:59 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.14 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Oct 2021 13:23:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.14-rc1.gz
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

Linux version:	5.14.14-rc1-g20eb7f403c90
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
