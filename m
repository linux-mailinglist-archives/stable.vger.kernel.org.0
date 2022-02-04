Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2E124A9BE4
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 16:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347891AbiBDPVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 10:21:52 -0500
Received: from mail-bn8nam12on2045.outbound.protection.outlook.com ([40.107.237.45]:3674
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238436AbiBDPVw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Feb 2022 10:21:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QEFxEWymIi3ktt9BJql0eQHRtXHWXSZ0MXE5aVDVRasusbfsCQUEnAsmzXSC7QGnqR1ff5WSesOOFIZzUB38NztzbwtR2MkHsPsksDCm0GEE0a2IaaQgp6vxC8x+IY+DB3Az868cgENBZLepnUBeyJoJkyZV1ejcHIi9AQFiWEkwlDfON0/6VNrK4FVJcO3FwzuN7lK3XxN5xZcZ6LoqneUW69LwXOzMr6EY9In/uWwpsAlx4nKqf/AISF+CVLHAXp6/D/tmvhNeMOL/WH1o3/AsZzDHyTj1PTjTG8RekWtv8jGG0DGZJAL1nSC07KlQZvkBx5RktukbeFQ+7xcbSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5LoA2hhFX94tKrZ+50rGoXha713NXN4mFAFOS8sciic=;
 b=Zt8HJCG7B3EFSZmdYyWdQ1hpNKhXDkZUlypjx7uYOQ+JYxvbbcYDRfQbkMYsJPvYJV1qlK//BShpDrXZSNrgltOl+sCTxpYAzbcWhELkR3V3AFvaGdnG9SHkZpowAf8xjOVoI5kyIk9jkAT1EWQkjpUzD2ZbPFbxYtBjeWS0MfQAg5qIu8kRgMz6R/rKEhuvjbvl/Lt4itaOEJ3JIW0Eoy5lJImsJ6IcwKV/fG02GNiWg4fB71LeELT+NwaMQ2lbIm4oiG1TynieilUJoSywujWisXHwVKWuV83aYQGRXnFWeIlsy3eYHsqdQekzLMcPbWaHB0G7LkY8ihcbww4UtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5LoA2hhFX94tKrZ+50rGoXha713NXN4mFAFOS8sciic=;
 b=E9CaYEBv5DVUJVckZHy/TyBt8m/YK7ol8d6htLunPWvNCsVtDABPWaaLVLAuBw7x4018wkvw6uuSSmtFtW+8YLpQcPh6AOidwWv86woPnNxLG+hNeTgbgZOxMI89LwOoTnd4y5i8ibxZKBT7jVhcSo1FgdkwnrxkSPFtJXg59A+AQZa+NxDW+ljmR9cYaAhwFjaNyUIsWxKv3BygjiraE/lNyx7dlq0SstdeDOj43dkBEYYDulCmhxAALb+tPF0cxE9WaQCqSlEjJD7AtaDks5Yc0HubheFw1sUuJsnwTmo+b48ZBk9bDl1vnotDvghzsMJB0F+KUpezB6+DghqdCw==
Received: from DM5PR13CA0026.namprd13.prod.outlook.com (2603:10b6:3:7b::12) by
 MWHPR12MB1536.namprd12.prod.outlook.com (2603:10b6:301:6::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4951.12; Fri, 4 Feb 2022 15:21:50 +0000
Received: from DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:7b:cafe::5e) by DM5PR13CA0026.outlook.office365.com
 (2603:10b6:3:7b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.6 via Frontend
 Transport; Fri, 4 Feb 2022 15:21:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT042.mail.protection.outlook.com (10.13.173.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Fri, 4 Feb 2022 15:21:49 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 4 Feb
 2022 15:20:33 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Fri, 4 Feb 2022
 07:20:32 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Fri, 4 Feb 2022 07:20:32 -0800
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
Subject: Re: [PATCH 5.15 00/32] 5.15.20-rc1 review
In-Reply-To: <20220204091915.247906930@linuxfoundation.org>
References: <20220204091915.247906930@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <c590065f-6c7e-43ae-b18c-0f4e9b0198c3@rnnvmail201.nvidia.com>
Date:   Fri, 4 Feb 2022 07:20:32 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 013a6283-df9f-45b6-76ac-08d9e7f210e0
X-MS-TrafficTypeDiagnostic: MWHPR12MB1536:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB15362A91F63F7E7F41AC14C1D9299@MWHPR12MB1536.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cjqW+x8RcKkBK8Di8N81XYH94p4/8lwQU7ZigrPFX5iWIfA6F1TX1LWt0F8QTdO2Yz0KeNcp1hyfZi+PHNF+BUxj+34ZeyKDn1kBQtfUK7EK7xE+H5amJc42XARLlALuS5ClbKAOcbaZR3DYeGWyJwIHDuM8R5vBtBEzw/wnqULZ+Enj/MlvUSuMbOh0L9FHSgWFVxVOWouuStC1U3e0kkwuODO4YJ/njmnBhanYuIUNx1l6ZgWDDuLAba9kH2JuhAWLUunK1XoKEWmkFM9Ej2UIp7NbG17xAtPzClrxvloczwlMFI8W/y5SQ3agiohvnDP3HN092TeOgXnjnRKLIaLzhKKybBZBVAzcpv+6HNd7hQf/k4wxWZ0sHspnpp+qa5SUp5Qg45FHskZ/oVfLwDTV5MGxNzkjsg7bQ4v23S4oWK4pHRjHp4OajQbdEZw/Hn1OnLJd6WfOAbvJnaapbbjSVdt16/kjhHvne9SrKRRdm/T3TR0Jw7jKcJX9SUYuJxJq4W2GcjZA+BYbhijujcWrLYWt6xSNGCPvI4rKdPkZim2Xb2lLO5Z/n5bAbl1ivqARue9yILd9lRZ/y7GO9FZyau3+0i1PsJkB3sTFgUMcsDKpC0Fgs+6CfygkHJ5ZrfH3mdgLdJHn1IA5DDiV2vYodbRoq4aXg5y/Nl1v9+T3rUeX3egB0tnUPqBx9S01K9IMyy5bR0887/7WWsSb5cN1endHcrjuv7aDL9gCCJ27VogKMmYwVWFiTv5UUWpIvKSXQptrmV2KHVv97kZBU9vmZHVSHmLiMvGCXhaqGNY=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(31686004)(316002)(966005)(40460700003)(54906003)(86362001)(426003)(336012)(186003)(26005)(6916009)(508600001)(47076005)(82310400004)(70206006)(4326008)(36860700001)(8676002)(8936002)(70586007)(356005)(5660300002)(7416002)(31696002)(81166007)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2022 15:21:49.9633
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 013a6283-df9f-45b6-76ac-08d9e7f210e0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1536
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 04 Feb 2022 10:22:10 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.20 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.20-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    114 tests:	114 pass, 0 fail

Linux version:	5.15.20-rc1-g61f904d1d627
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
