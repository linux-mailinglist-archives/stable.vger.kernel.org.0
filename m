Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF82426DD0
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 17:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243202AbhJHPpw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 11:45:52 -0400
Received: from mail-bn7nam10on2067.outbound.protection.outlook.com ([40.107.92.67]:7137
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243274AbhJHPpg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 11:45:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YL6eBPf/ww1G/UM3gSnP5s2XV4cgid2mVKhDzAclQkoDP6BETYfXsPM3soSJ7Qrb7RigFkEBPJW1efIJg1Gq5kJtjDVWFg+mBmb55rqvG58Z1rj2HCN7l38Wxhi3uouwgerOSO11/sSnUu/R7lnhmMILGh/rRuh2jIxCqEoA81kBAxbtcm8DbXkpzpjvagXGyKIb8krNiiR2n1a0/lJ2u150SNyHUNMw4ERQ313KePrFmghqFDXAj65ejKTa2LIOeMgcNFm9+1VINg+ODOMlfQJcoc2tHeN4wT6X+kuayO/ZfgbkxudOsYC6/2ZlIHHIrNwCtoBwBGXcnJvB21x36Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mL6BuYkyzcN9OTZoQus4QppnqUpcQr3fJkMq7Al/4Ns=;
 b=T38LgpIzl1iUai451kOqnBXTqpx+9reJLWSxJiOtQ8g/Vb8AFT1UYJke4m0TUftktVMWJEYHYd7xz9daNb5Uk5E6Ih7ZGO74USAOP6YmkbYi7/VmWaZUvHK36Ne+WTPAsFIgmzLLw/4vIYN1yZOUMmJkopapi8PwPZX5G7Dhdx/Hmt7p+E62Ipd1WkKJkuLA7PgIMZHJ68XEddNVA2wYYUkEqeNl8hwwCl1qtUEPB1t1srz2lAKbZ1985rOmwvEXyZ7M19sWSI96u6Dk66iGg/Mva9W5hPldQPFP1Xys7B3aKj1pjcQVCA/P99Gqeh2F1Jjz69tf1qkYGI/N8soFqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=none pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mL6BuYkyzcN9OTZoQus4QppnqUpcQr3fJkMq7Al/4Ns=;
 b=atZXAQdUCZnvcpAer75Jd9KPRjQtIJ0cEufpHEVDD4p/ycgt5SBRQOA9RzCvR0F89iNgQFXWbOTGXDrtNoErsNAARNh3wV56hb76pOcNBD9XEYiDfbTz5cOU3EmATxCc5VV8CxFEtEJxefa60BwSBCX9EqucJBlaE6sCvye6cuugi10zIHqGAGI40IKDE/ACbuRhsuVgsOoYusMwta/6tFfHyLTmUfggRDYZHu/CtRDV/EzV24UW2q5lvxs2b2WoHxP/g3K1pkI1WOCe1bj8b8qEbv/6tPI3NguTdl+LI/DdPlDYaKt0vquGfHF53cz5iEv9N1ujhfxQCCL/RlI2FA==
Received: from MWHPR1601CA0011.namprd16.prod.outlook.com
 (2603:10b6:300:da::21) by DM5PR1201MB2536.namprd12.prod.outlook.com
 (2603:10b6:3:e9::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Fri, 8 Oct
 2021 15:43:39 +0000
Received: from CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:da:cafe::6) by MWHPR1601CA0011.outlook.office365.com
 (2603:10b6:300:da::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19 via Frontend
 Transport; Fri, 8 Oct 2021 15:43:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT066.mail.protection.outlook.com (10.13.175.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4587.18 via Frontend Transport; Fri, 8 Oct 2021 15:43:38 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 8 Oct
 2021 15:43:38 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 8 Oct
 2021 15:43:37 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Fri, 8 Oct 2021 15:43:37 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/10] 4.14.250-rc1 review
In-Reply-To: <20211008112714.445637990@linuxfoundation.org>
References: <20211008112714.445637990@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <a118a4a418da4aeca987738ec12dcf2a@HQMAIL111.nvidia.com>
Date:   Fri, 8 Oct 2021 15:43:37 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2cdd97a-5cc7-468b-5661-08d98a7265d5
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2536:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB25363386A3B2F1EF48F634E1D9B29@DM5PR1201MB2536.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /NNxW6ZHqLqumPEg2F7kl8kBHRPGesN2fcc0AVKVyIp0PgkcXzd4Wk+qYOq4Rm7CXw5GNStZxs+iyR0HoHP6FC9XONJZa+z/mf+U4o7VRJH5i71K+UFSeCQWoDGDG0ayVBjyNh3tlopMN2jWd+DrdVEG948jpgNmSrqbbUvTbCSn8HYI+Kx679BT2isKw7UtQQSomQZ8FB9LfyyWLHs9tXrCWQ21FbGdn/J8QEqUGMHhhseSGS6qfJgK1YlLiXPLWw/9ynsXKrUqqbb/zRGloj67v0ugw2afBnV523UnJF/Z1JQR8G4c1pBlOJ5WbpmJj4cfCQ9lhF0Rzi65EPJw4DwsxntIPqGqZygj6Xg6gdnKxCFk7phF2Ttwpx1oznd97Zysb7eDEmSzKjQE/ko18W+Sj2dLmKcWjxgCrtayPTHcXAWGRPehugZRNkn3UtW9CibJ2hG119KkAA/+nZef1ugUEG7YwTuHW7bvvpPqsFoW3ct/nQQLfVauQiJUZD9GpvPaa+OJ8jygZ9RHbO1gStkRNYjlEYeaGf3T68s78/gOxiAeiBIvIzFWtdnwx4oB+pxOTvSPDKIjbGhLVcmyPIwy8XAWq1iJJH0U1Tz7xfb/of2zyFJIRVhKZBWiNC7mrMPnfaVQ/E3ySL9GckWB0tTYbDEEQci0eCX81SsaA/Lpkc2Q/Xf6zm1jJMSkJ9U/gT6hEm/6k/wxEeVxAd6do0QYuYl28o4HPoqpM1Wiop+Wz0ushY91S3+SyRq8SkwQdSS6+WdtoB5si73G/I1dipVejOzIXFIJkLnFMnr+0Bw=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(186003)(7636003)(4326008)(8676002)(86362001)(2906002)(7416002)(54906003)(5660300002)(24736004)(108616005)(316002)(966005)(47076005)(336012)(508600001)(8936002)(6916009)(426003)(26005)(36860700001)(70586007)(356005)(70206006)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 15:43:38.7653
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e2cdd97a-5cc7-468b-5661-08d98a7265d5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2536
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 08 Oct 2021 13:27:41 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.250 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.250-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.14.250-rc1-g7d769cc629ad
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
