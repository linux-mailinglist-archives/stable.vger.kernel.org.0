Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B942D33C377
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 18:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbhCORHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 13:07:48 -0400
Received: from mail-mw2nam10on2086.outbound.protection.outlook.com ([40.107.94.86]:59520
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235378AbhCORHR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 13:07:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bDIkt0XWoP7UgD0jvnda6mM6gpPHQcZBAU41uay5FVuo4/eTdTFBgsn0Oh8VL9ldqIHmmFJD1NRN2dP9i5x8qq6at5BCM5ZKRR37WBDKD1zp0ThsL6/GmYQ0/rxnkdb1jvhqEoFD0SdW5f6q8Go4dU4za3ZrDqUGw/omxGGXt/Z6xASqeFpBm6mdzyjD+MEvBUEW1TA7vE7uaqXUYXUx+qZxO3qA6clVO9cQ5eiwtUcNz13gftzMsJRzOqsqCeJQ6fN3VqbSdYyKUN4WbT9PET5/XuRVzap6ELnDiIh5SpkO3F+lu144p/B+Xep+lnAfFluiK9FM1m+Ablnbmtabqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SeiAO/O0C0yqwpjP7RiYeXvhXJ78fF5NBLNZD70q5iE=;
 b=QeuhdBTzV+tjDqJTiIvlSsm60mKAzkusY0b9fxw4TuEevRNtw4E9rm0MiYEh/pf63uDzRSKY9mHiipWVMGuAP1BiBJC8zc58xVB8sDpYSx6CrAVaSyscmkLUGrqUqehTpPGGZ5g2PUioNz0wrPWMbUpLtQ81797aXS50yFRn70eL3kRRhQsahPGz7iOP2AKNWWoYE+NLJUKf6UZyjAy30pIImeODv22Su0mkOtvoaqstwIi+1dfVnJUMil+lBJIiuUKE01XggkZbXB032WYJJaVcBhGe2f1hlw0T3mQPOoYOP2r5z7APAp4VdOZFqSB3521QFeuWD3WDlcCCWl0tZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SeiAO/O0C0yqwpjP7RiYeXvhXJ78fF5NBLNZD70q5iE=;
 b=jZDUcs/zWbbqbeMEiHSVuiNouD4xXlN5BLIRDaP74iVdES1wjAta4s3B/1byiK6gJsp3Vg52dyWV6OkQaykHyQgB6MFs+t1w4HjEI9LimE0QMtlNzS3T+G++Uyi4LJJDL2lkS1QcIUptMiubz53RHSzsPBJoWPaPdZSRov7dzxCRoIhd9QQIK99gRriVqUSckJEhG4gcIxI3w0dcHTS8rXwHv7HFBtSfmDFijYlffGfPgGro3DHbIJ+mjABhCGRTB93sGSEMzpJ5qFhE60qEU+xLJx+jVrnKgQUtiY3+Dtc3Ca7gClFb/KdYtSvCfjliTUYfEN236yqfPbF4TS8pFQ==
Received: from DM5PR08CA0035.namprd08.prod.outlook.com (2603:10b6:4:60::24) by
 BN9PR12MB5241.namprd12.prod.outlook.com (2603:10b6:408:11e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Mon, 15 Mar
 2021 17:07:11 +0000
Received: from DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:60:cafe::36) by DM5PR08CA0035.outlook.office365.com
 (2603:10b6:4:60::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend
 Transport; Mon, 15 Mar 2021 17:07:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT066.mail.protection.outlook.com (10.13.173.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 17:07:11 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Mar
 2021 17:07:10 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Mar
 2021 17:07:10 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 15 Mar 2021 17:07:10 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/95] 4.14.226-rc1 review
In-Reply-To: <20210315135740.245494252@linuxfoundation.org>
References: <20210315135740.245494252@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <ffb6d2de77c140469cb1fd632738f8ce@HQMAIL107.nvidia.com>
Date:   Mon, 15 Mar 2021 17:07:10 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b613b8c-9de7-4619-fd34-08d8e7d4c61d
X-MS-TrafficTypeDiagnostic: BN9PR12MB5241:
X-Microsoft-Antispam-PRVS: <BN9PR12MB5241967905C36FA5CFA30970D96C9@BN9PR12MB5241.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ayS4yZQg5XRho++ozRx120Ln/CAaLA2BoJGuq71rNbmhWA3wSknUrV++aI0uoIiCcHo4Qgmnu5+m1Rfkx9m/FQWZxWvHRYClzMPwXjqIWfSJr/Wf7yD3wbL9jFP2xtzLxzl0KzkFndq3B4RKKDjQmEyHPQ6EmcMF9FWDdmy2YdaNkSv277rSd6IHIvkS5Jxg+LPz1ZxDDS8TiGGipPloI73v/21sLvhjwvggftusHn3dqx40eSU52kb+DKT0gTmBA6qnQZ7NOpA9dvq5COCbtfHvioJIPeAFhGZUcof2Kkv8BXRocyyMEvztEYZRwMDZQ0tMM2LQi22hHe2bS3Tr994RBfkTf4tJIeh8fIoLa1S46Boo2Tf8FGwh73nZwI0tUVkdAVqGQEcum77uoi1Kz3It3tr8PyyDmhKyq3UXXNFiV/3f/+iMH64W89J7dLT2OIKkLQu70op6yIHzeEsOcgFATML40FHDdal0H7VW3CYOJxc2XAkNBUntRExuiWtaTCP27XQuurmBKPNYPYQtjsT43JBYMyelAt0akU48T9kInrhVK7m++HFPgI9KjDYhkH0oQRN7YbxbuwPDjMp8bECb0c038vj2rMH66Xswf5Ldj7j1MWoWgbaSV5tG+Oz2GtmoIZ1ZrgUyut9BaCUElO6JAs6jdNygsm6N5egQVpNtq82HtMToXpXytimPxI6w/1pg3OPce5mIiTfzrfL2X7WSMUSBMks16mEc/qevCMZ46kLWdNKcR7ar02gXkj0Qu9G41su1zHmE1kWbi+ibDQ==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(39860400002)(136003)(36840700001)(46966006)(336012)(8676002)(966005)(70206006)(54906003)(356005)(70586007)(316002)(108616005)(36906005)(26005)(8936002)(5660300002)(6916009)(7636003)(24736004)(7416002)(82310400003)(2906002)(34020700004)(478600001)(86362001)(47076005)(426003)(82740400003)(186003)(4326008)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 17:07:11.4752
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b613b8c-9de7-4619-fd34-08d8e7d4c61d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5241
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Mar 2021 14:56:30 +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 4.14.226 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Mar 2021 13:57:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.226-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.14.226-rc1-g9da189063f94
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
