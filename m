Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F9D4D1202
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 09:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237047AbiCHIV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 03:21:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245265AbiCHIV1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 03:21:27 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0925F3F307;
        Tue,  8 Mar 2022 00:20:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lwyh/9C1+ZKNVJz8aSnbdJLLLmf9lad/odPNFuDtoRrqCpK4/fxD/oDPPWRu19TLvihqjK+rRbCHEJ2+wLaNLXsVmf529JvkRtwMZFNTsVoZwNZnjDEZrNb12hx674Q2365UD4WMxoYauoZfv3gJRb2lpMNA4gBwLGsw0EVvA6kJnxt73nZ6XVDsOivQVRy+cEeTl/4G+I6lD+Y+DpaDxeAvsPuLXTQQcvwFiq/XRhi7lJuLs9PLZCDmsdM+YMYp+XeVD6zSqRRVS8hke1asftKJPjr0l9eGFhJb94gyOKeOEJ9pfRpU8iReQ1eMnjzxIh/AgmP3ckcUWWYYqYJuUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3iocYi/EY9eXxJnVsxOF3UEvsZFmJNXmgn8gb+Ya1t8=;
 b=kjsI3DB/eBjZk6x5Xdh5xu/g3bakI1E/Vomg/Y/oYmrApJsdibu4rnsqqSK7k8YW8nZe/maW55ldsxVI1C1sLpBD0dVgRNey7N5cuD0eXXuQWjGK0rv2BzskqgA4yeZqba751SxvLFWZAZKSafqLNct9DEr+3hwYtPuuCYvZFdwXUbOn1yJrte79Mj4yK+GbgrILF1q7qPmmAAb+JwkOY+c8B0EA3T9fGkbRj7wboRxACYqLHmvIaaEAFb5SSxPAzZsHIsc7tseTeOEbVmQuZ7+d6d+YS80qhi4JOJIeYoTHqYgu5FUrZPjR32NWwPXctCELfZZEHfwT1bKpTHWmEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3iocYi/EY9eXxJnVsxOF3UEvsZFmJNXmgn8gb+Ya1t8=;
 b=i58goKf9GAjzTXGJpeXn/IlmWKbW24ICootm5bp0yXSJLQdVHVGywjft6XrkOQo6xvuFi6MKAhHBLevWXY/abl1J9ahVFYqdp/XchMWIb/gJTQah4FlizydbHggKixu1mtpFC9rWc6qebOmOHsom7laFdy19/TapinRvd4BzUIR230N48bgycLCIuj07JuRXUJ8exAb3zFu7S7praiKP87ui3FralDOv8W1TvWvA7PWPPcwLChLhTuMyag4bNqocUMG/OEoRmny5K6DFn4ZSCKdWmmkI73VequMVijB34GpBlMGSAjq1G8zVPsU8Kn9S0X2XaoavP4K1/gFpazXuQQ==
Received: from DM6PR21CA0009.namprd21.prod.outlook.com (2603:10b6:5:174::19)
 by DM6PR12MB4266.namprd12.prod.outlook.com (2603:10b6:5:21a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Tue, 8 Mar
 2022 08:20:30 +0000
Received: from DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:174:cafe::d3) by DM6PR21CA0009.outlook.office365.com
 (2603:10b6:5:174::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.5 via Frontend
 Transport; Tue, 8 Mar 2022 08:20:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT035.mail.protection.outlook.com (10.13.172.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5038.14 via Frontend Transport; Tue, 8 Mar 2022 08:20:30 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 8 Mar
 2022 08:20:29 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 8 Mar 2022
 00:20:28 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 8 Mar 2022 00:20:27 -0800
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
Subject: Re: [PATCH 4.19 00/51] 4.19.233-rc1 review
In-Reply-To: <20220307091636.988950823@linuxfoundation.org>
References: <20220307091636.988950823@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <110ab42e-38ad-4bca-97eb-28f4169382e4@rnnvmail201.nvidia.com>
Date:   Tue, 8 Mar 2022 00:20:27 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 362440f2-7767-4a8d-14b9-08da00dc8251
X-MS-TrafficTypeDiagnostic: DM6PR12MB4266:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4266CAFC7EAF6A3897A13326D9099@DM6PR12MB4266.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V8rKIsxkGVPWVxHchqDdHt3YISwRtM/u9ODA2mczJOBS3MJMB7xFy9Wb6ByHzpGrGG741EnsX/gSJfq9Widii3QWWW0dmak0MaYyLOB/9z6KK4ZyZYcSiFY3orHavLku2T0xJKg0oAiE/PjH33UOf/07IEg0wmitFKM+zLrteCD5zTcAnEmhgNd/nCUA7hMDaAzP8wjitbsG8D9pnO1YXOd4sAhc0ILtvYaRFan44IdzOz5wkpe8hvMI7uZ4KF6cJjC8EkVfw/hEs7WN1S4eJAG+Y2wuIK9DkZEYu0Mj408wO8UF/gbA4dX/vTobCS/r4hJFioVV7cXRtCrf7ANk1wB0dQmwJLid+xiy1zfoCeDwEO0vnyRzCRFbPPNLnT1R7cQEjbdFrS5YiTQF2ED0BHPxmPdDVN517/SYBr3XNTzqwEWNwL1I+D0o69SkB9rN32x5y+f/n6WxRG5bc2a+DPPhlTJ8ezKdXXOESGnlqzXlrUyYgifV72S3g1QY9o+QUAIEEbZpMe//IQgVfPGH3pjAZkfMsmEQzkAmK0mps5Pz3pwGv09Q0soI5T3qTQ0KQ4qPuvfoxb5xCEQVAZvE+olcHJp9GCP91bhn4wJWWmN7bu+w6bK5C5bSINkRBG54AHggu0WlcB445TG2H4N918SRl1pM4f4XW9ChMR3eGakUfSGg+IzxWkHydkBEy6/jMrCdKqmnmQwYkIw75z1rmTK2GF9oW4NaM/I4UjW06Fk9kBatFdLRO2yfLXrX2h5FoTr/1uPCFN+/4cSkHMf2iQKN6AnJOq7UMn1/aZX2EQ4=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(86362001)(5660300002)(31686004)(2906002)(81166007)(31696002)(6916009)(8676002)(7416002)(36860700001)(70586007)(70206006)(508600001)(47076005)(4326008)(356005)(40460700003)(8936002)(966005)(82310400004)(54906003)(426003)(336012)(186003)(26005)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 08:20:30.4409
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 362440f2-7767-4a8d-14b9-08da00dc8251
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4266
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 07 Mar 2022 10:18:35 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.233 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Mar 2022 09:16:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.233-rc1.gz
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

Linux version:	4.19.233-rc1-g0636ce769699
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
