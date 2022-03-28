Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 296CC4E995A
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 16:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243693AbiC1O00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 10:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236954AbiC1O0Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 10:26:25 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062.outbound.protection.outlook.com [40.107.237.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC3B71EECF;
        Mon, 28 Mar 2022 07:24:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nE9SkGl9BWeLteU8SJMDn28DJ0xYl11oTEFebPhsG65xKC1iVrc7dljQilwnTlWt7/e0ppBLojsCX0ypyYBrZ3TplKzZ6oR3mhFsbDnAb0NgQIWDAYiEN4pDRd6RBI2AJig01vESfud8GcokrmodLK8iTzzPUGtQ2qTrOWCmTjtU/Pqhhxk89ZUP4o0q7pFLzPd3DOOrDSIHL7p2TkNFd1ibrHRKItWHh+/VFrr+/zBCR7B08e3AoGGkHuOTJTuKK/h+RzMjbjZHqlJM0eqDEz+go3wbpGSRs3M7lkBCRQLg0JpG4WA6gTq4iu856VkoKuqD7yVaFmlOcZuX6rv80A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K8H4yUPrUkXx7l7vDqxXYakSCzduOc3/8ALQG+j24ug=;
 b=RYzwXr2UurierFbaLh3EMoROb21jpf/Cov8wTKjZIk4jm7Nwir386zek+VqNakZZ4q5f8U0SLtF3zHgHS33q96IBdfNErygd8b0n+o4sJPs2oo7LoZkapMoVjVzWI914+nRCh/TKtfI2REf9sC0CUj+c1pqA5uwKdQ8eBcu35Dc4KKjbc0ngk6EpjqZlkIn36I/CZNVLYaLrlnum0U7okq1CVFoDhAKylbs4ARq9b9Q1ZQK7s2tXN0ZIo8+J0CjgxByoEyrBlW+HRvy2jrGY2q8bOr9Mm1YSg8O9BrJ6GE+12A7DMEvn4UOT9yXddNbZIPLTE0EO1YfxzJi3u1D6fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K8H4yUPrUkXx7l7vDqxXYakSCzduOc3/8ALQG+j24ug=;
 b=Q2NRWk43MdGnZ5J3MHXANPioPS9kt6guMs8KU3aBNjU2Ev+N7G8+x1a+ivHdN3Kkj93oYHCMw1blTqXLLdqyaQQwk1VQ90O1SdvSBjdnDGHAKJBt+O0ZZ+BqTlqQMvY0pL7TehwlbJ4b2oCVkTAI/s7WNoWw0j0xYyUN+uy6pZODr49bFqR+cW2iLiWPa2smOW/eoHzFrkoxlW/xTC2Moba1q9RShj1vrPXZeIUzFm/tbS0vVAxFSZN8IRXOl5L8UTBfPYFpIZhcYYv+t8B8c1aQGpGtQnMtAfrB4wGA16f4bbVIHxDXCh4hxamSkbPmOQx6hpGht9V2B3Sb721H2A==
Received: from DM5PR06CA0081.namprd06.prod.outlook.com (2603:10b6:3:4::19) by
 BN6PR12MB1587.namprd12.prod.outlook.com (2603:10b6:405:5::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5102.18; Mon, 28 Mar 2022 14:24:41 +0000
Received: from DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:4:cafe::81) by DM5PR06CA0081.outlook.office365.com
 (2603:10b6:3:4::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16 via Frontend
 Transport; Mon, 28 Mar 2022 14:24:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT042.mail.protection.outlook.com (10.13.173.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5102.17 via Frontend Transport; Mon, 28 Mar 2022 14:24:41 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 28 Mar
 2022 14:24:41 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 28 Mar
 2022 07:24:40 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Mon, 28 Mar 2022 07:24:39 -0700
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
Subject: Re: [PATCH 4.9 00/14] 4.9.309-rc1 review
In-Reply-To: <20220325150415.694544076@linuxfoundation.org>
References: <20220325150415.694544076@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <44817d74-db42-45a5-9ec8-d0a9d74304ea@rnnvmail203.nvidia.com>
Date:   Mon, 28 Mar 2022 07:24:39 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b599b75-1b3e-4919-4e04-08da10c6b2e7
X-MS-TrafficTypeDiagnostic: BN6PR12MB1587:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB158737CBA8EBB2BDC7FCE737D91D9@BN6PR12MB1587.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ymLrrH9q3JL8SgSQA29s1Smke5ur1ze5xPznNH+F3UA44Y08+wnLn4HAjSJJNzbHruRJ0roiGFFpxsfN3Q09AG7d7gnMOf2hNVnm9If5C7lv2s9WP7EFQ89bsQJlc5zFlAXuOyscQJ8g0K7O2g9UXyrklmuEkJn80P7FqjDUbFlMpbG1pXc6Gwr2zQn5Qsbk4LUZY5jCY2qufHNCGYVky6kOa0AktTDmFPYUEIso+hs/v0BV2gkVt4dCoKR4SJBwYRicRodPrD+4Wj3i/9++lKDNnNM4WsFER7leU+fCUCY3MTxe44VdcuQuD6ZKA+nuH7mQqo3gZq2iD66utSiSY7Zfdrak0kZ4dM9tG6IUIbVZNgj4M5UFSFbdv9y8qXWdLG3VoMWs8MoWLFipcD03YMW9lM4vASZjIt7cpSuscbxYrJwAZXkHmQiM4ZxtMybIZC+hW75VZrf8dNnkNFka20XCb6tdvHKAB7M+5nRc4ABXVM3A2jdk6WMzfgDs6I4n1sxZGF4DJ6Wk7BzQXaw5faprMJRTGzDlPCzYIUbv+tsl6Bqyi/+vk/Ut6XyFf2NVd9BBRQ4lCS//3ipmba+OoRP1c8IlI+I84SquSpW9+mybaA8/yaJjAFX0ee/MXyRDJYPbYPpanV5AYOpnD2qPuaDKZGs4qrA/Y6wKg+d+a8WikrllGlTd3njiJEeitCU8pKIHS9n+273mju9yNG8c/O0DIGdsam1a1lnsjXjwTKniT9cHhV8l7pIRUDl5eE9a+qOnsVb9b7ib0NsYBByipH2sdMrcMfbgtOe+L9ms8DI=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(31696002)(81166007)(86362001)(7416002)(2906002)(26005)(186003)(8676002)(4326008)(31686004)(426003)(336012)(356005)(70586007)(70206006)(316002)(36860700001)(966005)(6916009)(508600001)(40460700003)(54906003)(82310400004)(8936002)(5660300002)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2022 14:24:41.6168
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b599b75-1b3e-4919-4e04-08da10c6b2e7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1587
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 25 Mar 2022 16:04:28 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.309 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.309-rc1.gz
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

Linux version:	4.9.309-rc1-gebc053b844b7
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
