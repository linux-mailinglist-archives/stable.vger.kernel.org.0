Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 621BE529B1E
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 09:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbiEQHkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 03:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242334AbiEQHj7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 03:39:59 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2049.outbound.protection.outlook.com [40.107.94.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2616488AB;
        Tue, 17 May 2022 00:38:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lo8hw2MgFGPYLWSTtfucf01dTcZ2UvHRxcjgPvAclFKeBVNKEZzj8pkDwX1ycPtiFjYrDXbVt9UnD0HooxDtlDFtM2A4lBWBZsoJb0fXojBrC4dKk8g47cPCudCXOhNc00Kbf1+tFxygWAHGzugvsQjbfcm5OwCfPtD66c7QnCKWtoeltjpSslyf4IzEud8yf8KFTjuuiwRoqNfLegRUV+vPZgsdZoAx1u5EI5d2G5sEqgEV7DuBDyJPjLE5ahiFnYO86SUNVy57TwQjt/R4FCNiIKD9bWmIuMyK0U1SqtDQRdDwjp86BU72/5zRUH77keMnt/pDrvBzZaxzUBijYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kn4BXPzKqNNZkynBAIKhrw1zMaiNex5I6drgoFAciZw=;
 b=PqYi8VypXCsaqdGQxHvIMJsDfUyIBURL7jbh9oWHZYvszB30xZ5i86hhN3ZwDZ4y5afZl7RyHa7wsiNqrpfrychyjm2+lPP6DFmbFDAXO1aPuQAw0YmPyxBaFyUzuQZmxvVG7qIZDUo+KKGM+N824wN43G79uWrL4ujj4vXuKwTHk1QAI5jO8jguk4GAwBDU18otgUZ4vFPswZ+PuHXUy+v9/m020dGD+eScHFdiscsp+pZkdCBvH8TEFKs275kTIX5ggLMSLuBspnTWZ6mYDAGUsmWpbb85ln6CALVvEb8OW2ch7I1A63rXYde+XbIdcm5l5+GW9kjkqpyGX6pLlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kn4BXPzKqNNZkynBAIKhrw1zMaiNex5I6drgoFAciZw=;
 b=FdG0n1D7EErG1LJajORb/1Xix60W58E7cPWxaXN+Q6nFpKE7LDMlfF146bcurC+D8qsAyF6TWktyVTjviF2U/2xIgN0YzrocELAhCkaPoS5egTplZtoBgMNqQlROjPUKq6Xd1hiKZCPKJbDHwat4LwofrDpDNFjUpMKArTp5RNWAmObzqQb83AhXaCTyQJbh0h/NYFS7VrCR3X163+fKD3IGXmymVI8ZswkFOSx0rTo6CYXynGSYVOfCewyrjbVxRNL0Avd0e658seoNeu2T87i8woIdmjU75BxW5vSj1a2yUfVUIyVbiTKWnWapTF23tiWAF0VD6iz5dy874g958w==
Received: from DM5PR07CA0052.namprd07.prod.outlook.com (2603:10b6:4:ad::17) by
 CY4PR1201MB0167.namprd12.prod.outlook.com (2603:10b6:910:22::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Tue, 17 May
 2022 07:38:27 +0000
Received: from DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ad:cafe::c6) by DM5PR07CA0052.outlook.office365.com
 (2603:10b6:4:ad::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18 via Frontend
 Transport; Tue, 17 May 2022 07:38:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT034.mail.protection.outlook.com (10.13.173.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Tue, 17 May 2022 07:38:27 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 17 May
 2022 07:38:26 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 17 May
 2022 00:38:26 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Tue, 17 May 2022 00:38:26 -0700
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
Subject: Re: [PATCH 4.19 00/32] 4.19.244-rc1 review
In-Reply-To: <20220516193614.773450018@linuxfoundation.org>
References: <20220516193614.773450018@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <63d1ade6-33f6-453c-8070-ca79aff7b7e1@rnnvmail205.nvidia.com>
Date:   Tue, 17 May 2022 00:38:26 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f63dd29-83b4-4538-0d3f-08da37d83b6d
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0167:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB01677A3DC272052EC785D2B7D9CE9@CY4PR1201MB0167.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e5uvUYgx/hWVdXZ2esfm8sTtAtf3FraeChkReYJdtgiWLKtZ3srHohZuSjpY2gTrib13mAflZ/WkylF1j2Osyr5ROs1xHfE4qCiGyqfT41TXstlJXnkgPct09cWqxpFH/+c1vcjWYRNFZG2Cak9Mqrjsx7uo0OoHiSppVYUBeeknFO/R/iKgGJxB8w3ZLK75Ou3fwCSP9DmLnZSP23A3sRBopQno/cCgKdVJHWPjJBrFoznwC/6qZ+CvEplW1BJh/qa6U5rO5ZxT66F03GgZsOwYcQ9RU8PwxX7RZxy8giMOX0LbI+cEAsUivF23Di1bqA+D40cRFkZ/yQY2g6917G+fjM1wbMBsJ2pLxvabYgJ/1eM/Fg9eUKHWY9XQshX/SLisL2Vshkwb0EuXnVvUiQQQTDmKibny48q22gPYKfCrb5+itKvzT8OkWZsBYdJQ8oXc2b6ZXjaQ9WEoThY6+/ttOj8iuYe37/hDxn8ljyGc43M5aMro2fda28qtBMjARgy8MAQaK2sbm0WpMtNzwkTkZo3lvmdLApZk/A/sg5MYb7TMnUzF1NY3p1ssyttixMJ/aPAGa+zjNCF/T9XRSdPLGeVVBVm6Urn+dqP/Vw5ZccNdqLaCRmFAgW/T/fyER20jHO7GS1ocskENiWAuEUYaL1CWnjj10dpgYjB+gNZ1OrdZ6q4+V7A5fl/ZuyyhQuVQu1UywYIHblavEY8DLwyZ7ZmWF39JokrsRPKvXSlvopKqtXlVgiVabOoiD6//rBlvKvnNxeKCeCg+OsG/ELqyi3ihxKNcFSODzakhDtQ=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(40460700003)(2906002)(316002)(6916009)(7416002)(5660300002)(54906003)(356005)(8936002)(86362001)(31686004)(31696002)(81166007)(82310400005)(36860700001)(70586007)(70206006)(8676002)(4326008)(508600001)(336012)(426003)(47076005)(26005)(186003)(966005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 07:38:27.4562
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f63dd29-83b4-4538-0d3f-08da37d83b6d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0167
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 16 May 2022 21:36:14 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.244 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.244-rc1.gz
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

Linux version:	4.19.244-rc1-gbc41838f2dd8
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
