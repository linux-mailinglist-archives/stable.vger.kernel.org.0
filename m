Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F54860B5C4
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 20:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiJXSjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 14:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232568AbiJXSjI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 14:39:08 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on20624.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::624])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E23EA6AB;
        Mon, 24 Oct 2022 10:21:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CdhQsm/h52akBcZzNCIgLjuYQ0OjH2wSU0YHZ3rCWfVFZGJWDa6EO12d057h2bIxlZzx9JmupXxNVrqnhKhsfo+A8BPZsA51R1J5tragLwnH2Bv+aF6lNIHiEbZtuYS92q6RDl23aKfmVmkoCMCrfFsY/IkQTjJsVUsv/0mNMuDPdFE23Fa4vPFXjUjDR5Xys+/FhCFeY0ab/pgLxVLFWNulkHz4o0xCj6yfDF9QO6H50frMCGBuMHzWsCwdi00kckiyQxP2lESLbKllWJZuf8azlN7fSvr2m/7jjgxJD03YMLLtLGxUrW9YaQyjzKqjfmhLW9sgP97Rab0E+BYrjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NfXaWm6/E464ziR89wa4ItnVBsjEuFIW/TxX0eiBfB4=;
 b=RCUvxNDJgwW+8F9jmvC7xV9uybzh/x4f6NLIfKCOu7TRHonOnRST6wAz0hM5JaQiiiPsSwi42MpFBJhMadKX4Sk2qz0DKyIxGrCnGwDg364itnsSz1iBmdLQNPrME7uTgo8QIaovxzCVU9h/+1OkhfLlcAqS0p+AuYCl6b5i7Vn1eqoJ+nT6DGlk6fl0hZEI796JjLPgCiO+xLU++SZBH+pAyVXW5/V1RCG7HyeEk91kGGnh0jOb7EkzsRaK/FjWMfd5b/wcpSoMyNC1Ochn0FJ1QljZjUHHOAFDavuPK0s4y3bRL9rcvM7+AEWh3cF0PFIVViljarH6pZUVwLiEhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NfXaWm6/E464ziR89wa4ItnVBsjEuFIW/TxX0eiBfB4=;
 b=rJve7CWxj+JsPoqbjehsOua4DvdaDPyf/Puo7Mfsqztr2BViLaJ5SBpOPJ545/ufZx1nmnkzgfN+Bi5Uxx1zSYsXPbHWYtdmGhhVCiywaM2TYQKkKSj5CzhC0L3cob+Flkrwo8tURxw4zc5O0ru0A348sLvNxUwozR9pD4rWzyBFhKgqVhnLxxWBkgU7pF/6ARAF6oBAv/5qsMnQNqhcc7GQ4dAMzb+ZQr0iahYjz8Z9tthedGH5LuIyZf002Ua0/JlQC64NQcYPFwyot8npAwqPR6sD6AZgFvX3k7ykf6Pzjc0El5VWf/XP0lgufMx0L1stLEZYJGbLkWyRlIyKsw==
Received: from BN9PR03CA0576.namprd03.prod.outlook.com (2603:10b6:408:10d::11)
 by IA0PR12MB7578.namprd12.prod.outlook.com (2603:10b6:208:43d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.26; Mon, 24 Oct
 2022 16:42:07 +0000
Received: from BN8NAM11FT072.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10d:cafe::f4) by BN9PR03CA0576.outlook.office365.com
 (2603:10b6:408:10d::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28 via Frontend
 Transport; Mon, 24 Oct 2022 16:42:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT072.mail.protection.outlook.com (10.13.176.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.16 via Frontend Transport; Mon, 24 Oct 2022 16:42:07 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 24 Oct
 2022 09:41:57 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 24 Oct
 2022 09:41:57 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Mon, 24 Oct 2022 09:41:56 -0700
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
Subject: Re: [PATCH 4.9 000/159] 4.9.331-rc1 review
In-Reply-To: <20221024112949.358278806@linuxfoundation.org>
References: <20221024112949.358278806@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e6329c38-4e27-4bd8-9b71-376762215788@rnnvmail204.nvidia.com>
Date:   Mon, 24 Oct 2022 09:41:56 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT072:EE_|IA0PR12MB7578:EE_
X-MS-Office365-Filtering-Correlation-Id: a7b17707-008b-4a6f-9c4e-08dab5deb05d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4itytK4lRsKEbwh99wF0JtpnZgmX4evtxLvkQ59NwqqmcMNqlLHS5YMzZ7JFW62VbPsE2cR0tsMRvSiNN7gOiNyDbQIurAvLavkxWGVpQdqerDoSG74PU2CoFG8Cc84RHIJUuvcoL92bMPBXJeBD1gZ1EERbYpOpeVVV/sRrk96kraGiU4Rf+49Cde5IDsUXA2INaO9sbCPkcCjHiqOa39XGIitRHDTFV/ylo1EOjbRLZE9prkgLyGRFsps8kXiP2Ihzdtz1/BH7wp+I3yX1QkESI31xn7zswyxFOFztMMNaFeL1xG5UdG0airJIJLY5o5lPWVZMTmG15M6schNTw5RxU3jAUZnXz0tE6/PoeIDrFzSEDn879fagpZeAKP/MFmrPZ1JWdr28Gqt83kVdJpKdF9lLpRJUosIeQ0dTZ12lCnM6sayX55s5RfjnSQ31Iei23QWPjK4OueIRPSuac0OdOKrrlDyA6KFzVgttKwkM+7XkOnAkxU/OFuuCChU3zTzDQG/dnGLxpSn1f0JmTAc7/J5aLzuLC0msqrMZBJ+T21OkKGEU4dnZ3G0VOMxLlV+PTCSyx2ENw30QRegRqHIkrw+lXNc4cVORDUaC69ut/Z8MlqBWn/dzgN2GwNDGY5OoVqkeluW+y39UlHYzcgUYeTauyHXse42N0Ax+GYWVZFkKJqqSvx5gDkL/1AIhETOHX1WovKhcXn7odm7j3IOuDZ6C2xwE/1d1Kg6htEQKksm+V9sgKBjBY04veJYjyoBhAWfbqJJghPUsRY/Nq7Z29tMGUkJRWHaQbNvZ1QldhmO0Ie5w7lLLwmgJEw5A+1Sozb9vVTkw0iO4ofqSxjIy+SSrSV7jU8TVMsX2f/k=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(136003)(346002)(451199015)(40470700004)(46966006)(36840700001)(82310400005)(31686004)(82740400003)(7416002)(40480700001)(186003)(426003)(8936002)(4326008)(70206006)(70586007)(2906002)(31696002)(6916009)(8676002)(5660300002)(54906003)(41300700001)(86362001)(316002)(356005)(7636003)(40460700003)(26005)(47076005)(36860700001)(478600001)(336012)(966005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 16:42:07.0607
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7b17707-008b-4a6f-9c4e-08dab5deb05d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT072.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7578
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 Oct 2022 13:29:14 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.331 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.331-rc1.gz
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

Linux version:	4.9.331-rc1-g5bb2c3c178f3
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
