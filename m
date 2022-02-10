Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 102D94B0869
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 09:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237530AbiBJIdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 03:33:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237463AbiBJIde (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 03:33:34 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2043.outbound.protection.outlook.com [40.107.244.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C1121E;
        Thu, 10 Feb 2022 00:33:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yi9Vy7I4qA4fq43336tAgFi8HX0/xCoA2iR0WLQyhnGjaLbNq2kZOI7vx63dNk3CJatqiPX9gn4039AfGk/CZNt5Qhje4VgDjiUU9io2SMtxkA58/boo1S5YXFyc7K3F6hi4aPev/xdeYa22Sd5dGqy5ltiv2y/iK6ivE5Gz9XvAXhYvY6fYSVyt2Zz2Tbw6JTMtwckiUvax46Z8W6xuRZvPVmNdZ3S4JotS5LaOGHFZVb+hGMa0BiXcEkqCgbLXUksYzgvb1Dm4mrF4HUHEXekHAUVvSjDyPQgouP2r4EkL3LFTYz0U0qMo4F01AosuTAyVyrwn+CYW3P0J3dDK4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=stxpOAwujWWZJ9X02Iav05Vdwr1T/+l9o7je+pV7M+U=;
 b=ehU+y5mTd2hFq0d1/bQQyxcBScTvR+UGvt9pKeeV9OzCFfoE851kKpR3zExFZNihuPyPQBzGCkMRPobJ2gURios9CeTWUvesNoJYMUwaB36Q30FDh7gEbSS4pD20Ep6OMCfM/VxhqOj2tOcEP2xAbRfms6+POaNvUx/QfmeZMSx/PQRMxDdDk7uhn1TZOa+nLdmfR54YbLUpLrlj1E6UjsgS6H/XnV/XVMaJYiL9GbsEKvWmLnEdatHAwu5W0EWlol14BLD+jrfJROIhZUVXGy+ZuYfNNt/xf3ukyZFlIBQFz/NllQClYQwJTTL3WLiKFV8/v/+AGdZhA7meDqTBSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=stxpOAwujWWZJ9X02Iav05Vdwr1T/+l9o7je+pV7M+U=;
 b=PRQrsVgdVdLdnjIHNuXKRbfl8P1n372MZveqPi4mFTE2Gs+xdwx5szvGXvoibW2fwoP1doWl4LoDGSUBEM9LR/qjHmp3gqu4yMmiunFeLZ0yYU+WTxKPlpqkau7qZ4OuFPu6UfIT7Di8yxUE346ixL0bBkKHNgPoRV7apHRdEaF0djtL0H3GS6DGX9MKWEzRcUr+MOGSVE5bVtNE1iD/JADjGKJZq7jfKQndpXU0pqwi4rk8JghpLBfM7p3h236ZIm2fQARaxiTTGC4ks95DYgLqhvKg2qMhFpN9RFTb8uSmojhmFpR01HT1DLoIlwZjfA3667wTF9PfW7710S82ww==
Received: from DM6PR01CA0005.prod.exchangelabs.com (2603:10b6:5:296::10) by
 BL1PR12MB5362.namprd12.prod.outlook.com (2603:10b6:208:31d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 08:33:34 +0000
Received: from DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::1e) by DM6PR01CA0005.outlook.office365.com
 (2603:10b6:5:296::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11 via Frontend
 Transport; Thu, 10 Feb 2022 08:33:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT052.mail.protection.outlook.com (10.13.172.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Thu, 10 Feb 2022 08:33:34 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 10 Feb
 2022 08:33:33 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 10 Feb 2022
 00:33:33 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Thu, 10 Feb 2022 00:33:33 -0800
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
Subject: Re: [PATCH 4.14 0/3] 4.14.266-rc1 review
In-Reply-To: <20220209191248.659458918@linuxfoundation.org>
References: <20220209191248.659458918@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <6a812553-5768-4b95-aac2-964d12532427@rnnvmail203.nvidia.com>
Date:   Thu, 10 Feb 2022 00:33:33 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4ce4bb5-df07-4dd3-e414-08d9ec7006c3
X-MS-TrafficTypeDiagnostic: BL1PR12MB5362:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5362A25796C289EE1749C746D92F9@BL1PR12MB5362.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n7RzRQL8aylh2+efMkuMYfyIR3oSUdddz/uoOtXqMAL0jfl12kqCIlksFTLDaZ3DbRgF0g3iA+O5418nQ7F4LeHqOS/JaPlW93m7e4LXYzU4EMqwni2diJ1O+2tXGIZKHAwyQ50/JqM83NMsJf7JjAYRHMCldQKg15oDj3r3Ei6WQMul8QrqsbmOoOf3p2+//BvvoLHj6Y30c1AadZmVmSxcUUKJcXyCo5p81bJHGP4hjl0HVck6FY1lkUDGCRy+fbhr7XrBjAYBF+Sg5oa47fFOFZzmKI9vEVWoAOGf201kA+qtCDs47xOYxdJFqQGotlkLXJa5gdTz1USikQEGIU6Bc8vDO78RxScEDolqysGwll0j3tDTq24ZXhiG+7L+8k+CPI+PuILp+0OdXQEsLYwKwXTlPrmJXSO/tRowWPUJx+operRSPXMR5q/EHJpeenDdRgRz9zM6q96WcuK8DNkzex7zkQ/Uh2e91JS/3tbDSLSmlrV+MBKJVDCJoFQMi1OE10TWXDdgo3EYa0L/hj7jy6GVmpPkDvo+FsPAQVYHt2vcOlYYxAsnQB7JMiI3pB+nZWpGQscPxLvDUpNJpWft+Hs0KZrETgN1pkwrseSL/Le8sieUwtJ2Le0NpS77Dq5Awke/W8sZPUE89ROQde/deVoXaKO3X1/XnjdUj+LV/K0H8d50QfDu3Ly+/AqbKp/TNYJpu0OMnxRN7dJT+ne29vYag7UjzKqorCVIejHjnXxNF8FXPjI0zBl98vlBeuxH9fhgaB9sDqx5TZqoao1gF41q58Ly0BazxowlO8M=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(7416002)(316002)(2906002)(54906003)(81166007)(186003)(8676002)(31696002)(356005)(26005)(70586007)(508600001)(4326008)(6916009)(966005)(47076005)(70206006)(36860700001)(82310400004)(86362001)(336012)(5660300002)(426003)(31686004)(8936002)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 08:33:34.2379
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d4ce4bb5-df07-4dd3-e414-08d9ec7006c3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5362
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 09 Feb 2022 20:13:37 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.266 release.
> There are 3 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.266-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.14.266-rc1-g11dfe0b41849
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
