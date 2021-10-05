Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F0142285F
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235323AbhJENwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:52:18 -0400
Received: from mail-bn7nam10on2067.outbound.protection.outlook.com ([40.107.92.67]:53208
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235288AbhJENwP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:52:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WL3ekfqGB8iOb0CSoFG2gMCXLkHbzb5ZmYsSDTfsvJnZz5dDOQMiGLD3EiW4DFjaJ0pqCv39EuVsyYiSjA5NwBP7mozMLtUuZJzFFQSFnUP/7u3yLW+E2m4jL8tHsVZayJJ1PH0gZjPYQuqQIp+rART9ENkBNDLVLXtH1tAgCPeNfZuS2GFmk8sQKiWVTdJYt74yizfup9ej/erb19hGC56Tpg2LRsTkEaOsEZ0fOo/sbu79vswDCgbTR3JWyeorCylvXgdF1up0M/HoTx09Hlmn90IloGyz5qrhGSTsmcuf1zRiMiqZiPHROdbDNM1wzLugLxYaroqTB41HLJ/xWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g7w+hyfWDC0nva/PXYpdQkzYEYPITx4oRDcdg8X7Hbk=;
 b=dIs9NJXenH3tLJTjd8YPwkYxouHJzJPmX7atx50k+bftNmrlawqYASZnOxu2k3DMRlOBbb2Azilv+GtYEBjmLB3jryqAZONrHA5J8hgMWNEnMVgTYZmqbGNSlCrZcmYCiKKPo/UodN6vdHEmWOpuCVmko2PFqjOZCUAgjZz4vQD7NYMUdTWZTiBjVUO+uECdkljqDX0b+yd0wXx6Rc4arGoREQrU0htvzmyeheOH62Wdf0eRH9Of7AzRKzZRCiyTQnT0PpWpnQuSf3Ffsdmdx8MnTGC4zX+UTfFe2rU2CRzHeXXRxXmBXknu1/xwZNNOcAg+JJTXGmFWjJWTNm2vfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g7w+hyfWDC0nva/PXYpdQkzYEYPITx4oRDcdg8X7Hbk=;
 b=KHgozhIIhrre83rte/vWc+tBlln5H+F94KO4Zs6+i+Xk1Hj0Xq4MWlkiatgnupe352wbxIPugvkGW0RzuAzrCDrxrd3hKW8mud4idphC3bjECOVmEjZ2XhBNSn1Hl9NCFt2HJFovOWLVnv5FzVVgehuBnCXc6T65tBwpoB+zDM9oVtTRXNpKSzATc4av9t7IB/F5lf+ylamtpZqGdgOSyRGpMLzZSNbEIfe3rekDHBP4UNGzUr3qANbaeVHsRkhU4zDfSqoFxwaXAsBHpeHjPA1WOFo1SfkiWqkR9TkZbQKkOvST9HplEaQbVMlb3QYEbIv0P+nccOhcUAib6/OqLQ==
Received: from MW4PR03CA0182.namprd03.prod.outlook.com (2603:10b6:303:b8::7)
 by CH0PR12MB5106.namprd12.prod.outlook.com (2603:10b6:610:bd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Tue, 5 Oct
 2021 13:50:23 +0000
Received: from CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b8:cafe::9f) by MW4PR03CA0182.outlook.office365.com
 (2603:10b6:303:b8::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.16 via Frontend
 Transport; Tue, 5 Oct 2021 13:50:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT009.mail.protection.outlook.com (10.13.175.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4566.14 via Frontend Transport; Tue, 5 Oct 2021 13:50:22 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 5 Oct
 2021 06:50:21 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 5 Oct 2021 06:50:21 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/92] 5.10.71-rc2 review
In-Reply-To: <20211005083301.812942169@linuxfoundation.org>
References: <20211005083301.812942169@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <0b55358cafb04dc1aa23a89ec6f067a2@HQMAIL109.nvidia.com>
Date:   Tue, 5 Oct 2021 06:50:21 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f19a9b0a-1e94-452d-3ec8-08d9880713d8
X-MS-TrafficTypeDiagnostic: CH0PR12MB5106:
X-Microsoft-Antispam-PRVS: <CH0PR12MB5106EBFAB6D0FFFABAB1AD45D9AF9@CH0PR12MB5106.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5zDgEkwAHl5rosMTlSa8QmmPe4R62vQcm+9aeTeIMJdJQeaOZSOKi9cNbj5+uvibktsyhEJ2gIv59MIVF24KHkU3Nqd2/wiDRaU36yRN6gDZA17CXNQdWfLSzyHbC1/uVxjXt1QwfDmZyO5D3bIZE0d0HS+xj0mAPUTWwz+/FvMsKa8m5FNLhr9lONef89gN4izxwoNbCLfQ3JthgaqZhsQJCqNAh3SnfxjolP/WYNn6tn7gWMuI62zhlN4fk58EagK1pPT61HGlOPGP5FFE3UcbR79kFaLhwyBecQN/91LUlC3iM1eSRIwguf46gQPN6INVgnC7QiNLPd5zJOdC0EgFJ0lwGp3LXS8RkX7s+YmkC+bf4PxNWmhHm9rNsk/s2sCCmtwIzIRxe8e7aa1NGq/Hzs7MuI+x+nCFjfKgvKmTMCpDWqWO9xYAfwOVP7x+sVUoZiy9c665wctwzWc7qJUNBZny590te5smcmcjGD12rstvsNMsf9FCHLumn0uqvdBEzqRZrIcFU7Sui/fLaiDztWqmk8vpwk3GubuiLD1PI28NQTRoEx++p67QtcIYvx7pERH5aWxlKQa26yXHb54aJHFNHpk89RkOcotB/ols+zzC+Cjn6LQ3GLxiHHWTfjjd1GlDsAoA6twnGjoY8pQNDQk8LJh9OmcR/qF1xVtVzjo/rV4kc9uhTABkdoSRJV3fq2fnn9vbdG3Kcbls16nRT2XzVilr9lUp2WBJ60w/XsWkbQMXUhhFriGILpI/JNIlotFd4pDC6SMa0+PUEMteHoh6Dn3Se42w5X1Szx4=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(4326008)(508600001)(966005)(86362001)(82310400003)(5660300002)(8936002)(7636003)(70206006)(7416002)(316002)(26005)(24736004)(2906002)(356005)(6916009)(36860700001)(426003)(70586007)(336012)(8676002)(54906003)(47076005)(108616005)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 13:50:22.7680
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f19a9b0a-1e94-452d-3ec8-08d9880713d8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5106
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 05 Oct 2021 10:38:32 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.71 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.71-rc2.gz
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

Linux version:	5.10.71-rc2-g76aee5dfd7ee
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
