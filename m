Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF03D3CF6E5
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 11:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235882AbhGTIwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 04:52:18 -0400
Received: from mail-dm6nam12on2048.outbound.protection.outlook.com ([40.107.243.48]:17445
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235369AbhGTIvy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Jul 2021 04:51:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WKMbdLL1Sq4FAfIrJu/dZydaoYjSrB/4Mg24JDdApTQjFD3XON0Imhasowu+MggA2T6GWKoO+Ynj74oQkAQxU2L3sXFOLC+mR13JKuN8p/58tQeUWjc3jKS9GKHJTd7yZDw2HWFrt8CJ7wn2Ob9Lh45zTeRx6zGaXQ3QVf827WQWhpubPuHdx/5hzA9/Wx33bvPhTkEfzq/6cSunbXISnFLwhQXVPEvB8Da1ziB5CgJo0dKg6WXK2mjihM76DHtbn3vnIdzCSkFPiF8vHVM3CRNEr83G//6z0R8atyXJeOtLftLyiKeJIwfMJvqUsi8k+/ULRnKA/JH8h4GlILzHZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xEou1QJlNZE7Iz0wDhkRHh+x0QXQa1taDVOzr0mJJhQ=;
 b=LP7zzhxe24OuyssjKPKZWXSFf2g3hiW0/AzX2SfRdrqILg+vENNIG5psaVKXfqVIA0VvBd/MhXwgpadzN35vsJIt4DiCVBtisdUisk3OWe45VM9e2m27YTEyHuN9Non+6qwyY57LXb/XqRGQUJKPwAzdT/SJTdS3YCPiVU8EXzIMrQAOLl2AbIm66SqaLKj01pJ0/ceTng7yEX1dv5I21mf+CVtEXNhqMpxnkOtfZ7WRnnVMT/rMfcConSokYQSweMupdJd27S0pGwVQt2sUtv6EkzWRiZprApHz8VJmCHVgBvfabFL505GqOV4F88tvbWVadDNW4NKPWjDsVUE2Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xEou1QJlNZE7Iz0wDhkRHh+x0QXQa1taDVOzr0mJJhQ=;
 b=H3XO4vO7qECL/auu36qgfSVTFKzkj5LbmKUh7UAT6pMKgCHfCA4gQ55qgepVrGQCGiaRnlhdcJutyPFdyRfW4gx/mhrpYqVDtH5JaGSQ3qYigel4AK7Xv/HVX7/sIpmcKPsqxhTUh0rWT/zApdW6XutHst4ybkU/slIvHp12vXoj7WMttA5MnCruSfPnOOmerf1LfRwxHypADe2pWpvnidCBwdDt8plSGeCNI0CPcETgiCRqbLGerF3FxbwNxD9yodQ8OnS+uuCWDzaYMbga9yfi7eJ8/xRfKqDAPSeNhBOqafZMfwFqu1+4M48PD47ffW1zo6ZHqk0AwoKWEIJr4w==
Received: from BN7PR06CA0037.namprd06.prod.outlook.com (2603:10b6:408:34::14)
 by BN9PR12MB5130.namprd12.prod.outlook.com (2603:10b6:408:137::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.25; Tue, 20 Jul
 2021 09:32:31 +0000
Received: from BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:34:cafe::47) by BN7PR06CA0037.outlook.office365.com
 (2603:10b6:408:34::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend
 Transport; Tue, 20 Jul 2021 09:32:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT047.mail.protection.outlook.com (10.13.177.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4331.21 via Frontend Transport; Tue, 20 Jul 2021 09:32:31 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Jul
 2021 02:32:30 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 20 Jul 2021 09:32:30 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/420] 4.19.198-rc2 review
In-Reply-To: <20210719184335.198051502@linuxfoundation.org>
References: <20210719184335.198051502@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <a6a271ee9cd246c7ae444c2612bebeae@HQMAIL111.nvidia.com>
Date:   Tue, 20 Jul 2021 09:32:30 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24fa57ee-7abc-4472-c973-08d94b614c4d
X-MS-TrafficTypeDiagnostic: BN9PR12MB5130:
X-Microsoft-Antispam-PRVS: <BN9PR12MB513050DDBAD6631003CCC405D9E29@BN9PR12MB5130.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u7IYGHM5Du6BZ9LJOsp+MiCAF7BrlgcKcPx2sGHcx3LfcewY4Afh5YZC0zWI19p4NUAJ1+qsEbXE/jHGo2nRgqXo44pOygoVSvuIfjuyWAhscuc/xF7e2ZEke6EAB6Zd6zK4B1cNDYIeIjiolDYek2cuKmQ7TxFojRMpiFOuxsVdm3GF8BuOdLk6KrVj1TO+hWG2qr5VTpDFKAxJe39HVb+NivF5LLuSJLgL8oe1iPBPrhMW1qggJlOjF/39G94CySqC10iE5chWey5mI9igLGvqSbdl6i3NJTnIEKFEZ84kOXSvHCz78VrLtnIEHuo9ALyVBGDmshoJRsV39HQNik03B0TFRMspUottGNECDi1DMNRBBsfzMI76qCp0ng2NTp5YhyoSdv6hfcXA6JSyaoAju5aEb3H3+VkpGhXX+LvDdQhagOh+HRK2s9EuouMfHljJMfJAky1it7IPh4+ZrXhv0DZQCN/DZJn9JLAdCO26Fo3+i7Kuewb50aa9vdIWB/R5X4fMplRDdO71Xas68fqamWBKWaN1WIdX4oU2YkeLpBAoZFxf/EFKpngI3YHOtgkQ62g7BJW6CeVFyaYC1Sl3NNIwNpR0/UvBNhEoM7h+aVxBbOtrmrgyfEKxAvunubzlpuQQY9dpNI77GCRh1G6yBwpIJSa/sZUuz60CO1O2IZSwGZmVL+yGJltUAsGhXuc17lR6h7AT5eknt80WvphmK2qnYuxgKIYaydfDWqOm3JLVsHHjhcMDy0447FicikknK0BfmM4cw/9AegDhTyrjbl/VWHGaO10Nxg3q+kU=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(136003)(346002)(36840700001)(46966006)(4326008)(70586007)(70206006)(478600001)(54906003)(8936002)(7416002)(8676002)(7636003)(82740400003)(36860700001)(47076005)(86362001)(356005)(5660300002)(966005)(426003)(336012)(6916009)(24736004)(316002)(2906002)(26005)(108616005)(186003)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 09:32:31.0844
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 24fa57ee-7abc-4472-c973-08d94b614c4d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5130
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 19 Jul 2021 20:45:06 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.198 release.
> There are 420 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 18:42:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.198-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    10 builds:	10 pass, 0 fail
    22 boots:	22 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	4.19.198-rc2-g9ec1965d618f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
