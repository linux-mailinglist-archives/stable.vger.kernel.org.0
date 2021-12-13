Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBA1F472F9C
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239670AbhLMOnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:43:24 -0500
Received: from mail-dm6nam11on2077.outbound.protection.outlook.com ([40.107.223.77]:33852
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233094AbhLMOnX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Dec 2021 09:43:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cqx7JDoVdI2rcIZvNEL7GoIINifoHSSaIbNdFuzJ9oYGeEvAKhlTzcRS+88jagvaHtD98Z/ZL1OMODgcUcNDfYpliMlFmWouBQZ3PGEEm2BFZBQa6o44PGwFsCnYu6qAf4id8jxp1mNWYrVwz1a34FfkQFcKHg3NDZgaF64CuO58Qen1UE5DRkzuejYhFBBXnGFhJVcW1DGv/DVfp5u7iZ9Yh3TA9LUmScF9CVipUEMqttwjDP0NHk1lQiOPGIjH4T54D9n1JPrEjB3b3ry3/XPyNn6G+wrpVopdh4NSal6nAy35NuBzbraD2JbToK+JdB4+hYwT73ThXPzLP5VzWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pGWctE/M4D0c3qfgZ3dhgulP0leObGnhoJz6PvmF6VE=;
 b=IssOq+wF1BJBhfN/83+hZ9/tUj+utBHKJmC2YJdpYfdAsRf/qSHnfN69WrxoKOSWcmeeekjyOzuFqCi4JfbU8U4Ow71FbknIP1WeLBSJFTfUbbNkfPA/CfjY6Ufyz9gsiY9/X0PSO7qFfBMYPx6vJBUz/dqC31x1zlTGAKKc9syuisH+97VC70/igTcfh+2LsrwHdtdRx352FqzrrLLztuWgXmiXe9XTg/zVRJM1a9nCRk7WJ7YIrybeMEBNqZutsPcBDGzOHQhGF8aYMS+ENoKXMrTdoIfhOS7VKknUKOLb7++VMb/PXYy1N7Eza16MXRKkfqgZJNH/dbk1MHOOaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.12) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pGWctE/M4D0c3qfgZ3dhgulP0leObGnhoJz6PvmF6VE=;
 b=iCn7rLNf8xE2awWcdV/nVBRGdI4N1dyYVRs7gLIFRpZIv4xu1jViNwlszyFEq1bTECW+oD1eNcgz8aEfz1vXcPej3qjBLaiP/YtELZVNUjJ4K4LZryJi8z2Bi+hN/3/pgg/vncwA9vqS62eCEP7/6dBZ6C6N6HftQvATQJ/Ec7qOV90i8pNFWvcBlQ9llqbZEGd5FvKfJmdG/ehXHkqOR+6uI4naPaC5T7IcZl+FynqtnUQ4OQOOVRepQT2L7ag77BqA02sj68NBJPeLMs21YPkkzf346c3AOeyuQ2rd4buonDfY91do+cC4SshFYnxwDKJ/wA0lwj8ODEaraQV06A==
Received: from BN6PR17CA0050.namprd17.prod.outlook.com (2603:10b6:405:75::39)
 by CH0PR12MB5154.namprd12.prod.outlook.com (2603:10b6:610:b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Mon, 13 Dec
 2021 14:43:21 +0000
Received: from BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::3a) by BN6PR17CA0050.outlook.office365.com
 (2603:10b6:405:75::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.14 via Frontend
 Transport; Mon, 13 Dec 2021 14:43:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.12)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.12 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.12; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.12) by
 BN8NAM11FT009.mail.protection.outlook.com (10.13.176.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4778.13 via Frontend Transport; Mon, 13 Dec 2021 14:43:20 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 13 Dec
 2021 14:43:01 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 13 Dec
 2021 14:42:59 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Mon, 13 Dec 2021 06:42:59 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/37] 4.4.295-rc1 review
In-Reply-To: <20211213092925.380184671@linuxfoundation.org>
References: <20211213092925.380184671@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <fb1910a9814d4e4cbb98310ed84ce11f@HQMAIL109.nvidia.com>
Date:   Mon, 13 Dec 2021 06:42:59 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6027afd6-f37e-425f-f735-08d9be46e8e1
X-MS-TrafficTypeDiagnostic: CH0PR12MB5154:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB515454DE7F8CBF6990339444D9749@CH0PR12MB5154.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6/r4/5HQVEs/EYXb1ncbrTNBiBZ9XbMUFHcR/TzuajftgV3VdzYSE3zL95Rw5mMwlrt3alETE/wcADUz8amKWYs6jEIjyGl1VwwbM30Y8oqueQGz9faDaHwrDfo4HM5DpTY+WMuYbQ+s/2RrwtSkaHab9jZ09WK45fZJD1sm7Kfzwa0RO6yRTshLi4w5/+AZEjOU6bIUh1OQW1pm1Tt0lcWRW2ZPc7RPFTaV/kJdAKskWuSKSnRQI82ESifONWQplWJ90UVysfZghpIm89LBUbTLlOHSz5k71QnBg5iWniDpaBscAJrs+p3fU/g1ARHbse0pTQTJqHgj0zptBSyLX/DXOMvaFfzL7hZwU6cHsk3soNoy4ZDlL4Y8NRRykGbOofUKG7d0YEXoleYM9T9O2Q7mq+fB70R42Etay8tn0cOBs9ReKqn3YAcRCDXql592FWdBEGudd2mQVaOJQVnXy2B/JDwl3MLZph0MvmrMejpOqS6gt3SZAeGKzKTDi1UaDK1+NZ2gDRFqrzz5rjq/MYHVVmUc0mNxBZmRNYFsi25wKeguaVcRf1qiew/wllI/LzF6UkkTDZHbhoaAsRZmrzZ3D2dNtqlFQBVJzBHTILiDeSj0JXmRg4VbgjS9/94eU/2eEDO5EmmA1mwn6HkTt6nx7MztymnZa9L0vAVsp09hCMYzR25fJoPEVvTFMDXY8BaW/jV7eLxpcmQMESHV/7o24wjx96i6cSfXP4Ab0SiCiRFj+XK3bvm8dXaa3ujTKyOpqNns6NMdP6PfTgARR+8EfYm+02erqer4eHVsVCBsg9FE/tEEfmOyoNC1QOYS48vzmLR87aGneCnkNaK5D6ELIa93HKPJqWr7AlFtabVkLxb5VYriYqFiDk1DuAiG
X-Forefront-Antispam-Report: CIP:203.18.50.12;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(8936002)(336012)(86362001)(5660300002)(7416002)(70206006)(426003)(54906003)(316002)(24736004)(108616005)(186003)(2906002)(6916009)(70586007)(47076005)(26005)(356005)(508600001)(40460700001)(36860700001)(82310400004)(8676002)(4326008)(966005)(34070700002)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 14:43:20.8816
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6027afd6-f37e-425f-f735-08d9be46e8e1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.12];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5154
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 13 Dec 2021 10:29:38 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.295 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.295-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.4.295-rc1-g597c1677683a
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
