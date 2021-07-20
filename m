Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB0E3CF6F9
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 11:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235073AbhGTIyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 04:54:40 -0400
Received: from mail-bn8nam11on2052.outbound.protection.outlook.com ([40.107.236.52]:21505
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235313AbhGTIwv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Jul 2021 04:52:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X62+QQKdg/adj9mJ9P/R4vNfKPIxM4eBc9oH4D6GVNSUn9fNqGGULbT0yYjizhUcO0PCrYO5jgbLfcLtrDlQKngzwoKmb525gEnt20Yl9jxmTynV/YWNVbrZva7/OxiHefOW6+sbxcxOIUK/7enaGJz/FhNF1mboR+8a6cS3297CaN4G6CyzRg4PN9+2TpEc3wxW7HAtV5DL2DEFi9+ZWWcjpX5lpcNLGGe14POIIEY4nf35vGXlR+wfg8Bi3IVWaWBFk0/PI68j4AMSBRSFI9G4fJqgTmO+h9NGZNtgkso96zUoCh0lb+LHfN2zS3muxksrUIWlpKiuGqU2kpoHbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TiFiA6KzYe8X94WZiibZOY/4uuoiI144nygHLBV49+0=;
 b=YCZB2qo4rdyWt3JMw2pAb8U9DyNRELN3uqs23c1O1I43ZSBLP/BfZA7z70IpqrIEEYqKpsgr+vglhRPbpVyH8W2zAH7ROwCDXqePFAMyt3Wo/tXQ3FlWqR/lAtzBxYkHZy8KmTRlgImExphzwKhQ3RB7Bk82Xw+++txR8OanNGrNLLLwD5NjEQ2Q6QMptVSKP23nL4lgEbNa55zQlcp12OklAPWvtUVsoZ4X2bUfTPpR7MVPnwSGf8ujthAtOdaXlkRuoM4YvYrMMhrDpUs34wUpOalbch74gfvRh+kd2dMlZZk9l+VIuhMNZnYhlO1uU03X6pTuwC7cpx2T9VlHmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TiFiA6KzYe8X94WZiibZOY/4uuoiI144nygHLBV49+0=;
 b=npxuPhxrfdNKnziMzWJcPP82c8uvOLrIgXcfCys2x+vbCcwAvqbPyodnjHkTcWM/aHvw1Dz1/Y9XtHtmzPOpY3BkGqdDEroC6dJ5+UxoQKL2PJSlhkHNi9VBQaGEcenmpcdrbeX1q3JkLhP6oS+LOBY8rFT2cho0BEf9SxnnelVtlM+u4Xuk1JU+nFHQObE18Y5vpceGTEFo7LYKcMxPn0XhrKpdw1wNaZfDUgV0bJ7vY911ktpU9obqaTv0CvG8JdtZMYbTsxjwuRahpz2eTiT8/8pxUDZwaTUTyREeu179A10j7JlTCNA77+xb/pLQ4U3zzDKRBg+/WVksBqDoMQ==
Received: from BN0PR03CA0004.namprd03.prod.outlook.com (2603:10b6:408:e6::9)
 by BL0PR12MB5540.namprd12.prod.outlook.com (2603:10b6:208:1cb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Tue, 20 Jul
 2021 09:33:28 +0000
Received: from BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::ba) by BN0PR03CA0004.outlook.office365.com
 (2603:10b6:408:e6::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend
 Transport; Tue, 20 Jul 2021 09:33:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT057.mail.protection.outlook.com (10.13.177.49) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4331.21 via Frontend Transport; Tue, 20 Jul 2021 09:33:27 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Jul
 2021 09:33:27 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 20 Jul 2021 09:33:27 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 000/188] 4.4.276-rc1 review
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <ffa78222df134fe3a320fef01dbfe2f8@HQMAIL107.nvidia.com>
Date:   Tue, 20 Jul 2021 09:33:27 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50d4d75d-3ed7-48d7-3ca9-08d94b616e1b
X-MS-TrafficTypeDiagnostic: BL0PR12MB5540:
X-Microsoft-Antispam-PRVS: <BL0PR12MB55408E58766036DDEE0309DAD9E29@BL0PR12MB5540.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j1qDLlWbFKekN5FakRSo5ggFErTe4664p2E+drlhr/1Bse2SgQajxjyYj6cX0d03q0jYf5aejaLg/wtgl1xUMs06DHZxnCLLsYqmtmdRUZuLLE2IZe5sYipnHlfw8GVqmLIcygJfyVF+ftFknW+OCp9r0za2K4WPuFGaqQObfUf3H+uE1xVw8Foy/I5wQlOZ9L3Grl5E6RFvTGfgr3vrLnV0BvAh32OpxREKzuTx0/50V4lkcw3Iy8xIC85lkGmrUJFBRswg98cwfhUDm3CjlfjWm+XB5AmK3crO2o0jg4qDm8ax3wI7DZbbixkr4bEZtkDdHTmxtUlsJvINsLSeg/K5554PG0pXfIVFVkqNtQuwTFNEtWAbKZd53zMb4OmwKMfXStcEcnwKtVhQfzIMA23nNfeMl34fSg0kSA5uIdgJUUrJSuHjKJGKrcPT64OHgpt7KsY+FOkQssm+YQOoBpFYtRpVLjHt8Hqw9ZJopRhcwiYbfqAqn6QJTLX5IZC5mb90WEFSgQVzj2jOcwi+iSl+tLBKClS9kcnghaUQb/vsEHO8bkco+gEcLrYVLN1N/3H0PlyKNab55B6JmQrxsyVuehY2w9SL89SVIvl8+vZWgDXMWJaTbNZzv1QsnzwG8PAA8Z06gWaf+z+O7g5tqGothVHBqxVoU3Y9ULQm3DENF7HVIgqsPHxgrAyuiiiV8nU1TbqK5xE4D+VOLBn94g8ih2bJgjkcatSvqwEJZ6IjMrbpOd/DJLhESfARhlpm4Cxq/pbyuaqDxaVXUbXk+KW0YpEHeIFnzV21kb0TcKw=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(316002)(36906005)(36860700001)(26005)(356005)(186003)(8936002)(8676002)(508600001)(5660300002)(7636003)(82310400003)(54906003)(70206006)(4326008)(6916009)(426003)(966005)(70586007)(7416002)(108616005)(336012)(47076005)(86362001)(24736004)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 09:33:27.9276
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50d4d75d-3ed7-48d7-3ca9-08d94b616e1b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5540
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 19 Jul 2021 16:49:44 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.276 release.
> There are 188 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 14:47:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.276-rc1.gz
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

Linux version:	4.4.276-rc1-gffa748a4e4ff
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
