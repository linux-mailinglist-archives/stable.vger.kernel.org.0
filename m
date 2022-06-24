Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84F6C559696
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 11:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiFXJ34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 05:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiFXJ3x (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 05:29:53 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2082.outbound.protection.outlook.com [40.107.94.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ACF35250C;
        Fri, 24 Jun 2022 02:29:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IwgovuwbCLLd5UimTFg/DGZFpWcMuuol4Q26sNe9KkDEyYMzXjOfXrEj5Xdm1AJgwcyOY4vh/DqRnQ348v2X9TZD0FJBwHhLC3M0GATw1mBf3jhaWCEEg5Oj4cAetNuFs+7577fj0gQ8/ghuP8g2H1Cpu9I48cH2jnEWc9boj3sRbY+o1gG84zrEUW7xlVHj9cKs+BqyGj0TQ8oICvxmfXd6sJdrarhyqmH6FtNM2vv7/TqwjOmTXLMT5W25rPLASsnwb2mhdVbCG6d1fruxqIPMfDPr2iaFxAELuOKuModG7jtNrfeibJCgOnpcjAEM977TIbxU1jnm/I9EIG1QfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S0QKO3zObnxP/8RlvwSw3KXpvSeJ1m10PtvpubaPz40=;
 b=JsKdmKueafPLxDqGQEZb0zZuD/kCm8zdCECXeGpEzbVxSWjHRKDqB9iYv0ikoRRRfJN+GMxg3H5cimlgVRAuxmx9w0RShnemNWj8tHXxTWDqWyEc64rV6w0eE0feesqQMex7DdYQF0KiRv+FyuP0Oz1/JTqHf0VY0LecNSbewlRAHqu9Tpp2wzJ75bJSWAGkPiJlrAP40fuQsQuZmT5aZGpjeClLc1d+ClYrzG5qAzGFn4lYLo8kE9ygFZ+X1r3M2034c6x0DLvEFDr4IaDdH6P4O81eON++udRwAdEFnZ9z8D2HrXtASaOYOfiRIfJFzkYLhZE67HWRK5eyPQe4mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S0QKO3zObnxP/8RlvwSw3KXpvSeJ1m10PtvpubaPz40=;
 b=hNolcPRWacDMusNaWAkxFLs0TgaYLzj4oklqK2Lucx2uVhMaA/lh395gZxfMVLE76wEulmCS9yAXvEimYcwRSlb92g86j8O4EXckElTHLVIXZfCoo/0v3HdVwefR8ATCPsytid7h5hrnjez+GM/lGCcXp2ekd07By7LJhYj1WRAa6tBvln9eS39OlS+8ZJDVs3nKufuB15C2lSiRVJ13FjbVdcNpzWU0II7pcG16dCbVg4wFZMPsUK/jNxyEhsLXO9AYwNxpzFiLJa1ZQXPA1fOKFHNIY2b9n0u9xLnHqo2H6H4sSoEnT4V5+JRLJmIyKsP0cMLfIr05TmUbJEvJDA==
Received: from DM6PR06CA0084.namprd06.prod.outlook.com (2603:10b6:5:336::17)
 by MN0PR12MB5954.namprd12.prod.outlook.com (2603:10b6:208:37d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Fri, 24 Jun
 2022 09:29:50 +0000
Received: from DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:336:cafe::3b) by DM6PR06CA0084.outlook.office365.com
 (2603:10b6:5:336::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16 via Frontend
 Transport; Fri, 24 Jun 2022 09:29:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT059.mail.protection.outlook.com (10.13.172.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Fri, 24 Jun 2022 09:29:50 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 24 Jun
 2022 09:29:49 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Fri, 24 Jun
 2022 02:29:48 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Fri, 24 Jun 2022 02:29:48 -0700
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
Subject: Re: [PATCH 4.14 000/237] 4.14.285-rc1 review
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <c5c6a39f-36b7-4c2e-98fc-c82633595a03@rnnvmail203.nvidia.com>
Date:   Fri, 24 Jun 2022 02:29:48 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a958df70-ae1e-49aa-e512-08da55c4165e
X-MS-TrafficTypeDiagnostic: MN0PR12MB5954:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qsEiSmBbCy7LSTMc2TrX4HtojF0QUHhamGZOe+SQTGkZsChovucUTvF3w6HoILC6gwm9UmI4y2HTxw9OJItwASmsx0WmfNQATM2EF379FFqMP4tZcjHgqBqDniCzuUlJIt8etpLqG4tIRfnoephEMBBPgJKB8LEwfo0Yf6TVs7L+lGAZfAlQ29BKb2d0EcKQ7uvPdIB2PYnCzcMsX0awNlpl01ZfRchX0lZfLgCrWUhjkRdQ+9defXsWxKmYRGsq7iNc/EUC8ISIcmkl6gj3Q1folbzbug3PBhfM3tv3fuYuwgFDzppcw2HKl5SCp1lcqXTnAjF9Z1sVGjqeg5PETZQdb0mYJDukV2muvPXfXAKmwC3hwDqKOTbALYTH+aAyWgbGla+ihOTc1RUvfVK/kJIgkAe9PAcU5WUwlr4wNF5cjVFFpj9s7tE9VZC9xflxwr8OS2ng/pmopJ+vCV13+THIaPJEzwaZqwkRz26ccF9AfRMDRF0U60zXO/WuuAWCOWnDR8q9Dq5Akdo+75i5jTXhysbkZoLzWbjLSKb21thC5KTYkodLtLq98oeL0F431PuG1RJz+4H76XXoi3+niS3aW2ePeJu3aHrQ40U+bpwIulnVuh9uKNNIQC5GNdrD+qggwiOmzpGKWavlGGk38BGOcNCyS/Cux0OI7StNjD5CfuL10r0JNjIOQjiwDfZX7VqON5UOuKtWVvdwm1MGLJD5gl0K1MkE1SJjI7oEaQLGx1Z3dLffwbLVXjtMLwBbrLFqC9Zl0plAHBrDJ+7toW6Tjc7Fh0fUheTIgyL/8QYVaHtb0OgDi8ViiaBgktM2ajJTW9KLr5XJ1PoA3JuuTJyEeeR78HE4lHlUmnrr3Py5Q/8dh5Xe9pjjLgEBSMvjueSMx0/eIt03MgAp3z2FV19H1nzlV809j7B1Ls21u6o=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(39860400002)(136003)(40470700004)(46966006)(36840700001)(70206006)(36860700001)(31696002)(356005)(86362001)(4326008)(40480700001)(966005)(70586007)(426003)(26005)(82310400005)(316002)(31686004)(40460700003)(8676002)(82740400003)(47076005)(6916009)(81166007)(7416002)(186003)(41300700001)(5660300002)(2906002)(8936002)(54906003)(478600001)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 09:29:50.2365
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a958df70-ae1e-49aa-e512-08da55c4165e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5954
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 23 Jun 2022 18:40:34 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.285 release.
> There are 237 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.285-rc1.gz
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

Linux version:	4.14.285-rc1-g948a36f89e96
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
