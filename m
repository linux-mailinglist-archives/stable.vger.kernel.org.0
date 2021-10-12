Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A646429EC6
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 09:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234027AbhJLHja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 03:39:30 -0400
Received: from mail-mw2nam08on2069.outbound.protection.outlook.com ([40.107.101.69]:63712
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233849AbhJLHja (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 03:39:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=izu6oQilqroCcbfPOSI1NDSBqFZ2v7bjpJ0Rp8yHGCEEeEI8HPcNczV7fJcVsIHplnNBnMIDwBqucOB2fpP2JVipSj1GtaxxXfKLk8VA2ZcNi+uMBD7b1EwsTP0JKQQmmZsaHFM/ME0diOjrX4apPY6VhqkMSz4B1N5cla0uTx10gpaDl+poDmhHNOEjg/+hEUXgh6//lpdm9ItLgRIOKEJpmF9te6DZx7UhK86iwcxTOymie5nahnHRm74oZK38oOsmNmH6IgZapsUWs03p5UHInx4zw8P4d64b1927S5x8MSW3oVnzNu1LodnDda7JD3GNcve1tl5sy/vrtS36UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wreh8kSGe2ObJdgyTBadjII8V454kfx2uwNE696VJgM=;
 b=PDcxfxWxP8eXE5qTVFgnzhGuJcYCguoKOOAZDz6PfCZuejYCqiLaTUbtwjjbA/oaTXqpgTcEs+4IXz4ei4MNXszDCuUVz/TtTU39qP8BrFfo+xcglsXPSZ6U+Q2XSXdJWu03Jp15MQ+vSXWdRNErVts02LXOhoVMa6XkAm6ScywfZAHry+LxZaNe65yhwfFTgBVOi01Z9/NXnEuOrYNX8ToR94I29YIjt2oYAaDGKjCLnIXg1buXPEU5owbHwKmv2drEbz/gWxlZOMWpUpN/rBt+RchSLo1/Ej2Zn2c14fw6H2OUun6unCXTocIIQmCxEsVDvayx2ZPkwQiatUJzaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wreh8kSGe2ObJdgyTBadjII8V454kfx2uwNE696VJgM=;
 b=EWw0XiPIs/UB3UgNh2bTMQ/qDZUP22pa253u7EEbitl+CzDLNrhHPRKSMj8T4eFIiGQfVnSKpkVe4eUlKbCCGtAqSnSAm6aGmVHBOW1MKG8VsRc7oZvtNtESxDJat1noSThBpSIgG3Whpk7XaYgp5HHdf+2c78D+7t+71O1Pca1Du/qgEcwSpbUX+sTohWtQ/XN/TA/2Wtgo2jwk2GT6BawZ6zGAs1Vw4jkTRZJOj+iZcKr+9N55qFUiQCvVvclWQbBtKrdeOFWf4U9h9Yjs13IM3BmZzT1pi8ZDcP4fWQqJF5hVi82gTnxJLsKtzTxpRP7AblACF1h/jcFdlZ6p8A==
Received: from BN7PR06CA0042.namprd06.prod.outlook.com (2603:10b6:408:34::19)
 by DM4PR12MB5182.namprd12.prod.outlook.com (2603:10b6:5:395::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 07:37:27 +0000
Received: from BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:34:cafe::41) by BN7PR06CA0042.outlook.office365.com
 (2603:10b6:408:34::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25 via Frontend
 Transport; Tue, 12 Oct 2021 07:37:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT004.mail.protection.outlook.com (10.13.176.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4587.18 via Frontend Transport; Tue, 12 Oct 2021 07:37:26 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 12 Oct
 2021 07:37:25 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 12 Oct 2021 07:37:25 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/82] 5.10.73-rc2 review
In-Reply-To: <20211011153306.939942789@linuxfoundation.org>
References: <20211011153306.939942789@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <cb53d8734ade41e5857798b1e29f7b92@HQMAIL107.nvidia.com>
Date:   Tue, 12 Oct 2021 07:37:25 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f52f479-50f8-4a32-498c-08d98d532398
X-MS-TrafficTypeDiagnostic: DM4PR12MB5182:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5182E483DD57EB8459430DE2D9B69@DM4PR12MB5182.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C47uYalG+MTCoyJwExvtrTTzRkJ+PnQUievPHDUuFIO0M/SE52sK68VFN6vcuzctAl4YfscyqBv6vNkcXjzzvtlXmwNry3bJbPZFE+Od4dyD3I0djux7nSdxnlSI6p3+AVxYJXzc4ebRExhh692DPCWjW1P+nTv9Ze5QjNXD007Cmnt1EAqw6fd9Q06/1PFxGJYrWhwRmGXk4dutI3ckjLvFdnIS0Lwi7SDPIlQuB5Q0ZECMKQ/6wbyeXPGleBiN11cqIJvgHXkuwODLvfsRJ95VkAAhPbgw7hIPYcbkDKiCvkTHX+5H3QEtdoEkbAZYoIQNcEnDByv3O1g+5eAXt1a8Lj589P73GBTILtQlSKpiYCkwfeAPqT+54Wnpy2HJYG4+bnB5/nVr20/wSLw3QWyPyR1ZDYog3gtYsMsko4pHWtWBTi1tCC6b6kKr9DcCx1gjB+e0hr+RirBkhrLpPTz0EVYZwzeURQ55Fr5kb0R8tUH70TABuH9pFEHDb1u/QW6u4ZqTD2AybmJNqEbiX7H7biQl0yv0+jEhdA+65mwwdSlKYTQlAgUuEYHXZjw/3p/JkO1SAvjjLMy1swRo+dPuPE0iu9CuKmuSF0UbKbBlHhe+ae7JLIB+RQc8hiQo503PFHrf11xGo2h4BmmwIUeiqYaJbvwtCaY1rTMdPrNcN4cx0ofBLbPwT/4t++LiBVXwU90KcZnmjsT74uv6FQeiKD3YkYAfeplOmriDxOb1W8SgF0H6tmOPeP4wHo8Y8PdK5mDjmihs46z4YwnFalYDsidBgbDGwGprWLZ/78E=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(26005)(8676002)(24736004)(4326008)(86362001)(7416002)(70206006)(966005)(8936002)(186003)(508600001)(70586007)(108616005)(7636003)(2906002)(6916009)(316002)(336012)(82310400003)(36860700001)(356005)(426003)(5660300002)(54906003)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 07:37:26.6811
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f52f479-50f8-4a32-498c-08d98d532398
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5182
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 Oct 2021 17:34:39 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.73 release.
> There are 82 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Oct 2021 15:32:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.73-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    75 tests:	75 pass, 0 fail

Linux version:	5.10.73-rc2-g0d59553e5bda
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
