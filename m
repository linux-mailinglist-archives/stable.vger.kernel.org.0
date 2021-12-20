Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C0747B2CD
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 19:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240418AbhLTSZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 13:25:16 -0500
Received: from mail-co1nam11on2048.outbound.protection.outlook.com ([40.107.220.48]:8183
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240423AbhLTSZO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Dec 2021 13:25:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bPEG+wF1KcsTcPzokE582c2rpNn11Eb9YovJKCxFOPIVne0QivajnK02b0mpIjWESW35Lg/0YqtBtUcBXTJkQzE4TxT19OkVKY421G09GMXCTwp3mBV3DgLtaDAjlCkHmjrlPOrZyOtJwWJ1zS2yK/Qms5XzL3MzK9U7+kovkKB9MN/gwvoyxtgGDLJ1TSVP0eMx8gmFV8LljFyOZQIGF37dkCFdqRimoJP8M1UWExWu9ucdaAsITu7zw9wJfdN95X32Pgv7zKMgraFFqmNd8/r3eaJ4TBsF8KhZjWj0MnnkCfIPzJ7+pR5SWgptg7T+bYbVZfcecFVxfQGWAzkp1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yUroZRlCs92t8vWDwFU1nBzRwKNa+HOx4jkiisjbGOw=;
 b=SX4lCaJHyA+rXByBiODmQmis7XyV/SPTOVfI6Not4+Vk6b6nAohfIYjhpmxpXTjMuj1fqSqmpaoSaMxDRYWNR87mOh989j0ohSPOzAqZkhnTrvIBB+metTpQdJLzY3mfXcn304bmhUpxQiu5YsmzbH0vLRui0PvuDAeCaItpbAmQz/694ngSQ1xbf0OtGgVOMp25PtRmCg8AYOObq8vrftAz724OqVJ3sBoe+M03cgU/M9a4qss5sRi1yd8pBR+bTgeSHfAAJl0aWzTPfR2BshSbaTT8TSCi7qn5DxSfBvW0oNCZlxwepM2MTiU+XJGKsooww9qrPUWAED5PNvCjtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yUroZRlCs92t8vWDwFU1nBzRwKNa+HOx4jkiisjbGOw=;
 b=XCZpzf/uTU7oQNl1Zr3f8IuDl3XF22QkNA6tpVF161cgv/mpJv5htSxuYdFICMPAb4MeVW8DCSrBG+igFKFAyI9Q6FRGiYJvz5ZFN3JWrTnGqw0ewxXiyFYiJFAWah5ZHEXQcRH5Uk9oSyT4Ba+/cSt+CrOMQOL0QEBOOeJRN4Kk+/L9cY4OR6oSVEMv3B7GpeaX526Ays4xEnxtEuWozDLCiwGy8CtMNNqUdo82PIDzZ6lt/RY3m38q+XpknqDQjJzDsHX+OL3X+otJon4Kt03fUkSLucymJJcin03xU00hYwXKGTmYtko1GZSkEwUx/awxOTo65hiCwjf1XsJBLg==
Received: from DM5PR17CA0070.namprd17.prod.outlook.com (2603:10b6:3:13f::32)
 by MN2PR12MB3502.namprd12.prod.outlook.com (2603:10b6:208:c9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.20; Mon, 20 Dec
 2021 18:25:11 +0000
Received: from DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:13f:cafe::eb) by DM5PR17CA0070.outlook.office365.com
 (2603:10b6:3:13f::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.16 via Frontend
 Transport; Mon, 20 Dec 2021 18:25:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT023.mail.protection.outlook.com (10.13.173.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Mon, 20 Dec 2021 18:25:10 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 20 Dec
 2021 18:25:10 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 20 Dec
 2021 18:25:10 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Mon, 20 Dec 2021 18:25:10 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/45] 4.14.259-rc1 review
In-Reply-To: <20211220143022.266532675@linuxfoundation.org>
References: <20211220143022.266532675@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <6b33d0544a874ceb91a994c5444f6849@HQMAIL107.nvidia.com>
Date:   Mon, 20 Dec 2021 18:25:10 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9edd2634-70e7-4f8b-fd30-08d9c3e60eff
X-MS-TrafficTypeDiagnostic: MN2PR12MB3502:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3502B639324348D6EA41F900D97B9@MN2PR12MB3502.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +woV8EDV7CfH407I6t3wexfoBbbJM6VhhBbMnkk8wIlFEVBaRvSx/FG66GRAQ6BQn6x4Oy9MVPs7KCfsQA1aGCNQODvigT7IOFp1WRn9G+nBd2EmTb7M9ygE3Zg7VJouZ/NndzuMIjf3U0wx9UzI9fyPk7XcJsBlWvtX2qL0GFbH+X5ZkTlM4J8Lr+9RFuIhWH/bpEqwfXxdqJXWMefRHc6HvYih8ARrRPBId3/ZcuKuqgQ5Mi14cAvS0S/H527gobJT9AhAAP2WPkx0Zwlodmeo3NLGdJ/180Qgrbbh2NEVAUfj8ZksLCWQXgv2wv3Mwy52g5BfGvFsSSYMPkIIGq7OREl3mFc8R/p58YaGreeVrdDf0OFNMlEl/cwqLr6KF0FFF3jORQSWmoDBdXLwAckqD7PsUIF1vH8QvO7zyFbLJnUzQwY9yOozzoMEKPduFzwDcZWmHwhaXqQM32PNfww7aVxuXazl9GExqA4MqPEDVG3wlnHN9xTtreJTrs84AiBbzJd03DlJtbfKw+hEZU6meb8baA9FO9MVZW1QOn6AmBwn3HO3LppjwJ0TZ6024J+BRoJ6/Umqlt0IxdpuUPB4JEoPgxyVTxJSKO2FgQkWsmA7k3uqKSZrhGPclrGRxjcQhPATaVaWcFYRUxHJ6tIjz/kIxMuVHcPW5UpoNsE4itaFS1oH8GtYsh1zPLAd9qkwfbKS02FqPFsgdclw1aaTw7PAbj7dbKUQhhPyTifgT+7r7mdb2riXzLwuHV/XAYD797nmhqOWDX9Nat3PTPTvi4RETHq6mPQpz0Kt/TcAcKSidJ00Z/cJu7hvVJ1+frC2kpXzj3aPh+qhQc6hGmd160gf3n7M2FSruC0Q1W1AIaIeElyEbLl1kErxVFtulwk4kzCSUl16UwMkRQ6UhxmFJsLukeVkq2j0YEkJjHo=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(7416002)(8936002)(47076005)(186003)(40460700001)(26005)(336012)(4326008)(82310400004)(426003)(36860700001)(8676002)(54906003)(2906002)(316002)(508600001)(966005)(86362001)(6916009)(24736004)(70586007)(70206006)(356005)(81166007)(34020700004)(5660300002)(108616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 18:25:10.9937
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9edd2634-70e7-4f8b-fd30-08d9c3e60eff
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3502
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Dec 2021 15:33:55 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.259 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.259-rc1.gz
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
    32 tests:	32 pass, 0 fail

Linux version:	4.14.259-rc1-g5b3e273408e5
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
