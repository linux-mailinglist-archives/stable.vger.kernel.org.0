Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F754133E0
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 15:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbhIUNQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 09:16:23 -0400
Received: from mail-bn8nam12on2040.outbound.protection.outlook.com ([40.107.237.40]:52699
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231658AbhIUNQW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Sep 2021 09:16:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dk8UCSVOrrhcEvWt/30MP8fRAGBD2d1TaFLasxiPNPqX9WgTM6ioIrGZX50zkuWWBkXBpOoNmmdMWxVpB4p6XOcl5OuREI0oA1U1Tc0woLHMKR6+QiyuODCjboOgsHU0Bc3paCwBdZDlDwAwDQc/8p8Iyc4Xk2JJv7ZkqqlIOpQ8rgVlHv9MlmNgPOPmw4Fd12DIe+s3WInK4r9v94a+VK08naJ/pSxwkx27U1iweWJ0O8EuQYG4mHWjd9aj3KcI8jmdvLiRpKXK0d4+fKj4gNwdwfn1wXn2gQRcLW1zYV+G4pEyLDaOKSIv/ujlvlqBJ85kbVWXrcf7No1Z1q3yfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=13DRxLHsUYn8Pv47+5J2aemHst6cShmH8SFWhu8imfA=;
 b=D1ScjvmU1sHpEZmtyUxZLvMW8SvXx6hMU79MvbNk2qG2UrmYKijwd6KtSNXabhI1xQAG1tjylkhBZaBaOtIfxCIcBTz40jECL66p/2c0GBuxNdifSmCSNsIPD7Rcxp0KGMlMwKqZHN7z27zykxCXQHaC+lbwT1zZZIShrL23+8A49dCYQfg7l6uUIAzucP0ARE+w2JhZ2qJg1rg45mD6JYgV7iduhnH1GGc/3Ws8f8W8bpwF5GX9kdPl4UbdFRXRqYuen36L6nKB73ogTi0O4Eit4p+poyj1YklvLpSSGnbTFCCvU30OyqlAgpX1A+D1vYVs+1SA10V54GuZSurT4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=13DRxLHsUYn8Pv47+5J2aemHst6cShmH8SFWhu8imfA=;
 b=LjqCsvK0Kf11dCN5mnM763BGunq0Npw212t54kkW2wwphn5GJ8V4c6zWJnXK+ZlZaVqUrQRFJIAsuDW4K95hXFqM5Pni2TfeCDacpPm2zBEAV4bMT01saOHRQPzvL4NLI0odm3YDRxkJrA/4dc0KtCnROx5iKJY3eu5gARBueLxoYtoFRyvykwrco/zyBmvkZ4neQFkGxc0qbzyqg0yp3bFCsdJFcdOqSZPvg1Bp8PGhqHDgMY/JVnojPHE+OYcYzH4h0BqPMdbLMJtDAee2myaMjz+b/qQQfVG/TOM+OcgIG+PDMqq0cGhe+MAyWeYVC3i5OgKZMJZbp3tE347log==
Received: from CO2PR04CA0149.namprd04.prod.outlook.com (2603:10b6:104::27) by
 MN2PR12MB3935.namprd12.prod.outlook.com (2603:10b6:208:168::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Tue, 21 Sep
 2021 13:14:52 +0000
Received: from CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:0:cafe::bb) by CO2PR04CA0149.outlook.office365.com
 (2603:10b6:104::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend
 Transport; Tue, 21 Sep 2021 13:14:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT054.mail.protection.outlook.com (10.13.174.70) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4523.14 via Frontend Transport; Tue, 21 Sep 2021 13:14:51 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 21 Sep
 2021 13:14:33 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 21 Sep 2021 13:14:33 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.14 000/168] 5.14.7-rc1 review
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <c410fe6223d1485fa3884c1e8e109f27@HQMAIL105.nvidia.com>
Date:   Tue, 21 Sep 2021 13:14:33 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75fd46bf-5f9b-4ceb-4f54-08d97d01cbe2
X-MS-TrafficTypeDiagnostic: MN2PR12MB3935:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3935BFB7524CE712699A70C0D9A19@MN2PR12MB3935.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FcTWPfsb254tw9mA3TZDoG9Zl4+YEMIZHr4lItcWxNUeMt8Iko1MvAn85pwW5ar3rEqx7O8IaPFjJReeSpBEHjUHLp5BjyXpI5SjGi3eJSDWUfVzCxGt3tCYqW0CTmjse+twXWvYbmHMgRj43dVHLdcNYOZF++zAv50rpbSfaXkrxoJkv46Fie9csi9LbbMvTAnZw8bdRIsfJ6f+RkY42h4zvss6cSu6DxkPSe7zaq6s8NFlubhttXeOfKRicVL3+IWyxRhCU42BczCADO54KoP+LaCJpeiSn+3qRBkfVAYEuTIP+2dRXshSqxZCbh6qbPIPE4MEFVoJLOF3YdZ6QcnWt46MWxIzi5KnAnSjt88LXjl0GvtuYTBmMYk99Iw0pPLniKWTwqVCKlRAzvACH3JnVmoLSUJpicsq4/tgnJa11xPWO4up9wZQy1zDSgAts7F7+HCGCm3qXNhLVxoC6wrseEUY8H0e2MX6rqxFmCkOKzWRWS4C1yEH6B8KCghAHhao0A7dbxBgkyPkPz5tkbaz/s39oHZt7X2PUvyAdixPPQEElaCgdnuUoc1VYTLR39OUmmAFILrxvrdYt6KhpzMItYoYmibINhPVEvRzWpLMu4851H3E3ITQtxKOThVnrMPrTaThnwZoodRpP8nhRFKDEJSnoEvGj1xU1i0x2EC/CFJU0L6KwTDpJeo3kzsFJXcZwdqhD+DEwL/Tf0lJmBUcNEDXKHCpg74ryoNbLkc3jsxIhlJzdBPwgkmP+BPClxv+ldAxEGUiOnO4y9Q5qg40XUkdueS4nc7avpkAGOs=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(36906005)(82310400003)(186003)(26005)(426003)(966005)(508600001)(6916009)(24736004)(356005)(2906002)(47076005)(336012)(36860700001)(316002)(86362001)(70206006)(54906003)(4326008)(8936002)(8676002)(70586007)(108616005)(7416002)(5660300002)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2021 13:14:51.7602
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 75fd46bf-5f9b-4ceb-4f54-08d97d01cbe2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3935
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Sep 2021 18:42:18 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.7 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.7-rc1.gz
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

Linux version:	5.14.7-rc1-gc25893599ebc
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
