Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBDE413411
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 15:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbhIUN3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 09:29:35 -0400
Received: from mail-bn8nam11on2044.outbound.protection.outlook.com ([40.107.236.44]:60801
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231247AbhIUN3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Sep 2021 09:29:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y+Jj/P46HAu8CFwXM964keE6H+bzMhzn+veSRCsPgURmeEpM8lw05Me9rPwoCcxm1AzHLQAr8cjv9eS9vi4y0UDV/dTenexHWZC5Ej2B5WQP+p27b4R4AVi+wuUn+oWBdQWE/+z6a5EmSIpvxVbuJDbloPJ3yAP9mwc82pG7zzyw9t3JJwJBe9ifZMpzNNU/OiPLX2PpXY6JGPhmEMxXdq9wri0QoFcN2SC0EirLqTAcETRwvtKff4i+zIhOtIIN8mEve1V1NrDoGSd+0KPBdswhpW304l9GgMQCCoNUVH3yBJKQpFUpkoNdzP+LAa991maQlUGxGtY/s+HOoAjxNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=8RZOGUTaADKPNmAUKLjQQ1PpDnIXC5ar5khydy+KNjg=;
 b=AlEbGWqFRqxdfvEaE2/ePBE3cAEIFp/3CPLNeiqVyLOe1ncjXoHEnzqjBc8shKmXk3aQHaJJbhutm8JaPT2ndY7eVv1B5YnIdQlbsuW+umEJ5aNF7k6U/faYhInVIBZ1DOxea7oufiIwBoVYnPk5eHjE2YQKXnnjSg/13i8Rm4qI+gh1Pv2cs+lhbPH+9j7XAcC5naiUQobr21Oq7KtU3nDLgP1M2WieB7Fd8pjNByfVXhPvP0aZ90dzc7JGFf8H1mD/LssKsXiHMRLXxqA2LpIW+La6NYgx9XOOSESuReczbWwDzdWaDr1jGB6OGMzoMWlUUHlMZDYJ+kB9bM+sJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8RZOGUTaADKPNmAUKLjQQ1PpDnIXC5ar5khydy+KNjg=;
 b=YG0gJOgoIjSlFZdo0llyykyUwdzajCaBPfnF0sAg5ze/KwTscVN+LApEOgEWMvC10muVYnKUuWy87uMk/xJemtUSMMr+N1mryr4x5OPrpEQxoBXE5s2P++pOz8ms+WZJ68abUndztmL6PxUzE4XMe8BsJg7eO0igXrh3hvBm4oY/UTpadXLEhIjxkAI4S3YSS4f800P2bbCy7+OwdZLB/cIvLE+rSxnn5SikhnFyJ7+2pXrglAiSafQGDme0x2dV3tz/ELCl/b0fn3yNdxNoDP4KPO0ovq38sNUEk+QIg1zWGBZSWK3D92COzLFMmQ+8oGaeEbk5alC+17yRTvn1Dg==
Received: from BN7PR02CA0027.namprd02.prod.outlook.com (2603:10b6:408:20::40)
 by BL1PR12MB5224.namprd12.prod.outlook.com (2603:10b6:208:319::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Tue, 21 Sep
 2021 13:28:05 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::ff) by BN7PR02CA0027.outlook.office365.com
 (2603:10b6:408:20::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend
 Transport; Tue, 21 Sep 2021 13:28:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4523.14 via Frontend Transport; Tue, 21 Sep 2021 13:28:05 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 21 Sep
 2021 06:28:04 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 21 Sep 2021 13:28:04 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 000/217] 4.14.247-rc1 review
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <473cdf60cbc44c4b846d84384255a322@HQMAIL105.nvidia.com>
Date:   Tue, 21 Sep 2021 13:28:04 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3a78edd-da6b-481e-7c78-08d97d03a4e7
X-MS-TrafficTypeDiagnostic: BL1PR12MB5224:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5224B0A4D9975171807421BBD9A19@BL1PR12MB5224.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uI7ijU+Wp1eVhrLtTAOA6bK6IjwIGbHX8sZAjfWlhIBmFd+Ki1UfNgKHXkXWokaDK/7WbNc3gNCp5OnUI9PtuBTB5ZBxze9snsr4e3zwuGLTRiKm8Wq0OYlNeFekXvnhVAjUQRDt2Kh7lSJ96CBPsbn9PuTH0QFG9qAnza247lqcf7nwvPhOSl/KwIBhv8W/MJnWW6U28t/cfDRh9ELq4DmTzFr/CKAyMnm0832jjFv37yULDmMY4Yqci+535fLlu/m8jCrmVT4aTkCEp0sdi3C2S7Itt50Kisz4dxKoxF/Nic+q7W3ZDCFkBkFJDKqSmAQi/IAjH1//2K6FZpMFvRR3vISPES2XZq1VNdsfkO5n7kaHgdF2+RHfhm7TaoFA8q7/0pDqIulq+u7MOLZoYkaHcHFmMd//RhV6eI4nfGOzx2QwjYsofZE55QCnYx2RLllsxWkwTuswMFPdfn1K6GBYGXOvssnfD/8uheLRaOvKIFWUb351zpe6OxlFcdOkmRoYM2pxnloIngvfOh91VGO7dJ5l4+zqZwRKhJw9ds3kQiZZ4vrKINPvUmGjB0rrX6q70EyzZ6k+0m9EFqmxSVhTM0f9XNckORpDtyA++x2zDAwtHDGkdoTG4o/tVjfyq0uj/UsiXEfSr1qcUz3OPTdB55Hucr9GWt31qsQ8RUCTIw1qBdyNuT+YQvW6l3FQsPvt18nzf+tgCLX6N6S9guZ+nXYD7W7lOOmVHar1LVh6r07vFd3Mrt5A0nkz9BH5Emizjti4VSDivpRdPi/Ym0Sarwf/Ghlp0NtpmKC3t1g=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(426003)(47076005)(336012)(2906002)(316002)(8676002)(7416002)(5660300002)(356005)(26005)(966005)(36860700001)(508600001)(8936002)(6916009)(86362001)(108616005)(24736004)(7636003)(70206006)(54906003)(70586007)(186003)(4326008)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2021 13:28:05.3004
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b3a78edd-da6b-481e-7c78-08d97d03a4e7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5224
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Sep 2021 18:40:21 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.247 release.
> There are 217 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.247-rc1.gz
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

Linux version:	4.14.247-rc1-g7c9c2ff5fef0
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
