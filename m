Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7EEC44629F
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 12:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbhKEL0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 07:26:36 -0400
Received: from mail-sn1anam02on2067.outbound.protection.outlook.com ([40.107.96.67]:28651
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232115AbhKEL0g (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Nov 2021 07:26:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RvyUz7iqfhqll21g2WB5KCqvG6J+I06aErDxq/IRGm0yAurrizTKOScqEXdkIu8Kk18i2DJMTzLzPZJttazATC/6wnB4o6bhEoFvNVtJxufCZExj+fLXCaF2NtXR6nVCeUFNhq68jROZ7VUb7BcM6LVNKKa0u4QEBo7w01Zt8+9eZRkzUu0RtDef/UtdD2wNkYdnWfgR+Ud8V39QE3CL/DBC77UXUIF2sGkHVsKuqRXsgw04wFQ1JMd54LEEtj/L5bSB1VQwQm9juFu0gTeFTnbKtjYLO1X4P3Y2trFf7jRnYtVmAyu3E6nJCiEu2vCT0RZfLb/2bi8fN92cRRYXCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HPjOM7chbJrkS4r7VKVjvXgSGWUnA2ELb/b6ipIeHMs=;
 b=KJ0fH9jTn5zlyWDDZ5ttntWL9bl9H7TRqnDxZnwZyt5IMHltILGmkfRK84tQmJsatrnbbf3FvRVHqSxzfxRFhTovXPTxbFh8PcAYGtHRjlg6Oa553NYR2ak772Rsm/KS4MTOiL2XhINyvdZg4Fpk+A33JFH271B/VTt64tbexDtMCkVT41L8kgtnkKXJiwGp6eFAUP14XH828zDvm7TVa5NEMtBvlLbng9X5BXuhIToWj2/nDkMpxK+PaWNeOJJ8Rt5ad91JtwVSnL1IMyYVoftgRzpAl1XGeVACDY83zPlkCQtwUxAV/OmyqIRwwjIHgr+SxEHWE4FdFWdnifc9UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HPjOM7chbJrkS4r7VKVjvXgSGWUnA2ELb/b6ipIeHMs=;
 b=gBwzx+O/mSSuNwpfe7dQ1trBzxM8jQGQ53i9XNJj30iB00sCQlvamvTEbVy2C32eJ/5Dvlq7Ahd4aenTQcICwF8hpGcPZDu5r/CfzKUFVBM75Y6X8homraL1Eg11CxkBYWGzZ0wDx9S2l/ZJKz9htQK3gKAV36tE6UEgYBG0bKBVj3TCh5T47ikJ2AynzL8oM/E71dScdR25uCDxY7ONl2iHv8RuIldox3ApNUfhxFe+PWnej+4lxnpn3ljHrjn51AZPpgTr/9nfKiXLsjovfffQFrL/eK0GrpxIJxhoaSVQqep1qF+zRtFQt3jkQ/AFwtbZwo5Weouawsv7RJQ8WA==
Received: from BN0PR04CA0093.namprd04.prod.outlook.com (2603:10b6:408:ec::8)
 by MW3PR12MB4426.namprd12.prod.outlook.com (2603:10b6:303:58::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Fri, 5 Nov
 2021 11:23:54 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ec:cafe::dc) by BN0PR04CA0093.outlook.office365.com
 (2603:10b6:408:ec::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend
 Transport; Fri, 5 Nov 2021 11:23:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4669.10 via Frontend Transport; Fri, 5 Nov 2021 11:23:53 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 5 Nov
 2021 11:23:52 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Fri, 5 Nov 2021 11:23:53 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 0/7] 4.19.216-rc1 review
In-Reply-To: <20211104141158.037189396@linuxfoundation.org>
References: <20211104141158.037189396@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <5795b79e6256425ba7653d74fce62872@HQMAIL111.nvidia.com>
Date:   Fri, 5 Nov 2021 11:23:53 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d18e1760-80d0-4e23-7f62-08d9a04ebfdd
X-MS-TrafficTypeDiagnostic: MW3PR12MB4426:
X-Microsoft-Antispam-PRVS: <MW3PR12MB442609610A42228AB0B894CAD98E9@MW3PR12MB4426.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LSkmLKrbT6URnovwAT4n7BzE8HgqPxVhTvuws8kEkWBOOFoyuC4GzopYXay41kj7wnN+Ionf42qaFKPwjNJGhK4olTFBmpqn+tpmgK0e4fWO8LJ6+XIOjjO4gHMuYGulZAa2dn21aUD0+EDJar6LULwrriJmnLvoiLYQ1ruXUe2mJA/y/sMfTVVlZDAgsJJS+uYEjRwY2mh/3Sy3I7lNW1nZ50OJzpigyJJ83zAZzPPdwVVTr/mpFqRPa1xqQy3AUVTuCtNfvAsEm1ImQf6HI9qY/qURUgqUSsOwSghB+/E4FsXY3Kd/BtBFXXzRBYxXLdoRa5sVyLdgvn6ZDEQpvbheQ33XxB5M9u/MtNrTYet3jw+qr3HD+/o2dad46+WcKhbuOK8Kuq6OquJMyQZ2jOQPfgEVWOjcG0bMGoJGgZCMKcTeVv2Cpmx0H+764gcclGfv5naI518YVNXP/4f3PN8nEld+wbIGYABSFzUMnzNrUAT0XYiqGWhqFb4FJzEN8zbDEenJnzF9Rh2HAuXDoGuzc10RlhQ+WTRmWjpKnCh96jzgBFWI0IYC4qoLW8nKnm11fCpT5UU176TN/qm6fnZfe+QKJI7VasxYau+nZ6TjoHtsIu/ZLeWoVepoQWNAS+I/uDUWJcUX3htEEtu1YzNBLjzOW4bz2MI+jrjpWY2aKn0ck+C+EFrsDBPrnMGRqK3+XVFUIsX3Lwk+SpiAJHl6gBEMq1iiAH18ndJnKEGCnJQ7hLivK28RRT8jU644XXkUF8BaElzz8QA0VNdiTkG+Ib12yofXN/2dvtA9/FE=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(4326008)(508600001)(70206006)(966005)(7416002)(186003)(24736004)(108616005)(5660300002)(86362001)(26005)(82310400003)(426003)(7636003)(47076005)(6916009)(54906003)(2906002)(316002)(336012)(36906005)(8676002)(8936002)(356005)(36860700001)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2021 11:23:53.4434
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d18e1760-80d0-4e23-7f62-08d9a04ebfdd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4426
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 04 Nov 2021 15:13:03 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.216 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Nov 2021 14:11:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.216-rc1.gz
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

Linux version:	4.19.216-rc1-gafcee5295c1e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
