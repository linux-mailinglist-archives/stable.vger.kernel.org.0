Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 679A34A9BDA
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 16:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359652AbiBDPUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 10:20:14 -0500
Received: from mail-dm6nam08on2080.outbound.protection.outlook.com ([40.107.102.80]:22625
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1359644AbiBDPUO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Feb 2022 10:20:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gybFZ9et5AaIc1IjF4KNL/s2R3OH9tcwT25j6x5pG+VIZe66moAVjoXccilQZyI4DT1u8U3sEdUlcTACmIpadTnXBem+gS0AevZF3Tdq7wDLajftHv02abiur1Ce9fw6BEh78bfzY77lri6NAI/yVLI80byz+GP+DTv6GAPM7o+yn/iswvIdsw1I00afh0Hzb1esdOxaTTeEi+L/BNNBsaJ6f5yUVhQxxtPAjptIzp0F1AHJdZQtkGZBpYaG6637QCRMIUj9jBkiVZ5+AAxXEriDwEosAViXinZbJcsODTRd32fN2AnT7p34JZVVCMAmygpvIdEwaLqRZs4C0L/dOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mv+HwJWQ9Mt+IHRDXdoVaqpyW1E6b0dye43626sI3BQ=;
 b=A1qSTHNFk8WV3eiI/2Gt8tAXtv9VxiJ6MZQkKVj+vx+ZwHie2f7pPgNzfPUv19SJOwK9/20p3mbCOJ9eQcpO0weDgHEwEfeSlcsfv+ZAdO0VHGeD38X3JJyMTSWqowBnkmz0MBgvHSdiqkyKKD1xWFgJzHbAu0R2dBVIkHYjKNmOpzwVaR8ErPkQ+MiwdsVoTBlFZg805m/MepbsPqSqZf465Y8Pl1/hVPXODV5G/PS52dOHviceub2Z+tdYFb3PPweVSkbvpay6ZaKDeUJHwIrP/DRPcGvWkcGWFrtL2Q6nO/dNQfMazk+odtRfc3QW24E3+NKineVd49c0fg+prA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mv+HwJWQ9Mt+IHRDXdoVaqpyW1E6b0dye43626sI3BQ=;
 b=DDVb9wNajQC3Yp05O/LAxD0RlvVR6qiUPy7qrvrpHBX77dkV+R8KPLTlcG8zGWp7f3FTOkc7YQAgRUM/n+YrRJp8ih5ZAvYPjAd0zCehaV1RoQoUwDOiSJVtbn7/tUwUFNuY9Ea08OmcmZkf49pceiPJmc3O2o1fGZRrsDONSO2Do1Tyko4XVhK2tOZsJF/FeRKJoFlDwPcCqfdxnQcPoXEz1c7FfKDUB1lnDejkdoXUBvDHspPcLi9eE44fzTUsuVu32j84Au1jUUiupdWW13GCoiLwBjCP4CbGeFNq74SjDnG8K0SS8+NIuke1whhUli+QnjflBIRTUUOLrcwATA==
Received: from DM6PR14CA0061.namprd14.prod.outlook.com (2603:10b6:5:18f::38)
 by DM6PR12MB4530.namprd12.prod.outlook.com (2603:10b6:5:2aa::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Fri, 4 Feb
 2022 15:20:12 +0000
Received: from DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:18f:cafe::be) by DM6PR14CA0061.outlook.office365.com
 (2603:10b6:5:18f::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.14 via Frontend
 Transport; Fri, 4 Feb 2022 15:20:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT038.mail.protection.outlook.com (10.13.173.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Fri, 4 Feb 2022 15:20:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 4 Feb
 2022 15:20:12 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Fri, 4 Feb 2022
 07:20:11 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Fri, 4 Feb 2022 07:20:11 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <slade@sladewatkins.com>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/25] 5.10.97-rc1 review
In-Reply-To: <20220204091914.280602669@linuxfoundation.org>
References: <20220204091914.280602669@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <0970b07b-2eed-453a-a305-3310e13a81eb@rnnvmail202.nvidia.com>
Date:   Fri, 4 Feb 2022 07:20:11 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ee1842b-c774-4618-a737-08d9e7f1d6c6
X-MS-TrafficTypeDiagnostic: DM6PR12MB4530:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4530F2920A995B29B6E8A15BD9299@DM6PR12MB4530.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0J0FecO/9HSbOCxk0CPU8IQp1w5XmVIwTVoBfhfdhXe81i68xSAcZI/8CZW3JL5pEhST5lzdP8eU2GfUcZknF7yhz7Aj4nOPJrf3v94yMJ8LfynCwyf23b4bkoIsciqIxLzLRys9aHGQ57djeYa+v3BkFc029CeenllcfiSNsIYuJ9lLVHztLOjOGf1JZ/eYgeAkp0w6L/8IcDPqZbhsNpqWn/k0NKXvY00FwJ+IipE7EgKl22Njyiz/Iyr0tEldKCt9PFrANCfnj0gLhKlB+4sAudgphsKW4gS/RFwNyUAy6v8W4OFast3I5jlj/qCOL6flhBYdETVC8X2XaUsFri12PfmKDgB+/s8cmLHCMOVr+axJQuqAQiVvkjsyF8CInf0Es3UN8VC7T7J/zYYPdZXwrWuj4ulClKQeJu/fvVeC4L4BXGYxKRsZg/0KRFkr/8emu8cwT5SxAMpR6ehpU4/f5CH17RecXOiWZKSPs4s+eRap9eKfoaQq2brrjD6whE1Zb8GwedbrOMG20c1T0sNU1PXOQrt9O9KGCTJ18+61ZD7OfO13R349tla6Q7EpuCkRcYbMsHOx0Hrd9ZlYVcYipnranKuBMRfmRFwif+KQBswV7F6T3dM/kV4JHZGL06WBpxaCxfp4A6uM0XG1yzSuuy2R6lHG7wZ4DA779LqC2fRiMboG3gpx9wCFRZuMFcLJJevUPFRdpV8IE4I/Ca7z+/fHmI8gPYob6l7Bjrnt48kGvofogHZP+qnzdRObbRq9LjV5ok2ESXMYC0deaxcQZCe3/c26S86asuxyojg=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(36860700001)(5660300002)(7416002)(426003)(336012)(186003)(26005)(31686004)(2906002)(47076005)(508600001)(54906003)(356005)(40460700003)(82310400004)(31696002)(86362001)(966005)(316002)(6916009)(81166007)(8936002)(8676002)(70586007)(70206006)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2022 15:20:12.5019
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ee1842b-c774-4618-a737-08d9e7f1d6c6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4530
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 04 Feb 2022 10:20:07 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.97 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.97-rc1.gz
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

Linux version:	5.10.97-rc1-g847fbfddce32
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
