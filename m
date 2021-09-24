Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73B05417A51
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 19:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345028AbhIXSBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 14:01:20 -0400
Received: from mail-dm6nam10on2088.outbound.protection.outlook.com ([40.107.93.88]:4705
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344663AbhIXSBU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 14:01:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iFu+GD/jLDk25zvfhUW/OSHJamNg+gH/z4Ja7OO0aJvpbicqbA7MkdD+FO/CNZK42WwQqfbKOGQYwpJoRLEUQdhLARvaKvnRODxmsPIVC+ZCxJUGWQrsvyDPCPcsiJUh7yJ5Y+T52ufG4Su+OZBn3CCJrRdL+VKLtpTgFJtEz9knOTDTnrgTRKnFefy2zSBnpZZUTRF1rV3Gqxi8AjhXRyyCajbVhcDrB/LMcQ4Q7Pcy2e5WcZipgIfB7i9zP99Zh7g2ROV5C3ZhCTNifLR0XMi/PfClBk/3t8esH6doHk/DBfBg+zLDSLf79hwsC7UPRdA1M5entcpGtgShJ6RT8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=g4zr3bRfcrNC3V1mwv3Kk/rmsDVk6Flu8uBB0rE5Jkw=;
 b=fZ32m584Mg+zyVHK3SX4VtAAHN1iNXgbMNcRb2MYOgZlsAHcYueWdfAMc2ar+HstkJSQZcOM5t9R+2fu9C0+FIsBWP+MTxv0yQ9pE0KM2Yp2ucySUBN8Bd4+DP333Bzx8hkE3PIUgk6/ZQXnjhs/gas98Q0z83glSCpK9ao5SvMHpVn/EBLtBDhl1AiOfPzkKgEltd3bA1YA1Lbqv8TMT1HVjWl1JiofbnON3NZVjz080bNMidDFxzwJEGVu1ZEzs1qRGd+j3h5eoGgCeGBmDb3+h+Ge7UV5LXU4esjXMe8F5Z0dasoP6JFK9rJN/O9TP8M3Cs7OaJg5eBnIBLO5mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=none pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g4zr3bRfcrNC3V1mwv3Kk/rmsDVk6Flu8uBB0rE5Jkw=;
 b=RpZ1Ees6olDnio4kxqd7PqF8ShZ8Lk3wBh8deVqjG+ya9eLIf7SiIm/c2L8EQ+i/wOigzz0HRlpdMGteYeUYA7tF3hsyc9NL7nTD28vk+jHal1DvBDSamg5B6pJT/+n+itm2tyNpqKUCgALsXaNqeRik1iVs8tA1VInhOfVHbi5C/F6OsTyyg3oz/4AjG6UAm8q+G7FKvxdsJS9+m5RNv0rshwhss94TmLmtktr3uTPlIsgzD6WVJy7P5od4ZIKrxXDXv5FSd6TkdOuBf485XTVTaCWMNkhzofXn2FtpxGT+x06oTe5cqwTr33oRuGOhVCgjRrFaSLUMaVzflQ6fmQ==
Received: from MWHPR14CA0051.namprd14.prod.outlook.com (2603:10b6:300:81::13)
 by BN6PR1201MB0226.namprd12.prod.outlook.com (2603:10b6:405:56::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Fri, 24 Sep
 2021 17:59:44 +0000
Received: from CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:81:cafe::8e) by MWHPR14CA0051.outlook.office365.com
 (2603:10b6:300:81::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14 via Frontend
 Transport; Fri, 24 Sep 2021 17:59:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT041.mail.protection.outlook.com (10.13.174.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Fri, 24 Sep 2021 17:59:44 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 24 Sep
 2021 10:59:43 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 24 Sep
 2021 17:59:43 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Fri, 24 Sep 2021 17:59:43 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/50] 5.4.149-rc1 review
In-Reply-To: <20210924124332.229289734@linuxfoundation.org>
References: <20210924124332.229289734@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <de090ff5c9e94c0cbd2b4a3944a5f8ee@HQMAIL107.nvidia.com>
Date:   Fri, 24 Sep 2021 17:59:43 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe1349ef-f5a6-48c4-0d16-08d97f8516f3
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0226:
X-Microsoft-Antispam-PRVS: <BN6PR1201MB0226BE3FAF56399CE8C6A4F5D9A49@BN6PR1201MB0226.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E9Tg3drKKRBCHic2NGGunYW6BecJFq+wgPpQMQtGYe6h84ALtzx3uG9QIs1f5RfTI1hFWjdW/PFIkEjJEdWIeF62uAKJSAYKHfcQuZcRwDqkgAv6kRJ6EDwYOaqnzvtpSZjXTZAJBCTHpISFAqN9pZW2UEXYuBIGJ38Xo0MwhkCdNDFB6OaNn9DqMQQQzBXyyhZ9yp4pbVyUjt821kaPf3Ojg1/hh6zEqLOk1VFXgQhS5We/kUufGlCokdsA7ybwwLokUElt2scYEjs68Yfjh0Uvtzywbkr0ki7UBm+JYJ0xpf2JLKjh09GVBMsD/2UR05bPYVFq+HYl7P6IiVUnlMC9Kcy3JFdjcaew5KB6UVioUHPLNVQSdgO4TmcZ8YBwSS7QNydj+f9xdHGvnPhBfigPLoDvieBTQ1dhr6VPUapnceC7yVAXdQDR5hWenMYtPSTi/a0qV6zMg9i6Kt+7zJ/guMczqdPindb+Jict1q0ImnpYZ0ElI2kaBvQ16D44swCCyzi1xf0hwaKrlmgESz+/f7Fe9KLltdG+3jI4yzKKxEop50oQRQBXTNucPd/IAXv9JVxcCG7eJ4/EdIWHAycj7Ff2c0tau+3AAb1bujXYABMPzcPiM27QMD+ovOEmy1tnBtk2wmjq2Rr+7mfTPetQNoEOFTj501cTfnISDMpYwK5wIOcWTS8OnluuocAHkqWkqDHj7boLgzvZ+ZWS62oj5+XlI1/Ugdlt/B4MdvMDZNuQmeFzDr6FK3tv0xaXMJB3YUeeUZz1xdZeN43vOcmeFTFn9RRkps2mbkATOgo=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(356005)(86362001)(508600001)(108616005)(24736004)(6916009)(36860700001)(966005)(426003)(7416002)(70586007)(54906003)(4326008)(5660300002)(316002)(82310400003)(47076005)(8676002)(336012)(186003)(26005)(8936002)(2906002)(7636003)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2021 17:59:44.0951
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fe1349ef-f5a6-48c4-0d16-08d97f8516f3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0226
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 24 Sep 2021 14:43:49 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.149 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Sep 2021 12:43:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.149-rc1.gz
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

Linux version:	5.4.149-rc1-g0e003dbb1df4
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
