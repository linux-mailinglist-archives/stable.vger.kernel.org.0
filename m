Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAFA35F63AF
	for <lists+stable@lfdr.de>; Thu,  6 Oct 2022 11:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbiJFJcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Oct 2022 05:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbiJFJcG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Oct 2022 05:32:06 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C745A9AFA3;
        Thu,  6 Oct 2022 02:32:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WF57Gem3eyuKemSHGUOcBq7sBnIWQGmAIQ9FIYHgHrIKboonTrw5e08fZC7GEgopSI3Td32pqMr2sdDvetA99tXYqXTcJyRrHOoIn08kM+mUTxqnATAJkv0tG/5cxD0OXOW0xCyYrVQ3qnAIpIrc+028+2zpl71En23meyx7XpVYJymink99UEN6dLmwvF8euubIdRwGkll6JPVA2QBI0L2na3QE2tDvOv97hNTpbkAPoAIequZrwhqTI9owZhRIJt1a0xcCTkGs/VpnRrVfpsE0vNCm1TqjTd/5BFzzd5Xl6DvenFC0waLQCE5zAysxcCe9K/BjdQf14ek7P+wjuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uKhoKgc+ApRwif4elZMau1HGmgtA7EzvvAQ2CEQVA4A=;
 b=LQrMt35GaCg/8ue7cWk6nlj2uGYdHHuBGLFh2WdHh9qjwIek2ZVd8qzEmWbbv0s9bevpzS84u65m0yFeEnVEx0wQ0k8pInAyz5lYC+FtAaTte1MQ3u/x22eBiVcFJWsfNKe1TqT5nZG073FWtTTpbBQbnHgfPSxUgDCjIipqifbXvACdSeLHZew/veCR/yWYu90BAChzikDNwzAu5ql2jCJxniwrBcuaGcF1xQsHaGWikwQyCJyd1pzGxuG17xgK2DOQaS/jDbplYEKypeyiKAdXRAOCtlarY7FqLcsLqBRe6XaYw3zMlKAKAuzWLrfzRM8t3GvEoGFkXPEhA2nEXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uKhoKgc+ApRwif4elZMau1HGmgtA7EzvvAQ2CEQVA4A=;
 b=bYdJceqQs7vNJtOsTJ15SpRQbizx4XV3ljS38qxJlD1zQNiKjcwinLtC8m74hs//RVEQ65WjaDaJK3dhzm4rBGpTUAV/rMaFbhuBy7vzfdVzWkw/nmvZwhgIQm3l9BYo7zuk3SQ/KEv9I8btd+CHyhZ0unZqx36nFQMU4LobzPWoysP2KxkYC3/ZDPVt3FD2wtPB/ctMNEBiIkAkTMF/ocSz2hckulP10o1Wi1PTtKGKyQy6UVdHu/FAaK5PBPZNG/5zi9n/SnxUoJ96xElySa9DHyLLEYrh22vOTo+ToFe6gcn3bJZBqNm8thAb32ogYNEYSFlIEO0/2oH90x6Zmw==
Received: from MW4PR04CA0336.namprd04.prod.outlook.com (2603:10b6:303:8a::11)
 by LV2PR12MB5870.namprd12.prod.outlook.com (2603:10b6:408:175::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.31; Thu, 6 Oct
 2022 09:32:02 +0000
Received: from CO1NAM11FT096.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8a:cafe::c3) by MW4PR04CA0336.outlook.office365.com
 (2603:10b6:303:8a::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24 via Frontend
 Transport; Thu, 6 Oct 2022 09:32:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1NAM11FT096.mail.protection.outlook.com (10.13.175.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5709.10 via Frontend Transport; Thu, 6 Oct 2022 09:32:02 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 6 Oct 2022
 02:32:01 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Thu, 6 Oct 2022 02:32:00 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Thu, 6 Oct 2022 02:32:00 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/51] 5.4.217-rc1 review
In-Reply-To: <20221005113210.255710920@linuxfoundation.org>
References: <20221005113210.255710920@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <9eb1718f-e2d1-4a8b-aea1-adf66c7af01b@drhqmail202.nvidia.com>
Date:   Thu, 6 Oct 2022 02:32:00 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT096:EE_|LV2PR12MB5870:EE_
X-MS-Office365-Filtering-Correlation-Id: 25592515-34e6-41e7-ba2a-08daa77da018
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z9A2vRy461hPnOqyDr9qmh/2rcr88azHTMdN2pbG4BTUskLOArARKzadVNHZNIaeENfCtsorBOFEE0MNZLgyB0ckazkiMJ2g/G13ASInKnmqci3JDlpRXbrmk2LPH1GQKQVO6oycxLyQD3wW3VcKE/OVJ0FOAyOpunpYjHIbtUQF6+0iTfSMPtym0ahIYb1Zc261sIlJEKcEPTFyQgHDEnDtQvSB+hqGXLSpPUEtMIe5duCw42mDPQDBrcmXIxvkFGQoJ15KAMQHD1JC0HiTnq2fEa6Lq5FYWBwIwDk1BaqfRzhSjSfyctTTEnuaYgnM91ZYRkQie5mlM0e2oVHsYk1i1z9swWKkXGZahrixEFefQcfNOmCXwuCISRx0CbrmI/Cu+lbxxZTed4mKL2VsV9bT+67fe4khkpjUyI3jaONeD2MjhLFf43miuWPyjb5wZE169bWxmVbr6DzG7r7hm1dWoreARItfCxEDeUQ9M0Zmbuqec007xijVwfXZVMSBDtsc8ChtJeHvx9OE0LlMx123i0xuMwhzCu2hLT/p6o2ol2cQ9Vu6uclhhzWUJ/gxGEfsGSdHXJK2QFD1SqERwlpN9aVMbp45w9Mfmranf6OXWTG10neugQtslDSC4o6DBEW5As8TVF5350vDFQDoWRtumeeQBYK1+s57cpz9YqwLXexYX8vsgM2lKbqk/DPe3oZSVX8qdlFkgmdHObThmY5eKkxjuFa13o8UMmYLfENtYHx06bSX7hF/1W2qEzBJTYm+zZ4AFnkvu8awQnvWE3/+4wjevmCzhZR4VClj8N0mgHUvlFuNgmcs4D3NEykJ97+lt8jBGRSXzeMBRLYluCUe8ER17Sp24bLb8jO3lOM=
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(136003)(376002)(451199015)(36840700001)(40470700004)(46966006)(2906002)(5660300002)(41300700001)(7416002)(8936002)(31686004)(316002)(54906003)(36860700001)(70586007)(6916009)(86362001)(31696002)(82740400003)(478600001)(966005)(4326008)(8676002)(70206006)(356005)(47076005)(7636003)(186003)(40460700003)(40480700001)(26005)(426003)(336012)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2022 09:32:02.3978
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 25592515-34e6-41e7-ba2a-08daa77da018
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT096.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5870
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 05 Oct 2022 13:31:48 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.217 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Oct 2022 11:31:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.217-rc1.gz
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

Linux version:	5.4.217-rc1-g6376bfa24632
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
