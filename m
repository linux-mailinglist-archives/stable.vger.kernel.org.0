Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC4133C384
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 18:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235402AbhCORHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 13:07:55 -0400
Received: from mail-bn7nam10on2074.outbound.protection.outlook.com ([40.107.92.74]:15777
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235193AbhCORHU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 13:07:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AVxs0AQOmzmj33+lkhIdzyFvc6oB2OwvTbVKYgB86XIjasMcdfgG+/FE8EspYdNIHLJv4C4FnHwwWblgQSjAqrGoYjQRncu9lOPDC3A0v+d9yK2USqN6a0evwtiMWO9Tg3a/vLOkdnLYEqdnXc7I2axFBFHIRFSFsOqD16EqK7aGrpJ8bBTbXiky4JAIQYzdB4e7jTzY8IuygLssswaKSyXbFi2yZPvfyY+kwjRQ5X39o8g8+AFI2PdvwL6HTFw5KG9pcX8ciOniBZ+3/S3HPnn51n3Z5AYVJ85F3mRHEotgosVa/NKywXiHK8KPNYiGOdMIWUEPRYCaOGLs6CYyoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6/bVHtAGen7sIUazS2tlhPv9vTg9PlPXZdvdaVJZqY4=;
 b=ldE4mjvJcSf1JQ7Qsc5soxWBlt2KU/GfCdutMAO2I6Is1FxGaQNuimXv1ICZ9mVv5GOx2GEnqzTbmEncJHrGOp9JgZ/XXMoe5GReRmpp5jZ8gZz1jrJPcRe+uWoJqRvexulDjkq7f9cjDctM/Lx9gy6oMNnuZPMxITDO0/ORYx7HKVCRxE/akSW86Ew98RSJrCOCErlzuCi7ZAlpVuCZgSJpDZeFFjX7ISPDHAMt7bk2rvLdbF0sJrnVG40NlL25Ae9LVcyffjtoUlh2fAzrExSXUJejraCVEohY70pNuWOZ1uvsxp90JxAKw6N4wGIW1S8Awso45yhtyGJCnX13hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6/bVHtAGen7sIUazS2tlhPv9vTg9PlPXZdvdaVJZqY4=;
 b=E2GdKFcZaraklZbRlBHhQRFjbmSkEojWON+8C/foUQs2KYD3C7oWP3D20zaUiAioNElHFy8EjfH2NILdf7z2iwA59RGGHZKKu8kkstGNnfrenmqYywU9RBLKxA2JiDfu4WZWfJrLyna/T1yRPict1M8Gydt91W/ZWTK0RMRTlEO0oeeHJaSIOpi7t5aKX5oNfw1xIbUyGMJ+9r8+DouSz5H3w54uYhxRQkkvw3Ed9boho6DCv1rAul5AYBLl9/6RfxFSoN+JEnULFkjLdHqVmYDTlc0i6aZivowX/31acFTmra8bg2dYqU0RBBzhMpURRJjAOlKaymoeVIbRIEF4qQ==
Received: from BN6PR17CA0057.namprd17.prod.outlook.com (2603:10b6:405:75::46)
 by DM6PR12MB3387.namprd12.prod.outlook.com (2603:10b6:5:3a::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Mon, 15 Mar
 2021 17:07:16 +0000
Received: from BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::bf) by BN6PR17CA0057.outlook.office365.com
 (2603:10b6:405:75::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend
 Transport; Mon, 15 Mar 2021 17:07:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT010.mail.protection.outlook.com (10.13.177.53) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 17:07:15 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Mar
 2021 17:07:13 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Mar
 2021 17:07:13 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 15 Mar 2021 17:07:13 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.11 000/306] 5.11.7-rc1 review
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <caaa937ced764f99aa3e6da7988d5703@HQMAIL105.nvidia.com>
Date:   Mon, 15 Mar 2021 17:07:13 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5be7dc0-515d-47e7-d1c6-08d8e7d4c8ae
X-MS-TrafficTypeDiagnostic: DM6PR12MB3387:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3387DFD306CE3FC7F279BB19D96C9@DM6PR12MB3387.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SeH0nrwp/fFJWLDEO/5AFmRy7mt6MdeA1Mq8jHJtgATDjobJHpSKTmOuEyZlEjE0MOxpBrnla/g2MLmvuDdEzv85KEdbiu8dWO4lAd7/5JdbQNZCbAsv67+4fb5h/6mFsflNAXzcUSH0/Tfe3ueMWlIW/FcQ+wcC7AWyyYdkmdawuajFu6rv81qHH0uLS8vJIQ/gUAYGo0KCGYGTpAG3Peg2XtqqWPFxiX/zGKpE88QYtz1AB0cBdCH/jhu7GIYJMWI3vjxWlxZweA7YiTjDkfBMt6+PEbFtVz/731DppoKVQrw2k2J1LNCakFXn4A9TwgZKmjJ4BaUd51VBcU7ct+nKOHXMeWY7iqCAolKXgX3XAdrODDguqHn6Yc7JmwPlIK3FvAlxd2yQtbyTfAFQrCl8ld8VwkYtQ/SjMNwzRcMCTybUKEMBf2wnQlbxSvRbmxiXW0k5y1cXQn3fUDrOaHY/naR1DPzzCPjeEVhqXDn7C7fC1ZFARZoBV3FlenZL4p1bbEvG3tOR0uIWULL0UI0iGIGPUfMQaPK5Ynrqh7kVZzhd67S6JOGsJYp/EmaFg6R2HMd28YDfXYwpqXqqU2wH75YujEcnDdnU8keTMbWDYLn2nrwKhGCb0BkWCbx/kswWLWcdBRrHQFQ7on+HeCMOORjylsJ8PiuZFYV4TYxtkhwiSuGgZcMut3zNxLvzlDUHcoKfMsi+9v/+OqJPq13ydmePtYIX2bXsbftU1HqNIvzCpyyQlkSX3y0vMVRno07tFlkoTf2tBYXuDeXwGQ==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(39860400002)(376002)(36840700001)(46966006)(24736004)(7416002)(6916009)(86362001)(2906002)(36906005)(5660300002)(36860700001)(47076005)(356005)(478600001)(966005)(70206006)(4326008)(336012)(426003)(8936002)(70586007)(7636003)(82310400003)(26005)(316002)(8676002)(82740400003)(54906003)(108616005)(34020700004)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 17:07:15.7379
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a5be7dc0-515d-47e7-d1c6-08d8e7d4c8ae
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3387
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Mar 2021 14:51:03 +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 5.11.7 release.
> There are 306 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Mar 2021 13:54:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.11:
    12 builds:	12 pass, 0 fail
    28 boots:	28 pass, 0 fail
    65 tests:	65 pass, 0 fail

Linux version:	5.11.7-rc1-gb87703cf6c9b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
