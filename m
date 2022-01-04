Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C43483F6F
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 10:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbiADJxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 04:53:18 -0500
Received: from mail-bn8nam08on2086.outbound.protection.outlook.com ([40.107.100.86]:5725
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230314AbiADJxQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jan 2022 04:53:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cdpSh2h9X/0UwU/JJIzgyY47L/0aQ4GCe0eBvB4q1rTCUuKTs80KkBLD0tCxGn0PdBauFuRbPfz/DCOL5BpeIjS7t/WeELDWzNaPnaq2NnXjckhsZgFyG2tZZSPN7d9jVnoPkfeITzmwfaedjpgfSCfUfbhnbKQOdEEuGd0TyDLl/MRKDam5e0zs5Mbd8fhAePao6Ot1aj0VirJExVaAvQrOPE3aWJoIgY+M4GUMrUYYr3xx/9GaaWgXeKm0z3TdKrfARFkZdabutla7eZKNHj3Dp00uQKJgNnZ5ltZqT/m3C2nwdunf8PyrfTpa2JJ9OmwHbE7PoHsIjDM9uGN88Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vlmFHAiU7jQhBaKXd/tFxDrHQcp+gLDeffrP6ZYGfQI=;
 b=HdSYHtMlAvIOXnTQ4ggEA2Oh0NhZny7oZB3cIHvsywQZbFvajAfi2pzVwU+qsCG/QUKI+T2J8MHsMW9uZEnI4XqS7AgBJK06C24Qo6HvGZsN8wibfE9I8nkmnUCSKnOdEwOQvZwGSkt11z8SorOzNw9oBDSVxH+rIxPUneFv3e+hUsy1CwpaPjQQpJFTB/6itZPeLD+McBKw3/r0Z+zw1B7VudKdFW3nO7FyEltld2o5Z9Ppc/O7Om6Z3ar7JQP7p06b4W1di0aUVLfArKNhIj+ECjFtLVnHYOejfxolF/Bh+sr2UkMdibF+kmbDNHbtLFzmSTDEhQ5oIlDmu9BXrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vlmFHAiU7jQhBaKXd/tFxDrHQcp+gLDeffrP6ZYGfQI=;
 b=JNxvVfsQr6DiEgWiyDCqG0z0ELlIwFY77CASTgpFo2FN3Gs6q2OmIv7Mzmy5QAqqh3LBVizcyrTM5hEK6UdlSsIBKnqcI6OnVYP2JeheLQgf3DrecV9tCuFfRQzfqyXWp2Wyq0Gw4wi7C+n5LMgcaUKKZJ/795McrlR1dP8SIGJ98nBTG62zBXGaM2wrtpkFXeWBHPnO2xq5VX4T8ATH1j9dpl+QsNUUEnHSnc+jNGFqoKlaWQlVzfcn2srgy68mfeMrtVtye1WDYTmYSgZW5zbOm4bwL5F5wIUyBS1yTeEkt43XKhwMDjdrEW8e40FWtSRVVYQWa79bEvmDfqXJVg==
Received: from BN9PR03CA0357.namprd03.prod.outlook.com (2603:10b6:408:f6::32)
 by BYAPR12MB4981.namprd12.prod.outlook.com (2603:10b6:a03:10d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Tue, 4 Jan
 2022 09:53:12 +0000
Received: from BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::3e) by BN9PR03CA0357.outlook.office365.com
 (2603:10b6:408:f6::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.13 via Frontend
 Transport; Tue, 4 Jan 2022 09:53:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT018.mail.protection.outlook.com (10.13.176.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4844.14 via Frontend Transport; Tue, 4 Jan 2022 09:53:11 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 4 Jan
 2022 09:53:11 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 4 Jan
 2022 09:53:11 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 4 Jan 2022 09:53:11 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/37] 5.4.170-rc1 review
In-Reply-To: <20220103142051.883166998@linuxfoundation.org>
References: <20220103142051.883166998@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <9207e9cca72540ab87a577eb8e961d6c@HQMAIL101.nvidia.com>
Date:   Tue, 4 Jan 2022 09:53:11 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8009ddb5-2c27-454b-cada-08d9cf68053e
X-MS-TrafficTypeDiagnostic: BYAPR12MB4981:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB498172327C62513EC09E6231D94A9@BYAPR12MB4981.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e/Grlrq/ynfPzssu94nGMDbav5nb0oGO+vcjcFujuTkVZM9SmLe5U3Nm8KpOOXLiSiiuAcL4aJg1bcftl8v19YjYxH1tGaiQNFauGTkjHpNHqX8MlHZ/5Nt78uqZUQjKzuvs6uANL9bqdmHoqnv6uxSG1407kz7wG/s3szBjn30BaOBbIBBtt3XmnZQddLJBijQ1ZAtf4JR9ZAPJw36bPzInAp37K6/GvJqTDRbU1kZPzrIykS40YepV70qd+mZTKKOFqoKUNvgv7bug/Ik5UHox/EZvd+JunQYeyvcH31sxSDXI76ME03GIExNF4iVOYYpl7nAZXpDToBmDSCeerKcXpiJc1n4Mejn/GW6Ckteul6SgkbOrVBRZgL0SDTvJaXBDRmOP6yCTHcmJy7xDwmbywEU68IcpgNrwpQSfqs+05WCURaexM3oI7sirCGk1BybHAICrcsLmnrGktYDAk1bFFl4RNsDAdJ41lq6NPhbULx5+zFIRtJ5ZXPvXhmFUOeLvbDUNQRKmSHfbaZsSfl2A4libHkgpzbhjD6CoWq3MchrT2xF0w/XZ00zr5JB6kSJ+nLo6uTCwY+mn0KzUVQ0uENOPB7Sp1dcHUK26nWr+Kcs1hjKP8d2KIMe2p3VOFa4cUPcEUI6rIh1gRR3gt/5hQzmInPYrFOvkqbzTl3j8nISL7OTiSbY6q/c45ugnjFlfzaLQmDnpvFmtRi4Z+ff3/qqe/UiyJIJMUq5w+zwURSnJEa8tWV63K7WCd0pjui+vGd4byFKRWgmt6VfY3Fyar+WlpNmSkfRfyHIuBPPoPSPb5E0fWmiJA3Dmevd8q45uRQJcLaHmFX4UeadSfrQcOaQNs8R7HrDkuVcBRe3d69lMAGJTjsSR6BCie6NQ
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700002)(46966006)(36840700001)(26005)(82310400004)(356005)(186003)(54906003)(24736004)(108616005)(47076005)(6916009)(336012)(81166007)(5660300002)(86362001)(426003)(508600001)(2906002)(40460700001)(966005)(36860700001)(8676002)(8936002)(70206006)(70586007)(7416002)(4326008)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 09:53:11.9623
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8009ddb5-2c27-454b-cada-08d9cf68053e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4981
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 03 Jan 2022 15:23:38 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.170 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Jan 2022 14:20:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.170-rc1.gz
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

Linux version:	5.4.170-rc1-g41ba4f080544
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
