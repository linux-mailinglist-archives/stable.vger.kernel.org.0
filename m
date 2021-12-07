Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE23C46B786
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 10:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbhLGJkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 04:40:05 -0500
Received: from mail-bn8nam11on2052.outbound.protection.outlook.com ([40.107.236.52]:20843
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229940AbhLGJkD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Dec 2021 04:40:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RqQP35WI7wUEiuE1bBCnODpHD+upLIFYKDXmaKb27w94m6KD3iOZ66f/tTQTJBClPw/0H34JvwscBJAbXygeKUr/TTN+7BYCajsD8PMPNRZlEClDpcO+lKXkLx79EMguf/OJXXoiUEaYDr2eDCvYTeEUxxY1agO1bfxEaJaowZmM9zNrLbcnhg7lE18bmNhkJbRMqc6To4W4sbh9sw8sF6T48wxAmcjf5Xa9U7yP7ZoeDOALCVJZ0rhGjuCdqT2YqUxGMWYqcKwlpVjPZTptQ4rQ7lmnS0RpvEII1RN0KY94Fl3zwW6HaZ3gxDWGQvJF0IqVgriKnyEyzBcygnVRUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TAneTIRMxrd/o9VVqerCYrT8QSVmgR/9qrgvjwIlkEg=;
 b=Cf3BFmtBmKJT8JYsRLV4vYzH5m6kS2sfeyTOpWGNVMUIv+CrNGmVovwtOlHeomJn4AoyC9UufUYDEHRB8Urwy80J/1QlsWKd587zoheddMzteW1EjYa1aTBjYR3U3O5B9JwNV6uF6H1EMlI03NSXdeN8xF5Ykn5qeBEtOhzzQ1kHY42x71x2pQQrXsi/cfs7i0rgXHmJYXaZCW9rs5PuVBUoJe3m8AGzW9QmZy3C7bSHKf8iXVFqht8FOMyJ5OpsGUcWYtMhAU6QGKp9foNhQQm6PAahhS2D6Q2EF0zDd1yOg19Du0zklS51/y6BqR8rYY1PKeSW76dS06QR3y5upQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TAneTIRMxrd/o9VVqerCYrT8QSVmgR/9qrgvjwIlkEg=;
 b=Gtrx4NKxLStdgvCiZ+z3NwhvYdN+jJSw/3fTHndrtPEo7IyJtJKiW4zEdVyD/75RBxHZt4cB0LRZpbRF7FQHmm6/OqVvJ9VVeEBSQDck1siPT0ki1hECTq7EnAyfKuujswPlb2G+//99d13NxLvQNhOJP9EWSaaqkyEWSH/XPUYX6Km3GdlP8cpyyaKockxxm6A8Ak51BBJRW/RnM7oJPKGd9GC15KbJiy9WRNCUoO9la8VrOETJDob5a38TXq47q1Zo9LgcnDb+XNVBHTLk86OW2ughfqnzVANZki9N7oQ+ci4AFdkV9EfK59UfwhXJ8HfckN3nX1K07fI4Goj0hQ==
Received: from BN9PR03CA0687.namprd03.prod.outlook.com (2603:10b6:408:10e::32)
 by DM6PR12MB4862.namprd12.prod.outlook.com (2603:10b6:5:1b7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Tue, 7 Dec
 2021 09:36:31 +0000
Received: from BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10e:cafe::3f) by BN9PR03CA0687.outlook.office365.com
 (2603:10b6:408:10e::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20 via Frontend
 Transport; Tue, 7 Dec 2021 09:36:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT052.mail.protection.outlook.com (10.13.177.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Tue, 7 Dec 2021 09:36:31 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 7 Dec
 2021 01:36:30 -0800
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 7 Dec 2021 01:36:30 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/48] 4.19.220-rc1 review
In-Reply-To: <20211206145548.859182340@linuxfoundation.org>
References: <20211206145548.859182340@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <f5c3adb63c5c4374af7fb14b2bbb8423@HQMAIL109.nvidia.com>
Date:   Tue, 7 Dec 2021 01:36:30 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed7f0534-ea7e-4f24-0434-08d9b9650d58
X-MS-TrafficTypeDiagnostic: DM6PR12MB4862:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB48629FD4146CB4EA48DCC882D96E9@DM6PR12MB4862.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mwo1U4i5tuga0YuxO/SdoUp5dPjC/h3ZY7/RQdS5oa32LtK3WLhLnpT0BUEKU9pxmnWxsqJz9RA7WWj5LGvk5XdbubxccR80EK0PrnKGBAasjtbFFR1XEIXGvl3oJMj4ZrkdZUL5H63LpmPzRbIfe9ptOlZs9o0OB+1JjI5rq6vqwEDLk2wlrWCEVQWcyVcMxWfppRJCkJ+3s8tLbGpdrVf80c/sR26SUI7N+u+btJcHRd5uIh9vMg72q2Cj/r+vdJPmHngQxbiflGYoCzcDz4tUmdxa2sTpXDseh5162hPX5PiV4q74tEcism5przR+VIjQMBZBAN5+8m66zjxP9o1g+BKLMDJmda49h0KRDE6l90Xl2RRABKbvX+Tmi3MTT+IEn90TUPP4lxZ0KLjTCKDHkAVNUfMW+HzBAQr+oZR20hU67Kks1hCta4NiPit5jJK+wScMYWnnIHhNi7Z3h0PpSgFKsymKF7lUdXYm2D46wwJq+1d++N5PSwjDFemF8X5jEqiIXnARkMKl1ndwb6+b3i9hVBdT2DRYWjNl0sdYBKYar8t6a5uG+I1k8GHKNpR9Siwh4mFDLVCGG3gKpgoZ9uERBqnRNzUdBY0UU6YYfwRlLvVxuh2/zMUnfkjsQca6OnGxhLUwhb8J9X09HOt/05n1BR38ZsW93ua5lWt+HJrAAjebA5MHMBYm/A5sFZRXwPoXGrijP5mRhdd4uXSjQconPsSN4cUlmtG4c1AF4ygfPWLi+hJhiREnK1g7WZn9prOrkCxzRjRjG5iZbaCduQ/79x/0kx6bu2YeARv9ZFcSKQrTWG/aWqr8tbUUbiGnmncAZC3yKxbu7cvE/KOXMILyCOkILMO3Z8c763ux56/Pn/Ghxd5eIc64Hnjf
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(426003)(186003)(108616005)(5660300002)(336012)(356005)(7416002)(6916009)(7636003)(82310400004)(24736004)(40460700001)(4326008)(8676002)(36860700001)(26005)(34070700002)(54906003)(316002)(70206006)(70586007)(47076005)(508600001)(86362001)(966005)(2906002)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 09:36:31.4780
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed7f0534-ea7e-4f24-0434-08d9b9650d58
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4862
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 06 Dec 2021 15:56:17 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.220 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.220-rc1.gz
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

Linux version:	4.19.220-rc1-g36bf297d8737
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
