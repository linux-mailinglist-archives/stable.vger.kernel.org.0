Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A93424B5320
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 15:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242550AbiBNOWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 09:22:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbiBNOWG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 09:22:06 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2064.outbound.protection.outlook.com [40.107.243.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38700A18D;
        Mon, 14 Feb 2022 06:21:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QV68jZLvB/nVjC+9Y0P4mD+fYxZlwKNimREateZW154JIIZUMAn6KRn1xv6Yz14iT7ZknpDcWSyOVjhaJ4QdnaH8TfrTMFAV7g9b+pWCitkhelzNy07KEkBzvGTvYySrcONd97sC/EWITJddgLkq6GA6wWkS2UwlabhHRP72MOeoEoA4a2f+f4ov2stMlfY1bKqvDBE/qG+lBQXDgm+NI4tbXH7MWyWFzl6zRFSXVx0CWqFo2mL2cwIyHMs146N4/4PHTBZ8PaYKgm3KTxY/+PqdHNjxIasmF/wJ69zlcu3FsHCdFsvniSK01toqIjIY/63e8a/T/Vbo4cyYSP1zKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=82yNFdJjHS33jjfOc7Qx6/p3I6qdO7etMuLE5HpJtgU=;
 b=cyODIAaG3p/qLNFzGZjOZhnuBjy75ygs1yLBrhGAPPHzCImAX7H0TBztlGLeGQsk/mA+EeFzX4tpHtVfyxnaJsWmJ3kqYW096aS/cBgCCAxdGkgyhV3NV1muzssQ1YQE9PzKTztABAF2Xu1BwO6i1R05KpD13XihJPkevQYqX85KJT1JrSPP4qtgNW9JApTyoJD+CNaCdleMl4fdrieSwBBvSGPM8Qm86d+nXweYyG0mb3WnLlWlhc/f3daE+viYQqlUkjYXhxSc+j+OJKLfgl/VGKo8WqfSARji+G+PA4kSczmvZJc/wRmxPz/MVQ2RFXhtp0rGbigklNsmRZp87Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=82yNFdJjHS33jjfOc7Qx6/p3I6qdO7etMuLE5HpJtgU=;
 b=tDQ7ROdU8K5G/76Lbb/gsySX1AWSYuhf185FvRi6bJ+p3k0iuCCNAGa70A+GqsEVoD1gPWM3R+EkuRpsAvJksOdC4ZuTl0h9DqM1WOzzWSBBwuq+sqWzBc0d+TsMx6vZIt9+LUuZf2U4NcK/G2XXxKHUM3nsv4G+qMh8cGTAMmyskJwVmMNlNqAcdwduW2yjsY4hvi7ApJgoculcGKdfnLJnt9t+Khggch96q14AMsmOtZWCAIj2KDvqU+CQ+YF9SznqCftKedtZ064/15IBxa1hRx5oZLY+4MZKa9uDFrORqWJrjbtyr0/9HlKvMmbagSvPVt9DiRTK49sTLEmTIQ==
Received: from MW4PR04CA0076.namprd04.prod.outlook.com (2603:10b6:303:6b::21)
 by SJ0PR12MB5456.namprd12.prod.outlook.com (2603:10b6:a03:3ae::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Mon, 14 Feb
 2022 14:21:54 +0000
Received: from CO1NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::51) by MW4PR04CA0076.outlook.office365.com
 (2603:10b6:303:6b::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11 via Frontend
 Transport; Mon, 14 Feb 2022 14:21:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT063.mail.protection.outlook.com (10.13.175.37) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Mon, 14 Feb 2022 14:21:54 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 14 Feb
 2022 14:21:53 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 14 Feb 2022
 06:21:53 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Mon, 14 Feb 2022 06:21:52 -0800
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
Subject: Re: [PATCH 4.9 00/34] 4.9.302-rc1 review
In-Reply-To: <20220214092445.946718557@linuxfoundation.org>
References: <20220214092445.946718557@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <d1efa8d7-b00c-46f9-83f0-cd0612e08398@rnnvmail203.nvidia.com>
Date:   Mon, 14 Feb 2022 06:21:52 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e9921da-6cb8-4fb0-b559-08d9efc559be
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5456:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR12MB5456ADE9495274606CA32049D9339@SJ0PR12MB5456.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AL/LCxdsNGxNxrKw3uW+kKsYOCFNeAGpIk7DHRD1UJiuN3dhl6vEga+U4rxFkIaVjJ6xQjmH5qQpvaC4FzTZzeBhsWMyZq8gNXqv7DxWCIlbUY5szNhWMDslhhU3eyy7c470f1lSMT+JjoAcdf1Sd1Bppz3EOx23VocZ0EuDAV0xE5uzZEnjeO9qhEgt2ofQcz/PkJ9sVf8YT3+hW7GRWg+KkGYtia3x92L4fnRE8k02Ei3z2+K+2hi1B20ewFoJSe08ZRF71gXmWTiB+i7Jazl3UE/5ejQXY8I390wpJ9PWeeld29nBnRurxEJ1B4/wfx31CmhHJAsfzMvQ1WL98ddl2tK4lkVNDDPpRboh44fY8xZBCwMftQEG+UVuIp7XPjyWLkfpT2pAAq1M6KeY5c0Zcbbsbbkm55SDffT4QMnrw7vkiRMl3AQhQBr2OJbHFYRe7lP6CKFr6Ii1mF5V187ENb1aPwvUmzud1Kp1QQeOycWsg1uvYo5vqR/FyojIgLVJyH7/CTMC8xmQVs/VwwhromJf5Tvvw1LRc13je7uzMUZKo9pXkIrO7J3+2lSL6+4kE1DVgfzTLmeKOObmDhw/mAJjQT5JQmWSAPhQPHRQQfUE9a+BpXAALqVWVWd5cnSMXOgGj2Nm7xLfm0Fe5XxSS1VgvYfn/gtySbGySBIagrJRUcRknqx6ViY76129Q8TTxjYmwGTI2TIDy8WFbx6a8x1U+c05JrPkQZJQ23ZQdTrTE/VfjdPqmXunEuEyT8i4fcNzNUlhd2zMuUBW/qU/mHN7BQYF4hZRVfDCXGo=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(36860700001)(70206006)(70586007)(966005)(31686004)(5660300002)(508600001)(7416002)(316002)(426003)(336012)(47076005)(8936002)(8676002)(2906002)(40460700003)(4326008)(356005)(81166007)(82310400004)(186003)(26005)(54906003)(6916009)(31696002)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 14:21:54.1652
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e9921da-6cb8-4fb0-b559-08d9efc559be
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5456
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Feb 2022 10:25:26 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.302 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.302-rc1.gz
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

Linux version:	4.9.302-rc1-g133617288e03
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
