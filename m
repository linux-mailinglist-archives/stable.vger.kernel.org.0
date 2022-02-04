Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8AA34A9BD4
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 16:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359640AbiBDPTp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 10:19:45 -0500
Received: from mail-mw2nam12on2073.outbound.protection.outlook.com ([40.107.244.73]:63810
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1350985AbiBDPTn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Feb 2022 10:19:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VqQ+TZ+mISDn/ZVCKmZ5EfaXv0DItnhf7hGvchV+ey+Kun1hP3Zn5++lyobqNM/J0vFPBQqb87ZzSuTD86OqTX4h5AcaHYPsHKebqRB0ECpkhDtvTdLXoxv7N+PvK9cIIHmDj6cx7SMlZU38j5Ro41+tkSmS7VpgkGTbrH2vmpqZwwD8KGBtxHbffKvjQudwDetMIT8DmgTHQi0MuX+violZihFUeh+NXFbkCV/OpD+S1DUEK4OI8hhLbARTR4/KJhBNK00wFyUQDh6yNoL0/2qIjNv/P2N8qdoeSVh02X2j79+ZaKgrNE6sHfzpJ2pLl79AxHL2AqXJdiHqfcsJtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cts3xwZ4z4tMw8qusR1RT8OUfk9mTKsGBcugK5DXo/A=;
 b=SFXtZveXsDN17yvE1pFS4aX/M2XyFTHI9DxfQKYh5yzrHfp+q1Jaxb5AUAN6VReOfKuNYvZA//tsufYn2XG/Z6kMBi6W+pVGsd9S52BAwPgczpMnRIKk0n57Vi1slISuoV9b9VyhUhcJWAsJC0yO7iWd4+o184g8mfM2FuyfKgb6To0Gk8RD+3GvaKLmgzhmnhSpc+aT/ekZF2Ta9RAtJ936NjEEUFLcLaZ8f3GJuIBymjWV1T/Rr0ddCv6OOcPQmulqOIKkI1gEHDpUyjuILbhqx/pZxdksU6lYkdq+EfO8ooInEMWZHyQ61DV0mo9EyOaaLGuuODwuGnUTn3mOKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cts3xwZ4z4tMw8qusR1RT8OUfk9mTKsGBcugK5DXo/A=;
 b=B3eNwsWBN8qyVeRzr09JNuMKha/8q4I6A16dGjhRC3w/FM1uxcjZwvBBpi+UtL53Zok1e8tD3BLD9xlASHdP1j/bmwqLwRvBCEe7a2OJohnsbTwwHw619XSQ66NjonNR9M8tzkCm36jRonUFivWDyO6hV58lcatHjHpYIeVuzVl4QfnsQeMAcP7SjCkcXiJ7vx/nl5lsDiah4WVNEskLXkZv4rIspD3T2RDc2nIp3ICMqApt+bi0CuThjrpJK17B2c7CSPzJrHop5qO6dLsEoHtSKwd+rpBxRpiZh9TPHgPBOR0YpDvELGWTkncHuCZs7AXFN6AbE59LmtfhfJcBCg==
Received: from DM6PR01CA0006.prod.exchangelabs.com (2603:10b6:5:296::11) by
 BN8PR12MB4596.namprd12.prod.outlook.com (2603:10b6:408:71::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4951.12; Fri, 4 Feb 2022 15:19:41 +0000
Received: from DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::95) by DM6PR01CA0006.outlook.office365.com
 (2603:10b6:5:296::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12 via Frontend
 Transport; Fri, 4 Feb 2022 15:19:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT011.mail.protection.outlook.com (10.13.172.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Fri, 4 Feb 2022 15:19:41 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 4 Feb
 2022 15:19:40 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Fri, 4 Feb 2022
 07:19:39 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Fri, 4 Feb 2022 07:19:39 -0800
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
Subject: Re: [PATCH 5.4 00/10] 5.4.177-rc1 review
In-Reply-To: <20220204091912.329106021@linuxfoundation.org>
References: <20220204091912.329106021@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <2efbefc0-276e-4db3-a92c-ba38d4057913@rnnvmail202.nvidia.com>
Date:   Fri, 4 Feb 2022 07:19:39 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55da9062-f990-45b8-982a-08d9e7f1c40b
X-MS-TrafficTypeDiagnostic: BN8PR12MB4596:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB4596AAD6F4754E67C2F2D8CFD9299@BN8PR12MB4596.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ai7eRVCzDarRa0f4ERd63Wx3YbYKsFK+FWpcQm+ca3xfB8MAiAIG+E9ubT0DndQAfII+2ooZIgZ5+Nnzf4MTEcCGUjS7mVtH4nyvKS8XRZxYU+CL7sX+W/HM8siSxvqH5TfOK9B0rzRsRyobFa4ivhw4WibjYb+VT5rsFunXLeogsG95SzYAEn8MfCIw84UCz61FsaNMh/WYnXJ5j/qgbHC/mSCVlACQfqBpUEbgPGDu5xHQRvjo9RJ2iU2tHColhvBxkYA13HDyM7THIcbCJoZohdDW9MmOIDW7A7Receby9LhwJweUmqWixtiEiicOEkg0HljjImGQ+Wq0dHYANg633QD8A5vWPmm5bzdfvFDe0n4kWrWhdc5bxEE6mYJruVrtg6DGiKrVX4vOlYDe+yawy8S5CRJjkxuUybheEMC+rpg/7Ow9ieeAlBmu54uUtY/LGI6jnbCqDAU51N5eMlBZR8P9Sgh2CObsl0dXDBnnskn3IP9L/qsoob3fCw2TwOCazT6I8APJJRTLMaHh4Or9UykiNsqtVCTHpDaifN+MjWtI2Lpeq2jmefq2OclBj3V6FVsovbwnjhqu5Zs93Z6xuB1EjyRVij2OfmPrERmWib2SlGOHehyDRWRMYu2xgV49yZ3NkPtgtCUXV8H2ufHStpnxCFtqrLQRI3u7qW2SgLRGS/cFaV04bRqdtC4iDBBY29Vx1FeY5oz8Ln0OPtZyp3GHrH3S0XkmVnNxPmwtsSucNK1Khs7uHPqTgpiOeF3PPS9f6MjPkScCEdbU7QOG/sq5vIID0MGIBWjpHQs=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(186003)(966005)(508600001)(26005)(6916009)(82310400004)(86362001)(7416002)(40460700003)(47076005)(5660300002)(31696002)(426003)(336012)(316002)(31686004)(70206006)(54906003)(81166007)(4326008)(8676002)(8936002)(70586007)(356005)(2906002)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2022 15:19:41.0770
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 55da9062-f990-45b8-982a-08d9e7f1c40b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB4596
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 04 Feb 2022 10:20:13 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.177 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.177-rc1.gz
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

Linux version:	5.4.177-rc1-gdb9bfa6e8ef5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
