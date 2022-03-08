Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97A64D1475
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 11:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238695AbiCHKMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 05:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233523AbiCHKMl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 05:12:41 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2055.outbound.protection.outlook.com [40.107.102.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B487C42A1F;
        Tue,  8 Mar 2022 02:11:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fnzVqeBq48FQJ6B8p3AoMTep+RCaTuqz4nCAoAuWnp4P5SCJO8fb679+WUP4dUZJzgYqhcmLs1ws/saW/g/GKdyZGFtPLxQKPybL0c7KqaBS8xFpz5IkiVyOfdxl4Vkrz65b6RPPB669ciwec9FRdG9gSq7smXFOMS2cXgTSCK8hXQDf92JvttpHnMsccR14oSmX+25tgL6tyL+MzJE2Wtbou5npyW1dkwJVGntFJnGMdqndZqL16hjir+88zV/qznnCUfgWVKQsgb0zlhqTwJOlgt4P8H0Mqj7l/7AyFug2JpKf7w71ed6At441AvnuKrU3m8LvlGEKEIgcG30rxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aK2+xt4csagORwC11cdB/zrz6xlio4l+LBiBisUlXMk=;
 b=iGoAvzcDY69S5qOa8dwivtp2WH+zKQ2aYkTMFYYpxEXP9RXo2R31r+iYd6w1cqCL0BLPQtWkrYqFAqMSF7X6K9BsJpkJ3WwJnrDKTCqSYm5MCWxT2RT2rGtl32mKnb1CRaWYybr2ernZ5+chPBC3u6ch0DFP6rX16GwZ5nQC8NGUVOWDIeizj5KneEKYj4pwwIPziRXfTm4OeVdqnhpVTvaXJpWEmViGaHQY+IcUMTigHSpb9CeyLoHQJ/yhPPNIZprZTuuij1C7SUjdCz7zUsBHxxMaw7jAUJsDb5UeBUwOKJtzRQsFHqYFJnhHFCkwqQpxlb6juKRlArJBsNRYqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aK2+xt4csagORwC11cdB/zrz6xlio4l+LBiBisUlXMk=;
 b=sSmpnjAm63W0CfWr0VfEC5XaoMvO3iIUlkdhgLH3JdSQi7w/XIlC1YgzPu+zVEpJynstDoSh/72ZJaN7at3YBNi71yYhYiJFpwVrrQhdqJHmL714IwH8OXlpXpec09LpFsEtkdiyUZn7IAbpCnzf5azDjQf/2OhatFwABu6UT3+wo7ppvLGXluhJMujrm+9Ii7ytQnMrV3/EZk25ayXrWHe8stivMtrJ++zgGzanSCKSJdw31fDntsoxmk2riX1vHCW4xTxBK+Ju0FbzrtfN5fNwrPt2Vd7ugFj3IX7CQRnv0DKLIykdLyPdfeyzbCeBfRSIw88SU4FmLRnXhPKlLA==
Received: from MWHPR10CA0070.namprd10.prod.outlook.com (2603:10b6:300:2c::32)
 by DM5PR1201MB2507.namprd12.prod.outlook.com (2603:10b6:3:e9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.13; Tue, 8 Mar
 2022 10:11:38 +0000
Received: from CO1NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:2c:cafe::3c) by MWHPR10CA0070.outlook.office365.com
 (2603:10b6:300:2c::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Tue, 8 Mar 2022 10:11:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT026.mail.protection.outlook.com (10.13.175.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5038.14 via Frontend Transport; Tue, 8 Mar 2022 10:11:37 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 8 Mar
 2022 10:11:33 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 8 Mar 2022
 02:11:33 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 8 Mar 2022 02:11:33 -0800
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
Subject: Re: [PATCH 5.4 00/64] 5.4.183-rc1 review
In-Reply-To: <20220307091639.136830784@linuxfoundation.org>
References: <20220307091639.136830784@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <8f372021-f441-49a4-bccc-400ffa45bec4@rnnvmail202.nvidia.com>
Date:   Tue, 8 Mar 2022 02:11:33 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1820306-a449-49db-4d02-08da00ec084c
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2507:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB25075D9ED256ADDC1A2BD9DFD9099@DM5PR1201MB2507.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nzUBo2K6B+PxPbeTUDchO+CP9iF221NRbbxRNd4my3No8NTd/IuMBeZ8LwLTEGzOyVL+sLoCMa0+WE0fUBfmDeAlKq8t45ftgl/8/9ig7/cMQYIDX23fcutGlnGqGHcjgjASaGn9sMYlyh1mtqVd8Du3/QqopOsIHUdMV0yprqAfsiTm7Sm0NWkYCanLMkJtnodbynpWOqYTkhFyFlnUvXm6f5xI4UceyycDNL9hWxjyFcXbNaUxZ5Qjlk5+Krha18lHwbQy5vSGempp+oVDtkRa2QMMSrAhsXNRxb8zpoFh9bBmVDXQ00nc3bgI/RWlEV7xgMYMr9hmRq/LZ52kXBCc+tU5MSW8mQIhMYNy7POVrsFrUsYYLcVm8uxIPzNFGlgeILtAWWAFkoDkTqczijxE6aU3wseuPComhhYhd80NGqiQPZaEUaI++WgHZ+dRqMqtbggz5LpOSsgTDeF5M4jsDTb4awMMPYw+hWVd923k3uHwf1PCGqalaYAiLfFGSzO6nYKj0gOeitR48tpfp3YSmAft27vWz93FGYmbWT52qEzhyQdXM1CBg8pqVL/3pW0gNn3OL15gynnivM8asMoJlUUEiOj+nryQDDiSPcFvTEpq+zQ1C+PER4mUydCUUWLcNm71vHAb8Mfj58LHnlAo/VIuRpNoBmYz2SjiuvVP/kLLMCPvFTGb1HMaYTiZ1dT3sZolKB4pWdlPkuAISFruVrzopHqCrqc+uda1vbugQtT3AVAAyCmtp27rGhmqx8PYQMUdtvQcceyGn60dQje2dGbxTy60OU5RpQ9MOG8=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(426003)(336012)(26005)(81166007)(508600001)(40460700003)(8936002)(2906002)(47076005)(31686004)(54906003)(6916009)(316002)(36860700001)(86362001)(82310400004)(186003)(356005)(31696002)(966005)(70206006)(4326008)(8676002)(70586007)(7416002)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 10:11:37.6596
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1820306-a449-49db-4d02-08da00ec084c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2507
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 07 Mar 2022 10:18:33 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.183 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Mar 2022 09:16:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.183-rc1.gz
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

Linux version:	5.4.183-rc1-g5adb518895b3
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
