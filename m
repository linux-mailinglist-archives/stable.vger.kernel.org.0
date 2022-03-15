Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A21FA4D97E6
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 10:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244261AbiCOJnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 05:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346737AbiCOJnk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 05:43:40 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2075.outbound.protection.outlook.com [40.107.220.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BFC4F446;
        Tue, 15 Mar 2022 02:42:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G0tBHQlUbV/Vry7iKFxIi+WjkpSDICuxiOQfyYdevXXv00BnSbaBCGMiwofxkQ+VuHMftyO/YoDnTgY3p58gSVF8zhy5ywSldLp/jo1JcQRfLd+1mpPt8LTYWRg8K1PvFjQ0UL1cSWvHvmVOnFVY8G7KzltTa/l04Sn2w010OoZ5oxq6u3332e+R8RXzcRfl5uUo/Clg7/jnRF3J4lGxZVYAId1pwTO+Yscwuz0qVMw+7g7BniceQm1nzUOthim3/axYW2kOlj2zxCqjnB27grzcbgd1rqbFUlusJq0wc/x9Jm6FzYfRvMRGsAXX6xZROAggtMQQkdkC6Wx/egNq1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KvsQHI0j3a/aA4/ttjGW3o/bFjmPEAdYOVlofhpfbPI=;
 b=gVsjpJl3iAwdjRDan2E62piO+A0YdUgA8IfDJSYdvvS2GswLScnw1IRJggoQKqrycnQ5czZv3QDjUt4pnSptL8PZn2hWsIRMCijnRVe6ioVuZzPF1wGjaweBO28UDoUojIhZ+O+5qje1XPjAZj27KXx/Rgceh7UuASqKkl0/MXXMy0dhabNFkJGsKnAhrBVTXyR3MFdDEjl+7FNEc4aBJ/zeyQl6bibgUzmm0OCf+RAKJ0IrQeodp1g6n7UUSzsjMb529MoBjh/VUvfRNWqij+5ORLQF63fhI0SEYqopxxF0zKGUsBw2yHVXsVKC89g5YJjaDWC/gO7olapcrea40w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KvsQHI0j3a/aA4/ttjGW3o/bFjmPEAdYOVlofhpfbPI=;
 b=RxpLKqfAqviTJnTX+gCew45jfd6vsCPJ+8/O1uPzJtq4hcjafigmeB0jE7TRBsPWBXSxKD6dInBcHmNzExVThmye8Sdrsc9KaoN2u7Z9XKvotixPa/7SgpQ9lAx6O2gudG+W+buPTh8jNfl8YaKWJVKu8X+fsHB4Nmbo4ALZWmMiD8Z4xTt+PlGzOGHqkhhbtL7LcHl302ZJmBQimsIdpDNTq37DZdtHQbjPYJO/jXKyniRW0MOIY4icTyNzsNubWzEUQsBg7rKX4TXBAtFENbdoEBebeyTq/jMCCQPPmMNghayg5aIu+H/zmvBQZJ0GdwsC1YOTqpAVdphVMt9sGQ==
Received: from MWHPR14CA0019.namprd14.prod.outlook.com (2603:10b6:300:ae::29)
 by CY4PR12MB1319.namprd12.prod.outlook.com (2603:10b6:903:41::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.25; Tue, 15 Mar
 2022 09:42:19 +0000
Received: from CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ae:cafe::e1) by MWHPR14CA0019.outlook.office365.com
 (2603:10b6:300:ae::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.13 via Frontend
 Transport; Tue, 15 Mar 2022 09:42:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT015.mail.protection.outlook.com (10.13.175.130) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Tue, 15 Mar 2022 09:42:18 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 15 Mar
 2022 09:42:18 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 15 Mar
 2022 02:42:17 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Tue, 15 Mar 2022 02:42:17 -0700
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
Subject: Re: [PATCH 5.16 000/121] 5.16.15-rc1 review
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <7a0cf3ca-1106-4a91-9228-f6d4af055f0f@rnnvmail203.nvidia.com>
Date:   Tue, 15 Mar 2022 02:42:17 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f709695-4763-422e-6826-08da066818ce
X-MS-TrafficTypeDiagnostic: CY4PR12MB1319:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB13199AA910D38CAFA7C6AC72D9109@CY4PR12MB1319.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: etAddT/dii1UVzjyF+779AGlnWh3MW3rlMdu/0WCHRKW8aAsuJ3ICu0pIbu5q4kzSB0+sd3iWGxOXmjcfPEY8n0EIMNUMl3lmBBsKeiof0uWHTIhUWLIZJbM4+UExEIf8Ww3fojm8IEMVM6G8YdEquMNoDt6qvjspdMzvKW2ev2jm02V/7f3xEyXHLyM/iKyJ8SVZNoqPFi1V9KPNGWTCcjpQaMffHpyF66NhW+rv63Rj++anuL6fvg1YbZ5lBClhPd/7Wa4vJlu+cO5blZA/LrMtvGUTKaLV5l7WMHkvbqmXMlBaLRHXHpa/RFW8WxcfNaZ4cr+VA880kgnvxqKAJaLxJuGQo28SX8bzKbHC6/BJHqSQdR9Gt6xzNhVo9Sh9/qaKJCPdN+2Hn39NpkbHr3dHkJPrxz6dFpkbmHx/bf2R0FN9+EWP4024Dq4DKwtaWgY1tyW3KBuckUQeoxztigw18KzyuEsAyzzTEtKvwwrFQfvz1R4EePaycdi2/c7nS8ME6WTykj3OKrZ+U1uxAUJgQoMPwAvqWUaN06dIwX+cY++WRi9rBbz0E9RSblkStYMC51yfXx9eIARQsIGNaTZSzcwn4Ru+GksVJn8VCoY4eYrJ5rOw693dKXKsbdB0vdiYzQiPH4YiyxT8SmpPdkkckBI9kBCVbIL8Cd7t2aJq+cFiEMFuabueprCg3FliM6dWG6fmImekcpfqBWnHwtQ/cPwW0EYF9Kqwd4HWW1R6cdWhFpwPN8UvQCpAHv/wZFkjhYOP7tjR/B4q7aU9uslYPzkAUurZBJIT9/Voes=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(508600001)(81166007)(356005)(31686004)(186003)(26005)(36860700001)(54906003)(2906002)(7416002)(316002)(4326008)(966005)(70206006)(70586007)(86362001)(8936002)(5660300002)(336012)(47076005)(426003)(8676002)(6916009)(31696002)(40460700003)(82310400004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 09:42:18.7798
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f709695-4763-422e-6826-08da066818ce
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1319
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Mar 2022 12:53:03 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.15 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Mar 2022 11:27:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.15-rc1.gz
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

Linux version:	5.16.15-rc1-gb2a408c85a22
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
