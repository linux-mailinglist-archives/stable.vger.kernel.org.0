Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA87B42E152
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 20:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhJNSe3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 14:34:29 -0400
Received: from mail-mw2nam10on2042.outbound.protection.outlook.com ([40.107.94.42]:1389
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231472AbhJNSe3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 14:34:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TQT2OB8weliBaXqXe+d4Kjie2mXdB+3c3Q6/WOY5XFB6SxHwlHbrz5lJYHqMXYuZ6WOyp6/+Bne2FAB1B4QTAyHFU1ni1K8OB73HYJ2ayHuMqOzW4UDubdJllI3Aa7QMtXpfw7oc1mbuYNePgmik2+ZTcrUa/S13aeXEEDEszf5Ukt8hUtQ0xg6Rv3R3UBg3EAg6Ol9y2wozw44afnepWhLjA683F+8kQY4gJLyKtOTZMOA22e6VPrv73nLqTgKZfnwW+nma2whXx0iLDL9wMnUMMg/8B/ZJoI3xI6rBcdContNCoxfivTr8SHD0dhKK19P20z70aiXzKKX3f7nEXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yKup3axICts4zzq84tIbAtUV/kb8/EQkdGDYwyc1P64=;
 b=K8JMd4YSb1DcYpDQgLbbKiU7ACMhE5AFdVGoP4tPCDgUoULdQiVarIVYF/XFDVigQfkzDCCaQzsuHFMH1+iBvAGzUE11Wu39cN2S7BWbnns19hPCpYAaN9vBmReZRbfUYWg8YWYRqjRQEf4EC+wwddKcfwipdGb8pTiMdA3jPDpPmXV3jw++np5UHlVXx/dvrroopfZkyhbA473AHnJ7Zzz8YoQF4J8Dcj+PT6WCp80r3B8DR89WkNKj0G5AcbOuHfHz2lf208nYdHq4zB/ccD9nZGKI0SadAcLEsNGfWL1A3Mxi2tbnlI/XDlXyZMdgt5flLJz7ItrXNTPMh3hGbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yKup3axICts4zzq84tIbAtUV/kb8/EQkdGDYwyc1P64=;
 b=bWVKvaDEvPL8kx7XFa/FnUoeminoGBhNN1CpH2WbJWj0XaiUdz8ZwIFRB+ywwPu2nlNWz0YhT2My0DLRlgzRWmbZLwtBD5WTRPqAtOB+nkezUV+ND/9fs+AHX6AzU2TfZ0MuYOFuSbLiQH8ZGnvum7978joNogFMwhUTPpUNJtjQUrjZ6ZnCIdpeor6O+mjIRe4jYlqtp/G6JlYQk/Bv6ckQliP07k9EHrasoHBFumdieMogzEGXqByZULFh6ON1i9I/gXIMy+UIV97earHHhxMQlcxJ/KcI81CSQIroFntCnoopD4s3dEgHdOK1+LdLlEPbcP4IrN+obLYgtom5ug==
Received: from BN9PR03CA0428.namprd03.prod.outlook.com (2603:10b6:408:113::13)
 by CH0PR12MB5075.namprd12.prod.outlook.com (2603:10b6:610:e2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Thu, 14 Oct
 2021 18:32:22 +0000
Received: from BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:113:cafe::47) by BN9PR03CA0428.outlook.office365.com
 (2603:10b6:408:113::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend
 Transport; Thu, 14 Oct 2021 18:32:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT061.mail.protection.outlook.com (10.13.177.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Thu, 14 Oct 2021 18:32:21 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 14 Oct
 2021 18:32:20 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Thu, 14 Oct 2021 11:32:20 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/12] 4.19.212-rc1 review
In-Reply-To: <20211014145206.566123760@linuxfoundation.org>
References: <20211014145206.566123760@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <2b8edfbdeffa42e99b97346582ab4bd9@HQMAIL109.nvidia.com>
Date:   Thu, 14 Oct 2021 11:32:20 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 732d0e39-afeb-49db-b7df-08d98f40f637
X-MS-TrafficTypeDiagnostic: CH0PR12MB5075:
X-Microsoft-Antispam-PRVS: <CH0PR12MB50759CD73C18CA8D6ECF85A8D9B89@CH0PR12MB5075.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sw36/BJ7hm6O5r1CVfsd92BGzpmcP0jZziPlU77lnmJ0U3QIQj7oKUBjCRBc4dnB2RA5sEtsXjSl4IQKwyTs1xVOn4PdS3yKbfk1PObZAt4MvcQJtp0DudAa6qM8zHWOQo5M1vNQR5Lz1ZvUaqcc5EY/c+IJxpAnzq9B4Rskm6f8AWS2brrJhZOwWKLit43KgEY/U1LIY/UAOpi8BD+Ob5ccyXwnPUofzwjL3+UnPUIHao9hnjvjs6LBCPG4Vh3jJfuRzMLkMhZZRUL1fxIRnm74/4SQ+5qkFvfpvHA7eok90o8yCYHrFJgl1UYo0cN64nNIW5p3Ba8woj7qZ2Gt3K9lPxks5qqvRPozW6IWZPAiEx0LpyF/zv680DRnzNcYmGSteL8BUYdFryJEIIajG4QV38ALA/18ghuJddaLp3wG2ViO1eUmDDBqBuZdh/N2Q6cDMApuY28P4P/VkJgJpXLWZo0Nd8fgrPHjcET1Ze0guIv1+qx75+MxlxuxavW7pLBhnhJDMP2d/awOxXILaTPU5IBNF42HYztvNrhsesDofnhmCy/EyMfRAcQDuL3OkTQ8egQ6E/YmtVjyS9B4qyomWMinldmnhbyVuHeLOtjjqfE4MgWEDwSyxEHahJXG9Qr69oWIu8RpnFujyvEuFEV5eaStMA9rFozvqvQAMZ+wWa5fzKN1uMZ/5zuHeWL6bQ6ioPhSCLgGBNc5zF66aGQQeYp/I7q25il9R2kBunIKZZiPlS/6+9MuQuHruutr6tqcq2FSW1DfhLh1ANu6Jv8l1X1KTK9+nbYRagrYvag=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(108616005)(24736004)(70206006)(70586007)(36860700001)(26005)(316002)(54906003)(966005)(508600001)(5660300002)(47076005)(7416002)(82310400003)(356005)(186003)(426003)(6916009)(336012)(2906002)(8676002)(8936002)(4326008)(7636003)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 18:32:21.9392
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 732d0e39-afeb-49db-b7df-08d98f40f637
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5075
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 14 Oct 2021 16:54:00 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.212 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.212-rc1.gz
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

Linux version:	4.19.212-rc1-g2be6a8418bd1
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
