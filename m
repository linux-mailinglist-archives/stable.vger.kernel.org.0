Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B75FA4D51F7
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 20:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245602AbiCJStv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 13:49:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245597AbiCJSts (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 13:49:48 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2062.outbound.protection.outlook.com [40.107.223.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6A74D9F0;
        Thu, 10 Mar 2022 10:48:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eoP8ks/s1nrJgnIgLa2ERHjZg+viqHaybOIu1Y1O2SJmWyrYtCrJD6hdPyPzssSH7S13mo0FtBRCF2o2TJWg5f8o+dP0M9NizjmDswtsPT6Hn9S9yYwE4lD7HYYonF5mrXMzrc310RFzkUIoITWj/1JSjZD93MMKgLIS5hFvhSKyZH6INDAXPT088nkY/SQdfSNOawIx+LeX3302APhfOOkLski3rrKLln/t71W5kyPFHJzuXpl69qy5jpQ1k1sZG1JbW3TDj05dDPNt6xKp8yOiuTQjK4YISIhqNdIa83gDvQ6fXqntzTQ1O4/dyNG/5lfwX/r8Shs4+L5xK/leXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OT6LPSpSJbcmHqQL+y/xP74gJTvCJBvJHbgfyYT4efo=;
 b=FKXYvgKH3sv8iXGgTU2pOAFyxv6gmZ83zOx99uG9/ibKfPrqMJePpWjXgrO94kZhR8iB35E7pQfnI6ZklCnRNLRZraFGXcF6qV9r2/DRpPqucDtylyYVF+NvuRdvDPj4SPuK3oLUv4O59ygE+mqzI7TrRmRZgh8IJEic5w2T+428X8d0S2iQ7Exw9hv8Q8Nt4EyKEDKNyGcFzt0wJCpUoudAc68K7w18ByaMTGE31IJlnIkkmXu6s0SwLQpurt7I1unLee4HHiFHAmkbDynctecB9Z3MQZ7AYkzlM/yJNOBsJwF4grIHqPtNIcT0uqC1jxiTL5MZlbHUA/STAJn2OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OT6LPSpSJbcmHqQL+y/xP74gJTvCJBvJHbgfyYT4efo=;
 b=kq8+L2AqDCUhO6tpb2QHpMn7EWktf5rxw9XEmcl/QBcZahp3M7Lx19lvYX81mSFurht7MZVJwqCqrqTuQtKxGAyJ4XnCJOAP9sfkEiRCE3gI0w371O1dYQ3QRZ+hbg0otwLc4jo+mVfMCwJQ/2Ctez9lURgUAGFdAiHLjm94rYp+Gu4jQIgDj7ss3tMjx3DsyFqXOW8pwNEUEzpBz4I+qJUNAPg9dKJq9s/2D0UOS3bdlzlnk0GqOBn4MmSmAeeDmHhMR823DS9cuuoc7/KJboRy+m1WigaPcwqQd8Fci9v8UHSmwZemSDEXA7z8RfjVbNdjN/s7Qt/w5+wsmcSydw==
Received: from MWHPR11CA0004.namprd11.prod.outlook.com (2603:10b6:301:1::14)
 by DM6PR12MB4960.namprd12.prod.outlook.com (2603:10b6:5:1bc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Thu, 10 Mar
 2022 18:48:46 +0000
Received: from CO1NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:1:cafe::e4) by MWHPR11CA0004.outlook.office365.com
 (2603:10b6:301:1::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22 via Frontend
 Transport; Thu, 10 Mar 2022 18:48:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT047.mail.protection.outlook.com (10.13.174.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Thu, 10 Mar 2022 18:48:46 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 10 Mar
 2022 18:48:45 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 10 Mar
 2022 10:48:45 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Thu, 10 Mar 2022 10:48:44 -0800
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
Subject: Re: [PATCH 5.15 00/58] 5.15.28-rc2 review
In-Reply-To: <20220310140812.983088611@linuxfoundation.org>
References: <20220310140812.983088611@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <5d72883c-aa2b-4479-a85c-74a04c333095@rnnvmail203.nvidia.com>
Date:   Thu, 10 Mar 2022 10:48:44 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57a85753-1350-4136-780b-08da02c69b9c
X-MS-TrafficTypeDiagnostic: DM6PR12MB4960:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4960C06279301E03588BEB32D90B9@DM6PR12MB4960.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4NahiGrqWsqOWExweRh1e+9U5S25cDQ6oUFwo3+wj0+3TMU7FA/+D19Y5eJiEVmhTn6+KEl4J4SOWsX3bREtD0h/06oFwE3Xb/ikfTft1dFZ6aP9M/NXBYerxLod3d9ml3LdSK8Zp6YKthq0PnPi77oNDUHdnA9ZXGkJbr2Ey7VvCUQuRttr7bPBt9SFJiDWE6JkPbOTcdRVSIvji3gvVRQRwhVGYTlx7YoN1ICqK5uy0iR1RgL1yb9c/m6ZmQ+9GRJNarV25SG0gt7c4Gqmf4A6k+N8qNCIVwzSfKffboKx5ZFdcovmIoVgafqXeuW6kdcYplWhtdoWPtgNzuBONS3zLFOh5iKnTnP5E69yj2vYnz06sppQpGpm77jSk8UU/HTTh4h4U4bggpy0ZvUMkep91Hih420EVeBCUHrBFL6LNCR1DOjRNN7jUei/uOD26j3j/HD9WoJUydPVFNamNayGOjRGLljpcJ+BwQ8vEH8a2SiMOcRICBC4W3UyW6uMgXs15AXIzqwjnJXHm0Hehn62q7CBIHjd/3CwBZTmnmW2csCTUIsCd6yNbTSheq6ljiOthpqj0LAeuPVe70y/OPdfUTeM1WTtUZsCT7IHGjBVt/ZWHf0GZxx5uwmKqFIXX9N0UciRqsbcrZnwBMD/ZFnaNsj5mx1Bkrlv6qmZA1FZ1MpQ5M72HIwkOp8hPLzJiB+s5L/O50EKPDGdxravD5Mfk0fHgxgiuYLYmLQI0JOaPVANKe30uDT/ySaNmLCLe4MNvMIEyGlQGChT2834M4wCq18bw2TM2Yw8xPs31ks=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(40460700003)(81166007)(2906002)(356005)(7416002)(5660300002)(31686004)(36860700001)(8936002)(508600001)(4326008)(8676002)(26005)(426003)(186003)(336012)(86362001)(966005)(31696002)(82310400004)(47076005)(54906003)(6916009)(70586007)(70206006)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 18:48:46.2755
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 57a85753-1350-4136-780b-08da02c69b9c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4960
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 10 Mar 2022 15:18:49 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.28 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.28-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    114 tests:	114 pass, 0 fail

Linux version:	5.15.28-rc2-g733316a3fd59
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
