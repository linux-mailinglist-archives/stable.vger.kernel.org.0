Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A74B407D36
	for <lists+stable@lfdr.de>; Sun, 12 Sep 2021 14:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235454AbhILMT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Sep 2021 08:19:29 -0400
Received: from mail-bn7nam10on2072.outbound.protection.outlook.com ([40.107.92.72]:21661
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235206AbhILMTT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 12 Sep 2021 08:19:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PlQVbMCDn2mwkkBaQ54fjkKApNHZz2QFDUkcGTEzt01CFpd8E6LvoHh1kiFRq3zU4NyDpbZWO+GcV68EtlJbDu5umSGWo9nNUX2EhZrSmJpfKHoj80rdRZKEwRTIdCwSSCEgnYTQmydhtMBjwT+YcsdEsw72q63kVAOiiv+UkLUx2ql+iAU9IPuy4E9kU4fAHERAfvbzlbeXbuu8BNEaxPb/sWBn4XTQFcHU8JboQo12PwZXHsc526eD7VW88dov1UDG4LrKJ6QjRpnDLUMNYcODEMtWSECpaZ/qorKuvDUSjdRB4FdQeigOq44F2uD5MnzPnxZrYflf/kPAyNXJNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=qwamdC8MgJXesQ9Sbltkg+mb7N2c8sR+b1yba1ENJec=;
 b=Lpg3/CJdO8oIuncBm8V3u5jaQMdVsN85vTkuzT8nSnbNjlvJNZO+dsGlQ9bgpCTVmZQPQQzp6JUmSTL/LbvcltwKHok5KV1odSLIgPBS8C3HzCjcqfDQeJjiYXD+Ydu/Y1DV811Mu29ZYD0IdDfhgwU4NI5TZenGB5RHQnpkGwOKXjzYN05FtmsK0li5+jE7Pn+cI0HkOtgk2aNUFnBhpYjOyMIW1N5mIlh2jptI5442CiQdAEA05GuTh9CeEbEyAvAFLKc+eSnKmur2EQQSsTKg88g7hVkdh9r2Oe6keOGZZ/zeQu80Nx2acZIW0yVholXMxJ0lhPFbvm+nyErmIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=none pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qwamdC8MgJXesQ9Sbltkg+mb7N2c8sR+b1yba1ENJec=;
 b=fEqLbdOI92xH93DFY/qjZ0eLYRavIjsj7Qn0eUmbL3LWuzd42CYkOzBOP0VPT9IIEVNw8kVK2EtP4OJSj3KQdMwGFuMesdPSynoGLFPr2salv36CKF4MdpnLA+lVV0RpFUmLaWT34uWUZYiZ5PiMPD2vjEZ+ne8fkpjkznK5aEPdrOtI7zUz3QheYJvuqbhgQCmm4uCAQjpus42/tcuHsSQYa1mMD3rvUZm7xjYDD9JT4oGuErlrUOK/CW2qwtemrNgH1A9Seh1YOoVQYts2XKcKe80cWmJUYy/nQ8wIjZrEPZiuemI81NdPGbJS7BaGyBP3feP3/3rOqFABdG6Ovg==
Received: from MW4P221CA0002.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::7) by
 CH0PR12MB5268.namprd12.prod.outlook.com (2603:10b6:610:d3::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.17; Sun, 12 Sep 2021 12:18:03 +0000
Received: from CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8b:cafe::8c) by MW4P221CA0002.outlook.office365.com
 (2603:10b6:303:8b::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend
 Transport; Sun, 12 Sep 2021 12:18:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT044.mail.protection.outlook.com (10.13.175.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4500.14 via Frontend Transport; Sun, 12 Sep 2021 12:18:03 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 12 Sep
 2021 12:18:02 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 12 Sep
 2021 12:18:02 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Sun, 12 Sep 2021 05:18:02 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.14 00/23] 5.14.3-rc1 review
In-Reply-To: <20210910122916.022815161@linuxfoundation.org>
References: <20210910122916.022815161@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <a33d0917e031471ebdca1f8bd55bf853@HQMAIL109.nvidia.com>
Date:   Sun, 12 Sep 2021 05:18:02 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15c6b26a-c007-476b-146c-08d975e75e74
X-MS-TrafficTypeDiagnostic: CH0PR12MB5268:
X-Microsoft-Antispam-PRVS: <CH0PR12MB526894782E69BCDA03D07FE6D9D89@CH0PR12MB5268.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PeaOTmOSc2pTl2YX73rFtQfVanqiaPh1CGz1h9Gz4o4UUfq1oaVx/AYRlB0Fj+ka2DxSpOsGE2gV3JO/IaIP8pQrTLyubc4ABUfrsb1RaJ5TC2wS66HuKBsmhCuj2Qb+WVDxapRf6VOuT1G48V2lUq2FMd7V7XDMO1ua7NKyyibq0D/sdX9z886Se7CLfy1h2aSRQulkHi8CgkaF7+rGUbaqiVo47tA/Hy1BYAJ2rUQywYDzqlJVPPI7eQT55jogn4RQEm8foVMjrSZ/oWAtpKPhaPceAFAqSV9wKsvSyNcYW1exvS80W52PGe+061b/EEd5p7VydLpbvy1tiML1YJDydpfp17DJD6rEVhfp+KiQVO//Ukr3AEmmPepzlrR8YQaOK8n3gEexgl/JMjA0IDI5ScjZMgneE3UiuPPeNmsLd7/2vig9TrItRy4e8ZbZVhs8XXAnUcMdoXvkczQagxtIFiw+UaaLqnJ+3nLK1Gk/kwUdQsqfrBZEuE/FtanvwmqlDZPuUA1mrtlwJSLpWETdaLCgkEnRt9q3DJfZuJkVRRF0iypXz4sI9LssLZRESjqk8WcG5j0KFEUIN9VHweUCznu/+ibnaMXCFUJ+0C9cwe0YnCkwG7Myb81Jrp0K1yn/ze2laaJUbia+JuYvX47kvItG0bfRCdAvf8OHJoc9QAy18aUlZoj+CDDgIj3bGJoDYh3SzXftonrNg/69flXWnZqC6cyZG/7kROWK+da2K7zeHFyfepYd5VuaUM5HoZcDj/UbZJfrDKCg14qsRbq1ym99DBsklRL3PBsvNyg=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(396003)(346002)(36840700001)(46966006)(7416002)(7636003)(478600001)(6916009)(336012)(966005)(426003)(356005)(86362001)(4326008)(8676002)(8936002)(186003)(5660300002)(82740400003)(316002)(70586007)(70206006)(36906005)(26005)(24736004)(108616005)(36860700001)(54906003)(82310400003)(2906002)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2021 12:18:03.1057
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 15c6b26a-c007-476b-146c-08d975e75e74
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5268
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 10 Sep 2021 14:29:50 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.3 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Sep 2021 12:29:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.14:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    114 tests:	114 pass, 0 fail

Linux version:	5.14.3-rc1-g08d4da79178d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
