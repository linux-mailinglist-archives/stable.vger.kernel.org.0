Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4766F51516A
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 19:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379450AbiD2RSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 13:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379092AbiD2RSc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 13:18:32 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B535627CC7;
        Fri, 29 Apr 2022 10:15:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AKc1WJnoJpYle3E/NJsucvuucJPmKQPDXXB61LhqurPiTr2b7n1oETOcgMZd5UX/fNvyL1d0llQNe58ezFYhdYyzRgN2BaZxhuezvG0Sjt7Lw1+PYYVENUBayxRX5U3ODYuIwUvqh30h0KjKcQIZPx9TNyYKq6u6bt3CcOtnxwk9+eUmO3L20wKlUvyp3CDQ3lJZ6D6agHb8L5ma3NS6+koILsPEd+/R/JVlyFMHnBpv1L/WRuUHgl1/mOSgdUJ6+pkDkYIzXcHTHJWnO18IJGJPms2JhjtonBtFVlXSEpSTn8+8y/BKfEMC5rEJXjXxB42iUN2pdge/K0NlnXClTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=043ReD57TScSKPonqll5SGXVgK4b+12sxYfLA0UkGOc=;
 b=cDQSPHoWibibrkGHiM6wqI+JOn8W7HmQrDtPtR44roxbEdOMoGbReL2qfKhVfp00oXcv17ZZTZRwV7XSynap15DNlMphBPr387MskdC16yqtC6aZx7oiEq0IJ6zoXaUaVzBwNZINvRfbbcEhOrp5CkV/tUGngmHUXMZN7SlnMERYU0LqoRaJw2HIbCcJIu31zKrv9Bjlk5e25gPzrAiM1WMnqq9S6JMNmZt/JEtDNj5/Hq00AEv9XSdiSnY+Mv0qj2ZoyTmDCXxP6vHRI4eURa66A7BHcbJuzE/8WCtufWcY/yxFxcFqLcWWk8xsCNq+qFg1UdXrxrLxUczszH9/wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=043ReD57TScSKPonqll5SGXVgK4b+12sxYfLA0UkGOc=;
 b=hyWSFfPlFzSkb1tr/ILlRHJFlB24FBnmfJ0lHihu2RSIqV7v5xxfbdIInzkv1O4e2r+gAXyg9LC8fiQZEDLsXPamIWIH1N25ihvjfsHDq/CHc9D2d5mXibZjMJDRjXoEujbmD9rPyfeltsPTF1zDQEArDZX1CZJrS2yndnvX6Ll3c9xgYZCxGD84qNXwQg4C24bkqYOmGMFo5Ps+y3zhh5eE9dtlN5+c6tw/WnfOuboYirQjGvzvEazAXmAW4qlKKIraIH8u4xeMDZpYUkQqxKErRFb9nprjBPeF37vPRs7SLvJE6pwc1rxPBbk/TkFM+WEXSXyoAaRflbXp5Zso2A==
Received: from DM5PR21CA0023.namprd21.prod.outlook.com (2603:10b6:3:ac::33) by
 DM5PR1201MB0044.namprd12.prod.outlook.com (2603:10b6:4:54::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.14; Fri, 29 Apr 2022 17:15:09 +0000
Received: from DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ac:cafe::d4) by DM5PR21CA0023.outlook.office365.com
 (2603:10b6:3:ac::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.8 via Frontend
 Transport; Fri, 29 Apr 2022 17:15:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT050.mail.protection.outlook.com (10.13.173.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5206.12 via Frontend Transport; Fri, 29 Apr 2022 17:15:09 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 29 Apr
 2022 17:15:09 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 29 Apr
 2022 10:15:08 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Fri, 29 Apr 2022 10:15:08 -0700
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
Subject: Re: [PATCH 4.19 00/12] 4.19.241-rc1 review
In-Reply-To: <20220429104048.459089941@linuxfoundation.org>
References: <20220429104048.459089941@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <993082d3-059a-4937-aa90-6dbdebb68d53@rnnvmail205.nvidia.com>
Date:   Fri, 29 Apr 2022 10:15:08 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1760f267-cd6a-40fc-16b9-08da2a03d08f
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0044:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB00446829959A7E5F9AFB274FD9FC9@DM5PR1201MB0044.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gD/aij7zHjYqWfqGb+iOtLOHn4cwKwe1geeLRyN+4NvjlPCXoz1QFJW8ZhsrfUlHWjJJ2os9IGILnl8qFW1dQsz2z3Z1BOu1A3mSpU0/uINMoQrngyxCf5dzSUji+P+lqsDLGXJiBv1ozadCTrBzzRuFHFZ6SPmQcHOqeSsOr+Vw/URpxO4d5siUNWyRd2ov0Ed2eZpPO/pp1u+LPJpqw3s/2rliqrCiotdcat5McweCuf/HEu3Iuf8MWhiYfZg3vI5HIR1G85svzMNUtcTNwwK/6UBPI0etDrJalK/f0eCGrSsQMXCStxZiQhBgULtb/oOr3ChaZtIpy8E9x+Om9jTvBq/J7h8fL2x5mr5TfuC8LsO2JSZl+r7a2R0lyI4E3MuFMv8neFaEdIKwvCsZcn6hO58k7yFuHz2hEJsNAckFiWK7953Qpdfodoq3KO5QS8FS4/Du3w3qzI0WzSDZHyKhB6rRH/yJg8WquKlO06Lhas37hVr7Q3PRSA4lnIFJrPTRmIRUOHye+Ld1JSNsnIE4VN2L70KHeDaZ/xJLHfw16v3yWPUo0gRobSsxkPtpDFLKucXLUTR85yYZ9TFpuCKJQg9vSZ7hbc4uWSbdeeQpqxSq5Biw6/vqxHafR5k3us2NJTJxPYtLRcRXriKw0hxJ5u/sMZdrkSaA2xtPLah00tEULW0HXxaF69GI27WTFHm1+gByZh4eN0kJjSY0Q6FZbUF5TLWqFqFwO5Z5WH8DSM9JxzZmc+T7wuuQJp/jgCAiPYCsSo/DNmWu5wMZtrQAq9YsdGWeo/Trojdfluk=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(26005)(81166007)(86362001)(40460700003)(31696002)(426003)(356005)(186003)(47076005)(36860700001)(316002)(8936002)(8676002)(70586007)(70206006)(4326008)(31686004)(82310400005)(5660300002)(2906002)(7416002)(508600001)(966005)(54906003)(6916009)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 17:15:09.6622
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1760f267-cd6a-40fc-16b9-08da2a03d08f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0044
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 29 Apr 2022 12:41:17 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.241 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 01 May 2022 10:40:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.241-rc1.gz
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

Linux version:	4.19.241-rc1-gaca3ff930ee4
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
