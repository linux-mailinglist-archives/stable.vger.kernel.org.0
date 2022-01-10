Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6309F4897F8
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 12:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245177AbiAJLum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 06:50:42 -0500
Received: from mail-mw2nam10on2046.outbound.protection.outlook.com ([40.107.94.46]:26944
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245023AbiAJLtX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jan 2022 06:49:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DzbHVSLD1OTfo4oBrwjtLW2zyZqqthKRhry/6Hl3Oqwlk5oK1dP84ukOdji5H+MgyIn+WHKTfCoW5fpQ95r58G6oVKeKnfk1S74Bae2ypor6mpE/9Xw5pDKK3ivVmtXHJ5MXy2GNYSrWel+kb5NGMm6tFKqEjeAg2Dii2wU22l81HaIPLDf2hW6GQqLd1IdMloEcFG1ehg3CAFkBAgwkeMvECkB79/i2tPr9myta+s7IF2iG7geJKlqEvb+01Jo7FN0tfKs6epW6WTkkkJfrBt/HcdE5YqAEKM+12RvBNDbNlH46q2Sd+qnZZCAfJh+IGP3eo/bVO4mIaHqtLCfoYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dyqC1FQYXV/nklNE4842lVGLUUA8h3APl72fKNlJH/Y=;
 b=LyTleyhbb3LWzJJss8c/HllX82KGQBXUPix1Jh+GJEwhPBaEQrf4g+lzvhtptZjb1kIVp4DMaGHHwrzJ1/jCGsSoPfq5xDOUIFZMOG2WOUBT3kxPwGg63HkiGHtJqRi4P8miD0STa4asm3rY5wItE15wl2J7eyxV8ehCPfxq9UNXz4Tt0at15SNbge6e9LRjhvdLZmeCWrC9z/CeGgNED5EBzDK1VKMODxqsePwxrAb3YIEKWfPibXjG+K7hZa0a1AgazREL5w5gpQRoc0PKiv2sOlpkJgtO3PJK5EMVCN51C1zvTrTr2J4PWvIgXx4TsyuSg6MP6xpjW8XaLN5BRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dyqC1FQYXV/nklNE4842lVGLUUA8h3APl72fKNlJH/Y=;
 b=krO8z/DV/P6jQCYsCuOYtW2ggnmzwbMFPte6JxZybW1l57oMx1ArTHAm9W5MZagNO/nNnb7KlA9EclXTjNCfymcgWIThzZAZoCl3sPTmlO2DghCZ0nmaENx6Zrz/x9kFzNkqjZMLCx5zY3jIgAN2HKmzuJW25xWZ2j4qimxaZO985FVrK7kz0aAqCft2ZL90j7tCEWD85p7PSF+laiFw/jkmwf/AISQpx7s3LZHq0o+IDGhmaO8u4LguPJ2TtFMvuooqK4lusC7R1938GrI+jH25RjUWv7gNZZaDD5xi+2AKTpMXzyawIyjHfX9suBt4MhOoaJxOnODI9x1dmJ7wXQ==
Received: from MW4PR04CA0297.namprd04.prod.outlook.com (2603:10b6:303:89::32)
 by BYAPR12MB3319.namprd12.prod.outlook.com (2603:10b6:a03:dc::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.10; Mon, 10 Jan
 2022 11:49:21 +0000
Received: from CO1NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::86) by MW4PR04CA0297.outlook.office365.com
 (2603:10b6:303:89::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.10 via Frontend
 Transport; Mon, 10 Jan 2022 11:49:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT032.mail.protection.outlook.com (10.13.174.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4867.9 via Frontend Transport; Mon, 10 Jan 2022 11:49:21 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 10 Jan
 2022 11:49:20 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 10 Jan
 2022 11:49:19 +0000
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Mon, 10 Jan 2022 11:49:19 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/21] 4.9.297-rc1 review
In-Reply-To: <20220110071812.806606886@linuxfoundation.org>
References: <20220110071812.806606886@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e68b04cacdbe4b689494c23207e620f5@HQMAIL101.nvidia.com>
Date:   Mon, 10 Jan 2022 11:49:19 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dff994b8-2ecf-40d3-465a-08d9d42f3da4
X-MS-TrafficTypeDiagnostic: BYAPR12MB3319:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB33193D0501B70ACD52CBE5EBD9509@BYAPR12MB3319.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eapkQlEmyaAW5gh4KyGm799kCyXTuTkmpvbiD5FV09WkS66UKx/He62iDzmtwCBQ2DPsu86dnPYP2URZLBF5ueTyov9oWghBOgxdchkA6kLa8h51WXkGS3BmYmmAHijIatz9U9KDeydRMch7oFpRR3GUze3O8aXyglXB1AEsslU05jydC0BM1FuVplQnEGsDAGXv1iwwpNIO8YEuWY+mKDyLOYVTxsTJ7KgQxVeMdZv5kPX3lcEIzwWHKavDHaQIT4mjh3T9j12/pizCxzKNL+/bwKZQZoBJlElBQoelqPXhP1H1YgpPlKO2rYDwE7dan4Tnp0pC9YOi681/VE2j0ThcgFCfUgjwPxZefn3LlYwhN6rf1a3eqWBXWXACFSrxinX4gSQ1Qocj2V7u/Hq2Z17G9IGjAysyiz+kjGMOjXUn8YNvTPl78Dl9Yb/j26o06Pxq4HzYECVfsEl1/NRFnyoIucNmRzkIp7xgHE2lACxPvaGbbRJVujvrb4S/4Bx3vp1UHG3EE1Vndh4NCWuXpmnCqH5qH+OLW3OkdZo6tBH8xS3gIpTerZ9b7P6HQLUpwntBChRtpCcu7ToyClKIy/Y51b2cMa22p7O/eRqYriOZV0hGn7tlhXMGI/uRHD0vhKQPbvma6ZR5LUxGQfqFY/Exj6JhQdKOnwo88YPkK1+j+CKjIQ5FBdHplHBFQdkQ8LCQCNSFYNb3h/aZhA0adc/4joUcMKLIPyy1ziuYha1Q4VENkwVE77tqXPeOwNzSiDCCyAdF/4SyffuFQYBrUaKGj2bUXnGc0crzuouJYm9FhDb47g9pyc/ZAZ0z+Us2HFYHleIh/snaX0kOhRxMVNXzCKDcKaK2r3zMDZir8J7e4qApeOmXfU+wSUVP+8vA
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700002)(46966006)(36840700001)(5660300002)(336012)(356005)(316002)(4326008)(8676002)(54906003)(24736004)(8936002)(40460700001)(6916009)(86362001)(82310400004)(186003)(108616005)(36860700001)(26005)(2906002)(508600001)(81166007)(426003)(47076005)(966005)(7416002)(70586007)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2022 11:49:21.1269
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dff994b8-2ecf-40d3-465a-08d9d42f3da4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3319
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 Jan 2022 08:22:47 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.297 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.297-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.9.297-rc1-g166c7a334704
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
