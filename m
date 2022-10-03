Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 596805F2FA9
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 13:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbiJCLbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 07:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiJCLbV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 07:31:21 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20609.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::609])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8058D3FD60;
        Mon,  3 Oct 2022 04:31:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kvIYZ57YX7q6v2pXiQtZ3EyT8EbbnDhjntBQe7g1EErXRcpzh1qXqM/u2YuEPF52VasNjKyxs5dtMvPr6G1tIVOBzEZCGzNDFPIPA8KmOeX/3P7X/pTPXk0Hy1HXWNFnjYKHxqjFH+suVgvfAyRmaptD0OvObJ4Hn3jG98+hMQRIpBwZnQHOZC7CZNlDa+k3wltX4Qe7l53tzG9SfoNnxZCy5YwTa3NH5v8sL+az4omU1pp6mANq8DyIyWGz3P2mcF2RJ7xcZtDMcvTYAQoiHGasp9FJ4xqUBckrm7hujDtaS53LY0nMrjZP908YiEQV+KWt9rq+dedn1WwZPls/4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DP3bIH5XETkHEdxNdN6t5JKS/WQVjPNPekE9rtUKdvM=;
 b=guVZVx1jXdTsmgfjy9AsewK0W7/5gKJ1dOWd6txYRUzVokWirqF/AduYVHZP2r/xfN5wyglnEUQOVKof3/lDFfGxctP0Vwh3ezHaaBZyKaMBkBxfPL9LrEQWaGldwtjtYbyNfIEYyRQkMQechrj5sPW1lbUgIgba5EeP8I87O4UuyEIrHqL7Mjtll4mFuBX17GusobbR4BE3jJxB3/7csIEjCRwFOTYsBPQSL0fkHboFtnQcQiiF1UpinwoyIhK+cP1sc8P6r/SyyS2sQ0f8lOGkfxl2udQ1WMfwYQWpEEsB4LT2r5d+/a3AguCVwY8oAwK6D/eJzY8xq7D6EL4KQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DP3bIH5XETkHEdxNdN6t5JKS/WQVjPNPekE9rtUKdvM=;
 b=RnD91bQ1vKnPF+x9XcQa9uAqHWiE+BiUkiHl2QhHz5aryOwrBQql3JJvpbnpxGwO3M7wnshC1fJ2DQCXgqPdrfAcZ24b6wliGiIMAzYwAfhWUre9hAzdBevhGBXbgwcY2Md5XrMv2EqMUQY72vLltGVAjDMJhaZJ6Nd+J2HCNd3F3jhj+FyHNB4WaooBmiTHcbei9OfLIF2gSU2rK6Nkazw4JsuFyKDjrDh/2YSoYOlKrKJrnvkBrgBWhhhpYieG7ctkxXqVsj0N/SZ6VSX6S1Am4smFYwvoQrHCImBh+xQagh83Zzrm200cy5CCzycNA2i65PCN/lHkQo8K7jSm6Q==
Received: from MW4PR03CA0325.namprd03.prod.outlook.com (2603:10b6:303:dd::30)
 by BL1PR12MB5993.namprd12.prod.outlook.com (2603:10b6:208:399::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Mon, 3 Oct
 2022 11:31:16 +0000
Received: from CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dd:cafe::c3) by MW4PR03CA0325.outlook.office365.com
 (2603:10b6:303:dd::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.26 via Frontend
 Transport; Mon, 3 Oct 2022 11:31:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT051.mail.protection.outlook.com (10.13.174.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17 via Frontend Transport; Mon, 3 Oct 2022 11:31:16 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 3 Oct 2022
 04:31:01 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 3 Oct 2022
 04:31:00 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Mon, 3 Oct 2022 04:31:00 -0700
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
Subject: Re: [PATCH 4.19 00/25] 4.19.261-rc1 review
In-Reply-To: <20221003070715.406550966@linuxfoundation.org>
References: <20221003070715.406550966@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <6eff6109-3cc9-4d9b-a8d9-7453035a0e4c@rnnvmail201.nvidia.com>
Date:   Mon, 3 Oct 2022 04:31:00 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT051:EE_|BL1PR12MB5993:EE_
X-MS-Office365-Filtering-Correlation-Id: fedb4658-1951-4254-cb67-08daa532c8ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VvJBoKQSh0TNRrGeIJajauFn0Y8pjHWjOwQCPARZ0w8u+vG4tCjqG6PWwOiWDK8jd7RFjbfVdj9qmXQbwPtmBNFhXHlNt8BhwsjErf7fRyQaYohxOOa371Fj8bNEaad2f24gJ1NCTpVC2a9Lm1sJMTmoOzHiLyUIj48oznRXp+ENWGr+RnufVjoQeOVE0VmVPXUEGzHTQz7v56hmcrplhJOtP+fk6SjGwx/h5sNbM/PBRNFAibw4xB6kzwK619ZOb5o+2LcQ930AaLg9cQCtHoe5D331bdygQfbyk8tZy7p50D+xAKXRwFcia3qvTKftNvr2XQz+aHUo8jB6y88tRlH03GqGxKysTWFn4EpLz0fwHO0KeRFlPiX5QKb8S7yK42fPs+D/+jEYTlO66lXDPfiufak2h8R/p1dKJbAY/AyuXgHCAgpO4NBGPE01C4frAlfP8aG+n+7RkeJ5N1dqW3v24eWqw2XW/l51IhtjQY7CnVffDn8Raebm8mLfF+eTO0b5fZbSKGwU6pPUnPrdIIAqaae/Bb5PSEnCc4Clh8u6QWwYoErZT1284WeqGjPQsyyabukxeAFR5DiGe6xeGFjw8LGAkPiVMYFcjnYJXLqo1sgNQbPCZycgp57vVLgYqwcP4dDOFQqqSmJK144XoaHe0T2h9il4xcCndKlNCd8rG5nufsKaOUBff1Goipjn+88D9+YFcNiIPDxPpHTaon4O2HG6ZhQ+GokfMgcuKPT74e8lGMqYgWzm6XCItfswp0RXfnLW+1JhRIXckzqRT+PBtrKrv3KSZSvkRiujyjuuDbH2y2MnM/AmoT3wzDIcY47f1mRlKwOuop81YLzCLRCYJGKO+JRxW4ODUgLAl1c=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(39860400002)(396003)(451199015)(46966006)(40470700004)(36840700001)(186003)(336012)(82740400003)(40480700001)(31696002)(7416002)(86362001)(41300700001)(26005)(8936002)(2906002)(5660300002)(40460700003)(356005)(82310400005)(7636003)(426003)(47076005)(36860700001)(6916009)(54906003)(478600001)(316002)(31686004)(966005)(70206006)(8676002)(4326008)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 11:31:16.2562
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fedb4658-1951-4254-cb67-08daa532c8ea
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5993
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 03 Oct 2022 09:12:03 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.261 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.261-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    10 builds:	10 pass, 0 fail
    22 boots:	22 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	4.19.261-rc1-g22f1795c5b7e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
