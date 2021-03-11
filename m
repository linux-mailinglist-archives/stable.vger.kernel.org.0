Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C36336D6B
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 09:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbhCKIAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 03:00:05 -0500
Received: from mail-eopbgr760082.outbound.protection.outlook.com ([40.107.76.82]:50207
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229830AbhCKH76 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 02:59:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LCWZlBLd7X0F+H4As3ES7N1F6FnNUMMge1xDULf+w48uoesAgFnNBcK2ByCcCS8wZ4kqsUrXup5d23pmEgGM8FJ9xUeXz8s3zd0sgaNsEc6Nl5sNwGoqEOBwoqyMyoAeFXmnjCG9UGpCYlHhXoBG4CzNumdtBVIFf2ob/HPZI0uKwbPhJbsZascURiwkbLhzkwHzOlWexRxBkErJ/rzavnjLiRrqKJB6CYOglug1WeMPSlzlcEr7AVEvqlPsZsZBZ/53aRFDRQO144tSrH9W+bpVXVP5ou/Kqnp9fhshY0lW/f2RH1TAmSozLtdIuJzTL0RSKSMBCuXlT3B+//tnPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DETqY3EZ64kgwC5nwwB74gH99lRwyj/hcGZ5Bk4wKZ8=;
 b=KzYNexhgWk9wjRtVof0d0Mbhjp3b4Ua4xbB96sfmWhYQUTfnQ5n3deHU1n+jVKx2na0U30qgAVmkxFclkA301Le5FWaQlf9yngJy89hCfW/0V2mk3t3yXG6XBClm2bQcF5G5GzJK2iT9yBju4OPy5XJQ9lVKk3Gnllp4c9ep9x/j4+aCll5FCnP30CLuvf9WNqIRdO1CLa6H1RPLAcuuCDm9WmkZDKQGnO/JGcjSJi+euMgIWRa92YHQ4hl4/3Z3NXpnIKyu4q3+vETBZx5b927o6d7VXxcc7sIof6YokQhpvLtZzYNO42uUGiuxuZpdZDYC1NUhhKIjigNm7Hv6Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DETqY3EZ64kgwC5nwwB74gH99lRwyj/hcGZ5Bk4wKZ8=;
 b=ptlRbXEZVXgoTODT92J1mRoWP+9Ayg5yI1kmU7qJSalnRw5rtPMtnoT2wXgKGDvatKnFXtdpUWdBd7iS0Vsleml6Uli8lwkb2DOrYpF+P0abKji+GUww46jxJ+MmBMFEOc8NBpjfr2K+fcNMCH6Ptiwx4YCDMkp4sJ3n3c89hya2zBlANJw5d/T7yWg2OhBLyek21q5ecgTgMd7nQa6MJTEASKaEYVx/VdnwLBcN8YYp3zkNVPIiZWp9yyjy+AU5pghZAeA7/ZBnt+nPy3OUN3mZ/6btqXIEzwld6vI5eiUFrE1ajWNSI1RE2mMnItmww+AqXUMNTLxOBhz4iJ5PVQ==
Received: from BN6PR1401CA0024.namprd14.prod.outlook.com
 (2603:10b6:405:4b::34) by SN6PR12MB4751.namprd12.prod.outlook.com
 (2603:10b6:805:df::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 11 Mar
 2021 07:59:54 +0000
Received: from BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4b:cafe::c5) by BN6PR1401CA0024.outlook.office365.com
 (2603:10b6:405:4b::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Thu, 11 Mar 2021 07:59:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT043.mail.protection.outlook.com (10.13.177.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 07:59:54 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 07:59:53 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 07:59:53 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Mar 2021 07:59:53 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/24] 5.4.105-rc1 review
In-Reply-To: <20210310132320.550932445@linuxfoundation.org>
References: <20210310132320.550932445@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <3adedfff41914c63ab84cdbf02d3ced3@HQMAIL107.nvidia.com>
Date:   Thu, 11 Mar 2021 07:59:53 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09a7f47a-3d6c-42b0-83e6-08d8e463a7e5
X-MS-TrafficTypeDiagnostic: SN6PR12MB4751:
X-Microsoft-Antispam-PRVS: <SN6PR12MB47519624D1E007068526C89CD9909@SN6PR12MB4751.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 81o2KMZjGCd+es6fYH+S7bGBu0avF1ItGHBzZH7Awr1xWAa/RFPrGNitTBcnpiQKZl7ifkroZzyaNQ5CVlNTk+RLKR4iW4gLGjooIw/XMY01WDr1OLHSoffllhMq37p05oF1J9X/nUeT0AB4/Z2AICFWHl2gbcomc9sG3MHJyIhw3oQlGZ2l20kdQ9rpwGm0jamUh9L27KP0D7fkcJUVfpRLIMqorZKY1ReN0aDBUh88ShkS5+J3EzbcL5dmR1eHslYWmXu9FI+o5Y9l7zBxx9hOWMHbd8iKea6aiT7rSTN0Mlcp4G98/Ry/jEzR76pYUmt6sutCmakt1Jz0YvjmDGkatU8jq+qhv3IDQ/oY9foTAxNTmMk9TBwKDGUi+DA3ZS6jG7A8Lb3G87gNjYqwnJM4PgY104T+g7Sfyk/4v5PdvyF8iMATsde97zkaRWUFH9lW9V2DO8WkW946lmAFzVEKYZiHinsGMhHAqO/v8C0IvGmUKq2W43MTVSzEBLM5Rov2GtA6c0QHXuEGX6QvWV6O2uPP8VygeI7DDpAUisBD/kpHKUt/KGTcaSb5cNzqh4aDSTCcHqSTl5lVdXR2wQ4I5CVEmSLPcdVU3Fgh3ikHYhBHZZGJZMWdMDAKactalM+HoPnpg+PZAYqaUkFHj2hCUE2Poz6qpLRIdgn5Blx4Ey742098GjOWulQozcObOXtA+HrhpMgi9//gKEPPFg7nc/M2ChEHs/7vl6l1REOa+tEOqWvII2fBvO7ITlGBGP/47NLZssgTG+wQ1PcjmA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(39860400002)(46966006)(36840700001)(478600001)(2906002)(54906003)(966005)(24736004)(6916009)(5660300002)(82740400003)(7636003)(7416002)(82310400003)(316002)(8676002)(4326008)(26005)(70586007)(36860700001)(70206006)(108616005)(86362001)(336012)(426003)(8936002)(356005)(47076005)(34070700002)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 07:59:54.1017
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 09a7f47a-3d6c-42b0-83e6-08d8e463a7e5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4751
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 10 Mar 2021 14:24:12 +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 5.4.105 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.105-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    57 tests:	57 pass, 0 fail

Linux version:	5.4.105-rc1-g62f8f08c9d2f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
