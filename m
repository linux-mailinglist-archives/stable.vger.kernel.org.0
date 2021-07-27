Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123153D7249
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 11:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236076AbhG0JoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 05:44:15 -0400
Received: from mail-mw2nam08on2084.outbound.protection.outlook.com ([40.107.101.84]:55008
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235961AbhG0JoO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 05:44:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mEiN6ICC7VX0Nk4/9DSNdHAlaOto3JS/r77cUXC51bJtUOr/w5o4gpkT+PVdhnA5M+vO1csX/e7OQ0Y7pBNyAAwZ7ICAYSvvEn9SsL+9UKo811GbhJ4LgGd/6cW6F6eshX21qZol8hfqOZIPgVNRX7kD4NIcVPsVIIpeWj04578du0pr17sQ1glHjIFFSwxQfgqEB70VaKC1EQyAZ3r4yo0XXLio9UFK/GhU8olwMTnOcficr/6BaG62eyIawuxSFlH3dkGYPhtfRR+744LguOGVT8nJ+iAnt5DVB3SvE7EExIe8tTv81zGhJhklefl+n2juQsStkD/GEr9edsJ0TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qyyux+pOSZ4m7ealWkkJlPwnjAqnAmlnNgrHpNxHODE=;
 b=cFUrrj6E6ff4Ku3iWZXpMz0egqllsKelIFVJOioDMJ/kM5WIBL2m1lBmSL/mITBgVpb4LcwOF6XhjVBguyVzImgbsiGnveRPfR2EKZYheDpfkhrZPXT0REwVvTBEOgY615b7U3CQzXDFrkgv1amoWPJ+k366pFAWOuiVD+UAmG+Yg6/2GfmhJeSk00n2d8fy0R/hwcqsGIVHx+/OU59JX863P+1DCPIvDjvavFf5m7q4Lo+EHNh2+KxMittD10jPjAYu5K+sqahHHMtz6LFc1lvB4pYoc0wBdWx3qnUrO4hObijGSO5QWUEAi5Kzm1q/8UqlSvpVqIs0lkpA7pz9PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qyyux+pOSZ4m7ealWkkJlPwnjAqnAmlnNgrHpNxHODE=;
 b=sON/XgaphYABHszWeOd5KmUrvBlTb1bIMoQ+YpM5YGaQZ6n0QT6Zlm82uwIb/7CvYyD+b1dQrsndDXrqT9FtoSVRk8MJsUwuRFGxapjTvVqu0/j9UqKRoZ5BQN32LX2oQmdcP2pnD9uUis7eE1AQ2HuYu/TaDXkqMAQB3AHOZn96c+1t1IwqFqSe736nS8XN4Qys1VNcWFB/ffp7w7YxBUhqBndpoZbkZruFl2LtqYav2sVK3F6+Iof1PQBn0/rVOvtZ5Ql2cMybnGnHOWAcZUVE3acJ+rJhiUVjGlq5f6ljlcYM1zwRVKNrDk6CUwSzXLCWC7kICOiVpLPhG73LAQ==
Received: from BN6PR14CA0001.namprd14.prod.outlook.com (2603:10b6:404:79::11)
 by DM4PR12MB5277.namprd12.prod.outlook.com (2603:10b6:5:39d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Tue, 27 Jul
 2021 09:44:14 +0000
Received: from BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:79:cafe::2c) by BN6PR14CA0001.outlook.office365.com
 (2603:10b6:404:79::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend
 Transport; Tue, 27 Jul 2021 09:44:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT068.mail.protection.outlook.com (10.13.177.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Tue, 27 Jul 2021 09:44:13 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 27 Jul
 2021 09:44:12 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 27 Jul 2021 09:44:12 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/168] 5.10.54-rc2 review
In-Reply-To: <20210726165240.137482144@linuxfoundation.org>
References: <20210726165240.137482144@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <08bc629a5f344816a82d68113b38c7ac@HQMAIL101.nvidia.com>
Date:   Tue, 27 Jul 2021 09:44:12 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7787d2fb-7197-4dcf-ed03-08d950e317c0
X-MS-TrafficTypeDiagnostic: DM4PR12MB5277:
X-Microsoft-Antispam-PRVS: <DM4PR12MB52777AC018E715044190103AD9E99@DM4PR12MB5277.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /hbGmNGvGZioQAfCBnOsdTpo+6bpXwvKG6nBJQg3ImPIvHwrLegZunYKFkbeY/Lr/vJwOe+Ts3Ti51moSNPGRLLOUrt4yUewE7gewbI8wAJgmZW19VRdZBh0/87GxBmyeHuRFNiJmTyMEVyF87xVM58dywCet305Kt72ksr8my/xpX5HwGzjER7RAx2b3x8VEaw2QIFvyOf7+t6E5kDvC39cEOpGyw4PdiQjjFQu+qSfdW91yT1Mj7IBUpSxNz0ZIB8MnURVZdVc/6Z1w4tUrpTHewvU7d5Cm5d6DmLnwqAeaQFvLh/I4iy6aI0dTNXnXkQ7rsZ6rmzJ/Nrc43lbi4S+IhKgeoFL5BAJ2zth1isvpkN0Hyjds8QGbWazfT8JWOEW0a4Dgpn3+ZLV7DzSw/3W/Srb6WrCn/fbewwyW04mW0LCRnH0XEjagAKBSjOfd1s/t+M+42meAnTxZdewtS2Q1o5+B0igGjnsAbwMrg68VLWvyQBZKa+3UhWf8HqJsPTL89H4xBD1xyiTAWMtfPMYuTW5tT+eDF5vkQjoQq512yx3eSFnyEWgYQFSoYlgHbvLgsOAnhaIlKq8FPvLQNeQ+e4iT6m11rQ/IU23ZL/JHMfXxh/ZWbByGV8Vgc8YEtsMk72Y94LKpM8RwpVHWrLJ3yUxoFAx0c3c44FdOBInebgBzW4ONxRJ9E9QK16GD1DC2FR9Tex98fwiM2tj9Zf8+s57JB1OyGm1BT4zo64DBlIVOvwiaOASSz6hfkf1XXO+SX/cCoLLyj74/3uVEUBZYIOOxovDms/Ov+2jpIk=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(346002)(39860400002)(36840700001)(46966006)(82310400003)(54906003)(86362001)(5660300002)(6916009)(316002)(8676002)(4326008)(82740400003)(26005)(426003)(47076005)(8936002)(7636003)(356005)(70206006)(70586007)(336012)(7416002)(2906002)(36906005)(36860700001)(24736004)(478600001)(966005)(186003)(108616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 09:44:13.4294
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7787d2fb-7197-4dcf-ed03-08d950e317c0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5277
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 27 Jul 2021 07:06:01 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.54 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Jul 2021 16:52:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.54-rc2.gz
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

Linux version:	5.10.54-rc2-gf52d2bc365d2
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
