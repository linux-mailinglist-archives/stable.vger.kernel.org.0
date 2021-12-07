Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00FBF46B78C
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 10:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbhLGJkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 04:40:08 -0500
Received: from mail-dm6nam12on2085.outbound.protection.outlook.com ([40.107.243.85]:20513
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233421AbhLGJkH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Dec 2021 04:40:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=St9O3AW3YPw+xsHcHdur83HdqJErEPl90kwZlJslcR/qLAnI9rl1sC9XExdHWg/BQPVZ+0sJOOSHpSSHlcdcI4FQm6anQKK2vZ0mYB1kANzz3w9OkujD0i1ryoC9KUDtKdglomzsl7SUAbdYIRwUpKEBRymRoO+I/tatCoaWjLOaLnymLSYnyaO6JASuGehhmvFQ4OT2MqQWFtVrLGaT2NmiEPe3MSIu10WYcdntzGDIfRNu5bgxllFYGlsXPC8ALuiQW9CpD9sLXbZJWRraZmPoe7t28NybKUsJYolJzIJPrqHQBBwxPaWv4cbKPoJgUpd0BdkXvKNvXndFXpQ3RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SC7W3CCfkg73U5j/tI2/whf2CRGVRT7Jh3NbTAJ6MDg=;
 b=NfJxO2zN88b/dpnwgJPNNIjH5zERzcHa7SBwiB0A2BYC2uljSS31MB6vU41aQHI53DKSTXZeMKtj2KeJXe+58gmIfXxIfZXmD8QfC/sOQIFa0Lxn/h4H5zHiyzRFLdthIn4EUiJ1bfLYxtrEIHccpCopRRjcQ5Az4wBFO1wPQUkC3DdC0wh95lN8eMmMIogiEUGel5z/ukfQdcWH+aBUaeTmfZU+K8CyZCuI/9Jz/oMhFFGbhWaaCCMEqDNUHd6grNqO05cHfmNrzdhoUYmo8M35hzf8edUVPZs9d0zyxRWhhm4waKR/WbqAirJphJuHWBQj2yFj9wHiNhi10oDkPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SC7W3CCfkg73U5j/tI2/whf2CRGVRT7Jh3NbTAJ6MDg=;
 b=EP9NUZ/sTq2fjd5xWtaZBxmqEduI3oMqTlAdRf2oAfoRRM7SdsknQZrW5mqi72XX3A/0dHcAtueloO3ib+9EnHo2LMhJxFUHuKBoRAOOcizkJOqPPE1VdBfmTVCZ8zi97R78DilnJH9410P+MTtu35D+Mr686ASQKK2UpMqYg94w30XhVsAi5aPn8nKGeuWOqd5xHFbDujZO1oX6y83fzf0bVMc+cbVO0Yi2lTYeHxC4ZpB5VVP2awgA6LWtmhQV5Hwkwo800OBv5n2C8ABCnWAINf0DReyLH49jElIzYpRvqwJSRP9/K2NOxNJ5tJSCC2M1NN73oNQTZ/HA0HLDcg==
Received: from DM6PR06CA0010.namprd06.prod.outlook.com (2603:10b6:5:120::23)
 by MN2PR12MB4111.namprd12.prod.outlook.com (2603:10b6:208:1de::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Tue, 7 Dec
 2021 09:36:35 +0000
Received: from DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:120:cafe::e6) by DM6PR06CA0010.outlook.office365.com
 (2603:10b6:5:120::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21 via Frontend
 Transport; Tue, 7 Dec 2021 09:36:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT055.mail.protection.outlook.com (10.13.173.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Tue, 7 Dec 2021 09:36:34 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 7 Dec
 2021 09:36:34 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 7 Dec 2021 09:36:34 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/70] 5.4.164-rc1 review
In-Reply-To: <20211206145551.909846023@linuxfoundation.org>
References: <20211206145551.909846023@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <58165e64321d46a4965589b70f623e1f@HQMAIL105.nvidia.com>
Date:   Tue, 7 Dec 2021 09:36:34 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ceb554d-c2e5-4da0-0658-08d9b9650f51
X-MS-TrafficTypeDiagnostic: MN2PR12MB4111:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4111165037F1ACC9C6754054D96E9@MN2PR12MB4111.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8m4XKIULbv2tiHPvLKBdj6Fo4SRnG0uT61luuxwwZQSKnYhdcjp61myAJRisKrnnrlsP9uVpTdyB/S8aG6373yJJfcuXMXJSjSvmIzGVYwUd3nC3EFyFX/Ph/MiKwHK8m2PHhpW8W6MdYjmygKMQysOKHjZzgaq3JuPJ8hGxqzmXv3+R8Cf8U8tS781LTT6J9OCXuLryXgkTbr90bAG/YttrlyBwMgdB4pZYZdojf21UlkucKyYIlEVIku9u+Z2sMcPJ+fbBwvI2Ta2gBHCcfsmI6rs9ISMl2DH4OxHFKpvo4GsfjIF1asWY13Xs7DVGBnskQ6CaPfwhYrNrfZGK+ntaVey6GkGBSHpEXMhNLC0K7QNAgnIF9ibWgtRmqWMGmh63PqnnquCzgbxfz5S8Jr4RBmQ5lcfBiuo2yycJR//T8+5AToyLRkkoF53puVejKr0Tfh6dZXvcy/Gvr7kDwaml5ZESp/ebMhn2HgRmTOtGA3z/rsMbHnUnjOhlGLutW20ipoVgBuw2/xDCMGXikBc/XWkps91w2DeMIcdt4rmvouaLek0f3bfM43Fa5fEsCVvgnp6tQpidXPQGGQUEEZjzS6ja0XFrqJj8RS6tInJdvHD5K5WO3blh+dmJFSixJm5ye4H2x5rlpvKQywrjOTdJksUmGhpgyPfGWHTJwI1bwQV37PJGN2X26QZLxKs/XWGC+0oOicF9QregLLZNepNhmqBJEmG6dubV9vrtY1Q3RBnspyFLuzqOtksSNgi3IkTDki5cb6H9m9+iimL6HPuIzcM3vVAEVBmxjeUd7wqrc0X9YLHgFohk7b656CZk45p20fzqNXwV9i50eO/EBY/k3Y1w/rfdpq9G2X4ksl2x9kR3dEr5FkyRb41n3ync
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(36860700001)(108616005)(24736004)(5660300002)(6916009)(336012)(70586007)(426003)(356005)(40460700001)(2906002)(7636003)(82310400004)(8936002)(508600001)(8676002)(70206006)(86362001)(4326008)(316002)(966005)(47076005)(7416002)(186003)(54906003)(26005)(34070700002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 09:36:34.8345
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ceb554d-c2e5-4da0-0658-08d9b9650f51
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4111
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 06 Dec 2021 15:56:04 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.164 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.164-rc1.gz
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

Linux version:	5.4.164-rc1-g5d289daa9fc2
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
