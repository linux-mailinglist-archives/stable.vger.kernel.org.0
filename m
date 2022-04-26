Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 684A4510332
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 18:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352360AbiDZQYM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 12:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352954AbiDZQX6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 12:23:58 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2083.outbound.protection.outlook.com [40.107.94.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA8EADB0F6;
        Tue, 26 Apr 2022 09:20:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h8UyQBHNEWMzNiX2Z7hjOkJKNhEFf9jFy/4k7INnGFNbOPG/wldXRfLP2npSC8W1+zj/0W7ZiWYnngxEqybQl7nxLGWAccqHMvNwZMnH7FjVxvfcirx4KgnscEFCA/+90OoIN4nDLzF5hNMr9eNf1Upbu9vBO/uN6WCQq5KalHSYsvH9aqbUho7tamHVugCHLq8ZKBzgHkwhbbFwSulR4zvNLJ+0dSC+dthcI3SFcz2WB7ujmACa9dqlePf/T/eNYoE7Nu+ODE51DSCXg3xzi+24AIzeehWsLZVi7WthjmYoTemiThORVOvIjesFn3y21gAuUOzh6RNggrWvMrPmIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cieDVVIOPd9KD/N9OGj7nvWnBqFGVzEMIIwk2Yrv5d4=;
 b=H5cfypUaKyQ7bRfpZJkFKoulAIQNh1VudLekubUrtlZYU/NR3lj0rrq7/H3/QueHdXbrd66gsRiFVTYVXgDN/QUSQwkwZbMnvutSs1HfvcywHuWxDwxG1Mkz77LjybasiwsnRnP8ZdJ66PH03rgLG2wRFMdc46orpOVZUciCzVrqnpwMlLCO+teHYC+IbLqiOpfkI+FEsFquNV589h7sjC7FtesnHsYFR2dAxCw7hx2P+K57loPrZdqv+VBL7pD2xGjpe3pGqpHJbBhylT1ib84yOfI5GsZN0BP8+shV1ORGPkh/StVRt5vq94sm9AOAlNBqaq04MEzKaeByEJbHMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cieDVVIOPd9KD/N9OGj7nvWnBqFGVzEMIIwk2Yrv5d4=;
 b=C3Etw5mpnrLUsLftKTwNP6KBXy4+zWO6Xnh7ukRIDB4xOp/tUzxVy1Y1c4Z1L2Rrb35emv1ubJQiTxN/Kzug3qPH7xAJ66X0PYsAMD3Q+24pl44qUfvjIlBDimPWrN4niT+K0l/Mvkm1Fa1gyd06XRRBkyf7HD+MxTRd6Gu96EQBjVbq6biYF1xQ4Qczyj6GcGOUM+aDxqebUiMZ3flcFeCZv+nXU4Zum3W3X5TaHFha73AsU3QqeSUfn3JmMMEV0UbDbl53Ko3yiTrtqKERg56ELWEVhocXmI74NYuhSkw3naI4EFjxt190dwAm6+B9soUSW+Z9o04Zv3w2BefJwA==
Received: from DM6PR02CA0072.namprd02.prod.outlook.com (2603:10b6:5:177::49)
 by MWHPR1201MB0014.namprd12.prod.outlook.com (2603:10b6:300:e7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Tue, 26 Apr
 2022 16:20:49 +0000
Received: from DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:177:cafe::54) by DM6PR02CA0072.outlook.office365.com
 (2603:10b6:5:177::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14 via Frontend
 Transport; Tue, 26 Apr 2022 16:20:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT014.mail.protection.outlook.com (10.13.173.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Tue, 26 Apr 2022 16:20:49 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 26 Apr 2022 16:20:44 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 26 Apr 2022 09:20:43 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Tue, 26 Apr 2022 09:20:43 -0700
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
Subject: Re: [PATCH 5.10 00/86] 5.10.113-rc1 review
In-Reply-To: <20220426081741.202366502@linuxfoundation.org>
References: <20220426081741.202366502@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <a86fc7fe-e650-4d1f-9ba6-dec5d84c0b84@drhqmail201.nvidia.com>
Date:   Tue, 26 Apr 2022 09:20:43 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1686f0a0-0548-49ee-e1d2-08da27a0b9e7
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0014:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0014AF7104BBB78B5097B7FAD9FB9@MWHPR1201MB0014.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9I8WK5hM1nyFByxypC272ELAhcb24oCxR3DLjdWofaoU7WM9+y9iDtfuZ+2ElxFTCeTy958DmINH43cOVwlFVOZ+pDTD158GtOr80vbOIc1oBt+rGkHLbbaHMpVOr7VlJ+/faRKAurdkYIGMpgYpDwuxUR+XJ1VUf/vsqxV87Y6rEqfMMTipAcLV+QUctLfkDBbwCzqvwbnGGCcANO29KZt4PtIUIOflY7nwSXTNiAVOb7iJ25nN7yDMcR564igQxhYgYc2vDJuQAFMyfPy1zTJdYJ8Dt63VWqSskyd/k4345yMmaChcc5GdNR2RSOWfVWURpMB+T3btS8K8ri0Fv3oD5X0maMaSl2iNZJ4utbZnAFDeUMUL/ahHyfonCZyt/MgLcyx8gaQkJzFCTORgTDIm4ltvkvTvSyhpVyN+J0Xhz9hKq3n3HPbo8RWwyEvOreRstfsnhNwBsUntNEdUUlQU7e5bQUSKF1vpr2weHXCrJmlB9hQkXbvqx4Z9OWtQIKNDn5SVEN9Dx/o161IHB9BciAW/PDWGRqvVUPSnTXvHXyhXAC25eu+SadvSS/dcnilRol1qFH4nUkTapevap6Rv+uvTgGA5ZnT/fDcZD7tX8nmUMwI2BBBhx6gzb6EOJBZrnuV54NntT527lJi3IkpkT/jV0Ru8Eu/Ec4r4i+Z5YEdb80T9gz1U9EI0uBvdqncEbyDEnQy6gn6Aftj+NLOFhoqTfK2KXzY2aniDRQx1po0ViQkbsIs32+2btBrJDgkWd3Kh3r37DHRiTFoda0ugHJkpdTpcLezu4g7AITs=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(36860700001)(26005)(86362001)(356005)(31686004)(426003)(186003)(336012)(2906002)(47076005)(31696002)(8936002)(7416002)(4326008)(40460700003)(8676002)(5660300002)(82310400005)(81166007)(966005)(508600001)(70586007)(6916009)(70206006)(316002)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 16:20:49.2172
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1686f0a0-0548-49ee-e1d2-08da27a0b9e7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0014
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 26 Apr 2022 10:20:28 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.113 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.113-rc1.gz
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

Linux version:	5.10.113-rc1-g889ce55360e7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
