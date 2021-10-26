Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E229E43AED1
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 11:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234204AbhJZJTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 05:19:02 -0400
Received: from mail-bn8nam12on2086.outbound.protection.outlook.com ([40.107.237.86]:18401
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234229AbhJZJS7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Oct 2021 05:18:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nCCr2yp3EkxkaQ8yaF2pbCM5G2rUWjSvKsGrt07MOtg/WDOfzkOYnmR8cC7ufTrrLLvh7Dt0GQLrHXG8n9gb2aWicLjGpq+dWK0VuU3sBNNnt7oBOe/bKgUTxS3PNqUY2kVfXxu8IPiOqpAWHW54BuY4n8ozznF/PmjCAjqtLy79c2FtysLlB7ebSIC965Ji33PyAYna6WhUiBysCzvyCZlWRyNwo6RnMhFANCwO8GvBVcDNt5qB1EsxBlVHoD2I6ckXg/Bmt2TvCS17oznG+9/VGJlgPK9a7BaURyEP9lKqxbzo7p0M4Py/fw/cJ39GnJbrek3W0rhC/B9JwXVXcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aQpGm+hprbZUwlVpnS9MZL/1iB6/e07f978Cqau880Y=;
 b=XNKz9hInMQNGwzkNgT/Dy4H4Bm8XL9UznJ3sCa5f/QxczgqedHhTEPOhjsx4Jzpft8EGf9iW+xV89APnLoSatlLF/p/WT7lki+FaNl29OFTpREUb28n2z/lq4GmNuXaUHOIn4gSdW9HnDDxaav7R+WTnDrWOn/U/NoaZ/XLn96i1TJf2oW6/+mgDyE5qRt2xFS7Etg2pvidURgKkzTnhb+0Sw7Lx27arJDNMGqn8F7B+bkLXtbV/Jz/YlqHrvB46tnm6+me15cssbb3cYtMxEwz9ueWdGMER3VDJI+maLe073fPxHBddhRc2iLX25MB+jwSfht2UjjtBi5umtuhb3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aQpGm+hprbZUwlVpnS9MZL/1iB6/e07f978Cqau880Y=;
 b=Oqqz6SUZiPdRT+7yM7QVckY/BHk8pTlIXIwS/MOchXvdbqVbit9Jy8KQsV170a6dZtI27Zjp2IZ/tucT8Xq3GchP5/hItBeXxT15R3ix4pnxGj2a47pac3pILSL06EiOsAClXLtYMO7cQnrcb4Rx19/IYwAiuH5x4yKvb95jm6fK68hOxlMm/WR643H/uH28bvzsz7howNDNiLtXSmqPg9ouV1c/tJFY25pi3HUYMRZxYZNUh3Sj4+BFG14mgWpRuHhwu1tNr28SLx0K6mZKGx+R9w/GxnghFaRcqPpbHZRWIYaIQIOWqqtFnIE1wWL18Ly68ABZ+ZudzZQ70GDx5w==
Received: from BN9PR03CA0435.namprd03.prod.outlook.com (2603:10b6:408:113::20)
 by BN8PR12MB3172.namprd12.prod.outlook.com (2603:10b6:408:68::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 09:16:33 +0000
Received: from BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:113:cafe::e6) by BN9PR03CA0435.outlook.office365.com
 (2603:10b6:408:113::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend
 Transport; Tue, 26 Oct 2021 09:16:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT043.mail.protection.outlook.com (10.13.177.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 09:16:32 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 09:16:30 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 26 Oct 2021 09:16:30 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/95] 5.10.76-rc1 review
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <3a0f58c510b04d0283297f20049b3f57@HQMAIL101.nvidia.com>
Date:   Tue, 26 Oct 2021 09:16:30 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5e54a99-cc72-4683-79ff-08d998614d97
X-MS-TrafficTypeDiagnostic: BN8PR12MB3172:
X-Microsoft-Antispam-PRVS: <BN8PR12MB31726FB7200EA152315FE1D2D9849@BN8PR12MB3172.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4o1gF0f9SI8A6JPnTUULq56mGRgBiamh9ov1luGNIAOL/cSDP9PsJLNcYlu6frtLch+oYhYriD7A7sbGskAwm0UrynsFx6gvMZdbdJNpN3ESLjfch5WQGvYHjWS/Rj2zmKakQVMgHFUgBzwgVOOgYaIhTwfx1SyqNg3UxJENUCEZoICU6abnuntk7ibj2gFYixf0K0eaLsMvQ67vL4xBCQP8Vms+klTJ/ukzQlpdrYAYxtfEKtNMtFzftP3lTup01j5hPeoM4FlJkHd8iUK4b7M1y3/97HDK7t2rrdmmEapFdrOqdK4I1+dYH7NleW8OstoZCtCbUcxX1+UcpbBGurTsGhDUocqv4CX9UwqIuFNV4h97jHA98JBk16geYUpVQ/4ZQWkFTVYY6mizWF2gMvm9IwJMBDH/PMguwuDwkCdwQdTd1ErYdS5xe/hWRSnDitT6xkGXzs9y7Cle5fmdE/zKi46oHecPt/JGfSvqfFDSV8JnZpsp71W0s203R87SCa1S/xaPearB9roKZ5XhXwdeHBZlc4o4tVLZB9vDOzGuYXzZiAn5wKFEVnOqe1sdgrPWAPy26yYkQVV1jfKYyApHPGETeL7/lMqJg9ZdEGg1v3bs81YSfxMgBforXhkgEsS+tPbEOsY+fXepjnHp3nZ87ImkZm2mxSj4gq3DPHdy3WwrTeej/wYyiZhsFjpGqwg3RFt2PPwPRaNuv9WzIsxlIGkYuxDUvMaH91bx/5SdINcTz1gGhLSP9y2LxNEn0qYdX3DebrCyP/Bptrh+brUcqWts9ob9m7v3XSkmASk=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(47076005)(24736004)(5660300002)(356005)(336012)(82310400003)(8936002)(54906003)(186003)(108616005)(966005)(70586007)(316002)(86362001)(26005)(7416002)(4326008)(426003)(8676002)(508600001)(70206006)(36860700001)(2906002)(7636003)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 09:16:32.8899
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c5e54a99-cc72-4683-79ff-08d998614d97
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3172
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 25 Oct 2021 21:13:57 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.76 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Oct 2021 19:07:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.76-rc1.gz
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

Linux version:	5.10.76-rc1-ge2430f94799e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
