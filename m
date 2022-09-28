Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 326395ED77B
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 10:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiI1IT1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 04:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiI1ITZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 04:19:25 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2071.outbound.protection.outlook.com [40.107.223.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F34DFD;
        Wed, 28 Sep 2022 01:19:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mqg/jbj+uwnlr3KabmJuwn491/F0GSHtOdSGn+9QnFhsGL7+rHpuUm+Y+3NuL9ZkVq4pB3ET7pO5eYmOPu0ICabAWE+09klkYO0/4korH+265vt/D6hWvXBIfIoqLlBGJUTjxiNA3Bm5Jjg7tzbhXS399SSs8ot3PJI4GDS6TCaTiwOkLpt4UNFs2xeLemOGwnn/9LVXKqQkIr7oLYInyA3iOz7rmDCA4J5DiNZnYwWw0qObTmkPA0ts5xvo+RUkSuDHCohBGC/1y5n/LTyTIwiHpQ8uvaIbcu/zNO6b+kFkvOR8PM8xqvacl/FK3ARyldqUaq82vWy45NiYovXvGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pzDVtWqF3ccGFP1vqYKwADv6hZbiXIySdhHpGYVeqws=;
 b=bzoBM5OX6G0T6LItOBZUzaieSQ0HtGF0hS8CtBzLDyvVqmHaKczQ4qr7demuQGmgcR0UvdcZdnAgemWFeTJKEbc/5xRn/trKRYgvWv1dI5ih+fVQsVCRJ239GQbcIqBQ0wwQqflTbXnF8kaQRaE+N5Rq12rOTfPNdWJi0ZHiIr9oJpSz0ueV2P3s4BKSAAS8bd/po7RABG0DAKFKhoBvtAdjcw/bz+v7QUHqSHXquOWz6VCmURrMmZYmvEp6m4M1TA1is3rXA4Tn6i+w1A3PCvT+hrPnlP/IpuxKX9SLgwZY0UevkXlsvOY2a/GZdnlOQxzk30nxgc0aQye4L//jQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pzDVtWqF3ccGFP1vqYKwADv6hZbiXIySdhHpGYVeqws=;
 b=nr6K8ALAR7eT0Erjzme4o5BXpjAbFpGjmTy5Z/khHPqA+QJKj6jqZapHkr5nwBODZvK7GsZvwa7id+20yPIAoUva5CLg8fuNVfeVbNFcQB618I97/KwQkrgY9/jnQkseMoYy6U0vIkXPynZfrxvMpYd6xOjj2fp82a+eGxTV3e/jwkE/O/5OulqeJ+GgAT1eozrenEoCpWWjs06dIKEr/jlWvRT4Ig1jD7a5g/nRy9ma63WtFbAUE1JTwlF4qGd4Fb8qyjJ+QNNJId47m4TTVElfPOZC/J91S81+6TchBgyJt4SHPglA34ir51eJH+GOYSV16T1Bpvd4rIyYsJurVg==
Received: from DS7PR03CA0307.namprd03.prod.outlook.com (2603:10b6:8:2b::13) by
 IA0PR12MB7555.namprd12.prod.outlook.com (2603:10b6:208:43d::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.26; Wed, 28 Sep 2022 08:19:21 +0000
Received: from DM6NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2b:cafe::31) by DS7PR03CA0307.outlook.office365.com
 (2603:10b6:8:2b::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26 via Frontend
 Transport; Wed, 28 Sep 2022 08:19:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DM6NAM11FT065.mail.protection.outlook.com (10.13.172.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17 via Frontend Transport; Wed, 28 Sep 2022 08:19:21 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 28 Sep
 2022 01:19:12 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Wed, 28 Sep 2022 01:19:12 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Wed, 28 Sep 2022 01:19:12 -0700
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
Subject: Re: [PATCH 5.4 000/115] 5.4.215-rc2 review
In-Reply-To: <20220926163546.791705298@linuxfoundation.org>
References: <20220926163546.791705298@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <fe5ea4c8-7989-42b0-b67c-d051aa36b28b@drhqmail203.nvidia.com>
Date:   Wed, 28 Sep 2022 01:19:12 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT065:EE_|IA0PR12MB7555:EE_
X-MS-Office365-Filtering-Correlation-Id: 329bd4d3-975d-4127-0867-08daa12a2567
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +zAwl2FhPMtEcN0bdT9rr5lAokDnEFG/1Hay4Xw0tfB4s7NS8NTE7OjAVaR3V7k3RnBhv9TjiBCxEVs0AT5sJiGS6EpE1qYRqTuJkEHPz3HR18Y4DYdOEcp+LKHcUS3b8hRyYTRhYhDkh1UH6g1IOUDzQaDHBpNYZGp4jlH1J1wCpCq0ZA3kzDoqT5mig/c476P5NWyYTNd16P1PRim9hgq4UtUhIu5sIWJ6lpnD4lhnW6DFwB1F9Sp3mPZ3DlNAS7hnCGDckGudqdFfJKiTm9p7aAtTChTNnUTwSmtd164kWmD04qoGPehr5hESm0oe7zH1XwEF7eLLqjQD95Q9/V2J+llQLpgfX5rBI8LVV0g8+xELv67N5aV2/l8HQnIhwEE1ltd4epfcZTdM0CR6HJ2HLDtTNZNMUuKjX33+zxjBNWbyKsPYp4vVcPF49dS63e0oqFxEZGm2xVAAobO7EQIOZx5KGnZia3wroDwVFLWR7IVaXpD+AA4dr8bJ3zb54kLYQKljd6uu9aMZ7voreJuiDTmL6SkOwizgp07guqd6cTCw2Crk0v1JzUfXhi3QmP+HBK8309uDC2EVLZ2UmobEYAV5KdbWgNFW6IUhUW1H8QK0+g6RO2/7entaun7wW2PqrWFBot2TLcpK7+oZmKqegyMlMI/yy6YZl0IxLzyO2mnlXCbOxaaAB+JC+sUSmQ+HiQjfgIubaPiDOJH3KZmQDoqDCGVgqQvUiHaWR7wC1YtGExSBgJBzEA239F829GS3W3gryMKoGxiq0eSyc6qL6aJexcdwFPDEjfWDnzEK6+hmrNThwXYBSb4ZjJf+cLCZIOQUsmVd+zhXdDk4yKPolXZxBTBNutKDAz9tIJw=
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(39860400002)(396003)(136003)(451199015)(36840700001)(40470700004)(46966006)(31686004)(70586007)(47076005)(2906002)(70206006)(7416002)(8936002)(4326008)(8676002)(5660300002)(41300700001)(54906003)(316002)(86362001)(6916009)(966005)(82310400005)(478600001)(31696002)(186003)(82740400003)(36860700001)(40480700001)(356005)(426003)(336012)(26005)(7636003)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 08:19:21.3304
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 329bd4d3-975d-4127-0867-08daa12a2567
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7555
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 26 Sep 2022 18:36:49 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.215 release.
> There are 115 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Sep 2022 16:35:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.215-rc2.gz
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

Linux version:	5.4.215-rc2-ge5e9eb4c04aa
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
