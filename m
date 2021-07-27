Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6029E3D7708
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 15:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbhG0No7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 09:44:59 -0400
Received: from mail-dm6nam11on2073.outbound.protection.outlook.com ([40.107.223.73]:40801
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232123AbhG0No7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 09:44:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J6cX1ffzKy1oQZcGkM1oV2am5P3kVWr/ChO/pF4P6oZJCdlP9bywopgxlAmkX1OKvbV1jT+/jq8QO27hnTOZnqnHloYyPiBvTyDWxHSYAJGkEcppceCgMsV1ZHp7YhW6eOwwEdc0M5feQrSmqRsA7pG4sk6WjmnxbLoKZUV1X9MmLSslFkwgJOZXckAl9oFXZTHIb2h1P3JjVtnLeifGDfroP0KKednTgZYCS6Qctf5CsFjyGYxu3xd3RX8aWtQ009mzK9ox/LXf+KForsJ+Okt9oeAX7X/c+mH/Zf+kEps/viAPACgIwIXHMOzZEw8kEgSeAtCf7ReNbAgKAIpfuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kzDt8DDQXB1iokpNneg9M0sq9ezSGcTPcUTFFJ1eQW4=;
 b=Y78WRo1Zle1sUbeJcZ0LSoIgNH3PZhLkxFPI9uGEPjDcjfgL8re6gs4bPoQcUTfT8pK4aeQEpZ5u961hzOHdzbHjoiKPrBcZnLEwxYrQD9/fbOkdTiZmfk7aycJpl/mCgL5QSKo3uLa2uR4FR1m7dWvFBk2iOSRvFjuzy79Itd80O4Nyz8e/hN+GqILBakj0qeUbFR9NraDruE2k1lAbyFFFqcyS21+ph24iGtJpSnbIo9bNRWIPV+iZYq1BxLYl9bQ1HW0gPajgyETFlzCS0HeosvwLx9eD+O0svoK+HEHnvSPe//CbCI435gAPHWxhISV5XBoY5968KEpcKeblxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kzDt8DDQXB1iokpNneg9M0sq9ezSGcTPcUTFFJ1eQW4=;
 b=PwqEut7WaZkhGrbnvSunjRhBzQnBvll/567+WZq5mC8aGUWT++jqaqZVejIJnoYRiVc9Xuy/Eh0/6hkIJVKMVAxPRTqlxB8EwzaJrGPisn5VOiNsTQBri4vJ0/HCXFMnoRiQFSB3efh04Sdw6MZMfG2tJxB7zUWDWTkO8OjgX0AUcnQkIDQdKSytTOzWCBUb1BZ3KTsTRKEtmzru+Aww0kJSdfYsB5wJjF5yTWGlRPqzP1m8MRYHnFzlpO22LwBoAHbgcsx64g37TiW6kX8Ev9pIItkNh7ppY70H4Ripw2aqln5tyE2kXxSI0YT+1PVvrIPqiQyhVYfRG0p4ap0NYg==
Received: from BN9P220CA0011.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::16)
 by MN2PR12MB4175.namprd12.prod.outlook.com (2603:10b6:208:1d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Tue, 27 Jul
 2021 13:44:57 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13e:cafe::71) by BN9P220CA0011.outlook.office365.com
 (2603:10b6:408:13e::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend
 Transport; Tue, 27 Jul 2021 13:44:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Tue, 27 Jul 2021 13:44:57 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 27 Jul
 2021 13:44:57 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 27 Jul 2021 13:44:57 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/119] 4.19.199-rc3 review
In-Reply-To: <20210727112108.341674321@linuxfoundation.org>
References: <20210727112108.341674321@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e27a5aa1530c481da7862bc99a158690@HQMAIL101.nvidia.com>
Date:   Tue, 27 Jul 2021 13:44:57 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4aafb9dd-d4ec-4c57-5ed6-08d95104b926
X-MS-TrafficTypeDiagnostic: MN2PR12MB4175:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4175D5FB0A6A65FFDC166305D9E99@MN2PR12MB4175.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +kwp8ZAurMA0tbkIKzE3slwy8XIoabj5O56stbqBY9MWCPFiMdDXyoSQ/lSPJyB7zgPk9kZPIg5Riq4K27c2WoSJJTptQ73gIQs3JAtQ4XgS/B0sYZoyCq+drd8VTmltMuEp/fhGSctoKid70p5vtf1y5p0fW+gpsfe2hK2rEHt8GmkJyoodmebwn12njyMLEEcMkkr0QK2vyZK2KUaKny9DnunzCEvE2FBbbNgfYyxVZtgOMoX028udicgNOTbMOfNZW/X0CLM3bXO6nKgmdilhTm4NHfwh20cUn2rLpguFtunnsKg3NVZQ98e77eD2pmE5dVSvYuQzNhv3/J7JpdwbrgsucwarWgXimitRO9uxCw23TdMU/Y6pxktQjGCkQI0d3SHyvne7hy18NIduqmHhGYZFXZrYymANF45ssGCPuIoi0VcaZ8qpnEod2vq5pTikheoJyLmdrgInxLBFF1HDygNlskY8rqNEbwO1L/oHGSsBbhJKGOI9A/LkWo7ZAhxZglzkDAVsdvIIgEPCFqybSkINvwguqjJEtgtIECMqQ9szBDY/X4xgX4yNF8d8lC0OFqFuGVjEWhZZkjvVG1CNDIyxzODKJZrmlbTXlEroQdRJWxlXqo70R+bORvMGUVwIDESzuJFKXV6Xh5XRuLkMIqBXsYURuvZlffrLWWuq5fCkwd5+7wtGnLYewlNagtIzQf9qOy5Tjvr2kcPxVGvuEly4mT8dww5sdcDxOXwvmYWM7qK+hqf2kqQA/kWKStGvh9PXVIzRyoys2VhWGyxq0MVv1s2AspKDgHLtKLo=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(39860400002)(376002)(36840700001)(46966006)(47076005)(82310400003)(7636003)(6916009)(86362001)(8936002)(2906002)(36860700001)(82740400003)(186003)(24736004)(108616005)(4326008)(26005)(356005)(36906005)(54906003)(8676002)(316002)(70586007)(70206006)(966005)(336012)(478600001)(5660300002)(7416002)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 13:44:57.6085
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4aafb9dd-d4ec-4c57-5ed6-08d95104b926
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4175
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 27 Jul 2021 13:21:48 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.199 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Jul 2021 11:20:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.199-rc3.gz
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

Linux version:	4.19.199-rc3-gb72fc3c0016d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
