Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E886C52673F
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 18:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382426AbiEMQkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 12:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381108AbiEMQkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 12:40:37 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2040.outbound.protection.outlook.com [40.107.243.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05A7214;
        Fri, 13 May 2022 09:40:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qe6yWH7nns2dRfD8RhPTKnRQytndpCCP/eCIPWbyL6vANprKnZyPzcXpKtj5U8HArvrdoK3Ko4Uf2Atcj7KgDGC46DCCL87EqQaLuGEtWeb0qFIfyZoBX/fVz98VthL79jLvv++XP8CB7Xbh+pW/ahDMHkDZBOhOSJ4zEIDt0+hsJ3aO5p42CMAeKZrL/MJIUqo7gWqA7700KDaDRY0SFpkxJ7pBLRjr/KdOxmEgZ1vtMQLs+IKcESVO77RSbIY4WrPUo3SwYkBEQR08saJGj5jEmOzlX18auGpci9N7RGVbONqTGafM+n2OgssEIzYTys6UT8mgLQBj7MgtgD/imA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7LVxdiEAwxlpws4NgJCyhX00AGLZhyVuMbJCwWfemj4=;
 b=KVzBH2j3k4GYNFgFVuw00bbgoZocMU/P00rsdtiBFAPWZ/W1YegKXrdBtdD0GA1/y9YocfXMIr95dxmipINWChr7C1UvvlLdMpKocZcvUD3RntToU8kNWxqHXdjFlOlO3JnFR3q94FRtajFASVw/2rRFJzD/MmhGhnzX72A9a1f1b3QK3Mpt9OM53NNOWqdfmPLHAaaTZMs86oobpagYixV3cy7JRXXF13aCO1tUhUzN06W/6waE42F9RJc+y57VNgxzh3KT/VmgBmjG3fMNVO890HnbNPFo7idu0bvrZzzFkxPW46bNd/JupQsiZfGxHvUG3DEMcKYj/kZ2atCOoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7LVxdiEAwxlpws4NgJCyhX00AGLZhyVuMbJCwWfemj4=;
 b=P0EYmbLojsSAqc2PPRSx8wLo0UraLuj9vqyrDXBvs872PhAtAAAig2TVyDRPUgPw1CflYjgji0SeZLhtwY8QZfuEOrWeFbRI6+r6CuooxzTMVM5SZBzYFu8DmRmNNIjE5+JtvREWhT1Q+aXDAgIm4F+qOnss8yq1zMZsTD+OpH9DygW5nWxrFe+S80RM6bCuXt07A1Kc2hbNsGxR0JdaibthSWJWwXoSb5w3qxWWkhl7/S47GATyKvV89NXKNLbVhc6igiKSwhoM8+JgvVQXoyw+7/lc3hs3laWDalvmYR0JUyF5VSmBQNGe/ZVR/EfxfmAA/jSN87IOAcINdYHmFA==
Received: from DS7P222CA0016.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::8) by
 BN8PR12MB3186.namprd12.prod.outlook.com (2603:10b6:408:9b::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.14; Fri, 13 May 2022 16:40:34 +0000
Received: from DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2e:cafe::ff) by DS7P222CA0016.outlook.office365.com
 (2603:10b6:8:2e::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14 via Frontend
 Transport; Fri, 13 May 2022 16:40:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT054.mail.protection.outlook.com (10.13.173.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Fri, 13 May 2022 16:40:33 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 13 May
 2022 16:40:33 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 13 May
 2022 09:40:32 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Fri, 13 May 2022 09:40:31 -0700
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
Subject: Re: [PATCH 4.9 0/7] 4.9.314-rc1 review
In-Reply-To: <20220513142225.909697091@linuxfoundation.org>
References: <20220513142225.909697091@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <1382b60a-cad1-46d0-aa94-6baf914bf076@rnnvmail203.nvidia.com>
Date:   Fri, 13 May 2022 09:40:31 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 261d0251-e3c5-47d6-6d64-08da34ff4d13
X-MS-TrafficTypeDiagnostic: BN8PR12MB3186:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB3186D0587D9600EBCB920D44D9CA9@BN8PR12MB3186.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mwYJkl3NKOq6v9AqBm+8T83xPB6iAWVnqBOU2QjLAYENe+kG6PDuTO+Pz4qqmQ5Fgk6E09UIV7HewWePH0GDACl0mQmmx2r6ktVdWtd5TZwyGI7EvpmdFcdAe2PaTaTX90h7424HdpdkK9W7PjDOJhFoovqjCLluxb6kPCiiDOUjM5zX+P77qz7HiUTwnHRIKP3SqVMHiNwmuuqpjUSygnhFFeoyilcnEC7lrYIkMx1eLV25w1FwY/aQ8lwCLbcq2OVuRQHgDv/sHoxmAmkQ+4bxii6XTnIxUKsFae4RkkBbzrapqaOuV9YJ7qqHNgcKvFE8a1WWHXO7hPnGvSBc/GS+RjDfCoGt3KokPsVy6n8yVg4tQCstOc/+efZibYialDe5Lar96cedzkbPAV3EGxlcE4DDDki+NM/75BnjP4R5eikPJPWYwKdNOhN+r1W9yTqc2zXX4vH1zN2SJnPs+vPxX4iQ6TqraHd2E02p3Y25yfwkEi713IW4UBCu0q6s2Uk5Y9gINe9lVIvGN0sbm3ejbBAiVoYJ0R6s60M8ZBmg3t334Tbuab5rjlRxRCnKle5tci1MhIehX6h12vm/sWY6h9GHaReqBvZGtFzvQS71ApWtT4/2n3n3eUWAxi9ZvAWuVPRuDiueAdw7smd3acEY2ajCROqBTUwmkGqNXMhvg25/y1zfZSe8tAMHgg7jQ6WSjQOE2zov2Vh9Ra+Pbt5dL0dv04Kx6lBYCvRxkTtg/zHg0V+uUNkGzP8BgE9mCihNxqVFjBivJ2iNsXNVwBv1a3j6s/OcJJyCD+Y9LSw=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(82310400005)(86362001)(31696002)(426003)(40460700003)(81166007)(47076005)(336012)(6916009)(31686004)(54906003)(316002)(26005)(70586007)(70206006)(8676002)(4326008)(36860700001)(7416002)(5660300002)(356005)(8936002)(186003)(966005)(508600001)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2022 16:40:33.9676
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 261d0251-e3c5-47d6-6d64-08da34ff4d13
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3186
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 13 May 2022 16:23:15 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.314 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.314-rc1.gz
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

Linux version:	4.9.314-rc1-g0d0d580b3778
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
