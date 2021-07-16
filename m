Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87B793CB6C7
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 13:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbhGPLiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 07:38:01 -0400
Received: from mail-bn8nam12on2054.outbound.protection.outlook.com ([40.107.237.54]:1171
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232552AbhGPLiA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 07:38:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dt6SdTfvHzrPPLfxKJ6BIOHyweQ2DixczCnwCHOcJgQRU0gkrDOvFmb89+uHfTwUk50WrqZW+kZnZS3/V+SbnTBnmQ3/QLqePKbSHkrwVHZtL8ZfT3iB+yT4/NvOIoYwTSKY2RB8vWcfLF/xK9VSPMugwhC9L3YaL10sUrFTncZFmNQJSgFyxVnLsFFnacH6O1rlFrfmg/g8N2dBUEQwsI6HfGhL6n0DksyLqkvegFHF7dOAb2sjo41UucWO2WSb7OwiGM8d1z2PEJXMHdllSacTn+WysKSxvHeFRoYXJWwhhJmmLGo9mOz9PDUuiTPzmgOCzVlWWMZ250sxOUNBgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jwXX2zy7UjHu7PQ7x+L81CoXb9PJjYAUMLeGcn02o0M=;
 b=B955Cgi12ReWaB5IPo4LSExt+7K0QtgFdZRjSyuUQOe/lH5gFWJ33nQIJmclrqTpVEDGIcjRVv5g70Hk3XtQAamDQJ8w5k/Cm8iQai6jSH0ynkF07Gc3+6zjXkDwpSlSwyNoFS7rxW6XqHL5HRO+/LB6Tjh1K0QSclwbabf7oT0SjlY+KqapAKPpS/82ZaYO8I9gkaxcC3H66G6PiPD7XXnBJKuJ2dNa5k0HfES/DPPz0Yfo+cPExOGnaa5l2WvT5BloXCqMSx+YypUwpxyK+POhbLf0mzMZW2F2HT8ONPVxLoAYttdi/deCzgrbSp7VvziANcr4rbkk5B5hOAUZuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jwXX2zy7UjHu7PQ7x+L81CoXb9PJjYAUMLeGcn02o0M=;
 b=Fsp0UmWUjMb8hUasaDLMAmCoFfWMNYZCxlNhZcHYhv1Iseert9xF0W1N5aVO/90q0NW1NPRZWRETsP7tUHwM8REmFxge06PTHw+xiRd+f88CO4z9JoC8fNWZppBhK6OId6fg6c+6YZsQx+NBeP+gzwQzn8LY+SsnWb/CiWwsIO2J61rmFJSmEsLyxx2HOnjVpJ+DNEIqd+G+Zhu+HQUtV91NBaWq9ApGbAgnyMGlI4lUlkHiN41Ick+Rdw57XJidlo0CxWxbxaM/omsLhdSO5zByfs0x7htHg1qogiujWUwBDU6e//1qaod5g0Q4QD5lw5AEtvJRaUN+f9UcE5AHxw==
Received: from DM5PR21CA0050.namprd21.prod.outlook.com (2603:10b6:3:129::12)
 by BN7PR12MB2737.namprd12.prod.outlook.com (2603:10b6:408:30::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.26; Fri, 16 Jul
 2021 11:35:04 +0000
Received: from DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:129:cafe::c8) by DM5PR21CA0050.outlook.office365.com
 (2603:10b6:3:129::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.2 via Frontend
 Transport; Fri, 16 Jul 2021 11:35:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT015.mail.protection.outlook.com (10.13.172.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4331.21 via Frontend Transport; Fri, 16 Jul 2021 11:35:03 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 16 Jul
 2021 11:35:03 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 16 Jul 2021 11:35:03 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.12 000/242] 5.12.18-rc1 review
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <a82ab4fa68dc4c4fbbe131a423231857@HQMAIL107.nvidia.com>
Date:   Fri, 16 Jul 2021 11:35:03 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 510655b3-3aa4-4dbc-d0f7-08d9484dc134
X-MS-TrafficTypeDiagnostic: BN7PR12MB2737:
X-Microsoft-Antispam-PRVS: <BN7PR12MB27378B45BF52550CB1C37D23D9119@BN7PR12MB2737.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: biQY23cs0G8YRISRMKalBfJJ3u2/Cy1d25PluDOlSWEvRJ27tYto1J1UL2v8Zzb7Wy8vCDOO8SS5EIT/0hmLWvgXHCLHwAG1OTOrOHMugBvTn0CgVN04xDc+FoBO7wIn5os9ta9MIQEXas9uDg9NOEP8mmclvt+I/D22ywCnAAqqEMyfoDHdq5pBNtF6CAZmW21XCevwYehWnXBOsmDacuRxiFKdyK2jl7tghHJHyRNKF8dz4Hy4LN1hGMsiVaJXqjHo2qHjAHpgogFA4ylYJ6rVkidHku7wZJqoGnPvZ67/fHfB2+OO5z6DpCzyDhQhX+B4KaTIY4V9yCE3NeHQdTPR9STUzNNYxC6vbWfqi9oGECqBjQIBlDcaRu4033QeCpZme5YqUM6HzwuXw6WET892caRkoN/savECl3TpNqv9Bjvo3JpWTY+G4wcNqpv0LcZwQX1U+unRsUMNRc9i7X6Ih4ywwC8NmzAyS/A8zhHbi0NTncwlNDkAVsG1pFjzIwXZXH9Up9sCvKXm+dAgdFKMxWphsPSW8ZIPZmaE/Eg8Phz+XEbW1us44ZhouXCgB/mOGvQAjSL5saU+tuyCZT4SC34tzqL7r7uZYqp32pTeztt/QAjb8BM0SFT+uQRlPqK9iZmBuGY2/Bf94wgpblMSOzmNwBcswgcjrAp0L3uO4bF3HF3wwOcsitTW5Y16r4Pm03u31lhGK9le3T2JolBG491xD8fwVIcibbzoBmf2b+BqlMMSpM8xPxYnCjCOePLILHzW16r+HJh2gyBWm6g1HED7ONiac/+wT1TJmUnj9JoJM/fi38Y1MAt2OKKZ
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(39860400002)(36840700001)(46966006)(5660300002)(7636003)(36860700001)(47076005)(82740400003)(316002)(24736004)(6916009)(478600001)(26005)(108616005)(356005)(36906005)(54906003)(966005)(86362001)(2906002)(4326008)(34020700004)(82310400003)(8676002)(7416002)(70586007)(8936002)(336012)(70206006)(186003)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2021 11:35:03.9582
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 510655b3-3aa4-4dbc-d0f7-08d9484dc134
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2737
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 15 Jul 2021 20:36:02 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.18 release.
> There are 242 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jul 2021 18:21:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.18-rc1.gz
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

Linux version:	5.12.18-rc1-g56ea26ce5c02
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
