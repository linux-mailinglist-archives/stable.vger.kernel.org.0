Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E718F42E150
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 20:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbhJNSeY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 14:34:24 -0400
Received: from mail-bn8nam11on2059.outbound.protection.outlook.com ([40.107.236.59]:24737
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230499AbhJNSeX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 14:34:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CXFxyzi570C4um6J1Pqth/iRVk2cZsyC1mZAirUmEINRl+pUHFoG+5U2p/t7HLNR1/iDWhB7yOdYUHENJMe3H5nAoVngNOMy7/1Dpazzf44pQpFb+Mzv+Ob6Qy1Exej9LLH070V7Fbnahx1evQV6tyhh3B5+18KKKlRMjX0a/rFir0k5nPjiFfG1layhkuIpWOiVM4tm49p3NfAk/vDODoafnFi/yon1OXFFobLANQmm8Hk+NB11R4bs9mqVM0TtWBOD7RJvaqoSI4BceMGo28+Nhv5rWQ3t185cKPXgtgoOObSkLOfQud0kpVznTWddsiM0pcqz1ClDNcIoE6/V7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CROHhCC+zMUr59zbUJBGDwrsjbqkULip4+jb0/v5wjc=;
 b=h+J7t1Qq8XopIzn8KedAmM1pK1za9gdU/of46TeIwRyyJ49S/+bSTyEs/ntY8MvNz/Be1aPMkeXjmsFetNlkk8Fjnb9mojAPyegGrdISQMMSAVKGhw0tcBCAKnsiAd+UJb8sZXTmQ0jduOj2E3TYkDWn61XsHibXGdQO2ZI7IHYTe++vVP7Ihf1dEcP/qj64c1EEo5Gj3IQQE06humk0wF+o7hdP8hSru6tlav/09EJsQHM63xPZRZgC6losTnRXireYZaGrV69IAYu9l/PPWpz6IwVQnLRATwTOLgxF+foja175b+ejT5o9n2nM2AL0lx0y/I/RVSw7ek/o+i3/8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CROHhCC+zMUr59zbUJBGDwrsjbqkULip4+jb0/v5wjc=;
 b=OHYbS4hUlhQ85VvAbE4ayFPOp7wd5WWBwVTBPh7jQCAAXwGc3IPyGKhZpJ34qIGl6ftJG7q1Aordw9jfky0xwpjKqbK5Kc89Vm47InzqHkZY1jKmokywncvgV19r4ZDsFANrgp/iEbsSRcwG9AjYR5tr+cWl8oRLL6LutpUy+niI6x/UY9NNjC2GLwNG1+5hvXGK+w+3j1wjI8TlOv+u9n1SHwLHp98SmoxWEHrkfXVjIYNVlSC+BasWqlmU4SHgvysUhkM1EcZeS69Fj2KCv8+hGxlu5XdW3mVZzIKvxnjuBqA2vKyTeB5PE49dZF0iwzUMgquFGgQ/djtRihI8uQ==
Received: from BN9PR03CA0236.namprd03.prod.outlook.com (2603:10b6:408:f8::31)
 by SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Thu, 14 Oct
 2021 18:32:16 +0000
Received: from BN8NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f8:cafe::18) by BN9PR03CA0236.outlook.office365.com
 (2603:10b6:408:f8::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend
 Transport; Thu, 14 Oct 2021 18:32:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT003.mail.protection.outlook.com (10.13.177.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Thu, 14 Oct 2021 18:32:15 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 14 Oct
 2021 18:32:14 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Thu, 14 Oct 2021 18:32:14 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/18] 4.4.289-rc1 review
In-Reply-To: <20211014145206.330102860@linuxfoundation.org>
References: <20211014145206.330102860@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <12a499826db14f278e1257f368dade2f@HQMAIL111.nvidia.com>
Date:   Thu, 14 Oct 2021 18:32:14 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9605aa7-fe26-4b98-107d-08d98f40f276
X-MS-TrafficTypeDiagnostic: SN6PR12MB2718:
X-Microsoft-Antispam-PRVS: <SN6PR12MB2718B9F3FE6FD2B7E5434B75D9B89@SN6PR12MB2718.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mcP+jg0jnwGcRFJb/NULzZZDbiIRvOzOyLhz9AMonKj8HbR7FiUm2q6jUMp2jjHrwLWBy7yhGyo1tCrZRGRsG/C//T9JdC4SSahLKQUx3h2ffBIIbugrp5FLbLcHl5EKGG486qY3ctyXrz7DfpQlnu+gSJ2L3eJisn7ULnlpPWi8qxYUADQzWZTAB660w2zFdrysbWgQbs/H2vWtqD43R29WdQ7xrcEkJPoyJ99CnlfjFRWNOpODyAySKhrnfi5NtmsLjaB6XxOXdQG4AiI6pEnhhOvf2SaC3P3Dblqco9QF4cNSLyKWuvaOARrVJA1u44VPvTwn1IZJG9jca8F6VYXraCwKDTmrVV5Rz4HfeT4tnwO2+FeLWTGAxXqKbx59zFFQ0goyKBmr/oW0Zd4fxxoNxF3/MuIPYkPYB8rHnEAMxEx1q2+ngJaLt5Ig/F/RXUKPr+VrlfVzeVzXNF+v+eKTW/A56J9H/yn+q3QXNm817jqdNzjg3LfcLCEPOoqzwqseoIhwfywEFEXcvjSS5JzfpDtzrtT+0wTVpqaLPg0GZC2gIUKuc/ZyaK4foVvG8BRoQok/U7Br3s81ZhQuUqeXsseJqVR5Sj3psY/a0HW2hNKYeYRM/n9GMGlQpp1g5puq+L7ueFF/1c6PmBDXDeCZuYrUmEn7kiJ3ntJosKaDaPK1RhrjSa6BM0YV9qWOFsDfa8PLDh+7t5XGHVpKwEM56kX/TkDDMaGMoHpc6BRxrJmfM+g1Fsc/28LC5O+gjvd2XNcN5FLif4pnEJ9ruYpWVxvbL/kAhxWYuwJDVmA=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(70586007)(86362001)(82310400003)(36860700001)(508600001)(336012)(356005)(47076005)(70206006)(966005)(7416002)(7636003)(54906003)(316002)(426003)(8676002)(26005)(6916009)(108616005)(8936002)(2906002)(186003)(4326008)(24736004)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 18:32:15.6369
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9605aa7-fe26-4b98-107d-08d98f40f276
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2718
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 14 Oct 2021 16:53:32 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.289 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.289-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.4.289-rc1-gf9c6c370e0b0
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
