Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 225C14DDA42
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 14:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236567AbiCRNPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 09:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236568AbiCRNPY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 09:15:24 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2064.outbound.protection.outlook.com [40.107.92.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC631F9752;
        Fri, 18 Mar 2022 06:14:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bA68SYtDqcqZGWx+K9K+wDE/zeZiS8tUVVWxpybmaI/faZn4HMcBLHK+oVFFGF17DAh59iRaFtozzAvJ4HVK7oChbwF8CFkyzTIwpVAGn8OnSRl6bhLAogBlnO86G/CK+j3bqsSuJ+rkZEtRRP4xx+gRYjoJWQWdcMoMV6SkblRGAuBZ3OoASryt5AfJm4u0XEDivpfLSqWFGH03RNapyyHRtd7N32OVtF9I9/QTnBS+CJBB8H3iRyQMzMy6P2yaWQ/dtCPbR2ABb9UJ8X1vCKPxW0eLcJcjcLp2a8umr/IHZyTGS6+sjhmE4y+EfGtniZUlbaX0qm6soLsN7QAs5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C0U93UW6DFUI5jMgkL+2AEmSQNm3B16ftu6KfM00TwE=;
 b=ByVEXQMElC2nMT7Q5AZThEvmeumnu8lCJV9xvxCf4P3Xsho0niKrmDpu0YeaCeLqgW6NfN4KamtqIjaTGFCvQ/xvoxcPrf15FbhcgvUiAmSzoEXs3HwY1h30W/aBbO379mF5tEM1n4V+jQwbNntbKOusaAJKC0/S/TfiUm90f3GXadHQ4igttZoMe3oVr2xenEWp6mou5co5VrdQDXYJGcNKOPk4Qqeu5ToEojagE3vuJLjMGCZ+17FGNFYEkU2vCxO3bB/dOGXyyD8w3ZmIvvC+EB66Avptl84Tbel5zrnKNZDU8oAsXNx3g8FNg2lPbwI3uZOLu4skRv5M7jhcHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C0U93UW6DFUI5jMgkL+2AEmSQNm3B16ftu6KfM00TwE=;
 b=kSXYAvcQKrAaJia7TdHrd9xKgOTHolupSW74AF9rzVUddgSQuBPrFwbrrFnRC7XC18SUWRV4dGoBADWQlLUov095iV2Igfq4gE+5LjE84BuEhlYROct40DsksCvE1h9JIfxtfTy1hMLv+0tZLv4Njmvs7cnLtoxwIC5k5TqvedL2ZcBJTqEkTixb+CJvPX+wxX9xsGEjB/0yphOV5aGBhQM0wdZMxSjDHP2pzOn1JHspbgy6zJYIyyGvd7IcxnnTrIZGKCsZwrfiyHM5u/O4RMbBwDy1oJ4hNVX7ss24UgKuO2pmpAjpSbOtfvqQJZqP6Qz5dSjwpHjw6ZX68kuRTg==
Received: from BN9P222CA0025.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::30)
 by DM4PR12MB5054.namprd12.prod.outlook.com (2603:10b6:5:389::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Fri, 18 Mar
 2022 13:14:04 +0000
Received: from BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::e) by BN9P222CA0025.outlook.office365.com
 (2603:10b6:408:10c::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14 via Frontend
 Transport; Fri, 18 Mar 2022 13:14:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT040.mail.protection.outlook.com (10.13.177.166) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5081.14 via Frontend Transport; Fri, 18 Mar 2022 13:14:03 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 18 Mar
 2022 13:14:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 18 Mar
 2022 06:14:02 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Fri, 18 Mar 2022 06:14:01 -0700
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
Subject: Re: [PATCH 5.10 00/23] 5.10.107-rc1 review
In-Reply-To: <20220317124525.955110315@linuxfoundation.org>
References: <20220317124525.955110315@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <a22710a3-eed8-4aa2-9d70-79c36769c4f7@rnnvmail201.nvidia.com>
Date:   Fri, 18 Mar 2022 06:14:01 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd2adaf0-138b-4700-7cfb-08da08e12cd8
X-MS-TrafficTypeDiagnostic: DM4PR12MB5054:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB50546222EADF4BB35298DB92D9139@DM4PR12MB5054.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 79TfX66FBhReTnGK7txmGhXx31BwmO09A9OMt87ELFoGifsyjt7yOguUHMgJ9eha2eOi81vCzUVR5GPvoGlHFvT/ZQMD+Xjx7iclc/bxgKo0nyVxAm8JiIYJ82dkxxQXrC05OWnVXmJvibwSRLq49JKwppIIVzxuTmd/CZd/akPVClcwYoknDcDdrHe7H6KNl8U1ZjfUZcmb1CuU1oA8lNvgSaISduVXpm3fMtxePzTkCYhzfAe0l1LEt1c7SsZhzPIHb/aXFOHYgZHcGAe6YRFS/ouhDyyqeqzBVcJ4RNWpQR+5SbM7r4TW6sUDAo5PbKmjbtGzq4+z+hG4T9Rz4aukpCu9GWARHDHCYELeMlXbe2MEOvVvDIRMFUSthQ2jWvDWUuEY9xDG3Gjim+dtHdW6r3H2gxur0tMcVzxknkLCKgpj26fst8Mpi4llNqzSQlImg1Iutmwxj5ytAg1WzB2JkRsMzfAO3j0MDSXDrHYzK1VPxRFb4ljancHgx3jFXWZPwhzBLnCNXiBIwQk3BM+c8L4/hyqNoqf5W5k/rdKO2xyweMZ7F9SCFLfolvYr4S3onaQGnIB2+/NvEpuhyn4tCMm+0tklSSqbKIG8nblu9n8S4NA4eCk7fs9YKJaaxTikZVr0NsuzEOCJ75LGyvZyxl0vsppNZFLEy3Y4yR3KaF7X+TBQT7eTdcAWVLeLWfXe/N/K0TwMF9o/km/WfLqgliRjaxF7mzfakf6Rnya4KHop+zsWkp5aMRV63AS+vFEjJ5O7buTdDy9X23wb/QrVHzE3t0k5WaIIXsoVyCQ=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(36860700001)(47076005)(86362001)(82310400004)(31696002)(40460700003)(356005)(81166007)(508600001)(5660300002)(966005)(8936002)(7416002)(316002)(54906003)(6916009)(8676002)(4326008)(70206006)(70586007)(26005)(186003)(336012)(426003)(2906002)(31686004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 13:14:03.7676
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd2adaf0-138b-4700-7cfb-08da08e12cd8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5054
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 17 Mar 2022 13:45:41 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.107 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 19 Mar 2022 12:45:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.107-rc1.gz
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

Linux version:	5.10.107-rc1-g0bacaadb448b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
