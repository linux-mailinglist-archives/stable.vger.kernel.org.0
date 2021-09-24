Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09033417A0A
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 19:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344568AbhIXRwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 13:52:51 -0400
Received: from mail-bn8nam08on2057.outbound.protection.outlook.com ([40.107.100.57]:22889
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344309AbhIXRwu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 13:52:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K9rS6ilPbWFcibAMm31MK7O64GnCxyVtZGgc8RJJLVn7gqFuQdutcXF5beDMnt60rVDsVvYeyE+vWsY8JK/xJM5aQOaIVTH2sgl9XJShY9J7IrS45uUcCsCwqp34CAqWWxPUN5qOEZOSkvX7fua46FLAN24V+ht15sEqs+RQdjodnPORiwjFX4R7KnyPiXKV1JZQWXff9St1bu5RI6LQdAytDou9Rvvi9lPzt2tj5uc0DJkKDwydb9XsU1Sr0P+7BRQHXc7uMTfpy+ZQTOi01U2QVmyAEb02S0S5Pnd6qeDvW8AGEcDniBUAlZgNRpYWF64oIv0ost5pHw65xb0yNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Kmdj/5GlPROBvQiwKtsq8QDcELhG+nKDjxzbYBEVnIA=;
 b=lg59JXsTHwterx2NA0y8ONXIBvQrtnoprKLf94fVdFY2HKDI7DCz2rS4ereHKmd0Du4/BKu5Fv7HZdeTkQfosAjnMJNN2+1eJaMoQxPYYnDEpu0+O4f+ddG3hpRHAKG8OgrKoMOnufqX3LtM8R5F4LrNAbfvlfSEUH09p87WarQMgJ2nlUwdLF3EjGAPsewYOxUonlhf2VaSmqUvfLAO4GWSimIut3dGQT4ULTYmKKwCtssztNRO3xKLKGc6ENtiBcDB9yJgM3DDCG23t05VbsojuIjMaaBG6ZTs1NkD45YzL+7I4SA3anoLYPBTMTyEpU47lye1LCyLvhQ9AKp3RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kmdj/5GlPROBvQiwKtsq8QDcELhG+nKDjxzbYBEVnIA=;
 b=VhjItok59feSftdlGeqlIURDDUq7GWkaF6lzrS/Ha8QRj2g78uV8srW/xMSr/kKGChf0/cYgO8bDqAvEDtiimSI+JHlUjvPp3ZbyJAnQEdm/Cowcv1AGbylU7VdUnL3qee4drbeRGa9y5jjIe/CUS6aJphRrMYD17uU1PChjVIVAT3TEfYfbEGefqNgifS5P19X3Ol4JAI6pUaJ3WP1dm/gpnz/3rfFTzZe9keuLovne5kR3saAf7Jkhdf/fBPS5MpMEKoRP3cNexFT7yruk2V2Xk6FiKGsyeYaCIgtFtlU3J9EYmNIQhHc1hVBtViXg539AMX3VHmUNaBi9N0koIA==
Received: from BN1PR14CA0023.namprd14.prod.outlook.com (2603:10b6:408:e3::28)
 by BN6PR12MB1730.namprd12.prod.outlook.com (2603:10b6:404:ff::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Fri, 24 Sep
 2021 17:51:16 +0000
Received: from BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e3:cafe::19) by BN1PR14CA0023.outlook.office365.com
 (2603:10b6:408:e3::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15 via Frontend
 Transport; Fri, 24 Sep 2021 17:51:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT065.mail.protection.outlook.com (10.13.177.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Fri, 24 Sep 2021 17:51:15 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 24 Sep
 2021 10:51:15 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Fri, 24 Sep 2021 17:51:15 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/27] 4.14.248-rc1 review
In-Reply-To: <20210924124329.173674820@linuxfoundation.org>
References: <20210924124329.173674820@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <b86e9e38136441b08264759acc9438ad@HQMAIL105.nvidia.com>
Date:   Fri, 24 Sep 2021 17:51:15 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17ee3ea8-abf8-4284-e1ad-08d97f83e810
X-MS-TrafficTypeDiagnostic: BN6PR12MB1730:
X-Microsoft-Antispam-PRVS: <BN6PR12MB173040A5845A60BE0405A420D9A49@BN6PR12MB1730.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sbXnxvOm5mtMdCJqnTG8pbps+wz7ALlhGJXLczAUXmlthHX+EE3YOLVmKplJQJt6s+JXa5jgLzjnL8N/4hlE4htiWRvrkAy4EZnRUggUETAf3ianXuqKDvXAQpCw3N7F21WQVDDDthcMTIsmthcyFrjd0IUQ62fhTd4zH8PZs0fWIuglQwV2I4+5ZtczrXhRmC6+EZLiaq7I/1GuWQu7Jbg/rTD9qTqnFGLFa/Dq/k2QCFRexI1jD4HrP1uMbwSzRj48r9/rjABpQo1z6UE4KIpLkdBS4JCnhYP04spr+hd9c0jL2gUm9UqYyLoBnSA91z1JgyGgI7+bqJ/wbs2OvIoeRQpBomaKiqp1Jlhbm0S1Q6poU9yn5bH6ZAE5FwyZHJFTx5kZi/3qYn5dRsYnsx40h+M8ReS6/eyRUKzd3XvdYw6Xr7ZIW1KlbONZdYKqEOeLn9B3DTRrpEOaqD2QICIomUTs7JCinXMYPPQUwYIFDXMbnAVccCaknLQuMZQdSF8MhwQoB1vdRMKW4yy3HCFGQUc34Lx89fl5msDQdsz8wtpeQMtKOivMsArPZG3BXm6VCdP0NVofzyvaZxPCOQI3c/NReP3/lo9YFG23L7l8EDHtpYuQisb/qFBV6nuQGE3UcQONlUbNPzPopBhoirZL4xAEMvXCZ3POVokl/2rRYpHqsnNkjvHOFvUziid+CrVGpvfiixRoLdBDxUCaTbmQTikq9VxlP5MHdyYQ30P/r/IuVUDo47a6SULM+yy+8kla1nkNSa5zVHL5lpPT17978T/1frAg1kWvY6oIMnI=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(24736004)(108616005)(2906002)(426003)(7416002)(7636003)(5660300002)(186003)(8676002)(356005)(82310400003)(36860700001)(86362001)(508600001)(6916009)(70206006)(54906003)(4326008)(316002)(966005)(26005)(47076005)(336012)(8936002)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2021 17:51:15.8850
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 17ee3ea8-abf8-4284-e1ad-08d97f83e810
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1730
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 24 Sep 2021 14:43:54 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.248 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Sep 2021 12:43:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.248-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.14.248-rc1-g4e502419d5ea
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
