Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADF349BCCA
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 21:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbiAYUOq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 15:14:46 -0500
Received: from mail-dm6nam11on2083.outbound.protection.outlook.com ([40.107.223.83]:4234
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231543AbiAYUOa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jan 2022 15:14:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lbQh7IurAzsPudQQYH6rvEdQF0I+xR8/HLXMLewa91Iun7Fm5PL2aW56tmlj+I6mmyjwaUldJTTnHz0eaUCu37h1KkNHK+0hqYp0BfliEGhrFv+kTWzbObSz+FiZ9IOmDLrm29FeoH/B4d0QyJTJS6Fsgw/6Wmz4BHscfTB5NDxiPXehkZZr2lTHSVHOy2BzRwUOxqu8z9RlMmCb8KXzPB/Km5xrRdBd7la0xfjZz6HbPykbL8LN1l1Eltpae5Sa56u6gNd9ef8E8AXCPy6xW9+KKpU7Bbwfukl9Z0wR9yPjDZZEbRdQaHOmjWKuUQkhZy0jr7DWMyX63ThbnKPWHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H2VS/W3tTjsmY+REcndeHrXRz19z0MkMHLdNUBvxSKk=;
 b=RpjQtdxL89JyYMmebf8yWVaa2eK3GY4zXSraw6toQk68CNShKUauwty7WJSMPBd9CMfqbEzkuFSuK2iv2uDcL63I/9EWW52m5FC9fwTJgyX5QpQTkzt+Z2Vye/moABizL4oPSy1+yHqFwduD5PT6C/AMgP340u+XmjfHYVRDHEqkAdAvI7ZMqeNvY16XzUlynlGhTyF/z4Fy1ObZCK8MvjYAGmQhN3JdFTQcfc3ZnIWfy9p4A97gBeupyheX2Muissz9vW075xMZ7paJCXEodsZo/drc2AR92sGnf49yPdeC/ZL0abvnEONVfy5XYxshBVWjJ8eexqPUGChUEWGRAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H2VS/W3tTjsmY+REcndeHrXRz19z0MkMHLdNUBvxSKk=;
 b=sglarjYx+OcPRNwfrOjjHMoWim1Xzbf/TK7HP0HxIUfEH1SEH1BMp+Kk3kjBo9v0iN1oQB2gfTZuKi/y20XPvgUMEqjcLuhf1q5wEdrV5lTO7i0mgc9gnvBWrGYWRn6+0fjJrpt4QB5tFTRAIkMAkExFBkSy7BTdDke2SL5NlEJjJVbiTDUW8+2fmZ1cF5QWHzxQKeXs/NfnQFcC5BirPR66ZXerpkKrUYHMyILJREFQNI9ZRaWz4L8X4EC0a7wThL+Fpevxo7b/HQvJ0AIRbw6O/Ti3bnyPXI48Pbkn+q3bOM3Ahws+bxdFe+ZzyhPnlPKBBhYdvUJgXQiPtRwO1g==
Received: from DM5PR1101CA0001.namprd11.prod.outlook.com (2603:10b6:4:4c::11)
 by BN8PR12MB3491.namprd12.prod.outlook.com (2603:10b6:408:41::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Tue, 25 Jan
 2022 20:14:28 +0000
Received: from DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:4c:cafe::26) by DM5PR1101CA0001.outlook.office365.com
 (2603:10b6:4:4c::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15 via Frontend
 Transport; Tue, 25 Jan 2022 20:14:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT011.mail.protection.outlook.com (10.13.172.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Tue, 25 Jan 2022 20:14:28 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Tue, 25 Jan 2022 20:14:27 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Tue, 25 Jan 2022 12:14:26 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 25 Jan 2022 12:14:26 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/560] 5.10.94-rc2 review
In-Reply-To: <20220125155348.141138434@linuxfoundation.org>
References: <20220125155348.141138434@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <572ed97a-0e38-4a9e-8b96-1c1e83c83d40@drhqmail201.nvidia.com>
Date:   Tue, 25 Jan 2022 12:14:26 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2037bb3c-04b6-481b-2bfb-08d9e03f4a33
X-MS-TrafficTypeDiagnostic: BN8PR12MB3491:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB3491226D1EE6F886DAE54532D95F9@BN8PR12MB3491.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8BQsM6RhSP0Rz3BYtDqiR8Guim9PBIrvkKECM+o2QG05a7TDvhucRBG+8/CO03X1e6BzDtqZQCFLYDGW5JtneID+GZWa48AnVLp3APRNXZyZYXaujdwvd1F8CIZ8SG//GSq0VF/nVt158fNtGu3VDePj1PWvNSfWEJSqH8EVbDz3qtRwbRiJHYhdtPQxXPn7NNwI2VtRGiLQSi9/oJCejH0maFqHVYeBX0GHzR/8HiuOJ1q6lb/ScMpacK42d5MXDMPXKHZCm954yQnBq9IBMbMXkTVjdrQ2q8x7ZoYGy1gRu0K/kmfyWeogQ42PMJOQLxkIK1JsYFbXuoXVtAnPs1HGry3ixXqYJg+ZVBvxu6Yscpa+ywT1dU6XBzMciMexp3BsYlYhA7gLNwhIwUKKt1GQemxbD4W+d7hJztLTvDL8EGYsT+eYuMs9aD+uvkYvKJt90K4zFJ1LirbYZDgr48SMH03yZODZHFUOqddGuNy6+HDaIZc6xl/Cq+jaUTBr7ICQrw0E6xZv8XYoDiGVnPPIVqUZ93/AMTTpiSTzyjvBxZedFa5emZMiEJO2uvPLDvqIG+f9GXVVQgnb4jXKaC1KbElvggXDpT0wncxZX96jNH4B9CqkjC+ToP9fRTbMiMAvUYh2GVMrFBNbyhbTu5MhfEHbNWeFP1z2isxD96kY3BCN9dpKd8EeFZq7+k3JOphAG7XPUuL+f5A6Whvq0Z5FNjWtJddUx65RxTN2vbMpu1ayr13WZvF09cUi+v2Gq9W4Pu6lU5tXdDVuMAI+UiiLk3IeD+JYg+4pETl2SfE=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(54906003)(86362001)(82310400004)(31696002)(316002)(966005)(40460700003)(81166007)(6916009)(508600001)(47076005)(356005)(26005)(186003)(426003)(36860700001)(336012)(8936002)(5660300002)(31686004)(4326008)(70586007)(70206006)(2906002)(7416002)(8676002)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 20:14:28.0658
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2037bb3c-04b6-481b-2bfb-08d9e03f4a33
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3491
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 25 Jan 2022 17:32:31 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.94 release.
> There are 560 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.94-rc2.gz
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

Linux version:	5.10.94-rc2-gf32eb088b139
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
