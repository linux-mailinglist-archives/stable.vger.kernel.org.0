Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 650FF51BCAC
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 12:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354948AbiEEKEH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 06:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354964AbiEEKDr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 06:03:47 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2042.outbound.protection.outlook.com [40.107.236.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E93522D3;
        Thu,  5 May 2022 03:00:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IUb5dbzkVYZOvUMVCF/AVY5DIVKyRkvNdV3cxJzXU1at8b32gh+5n+fVfEEPgPonhBMS6K0nZniqaCj6ggUsazM9U9EIEkNvS2IOk77C/BykQ3JIZ/7v0ynWAoP/grvRBejhXTG2MDk0X4GohljbmqCYgpuzZs34qV6Au4Ml0Jw/wfMzVSZ3VQ2EvdOw2pNyApeJMEunVtRrEQiGdEvJN9AufUVwblgx+22JKyXiuTB7qTM9u4GlbBuVr5kgTerPwYZ1sXLISBzjJX8wBic3KEu06DoKVKtgR2xUg/acK8OJcVXA7PcaOD73wItrSq0sIF/xj5L16XEqcAXS4ww1Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qJUqVUvl2VuzQU0dzpXPIl6anG9pR2LYToxkk0BkKZI=;
 b=UGISbiFUsvI+w6ze4z/b8MylcNsGNwerJmOSg7hC6ete3d15A2qyo4IeIbEcju65vzbgJNLj1A2rGtqCMbLinaBrFOPKD1CkbxUlGTqba7WRgg2B8c9n/kIvpAnjSdu8tGJHEb8Mp3fjvfjH9vLVsY9qgJK2ZWO29uPtcKUpkV7OiUHfU27QoBkGRCo++6LSyeqVXnj4fhCqVtFSRjPyHJ/+JgYpBIB2tV733t37qgrjgV4oOo8z/xsiVaM+jzbcMJ+H1h9MryL2QORGd3c5u1of0MyRF/ZwWAFbvrR7lHbLxk4sAp9UllhiMUSxKykfL3sDdgTdfsohi/A3qAVOaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qJUqVUvl2VuzQU0dzpXPIl6anG9pR2LYToxkk0BkKZI=;
 b=p28knpmH3IH3Jk1O98atrp6zrI7T+bvXyUaFXM4jxWctVRsGIsdHkP56rX36BuEHa/gFuksn8TLyx0ybgyN/LEjtY9cNus6qJBSabJtx8+fKZNWUmZyBuk9xqVdXsrbEGWHUyinVH0v8HylqPDu9QFF3qA/pZTzGEGCsWvmywOktPoeZmLOf6vohtXUcumeYqxnjWb5MTfQcV7+A6XLagp31QKsqRNNgQoARjMMqp5ec0EwVH6i5GJdcX9KP9Q9biOAlNawquIXmBuvU1A6dnaJQYy07f4K8dDIvZa3mZPLeDR5WNYPmxvS8bf3WKt1aKhRLeajqnhH6LYaqHz0Uwg==
Received: from MW4PR04CA0333.namprd04.prod.outlook.com (2603:10b6:303:8a::8)
 by MN2PR12MB4094.namprd12.prod.outlook.com (2603:10b6:208:15f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Thu, 5 May
 2022 10:00:00 +0000
Received: from CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8a:cafe::a3) by MW4PR04CA0333.outlook.office365.com
 (2603:10b6:303:8a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14 via Frontend
 Transport; Thu, 5 May 2022 09:59:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT012.mail.protection.outlook.com (10.13.175.192) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Thu, 5 May 2022 09:59:59 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 5 May
 2022 09:59:58 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 5 May 2022
 02:59:58 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Thu, 5 May 2022 02:59:58 -0700
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
Subject: Re: [PATCH 5.10 000/129] 5.10.114-rc1 review
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <ba01fe99-ee30-45d8-a715-b34ec42f5083@rnnvmail202.nvidia.com>
Date:   Thu, 5 May 2022 02:59:58 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b50c7373-ecc2-48e4-37f7-08da2e7e041c
X-MS-TrafficTypeDiagnostic: MN2PR12MB4094:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB40943D21F801ED9CFDE52A15D9C29@MN2PR12MB4094.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GZdET5GV4MPIYvxT/s2bl5cQZDyoT5WdFdnRgAk4olLOizQJaWwhVz+nU2vgBTlGa5uabWUV/OAwQ3Rot1y9lvfl0AtK7UTUSrX0i6tNz/zA0A++WPxpW5KFOShSPVhvBBzN0X9RFHpB8SGfBoolLFVnfRhgeSk/fuMbv4r7fIF8npwu8tW7Sfmgc8W2kQ7OYitdEIAsV2yri1GSgxg1UNuB9H6YTRBkh7oJ90b4UyqrfKCMM17nFNMdDP3UU/ggd8dz1i0X5oLs4dhV3r/NP6Ukvsz4oI6+bXk4P6xNX9bKVwAbA9UwsoqWEv7h8lB+udMgc7o2tKy9NAIxRHwgE10lxO7SwjsTUcF+rR8H/FnzSQUST5xuS+SCJBOEmOLhEmPLusRky6JH/znh7spJgQkFWWQX4u++kVis1AWKKhN9A6OSpQUavIA0r0Hi/e96U9DmViNyNoYViHNJQy/Vji1/GCjQCDCb2xcSxiOuMCHw3SCQuzURHd1VDrM5tV/EYSG5VWWCWLDMEEm2k2BV6a3GQEaoem3dsbKAgLAMfT9nmjtyR9qexJWfdg8WlKrKLTPp+GL+ZWwF7LpjZSP0NP/43BIOzczhlawdk83en0mjA9tGcsnpYtdUKTitlHso740FDB2Dq9gUhKrBMkmWIW1fgdAkPicvZn1BZA9wNQqBgeMwaWluZP/aMlhxYMg8hiRVgnFI8FdoTRjC/ICKKRjibj77HksoUnAVeYar1FiAmOe5JqSdd3t5QElv5svAseATdZBn4N6lpsVldguqHGcVHAr+hZBGiXdEf2sAK2s=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(336012)(186003)(47076005)(82310400005)(426003)(81166007)(7416002)(2906002)(6916009)(5660300002)(31686004)(8936002)(966005)(8676002)(508600001)(316002)(70206006)(70586007)(40460700003)(4326008)(26005)(31696002)(356005)(36860700001)(86362001)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 09:59:59.4968
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b50c7373-ecc2-48e4-37f7-08da2e7e041c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4094
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 04 May 2022 18:43:12 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.114 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 May 2022 15:25:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.114-rc1.gz
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

Linux version:	5.10.114-rc1-g0412f4bd3360
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
