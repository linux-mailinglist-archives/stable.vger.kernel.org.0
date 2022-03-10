Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7077A4D51A4
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 20:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245605AbiCJStx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 13:49:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245609AbiCJStv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 13:49:51 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2045.outbound.protection.outlook.com [40.107.220.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88C44DF75;
        Thu, 10 Mar 2022 10:48:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hm7kVDLtOuPzaiSJdjZSUoQ12UwxJ78tEalzAx/mGTEwPeKoo+WYfg0bfE7cjLcnu9w8qMWCpUJ59RTpH22d+JTmMCvt/ipyfz/HOPWUNUyfO7AM5jJm+8B6kGRxeo44RCOWO5JN7L4ZvLDBL/DGn6z0LP3kmiQ2MGhyd31Uuq+GuTQzItg5tYz6BVcafrewYJw+RF2E3mN68mPHd2CnR8wLB7pMkMHCSYhjvwH9BNFgiH3RF72RghrXHynNWGPwdapIF50PQqhGIcyKmGhUIqw/5Y4n0p3AE5EsuH0oXGrNY4NmhRxXWuhO+l0xtt1eTlkiV5T0s5I/LmpXcw9QpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mknqsYlFfeXCf5rNAIGPSz7vlnFqjJjFa+pxvcPNNuM=;
 b=loW8252x0YZ9EDyu++4J0P9infU0pOpnkVvAY17WnIz4HZGCZtxwzfKLdOtjWM3Rem1ICfsEDh8RCB9+o0paNIJc5RVmOJiplePEGiVQCFcDc8fJx8d4Lyw2yNvV11vluA8nC8bGu2ZYXeloSegw0HIfR9pwibu11Wu/5xmxKyDQkIpPKsYxxK8N1KfcP2AGNLCwyhdMtET5A6kBDfve5g6hgO6sZEnclb887JntBo9UeorsQmK6E4oFzJY2kqmEH+Um/NYa3eIfVRHqm0dz6xUCrthogUqO9AbL1uANJFrP1whf6wf/4t4J/VJrYOfS45lRFI9iEG/N3WO0uyJeUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mknqsYlFfeXCf5rNAIGPSz7vlnFqjJjFa+pxvcPNNuM=;
 b=IpAUqGYjWBbydUM/LgD5F2AfHLcmzgpuaDpRvSAupYvPOkFPtw8qs9dnkkjglQebC7AaBia+di+oO6ZavZYzFlba/bsZYe/D+8rdeLOYEvn9sOEApb1m6qWDjHzywTnk3eow6H2yhY4+2YgERgaueqmTFArasAud0U+gdWKYj70DpgHS+LPFd/vbzB/yVmeCiAFKgJaGa8bRpbnbfUFrDr4LjB9GL/oHxzmWADYg6DzTfo/+91UZfggHqyYg7XXuHXvI7MLJSpOkJued24HrFmtsHt6VXQON4xV2ubzByn3A3xSL7hS1JgPx14vmFmBuU7pjUQ8PAfo+4thmjWEN7g==
Received: from CO2PR04CA0115.namprd04.prod.outlook.com (2603:10b6:104:7::17)
 by DM5PR12MB1817.namprd12.prod.outlook.com (2603:10b6:3:109::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Thu, 10 Mar
 2022 18:48:48 +0000
Received: from CO1NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:7:cafe::cc) by CO2PR04CA0115.outlook.office365.com
 (2603:10b6:104:7::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22 via Frontend
 Transport; Thu, 10 Mar 2022 18:48:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT031.mail.protection.outlook.com (10.13.174.118) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5038.14 via Frontend Transport; Thu, 10 Mar 2022 18:48:48 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 10 Mar
 2022 18:48:47 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 10 Mar
 2022 10:48:46 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Thu, 10 Mar 2022 10:48:46 -0800
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
Subject: Re: [PATCH 5.16 00/53] 5.16.14-rc2 review
In-Reply-To: <20220310140811.832630727@linuxfoundation.org>
References: <20220310140811.832630727@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <0af3e82c-b5e2-427f-bc62-7f5f6ce1eb22@rnnvmail203.nvidia.com>
Date:   Thu, 10 Mar 2022 10:48:46 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b262a12-0e70-415b-b382-08da02c69cc7
X-MS-TrafficTypeDiagnostic: DM5PR12MB1817:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB18172A07CE31B4BF1F276239D90B9@DM5PR12MB1817.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kALWEJ3tzl4iiBhKYL+3ketU0+fgmvgDDA2v3p0Cti/VHr9BNHR3NeZmzTXNfe3kmiTQgo4FdLIRFDdBBfADJ7nbdY/64b6I4EdcX9eM/mjHHDayCvrD8Y6a8alf4iDUvnL/j35kWzz1Nqu/Oh/qG6meHBSAVJg+//eRap0th/GMHz1nWC2m2dUPgY4tDzg9mJYMRg4+cTjtq1acz3iId2nU5uV1IAhE42akC6f/LahWlmuuKRc69b+X5Fbts+F4EeMBuiFO7G25epQqFtAhULjyW6X8/ukLI6VZB/0f32K06GIdAlMdpJUUkvyMWNhIDhrdpYJbJOBJT5ZbpYBiTJveqv7UVvGdwSBINiwPmW1+Pd0JbEk33lC9VdLBd5gn5NkUzddYk6/KeirbBBxW6TDVPPsFcSNPqjsiKUiByni/VAxoqHChhV2S/DntHx8l3HE3noSf5r96bkgGOJOUw57qgcTxJk/QbC5OFdS/+jmhEosjr4yokgKR2ii8XOugvYVbzw7M6YeCQzuTGbRrfO8y4goL85+DWyv13N97l1tj+9UcmlFRJeF/94qHOTDac/atJLQdvRjEfG3BrKESn66NDkTYaVIrdjcXerdjJWLIFjDJQ2kjHkLj7tf7K+dh39nwtWbqnTifdXdf9ys23+SraOVoKpDagAShaYHm8HEdPo31r6ddxlcdXwmTqiWuMSWCUmCnpoSmjPUKrJsJkss8IxX6uVQZ9bnzXCGvbKJojdYOANASN2eMWstaNbWKQ3hu/hiMvo9iTclJhAdJMNkOuNv7sSxxDmpAW6B27pk=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(508600001)(36860700001)(966005)(316002)(6916009)(86362001)(26005)(31696002)(81166007)(82310400004)(356005)(186003)(336012)(426003)(40460700003)(47076005)(31686004)(8676002)(70586007)(2906002)(70206006)(8936002)(7416002)(5660300002)(4326008)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 18:48:48.2366
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b262a12-0e70-415b-b382-08da02c69cc7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1817
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 10 Mar 2022 15:09:05 +0100, Greg Kroah-Hartman wrote:
> Note, I'm sending all the patches again for all of the -rc2 releases as
> there has been a lot of churn from what was in -rc1 to -rc2.
> 
> This is the start of the stable review cycle for the 5.16.14 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.14-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.16:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    122 tests:	122 pass, 0 fail

Linux version:	5.16.14-rc2-g8a3839d7a6f3
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
