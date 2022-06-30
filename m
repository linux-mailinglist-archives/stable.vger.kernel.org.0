Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3CC15620E3
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 19:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235518AbiF3RKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 13:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232034AbiF3RKY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 13:10:24 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2042.outbound.protection.outlook.com [40.107.93.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8193C4AD;
        Thu, 30 Jun 2022 10:10:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cq0fXBDOflLrfWNgGAZ2t6XOJxbNR47iN1Rxqd10JBTQXuL6GDzPJSjsxB3wRpUrsnOtFR9qEUnOtXdWCNwVwjoiI+QRxcTF9K8sP2lmj29hMeFZU/81J3FDxz+XHgA8c8eTqNmxciZUuA1FyH8j3WpTvfAhXcKIdm4+wcBI8zxTvOTRUQI/X6BIRWfDc3Sr43ZseEIjxx4vl0sH4lKLRPjsz26tEn99bfAA2x4nwai1n/lZrzYmwPJK82Il75UPMSvra0EwrKAb8SkgNW0jMeXg9isVTigI0ROH23QherFFOQqe37dAmyQ3lVzcsh+6jJ5shqNdfs1rZxaCeQ88WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8B4Y1KRk4sl7dbXNxlY9nL8Dtujx+uh0Sxd26ntF7lM=;
 b=gWEbJsrVWugVocJ7z/VZ+KOhEAKvTL13qoO8emCOjWwBrfYJKVjVfkhXVwHa7VmsUCI8Gk44CkcUhZd0jN/Cod6yGZdwBMlCe7foOye8jlUWtaDB1WotU2fG1a7328ipycC1QYYmB1j1J9oowI55PBFymTAeR8CYR1+ND5en4MrIQw7u83o92GusZJ5d579+9rvohycx2KuKTBH3KYmPY5U2aq1shBE5SffBoT5OMqqHve2l4yEuQh9RK4WtnZqW3AmzO9N9Hr08jVTl8qIyg2kCzFzUUh+vDV4FGqY7oAkIV6HawpPf3jmz/HjXOFR52d6qYE2kLk9GaKgI3nvXTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8B4Y1KRk4sl7dbXNxlY9nL8Dtujx+uh0Sxd26ntF7lM=;
 b=qFryW/TmY5U1BNtGoBypduw/0TJ51m8Vk4sUyLWIx+DnaEXBYfJB8KR9p2EohbQHbbo7K3qtjO17YYe4qKATZv1NSnHDSjENA4LROHG8GVwebrVZjV3kh0khT/WvG0oUfLzRcSXBMUIakW+khKyKJLAQs7zzWLOde2cpaIZH9qiSOYDeBu8repmrUFY92FR0bddEy8sNNlvGqUuB1dEqi9QvVwKfYoSTyg1pX93nSObrfgqAQ0oLWNDrcNWxD9p8g7o+phFYM5ACCyv+/Vkxwc/TH3P1C91vmkyxw2XnBTxFKzu0BMOn2S/Hq5/VnOjQR4p39VXAUjQDMI9TsJ4mzw==
Received: from CO1PR15CA0110.namprd15.prod.outlook.com (2603:10b6:101:21::30)
 by MWHPR1201MB2510.namprd12.prod.outlook.com (2603:10b6:300:e8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Thu, 30 Jun
 2022 17:10:20 +0000
Received: from CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:21:cafe::fc) by CO1PR15CA0110.outlook.office365.com
 (2603:10b6:101:21::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15 via Frontend
 Transport; Thu, 30 Jun 2022 17:10:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT042.mail.protection.outlook.com (10.13.174.250) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Thu, 30 Jun 2022 17:10:20 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 30 Jun 2022 17:09:48 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 30 Jun 2022 10:09:48 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Thu, 30 Jun 2022 10:09:48 -0700
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
Subject: Re: [PATCH 4.14 00/35] 4.14.286-rc1 review
In-Reply-To: <20220630133232.433955678@linuxfoundation.org>
References: <20220630133232.433955678@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <deed5ba6-1143-4caa-b9bf-c5ef5a983f76@drhqmail201.nvidia.com>
Date:   Thu, 30 Jun 2022 10:09:48 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb67e5c2-5b0d-4874-9115-08da5abb69c7
X-MS-TrafficTypeDiagnostic: MWHPR1201MB2510:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zNGa23WikYvOJ8OYpXJXDPbjBsW0pR65q+KddvjRGbYg6/dhTsjEWSK0FeGQBMBcHjChSXbyAgZ8J/IHCFhKhOPTDoEzd0C5t+cfn/gq/UCVDQRzHu4i20JEq6jPSNgXMAsMklNOkt6wDmIiFmY10SETlv856ey0IXWnsrrGIsz6xA/BWkseC/PPq7yocVNiav6IM4fmjEh0q4S93rBhe31Uf4W+IGxQyS7lL7MtDqvyPwUdt/yOOzFaeGF68y6YxGk3VPP3MLo5D5UEkngzdz2A5TVdkxm2QCWimYt/xXlHtLFrBoqoIR1mc8NSTOsY4pMJZMNzz8O9aSNtg/UCgIvHDok8AcJMS+ht70pyj+P7R2A+/hoTWhbear5uPlowBGpUBg6s3gMQQqQGt+Jf/GVG7520zdiu2HRV5lho91wL/X6+SOaZrV/hYpsYr2X028KEsxexvragkPppinxWKORj8UH2z7KBHdlDzIB8Rhxi6P75azQQnI26jAmraKUClnhv/O9gVsmNRcqGjm9Wwt4ExJyxTA/YNXkuG49SgmILSJJW0UgJJUFItYzgPDNL+Aolm20a3RPc3zl76oqjsh270ekaWWRvIZ3rcqUVTC9v21ypwbqmHjVPbLU3rj3GMphhYuUOUcfjT0f1T/bkUlsjusV0I2LPbXOLYuTYmj7V7dNBXTr1Ppo39rviX8jraXAZDl0KgfwgepOC3YxbSOemKQiidgHvSubgnYndoxPpHUkjBqYvxDog3TEjz+txTreOWVQPKJ4IY+4OoqfRN6+zCctuv8YG60UdCH9vcMf89s2FeOXGM8P2XC/yGkp6UU8zZ4xKAlfHKqsv9qJcTL+zjCTyH6nAukv6YS6bmvgKB3HKCgHh6UJtbm8YPb+Maw2ZDgwX3oZMZgKr6e/aPKSdnKr7Un3At64wplzTbkZgo8c1PsX+HAaO2zggwUST
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(39860400002)(136003)(346002)(36840700001)(40470700004)(46966006)(70586007)(36860700001)(70206006)(8676002)(5660300002)(186003)(86362001)(4326008)(82740400003)(966005)(8936002)(478600001)(356005)(2906002)(81166007)(7416002)(41300700001)(40480700001)(40460700003)(54906003)(6916009)(31686004)(26005)(316002)(426003)(336012)(82310400005)(47076005)(31696002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 17:10:20.5167
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb67e5c2-5b0d-4874-9115-08da5abb69c7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB2510
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 30 Jun 2022 15:46:11 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.286 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.286-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.14.286-rc1-gf1dcd28ff184
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
