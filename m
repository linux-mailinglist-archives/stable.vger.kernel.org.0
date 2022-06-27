Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A33155CDF8
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236835AbiF0Ook (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 10:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237278AbiF0Ooi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 10:44:38 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061.outbound.protection.outlook.com [40.107.93.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78FC6DEF4;
        Mon, 27 Jun 2022 07:44:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SybcztxmN50t2IOO0r81CT57EKcp7uREM6f6KFf0PeipNGDbvCbClPPBQsoy/1SC47udBALcb8bfyma77AAvk0RdxoCdv42MNuB/gfMJ5tIRYO2RIKUlpBH+Oy1/OnWHZC5Hu9cdLzd9Pij2sUpiD3AXVUEPxWUaAUP1UAQshK9AU9Cdt6btYnP8avbZcUQSbiy5InlTDRWyJglziA/yLzSmveJcIEpf1uAEiM0EL6Kwa7vREgx0wV5NqDpbad1VPfQ6owN5lpq53vhUl7IoQxjtsvGM80L4jAC/gnd4XuVVNK6VHSk7ZreBRP+kAExy6Hfk6J+rTnUnPVG9h+KGKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5b1cnClEkkjmCw/70jVHN27+WWRDiYebw4EEpXfqf28=;
 b=PsUp75me/zA/2A9eg4sj0Ya/G2T21cQ5lGUWAnSdnanKQNQgdf+nB687fE53VcN4KljpSzOzY+/CTV1hJjrVh6kYL4/M5qai7UqjgQBa6jJaqSoAudyKcbUNN22ddEQ5TTEB5iysfca/VM+qSI6v9yCPrzgjEbxKIsew3ry7i6zX81d5rAj4/vy81r0CArqh060eep3V6VE9Wru9oD/2mK+mFkoDHjtsEjA523FryZLlUGy5Kn3Bugi1Uy2uuLqTbRdgfN3pVGe7iGKwYfB4WriweDwyxo6U1Jopxw8mtAScbfYO6ZlLwVlx6grZlaqukPtHb4Z3phJa+SU/x9xw+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5b1cnClEkkjmCw/70jVHN27+WWRDiYebw4EEpXfqf28=;
 b=kEYzWEjGAD/XTZIKg6nuI44dIpqMcDKYCS2wF3O9pqXhSSktnq6sowTF19gy3NWiK2aE67vprjMpY6mfq5Wm6dlOPAxwdb/P/Jllq/SAAmNEvw1wDg3XFdu+iuftKGWKBLFjNM3hBVkYRUlMR9zAU4TGfMVt8aaB6nXkkTcnw506gLA0Tjf7iYpN6xjXlM5rFHUIbvDgcM+csi+LptKZuc3ZK0KD4gGFLWEt5QpNVmYA5ep6xFiZtztbpKww5cZLsSFL8LjjBwCkyzbcmcOOJlWxNK9NWg/CsdKqj0ZnFXsM/pUnpfNh81fnh9GDDMG62/TbAzcQb1hbXLbrSz6OAg==
Received: from BN9PR03CA0654.namprd03.prod.outlook.com (2603:10b6:408:13b::29)
 by CY4PR12MB1398.namprd12.prod.outlook.com (2603:10b6:903:40::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Mon, 27 Jun
 2022 14:44:35 +0000
Received: from BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13b:cafe::ee) by BN9PR03CA0654.outlook.office365.com
 (2603:10b6:408:13b::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16 via Frontend
 Transport; Mon, 27 Jun 2022 14:44:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT028.mail.protection.outlook.com (10.13.176.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Mon, 27 Jun 2022 14:44:35 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 27 Jun
 2022 14:44:34 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 27 Jun
 2022 07:44:33 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Mon, 27 Jun 2022 07:44:33 -0700
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
Subject: Re: [PATCH 5.10 000/102] 5.10.127-rc1 review
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <8b87c1d4-b24c-4d9d-b533-2bdcb4913326@rnnvmail204.nvidia.com>
Date:   Mon, 27 Jun 2022 07:44:33 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9be2b6f-8b98-41ed-3ee0-08da584b8de8
X-MS-TrafficTypeDiagnostic: CY4PR12MB1398:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eGDWsBMmMA/D5GfyOuFBltqZxxVtolNuzC3jNCH1cQ06H2l8pIEehZuSSB2UZWf1JYDwtqIAtAUrakqSbscQVVt1g90f0EIhXMyFZm5YdTLX3LUX/N/8qzfnxk118SBEBT6m61bp3v2PEYH4+seYuh7Uymj16Cb/G00mBk+RPh6wEnOQx8YZCFL9gOvcx6gOngXPP1Gnkt4vxKO4dNPs2ND+Vx4MZ9kaAV9e6CrXwR2D0FeBQlFrEVUwI7JD6mvAaYVlPwfGVj/lsP9JpIlLkTPOviNg8gOLhtkCxe//p7ibZq9qLa80dDFPthcNLENEY6ls1OoXJUTwGX4URaocUFdpy0ofa8ViMigxtJBrda63NAZam0vxGzRDl5KNTALHaNQ2t1xyu0uTBWwTGay9oEfYAtq3jfbykHkiLclFZLL3wPfQluNxcW98FjBw3V2QT6EyQekHBZ8p3fjC81oDoqGjWIj+CZgH5KE+eUpWJJSN3IUcbJw82rS5+hM6Op7xz9ez0C8kVNtr5ryDGqAD1IwugHIo62hJK/kcohfLelc6GK3fdUksXVLDIxSjZ7mBaSpSM54SBrF+lcQLtSpH6WY+GzJdy+qzJN2ubGWk1/0pC3xoXVNeftuBNtbwLivu3Yeu9+gOsSgedf3/aMUWJAT4NMuSlmMLScwHXkgNR3gBRo55vhl9wecnSWH4MFysMAvyyHkZ4hcIdugM4vlzcEcFaYewdPoHIMGYtHK9o15RJHqTlD13Q1nK05gnofhtNjwnfO/7cYphgUe6w+Uz1qMZlK9GK5svxMsSYXKN4EbAYGHfzZWm42keWLYTkLgM93gV5YrDPIjLbp1jYzvM7liky5f3X0E9JANspL76LkdJEoDXCYJiJpU4Bm7vDbVa0E5fS1pqz2jLrK86t1Ff1IJ8dh89Z9B4ebgGcfO1AzM=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(39860400002)(346002)(136003)(36840700001)(46966006)(40470700004)(31686004)(26005)(478600001)(41300700001)(7416002)(426003)(6916009)(40460700003)(47076005)(2906002)(966005)(336012)(8936002)(36860700001)(82310400005)(40480700001)(54906003)(186003)(70206006)(316002)(5660300002)(86362001)(356005)(82740400003)(70586007)(4326008)(8676002)(81166007)(31696002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2022 14:44:35.1383
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b9be2b6f-8b98-41ed-3ee0-08da584b8de8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1398
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 27 Jun 2022 13:20:11 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.127 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Jun 2022 11:19:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.127-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    75 tests:	75 pass, 0 fail

Linux version:	5.10.127-rc1-g0075d2af9da3
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
