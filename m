Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 096E74B086C
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 09:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237550AbiBJIdh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 03:33:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237556AbiBJIdg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 03:33:36 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7BD5D8A;
        Thu, 10 Feb 2022 00:33:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SEcuYRP/RT5rmQlyRahPss86gPUmQBUxK8Q8XiXI2v2LmDjmo7lOsERyUlHQ248qrxi71luKzVGayMmzLRg9R7hRGICi07brcRQ82Zk1cAQKGNKMuxrIBlQagKgn8Xkv+D0Wz4v7cB037FoKWXR3fTxvHoLtwB1Eo27D8jDYz/a0d/rV+XqDp7VDJnFLl2sTmyh115+ELwzO5xtJdpQJcmpxK2n8bzYyre1H+TkWonw5P9qVnBsQK58lU3WDj1tFd+YHALcsYOD53egoeA/k/PhLPUTCOg0eVHPEhXDFj2Af/JCcJimRODJP/wvuInpKUra/oAUsB8B0zVmGABDhXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/U+4KQP0hwGk1a8NHiSM1xxfBbcnJM4Y7Gx9QhYSdcM=;
 b=HHuBbHgPuLO1sq4qUgK5BYNA4AzI8B4BBLe0oGnCbX9VocPQsoea2sIW0W+va6/PB8I2PDqs3UPW7D+FsmcARt5sFH8kMP86tkfWtN0ju98LjhjHaPnmBYNwGn5q7XWK/3YLiurUOnM+VOdkrbT/AnIua5zlD5P7bjc23CzMaoY9T+zgHvSuNWrrNyPXbsJbGu11mouPfwQtBtyPpzeAM6U9jwycm0jk2an1Ote8UVCj1yqlT0/3xtsqMghdESluGNYVckjQqXWVr58nfbxEG/0HheRFW+HdeRNpR7lKTp4mTBNPiFwoJs4HR8YeKPewEjzU5HaAGO7JR9WlHpQvrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/U+4KQP0hwGk1a8NHiSM1xxfBbcnJM4Y7Gx9QhYSdcM=;
 b=nhUlbpMvGdfeEoHhG/NxIVdo0FGBTgSAxTW/0o0RV2+UIlUZkqCU3d5UEU5UciDfrH0SvrftMPGxDYqlupjPYl4cBaAzOP4hS1YKY8bMbIMJ1j5e5htxUfoV+FQYdQMtgNS11pClWsRfedg6fPvkacAe/FKoplQ9oGKwz+1ijk/h2BX/w7cvFAFMJd1nV/ExW3EaEFxRlc9ugeVuBKqncKb9nVd1pCi6pVJF86q5bsBMvguUeQEX/ZUU5wTTZQ2W0s1bvSpsySf1PFXUcwuX57oAQ0tdqCFPXkbaqvpBqgVmyn3+m+kaC7DO2vlWoSAgO/GVf5rEdsjXmNvPXF+6yw==
Received: from DS7PR03CA0204.namprd03.prod.outlook.com (2603:10b6:5:3b6::29)
 by BN6PR12MB1907.namprd12.prod.outlook.com (2603:10b6:404:107::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 08:33:35 +0000
Received: from DM6NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b6:cafe::f8) by DS7PR03CA0204.outlook.office365.com
 (2603:10b6:5:3b6::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11 via Frontend
 Transport; Thu, 10 Feb 2022 08:33:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT063.mail.protection.outlook.com (10.13.172.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Thu, 10 Feb 2022 08:33:35 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 10 Feb
 2022 08:33:34 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 10 Feb 2022
 00:33:34 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Thu, 10 Feb 2022 00:33:34 -0800
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
Subject: Re: [PATCH 4.19 0/2] 4.19.229-rc1 review
In-Reply-To: <20220209191248.596319706@linuxfoundation.org>
References: <20220209191248.596319706@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <0bf5f420-84de-4f7c-9484-b11e72d10278@rnnvmail202.nvidia.com>
Date:   Thu, 10 Feb 2022 00:33:34 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5c25490-f1d4-4eeb-3465-08d9ec700775
X-MS-TrafficTypeDiagnostic: BN6PR12MB1907:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB19075D378A7CD0DC9098C49BD92F9@BN6PR12MB1907.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ferDTA/UKOwj7DA6+l4kYaih8x6yaapG9HojgZJXBa4MtYOptLBIUNjhtkHGWFxIaMbfRVdBf2OxxD0hVrvkBhBjkMG9RuAwf7bknZ00Yg6J0kk675rBmCMDToP4pSoDL4JUuW9rKcrIkKtWBnyM9LQl1j+TpFSHGUXQ7BDEL0dsOiPqgpu+yJGwNMxVrpzSlbvgKzPg2F/h9KUxLiNjlRPlOyOwmomCb98kG8L64PKanr42/CfjUOMfsgFbs8E2RGLjxRplgGOvxD56yQ0KO0TeYOQ6Rs05U1slNL1HvwKjCYCS7TJBQFzlnFE3hL+TN9xVJje2/ftE2nkhBfdNvCSWKC3czPERMtt8VTYFGFwmVTHV51q4SqZfJI19NuRxK3uZU4T2G/L6HCPAKHiFz8qzJka0aJLy0iZQJ30FWcXCHhe51hSKKS0Br56Pu+7jxKilDaZCH4E2mQlRXfWgkvofwfyB4JAVEKAou+Pc2men3lJ1lOOFt7PGqEjao5pr4ujjs/l3cGHVxz/fRH+7eaxCVYjYVsBnaq5JbsmVXbGWc7jnhQuvZcoZIgGpz8NeXO+4wkoq7Jbl8TtQsQMRYY1KCp0ihl2DuNoPV49PLtzPZBbtYeg77MxNQV6EyZvyR88Z5sSIYqgYcI9SIdLeXLbGW3uVtXew91rVs0E6hLIySlrQT7cMnTnBHl41Ruqe/FaRuTI2A7V1E8YUo2OiXvSM/2pAPRV7Oqmumu2bWKmWXVX/ditLP1Xt9YFGZ9k+rYiwugDCdq3FVGs0XqSKY4inuJHX43c4UAozkxfifa0=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(81166007)(8936002)(4326008)(336012)(426003)(5660300002)(70586007)(31686004)(356005)(70206006)(47076005)(8676002)(186003)(7416002)(26005)(86362001)(36860700001)(316002)(966005)(82310400004)(54906003)(508600001)(40460700003)(31696002)(6916009)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 08:33:35.3999
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a5c25490-f1d4-4eeb-3465-08d9ec700775
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1907
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 09 Feb 2022 20:14:02 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.229 release.
> There are 2 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.229-rc1.gz
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

Linux version:	4.19.229-rc1-g020dc380ec76
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
