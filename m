Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838C140F4A0
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 11:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234967AbhIQJUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 05:20:09 -0400
Received: from mail-co1nam11on2065.outbound.protection.outlook.com ([40.107.220.65]:46273
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239263AbhIQJUD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Sep 2021 05:20:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RyC5U6cqj56jXuysixwPjFFqEab1t+u5DjeIgCdAPZ4XT00SBn4eTozb08CcJyzONg608eDMo+lUPCHwropqb4qP8DFwuQSWCUzX0luA78HvAXzlLuUK3aWfaWYC7DTCXHyn0z9wP1/fnr0tPRjb0k+Sl/Vmjgjyz49WG/X1R+EKf2+Tmx3Hzc0zwBVAx6VA1hwzBXVIFcEwRFWXCGm4PC5EPRs52u1bXDHTemmK8zCSHObsBn/Y3582HWWiQYktmLgVTQNqvekTzfMKFIEpwJi6Nc8jolzwwLwIGcul03FG0Bvx3zthpmXVu0Vxo6FGKPsddX9yZWqj30bXbroXNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=6Ya9Hvuamg3SlW14WcZrA8iEfOlkbMm4B0T+8qc+qy4=;
 b=Nhwca4oVwevAZOWa1gJuyQ3t1Oo/9zbOk4A1Kfmsg2elDNhI2gLoiLPqsCW8MRAxv5pCdkIhWrGL5dR3ChaTUbnviAS0FHCQYhkTu8OrPbnc1Yv3aDMV7CuXqoaMGOFQND2uf32aEKW1kvLUAu044GVwMGYAet+zx0Z2tXhqeFtte7aCxwFXvMckOzyAjwo7jK8WWjKlgVuHBOSgjwR6jsHrUfu1DUAmyzJoh+IPEXLyE3aEIF010PFuhgS3gceZ9l4xqyim4EK83tqV/hupxU9c3Tm6DLp9Fh3/QHFuneJ4PHX2ZZHzYgl7i+AuX40HHvZ1UapeMV9sJjfBdbeh5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Ya9Hvuamg3SlW14WcZrA8iEfOlkbMm4B0T+8qc+qy4=;
 b=mfiq4Mcvyu+5SBLFH7N7jnb3q9Cfw9ntTJfMajuwMe3C7MFwj2MXPm/7Nh7rkhvWfachiSXhE4b8UZzmQE81rZIBRPHHf9xio2OHk65PEII2mAM9tlRLqf0bvpybWViPTIOjnYS/bIEFx9fcWKjv11xx/4CpIWsLs7CxqgpNT0oy8G6g1ZkmSH0pQrL5W3K2/JBwGF+7XIZymkIJV3/hephcUpEGKorMwGtup0suCtcuGuwP+iEPSdVs7kXxb42WCC1Mx7N5h9g1usBbPwr8ry8meWqkCv53q0OlQQPIhzt4hLiXsG0Gubnk0ISeZafpN5t9/JorgGQH4KU8+qOvZg==
Received: from MWHPR02CA0023.namprd02.prod.outlook.com (2603:10b6:300:4b::33)
 by CH2PR12MB4182.namprd12.prod.outlook.com (2603:10b6:610:ae::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 17 Sep
 2021 09:18:38 +0000
Received: from CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:4b:cafe::75) by MWHPR02CA0023.outlook.office365.com
 (2603:10b6:300:4b::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend
 Transport; Fri, 17 Sep 2021 09:18:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT040.mail.protection.outlook.com (10.13.174.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4523.14 via Frontend Transport; Fri, 17 Sep 2021 09:18:38 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 17 Sep
 2021 09:18:37 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Fri, 17 Sep 2021 09:18:37 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/306] 5.10.67-rc1 review
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <b97d26613d7a4d7aa82a07b578dba7fb@HQMAIL111.nvidia.com>
Date:   Fri, 17 Sep 2021 09:18:37 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d578e853-e8cf-4dd3-f194-08d979bc221d
X-MS-TrafficTypeDiagnostic: CH2PR12MB4182:
X-Microsoft-Antispam-PRVS: <CH2PR12MB41825A9032976202B31A1222D9DD9@CH2PR12MB4182.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GPKCvoxkdwfQbAba13vtDRSq+giwkow9eun5xSA6G4OlN0oLilaZIPbr7q+uSP2B2S/3xEhDxoQ5S5azjnt2wTQx404Xyx86530ZIchgiN1dprAmLIltzxJSEjsOGBPFym0v1/n4gTYGgWC0RVmCy/87dNUnWI5oJ/9IsvZ0IXgMBhGgMxsUmnR8BmH6ZXg0qbCE5yrK82f7cB3MqCMC3R1pcDlwIk9hLb3x5EKb1lg+yRd/98ENkzH+lBPVdajQpf2178kDM3PFbFGxgErrrLKtoy3prjNeLQnHT/R4Qw+BhZzs8cZqkDsFkjJWCeHbTcQo486mUetFRTgQ1ByE6HKnb774P9vpz07HBfailJkajfvp9mf3YK0Ejf7RQ4U21piAvYLT4RzF97wk6sMcuK9b8VfgMPdUuaYOkesyKPEgChPu290pntU9Aetb7GPuAzjI70n4r/5wSucU0YVvesXDIrbnRy5asPIfMeYpLc3wrp1fkbDkqGZMFzR+w7HzjvWjAogBweGK4jFflQKZyF8fbClOKfG/OHQuDLT5pqiuwFDhH6R1CHwZ2783SJB55p9ceYks5T1owJJ2929wQm9tBMknpExNbeuvnrE1Tq4qrHf/kA93+ZUlfXBmiudygX6Xu0ryPh2jDrdzOOfmpV0+VliolorznB92Nho0Qp3Le+e7uGwetZrDODfNsQrINnRG85+xXC6Yegzln4GI6TfKcmn43OzM5gi/iXZ72q4PfUzO7TtHA8G/vqXL6Zld2idIqOFKgNVDNK02b67M+R2b7oiG12Wdu6CfdxaS7dg=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(39860400002)(376002)(36840700001)(46966006)(70206006)(7416002)(108616005)(70586007)(478600001)(966005)(426003)(82310400003)(336012)(2906002)(8936002)(24736004)(8676002)(54906003)(7636003)(5660300002)(86362001)(26005)(186003)(36906005)(82740400003)(316002)(356005)(6916009)(4326008)(47076005)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 09:18:38.1716
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d578e853-e8cf-4dd3-f194-08d979bc221d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4182
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 16 Sep 2021 17:55:45 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.67 release.
> There are 306 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Sep 2021 15:57:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.67-rc1.gz
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

Linux version:	5.10.67-rc1-g729f504fde25
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
