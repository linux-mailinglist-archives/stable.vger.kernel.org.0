Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2D347B2CE
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 19:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240431AbhLTSZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 13:25:16 -0500
Received: from mail-dm6nam11on2089.outbound.protection.outlook.com ([40.107.223.89]:56992
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240424AbhLTSZP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Dec 2021 13:25:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nk4XzfG+RORjIoj6aueHzWxxJvAZ4l94IYRkEemJ2J96GSKoZa7S61+0vO7ZUgq2S8qSdd+d1+q7LK1zfTiyBfP+oErgpzp210Y0Xpzl6iOmCsZcsucfJpJ4uF+o4P0AUuttGE+cpJYVJVFV8+08EV3Py2LpZHABSv/+GWWz9CRlsKL5Fe6g0fdbNiZSibOh7Sh5RpU/U9gDqNdQv3CJ6gk+N+5qPyNHixmgH/PtkLHUfh6ZkvSgeolfvf4a0DNNOUbobsi8AJoxCFarEiYSVnHC1Nx4PdqWO0fCzUFDLyVKBsQOl1gblhd8xvU+jQEsQR6Z91Z0ST5YHDydBHo2ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TuILE+WLfpPn25bf7UxWUzrrZPOzp/uwvBuTaPLNu50=;
 b=E94jI4/SSZ5exzm88w8eddnR7gaX2nzej+7YpZ6XhSt/VHlRonpu8GzEnY1xkBpP/0xKMFhT0riWNQIwwQg0gqHDDnc91drT1pQP+wEfizNkPGV+LW9OuBVXqbcCF76IyTknOAzL7gHlZ53Q0iWsIp9qYdzbUezPBtTm0GlLUPkd3xoZnsmgdrmqco2kPGB7BynSUAT+SvSuoJxVkmaQPoFYkIj5FJ+5k6jVg7KGP9a5RYAD0CPpjnXpVBU4g2lzNlNSqwml3nrLfG4SOHhgaopoJMsvJ6FeTUz+TewN1eorpJ2fn2yy/RSaeCiDHZhPlSKlZK/CkysCv0Og4rMmLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TuILE+WLfpPn25bf7UxWUzrrZPOzp/uwvBuTaPLNu50=;
 b=AgkjMFtT3TLe4AOkA6dsgx7N7fMuJ43QE2BQcP9nPGvvirgkFn6TYd9BDtwIck/jeVBskwMM5yeCFYmUWYkxphWaIywMWdUl+u5eKzAXxm7pM29N1Dz+VWWquMfs3jDXyoqOTdkC9My75rt/HM273aM2NRs42HIfSq+F0sg2/3JGyPrEcSXQIvHGv4zlKkuQ9VCEd1rxMCmqXymifE7+5fcgWvzLnqlKrjqSD1aTz4tcV58mtTsECgyQdqGZ+qmIdvVPClU46z4W1tZGitlwdjBLqzD4zrjhygV12oqIZWCb5hJf6ue9+S2ReF0Epj/RngG9M+BdmyaJP0C3OmWzZA==
Received: from DM5PR1101CA0012.namprd11.prod.outlook.com (2603:10b6:4:4c::22)
 by CY4PR12MB1191.namprd12.prod.outlook.com (2603:10b6:903:44::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Mon, 20 Dec
 2021 18:25:13 +0000
Received: from DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:4c:cafe::df) by DM5PR1101CA0012.outlook.office365.com
 (2603:10b6:4:4c::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14 via Frontend
 Transport; Mon, 20 Dec 2021 18:25:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT060.mail.protection.outlook.com (10.13.173.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Mon, 20 Dec 2021 18:25:13 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 20 Dec
 2021 18:25:13 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 20 Dec
 2021 18:25:12 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Mon, 20 Dec 2021 18:25:12 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/99] 5.10.88-rc1 review
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <df772640b1fb40c79a5b5138ada48313@HQMAIL105.nvidia.com>
Date:   Mon, 20 Dec 2021 18:25:12 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d099f9a-abef-4acd-d6b8-08d9c3e61089
X-MS-TrafficTypeDiagnostic: CY4PR12MB1191:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB11913126141D323C82FD6909D97B9@CY4PR12MB1191.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LdBNPXTQSechImhzbqVYd8gLlsGf09/yoYtTtFN49eF9c/b2cfli71yIlkAkFAEIeqEnA/Fdo9R3i9EtiWrUszbwRxUP25UfLBmkfUR6dr6Bha93bYxkaghxb/xWTHgWvFFAFC59KaQIPSfaRMjyA6HU9fDnkpXISG8/tV7ciXbXfpVn7RMEzqapd5SDBODz2Z1QRXnF4gbJCPvdLJOt86/KtwKr98HCXG4i2wwDoaXayCtNamGWUY6ddSA/L9MFWGU6Z+WYrOMaJmYcbOfIuLweRVAIot+Z8Zb6GAzK/eRNrpRlPjlimUJ7D8N1VcChWSZVhHRtif0taowvRSuE7mDeZc4mRrHu50tOwyHAPI/2cq+wv12YCKZqjV9Wt17TMG72Ktzrm0ldS+4Pqa/keujm5skuwnBGzzJp2e69C+8nK0Bbch9GDc/0tw/0WL5Ts9PJqSVHgJrmhKs1Wk6qgjAqNpOHAriiXyJ7zOiZMK48FOA7+tqm5lX960nWjyL9tdn0Ep3PrKUeJWILl6cbFeG2eswV2qWLEtShzdmHe8H9D9og6vxEGTipWre3szvlQtVoVR1ZE3o3AHl1Lpq+rOSXDKy19h8GSTNrjr4UJmFgqRm8KIQq04288xrVyq6lIwG4QCzyCHBmLL1s5nlxCI7hVjv/oJqV0+VC1TbvNI4dfWePdbX8vTgnRs2orOmwQprRcsU9xXdb0ph6F6j1cFTFpOki2T4ZVb5qzWo/aEqOplN13N+XuFbQTzLgvIpgnkISpw4BcYS+4AdJKIhUQre9KA5wj7W4HTTgDJCDx5U2GD2peo3OyzsGZTgFEs25U1YtLypaOpC8G+vwt2107eG4Kq8WqjbwS4KTyA/+xmzVt0IG1cfgx/V5WkadHhWog9DbAmUoV9oThcadQaIFc0C0foTYk5eKv4eXXUCKQbM=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(36860700001)(2906002)(40460700001)(966005)(6916009)(81166007)(47076005)(86362001)(34020700004)(356005)(5660300002)(426003)(70586007)(54906003)(4326008)(186003)(336012)(8676002)(82310400004)(316002)(7416002)(8936002)(26005)(108616005)(24736004)(70206006)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 18:25:13.5561
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d099f9a-abef-4acd-d6b8-08d9c3e61089
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1191
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Dec 2021 15:33:33 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.88 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.88-rc1.gz
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

Linux version:	5.10.88-rc1-g22ecdc9ddc3f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
