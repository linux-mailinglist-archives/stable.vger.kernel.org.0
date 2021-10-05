Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E067422869
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235249AbhJENw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:52:29 -0400
Received: from mail-dm6nam10on2067.outbound.protection.outlook.com ([40.107.93.67]:9633
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235338AbhJENwV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:52:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kXFsj/xAYt9DP3fueJSiEqc/vMis5pmyUh2cXdQBWRL0lItEs10Q58wbJdwww16aIhP3J58sOpvbJa/dYFlVeLnrrwJCBA7IzXSQAeLHOXMkoy0TIiWkJN1FP2XtwpfwXZR4g3ZABnUcJYrTEF4j2T2Xoc6uJnTZVuFvaZZF2SLGZRa9X6iqMVWD4FkI4lnx0Q8Rfo2qv4kzQ/whJ/SklY3fKByWhyI73900G72iNDF9XrmAb5LcfQpuOcEzgmS1n+2dhpEJ1O0rWUWDapJJaqSNTCSRuZe0fl2fGf2O1VD3oL5qEK44bUTfWxp2qlGr5TNYWQY60VfC24F+TctHwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OG4l4yQcLKFZReDqDC6+WYvy+K3ldo7Im2u5ygnRKzo=;
 b=QGAchLNdwe4fuhgLneMNWDfv2EwF0/gavRyWNyulLfXr9nZX9QRDBVchRNFG2QgU/1hkoAKeLnmrNbyIm71Hpb0U+JKImtFiU5sfkADql8BEtnIr6XU9jBEeQeUjjVLOhsPG6MS9ljvlRUP8w9jOFesIsrTVDC56L/ad0HLFZc5xGa6KcQ4SoYK3zOrVjHQC+h2HE33kW6YArLygJ74MRcpyqztDJcgoqcHU9JeWoGiWyNUAbxrNoUKo8K/L5AfNdo1s2nbtNx/pcNc8Ee7ehap2f/TMlGXTuwg82wymJNmdrfPp8eHKGLIIzzcP/zw3ob3yZvEv0AgR9c7RWf9CLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OG4l4yQcLKFZReDqDC6+WYvy+K3ldo7Im2u5ygnRKzo=;
 b=Mue78fehUAmOa6lqNMXC9gmCaJHF8zTP6DtF+jrEG0jcfVLFQMI4jkAnKbnsvUhaPejGIiW2GVsKDRFdfoZJpSqV6pd+Chz/pq0TsNw2D1Eb7FjzX1A8nbQ2VDR0sPRKDy9YC3ZeydZmWVUD9n/TgzaitdNGFpzXDp2vgB5iUOmeolCf5Hkj7fm5T/OU0duoLQyZbW4a2NltDpLUfinwqVgFqY70E+Uw+NCnJGk/ZhD8ngOiGMqw7Nu/Ew1KuXsY16hjcrY8DSwv1Lvv/h8ekSo7w8ScoTvaOoy+TXtegDHTFMaYmTB0ewR7RNZrlazzqbW+T7zvEnFms1xjZYlmcA==
Received: from BN8PR04CA0003.namprd04.prod.outlook.com (2603:10b6:408:70::16)
 by BL1PR12MB5287.namprd12.prod.outlook.com (2603:10b6:208:317::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Tue, 5 Oct
 2021 13:50:29 +0000
Received: from BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:70:cafe::36) by BN8PR04CA0003.outlook.office365.com
 (2603:10b6:408:70::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22 via Frontend
 Transport; Tue, 5 Oct 2021 13:50:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT043.mail.protection.outlook.com (10.13.177.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4566.14 via Frontend Transport; Tue, 5 Oct 2021 13:50:28 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 5 Oct
 2021 13:50:27 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 5 Oct 2021 06:50:27 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/57] 4.9.285-rc2 review
In-Reply-To: <20211005083255.847113698@linuxfoundation.org>
References: <20211005083255.847113698@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <c1c0e2e436a64a9b8ddc443a8adc9252@HQMAIL109.nvidia.com>
Date:   Tue, 5 Oct 2021 06:50:27 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95e24419-ae86-4f67-be57-08d988071747
X-MS-TrafficTypeDiagnostic: BL1PR12MB5287:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5287AD9F6CDFBAB05F1B4E8AD9AF9@BL1PR12MB5287.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hnx3pLuvYun40c0viWrVfYg7a7L1lzBhCL4duCegt1OJEKCZ2SccFrxbzVeQeDXZxKmvvstbpo18gsd0QmQbWbghBHaPI/mVnN1UvdoZwLKMzA0GvAED5bFcszC9IJ/OGoqskhXL0aSZVdnB9qb7jUkrzrejiYn5mu+eItpDlQKjZaFYM2Cgi8LhuJC2J4GFyLS/lVRzQR3/FILBtNGdWLnxIXEkibwMm7XUokzTcn4umDPgdilPMof0mczk9Gs9SbnUibttN97GSwr+cSEcE1/EcwO5X4zfbFQijIyVHOpOho4aiB6sh5h8ZaA1wdgd416ofHhoRWe34xL5ufmhXF55wb1bRSLzfHmlITJ6Fi4q7BgU5g+KPOwbsCStGaz+MHZVYeHXPYb2LQwp+l+myvbNjI/xjSo9WRFp5qfT2yDgSOEdbNnlTfKz09LsfnA64fIuAcHvn1t6sfvBrI4PDNmr/mK2m8RmeG52a1yWYNPUROF2IE9lsQEKFZlUvtB/dbMXh0NGHSSyH5CJz6LPNsxBArhH7ftMupqqecHeILDfoZIdiJ/cjaJwUOQ+++JdP0TAtSbjO28NHnkNXp+7eLzG1MdVCIp8Kqy48H2nBlwEY33/RyLP4sdi8qUr0XS+EyHr1/vuR6MV0DuV8Z1qfUEP/CrRp9UgasHjuAoQzmFfWANG1MUNdFl/CCTEwVHKhk1zX0F3eeIEwohliwbuTLuQ/Lt7bqV5REmmKO5NwM+rxMbgxkLj5JZ8wOhgZWYgt8XsHhkfrSMIFvVNoHnedaAHpH61rOa8cevL/inSnHc=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(86362001)(336012)(356005)(508600001)(36860700001)(24736004)(108616005)(7416002)(186003)(7636003)(4326008)(2906002)(70586007)(316002)(8676002)(5660300002)(426003)(8936002)(47076005)(6916009)(82310400003)(70206006)(966005)(26005)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 13:50:28.4605
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95e24419-ae86-4f67-be57-08d988071747
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5287
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 05 Oct 2021 10:38:02 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.285 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.285-rc2.gz
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

Linux version:	4.9.285-rc2-ge7efcc55cce6
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
