Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E64B8434071
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 23:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbhJSVYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 17:24:34 -0400
Received: from mail-dm6nam12on2054.outbound.protection.outlook.com ([40.107.243.54]:39393
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229491AbhJSVYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Oct 2021 17:24:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WizaZOy8WhoJPRlnlcJvowvHAR4Paj7+ETRvqixCwlGKQ5WLgA3JjSCt4JZCIX6tMFd1+u6kQU3vBDhVLG8QnHtgsTZmLEkKrjuJsXJL5BmEJiXo6I81NLBfqG4vQ+iF0Q9rYwFa3jyvmEsAeLeiLwFL0KxmPQpHciWxx29ivQS32/UWOIT157T+hkdVncJUuDZ2KreHVpGkKaE7dIkClL2vXujhKsG+WSIX95NOcH3SuuItZGBICNQjowy9+KPgoXP84lQ/IsOjLlcZcWmCFRj9Ttu91hAg3NjkU9/oATrjc5yOIeWQJ0FS1UPbFuDkSU6LaWycKeVyYUwE39lAcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZnE8cRdPVfJAxWctRuYh7dEO7twZcwEUI8Ta+n3nUsk=;
 b=MxZVS5G+6IiPGhZwInlhy6QRGFf24DwEdDCjt13TIoUzJd45KrgDeif/JV8FtIotCRVFXXlLCuElxx7lMm//HAXncSDH0WtoTiEd+BIgbp1nD1Om8MCamEAUo21bEkt4BoN7mc9HDv/d0FyZ0XBEa/chVvxwrLkOphh1HYrJioPf1SD2+5bQjwwl8dTX3qlRrSeZHkBn1W9Zpa5csQO/1QiZSRGZARE6LjaQ0W6DT20Q+xkZdcRDFaKWZTPu/DYZi0A3wzuCMMGW4X0w9A9KtJPIpxS9zmtBP2VH6UXMbLr6y7RFYOw+4AqtYoXspnokCipclGiqZG0iwPSJLLuGyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZnE8cRdPVfJAxWctRuYh7dEO7twZcwEUI8Ta+n3nUsk=;
 b=OfTUripNrea4Fo1vQ9kg5N0435OmLPAj111cTKGLnqzv89w91uFSDSwbE36/Z5hEKdk2I9plEfBzb4v5P9pgu0ZWtHXlacaQXoVlxxRh1yRZJ7dSHR55HOp1TGtMuMm0Evr1OsczYKPKIPXJvKzHIxI1MyMKZB6ggRkxEoYkgyFh+7Nv1QjXsrfCUW9vkvau9YWAGCOxvzM3hW/xIeUb5QA1xCfPh9NUmMQ1ncLW0/Zwkk1NSXMYCmo+t4pG5eEoFHJiY0n+vtvfmCQ/hIJu+4xJUGP9m2qbzrKrYGbqwzP3KPtuS+bLDRK3EMs9sy6I9bdGmx2c/8q5E15gIhWeJg==
Received: from DM5PR17CA0068.namprd17.prod.outlook.com (2603:10b6:3:13f::30)
 by BL0PR12MB5012.namprd12.prod.outlook.com (2603:10b6:208:1ca::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Tue, 19 Oct
 2021 21:22:19 +0000
Received: from DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:13f:cafe::ca) by DM5PR17CA0068.outlook.office365.com
 (2603:10b6:3:13f::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15 via Frontend
 Transport; Tue, 19 Oct 2021 21:22:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT017.mail.protection.outlook.com (10.13.172.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 21:22:18 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 19 Oct
 2021 21:22:16 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 19 Oct 2021 21:22:16 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.14 000/151] 5.14.14-rc2 review
In-Reply-To: <20211019061402.629202866@linuxfoundation.org>
References: <20211019061402.629202866@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <93385b91ef5c473fb1090f6768ccb273@HQMAIL111.nvidia.com>
Date:   Tue, 19 Oct 2021 21:22:16 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af64e0cd-abc1-4ad6-da82-08d993468822
X-MS-TrafficTypeDiagnostic: BL0PR12MB5012:
X-Microsoft-Antispam-PRVS: <BL0PR12MB5012CD18D978CFD470D98118D9BD9@BL0PR12MB5012.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cb4rJU4wLiL5s+o90z2LVNM+BkjZevCHYSXJkKiwJOUkqXGJUg7lJGH3AEM+6nq0GCRbgxoqsr/PS/KQSiwnARF+i41oV0rTwNAEjfkCGubBS0aX2YBI3qBFmIqg8R9bPwozend19JUR5Y8K2qciWaQmnfQb2SQc6YtJdQVaXhfn3Xzopn3ahXFX3Quv0Rt//qBN4FJYOJq/DG85ef29sVRBNob77Ogdrh4TBgrAZOgIpA3fP8icf2ds6qUzjF4Y37yvK+plmBD+jTEX0mXNlC1K/Yofi0bHeOqcVqbFDz6yIe1TAyEGQ4tdfPOIzAOVpRYw/h06mYOqkRMsyUlS4dm5rUfX1WgLpL5PwwteXqZSa/nGhbbXdbxzfpOKlSB8dQ/OCj3fwtTlAMpassfykROTRphCqW9eOsrC4zidFm9ozQlCRSJHsTUfW4Ut5Fy7IiybrjV5Ehr4cClbKNCjUOcRVO3VQ5JXPc7KNKn2kW9C/721yUwt1vnyNUcSBDpqnI81NSrup5io5sFyOsQGvJUDb6i2PNEfLoQG5MD5QrSP+IMmdSRWLNYYaf9xCFTkdNICrnlRKFBbWQ376LkEsdF1deISxpix29mJnbhghD5ECbkjTO81mJykdIXxU+aWYtW01YSsev1GJdUIKs8i922kRUTkjIkZ3vsWdaSHti3FUOtkvSDRMx3qqfCGe/4OXOJBh1KO3fc5ATpsbg6qT6jN3o1rmGVLKPs1xo6hYZr6dRImKAWyWnGy47cbJXGo7jdLdScYJzxToomkk34MXS2EuQbgBvQLe1GrPIDjjkY=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(5660300002)(36860700001)(336012)(316002)(356005)(8676002)(86362001)(47076005)(54906003)(82310400003)(36906005)(8936002)(186003)(966005)(70586007)(6916009)(4326008)(508600001)(7416002)(70206006)(426003)(26005)(2906002)(24736004)(7636003)(108616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 21:22:18.6407
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af64e0cd-abc1-4ad6-da82-08d993468822
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5012
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 19 Oct 2021 08:28:35 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.14 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Oct 2021 06:13:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.14-rc2.gz
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

Linux version:	5.14.14-rc2-g6b894d18a514
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
