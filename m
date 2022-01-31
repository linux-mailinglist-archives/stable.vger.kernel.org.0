Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFDE4A48F6
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 15:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359781AbiAaOGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 09:06:39 -0500
Received: from mail-co1nam11on2042.outbound.protection.outlook.com ([40.107.220.42]:3745
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1359088AbiAaOGi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Jan 2022 09:06:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oTELmtR255GUcMVoUaRSITuV3EkkUmA6fTGu7mYLHFCaPwALY8+CaoR/42l5OZj9QKa1ENWxehYVqJ9MRu60o/8TdoIf84Cv3uOOT834P9VCEPFK6sefIB+cpjKJUCbY4gX1mp+y9KVtZZss84bf8MlnYGnw1yVzHVXftoGKSPnrPFfHmh2hywj1gVqQsRwWjs8fqgvzsrcLIF1cwvE6adpa6uOM5fnRsRs8aj5wIw9BsaQBsjI/bWp4JTbIJgGs2hrZgAecS7K2x2os8dDWeiSwBOIZd1i7UC0D2VK1Is/ntAS/N60JlcnlWCUtXTs2wD0FqiJKGLcpoYURSZOoGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OCVF2NpRI/U9KRd2xpeaGOaZUrMAY5vst31X/n/X6no=;
 b=nyfTOTEgaNTHqEutJAZWVTV5Ab4uHemZMzW3+LtHhLpjNIiZZxpCgasRsOwYaKilYtNuy2EHlQMZ9NPQxcmAnhDH0n9iYpZAPsYLwSakPwhj0EfeG6uhFobezILlI9JF5J42GHB/iVZ/+LW28h5baxzTXjYAPNMIvQc7Mi9MuuoXNEwZK7hdlbqi/l98Y9eOhRT3TsrqOYSuPo2SWovsXqBX7y2L9d5ICsMAQRSAUznSqSYDmNyf32vfEnWr2m041UjgQVaMKgj7X0iJiMCATVFrpzn1lP376T0J7Jrt1yXXDS0R/+4einem7V40tgbPg8rwtYdznv2rbsd3p5i97Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OCVF2NpRI/U9KRd2xpeaGOaZUrMAY5vst31X/n/X6no=;
 b=JnkjQWeAnn4MM0IxZpC1FVkBhdyNlMOnMInwBwFvIbLgjQYxRDyXGfDZXzXB6ghyKA+XbjLJudGCIlJ4fPoUjU66RN3wxbqgx8IsWJrD9xZxm0JVDrn4Pet4tlDMjHeytlo/IO2L4ljiyuSGZdQynfY48SgVphNpPWiyHaTmXeRdO1nUlPKiTh50l3MJkyAPfL7PiIw0Hu/AXjUUxwx3UCksatP+UPhw2kVS3Xjr1JDWqHfjFKTEGbjbriwocHNTSDBkhpbU6EJtpsR/31QgbrgfbivTvMCpa5RYOBridtaJoMaKF51qndOqnQQeTRMYxgxz1ViPqzPgm2CeugxCOA==
Received: from MW2PR16CA0017.namprd16.prod.outlook.com (2603:10b6:907::30) by
 MN2PR12MB3023.namprd12.prod.outlook.com (2603:10b6:208:c8::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.15; Mon, 31 Jan 2022 14:06:36 +0000
Received: from CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:0:cafe::29) by MW2PR16CA0017.outlook.office365.com
 (2603:10b6:907::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.22 via Frontend
 Transport; Mon, 31 Jan 2022 14:06:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT067.mail.protection.outlook.com (10.13.174.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Mon, 31 Jan 2022 14:06:35 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Mon, 31 Jan 2022 14:06:34 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Mon, 31 Jan 2022 06:06:33 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Mon, 31 Jan 2022 06:06:34 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.16 000/200] 5.16.5-rc1 review
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <f6bc3007-1afc-4095-9007-f27cc2ca8436@drhqmail202.nvidia.com>
Date:   Mon, 31 Jan 2022 06:06:34 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45ff363a-6f04-4d26-dc6c-08d9e4c2e468
X-MS-TrafficTypeDiagnostic: MN2PR12MB3023:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB30239792E538C7B4F15E2BDFD9259@MN2PR12MB3023.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9Aw6FMFGOPkxUXMN6ttlgXBvmjS6auyqHstQ85B9pHtEV6YCEAkuQBi3APEuUPVmJvR51hGsxKxHIkdPQ4DOMvHzpIUH+yvJrFEFKkDXZyWAqpOOknNDD5N9jD+nbPeHyKbiyE3StfTWzn+Q+AiKp4AjIayqdtkWgBuaKGFzs09cqnYOGu+T82wBVIxbXIigf6e+NRbIEBD/rkk1RTCro1zE2po0b6z16BeezadYBLs2wN/ikQ9W5J5EQLvvhuo1TIz8Fy/3ceOeVXycMrROVrH/AMTez42ky8yCejjrWnjU9dXKn8OfjpMYDv6csTaGJ+gs9xKiXRq/JmDEjnhqonYB21JaeaoPnI1vwNFcHxOie5tevcu337AK0/ecmvu13o8idYcglEDr8++M3Q9r8kIBQG8Tg9TCok6gmQUgYJjL7JCFwKcDNB+DbEBoshdwSttecMM1gvAENTZXROEDdNFyINKZpBrLWOK2ZXFeoS7til/5HkQ9NC2nf3B1/ObUMxr84Nzg9BGGLDM6P27sjE+wv/Q0o4Q1c/HeVn+nZju3Iow9f9VzEgTdrOVL08vkzENhN2Qk/Rj8fm+xL+S5gaJtKjnKiKtQTpDrQQlGN60NGAsCHdaJ0hm/E/WbWpcuhrCEPoL92UDj3dlXHVzYmTNK1817UNJtanGkF4/U9cK8ml8KbklBeRUx/emZiEOUVVvruRy+WUq3zl93RGO90Vf6ZNFt3KCCevq3BXd+1v/AT6O94AK2bH+aAKasu7FPdMXzoJOo9eDV49TcETEKTCPaXNx8CIYsf8JWKCI2DOY=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(40460700003)(31686004)(966005)(8936002)(316002)(31696002)(86362001)(4326008)(356005)(81166007)(8676002)(47076005)(70586007)(70206006)(54906003)(6916009)(508600001)(186003)(26005)(426003)(7416002)(5660300002)(36860700001)(82310400004)(2906002)(336012)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 14:06:35.5407
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45ff363a-6f04-4d26-dc6c-08d9e4c2e468
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3023
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 31 Jan 2022 11:54:23 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.5 release.
> There are 200 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Feb 2022 10:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.16:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    122 tests:	122 pass, 0 fail

Linux version:	5.16.5-rc1-g04f8430582e6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
