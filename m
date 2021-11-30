Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF1C1462EAE
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 09:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235223AbhK3IqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 03:46:24 -0500
Received: from mail-dm6nam08on2076.outbound.protection.outlook.com ([40.107.102.76]:21089
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239665AbhK3IqU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Nov 2021 03:46:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DWgkecimRq5GVsATPn4wQOfZtubt10ST3iUGDGOqD4C7AfAw3meag2Yq13kI11pY7qMCYvF9IKiD+MTpV4wzmSGJXSQinpKhP15n6PLSFXMlVbMKO0dKoExspNRh6SGPg5E3/65Ist18e0PUTLCXmWu8ztzvyk7c3Z2HfMG6inkkPXSsaVonY4MU5JdPMDkqOgRUih3WJEcTa0LRY647N5i1j1mSx3tpbciGklA2RAcM/IBK0acPsBTOnGgZCd514Xi4uoNfcIG557cmOBQpn0GfU+qMoMyLAe9NybLxWI3mQBogyVJ12mO3hkxbUjUJY5pw9dRoCDXu6eXZBx9UVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lv1cXdNytp/cOFtKmtCyeXr0skRk4b3z+2vVTBSw17c=;
 b=bbjiMLXE76lQky1D8h7vZJv5zPGzBYImJIFXUQ3gkM65pIaKBEKBfRznc4osvT5WfjeYwkiQHPL7qwgsL7WDVYc0Ze/SWpEyzgF4e624xN+mxj2lTtDShElPhtPZBU796oKQ4EZlXnBcTwBtJAdC4Q660mQSeVroE0m3lpisQDjPspMn9AkrDDxsNWMv2lpNvaMn8HByX9KE00iZYrP9k58FENnoTMwauyNeMLHnEa3wl68plQxGXXSU+lYtVgCpC8oKUzyZkkSU9lHIdIGK1ypvtEVwJHHL4ivwGiI6FNzKAi88uCSIU58d99wHg3AmA0vUlJwkh6QtW4c2hpSifA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lv1cXdNytp/cOFtKmtCyeXr0skRk4b3z+2vVTBSw17c=;
 b=t3wHHbIlfmVTuoQaeHwtN7oDCvNFIi0Hl9YsrhF+ogRw3zT9/UFBgQiy3V+0UbpZLEtgwUZ3x4FHAeS/Z1GfdOm2pqeB7OZ+i9LSbl2LD3YRxYBKn/tH9nHUVGeqb5R2mJ8dKjefWeokXw9+qyuY01GjYFEvDJmyPRigCjF0GGYbJ/vnKnFJf23QMgQ1G72bXcEks4XsFIxiAmpywcyc3h3IjESdCCTnTDVLeJ7eEcIYyh4oEbczaaszJPJsZ8Uu5ujbc5f78ghwG2N3dH2cDBKaA/I+thhVFxfX7JZC8XI0WrH9oBD0KSZc3jDiO2UG34kPUQMpirVU929A64Q0IA==
Received: from DM5PR16CA0004.namprd16.prod.outlook.com (2603:10b6:3:c0::14) by
 BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Tue, 30 Nov
 2021 08:43:00 +0000
Received: from DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:c0:cafe::57) by DM5PR16CA0004.outlook.office365.com
 (2603:10b6:3:c0::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24 via Frontend
 Transport; Tue, 30 Nov 2021 08:43:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT050.mail.protection.outlook.com (10.13.173.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Tue, 30 Nov 2021 08:43:00 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 30 Nov
 2021 08:42:59 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 30 Nov 2021 00:42:59 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/92] 5.4.163-rc1 review
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <0a85c19ec88f47319beb4e2b4de953bb@HQMAIL109.nvidia.com>
Date:   Tue, 30 Nov 2021 00:42:59 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6fa4cdcd-dac5-4768-e7d1-08d9b3dd6a73
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:
X-Microsoft-Antispam-PRVS: <BN9PR12MB5259BB6B5FF0364B79F05B0CD9679@BN9PR12MB5259.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VzcgMK63i5/w2w1mDPJyzQzPRIznsYR9nTP9Jg3332NtVfKXDpIPbmvpXxPZ1Q9bNZhvNED+LxSzDA5+d336DfSmBbe0AHDGKkTGbHwfBCDZH7zph9vADuhnU5EnFNLI/Z5+9lLqf5gkDE0ixo8wbSafj5jSqK5RFfrni8Uf+45EusQmYiWAzJbfSQtfGKAgHwC/4xjZEsSkbmyoCkY9uXblJ0LBsrRzwShlaOc18zQpSXc3mCMmqbFi2+F8+m92tff2RDht+imdBhXjMOWa4z7Vnl62B0OQ48OxDevV9INnd+Q8v1zMWPrXGHL1OWgrRbjY7DAXonUOus0T30+WP7oytxkdetYCgCC0lHPvYQxxbb2ozG9MzoFlOroFylCRXPDPd/4lgzAd6shQ45P/8IAR6MFv+4TKLICak7JMdtzioEgjqYll/i0qyvkZwEv0GH0ojrMhxI0mtzgtZQAFZMxZF4bliYbpYuSSyXoxV+NdxlauvGjof1Xf8voYEYEBzz10HLI/p0dXYEvolLY5vepetutmVjtkk5wOF/JyoB8AFYtXlQfnOJ7lK3EH3TMeA9SsAVjDP5okIlq4vb7AEISKDfR7Lenk29cwJujYbFKBxipNzX5KHJpq2vuGNsjh9N07ohocLEvGnXGq0Tjn2yjmqMgG8l9VAp2KYPwqfrbDMwcMdoO0aKBXPhI7T8n6TL94xy+Kh+HftORI79f1ZoIdjekc8sERJJzJZ7FKSomnFjA9UsXMTt409Kjl5w/An7HhEio6J0N2QRV0cTMVYVkUVZPaOTRlOZd8VWAKHrQDag2b3qAqKK33lf0HQ8sUXKwzoH4m4yK+X+zb3AQNh1SAjTHE4PkXaAw6qqZ9b6s=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(2906002)(8676002)(426003)(508600001)(70586007)(7416002)(336012)(36860700001)(47076005)(7636003)(5660300002)(966005)(6916009)(26005)(108616005)(70206006)(356005)(24736004)(86362001)(316002)(4326008)(54906003)(82310400004)(8936002)(40460700001)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2021 08:43:00.3731
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fa4cdcd-dac5-4768-e7d1-08d9b3dd6a73
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5259
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Nov 2021 19:17:29 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.163 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Dec 2021 18:16:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.163-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    59 tests:	59 pass, 0 fail

Linux version:	5.4.163-rc1-g53673b0fe933
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
