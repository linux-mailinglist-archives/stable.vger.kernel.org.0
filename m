Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA84506C38
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 14:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352226AbiDSMYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 08:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352220AbiDSMYd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 08:24:33 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2047.outbound.protection.outlook.com [40.107.223.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F552E9F7;
        Tue, 19 Apr 2022 05:21:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TPzMGlzcQzuyvPqiN73X06pLO28C3iUaF0QclkiAenw4NNTKWeDSU/UEzpSA7qk+3ehFNwqdUIQTI7FpTP+enSoDcsDOK8sWObmSvbjp5clxfuYW5zzcecoGt7rK4jRDFTYgrIaGccqBh8Q0tuxVPJA8Z5LvJXVDBMlYbwjT81iBeM7BSEOqeMCCGUJac8YErk0/H+Dp20lafDQu6ufes8jDNHv/KxJdKo1IBpYTfe4oIsoiDp2FftWfdf8eLSxSQAjjl3tD71pQi7PovhMZCTTMhBBWxpQldi0RWZyV4XxgldJl3p70sOnU6NNrm5+wsOqOf6RkUbQenXO+HYOr6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8AQUwROvW27yI4TNuAXgsWXf1xhsppOQueLWwnGdhHU=;
 b=WoY+jBNsjDv4QRmzygCQ1Q3X//4sUJUjNJRo3ajEZR9fzyDg1Bz9i4XzjZfPBoSpvKYGfZncJGILMF000Z3MypIJxHOtc/NQlMJq9B9UHYR9NNGpGpdfpdCCMJkWPVpgo+2XcHt6HqX9jI/1HT5mD8B5cMpEZ+xnlXXK96e5X6Fgi2PZpq8gJzEvABnqHjFaPR6oEyJcDUoSBi2WxFTdCWa9IHFEEyj+l49pBXdcqSsZ688sJh14+EZcRD63+g2+OoeDoWdy4TBzPkaStdc7SfJgccQaRIkPf7NftgVm7xp68L0SN0T9ej+mz5TdXvmaXblHkyK5av1+mV1XzeY7Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8AQUwROvW27yI4TNuAXgsWXf1xhsppOQueLWwnGdhHU=;
 b=NpjCk7o0z/oR01+U9wifxzPQK40lZALQN6veqtCqNd2wuf8P/QIlo8fXXK3N3C1meZH3mjmgAW/+X7jT25EMbaz62Aa1ug52A/lzO8RX52K8vKjZ0DnPYJ0+QCoTiU5vvKh31OYo9DphDfZ6q8uJCVMwRvHtF9tLg8VNYnsfQPjQrclWAZPaAF9ulTnAQKkDniVLv/8k3CcSvKSBW0K1NYQmXZuwxXeZtOM6vvtQqmSYBsipIYMxDkzLPw5thYRV1n7tGremtva8OmJpRj1uaxx2G0+UfWYd9kXs7SgTQUCjS+rXX+628EWDCXQbRWAOQDuPz3II4XJ7RfHWOSHdDg==
Received: from DM6PR02CA0119.namprd02.prod.outlook.com (2603:10b6:5:1b4::21)
 by PH7PR12MB5830.namprd12.prod.outlook.com (2603:10b6:510:1d5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 12:21:47 +0000
Received: from DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b4:cafe::1) by DM6PR02CA0119.outlook.office365.com
 (2603:10b6:5:1b4::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.21 via Frontend
 Transport; Tue, 19 Apr 2022 12:21:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT004.mail.protection.outlook.com (10.13.172.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5164.19 via Frontend Transport; Tue, 19 Apr 2022 12:21:46 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 19 Apr 2022 12:21:45 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 19 Apr 2022 05:21:44 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Tue, 19 Apr 2022 05:21:44 -0700
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
Subject: Re: [PATCH 5.10 000/105] 5.10.112-rc1 review
In-Reply-To: <20220418121145.140991388@linuxfoundation.org>
References: <20220418121145.140991388@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <9f637fd4-1c74-4421-a09d-4a3d6bf28ef5@drhqmail203.nvidia.com>
Date:   Tue, 19 Apr 2022 05:21:44 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c102f0c9-3b90-421a-e437-08da21ff2c42
X-MS-TrafficTypeDiagnostic: PH7PR12MB5830:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB583016C7DFE76D82A0CD1950D9F29@PH7PR12MB5830.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: boTmFCBWC9LDjl71c44iX8hgR/Nk8AjPBozTBayU6O9KbSL/E1pYwMztmf8k8v3T8FLY01TkrXv9IVTqYO6iFwHxHXrYvzy4zyurdfw+oXthqHNC2OMfl5egzu/WToUCdZHcQB6YdNZWoJU0koY/MfcArSOjKguBm28yG5Hl8lJEmLEBAvRcdhjM5vo9oFybe99kKTLindcwZFByYLqJKWok+dFRHwVsq3Zr/x4X/wtMwHH4lcBvolceZGAuRMOZmB4Ngwra8RzI/T+WjKUnLMvrfTnEkhLCHz7Xg7ZAWVh6HOaWZzqRgLOdxym6jv7ShwNom6lkVAz5hmOFqPhGBOIiwqcQQgFyCxuoRmwZIHLnvcFKp1DUdJTdooHVYw/XESvBkd72kS8G/3s/kdgoAvH4R/tD04jK1wRgbKSTfjWwNbqUi3HKVT6Er74HlyK467esiYgd8ICkelWH6M5G0tzpJ0SItUeZ+iIywX2JH3i1yGL8ag8tkrs0R6otYpNfkbJ4KU8+WVsw1Wa5TL/uJ+O8XTY78D6JmWBsqwUK4RgJhmBYXAjUcLdt4wTCsb723RprS7Gj8e9UbeeHOfdseMGD7hJsP1S8wDjxkjWTubXpRjM7Aj40DRpXyButeU87V08c4G8KG1L9mueoKCM0rM2VBxKWjpFTO7N6oVRSRetBvHB4jbkhIpRNZDxf0JlhSyY2nJUEuk2DIeG2jF5jg1IJRpUc51FOygDyYUm0UwToTUfflacWiZez6hu0iGct47WD2fNqTU3w81TAbnvv87DNLp9ftfi4Bvn58RYDi70=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(6916009)(316002)(8676002)(31686004)(7416002)(86362001)(5660300002)(26005)(186003)(82310400005)(8936002)(2906002)(70586007)(31696002)(40460700003)(70206006)(54906003)(4326008)(81166007)(356005)(508600001)(336012)(966005)(47076005)(36860700001)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 12:21:46.8054
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c102f0c9-3b90-421a-e437-08da21ff2c42
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5830
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 18 Apr 2022 14:12:02 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.112 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.112-rc1.gz
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

Linux version:	5.10.112-rc1-gd5c581fe77b5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
