Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C766036521E
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 08:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbhDTGOK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 02:14:10 -0400
Received: from mail-dm6nam10on2073.outbound.protection.outlook.com ([40.107.93.73]:46688
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229577AbhDTGOJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Apr 2021 02:14:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bRUdaE3SQ/9Px9Vok13n86ySGswy4HbX5wpJ1PcGJ1itJuZ6329HV3UKIMyf8GKnhAy178IGo4C4H//Uv4cQXwJY3HblMkdyTQdmWvjtgqjdJMdeoNBdsTxnuBxyz/G5AvTZakyuIPVZQpFsJlfeVk8xbzZ6jK/1iOZ7cBZhfewIAvvbGUBrGG/DZThXOgxLxWAd7S3CMRg7p8Yyh2KjKYtjVitWVTs7Y9l2MpozQA2Hq59ggTbGu7navsRGq9SJCkfZSLnhvQqr/Pbu1IQeFmHJHt2KLiahUEhp4Yz+3NfqlBIzLZWEV5tU4HY6ddcMPhE5c+ARyb6OyeBbkIRXjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NSs/z2K1bpuAZQvS3t5slUvqctEjHn7Sg77viLb4GNc=;
 b=aUb8v8tFFTD+WME8I9eaDIJQxUr9F3MBLG2z/7fJOcGMKrxhnbuhWyB1kDTfP3qggrRMu5tLIGk2aWttZkPqEYNoJ6Zy8NVaJzXvDotnynqLjlDr7MH47dA/KTEa/VuQ+VJk7djbZ6oPz0z166ycBcQscd/r9u56EBdUEeIU3UF/bDiXeWfN2MssTF7fjQpQFeVtx5XLgVAySQNzMYSmix1s/PmvePjizRAmysuuT8yv9PmJFzLHW4TkrstsGBNoj15WFlJseqfdXFQmEZZ8IojQVjXk6KiPccHl0SXcYmOAFw4P4QVj8Mh25nhLohlV1Uj9BfNLDW5JwSqKv5/bow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NSs/z2K1bpuAZQvS3t5slUvqctEjHn7Sg77viLb4GNc=;
 b=fWnAPxLPzxoWO1pksU0/IbTBbzIWEv+ktuwsBKJweG8WsC5hx4fPIBkzztzzDoyYqk/gPZ382aMd2I0mgJMpUFVZaJCSGAwme5pVu+sEagjdk9X0MXipmSvm0BZML939ykK/zcToe2uJwVXcq0ENAWpmIKA98wQPJ8KymS+Hecnt4CFlAzMOj5IseIg+fpX0FlMTmI1utXLSqn06s1YItnKQl20/N+ISuQgkFc/8gp7PlBxJE/lsgT3vOmTk/uB7BET5L+fVxPlGtG52EdFvtEdHHotUQRgS6APMw/uTRCaVqS2vhlhXr1ZHMWtL0ry1ChgnVz2o++bBETwzIRpAQg==
Received: from MW4PR02CA0037.namprd02.prod.outlook.com (2603:10b6:303:114::21)
 by DM5PR12MB1532.namprd12.prod.outlook.com (2603:10b6:4:6::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4042.18; Tue, 20 Apr 2021 06:13:37 +0000
Received: from CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::a5) by MW4PR02CA0037.outlook.office365.com
 (2603:10b6:303:114::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend
 Transport; Tue, 20 Apr 2021 06:13:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT013.mail.protection.outlook.com (10.13.174.227) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4042.16 via Frontend Transport; Tue, 20 Apr 2021 06:13:35 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Apr
 2021 06:13:35 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 20 Apr 2021 06:13:35 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/73] 5.4.114-rc1 review
In-Reply-To: <20210419130523.802169214@linuxfoundation.org>
References: <20210419130523.802169214@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <58fde09491f54d158889bf6d30b7cdb1@HQMAIL105.nvidia.com>
Date:   Tue, 20 Apr 2021 06:13:35 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ae874b3-d2a4-4af0-8fa9-08d903c36eae
X-MS-TrafficTypeDiagnostic: DM5PR12MB1532:
X-Microsoft-Antispam-PRVS: <DM5PR12MB15324C35256B58D587BE6D07D9489@DM5PR12MB1532.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1vCe+w/VgQ4Y2DJUsnWVK13nCpIk5bWJvjhSwUP0FTZiYblVHwG2zpwhUT3zFlszc9k2w7X4n+kz8VPGXEl16Y4qG9EqSRhqB/ItneQnm1utZw2svwx7n43E8Ec3vlnHvLP3Q8wDUKna11CGVQXu3sDOjOzeYIXIm77SFjGOlURbHGtruPiTyk+AFp2pWTrLGqXOD5VeKD/nIY7xddh7ZxnrhuKErLGzJKpDrJ4dVLGY/d8ET/Fwrp6xoGBdLsog9ApYO/EMZ2A8LhdqiNU+Z0b2/cvJW7TQktikpkpOIXw1c1qd2A6caapMW+JyIblCLnYA17/so4SOQSeEdswd4s4DmGAMPQtug88Oo44p+drOUcXu+UmPSYzyN4KMUqx3BA7XF5qsMzdulFfQy3m2Hupci5ERYsQ3LsFGVGQUKVcU2oJeL38zY7xpeolpxXcn2a6mWVoBLT/TzTjdR95U4YoQcuf+b/8IMzHFNnzBL0lRWpuJhSnuJlpeeD1ykW+hGHvMH+ecZVC1Ra2HIC3xEh0BZEt5irpjp8QMmvMEZGoBdnkx0XWX9PuLD10adhi0eeDBF4WEefIMiJKtClsiYklFRfBmegat9K8qrF0hVdgx03naNbjfctConxBPJDQMn81Zh4ODZbenqosLioXZUnwtG+VX2a2FKNXaCa84R057nXEsEOWExoxAbeBJI/Whr+A07l5r2Gem3q/htBMAaXJPMTOvs4dzd4/hM5cJibo=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(376002)(136003)(36840700001)(46966006)(966005)(356005)(82310400003)(82740400003)(70206006)(6916009)(108616005)(70586007)(7416002)(336012)(8936002)(8676002)(24736004)(426003)(26005)(478600001)(186003)(4326008)(36860700001)(316002)(5660300002)(36906005)(7636003)(86362001)(2906002)(54906003)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 06:13:35.9006
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ae874b3-d2a4-4af0-8fa9-08d903c36eae
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1532
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 19 Apr 2021 15:05:51 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.114 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Apr 2021 13:05:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.114-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    59 tests:	59 pass, 0 fail

Linux version:	5.4.114-rc1-gc509b45704fd
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
