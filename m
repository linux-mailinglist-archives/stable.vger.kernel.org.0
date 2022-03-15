Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 484CC4D9716
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 10:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346363AbiCOJFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 05:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346342AbiCOJF3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 05:05:29 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2053.outbound.protection.outlook.com [40.107.237.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860591CFDE;
        Tue, 15 Mar 2022 02:04:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VvZIqnDTlrGoC8cPCT71iTIRTWcD3N901gQC5vFMUQKuOaPLF4yIx8O/o+zajNjh+qA6QLEIOO1fy8o4gLwFWuxdHtYxaFpPnr+Neu4UIOkZVoZKeORYsbua3rbQ0ErdkkJNet6oavncet9Njnt8qcyojkjyuHBaEzgTXxBbCG0QpD9Q8H5uBbYQfpKVzLz+f711Hef9Fugcv1MDJ6rF0oicQqlqW6YOvZ7c2rhy2K6wnb/Qo+OXJM6b5c+/xNhsNzmdU7wgXQt0EgJbUkG+sYVq6k2JmQnOAjqH3kBp+9AN1Blu3npj9eKSbc9bt/PqnTwGhV4vVOsk5QdV65485Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wstBT4VSgOtajnTaq1gSDtB5nbAzhLqS1F4qsLbG5y4=;
 b=PmC6oqIQRbMCISggTToJJ8mdSFvZ3hipdKBZa/5eDF9zz07u11M0xO59OOec34aTA6eHwWVL2v5TxJyYusPRGkqqd7FMQOiJeay0erYmNVTGKxB1UlRLDDFY9F3BdsHhOP29tBSJLN2AP+G6rxB0XLldahLd1/RQpBjHSIp7C44Mk+FjvzGZNuSXvhG9uhoXLqD0iG5m/4b3NH5EBY8KQ6+nRaixDBHE/q0EylXyMh7xoVFY9DMJc3eBnno0OB+PmYaqcczD1EFQEVV08Sl7aA2ccLxKKuCvxhZvWcDTHbikVD3OMg5fix1x4CfiFlM00sPmnsnIEmSYMl3S3QRqOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wstBT4VSgOtajnTaq1gSDtB5nbAzhLqS1F4qsLbG5y4=;
 b=VRSipHAn/VRUYv5qzoF6Da8dIBePvjK8ygBjB5TtQ/MCwF52pk6JvFuxyLsFnVo8CLk+DQFChaKja8lZje9IZwBpTJiRRBA9n3u0ALzaR661ehKsfgjDHrzO2TWZ5s2EOG0bwjRrfv6Qq9QpsS7ehbGTVbMly6yZ2x57lmmcIT7ibOLvy2jjVzl4yvuOWG/DCv7e0bN2Zpi/U3VrP//ENxPUcSyBuQnoGki/bmOlyStuFqZJ9unkxSc7FkRBvJU+gf27Br2wkNaQk7jf54TCLhTthbaQjq6p4xHk5xr8fturDVp479PzsC6XuZGnOjx6uowxWuYIuO2W+yZaKTmXTA==
Received: from BN9PR03CA0408.namprd03.prod.outlook.com (2603:10b6:408:111::23)
 by DM8PR12MB5429.namprd12.prod.outlook.com (2603:10b6:8:29::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26; Tue, 15 Mar
 2022 09:04:15 +0000
Received: from BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:111:cafe::ff) by BN9PR03CA0408.outlook.office365.com
 (2603:10b6:408:111::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.20 via Frontend
 Transport; Tue, 15 Mar 2022 09:04:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT031.mail.protection.outlook.com (10.13.177.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.24 via Frontend Transport; Tue, 15 Mar 2022 09:04:14 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 15 Mar
 2022 09:04:14 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 15 Mar
 2022 02:04:13 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Tue, 15 Mar 2022 02:04:12 -0700
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
Subject: Re: [PATCH 5.10 00/71] 5.10.106-rc1 review
In-Reply-To: <20220314112737.929694832@linuxfoundation.org>
References: <20220314112737.929694832@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <9f00a620-06dd-48d1-a526-ffb46f22ccec@rnnvmail202.nvidia.com>
Date:   Tue, 15 Mar 2022 02:04:12 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c423e46-65b1-40df-637b-08da0662c792
X-MS-TrafficTypeDiagnostic: DM8PR12MB5429:EE_
X-Microsoft-Antispam-PRVS: <DM8PR12MB5429FDA9D6E10CA6D8A8A03AD9109@DM8PR12MB5429.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JgsN4WdWAHMbarzLrZiod3TiVrI7RwlCRy03z6C0TV3OcX2M65WjXaW/EnW+vyDfI0AYzbMAOkSGIh8SEN9KuWwuQ9ISFRwY9NluhGdTYKHgYClr/QhOD5Mo6B42c66ohFE99CA9w+T0uEvCqEKSS8UmONJ2T6WHuTDWlb25Si0i3kKuGyDemkWllpcgFDGtTO2AFIl+4nAkHDU6NxUCnut+ndnu61xGwxWSdxZVpDKxllrnKg67MWnht8bXjSvgOIQkbaRi9Kjhi75lHPsDXZ8zJTZbVds+4BKklFzwhC3L/te0ne5mlIpJl2qFEC98kBqUK6Xky3V4Y4m0TxpfdNuWw0Okwgc/K0JRkOzIOQAxBMlSCwm5giFwWfEk6BxOwT7DEs/Z2y/nNecHnySmRXdu9E50R/w/76F7LmptEleWLoBL5IHX8HJRvLjiEl6rHCRxP+cxRPxZfnWhG+ajFNUHXuGUUnNnzEd4NAFKHCE6U9RzBAJyHGVQi45yORATwq2RTu7G/cQoTfkFwvAr7HkM52q2NMtuBOyF+xQ3x14CWxQ/fcaG5jH+unWsQ4A+LkVO1DwP6JcJeqEinOGyymmLW/9FjksVR43yJZDhWv5+T/r6sZrvlZT0cs4ceqHGMFRvkKZjktNMsRbe0m4JkyxNxI89D0+yRMSlHWjoYw/tR/83uP5xYPeHeAYkYZsT9aXg8SfxxisSDrkTqix+lb4xLPIcfosbfUASkotu8E67TexwSDd3cOIa9ShRp7omc3qreLutoM6Mkmj2Iyp6XssbayftFh/rrER3YxCOuYU=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(82310400004)(40460700003)(54906003)(6916009)(2906002)(7416002)(5660300002)(31696002)(8936002)(86362001)(26005)(426003)(336012)(186003)(966005)(47076005)(36860700001)(508600001)(31686004)(8676002)(4326008)(81166007)(356005)(70586007)(70206006)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 09:04:14.9449
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c423e46-65b1-40df-637b-08da0662c792
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5429
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Mar 2022 12:52:53 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.106 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Mar 2022 11:27:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.106-rc1.gz
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

Linux version:	5.10.106-rc1-g1ef0e2b31490
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
