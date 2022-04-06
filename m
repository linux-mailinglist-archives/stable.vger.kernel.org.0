Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4C04F5CBA
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 13:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbiDFLnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 07:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbiDFLnT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 07:43:19 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2086.outbound.protection.outlook.com [40.107.220.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BAA5826C3;
        Wed,  6 Apr 2022 01:29:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lm6emAr6CtgG2KrWwTl7kvIh3u0JhMPQL9dG3VTL8EbtgKkOqkSHaUgqFy6C+SGOcE3CfxxY3b+vKw7KkhQxyeYAdWE1VcV8poW4jpz7tTCL7KOvDdRkyrh6fM6SRUAULqJI34RRl2k+UN0Aooo+pbp6H6mo254KltR089r0+Z8E2lXIXXfJ4nzyDWkglGtenNBw7g6qw5qXPaLreF0SWOuuIeEE5oIgBrIU4dWIY6R3tWr1K6wv58zY6Q1zPaqCdD59+oGVs99ykZhcdY5p1vEHBdNWJwel1PzrwXuBT/ivY5YRqE5M7WnpfG4LBGP+CPFVCWUUNm8CeA7vjDli5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PfsCml+hYApcnyZVuzGqGs4CE8X4efvXifaXlgMQjyk=;
 b=OUptIfXhq7+hnyr6lycf20xNBgbylgdUvZBQTHcW05UeqSdktPDWsMl5RmnR5NIpwGYVXzL3mDfSdnxTkSNgECbtq64erD4W+IvBXhDC1sFSL5xZgDS150oEHMRC2qIkxe9xP6kvBi0RqIRMqQ9yd/XzrukT+qd2MshysywiqojIY+YTf6lfSvyd94V9OIGhaEwVyp89OnCpkWaDPQTKDil/5OGpRKaxaB8bTHrjlq5S61Bm1O85tk26rfpj4dYEe8kM1/7ynZyMO5wEXWs+T/8Vd2FeO+ElWS/BGKCuzslK9xwhlpfLNnIhrADtBR930BYG/ij7yoYgghBCU9XiQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PfsCml+hYApcnyZVuzGqGs4CE8X4efvXifaXlgMQjyk=;
 b=JH+9c6jahIRSW1Lkp6I9zG7f1iuvBniBZSzOgEsZCp2v/sbbf1sQ46wPDNBcV0RwBDx9gWiUmrsrw/qYfIearYICeZfMjrL5fAqBQhl7DP8NYKobO/OGi/qBFvraGcu18HmuqxrRKFcOQlwb5up8jfuEQECEwnBNGFwk0FZFxLAovd9GqHYtnEAwOOSxAjQ2xvimi0DR2s4JAyVeGCmSMQfOwR+wKUDXsiAXDcZUo6/H5bINFnVHcjdibvhmH1rCFmE7xZfyK3Hq2Xj1+XxO4Q/Y9cPwyzB1WqCgvMx1rj+WMbiKYMGmSBLhm+BdJPDHFH6HqZa+XIRsMOLJS03feA==
Received: from MW4PR04CA0180.namprd04.prod.outlook.com (2603:10b6:303:85::35)
 by MN2PR12MB3293.namprd12.prod.outlook.com (2603:10b6:208:106::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 08:29:33 +0000
Received: from CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:85:cafe::c) by MW4PR04CA0180.outlook.office365.com
 (2603:10b6:303:85::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21 via Frontend
 Transport; Wed, 6 Apr 2022 08:29:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT015.mail.protection.outlook.com (10.13.175.130) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5144.20 via Frontend Transport; Wed, 6 Apr 2022 08:29:28 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 6 Apr
 2022 08:29:28 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 6 Apr 2022
 01:29:27 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Wed, 6 Apr 2022 01:29:27 -0700
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
Subject: Re: [PATCH 5.16 0000/1017] 5.16.19-rc1 review
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <0ac997df-fb13-4fbb-9182-8a89fbc873aa@rnnvmail201.nvidia.com>
Date:   Wed, 6 Apr 2022 01:29:27 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1981f1da-2508-43d1-3e5a-08da17a7914c
X-MS-TrafficTypeDiagnostic: MN2PR12MB3293:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3293A3F4043508AD91801560D9E79@MN2PR12MB3293.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OwHgyRkGQudm79HSVJsb4Ddn0i22dbdVCtYwiwiWXpbsfMZd4RbbRBa2D3muZbELxGF64D/RgXrB0nAzLqWU3L3OmVOcjWX5Rp7T/GVH/7jr3ifA8z8bZ+upgrN0p8RJJcT1Onrwr3Fjb28zLq6VmsqCXH3jDjrEhnmMx2g7u0iETUdh420uqOpBsy+G6mAW959utvTHY96rdHOjmLcko2qEDQXdn/hcRw8n2elNAsoeerCGNfaCQbo2F3t3YSA/uk5b6NJmirmDM41BlIxiLYoyAUU0DJRNzrMRnDid1J9PsSdsF5JBCWDao9VXprfEnviQqIce3KuYTFMJuWF2fYB9rJbBM23m0g3jYHvNMlEMMOhgqw2TWQsaQgFb6h5yKpNHFjWCPwEFolkTzZaDf2lEYSDSbvgEwjRa9cJTPc4WSOH78mGj0/Pq6/mcD0qhSjNXavnXcN4GuhVAtHO9rrkBJ04cOJzPfIOHhKSdPjhi3sA2Yqexp7aW507W3OoNZZIaHW2CQ3p2imfM3d4kp5jsiU+mkb3DMMdWB9R2Sw6DliN3COGcU0uI2krbdyB+2jL64Fz9FMVr9o+zCBx+hF8sg+58uFNb9GXEuGlCYFR8y3rShv84YF1AUlfRivQSpjbnbCxyuUTp2tInrsLRO3DGIYdgONfnY20Aj+k7cd6mtKFPzjVve+sQCPEguCR7S5l1sjCesDsH+vEaVnOgWn+obOypRPjxQm4bbq+T8e3QjjajLtX3zXQVO8OvdaLh6a18huQ1GBIAnZsjJ8QSGr/lH3sdfYCvroD+zDFAOSQ=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(316002)(6916009)(2906002)(81166007)(40460700003)(186003)(26005)(356005)(82310400005)(31686004)(54906003)(8676002)(426003)(336012)(47076005)(86362001)(70206006)(31696002)(70586007)(36860700001)(4326008)(5660300002)(8936002)(508600001)(7416002)(966005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 08:29:28.9923
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1981f1da-2508-43d1-3e5a-08da17a7914c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3293
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 05 Apr 2022 09:15:13 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.19 release.
> There are 1017 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.16:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    122 tests:	122 pass, 0 fail

Linux version:	5.16.19-rc1-g5d3da1624789
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
