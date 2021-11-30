Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7CB462EAB
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 09:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239708AbhK3IqX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 03:46:23 -0500
Received: from mail-mw2nam12on2088.outbound.protection.outlook.com ([40.107.244.88]:63755
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239696AbhK3IqT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Nov 2021 03:46:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AvRXjd7fSVVV1STLlAkXbdlLOpMMExSsmbrZhOw69dqxcWRhET7LokYa3qABgkT0gC9HA8cHfTWQgdO7xUC7vIcR8lFiIPEAy3Uvy10a9mBD7I/vIyKGX0nkbX0z/FMsXzjnWiL1ZfWEJWUmxuLAbEt7jEk75tVV2VsJoHsSJy8EdzuZxi86ydMPBP60XghnD0fbsK1CC2rb8NsSljzhiYRCCZsc+3RYKw9o08M2X1AvdE0IYkA0Xr67/qgCSnOQMFCAjWUvk/DXptQ3xx8b+KseMtzd7kKuhQxUzkTXCzCxVXClQ+AHlDigOO/rfEkngCmSGx+8wLDPhYpmJCHuJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xxLplxt6VkmJLmzrmbJSpzlKoq8iW567CKv76R5VVU4=;
 b=DMMFTXWZ9fIEdYt5v6/WfGVrKfbg9watqci/w0IyG5lAle3LjrkiwZcOpuTCSXYYZCWTkvra+DC+ShR5fdLspwCjek6X6/SaU19ELaS1hdk1tfw8Op2/hRA/Xe6t74XNYMLqUiCxv5okm9vbxL2zX5bdNU5gyHi1JUCmdH+tYyab139D1OXc4r9RgP1NRoyrTaszkwysmZ4I9K2wUUjvS3akdj1YB136m1JP5B8LAaj8mmAVCpZ68RgdX9g314XXrq8ZcWMt5+AF6+COlN4ZQkHFN6MXSQymVPtlcS6qYOBku6DKJKp17/7iOJiVUTRsjP2LjoMP5xn9uZJHOZY9xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xxLplxt6VkmJLmzrmbJSpzlKoq8iW567CKv76R5VVU4=;
 b=Zxl9X5Xm5PW6jlV9XxsZtNVV8zcNrWVtVkuraDJcHeVFGuZgcp7xQLc9cv1woyZ2w7mXwMIJ7qYpRLElnCD0UYXUgTVJobTkPjD+VZtCGGSgo8ESji1e6fFKUHxd959KnV362r3uE7qiEP94C7Oxs16N309aeBckMMWbXYiKd50zaSmw1eAnGInMx/5kwVeOtx2UmHMZXSiUn7HvIb8Fy1ApcZJXoeiAwa2beg6BKGvPOmk/Yvbm//cPeIkFyAxwTdib+n/VFGP08KmnIL5GCdPwOE/xIOkWSjlV6zz1CE8ueLJfaaQHklW5jCPRr1DU1BTgSchuqEVwvrlIoQQsTQ==
Received: from DM5PR22CA0017.namprd22.prod.outlook.com (2603:10b6:3:101::27)
 by DM6PR12MB3530.namprd12.prod.outlook.com (2603:10b6:5:18a::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Tue, 30 Nov
 2021 08:42:59 +0000
Received: from DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:101:cafe::a4) by DM5PR22CA0017.outlook.office365.com
 (2603:10b6:3:101::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend
 Transport; Tue, 30 Nov 2021 08:42:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT046.mail.protection.outlook.com (10.13.172.121) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Tue, 30 Nov 2021 08:42:58 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 30 Nov
 2021 08:42:58 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 30 Nov 2021 08:42:58 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/69] 4.19.219-rc1 review
In-Reply-To: <20211129181703.670197996@linuxfoundation.org>
References: <20211129181703.670197996@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <a0b17639b0694125b548c37a956eab77@HQMAIL101.nvidia.com>
Date:   Tue, 30 Nov 2021 08:42:58 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2df3da8-b46e-4845-bc2f-08d9b3dd69a1
X-MS-TrafficTypeDiagnostic: DM6PR12MB3530:
X-Microsoft-Antispam-PRVS: <DM6PR12MB35304A515FD489C5A56F6CA5D9679@DM6PR12MB3530.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZpkJwgwH6UZo5CQnK9Y3a+iQSZNi9mQB9W8i11zTcwrWzxciDNKKtL5RRBXrWsC1jHgblCQhro5NPAtAD7gITYwjKa3IP61wFuTro1LYG1G9xwlpihmyQ3KWQDdQoKDz8MbhnOFOTn5Cyd4lTLdlo17aGKAneLqphpPHJQAQIu8yW8eqo0LGuTZFYfeDYc9D4uAgKrChaEFjU8GGILvVPmS/923uu2xcWOv6yTuh8gRwudUrHgFuKiRjCo7/+mxzg0C8LrFyG//PB+a/ycre+a2WLaAWW7FJC6CKwT4erZPsqVLT/a9S+3dsSwDMvM8mvmxDluQ4P7isyJLfknJjO7+J4lGPqdnZ5TFmcOUMVIPMw1UrfB27H1NyQEUty0X8lqjeuelkTvK4FKZt4Sw9zueHVTSEVjGfs/B8NjYgnIBW0C1RqB83w581RLuI4+ZXyH0m7k+b1PR7Jw7/ipYrxu+/A0yjByGLgRHY1needloqj59F0wUvFC6EqrB3M6AqW2g2CwEFJ4e32zFIwhun5MKl0PGVgIuqA/i7Co9KK5Z2Js8LMh1xFuQZGFM+TzqHUkv+qyMwbp+ju5ULN+VeSTvfnjYif4wQgq3BoiCV8Zz18NbcCvGWAv19Zs53rVuJAHuhiGHQrSIq6UWGnvKodOM/y8kE7/9jMacdzwkNXc/NXElq0cFRH8/ih5wv7FuimPqMxGyy3in5GCRpU2HLHCAWgAHIN+Y5NmBSheBBi7CNJpsRE5jiLLlPcEBghLEHVnd8/TN5fQRfcMEcZ9CVzF3TvgplE8ASENB0dXYI7Pw/VGdZwTbdmkCIpTaRSWjFR2uyI72aetmXbFtWx6roUqyKQHKbe78Xs6LyLo77xJU=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(186003)(356005)(70206006)(5660300002)(70586007)(26005)(7416002)(4326008)(7636003)(8676002)(336012)(426003)(316002)(508600001)(54906003)(47076005)(966005)(36860700001)(6916009)(82310400004)(108616005)(2906002)(8936002)(86362001)(24736004)(40460700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2021 08:42:58.9997
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b2df3da8-b46e-4845-bc2f-08d9b3dd69a1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3530
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Nov 2021 19:17:42 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.219 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Dec 2021 18:16:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.219-rc1.gz
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

Linux version:	4.19.219-rc1-g969701714472
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
