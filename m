Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDFE41ADB8
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 13:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240054AbhI1LVg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 07:21:36 -0400
Received: from mail-bn1nam07on2049.outbound.protection.outlook.com ([40.107.212.49]:15526
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239068AbhI1LVf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 07:21:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f4j1ry6vi/59XCWNShmrHv/RROlt2bkIRTg8S9BedJmTdJ5WBfwaRs9N/gOpXRUymDAXsthIkOurmDd7uOybWctrfDVAkEBVr7GcnSEyzXA7EmGGrXpUbLxHsIyac6KSzOSt2dvaCPPqJREsVoaaaKcC17g1HYBBMErzfO84Z4rLQxbb1ch+Zkisxf7jm3UuFmr+0H2md8DOjc9H6UnXWDo9a6+idZGDiGOrJlpZOwIV2QVTKwT4hxjts0EyghreQ5iidWNvRsWel4FPnIckgnNaZUeoOb8K8tz6aolE329kG0cTOsBydEFS0yIsUSdIG/fU+kQGSGa5uWhsNSeEiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=wSvmJRH1YgsRuYIhOOmsd7u3NU+NM4JLjB4QJL8sq+g=;
 b=iZrB2yV7k/EX6o6pyUqNMVPt4nubT6H/2amsOOJya2SrTyaUnIZ/BbyP5SGk9lOt+eBlvuqZforu0d0EtuMSbLFZwwGTmlWhglvngMVX9/486XG+XJf22maMRHkbLUWe7YpzmQk6g/AhDMgUo0Zqx5KWeSqNZx1ftkOYLBPqyyjjmLE1gCW4HYiRdq/lnW/gUmr4NvXHzi5Jw7YACfbSONI/wj3CzTc63QFt7kgiSvmAHz3Jo/3Qq40Cu6XeGOFV5OWIWbN6x2UC6ATA/HfIBU/Prqa5dwyMsDwa7F+Cdy3/b/4IxbBojufzfdtkYiY1+RJOuuA4ONtTHsNPSQYgHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wSvmJRH1YgsRuYIhOOmsd7u3NU+NM4JLjB4QJL8sq+g=;
 b=edx6uj6b6C2QcFSIoPSkEshl9QbogCC0bjNhmHdmQy8P7wcstgw17QqF4KpNxMvJ0kZqqJIheYxWD5sVDx/vudD4q/FHhwGEhhQXQpg4/eeldSiQUzd+53xUPorFAIcK4+HIgFGIw6kSRGTasTJUj8I1pDM4KyNv6FwcYUTyUK5PvWzHsHZhwXIhMj8DRvrOCfcO0+94w+CDs4fy/k9EAR/cigSSULOcXmuuyeE+VQXSBO3oaC+zBPHttW/Bo01eoXxwaaCLKimGsXDBfOkt6S3eV9UV/m1h+CKQOMNhO95InoCq4VS0/ig6xjTpT0wWU7Gev8X7ikYyzb2xUaAP8g==
Received: from MWHPR18CA0038.namprd18.prod.outlook.com (2603:10b6:320:31::24)
 by MN2PR12MB4224.namprd12.prod.outlook.com (2603:10b6:208:1dd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Tue, 28 Sep
 2021 11:19:54 +0000
Received: from CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:320:31:cafe::92) by MWHPR18CA0038.outlook.office365.com
 (2603:10b6:320:31::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend
 Transport; Tue, 28 Sep 2021 11:19:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT042.mail.protection.outlook.com (10.13.174.250) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Tue, 28 Sep 2021 11:19:51 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 28 Sep
 2021 11:19:50 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 28 Sep 2021 11:19:50 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/102] 5.10.70-rc2 review
In-Reply-To: <20210928071741.331837387@linuxfoundation.org>
References: <20210928071741.331837387@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <b526da7db13042518bce4a35bcea4bd4@HQMAIL105.nvidia.com>
Date:   Tue, 28 Sep 2021 11:19:50 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c336a59-b668-49f0-3122-08d98271e551
X-MS-TrafficTypeDiagnostic: MN2PR12MB4224:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4224AEBFD0A0C8810D413F59D9A89@MN2PR12MB4224.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oMkwnShsje69RVoe6wF0XCKeYBSs7SXfPZg6HUh0e3OmgecasFqwG52pYBSdGD9sNKNt9r5IOc3DnP13hzHunqxKSSGSvsgPnJU6jkmBjwyO/uSAwwKxTVPx84NuTl2Nvab64tOnA0mGhKQemNzMmzw0LNFjqtE0eW9k/0Q2ag46i6zAegmncNmy4WqX5MZMRKUsCRU2R/bikAwYRTmrSEYeLzLSxqW+jpY5yMchRqmpyp5UU7dbhJspE+EZYMa/+tuilNSeMIdyiXcyKO3X4iba91CMvN7nM8nUwN4ZbyPDuGEqGUfQON40iJKjAbWFjlU62ka8pxheSI7gIDDypCoMaUPogKrnpGvhg0pl5mVdN8NrtqzmriEaPhEEjYPLjCU7p2TFP5DBMScJlKOFA39YymoyLNLsJSxMbfdttxlmNmPc13rmK7xrEvxYRJDuIG23rqYsb9hy1kU7AVbGBlB0M2K+klGcJwh6a/eZ4yIg6XjaJopauvt7AlJmL7dGzK36wvOva3MP93AxgBFFieoTAgzZgpmLo7xIvLNgLDlnnRE+zXq53f2gTare2ALViGN+FHJ41dSBhiO72p9UN/56+PxWZQSXzTeH7NpmXteUKD517pl2sr/3A2WIX1nHWZfrZFCDk9FJLHDOIauC3YK/BqePY4Fw7U9QPu4XXGz93MYBlYCGfk8XGBtcaMaNM4RGHZkO30hQ27DsG8x0E0+Bv0WMrHla4U4uivV2tUwgqYwx66f8RPX6LS2IurL3t+tA7RbnP6abdUVgxnSODSZK9EN0o+AjAd20grmIFqk=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(7416002)(966005)(356005)(4326008)(336012)(82310400003)(2906002)(508600001)(70586007)(36860700001)(8936002)(6916009)(186003)(108616005)(24736004)(5660300002)(7636003)(47076005)(426003)(26005)(70206006)(316002)(54906003)(8676002)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 11:19:51.8756
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c336a59-b668-49f0-3122-08d98271e551
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4224
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 28 Sep 2021 09:18:56 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.70 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Sep 2021 07:17:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.70-rc2.gz
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

Linux version:	5.10.70-rc2-g9583b61453b7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
