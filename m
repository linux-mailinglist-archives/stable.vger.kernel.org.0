Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1B744DDA4A
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 14:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236582AbiCRNPj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 09:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236576AbiCRNPi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 09:15:38 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2049.outbound.protection.outlook.com [40.107.92.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A29204AAB;
        Fri, 18 Mar 2022 06:14:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A7YsWahxtm8QhIXhWD+BJszGpC0l2jTWok+fCe3HlYXb1wiKlb7XJso1rUW0CGU8Q7T81HLtO8aoxquuy3sxlQOt5EJdGoO7nOZtZBW49XJxAympVFnmiZ+KwGHz+74MjmlIrH6R1ttiyWDJ4iJXFU3j7/Hg6IvP/B1w6Nen8RDMlhaJXsI//IMuAjC/u+IcWaDMJgMl/5Q3r5pnjVClUzycZcZ36CO2eWd9o8v7Tu8kkTxQ4MphlpqKOn7+AS9Zv+dH6zHfjyenUmrMIIRlKuQs2cFjcrhGHgyJPI0vHebqu12VoDRwgJIs7rtECSfwho3n1jjbGxCsdGzBDYDfOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BxN2zX5s5bR/U2vQ7GqgPZQC+dspbL+NkNrRbEQnb2k=;
 b=IktvVCC0sJ+w00ekh6E4/IftJR77BuFGyEpr3TIie/x56qn61/FWobZHv0FhO4fKIgAMgst1EqEil7KS7HkAufuCcoog5Z8dLGDT2Or0O/H7SzsNDeizSYelglChjyDMoh0QnmnaOKNeUzVg7icYnoAj4bCDLPgNH8bpNED93HuyWHlEkH3Y5haJUWJvGlJO/SK+C2ch0kNIGYm2TkrCajDkZqAkmmEmaJHqVqAKcUX2bohPfs4ArjWRmxlLcaZrlFZuEheSoLS0mNdFMaDm1asFsByAeWWZRlv6lrL+aT8w/ryXT2gMlE/2zLiqovdTyYycloSV+MRFRrws/y0bxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BxN2zX5s5bR/U2vQ7GqgPZQC+dspbL+NkNrRbEQnb2k=;
 b=CpGTRsocaVlI16LQ9ApSvTnrXY4qjrsNPAYnFN/csXKUtiQlWKSHPfLWbXRNySEFuAoAO6YJbzK6A8s+h8NH379oso8ntj/jVsXawtFukZsk4RgtY0M8BEX7TqQaMKUAsrBOB+CZNyqFyqbE7wpEvMm97P+pf+XonvLeqYGwo8EhyRSHpBdrGIBwuNzZXS4TD6GOqRb8Jes/J0ZBqITzbRdm5GD6jQZY/7WU9Cx7GDnFOlQ52Ity949Uo5beEgh6OXNHUAeVfkPsTX3mdJ4mPAubtyrlx05dkzypSKTYR+UIkw3EORZ9VHpyIuu7FX4/3nLLCBHBx6+ZDywvDCeC7Q==
Received: from DM3PR11CA0018.namprd11.prod.outlook.com (2603:10b6:0:54::28) by
 MN2PR12MB3421.namprd12.prod.outlook.com (2603:10b6:208:cd::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5081.17; Fri, 18 Mar 2022 13:14:17 +0000
Received: from DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:54:cafe::42) by DM3PR11CA0018.outlook.office365.com
 (2603:10b6:0:54::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14 via Frontend
 Transport; Fri, 18 Mar 2022 13:14:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT062.mail.protection.outlook.com (10.13.173.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5081.14 via Frontend Transport; Fri, 18 Mar 2022 13:14:17 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 18 Mar
 2022 13:14:16 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 18 Mar
 2022 06:14:14 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Fri, 18 Mar 2022 06:14:14 -0700
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
Subject: Re: [PATCH 5.15 00/25] 5.15.30-rc1 review
In-Reply-To: <20220317124526.308079100@linuxfoundation.org>
References: <20220317124526.308079100@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <1bde7043-e622-4cfc-bd7e-1ba3cd337d70@rnnvmail203.nvidia.com>
Date:   Fri, 18 Mar 2022 06:14:14 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b6f2fb5-21cf-4cc0-d2fa-08da08e134cc
X-MS-TrafficTypeDiagnostic: MN2PR12MB3421:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB34217A5E2D87C069B8977D38D9139@MN2PR12MB3421.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RgxqeF3KuKIlvuisHBGgEs+YSJ8T1yFX7iaQczciEfPFMHqeI1O/sXbg2Lr/WFuJQq9olEEJlVSvlcCbO3B+ikwrDFRx9FNrpxu8yncT7uoG1a20IeraYynS24TAgUllQpkoFhsmu/8z1her1lS/N7BWV8nVoV8FA6RgZmx0It3deB7DN+ssisQJEbpLdKhFgjUtbQBaVR3qvoA4fI1nfVCaeeMgwVxssWdZ2w0RerFgwP1mO+p6I6QmKV4+fTX56U3945lw4ZDoeqU15i2xW+a3f1DqlDpV7JH+EttYExhjMvTGAK6D/E5JOZ+aFjXMpk+zPC92lAdR8vT8l37T91jJ9oywsA/DC7KjKOUIRIp8jaEtkzlgK9taX0e/aQJcsxSteK+6ZtsXbYBjoutqscnum573BwfYjSVgABnFtfeBZnOt8E478gCpO+wa4IZ/6AvSs7RJn4ljatF6iRP4aZaA8rJKtNn3ZL8iqF/cqxjVNAMPxQ8wfVzBlHY3nFBnsWkX3WCJOfYCf5k9br/WqrUXWLfmmpiMiodjuXtfdHnnJRFkGq6sOyDtt8Ebgi/qGvbE04AGqOYe2NXSD6aIDHpXAyUf5cSsXR4eYaHyLUAd5OQ4Q2HoMYj89y4UmjkwMhimB2XbdmsJpoq/OH5JoF7bhmLXZl0QxSYX7h2OCm35KACQ9xAW6kQyMwRyBOdjKC0BsyX3MyJrWZT65MsWLFV/OkTJ9OWQiD0mZ38WSPCkv01okLVMHqmP0S/qP9+CFY9/4ZZ3zbW7KFEuOd+fqm1Hlc1Eyy52sQsAGgwSksA=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(86362001)(8936002)(70586007)(70206006)(7416002)(82310400004)(40460700003)(966005)(54906003)(508600001)(316002)(6916009)(31696002)(186003)(26005)(426003)(336012)(4326008)(5660300002)(8676002)(31686004)(2906002)(356005)(36860700001)(81166007)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 13:14:17.1598
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b6f2fb5-21cf-4cc0-d2fa-08da08e134cc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3421
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 17 Mar 2022 13:45:47 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.30 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 19 Mar 2022 12:45:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.30-rc1.gz
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

Linux version:	5.15.30-rc1-g1d4b468d2e8d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
