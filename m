Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 621C3483F6B
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 10:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbiADJxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 04:53:17 -0500
Received: from mail-mw2nam10on2068.outbound.protection.outlook.com ([40.107.94.68]:6497
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230293AbiADJxN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jan 2022 04:53:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fD4wtlGKG81pHhRZpDGUHIbObaewGscYQ39gtR3Lw+fcNAL2eNmviYP3lpK/LqOr4RGQtEjeK77VtxWQloRFt9hwA/TFQlz/CKELmyViUmIAx/SUwlGrpQbucgs6TthdxrAH22HiNxFGHVoN8tK/922fxMli3j/TrviEd0Rzwd5w4p/cSpMCdRAC8TpvHtppGW9Ss034pateNEEkfJEfXE9e0gqxkuxYdSar1//27tlTXxrKyqMrOV/QiXYUMVGB+ARyR2AFYU5KJ2o0EqOEMxgqPURuHVETYaw081FMuuL1STBpAJGqgN69RDMFHUE2H4DX8t1cW5z5la1c5XqPOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DKywZ4d6z8ZAdMBO1JJHf75DMFOb7dlu/FXmF1uKRqY=;
 b=jxU5apNBzs0vXjk7snbqh1J4nOZi0hmtMeEcY7pRPKvteC9+UlWKJTCxJR6elDvLMBngdkeUkKEdUcJwg9/3GaXVD2qUM+zis+hlimZ767cQd273ytQVZiotvv9Tw8F89kTvk1gA3JMAEV1uyh00YKL5Tn89MdJshNYkDwux8M0bjhplBcP9ZK5Twt07fBVHjbPE/YBXql9onYI0xndJgX5Ua85X+SPT3hhadbYLqNoUfJQG+39e65stofOL8fVn8cxiL3Itv/E3UU8w5ZMqNnsC267jmzt610tRkpvMjD6E+qf6L+DA8Sw1dDka2EBgybC6SX6M0TIBDdJQZPQwdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DKywZ4d6z8ZAdMBO1JJHf75DMFOb7dlu/FXmF1uKRqY=;
 b=sI1evRdd+Jhw30ldPw4hotMmC2o/QJo2mMjmNu2Baz2E72SKAuXz8EyAIexbPNPxpqfsMNHleGceoh8Vek1V9Nblk/oQyIjkUuCWIVakDOoIuQLK6cuEMbOLmG7Azw7RKFlydauTnszMRGpRq9roP6x6vJwFNy25uU6valIJUzVNA/4BUYoX41mqrUpzLY4YDYYFMyCOgBKa/M05ehK7zvOwehLW1VMyLGws/GoqWT4nI3/LdWJ3H0Uw+XaCtKnBQz25fpl2QCNmh86u3cGyP8Yr7p2QzhgFt1Awkqu3e6pYVfCL24sNKxdU9AHh98xr9WomgBrr8QuanGwTBkLkYw==
Received: from DM5PR13CA0002.namprd13.prod.outlook.com (2603:10b6:3:23::12) by
 CH2PR12MB4200.namprd12.prod.outlook.com (2603:10b6:610:ac::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4844.14; Tue, 4 Jan 2022 09:53:11 +0000
Received: from DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:23:cafe::e6) by DM5PR13CA0002.outlook.office365.com
 (2603:10b6:3:23::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.4 via Frontend
 Transport; Tue, 4 Jan 2022 09:53:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT026.mail.protection.outlook.com (10.13.172.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4844.14 via Frontend Transport; Tue, 4 Jan 2022 09:53:10 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 4 Jan
 2022 09:53:10 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 4 Jan
 2022 09:53:10 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 4 Jan 2022 09:53:10 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/27] 4.19.224-rc1 review
In-Reply-To: <20220103142052.162223000@linuxfoundation.org>
References: <20220103142052.162223000@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <3f7d421ca7044aa1a2b3ff04cf93d4c8@HQMAIL107.nvidia.com>
Date:   Tue, 4 Jan 2022 09:53:10 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72ab9b65-964d-48bc-574f-08d9cf680491
X-MS-TrafficTypeDiagnostic: CH2PR12MB4200:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB420087F78B725CD33809CAD0D94A9@CH2PR12MB4200.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H+QYeXXeJei6oAMSRs5sq9c/TF58jc+lmsAzQ+RZYcRbLQCi+EAAD0qe9+WilKSZ/ZZOEiwigl/mFkvXMAzMlDDdMlIhF9ZCOhYX0jJ61Rz/2lqgltt00145iQyVPNDlQkzZzF9mIlbDwLRt3IqtdggHJlZ7/RwLRwvI9sUPFNRRIyuyDpkzbO1b5QKRYnLV7ZZVSU6d9u/BmEqA8vVvf5ABtyTNAKcBKPQ0ZWTm1Q6/Czlffh9uGBrLLiZv30pciuWOs9ayQU70NRjsfNx/oG1/MjheNM1LapLTLiX96cM3G9xoIAPT2J7/6WoOY9+6GH7aKi6Lzlho2YPJObrQaYTQaW8oaOmRNtx6CaoralBITYVazEueTaRCt0KbpGtidJxHTt1ZPQeuidnNicUARMr4i4TcNEcZeNj/qC764I5Spiu8xR0mhQ+XSsVUOiZ4hrbC5qGNN2N6F8bfGGMhdTK+4l4Y2UUmWDDfdrvEWmTgE9KYY2BatUsLpIIT69rPwppWFZW5/bAL78G5XUT2g6sUmw2JIQHZGhf5aSYW35EmSDfyYlcctoTLWQYTT+d/pJE9a/HoLKQ+5zIl5jn4m+ilO88l82iXJuPo2iErFRXStVnmkvMz/4zmAHbdnewx21ugi1L6YylJ0gZ6qRHc0MWQ2Do/spANm2HXMv2izGHdOOd9z8BPA4Jhhwc5CL+Y4oj0azFGjac+Ps4wsvzQ3QHBUrUEIcNt8QzvLxRQeHN8r3YHOE0I9vbNFlea78acUrTWHMSrDOG8Rjlk7tqstGL0F3A5azPcT4nJ4+BfQgdDBQw31hJgynH6O+uv7bq3OPK+lHPg409kEZSJ4tKcj/gheSJJTkODY68Gi1YPYPSy4ZcDTkv+DGkHwyBntfpa
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700002)(70586007)(356005)(4326008)(966005)(54906003)(336012)(5660300002)(26005)(86362001)(426003)(186003)(70206006)(508600001)(47076005)(81166007)(6916009)(24736004)(108616005)(36860700001)(316002)(40460700001)(2906002)(82310400004)(8936002)(7416002)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 09:53:10.8568
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 72ab9b65-964d-48bc-574f-08d9cf680491
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4200
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 03 Jan 2022 15:23:40 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.224 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Jan 2022 14:20:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.224-rc1.gz
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

Linux version:	4.19.224-rc1-g3285af6cecfc
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
