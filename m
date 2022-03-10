Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4364D521D
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 20:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245599AbiCJStt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 13:49:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245591AbiCJStr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 13:49:47 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2064.outbound.protection.outlook.com [40.107.243.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95EBE4D9FD;
        Thu, 10 Mar 2022 10:48:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cbDdNHi22GWF7pGUGUhh8fOtiPpFOoLcQJLdLEsr9tw92oL1Tgn4s2m2GnYx/6p3LbG4Y8yz4HOxWvaBqs+WUs8KfAidc849DDc5U2mPi0WcOsjlKrcWYhM9fSXqUu5+XbB/YdbhnPt9iTXSiTJjfu1xffi6/XxwqwWZtN1rpBaSMXIpPxQhuyXd+a/ma2WAEFZfqr+DS4hPbxwAKizEoUmvdXMt/wzwG+j0We4ekiVaD6fSaZVDBjkhs6cNDQP1/oKHjRlfZCsSOYC7TIsZVBOWEWGhHWgAyTcJOFa8jBN1JSdDPWC2ty9I+MsWF3So5utUWSC6NnDtgvcdt4w4nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mK9f9IlHNx4ZizxOF9KY2H4emU0uYmm2+TGFE7htAaE=;
 b=O4MtGgNGNdokiEbvv/A13hTqR6pju3An4SeMf0VrJCiKAx2/HAMofezYrPU4n38ZxqRcwOUO9pE6V8+X7LuUpHUxZLLEmXqDtcsH3n1M4v5U1lcMb3SnOtAN2VWjlsKKwADELBJjmhfQq71M3hOV4d2HDcSjPEIP6JroiaQkPsuyINkMlHakuyzKTURmgiOko4vdHjIzj7pwRzHtdaOimK0IE6qZETsTDROWrsTYJm0HE57PMxo5k1o4tCcZAJRZtl69LFW3piIWYba4Fer4H/G6IBj7uiNrDckc+0Nh0m9RcrgTpf6covwphKULi1VIfRU31VAn+aJAXbnUiDsKEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mK9f9IlHNx4ZizxOF9KY2H4emU0uYmm2+TGFE7htAaE=;
 b=VaJmawIioozTyJLALkUiERXw7xH7UTpuy5hmMre6FunG47t9KDIRZQQQzjfxjtb2pP5sTInKqao1N4vypf2HQURJMk85C8zv6cLXFou8zhcBUNkEwABmkp7n8EG7sSYWuea/gwNJddJvkChFUtM+PpB5OyjpMAez20djwCac+y9r3xTKc2m5HP0/lT3TfpbInJ32y8lHXt12nHBcIFnmByMT4ByA5JkR9MhRIefKiXG71QX45UKvSpaZRWEv3akh8RJ2uFo3ZKoZJwzm1QYcvdmS9OGUrMLVrTIffYj89lfnDUChK8mnrpe7C5vOk4UD96JTGba8WktuXYhH6SVDOw==
Received: from DS7PR05CA0064.namprd05.prod.outlook.com (2603:10b6:8:57::26) by
 DM5PR12MB1787.namprd12.prod.outlook.com (2603:10b6:3:113::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.15; Thu, 10 Mar 2022 18:48:44 +0000
Received: from DM6NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:57:cafe::d5) by DS7PR05CA0064.outlook.office365.com
 (2603:10b6:8:57::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.7 via Frontend
 Transport; Thu, 10 Mar 2022 18:48:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT056.mail.protection.outlook.com (10.13.173.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5038.14 via Frontend Transport; Thu, 10 Mar 2022 18:48:44 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 10 Mar
 2022 18:48:42 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 10 Mar
 2022 10:48:41 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Thu, 10 Mar 2022 10:48:41 -0800
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
Subject: Re: [PATCH 4.19 00/33] 4.19.234-rc2 review
In-Reply-To: <20220310140807.749164737@linuxfoundation.org>
References: <20220310140807.749164737@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <174f462e-e8d8-4a33-b1ef-7299846a0f3b@rnnvmail202.nvidia.com>
Date:   Thu, 10 Mar 2022 10:48:41 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 467b5465-26b4-4cce-2490-08da02c69a5c
X-MS-TrafficTypeDiagnostic: DM5PR12MB1787:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1787B552AE5802647321F78FD90B9@DM5PR12MB1787.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mmp4XWCcsEeSILS2wKea1QMBirHyRJieUsq2aNvw0QqN4i8DueBuT/WofBtU++BD7dw+csJXiOGkrAZJvinnKMN/6RevKwSmtZ9pcHExWlFRFFXWrCpJxi9HEdSB/r8i6hW1/7F8vWf2MDACAGx0c3GzglEWRCtb3Tsda58kwoPdKvtQZHX5WFRmAIV3ZtJpyZN2q/7pAnV5yzX0jLR+QyPMUXfoRFohKdkg2Zcvj1mMYEeKLYiRZ+UlZ/SPK9cDg1YJKoe+RV19grqdfAQ19BPqittKsiIH736K28v/WYvX1xcbGmbZPB0JHMXuaWX95TmjvhNvWEnQkrUKZ39d1oxaHGJtPkXWVQr9/0OERiyxFSOZP1ZQVHrueviNQYdTc/DeEIFNlKi8vQYLZ1soStEHI/I7mdVQsoPLSbph7UF/rCJ3oNAWTQVF1RHenOgpBfAUXLpShKDY0INqjVtYb14hU08V/ujUAM/noiTesoVDpTYcGdcr2hVxCmwwfX3vENnd23LOhL1rF6Bdebtyz0gOIuvtPvW/BeBCsdlz0c6oBG0irXqgmf58w939McpUAbAS50uVEVb4942U9B6KtA5jHBdLJya5yIsFDnild8jKXYCsH4a1Xy4dpexXbjEOpf9wEUu/Z5MGOyixLCY3MwG6A4+6S32GmFHe8DWeRDK+m9xSAG9TVmiSnvPWNu/joEz+2PqesDUTsTCJpOtF1PMi58+Z2Tj33X9kNKHs7wZu/HhsSFk5ElXy3fXxzCPZFuwjxSS+IzAqyLyUbrBedgY5RyT4LVE0LsUAKy9n/DI=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(26005)(426003)(508600001)(186003)(8676002)(40460700003)(31686004)(2906002)(70586007)(86362001)(31696002)(7416002)(8936002)(5660300002)(356005)(36860700001)(966005)(82310400004)(4326008)(70206006)(316002)(47076005)(81166007)(54906003)(6916009)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 18:48:44.1606
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 467b5465-26b4-4cce-2490-08da02c69a5c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1787
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 10 Mar 2022 15:18:27 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.234 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.234-rc2.gz
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

Linux version:	4.19.234-rc2-g7603caa5cc11
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
