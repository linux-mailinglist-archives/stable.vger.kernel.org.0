Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E744526743
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 18:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382429AbiEMQkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 12:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382430AbiEMQkp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 12:40:45 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2051.outbound.protection.outlook.com [40.107.223.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F991115A;
        Fri, 13 May 2022 09:40:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=butVxwbnZnZ1N32ufqabfKfVc44qTO22zmV/FYcYsqHROKWt4jN8ACYaGqiRblSiClH45H6bWP8tfUHIyK10Cq085nKfXfX2xxekoLTd8JNdhPFYuUDNRm4FeyqPFcLojYpoW8pwZoFnfvsw7FSPcRC3L3qc2WahmEYUrH9asxEGXTbnS36CJYy/xolKpEfdLPsGE+5HzRjqlfKPFEHLi0IsiLXThGSFzIG/ZmzigmBnjl17IbgdWt46D75vsDn97uamPh2ncBlT0oQFXK5kSEMhZXZh7f/GkAhD1t4g4ynCSsNvah0lfJKPI9JVe28vmd43Vc0jMLLCwHc9EX+X4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MA0OS176//y1NQ4WylsUfNI4ck4jD5Ll/0crAb8BfHw=;
 b=oPsDicl4AtdkBMv1iJbiLaJ2YHX+MTYHc43+Ia5trKtWwhniQgU+XU2BHrRfY1Evbmo5ZlSta0Sgp6qV641a8VBI2oygQhIJfQcO+wmrHs2lSUae3p+StbiMKad9YkGuAeyFPyzAdlnMGI5kjtSAtrprczw4hPII95AE9EqvGkgNbJN0wg/UsIzverhrsLyVYBOdqeDYqwm+nsWmXrFuxtdYDsZC/qL3D9ZaJQd5LhVbJBp8QW/j0zhb+wPNYbP7e54VHhAtbVFGXdoeH5mvwwufwoeH9UJfI8EbIRIEihw6t0KY9usXlGpFshGNOe7LvEuz9Tqf8HAstjHfn5r9Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MA0OS176//y1NQ4WylsUfNI4ck4jD5Ll/0crAb8BfHw=;
 b=UkZV/fVYzplJKLpPcHxmcGvh6nNKJlwtFCiK8dB8DF7xEfR98zCpxmxcODI3rxHz63n1TBQwjc3MjB/XwgzqEofRlyHZ9CDLmSuz7T9A3AGDdEb7n/Z0VmFT2TFflwlyanARZ9WD+t+6iIMoDGrDu+7SJN4YKX3NvXUvmUQiDSuHwR8HwxRvuOC0bLxWHwqRlkznxKvCD09cwft1teNWVGq9QCj/kg1aDUK7T0FCm7qu48TRCTMEWE5tv6roljv6JZBGm9wa9EzigIlYbZWOpQ9jDGFqn/ZcP7LhnEJLTTi3VxMZ0hLDaKd9738csdG1FR+YtudKmLtFzpqo1om/TA==
Received: from BN9PR03CA0592.namprd03.prod.outlook.com (2603:10b6:408:10d::27)
 by DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Fri, 13 May
 2022 16:40:43 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10d:cafe::4e) by BN9PR03CA0592.outlook.office365.com
 (2603:10b6:408:10d::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14 via Frontend
 Transport; Fri, 13 May 2022 16:40:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Fri, 13 May 2022 16:40:42 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Fri, 13 May 2022 16:40:42 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 13 May 2022 09:40:41 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Fri, 13 May 2022 09:40:41 -0700
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
Subject: Re: [PATCH 5.4 00/18] 5.4.194-rc1 review
In-Reply-To: <20220513142229.153291230@linuxfoundation.org>
References: <20220513142229.153291230@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <9abb1c3f-fc7a-4353-b59b-a3524ea4336f@drhqmail203.nvidia.com>
Date:   Fri, 13 May 2022 09:40:41 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1ff68a7-6d57-4ddf-78b1-08da34ff5277
X-MS-TrafficTypeDiagnostic: DS7PR12MB6263:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB62635D2A46718BF5F0170B6BD9CA9@DS7PR12MB6263.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sjmSctPwmZhGWBXyeTTuVi2H5Rp7HnxqshmFNl8CUX6G1rv1hJK6lMGvGMg7Ng2+bc9h2wqJNIMHheReqlsSQMWGxPaS3Gf+Ffu27ZLAghasc0zsXsrrFhKxAb6yVDt5XWKtIEo+TYDYtcX0EXZ5PZ6h8zuYCrpV+br0zihtn41KgtfhKBFgItdIQtFkZCjZXdE7owZ1nl/C+w5J7maxCvpBDgZCrKb5YrY27gXgh8UQI7ZZrnoAummDQzT5CxruV2w5nYXDO1EZYqUfDlq5h/9dTVbGCDt3d3UAxWovAmxfAyPdtZmOKPQsUX+hC1Q26qAzRKr+nBUNPp57BTbGoWLlLaislFP/MvrFRxMN9u7Ewis/mjcsoVabLp/S70STtg3W8jG33ApdBKK8m9qSIRKrHbEc1vPBJ5ItDbz5c/HOm1R8+v2JmS2Tfp0Ya+JVsQbWrnEFYb8n1n98T5C5/JKgE+g9AWHSkRU6dUf9uECDZG0fW0ORIb9HzZU5dbqgBfn6MRMjWcXhc1hrD9/k/Gjm1l86vJFX+z0PyFAmP25rnanXvn2QyFeBDm6gHc/Q/wMeXY5UDYz7BjWVMIewJmypLXb3dukv1A8mbzkdpyt/q2anigZksgH6foc1uYMGiu42Mr8Quyorp35zkgIPi3QYsqMgqy7G42GTRGY7rXbJ7picY8p/2QF5SmmD7lGOz0UMjA7/t5v0gpPt1iZVdKmWM6IV27y1Vpdd3YpPoJSGzefn4cicwzRxfRLi8QfYorm4hPYXVxZz3DQB375h0ajdhRt6/J0jSCs1CfbCTvc=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(5660300002)(7416002)(26005)(31686004)(4326008)(31696002)(8676002)(70206006)(2906002)(47076005)(426003)(8936002)(186003)(82310400005)(336012)(36860700001)(508600001)(966005)(70586007)(86362001)(6916009)(81166007)(54906003)(356005)(316002)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2022 16:40:42.9494
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1ff68a7-6d57-4ddf-78b1-08da34ff5277
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6263
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 13 May 2022 16:23:26 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.194 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.194-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    59 tests:	59 pass, 0 fail

Linux version:	5.4.194-rc1-g15301ad60009
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
