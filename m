Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2395A452DD6
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 10:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbhKPJYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 04:24:48 -0500
Received: from mail-bn8nam12on2084.outbound.protection.outlook.com ([40.107.237.84]:64096
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232975AbhKPJYp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 04:24:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lxcpb0sSMtX7ADMHHErjyl/oSfnxitqctGlipebjKYUjs190LSWdAmzXUte9I5tdByFP9gS4mEnArmme2PmZem5L0kF7K9diblQh3mQAdu5r76ToUU03NIlnbSfnCd8g0KzqFds+sFT4tntHZgsyc+x84eZ2x7/9EHbsGGcRCVob9L1uus75DhC/3QGng96semixX8vvukgZyf5kLvWG2ckpjWI8XgYPrtWcnHz30rQyuDLI8GvyBuf9wh2wUZg26QzDhajlM6YlxgBkOHYjNWY0v1GbWPM7ZfyvyBladwUv9htrDiwzJjt4iE8mhqEWx28GBFyFilWKeESs3SpqGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=taI+hj9dZ+ktpAFOVQx4xdLG3cqwHemxe8xgHrtvCsA=;
 b=HogR6zzqwp71WEK951fTRPrhYpWZczVcqKerc4edSF7VccCEL3jUya+prrcn/9MRQVSkL1RKOp/1RJhq4DP9cALFByNoNDMthx4vmoNqgQMcxhj4TLNrW9ef60POJm/SzWqgBsVZtirApE1cT4qmo4/qSKousWxnJ4www7IieTMTvDiul/Xa/zpo2C0sw68UVH7igrai4qzKiPW2MjYu48A99aLfP8I5nVNyDSsLB16DY2jYD1jRIy8gOE9ko/ItX3+Pem155GJsGvyM/y9UVVXoZULzjiWQ3r9NtvGEpsrJ4Q2LT5wlS8jeHWmeFKTar/f7W9nE4tqVhoPKgbeEFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=taI+hj9dZ+ktpAFOVQx4xdLG3cqwHemxe8xgHrtvCsA=;
 b=D4iYf+L0u00OSaNghnvS2ia8K6eC6V28hhQyL2Sqb/TcDyELqPg79+XBJfklLd1TBjWUADCCyVamKm+H+yeXdbX2vtdxkRfvue/sXG4q5clX/A4712nzP+Aklsm/3OUuwxgwqJC0hZzf0sWmro6DPzs1NIhegCoY584EW1eHhwON805UBzYArjoAbNcOGUXiCEV7mD4iQKxoiMol8zpVe5wD2ryfbhApFzsBQ1Nv5vygPMhDpW2C66rNiSTgM2S1+j2mO1B3Iw0ZwKYTZZ63g3Uu20zEJk8CP6foWKqi74RUoSKz+tAeCb+9zBAl6kokOlMcrDikZtaeVcV3kmHK1g==
Received: from DM6PR06CA0040.namprd06.prod.outlook.com (2603:10b6:5:54::17) by
 BN6PR12MB1345.namprd12.prod.outlook.com (2603:10b6:404:18::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4690.26; Tue, 16 Nov 2021 09:21:45 +0000
Received: from DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:54:cafe::a4) by DM6PR06CA0040.outlook.office365.com
 (2603:10b6:5:54::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16 via Frontend
 Transport; Tue, 16 Nov 2021 09:21:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT006.mail.protection.outlook.com (10.13.173.104) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4690.15 via Frontend Transport; Tue, 16 Nov 2021 09:21:44 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 16 Nov
 2021 01:21:43 -0800
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 16 Nov 2021 01:21:43 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/575] 5.10.80-rc1 review
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <bc919d2ee774480a89e88ec7dad5a5ba@HQMAIL109.nvidia.com>
Date:   Tue, 16 Nov 2021 01:21:43 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6f7d013-1963-4512-3f7c-08d9a8e28214
X-MS-TrafficTypeDiagnostic: BN6PR12MB1345:
X-Microsoft-Antispam-PRVS: <BN6PR12MB134584AB1421361091D98312D9999@BN6PR12MB1345.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rwDDClsNHs/g351n7Xa54IT0Z5AIefofAV00+cXOK+8sf7w6aoD78WZpqJ/ysIaGd74ybO2ctBTwRrxFFJXW9MdyezZR9MAhXUFi7s03J2znVOulD6pJY7NiYojBTsPJSJpxZPCDz//x/LRQpcu+9i9Zys8iZeY4UW47kmkUHahBoytGtNqSx2AO9P8jTncmIYdAzl8xP+KRA7QDeatbWaS/KT3jCtdsJPCLD9HEab5HvYw3CQAROcwyK2aOivQUr/vhkPCvjy6KEGsp9IiRkE2y2d3ZFua5rP9WHQXSrC221PktfgGfItiUz1i7gmFZnIPnlhnOLUIFODGzelhDxI6d5o/8HhWEXAiHlmQDnAjahEn67JjPLwPN+h3P2cBz1gHWZi59faKDyQYaoWitA3Hk4vU7yQ3H3PwIsPEeJET7ZuUIOWoLj8lTTe7VNBU8716zRnta0J7R43nCec7BYLFfAvtpd/u08K+A+Vaq8cKVIajh5rVgayZsCcKcATbfiFlEXmV3MlOO2eyjSNZRsMXjzScAKFGbV3bjyl2yvBklao02XgGtf6HOvlTl6BrAAQQupmsIEVY0rLEjdvtp3Af3Gt95LaMMurWshuDvZb/U+43ZCJEYCo3KL0GWI8JxZ8JmgLZOXT8jxSqD572gBkhDIc6PUqu9sozMjSI0XaW5MB0Ui90PPxlCtN0mWM/SQsK2+mXz4OFBzEezLlGG9pkSj5FTOoDiUH0DxH+rWW0BaDFATWpeljcxvjZIUiU4C4CyMpnmBHvDt/9uZdXf0enJXMePoHGW9mWS6Nqb6jSj1heVItmwSD8ONNOOvJtWCWinAHPLAv2FGt0dFoMp9g==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(6916009)(54906003)(8676002)(24736004)(4326008)(108616005)(86362001)(8936002)(316002)(508600001)(966005)(70586007)(26005)(70206006)(336012)(186003)(36860700001)(426003)(82310400003)(7416002)(47076005)(2906002)(7636003)(356005)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 09:21:44.6956
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e6f7d013-1963-4512-3f7c-08d9a8e28214
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1345
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Nov 2021 17:55:25 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.80 release.
> There are 575 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Nov 2021 16:52:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.80-rc1.gz
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

Linux version:	5.10.80-rc1-g5c7cb5c15203
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
