Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF59142286D
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235339AbhJENwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:52:30 -0400
Received: from mail-co1nam11on2087.outbound.protection.outlook.com ([40.107.220.87]:45409
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235345AbhJENwX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:52:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L6gayVvSAuETymbIP/lvH8YL0vazDbwIRU/Hrg+4n4tZztyDUy9sW4eHIPwydVoA7Q7VPqeh7v/j5VdvC6+7V3NDr9SXwUoXsqIBQM0bEOwN2ziUkeVOS+jFNBiCUNyp5+mFclTX4EAqCHTbsPKW17YCQeMHCOGeRkEG43Zd7OsGP8REd2UcFAV1lGreyT+HTKcU5qo3hAOkGtRemjT/p27We+oes4A2oxhH7CA7mkJazYEnii5lSB085XLqVe51SrQAZ0jaef1alsXN1VsiH0ntigBKGmR0AjHdtvKac+VFLIacwsI/7yVjR6rS5dsPf7oL44R+L/WgUyx2qVxYXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ccTcGPvsSXjHLmWtxmc/0i/dIHFI1ynKbHoVaRlktA=;
 b=M4BxGFXiS78JOhHJXliCCmnw9hGW2HuSe1iaxDOntWjUO2DUV7D8ZAxOrXErEcRfthKf5gjjJN09tvqe4rDxb5jg0dNXb0rICIfci2dEPb5hYWZvqGiuL2NepVSjudUWisXU5cPJuAZtDLd5j4uNDhkbFl5T/I/PWjR+X3Y1x5I04VDA7m7t1mf7zfa6ziDr2+eYDoM1pOhtATpFHPhE5opNq9rHfxC4uOPopJImnYar7mgYG1g1sXu+v688OX4Sdq7W2/UfAH0BB83LcBgRlw94qLS3+5u1qn6ITOYwL7OqAEPFVqrTDb4prHLjiWNouoptgFFlvLlfvXkTQz+kJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ccTcGPvsSXjHLmWtxmc/0i/dIHFI1ynKbHoVaRlktA=;
 b=GsE47ZpoAZG4zZgZJSTWoqctihPzyFr4g1bd/jzGszO+J2W0KTrbEIRnyX7VJkQj1VY6FPJWiJ9j8obx5P+Fo/1lnhmKJXByf7W25xkUef3YIrj3lbq/i0JFGfE7MJsCA3ZHTfFmpPNdEkBaZuOB+YBxKwWHREIZZAOkh/D2rQa35pV8UIhYyFI62ufivFB7TNyz71/xBcZLP7nqKcIRpKsYQAswetL2Wh//Lb5HX87m4/JQ05wkA9E5x35AzFfx8kqcW+Tq+lunjn3/ONWF964ViBHkSmylu5SBIezuQOmML+W7aY/ZIA/gu3sH+gB/80XKolhV4kRItomh6Q9Hhg==
Received: from BN8PR04CA0013.namprd04.prod.outlook.com (2603:10b6:408:70::26)
 by SA0PR12MB4400.namprd12.prod.outlook.com (2603:10b6:806:95::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Tue, 5 Oct
 2021 13:50:31 +0000
Received: from BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:70:cafe::de) by BN8PR04CA0013.outlook.office365.com
 (2603:10b6:408:70::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.20 via Frontend
 Transport; Tue, 5 Oct 2021 13:50:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT043.mail.protection.outlook.com (10.13.177.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4566.14 via Frontend Transport; Tue, 5 Oct 2021 13:50:30 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 5 Oct
 2021 13:50:28 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 5 Oct 2021 13:50:28 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.14 000/173] 5.14.10-rc2 review
In-Reply-To: <20211005083311.830861640@linuxfoundation.org>
References: <20211005083311.830861640@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <fc7241b95bfa4fe6a7b3fbc34ab0b95a@HQMAIL101.nvidia.com>
Date:   Tue, 5 Oct 2021 13:50:28 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d318d772-a526-477a-135e-08d9880718b2
X-MS-TrafficTypeDiagnostic: SA0PR12MB4400:
X-Microsoft-Antispam-PRVS: <SA0PR12MB440019044C3DCCC7ECEFD7D2D9AF9@SA0PR12MB4400.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XJ7bQwoOwL7SQvljwyCqGXt9BIFzCv1nesHt2v6LB3YLbKB2J3gZLzBMO+ysgWMBQQGcInctjBR2xekJ7L/NSoURuA92c70t4Ao4JqYFwUTbcpk3FrC+F6zNLZZ36K4wTaDBTB4186goCwj2C3U/EQ6vF7wVO29Dn6/tDVF4eAP8NzJLjeQUJOmSoP8xDv1KEG18Y4GBYOiNRQ40Sn+EKgFeq7iYRPUl+kwh/g2t5wSqwsynOTMYrKtfmRXO7EXleBI9r8O7qCQz9K4q6ilet9VHcl40Xw3bPTLShYCp6a/nav8i+PA8X1TmeBBrG2it7lMY/Xs2y1/o15lT6PHfBdbeTiBMhLSlF6Df7xj1BOQRzrEPas0DbBl91yLAOIeXPzctsqFSC0rE7xsXKBMYEIHta+sbVjerace+MduCaYR+YiuIqrH+jlZdnvD5PgLkj/sKV+iFFXOjIEATbNF5ADIIiKtHKjPJtRNvDf1Cc3kDk8kGq5xQk5OkqpldlnUs/ZD9kVSfg7ixpsaWtBY4gIBsNQEA0GH2LiGFK8iAPGH/OWlO8U+d75lmu1FFvTqhmOmYgauZfRuoaTEvTIm8hAHr5ocJhS4D8ATK1Q4vioYIPy8SsWzX6uj9kEoqj+yN+tgYa5UYMcH5zrlzsl1svyGkQKkNJfvRzim826pdW3B+9roVK8mHyq4WX4Ub2PeDsujME5RBF2QSkCVrMhaBCUG96FKchu3nVzDmz05mpZ5OYdjWur2lWcJ133tsHDW62Jee8YA5Y/JoO9LVmnyB7UlidWHi+nQ0HkRb8/uqLPI=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(186003)(86362001)(336012)(7636003)(356005)(26005)(7416002)(82310400003)(316002)(8676002)(4326008)(54906003)(966005)(108616005)(36860700001)(24736004)(70586007)(5660300002)(426003)(47076005)(508600001)(2906002)(6916009)(8936002)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 13:50:30.8386
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d318d772-a526-477a-135e-08d9880718b2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4400
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 05 Oct 2021 10:38:40 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.10 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.10-rc2.gz
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

Linux version:	5.14.10-rc2-g355f3195d051
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
