Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29FB4472FA5
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239664AbhLMOn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:43:27 -0500
Received: from mail-dm6nam11on2089.outbound.protection.outlook.com ([40.107.223.89]:14497
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239665AbhLMOn0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Dec 2021 09:43:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ap8vXFIPb0KtjujXxV4uAObnKMQyjZa/tqFoswAMSuAL5HLGNpWADonyo5rjvsswGrb9DMIHCX9V/e8HGV9OpxspnL/5YlDCa5AKM1dWTa9tMF/O4PptlIlyTxIkIkq8WKO0nXYRvBotebAa09rHL7WRMfJroZ1VjMq/u7OoLqRw8WpIhwNN1OHL03ZEA+INNsfy2vkicXoi11l9EyZdvVnMf6ySXRLHvTCBKLkBhpH0qyLK9S6xXDA3eeHBlP3gjKJrWNocMZNz/oMNEiyZhdD0TSHcBr45LiWJB/ufx4QmoOcqZ9DIdfqk6Wp0uBu3MhDdqNw7pg5JrLaRSXLzRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qG5ylVYg5UXlAj6tNJp4tMpqukZ66x5+TIX20jZ++qY=;
 b=FQt2x7bxk0p29FYtVidMlGT9JPmeJAS9NblO80amFDuOp6O+YSL3zyQfG8c46FMJ5RGlmVq8CQ1HE+tcvEKmGXrDXavst6i2HT4vfXwTWyHWpGB5PSB47DWMk3jDYGhLN2JcehI5uKqiLfl3TwGZ1rgJSFQBdOq270OlAszjmFf8VgUnC+le1KUmilNNmADcWHb3RO1gM2zAoj2GEpnwE6Icr4hb8pH9PRK0s3grtNhiBJ6uaZ/kQOPIfzSpZf6JNxeihvnDyXQwOo9sGVorfmmhZ4y3rcW33k8fuEvD5ckbJmECGXBVB+ipaqgypFsrq0GJ9EOnJJ/g6LXIQg2l0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.12) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qG5ylVYg5UXlAj6tNJp4tMpqukZ66x5+TIX20jZ++qY=;
 b=li224GZcySscQUCkoiR7DHmPaQpdjDWHcqul0g5e1DjAcUKn99BvnCotFnDmSfA82vH7EACLSZImLYt3cpS19ROjdHCqjNDbrCscxxHOgt5uSziemYmLyH0WXDP/JuJE80mBrUtD7l4XLykaLA7YSj81Cg8hL04Ug+Y0quD8WcDKP2hc0HCN51lcpXMuH6zPwGjl4yYjyV1BZzEb8ClSvLi8aryE3YWk0MsjeiVXQY+GJqxVmNBl+i69SSyzRN4w2wvMYXS6r3e4QDbYucYIE4I05wVsoZs3PsTYQlvaiGFTYYkEOLpwQbPoFq0E91jaj45FBJEfjic3b2RCtJ1HZQ==
Received: from BN6PR17CA0038.namprd17.prod.outlook.com (2603:10b6:405:75::27)
 by DM6PR12MB3209.namprd12.prod.outlook.com (2603:10b6:5:184::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Mon, 13 Dec
 2021 14:43:23 +0000
Received: from BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::9b) by BN6PR17CA0038.outlook.office365.com
 (2603:10b6:405:75::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12 via Frontend
 Transport; Mon, 13 Dec 2021 14:43:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.12)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.12 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.12; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.12) by
 BN8NAM11FT009.mail.protection.outlook.com (10.13.176.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4778.13 via Frontend Transport; Mon, 13 Dec 2021 14:43:23 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 13 Dec
 2021 14:43:10 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 13 Dec
 2021 14:43:04 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Mon, 13 Dec 2021 14:43:04 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/74] 4.19.221-rc1 review
In-Reply-To: <20211213092930.763200615@linuxfoundation.org>
References: <20211213092930.763200615@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <34678005678f4b9f80b3b36743024605@HQMAIL101.nvidia.com>
Date:   Mon, 13 Dec 2021 14:43:04 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43ca0a5a-ecaa-4dad-46c7-08d9be46ea5d
X-MS-TrafficTypeDiagnostic: DM6PR12MB3209:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3209B10C5D1803EB2FCA2A68D9749@DM6PR12MB3209.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ei7v8VEss/x7pJtvErLGGUZdDxYFGCfG8/dYNWLDUkacy37T5SZ/hReFDYyXm6LJhQRudZITBWyTxJsCpRMM9tDYwYn3nW5tWPtQqn05A9almbLVYZna1NjCOVMS1XbMpWqzm3PY5hYOwuvcCPoQV3geNeMitC3wQz6maXyTTdwjT23S+w6epILmo1lv35QkaX/+UVjkoHhUgccqnU9lkipAAcark/vaISREvuDu1URZbMO1fpiPNPqE+25yIpWx/ENwqXTo6bscEgy63zIfulaPXdyaqJoM113AYOqU2l6QZyj692WJUhDldmij9ePjKedjNXEQALm+5tF7psKHkNAlFi1EBx5dTQUx1zEf2lXeU160BKS1kbgySXrwJoMA04wXGtH4ZuWFEOez8kp62rJwlGNypR6cvI1TIqxtpJ1PYT61cljaXvUxjgICSSUb/siR5Yj4fRXRBQtI0nxHw+knZUQGYpDW9H5AEosil9Qv5bxHsP8Ty4DcvzmY59SJPJhc2a0kQhNmb+/S1HqfscVp2h4ht2gjn4Orv3O2vnHo4g4grEW2MHZgUpQciHAlMPOCbFdH6TTacZdW9wXhP3Yu2HbyFAABR3FVfUB95jObAg4PEQ0c48O2N3JsidPUvFXJ4itXXR/3FOe3e6Aeed4sds6ijn8jiaBMzXwzQ+qM+0XLokqtk8NUh1GmmUAxD1bGBAFpsCcZoM1NuNKZGg9atkES2bBuhlr0XcapMyn6TMcF7XStbOYgNCtnYpZifV7pKj+8BrDZwP1r9owuLYpIwZF7vugQ33uPA5iA7ZabO6rTC1UzHB03tFTE3iRsjXuqxo1siN5H/gl+nJs13x19kozQNHzIEH7iVE+5yHzYxNyCGWOUs0n9J794zmFV
X-Forefront-Antispam-Report: CIP:203.18.50.12;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(8676002)(8936002)(108616005)(47076005)(24736004)(86362001)(966005)(70206006)(6916009)(7416002)(316002)(54906003)(426003)(336012)(186003)(356005)(40460700001)(26005)(4326008)(82310400004)(508600001)(36860700001)(7636003)(5660300002)(2906002)(70586007)(34070700002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 14:43:23.3594
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 43ca0a5a-ecaa-4dad-46c7-08d9be46ea5d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.12];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3209
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 13 Dec 2021 10:29:31 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.221 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.221-rc1.gz
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

Linux version:	4.19.221-rc1-gc65e8cddade7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
