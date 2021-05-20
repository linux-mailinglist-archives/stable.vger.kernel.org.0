Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D69A38B329
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 17:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbhETP0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 11:26:31 -0400
Received: from mail-bn8nam12on2065.outbound.protection.outlook.com ([40.107.237.65]:47809
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232455AbhETPZ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 11:25:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=emfs/iO7DI3GUNjFHtui84vQMDrUllTDh0eEcQia41z+Boa0G+3WN7Az3LEL1koeyXCzvbMSiw9Dl9ZA47zcAe26HUa7XJqb+hxZ2FI6ql5VBwTOx37LW/pIYgwMDTX1ZS8s1c1sz4kuigG9tw1i801WLKSobNahAYWmOXUvK4SH4Ajq08Zv54oqvi407JHqtiD7S2ozxrEt1iPVVSqKQmh0CXbPI0okm4PQEgwGsNTD2QzONtHcxn1kCu+CSrpJCl/PwuyYt3/+rYw3qUSUPmX+WtlND18lJf2r2RE6HZQ91/Bdrs7vJ+lHiA6kMxMiKHoGEg+wGKu3vVZSqyALwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=abxZxnHkfonHPI4KXY8Ra+DAH0IHMGDBio+LjZ4um+Y=;
 b=TkzAukb+vW4PJRr5KUNLW1BrPOIdUaF1rEzUsn6ic3wjPQSt+nUyPhfokpC5FXXCRlWwv8FF+b2nrKuegY5OTpU2BHEasog4rwnKuBNhbjSE6WVC1ZMpgEuwUTnT6E9Z7vLf86lwj2ZB4VOmqhzHsTsDrbjfFF0X6kp1XdGg3WyI0gn7hDTHCsHmfjPnUiONmlk2fTs/qgoqOAC3J1genzpXZLgmyLTBnWdPFcrYi0k2e3sipxy8NmK1sEW4+iquY2TTlNAkoiJpN6MW7p21djZq0goeCU45xomeHgBrVWNAvQSrJawObjWe+ILA+8q/5vSx9dXQbwGFFIBIev9nAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=abxZxnHkfonHPI4KXY8Ra+DAH0IHMGDBio+LjZ4um+Y=;
 b=U1fbdB+I//0oes1wR+Xr6uAo6l9+RegrOI5M8VV3r6Ba29TDyRIoyUeueNhbSTaKaOdaZsWRuAfmtsP3u8FWgMPZdsgkLN/+qOMz5x3drVv29wDX6gvq9YynZAKnzRN1D+PYTbpa4rdp4jjEHIAmR+blIA0OChGhZTiGNEydt4QT4NmE9DWccdWhZMPAl1PslizB3DXhtvHXMZEdClSx+QLquVrF9ejVbXu4jyrTGlUc+hFIsqPLl8+nQbypD7VH/i2nqRQILjAvz3mxAnHu3xJs4or/7zwdYNcfjYdzz6N1cjGTlNDC3ShVtnfL1oJuSHCKMCEn4oAuomJHUkDlaw==
Received: from MWHPR01CA0035.prod.exchangelabs.com (2603:10b6:300:101::21) by
 BY5PR12MB4241.namprd12.prod.outlook.com (2603:10b6:a03:20c::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.26; Thu, 20 May 2021 15:24:35 +0000
Received: from CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:101:cafe::a9) by MWHPR01CA0035.outlook.office365.com
 (2603:10b6:300:101::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.33 via Frontend
 Transport; Thu, 20 May 2021 15:24:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT028.mail.protection.outlook.com (10.13.175.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Thu, 20 May 2021 15:24:34 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 20 May
 2021 08:24:33 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Thu, 20 May 2021 15:24:34 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 000/190] 4.4.269-rc1 review
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <280fab068c8e494fbea57cc95ce34d93@HQMAIL107.nvidia.com>
Date:   Thu, 20 May 2021 15:24:34 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9cf07272-1455-4467-80de-08d91ba35f9b
X-MS-TrafficTypeDiagnostic: BY5PR12MB4241:
X-Microsoft-Antispam-PRVS: <BY5PR12MB4241BD0C843A9BB8FC31E387D92A9@BY5PR12MB4241.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sJH16T7XzhLnNUtNKx28wDoozcklvg9out/BOeisLCXOGzQK2QUGTEO0m0bm3d+zKjmn934jjRywP6Ftb86EJXdRqlt17VP+3LUhZ8F37K3gEyLlad3b0sVkK1xxnEe9Bq5Dq6oxRosz2NMUjzl3QLI4pUWnv2PeF5YuHQRVJ+KDMnJvTEoB96z/0zEwYshKC4pVyIFL6FU1CTgNPNFFnQpPCj0xtuM8nMc9ijDIiKn/KSDSYWdWlWWC/m2nKY1C/dFXB9o3KFs1jz5zZRdGeuN6E2EyAnGU5AuPzJJWsGQcLoB7lY+XYmd9PaH2ZkdVaZl9/GJMeCvHmtStHrnGd+iMr7hpipzdOWzPkJ7bnX4QrsguLY7ggTLrYNJcVrNx0pH28Fs/uaIsxiBvFeZ1cb4IuRniV7b5ei5MZBH0knScePPAiX1cErVtgBE83BD5k6uBJZ8F4ti2f6LRUzsgLWgY2zf7Ho29ZABYLO5nzel0Ly+8373ksVpi7B6JQYAyiRpJumcLvF0Sty60k22sIvgTM8fTbJWIDRnZ2Nu3rfwSMNi/KcgNy0HgRAdeEo7ioFm/QBteCiY12rHUlbm3XIgk9CmPWEakgNk9FghpDKtm3S8iNXp55dbbcDd6Fd4rpRrufYVmljFCDxWRZENuOeKtBEg/ml4jTOJ8E2EFjlyw7zNhv8UMfxKPddda6tgvhasKRZtq4K98ooDDNG6k0Jbun+Gw2be8o2/5ESjj7wMOMJKT4OGCyje3OSrhHde40iIwOe42xSW594u1FD/Rzw==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(136003)(346002)(36840700001)(46966006)(70586007)(4326008)(356005)(186003)(336012)(7636003)(7416002)(5660300002)(82740400003)(70206006)(426003)(36860700001)(8676002)(478600001)(966005)(47076005)(108616005)(26005)(24736004)(82310400003)(86362001)(2906002)(8936002)(6916009)(54906003)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 15:24:34.6082
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cf07272-1455-4467-80de-08d91ba35f9b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4241
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 20 May 2021 11:21:04 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.269 release.
> There are 190 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 May 2021 09:20:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.269-rc1.gz
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

Linux version:	4.4.269-rc1-g8605df0345a8
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
