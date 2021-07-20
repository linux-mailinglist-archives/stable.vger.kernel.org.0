Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCE873CF6ED
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 11:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235629AbhGTIwW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 04:52:22 -0400
Received: from mail-mw2nam10on2054.outbound.protection.outlook.com ([40.107.94.54]:57761
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235455AbhGTIv4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Jul 2021 04:51:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OXy1YYy1yvxlSMdJ0haqLilbxQLjk45+nALb2H1S5gbSXt/VPI01Spi2u+ZOzIMXkQuZv7KI5kld5zd5RdtXCT2d6wN3Z6tFk6ihiSeOsifunko+u6ffBMy8yyethsiaFp2tzEqH+CRPFEGviq3A+2LsLgT3R1faO7rf4LE32TUW5qusm4/CRfAQXylT4Ac+8Qst2/a7t1a3C/9XoDPrViUpODsK1/QDVC/evXc4rxAn11rM6pmYRjSiDksb4WQCMlUe/qSPtnHYptqGFznOCV5fKqj8pZ6rHkRK0GgWxKf16Pm2FUvXxx4KaseGxLxW9rLJQLR7sJgdH+vJkrT/EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w/FcdjV2oFg2Sx3WbmEMz9ol0fEx1rUtZYI7zziP774=;
 b=hbUaQ59nDqKMVIg1emRncFf9K/Cr6KOCP6XTgk5XoezSKM+znI/qM2bVCz92q5upNpKkCdKOrwmGU0MRC1qbYjeDj68vq/SyLNe908HWFxllVbnVDQKdm0NpWOm03YIryAhquFch/DyrqJVVlgT20W1fnQnzjvnhjDy9dDTT86ws4iGhM9EhcLr5lzbWjAMsLEDumfgEp8kBz17Zlg1UC6EPCxoo+AQSUuN9J/LHjzF7f5Z8txK3S4uiOfbGLAfWLTDGaY+Wvvly1qGFP2NKuiM9Sm4vsnmzPl8QxJYl6PLMZ/XHWPQQRuKDRbos7/+4mHmtCihUQSEa76b+xaTsww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=none pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w/FcdjV2oFg2Sx3WbmEMz9ol0fEx1rUtZYI7zziP774=;
 b=bv+PIc1YZeWupPb9pWEl2JLo4HReHsGaEOH85AEMIoGQJe0kzcdiUMBSeAm7680mXIjfwnd6yJYkGPdeaneAdhiI+cpMPmCoZtz86uelup4vPzKOwwJmZI1ubFCO7Lhmu88Ml0bNpQlwAHu9/i85FJIABWd2PYL98BkoGQH4GhsSmesiTOM07H/0IdeFFp+hOWuHX9kA43Aes9P5OxB9CNKIQuZib2qj2du4G0w13wPl2+exBrRe4QS5JO7RbcRmNqO+FF56septnkfUkV8cpYVt93E3XbeRUYxyd9HWhecGId5ggN0QQ/0dHAk2EGUPOf+l/OE1chnnXEr9MrTLNA==
Received: from DS7PR03CA0056.namprd03.prod.outlook.com (2603:10b6:5:3b5::31)
 by BL0PR12MB5554.namprd12.prod.outlook.com (2603:10b6:208:1cd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Tue, 20 Jul
 2021 09:32:33 +0000
Received: from DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b5:cafe::5) by DS7PR03CA0056.outlook.office365.com
 (2603:10b6:5:3b5::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22 via Frontend
 Transport; Tue, 20 Jul 2021 09:32:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT017.mail.protection.outlook.com (10.13.172.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4331.21 via Frontend Transport; Tue, 20 Jul 2021 09:32:33 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Jul
 2021 09:32:32 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Jul
 2021 09:32:32 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 20 Jul 2021 09:32:32 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.12 000/289] 5.12.19-rc2 review
In-Reply-To: <20210719183557.768945788@linuxfoundation.org>
References: <20210719183557.768945788@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <737d48f78968469c862e957a781e9564@HQMAIL105.nvidia.com>
Date:   Tue, 20 Jul 2021 09:32:32 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7757bcb-1b30-4880-4509-08d94b614d9e
X-MS-TrafficTypeDiagnostic: BL0PR12MB5554:
X-Microsoft-Antispam-PRVS: <BL0PR12MB55542F87FCE0E48B4382498CD9E29@BL0PR12MB5554.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CJExhXMzY7+BKze4G/aixTXGkaHmVgdbhaSrws1SqoVhAxurlM3At6PKyjAFp4WPm66X+tRnsPLcRcuH67qp9wOjRCnR7jDfUn2qpHxq+zP83qPUISnl2LyTYXh+pHpM/qfS1NTWkIGIqnNyCimGQr+otZnIJ5Zh9LiRlzXRx6qQppbfDEEC7wzDnFHm5l38W8BfeJSNJWEoeX18Bo4BtBD1vr8owadEUlsvmrn6tJBaloVKiobDurTarttuXMVLyQXZf+cnX+Y8mSlxYTMmKoUZjg08SiYGNPKFUcnSzAGtO3uNbp1iPhwWr3+W8di6MzSiDdCFwUEm6DJLyDakUI88BKEppql60EDowu+uVMaKEd1il68SeKcvK4QoSY+cF2p+aJQLDOCNjikEPV1EZmC2njiZuBrYgkcgYqPvQk5ezdWGNKG+MhhGdlgQpl9ftvShnRmiQ0VxSQrh9kkpu8dwzKXrkNuP7oray6+ZJPcf2G7+Hoh2ir7tlsL+FF+FfDCOCAeGGvOFKuubkcLnmZNY+HZwIyoa7Dcqr9PEApGusVvjVy8ne/o3647CWaFHdtOpgVTGqZl5XOuM0FJXSaCWLlNjCzmPjWQ1aHVru3porwL72vNQE5SI6A0IzF9FcK5ncQmvi9Ex8mRUAJ6GEd8ZDiTKH+ODd6WS4A9rElbi7NubiGY6syWK0C6UFqaY9dkXog7nhXzGKo8iceaAo2bMw9l9QMGl7awROXMzWYauKkNfY+eBu/f+mFP/eRQN4PoFrMH63pSz7wx9AIArDsicxw22E9A2VCbwPaOf8eU=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(108616005)(316002)(8676002)(54906003)(426003)(7416002)(966005)(186003)(8936002)(24736004)(5660300002)(36906005)(336012)(70206006)(70586007)(47076005)(82310400003)(6916009)(36860700001)(2906002)(26005)(356005)(86362001)(7636003)(508600001)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 09:32:33.4685
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7757bcb-1b30-4880-4509-08d94b614d9e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5554
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 19 Jul 2021 20:36:26 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.19 release.
> There are 289 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 18:35:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.19-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.12:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    110 tests:	110 pass, 0 fail

Linux version:	5.12.19-rc2-gaa783473cf1e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
