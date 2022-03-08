Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 449664D1477
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 11:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbiCHKNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 05:13:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236401AbiCHKNE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 05:13:04 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2081.outbound.protection.outlook.com [40.107.237.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24789427E6;
        Tue,  8 Mar 2022 02:12:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PT+fzror1NvdW4nnT0KCV4chzssy30ojJLqTr26kkV0RYJDXq20tyHc2tPGcoXqSowJ2ezbgLtGp1poJLwvw97CJVC1cuUduXcOA7M9lIuR48N0/9YL+OHAsA9c4yyb6uDlrS2Em6X0iNXPPG1O52TNbr9Imd311wwpdHcBqDxXzFnmnOBj1OPp4qENpYNlBUngMnBn1/4ny7nyVKRuEELEP/aZNsIFrGtkeftb8KBt5zcs2GP3tvoe/GBzax8IO3PAOu61xITnSfU3YQM5K25xNRzeqIE9Lgw3jXlbH5o5HLNyR59aJeQBgBA6LobHJwZ25jxs9E/Q9wUIuDm9i2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RJTJrS0xGUzcUODpbPy8iPWVHPAimLAXVVTlYtcfS+g=;
 b=Iza9dnqGyIe3F3WJ3Y8HziUOPrW5kkD43AIVJPCBnq4ciKdUGQchRCLqrSGDaE7pgDUPKmVPVTPa5KcsHLVb727GCX2bcGDT7k00untiKFsuvrydg0YHkTB9opBJOkp27o5iRVjRTik8TDlZYdzlxGHBPsgyaICLXIC+7JKK7N2XoAMlG1I4t8nEy/Xf+lxPKU1XJD7QV0axnujFZAvFLloTldHpjXGEa5apf7/7qg7qYpnQZgiuQeaZmkPba1ikrJ1CjlOl9XM/nDV0+0ZWGwg3/VgZEg1oF14vtPyTsqMCWCIiRdMr0WPS5gSf+zbVXDlTTLGntF+WHqgMu1myFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RJTJrS0xGUzcUODpbPy8iPWVHPAimLAXVVTlYtcfS+g=;
 b=mxBlxyxegM72rZRFLrjhDg4zMhzryYC4YFLAAl1BQAZZwcEtY8uiCLB+1Rw+Twmodz6suOeST4k4oDPA1WLi/EMkGMncVDB+IMkeLP/kAuvzvE7ZT8LUi7GY7O+B6qtowKVnu2kraeZaRu1pB8R8xhLmSuaLKRVAvlD3BLsai6KI8e4qXm8aeI+AIGiH5H9KfA87FbV14mqrfGyz4du58zVosmJCwAqrjz3wS8zmudk37rSJqjud/5tTENJK9qx5xEMRcxoE7yXYsWUdf+OZBp7VgEtA+J42sohn4T54tawnI2G6fA7mkBTFWBrq1ojHB6CH0XWLIV9wcJ52Tk4jqA==
Received: from MWHPR12CA0027.namprd12.prod.outlook.com (2603:10b6:301:2::13)
 by BL0PR12MB2500.namprd12.prod.outlook.com (2603:10b6:207:4e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Tue, 8 Mar
 2022 10:12:06 +0000
Received: from CO1NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:2:cafe::5d) by MWHPR12CA0027.outlook.office365.com
 (2603:10b6:301:2::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Tue, 8 Mar 2022 10:12:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT038.mail.protection.outlook.com (10.13.174.231) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5038.14 via Frontend Transport; Tue, 8 Mar 2022 10:12:05 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 8 Mar
 2022 10:12:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 8 Mar 2022
 02:12:03 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 8 Mar 2022 02:12:03 -0800
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
Subject: Re: [PATCH 5.16 000/184] 5.16.13-rc2 review
In-Reply-To: <20220307162147.440035361@linuxfoundation.org>
References: <20220307162147.440035361@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <73d9036c-e6d6-4e04-8a22-00c627917e05@rnnvmail201.nvidia.com>
Date:   Tue, 8 Mar 2022 02:12:03 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab291f25-daa0-416d-6cb0-08da00ec1924
X-MS-TrafficTypeDiagnostic: BL0PR12MB2500:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB2500515CEEE71B3734023C48D9099@BL0PR12MB2500.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2ZzKrVVVsVQsrByjqtbDpQaXKpHn9UOG0mbU3HbxfB4chDN7CoJb2M3weNMrXAMXlxR/9dQFuTpem5yIzyRq73CSzTaUmn0ihfpHVySA9tGrDRrrtrUS4eQfs/pHzh8A8XSWkga7nZXmTdT2u9fRaF0IyToEiv6TgCbsf2ruHTgwL+FonuxZlMGijPDLE8eF4wvfeBB8145bz/Lor4alV09OxZ7tFI/jVLJ5n2USXJya6hP7ltOwj8P8AnzoaqNNGQLYDR3bjl+Yi3P+p2dp4O0VVnp/8p+lCZ1GcnqmrdT3QMOZAg3Ir2E4VIOgvLAl8+bLAUIrTswF6tgKgoNltPpaEs1efu1ZMNAmlRml4AmDctsViwzxpFUHtuFIIf+DPv75zQpeHVbLXFYljDxJikMWjn+RWwUcFmePQ2z5wAqXmxxX5BK8YMI8Wd+bc4PxgkRZUQJGL16wxgbAwSXPvml4rRBOaXTNlGw9L1YU71UhiApw04nESXykE9Gj3/Or4b4ePR4NFHM63rj53BFXZXYwrlwjBU0ezzxV0LUycaQ1sZ15p4TeReutpTbyUwCTK+RG7vczUCVCRlOlIi6zVRSHdAzZzz8C1u/SBLCieFEcZdkQvF7FIEz4SWGo5QvBN3MsWzmVHufm59kwESFWdt7dnmYK4IAlzsHNcASRZXObe2IHVBxVH7+KphAHU3Nhsu2uctqNppWXV131Zsct3R0G5x76ZhVFoyqJZJBPnT1bWDUkQVw0JhYQl/dKWkkRAcR7LtPWRK72W6f29HneXqZ08YUVnLAryO69ZV3XECk=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(82310400004)(70206006)(31696002)(4326008)(8676002)(5660300002)(70586007)(186003)(86362001)(336012)(426003)(356005)(2906002)(81166007)(7416002)(26005)(36860700001)(40460700003)(47076005)(8936002)(966005)(6916009)(54906003)(508600001)(316002)(31686004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 10:12:05.9352
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab291f25-daa0-416d-6cb0-08da00ec1924
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2500
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 07 Mar 2022 17:28:30 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.13 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Mar 2022 16:21:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.13-rc2.gz
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

Linux version:	5.16.13-rc2-gc596a0efed21
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
