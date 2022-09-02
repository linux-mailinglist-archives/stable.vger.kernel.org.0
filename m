Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F043C5AB6A6
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 18:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236242AbiIBQgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 12:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236420AbiIBQgI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 12:36:08 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2055.outbound.protection.outlook.com [40.107.237.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39FCDDFB7B;
        Fri,  2 Sep 2022 09:35:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FIZdHzOCtbLh+9VzyqMp0HHiW+X1aoOVlhDU2g6uHX8hsZDxmuzFY1eFPHF13g1Whn6cUF/goQzpzg+sW2r5afRT9uMd/TYPuRaIQeb8v+Q53WhdoLiR7Q9TWjDkmNtQVyHky8cjgu2dkexlsVcFkAT8JKbGLSR1Qbd13oqnTKQFDrytI4+vMyxM3HCivNW098Vzn5muF815EULj55gstXZoJmMS7KG5jJe2PoKvzViEjMQbBQEC4Msa/OgJ57GdtMVyzLQhEcb8uT80k1+ZCoDVTUszIk8iEK/6tGFi6tJ1CqzyC+N3FhcPJK8jb0v4cOlXlvypAute5m28QHBCbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V895BJLc3G9cs66xz4NPTav1Z5JlezwOewVNjhxqezs=;
 b=C+PkrP66HbHUsDe0/ts0qSmeqaqFzOH43c9kbB2vAE3uGr0YtXnT6WbY9iFdhn1ge/Tw5OWsUAeQ0cOqOOyO1HGcy++NcnQJ8RMr7fhVNYHXD9J4NOuVk/eUVy4ctLZtDy/rYbSD01Q3dRzV1QWyxOzm58sHJpaV5sFlya0F/cAOwcpNSN3wLx8cQWXrUbe0QOPIDfYgiB0QplmzWpRCgg/BIfY2NGjsh6f4v7nCSnpXrrgFqOhiKvh+7zMmu8B1PhzY6MMtOvuHFt0rKLF+zFS4gEr/t9drANVpfumeYyDoJ3i3wCAjbzUvnIMY61QqU4OUfkRuI9Jmk2+gMhmJbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V895BJLc3G9cs66xz4NPTav1Z5JlezwOewVNjhxqezs=;
 b=TEkeB/ZKVHEV7vMWiOaRYzWVILdJcGJpWT6xwcu2KBW8uNAaeRjQN4/dc0L9uNKtOS2EI2v2KtpL9O5RItHCGwl1x57HJDaoCSVVILhnWFh2DLqgG79SG3FHPXNeUAtTHWOHdb/wVJtfaLHMoxOKMcDkwq+rnhkFPs8a41LRVR1/IJQh8AkalvVNXu3pGT1Wpzs3r2HfgCs82q9v7ikP8VbZM32/F3Kwt4a4eWHkHXckm4yHHRboY361f1f8411V0GsK6JfdK+qaBlxWOm14jWcF7qTUun3S5qlKfbg0PMn0g6Q3fMY/UEDwEeIXDTQT40dsK89/pWzdFox/ZdBKSg==
Received: from MW4PR04CA0135.namprd04.prod.outlook.com (2603:10b6:303:84::20)
 by PH8PR12MB7351.namprd12.prod.outlook.com (2603:10b6:510:215::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.19; Fri, 2 Sep
 2022 16:35:57 +0000
Received: from CO1NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:84:cafe::f5) by MW4PR04CA0135.outlook.office365.com
 (2603:10b6:303:84::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10 via Frontend
 Transport; Fri, 2 Sep 2022 16:35:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT033.mail.protection.outlook.com (10.13.174.247) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.10 via Frontend Transport; Fri, 2 Sep 2022 16:35:57 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Fri, 2 Sep 2022 16:35:57 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Fri, 2 Sep 2022 09:35:56 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Fri, 2 Sep 2022 09:35:56 -0700
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
Subject: Re: [PATCH 4.19 00/56] 4.19.257-rc1 review
In-Reply-To: <20220902121400.219861128@linuxfoundation.org>
References: <20220902121400.219861128@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e3f27342-e96d-45a8-a778-4997be145b03@drhqmail203.nvidia.com>
Date:   Fri, 2 Sep 2022 09:35:56 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a37f8adf-f734-4295-455f-08da8d01369a
X-MS-TrafficTypeDiagnostic: PH8PR12MB7351:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cmDoeT5ij4HtkbWLiOBp67oKiAg87HVpFhtZFoVUyR/9q0j8Mx14xJ49pKGylB6CCHQus6OT+iVQmFckd5mU5W2nEvz55GCJUMLHhDiqWr6PpasT9hNOnDnHAF1PfvAGY/8TOhJTsGbz+GN9BauEttmFrMnAoyDxxqTKy96LSgUFdNYLlHzonlQeKjhcbRFJupQzL2O8cJpcPbROIxCVdFE1a1Voot4NH5ru3MyAcP2fmIYmZQC85IUvJDV1XOGwRZykR7GdAXTOZS2sReZCAJdq/o/6o3twt2rpXBjib7r0yH7MDm8PcgIBXZtouPa0y+5uYK6dN7q9Kl1RwgueIZa466PsD56tsLPt29/nJsjEDAKS41PXdBFBdZUZ3B3inIsJb8/P7gjD2LqJJNWI2RLh7y+qeFF19+5rthLrbsHUGFaHSPTycF0du1gUXJcww2D8r/+K3/6v0eFPkfMxk66BJwf7+xg0cDqCLSljgiRGq3CWumnvF6G/GS2ppXrlg2l0bkBQg4s0ztCK/HlxphSDJMbWF55/CpAiRBsN9GB9eoyNsBhb43b0YXcXwARNizmievtc9AxfyAfVLGRQOhSTpCqrqtUzmrH0I2T4JGhMFRQcX8Rf4c0OgDYpJFdlDzK/zb/Gk9MmBXfl81j3HkHrgOvFqpdSNVqPDz+dJ7M5QERHyN579mJsLjxkaDr24eul/gbIZBoJprc/dMjKUyQVjw1vjbFbkhPWGrz4MN/LiOmRbF9yjLFM84ItgrjWh+LwcxrkkunMiAGdhf/OYC/nBNspQOyAZk1lRCnBTwCOuhMNi/JsyXrfn9ExqYE3HO/ohgWTut1IwUC1OgcR/d+jRk3VQPiXV94dN2LDSSnhH1o+1lwbcVizCqzzmV5i
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(346002)(376002)(136003)(46966006)(40470700004)(36840700001)(70206006)(47076005)(186003)(5660300002)(54906003)(316002)(8936002)(8676002)(36860700001)(7416002)(6916009)(426003)(70586007)(31686004)(2906002)(31696002)(966005)(82310400005)(4326008)(86362001)(26005)(356005)(336012)(81166007)(40460700003)(478600001)(41300700001)(82740400003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 16:35:57.5816
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a37f8adf-f734-4295-455f-08da8d01369a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7351
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 02 Sep 2022 14:18:20 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.257 release.
> There are 56 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.257-rc1.gz
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

Linux version:	4.19.257-rc1-g56ebf961480f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
