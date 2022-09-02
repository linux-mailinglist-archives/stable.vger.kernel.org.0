Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 737CC5AB6AD
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 18:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236245AbiIBQg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 12:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236197AbiIBQg2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 12:36:28 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2044.outbound.protection.outlook.com [40.107.101.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2848DEB5D;
        Fri,  2 Sep 2022 09:36:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MKCyxMWSZERVqYzu0W46O1kvw+fLsfkYzcCtaEjs9ShsDJ3NNzeKBbdN3OhmdWTMCrUGHqFN8qYHAZHGWqxpmN8sD+1lUbCQ/wmCpTnzkWsqVq6fTfmK06qpXA73QY1B86nzpgAz6YsyXxtdxlXhbkwVP/wtjASTCydNDGdSjLjF94tVhwEHkjCu3+pDIzf6eAXk6Opa2sEhDkRDEdtcGKYo3sxETxnA9EKA/phk5dg7aiA9qcej+IkidMjX1wO7yD57MzLd3hds874ypLyMOZgI2Vc0/P3Fx8fP1u8e7hot/V8jFc+OKMGB/4mXcWYPxEh5A7+xXXI+kITeH0LotQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N/u4iYJKgvpc8WNggohesyHTTE0GlF1rW64OsOQHBCg=;
 b=mVvNjFT+SKV1xSwqwVifToQTN4HPDuqGpQnKjUWckewdA63gyO8obW5I29QIsJ4o0aaHlqMWRwv2QQAd22mPan6vVXUqcw2Y3RSdkbVFnyUEGwBRTHz5ERXgPDhHR33Nz+f0w7dv1UrlGwgDM1n7WR+bsSb/jI4a/7KNawT9jfT/bW7RPs0LI8EYrdu2dmKt/KQCD+TtX6S7SnEfddKB9ukZh9fa5psIXyl9l6GwSGMATjiTEk2Q0pqei+lLF4xlakmwxj0M1OTtMCaM4DtOCjy/dknKOBpVh6J6D00qtUJavVhYJfA55w6q5VIjfxDpeOWKf3iDMux2ahIgFuETrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N/u4iYJKgvpc8WNggohesyHTTE0GlF1rW64OsOQHBCg=;
 b=XEH27eRrBgb+ZysFDIAGbpq1JbmdQlvxjGn/ke9yWpGegSYqM8kMKUJqCu4V6vFhd6nmcOqsdwmEVAgzK5IAueLJy7YpQdLe5mYfKkJ105n0P29MA0r73hZZ400nBP5zmDCXoE8XLk4PnuRTraEIkwbZOybJ0qmdzsj4B6UxoHKGcz8Ko7A9d7S7DYXf1KS4BT1QuDQV1YfFQu+qmHRQb/yTD6D72EFQzplxdW1xPgMBrThVbkI9gfcCvwOo9huUmdFteSuG7D+gSMr6BzceYHdU6I5Q0d4WmGyPgTlqOqjRXTqz9QH9c6RPNRgWDAHbxK+kT7ZWFMGYYdLhIyl/+w==
Received: from DM6PR02CA0062.namprd02.prod.outlook.com (2603:10b6:5:177::39)
 by PH8PR12MB6964.namprd12.prod.outlook.com (2603:10b6:510:1bf::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.16; Fri, 2 Sep
 2022 16:36:24 +0000
Received: from DM6NAM11FT074.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:177:cafe::8a) by DM6PR02CA0062.outlook.office365.com
 (2603:10b6:5:177::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10 via Frontend
 Transport; Fri, 2 Sep 2022 16:36:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT074.mail.protection.outlook.com (10.13.173.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.10 via Frontend Transport; Fri, 2 Sep 2022 16:36:24 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Fri, 2 Sep 2022 16:35:54 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Fri, 2 Sep 2022 09:35:54 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Fri, 2 Sep 2022 09:35:54 -0700
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
Subject: Re: [PATCH 4.9 00/31] 4.9.327-rc1 review
In-Reply-To: <20220902121356.732130937@linuxfoundation.org>
References: <20220902121356.732130937@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <0cd3a1e8-f3f2-4809-8863-1bdb368cba9c@drhqmail202.nvidia.com>
Date:   Fri, 2 Sep 2022 09:35:54 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db3f14fd-9ac3-4801-3f33-08da8d01466d
X-MS-TrafficTypeDiagnostic: PH8PR12MB6964:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dsG0PzalEoMgIKbuqhWOpS7+7QpIsxt1O6VL1Ov7TvG5zvCvMQXb2ruSk95lmdOPNDY1pOH6xRi3RCkJWrnc16E6h7KoWqe9YzKxbQjH0k5J2IywamLv6P5AwbZMDgvX1F2OG2B32DZtqMFQDL+zcR+jxfuqnlYB2F7UeMjUXtJmsPmlUWdS/sBBvtM8dSRfWMZqhJeY6QmaCWLzpBQVylX9Grgp/yIgJrKZlgjv6xy9Up0GqAhuufGtLUjqC2eKMqB6d7nmb8ft+WJclA7XRNzpKbHXy1V+GiPtwZw6bMShO/e2cTh5gYxydMPUx48oC+QP1F/4MrvkDg+9xm/r2k4uNscBpUTqJLFdfF+p/h2+eWf1thBEmitz15CZ8c3W7jBRZ56QGmae3VT/osoKerwSg5bK+B8CFIhOZ7+jBpLXtZpvY4DOVhbZKAhTZfy4QNeg7MwqlyK4wpBX17Wqxpzhcmt0NKJJlXYcF6S3MP6m2i8qNlTpHKkvp78rcDvOvbs7PBzgGcZY8OTt9Sgum2R582f6x1rJFW4BBlnNWF1/FhhJfnXGf2eImIUuBcNfFzzFRC3eGmxarc8ulbkciycHfEsTgT5xR+/inif2ihLg9eUxmu4SvKxQKw00vgzLWMDltTC5hgRcnqBzJC/tzrWOYlyWD8F9H8yorlYeGzfSc5FA0yhvMkEEGeKDBwLtueWj780CnqbDCuGca2UtnLMa3OPZTh4X7M9qyoTggw60xT3bv8qcsf04nGjKyQyDHaR7VWscTig1gpKN5fI3QxYxg2ueQTmNTHb41GIvkSzx4n6UH7tjrVQ213ebzZdjmvQcqTKeU9V3TzmdycapC7kwylVF9imiFePzdpF6lJJedRHBUXA+kD0Vmmu/ScSY
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(346002)(136003)(376002)(40470700004)(36840700001)(46966006)(316002)(6916009)(70586007)(70206006)(54906003)(8676002)(478600001)(81166007)(31696002)(82740400003)(31686004)(356005)(86362001)(966005)(36860700001)(41300700001)(26005)(47076005)(336012)(426003)(40460700003)(5660300002)(4326008)(82310400005)(8936002)(40480700001)(186003)(7416002)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 16:36:24.1145
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db3f14fd-9ac3-4801-3f33-08da8d01466d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT074.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6964
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 02 Sep 2022 14:18:26 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.327 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.327-rc1.gz
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

Linux version:	4.9.327-rc1-g24fc65df6e8a
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
