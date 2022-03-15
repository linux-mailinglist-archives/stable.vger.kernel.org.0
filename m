Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65BEE4D9711
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 10:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346343AbiCOJF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 05:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346342AbiCOJF0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 05:05:26 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2062.outbound.protection.outlook.com [40.107.236.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C7B1A810;
        Tue, 15 Mar 2022 02:04:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GfDFjkGnQNtVvJtrgCxHo9F9mORPVuLpCoGjE28xf1YyT73AoBKMtaO3EKKIhgysblVMB4vKBUQadAAPPLHLK4eCaTbGGcOrX6yorjpImPi4w7XVQcv7nzsVqowaohqccHyf2IOYTL/jRz/Cl7fc7fFFDe+sxRTPGQbHfYnoSkaN8Maqgx5fSQRkxuVd8qIWmyH9Cl9C6J6rWLNOzgMH47u0rwj0aLijaV9fsO3MjqTtykGR6yHf0FhyRPhJ9BpdrchzoSEcbEJHAA+5UJRVUVIiu0pNMPeJZIIF3GalGhST+1XH+j3cmSXfOfuywLs4GlBW6RHIICJHjFySN36tSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UVqfOqfMWDHLmwGCjZ4IkJuGuVEbNkXcpOgnLo9tUrw=;
 b=aoN66YvmUV9huiJGUk2XdEUzfoXR+oD+JG9NRnnvzD4wDalEUK6bNDgFgZgkqveHXHOCbb05ZPud6achHgoCRbhzPM3YJ717DQqYIV4Lr4q47zwds4PlByPaREJ6goo1K1CvlbgbuIidxs/tTN3COs/VpQjtEATyO2S3BEnop56uvLMf4Y8j4LsZS55huBlusJAGeWW9er6cDny3HqCwvFQl0P6VqiGcFBUiy5/rDZP0UlANutraAZfE9vZIR1Cj2pZEdlwxb7TjZN7ZDHxeT8u2dyndrv0MISrHwaW6CbRJ753PVQxjXA8seg1IdVsORzYc7MeTFu909IB6lSMQ0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UVqfOqfMWDHLmwGCjZ4IkJuGuVEbNkXcpOgnLo9tUrw=;
 b=NXtyvVVjFf0k0Q4T7fQycQr11QVxCCDdzstMENPXEN7lOISK2crOGuKpS4S+FI/7A22wbu7DLSlyuhNzmCQehSMQVmJ2RU5nmGfkNVqRbxKoUWMwHzbIswAaaT6DsfnfUYEeuqjafXCDZQIRlX7dUMv8rZjAJ5Vd8nVVU1Ck3F1EhcG74ZlJQSFqv0GSIl7oKa2Dq1+Xi8Ge5hOBvcJL1+NjC/OSIQileWjDl07RU9hUQDApXvrbNfxgtlmsSRXLDu4huxTK6Ad6uN4Fbz2QGNfQRK9sf7lbwO5jDr4ONUaHKnCWEgrLl06a+h8SC89J5jdfuJHEgFfAWeKAHp1tSQ==
Received: from BN6PR16CA0004.namprd16.prod.outlook.com (2603:10b6:404:f5::14)
 by BN8PR12MB4785.namprd12.prod.outlook.com (2603:10b6:408:a2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Tue, 15 Mar
 2022 09:04:13 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:f5:cafe::58) by BN6PR16CA0004.outlook.office365.com
 (2603:10b6:404:f5::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14 via Frontend
 Transport; Tue, 15 Mar 2022 09:04:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Tue, 15 Mar 2022 09:04:13 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 15 Mar
 2022 09:04:12 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 15 Mar
 2022 02:04:11 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Tue, 15 Mar 2022 02:04:11 -0700
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
Subject: Re: [PATCH 5.4 00/43] 5.4.185-rc1 review
In-Reply-To: <20220314112734.415677317@linuxfoundation.org>
References: <20220314112734.415677317@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <b0ef9a46-e554-4c65-8b50-27301f688833@rnnvmail202.nvidia.com>
Date:   Tue, 15 Mar 2022 02:04:11 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f427eb9-1e93-41cf-fdd5-08da0662c685
X-MS-TrafficTypeDiagnostic: BN8PR12MB4785:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB47850D7238A6A6C15A6E5D80D9109@BN8PR12MB4785.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q1Aab3WgbpfIrU/QzLW15F7UBcor/uLdVF911LMknqiiPNljNVA8dmz9g1L6qL95k4XTN+3F9f6Kn0K+sEyO5y5QBq9jQLrndLwN3YC8wqycP+LirpXauTKgDXhlO8cwFHMJh7wyUvQsFH5JRIydYY2Qpux81zR3x79qCDt138nJFSuYy+qltNk2DR5wF0q4Cq1Y+s3GfQQeoqJvBZRhoBOezWXCFx7/EnTBUwCvqAHXQH5pSGk81zEStji+eBPyixwXqdEbc4n0gk0ulnyu+MN3HCHiDIPUcfF73BFbzMCRBz0kgIOoUun8nEh0FUZuiox7ZmnT0znhhSyWpwxZI/Dl7udskKWkPR6Rh7cPNNfVkbMBx0z8XFxUmsh/g4tCfPU61VLK3qkuk26sq115jBWC//r5Q6MGtkDu7Dt+4Cuqq1O4yr3EDhORfDoN52pPPL6N4IHJ93OOT2ZVdIulAwvKjwKUOcKk5V3+qCK4VZU4De20QnHkM+DZHMa+83cRTuM/5aRDhBzzM8ceI4YhS/PwVELE6RF5Eea/VaPdnAw3lM+rn2ONcGo3dnC7LbFpePQlvgAw7iI87OLDvwfSxE5PbDiIZOSL9knwI6OydIk8J4ztrEfodiNDbjc1/92yrKcdeevRVPVfc1/7qz4bfOfUBgjC+gIKd6taH0YFtp9pT5M5Pugc8DOJrMcx/+083zhBlT/E5L999A6GF+XQq5W5vGSbY+7JAut/ILvxu8HuxWyLJRJ0b52bpHMG6Cf1MY4u/QSH5zMtADJMvICxK66seA3K0E0dILTYpDRxZK8=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(8936002)(356005)(508600001)(70206006)(31686004)(26005)(5660300002)(7416002)(70586007)(81166007)(186003)(6916009)(426003)(966005)(54906003)(336012)(2906002)(31696002)(82310400004)(316002)(40460700003)(8676002)(47076005)(4326008)(86362001)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 09:04:13.2015
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f427eb9-1e93-41cf-fdd5-08da0662c685
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB4785
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Mar 2022 12:53:11 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.185 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Mar 2022 11:27:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.185-rc1.gz
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

Linux version:	5.4.185-rc1-gcb0af18075f0
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
