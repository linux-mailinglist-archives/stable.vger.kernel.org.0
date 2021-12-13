Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72A85472FA6
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239688AbhLMOn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:43:29 -0500
Received: from mail-dm6nam12on2088.outbound.protection.outlook.com ([40.107.243.88]:33248
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239682AbhLMOn2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Dec 2021 09:43:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mHaZGs4BZj9NGJCA5Cy7HdN84JA1uBEsflP3zzE2NDq4ls0BrMuu9VviKGlx0ToLRZqE+L9Mypx7/RNWFOFp7D8i+TANIAwFEtB3/Z2bqqltO5Yfjf7frEAQagxi5rDw7RSTKkX8OuI3UPPFXkAar9a1abzxIuqgpEJYNI2um0IsNbnSiFNRqu/lM42tdXEroBmMSaFoC0V1tGKGvnfihtbhpCSiOUGvTTl2ec30u4ez0MRvV1sJqV0jmbc1dVHdmuY89VymYHbIrR6oqFxJDhTm2hWeyPjJbGKe3j5rLyQIaw82Vp2zYOgPemh2fkV/Ngr1uOL2TH7VXhApBspYXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ygIChLp/HAcYO90Q1lZscfMwUJB0JhRLaaEW19P3yGQ=;
 b=NRCKFGMvvZFG1gm9c8d6H3p0NQxZP4bZJU1vc+57JRI12cvef/FExIrIyEDtZsCXwOn00Y0M8YCEXME2YoCVdWNGIoaYxVsoS5OEeLj0TqP6Ft2XkL4EP44Xcis8MtUaNEcR123rrbM5es/Kya0YpiMHjEjkQgOmK8i+B1NgEbhf2ARXUlJB+W5Zk3DrRLjAVldbg4OJ6La8NXETQMFDigpxJ66fez7OKA512Kgt9jRvMw8Li3K4wrk913D49Zu1hbtzpj10VhKff58OuXOF/hiZCLXfMpTKCTJw/SdMt7pL6FlQS0j4faVqRsRYM4oR9iDSL1j7L9Spfqq/o0G1FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.12) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ygIChLp/HAcYO90Q1lZscfMwUJB0JhRLaaEW19P3yGQ=;
 b=kQ+UKALQLS2Q/ENINzFKJ3T5rz55jKd+rDRF7YIXkDggJljbbySCQXdg6H3MZbNxlljNkcNEsL3j0wLhY0MMNW8HDe57EcQpv3PTYHBndPI6h0ap5Y2iU6sIDKyMo9+3N05PP2jnmyZeMw63POSqiRvLgToCpIE2cOTzD33wIMqVKGjKjwp4EHqRmK8BXMjv/TftDsCPBGuDqeTc6WjJRK3i+xB9NgrM0oYCz+HSD+UMzV7+QinclY1IPJnnZUpcFxAYOxGDU2D1AOHshiAvRBporQ8K3S6EYQ9rkT8sYspyPjIxvsJF3rxNoUCix+RRZiLvU8028WVwCIMcpfUwXg==
Received: from BN6PR17CA0032.namprd17.prod.outlook.com (2603:10b6:405:75::21)
 by MW3PR12MB4442.namprd12.prod.outlook.com (2603:10b6:303:55::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.15; Mon, 13 Dec
 2021 14:43:26 +0000
Received: from BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::b9) by BN6PR17CA0032.outlook.office365.com
 (2603:10b6:405:75::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17 via Frontend
 Transport; Mon, 13 Dec 2021 14:43:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.12)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.12 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.12; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.12) by
 BN8NAM11FT009.mail.protection.outlook.com (10.13.176.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4778.13 via Frontend Transport; Mon, 13 Dec 2021 14:43:25 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 13 Dec
 2021 14:43:10 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 13 Dec
 2021 14:43:01 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Mon, 13 Dec 2021 14:43:01 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/88] 5.4.165-rc1 review
In-Reply-To: <20211213092933.250314515@linuxfoundation.org>
References: <20211213092933.250314515@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <8920adfaa8ba4a7790c1cd013e2e37fb@HQMAIL101.nvidia.com>
Date:   Mon, 13 Dec 2021 14:43:01 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 862601f3-5f89-4711-fc1a-08d9be46eb92
X-MS-TrafficTypeDiagnostic: MW3PR12MB4442:EE_
X-Microsoft-Antispam-PRVS: <MW3PR12MB44424D36D85DD8C206DFE74CD9749@MW3PR12MB4442.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BAn7+oD59N6uY4TdoBNZoTmyswku2Vw1NKF+29uAjP66ygUmzVtVk/MfM0OLBN65g6U4wr40g/bgcm/NJtGK51kqUu0rC75jT1xsoZ5hnVFcohLFs/+2kD5xZsakEvXIpiQTNY3eifGGcJJu3u7aGpLTbj18qURwrQ+W6zUnDN9BlKRuSk6sbCQgKd+4YN9hy0mz5fMF27d9tf3VHEvLhaOihnZcyClMiL6mPmkDKP5b4SUxEYDILZUMhJICcQX2+phlrLCkRInBJIvRprF2JGyF8fIqwzxo1JtIymtXCrsmY3/aqm5KHhwWmpHlCui5kSGzUYyxkQgUCdeTrlOCfbKnxMqg0/DJw7ZcFaPrTZutGxb4DtZjsmfo/IAsoGZyFLgU1FwNDRgjZem/OMbojDmHnm09IEZ5r38NGoFcRqmmBtP1kKKuoxPMzjMa2uCALmDbQIwfOXPx+VHNIVUIffVVFLm75RjWUyudSozL2hxYcFpDrqHrniboI04Gt8Ig6pAG5gtUnSp/uHB+TPG41alnqnONP5L+DGyhmPT6ojAdM8AbiVh9DzBU4ec6swcqVYsd15SP2CToEswqeybfbdtAxgefcsEv0GP0EQhW1zz1aBI+gjsskzjP41qA6xpEiO7IsN5KOxDukphkafo9yNpvhGVpIyxr3gky65t9mzEInhQhJZroXo/ZQpdQ1EUM9BekYaWR8VvhfMfAWrUJMha883Rdkci0scApJGxv2pvhnASdyHlqz+tthXAYpXtggOxYzERa84KwyiLYzfAousJswo8CttcOsrB1+CbZw4ek5FopvlXKyIAnnq/7FdKzImZfIEDuwImxp2UL9nJRFUGaSgt2EDQ2iV8YBnlge4UYGyERaSCx05WAFBc4UX3m
X-Forefront-Antispam-Report: CIP:203.18.50.12;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(4326008)(6916009)(186003)(356005)(34070700002)(108616005)(82310400004)(336012)(7416002)(86362001)(24736004)(966005)(8676002)(316002)(426003)(5660300002)(7636003)(8936002)(54906003)(40460700001)(2906002)(508600001)(70206006)(70586007)(26005)(36860700001)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 14:43:25.3876
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 862601f3-5f89-4711-fc1a-08d9be46eb92
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.12];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4442
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 13 Dec 2021 10:29:30 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.165 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.165-rc1.gz
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

Linux version:	5.4.165-rc1-g0896ccf90364
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
