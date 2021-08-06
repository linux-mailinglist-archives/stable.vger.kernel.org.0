Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DDE3E2CA4
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 16:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239864AbhHFOd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 10:33:29 -0400
Received: from mail-dm6nam10on2089.outbound.protection.outlook.com ([40.107.93.89]:19392
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239972AbhHFOd3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 10:33:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OICKAgMw3Z61YVc3WMM8K5EkQhIR9+GTlcy5mZZXh9hor3MzZtz/l+4e+HWtt4o4f6ypAMLixTDway/z4V6Lggod8YwY6VtbcbGS7E6dz+JkOTBORSmxY4FNo2B+21AvQb8D0Msqv9TftJiPuzdpftPoXOjqLj7phnj+Eu4OA5YYiOiIoewgHxAhIlWjvhufH9jkNbYzN3kr04+I3oN/zz2FRZTo3U70jpv9x1LniFVnKdfEWMKszi0BBuUwPuwyJ/aVtAFDaf3GopQJXg2f7pi8JSUiJr4C7nRmWrIFcsFcfiajoof6jF5FAGl5qAsJ1iKyCjKuMFXvaUlvOghxEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rGbosBlnJ37vBfiBLUAjx2TE8ecrPwQQJlZwDuM0KG4=;
 b=TlTRywDysYbDZmgYZofixkg7Z+UUGSYCusarQZSfffsTvlYdMQP1neBQId3cq2ntsn03xKB93S46y1Mgfvk7Wu3HKXZt0eSQXSPODukBi7w2wkj3U1yDBa5M7ZsHOipDpd5c2yCfY0KmkiB4L8pJmmwRLaiQwDhKgeOIeemk/CIPlB6RVuxwMG0jI9bsThxDsDhJ2/y0FYdxMZd8rApDkn8D89vASORraqdDd7GobiqZvh8mrBFzIHU5fxQhN40h8IHSEOSSCXtHg/l66V43Eriuuz2MUxSQAesYxjebGLw5YGBzdwQKAYyH0u/wdWc/kvmakPQhYki6vYiNLKZr4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rGbosBlnJ37vBfiBLUAjx2TE8ecrPwQQJlZwDuM0KG4=;
 b=o6Swsf4WahPQD8uggBExXGdVubOn1MIK48+DKO3trI8X7/QvRBPLJ9+0IXe1N5NfDJCuWwQlRPB8GmOk0gz2D86JSgYNZLbwQqgNEV4JVzy7CYU4u07A7cTyBymAze3pmguLbCBdpWry5Jy3Q65NjVCgHWZh5v1DDaJH5gLZ7OslBOcQ1iIMlsteLFObB8ZCszXbtXz79LT07Ah1iqXFoWP/mADZB8jJrE+tvg+wCfls7db2KYcWEAA/fB8td5e9rpsaJcrHyo1146Ax/KgIfgEXH3LLGL70uxlSylCoHQe+CJSMGG0O1ug/V6hDSpLm140nAPi3MyePOXnPlLprgA==
Received: from BN6PR1401CA0012.namprd14.prod.outlook.com
 (2603:10b6:405:4b::22) by MN2PR12MB4320.namprd12.prod.outlook.com
 (2603:10b6:208:15f::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Fri, 6 Aug
 2021 14:33:08 +0000
Received: from BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4b:cafe::fa) by BN6PR1401CA0012.outlook.office365.com
 (2603:10b6:405:4b::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend
 Transport; Fri, 6 Aug 2021 14:33:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT030.mail.protection.outlook.com (10.13.177.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Fri, 6 Aug 2021 14:33:08 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 6 Aug
 2021 14:33:07 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 6 Aug 2021 14:33:07 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 0/7] 4.9.279-rc1 review
In-Reply-To: <20210806081109.324409899@linuxfoundation.org>
References: <20210806081109.324409899@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <ed98090dd988403c855d5351c302ca49@HQMAIL101.nvidia.com>
Date:   Fri, 6 Aug 2021 14:33:07 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a1fb810-d0b7-439e-e5a2-08d958e71c36
X-MS-TrafficTypeDiagnostic: MN2PR12MB4320:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4320F7E7640EA391564DA322D9F39@MN2PR12MB4320.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L73yF2JfmXaA+Jh/yZg2KVic3BxSnFScGzxN/hX2BSjPxCQ7yPqNQ2BOsrzDutCMWiL81arSR2kkzA69bCdNvauE7SpvuFQ6chqzyFSmFzaDRZr1URXoWEauMtPmL4vghZ2UbDatfHkY0JuhwVDzPsxjBuPjuum+hIjKATUb/VVgxRo/dT4JbQ1PGFlwophyvndCQ79HKbe0PJA+OLUtVXlIlzSB7TCNWZFWXL0Hf7HUXW1aI1QbCmdSRXZqA88n18bTcqNXNUhPsR3b0F3xhE01m4Wo2NUAZxil0SXPhTlguvG1sMcX1eYG2848hswGFYNy7wlzDowFfy7d1LmXVK97Qfpo1P0UNvBqrfjF3uwsM8FLHeI8ce1j2xtRKsWTiB+76zVSo/ikM0bgPPhOwMW44zryY6WxY3acJp88AIdOfEcPmRwdesYe02eBTIhASmcW09esDBepTOlzjsqBAxiL6wu69XHF2/NwD+G9FyAHxrUW9Ud3e77ZjkhIJc5NjuMkBYhvAfd5/jj/unjUpors1/WCOxkv6SztSTP/n+lLerX9WjOEkxe90xKQ1tOLgXAgWhVJfXBP13qcbvTMYRMewzvLQF2mouV/ciT8nEsP/AyTll+p8NfY+b6M3IS/ujc0juEv5MKf8xNI35v9akntkkpoCv0NIY3UBEm4uxWnCiaPJQodLVPBn2XcHWgh+oyBcSmTTevzj671IBoCCVd+Hq1lLC4+8+abF5VLOaOMm1wCXQ57zEpxdx+jNjITeJjoX3bzs3VtonO+NTESbYrBR0hidSXkWDXNe8PHAwE=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(39860400002)(46966006)(36840700001)(5660300002)(7636003)(316002)(86362001)(186003)(8936002)(6916009)(26005)(4326008)(356005)(54906003)(47076005)(36860700001)(336012)(70586007)(966005)(478600001)(24736004)(108616005)(70206006)(8676002)(82740400003)(7416002)(82310400003)(2906002)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 14:33:08.1856
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a1fb810-d0b7-439e-e5a2-08d958e71c36
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4320
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 06 Aug 2021 10:14:39 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.279 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.279-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.9.279-rc1-g36c4ea3b072f
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
