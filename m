Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 763EF4D51E5
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 20:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236740AbiCJStp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 13:49:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245589AbiCJStn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 13:49:43 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E7E4D9F0;
        Thu, 10 Mar 2022 10:48:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cbt5TmjbM0aOUTr1FXncVXLNhNbdbgTYHMqBr6FOylEBx/H4vRwp9fMi6sxgb7tZI7akKh3KbaJ/jYr1Vfv+RahMfRJELluLhS0YB6OrNhzaARt/uPvM2JeJODS8esvc2MQUCXpZZIbKggZyHEBH35kRaXKSaACSINqFtEBgLkdu9ONXeyDrEP6pz6vqEjl2s9xFgyvam8pT6Qek2mJqt7VtSeVAxIxxqDzu14Jr2yWV5/LOqijoqOvk1I571kgI/TJHPUoBQxZ+8J8XsxnkB601BIpwqjauSFSlBbqGBzxaNbgrj61IHz4NHmEPWlUy6FKuyi2zaO92ltSnPD0PDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Q5uV67diWQdbWdww6CXmcChiDca7DBB/VAiJLFFHLA=;
 b=RdIakqnbiSlQDJcC3+4n2PT8ux/RPg4vOVt5JhDiA5Jck+GYHbTdkr8CM2SWXpFb6fboOIHdLGLieH/OuMHL7bvusmBhy3mKLv/+fvDtBa4AXmIpLZ8Hv4kHFmDXAf2l1gsVs4NA2LijW7/7zXrR9mqxTmLfDakyaDBZFKebVMFBvQHVcHhNFh5aMUos7Cr4jeD7ZAFW+TPIivHixJCU12l0t1nEWXQA+RCOVIf6SUuErIZgRnh05te2xX9V43l/9b39C50In7G+ejhqcf14emsgKLQIbvTbMQ7jlP+LcV7HJjCtvCt3jUY0u8D6Zinf/KURpQqOBtWULcEB1G8xJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Q5uV67diWQdbWdww6CXmcChiDca7DBB/VAiJLFFHLA=;
 b=pG1dmQsI/ooiJHJ0h76GuB1gsedmXOYZjurf/oG0wMxWYuPflhp2hq4UYXYu6zzoxMx62KQigN0j8DkVFx5B/IB7lNhaZarqV9FrxprIb2TH0Iy1PNl7RYbxxkso5G70AwWMb/nIAhIFl/OjBXmrQqfkWZw4JBMIYG24SPYua5Q23iGUjYC87z4XOrMWRh2FvDnSBTrdbGnZ9tN4pjOhDwmxzFPf5+7EU+LVmhBi5Tl9hQUBbip2Do6ibg1ujSw32WWQyDpa1q4kl3CRMeSoUIEcFbEn87eZ6jcEd70LPeadLvEP/dSvWjyDaumUM7zpafF3lZQQ+nzB1oypo3EhkA==
Received: from MW4P220CA0008.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::13)
 by MWHPR1201MB2526.namprd12.prod.outlook.com (2603:10b6:300:ec::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.16; Thu, 10 Mar
 2022 18:48:40 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:115:cafe::b4) by MW4P220CA0008.outlook.office365.com
 (2603:10b6:303:115::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Thu, 10 Mar 2022 18:48:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Thu, 10 Mar 2022 18:48:40 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 10 Mar
 2022 18:48:39 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 10 Mar
 2022 10:48:38 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Thu, 10 Mar 2022 10:48:38 -0800
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
Subject: Re: [PATCH 4.9 00/38] 4.9.306-rc2 review
In-Reply-To: <20220310140808.136149678@linuxfoundation.org>
References: <20220310140808.136149678@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <f8bc5b69-b87a-4f14-956b-f2d23e3c461f@rnnvmail201.nvidia.com>
Date:   Thu, 10 Mar 2022 10:48:38 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c52bf565-0564-43bf-425d-08da02c697de
X-MS-TrafficTypeDiagnostic: MWHPR1201MB2526:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB2526BFAD085A45EC0668E49FD90B9@MWHPR1201MB2526.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /tHhWqAxjBRJfdhGPUOm6RTxqJLJvBiV4TLKx8apXTzCCRa3jXaw1wOAMf/TRLIcBXV6HF0E1P5BGLCfe7ZTyhKz2e1B9s4OlRJMAgS+MxJFdqC2qWJ5HNRbdczKnW3j4pwb8EAUGL1gK92XMsg6XqH6lHAbjNjYRzli/su2hXMz9Tv5h4r+Qp6hrrmOOpwP67ifOfWn7CDoCCCDDi+T3EFm7t0Av8yPlraQOKbkYB0Lf0OIiFyxRGvSl3hzSIizb7AmSwgyb0Zm212qrRZAkmslN0G+wcqTEuB90h51r+ia+jq+22BnPcP6qvyDYTMMMIR+400RqbttXxp/UIWZkSsW/ALqY5pPcIfI1NxXqcpPCwcbOTRuQPGtiC0eU6qwftCrUwYdq7D7803xAy5i7T3cgG/PzRrwAkOT6W1HaGRqSvgksgKj70o9tKl5fiNRa9lMTVt4SvcmQZiiJkGaUCco0wD2/JSfdYjhGJ6vU2x3BzPTgDI4sOK3/1v/UrgKE+0Ys6biPAihlcLQImsSl7CGGNw/CQOYtjT8sIE73v6zhzWJftaWgTZAsxNrW1w4ob27DyVyKQjEC8c5Q+T9T0xoUazOlagoKsmFwyXZiHIcPQTdSEKhLxYYuBAXZFVURq6MrCkiTLy5WhgAzEbpHjJRgIa+aUsAR05jG3V0CEC+FWocQoRZM7jmNejbr+F6mv0tsn+0T3AcXwM4JpFiDTymJww/mFZE3WtFT7yq01eHAhX8LR3Hbh8dRre/2LjBTuwaMh3EXRkLm8ejVxDbY3Q1tDCRNIrmPvTFcD0hGSg=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(54906003)(6916009)(82310400004)(356005)(2906002)(316002)(7416002)(40460700003)(8936002)(36860700001)(5660300002)(26005)(336012)(426003)(31696002)(70206006)(86362001)(70586007)(4326008)(186003)(8676002)(508600001)(966005)(47076005)(31686004)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 18:48:40.0114
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c52bf565-0564-43bf-425d-08da02c697de
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB2526
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 10 Mar 2022 15:13:13 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.306 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.306-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.9.306-rc2-g274dadc1cdeb
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
