Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040A645D917
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 12:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbhKYLXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 06:23:04 -0500
Received: from mail-bn1nam07on2068.outbound.protection.outlook.com ([40.107.212.68]:46454
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240512AbhKYLVE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 06:21:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k1bd1TFxS2rhvKpv/Ljw7QlgBnXupIV/XwBAN4P0jXi28IwguRTyRrjnMJL996DRqDd11he+go0A/H/l8PdmNeu1+YG2BotQ2i1/vIe1186MHRF+ngogKj72s6OdxrzMCTh6KRojhPg3xu5GfGB8rOVfSL8i6GcjQ49qhwqTih0OQupxw9GfraZBPv+arc7CHTudaTuWYaVKQ3JgvLRjxeZBoHQjPMk9q3KNoHXGgotYdn28EeLKwkLR1kQVdtYdsPlCE0LleXK9U2cVMMqoQpuhg+M2yvzFrPyigYkFb7AJUweK2jXaO5Am+GHwPiRv2fRe/3rJtIziLtYDNXqeRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8TdpI/UmZpZjOqT2rletsGEsRi4sNYaixS1yZvmS7+U=;
 b=n6qDFCkQBj7nhlJdRhrVFHfOelHLdJ7vkmm63crAzlMCPXNkB5VrhSofOmzlAJN+zRXLElH9WaJZQ7UcqnR3HfqsO8vr0kT/Hs/35nzY0wUP8gQIoSraW//H1THE3HhAaIT2ktpu+/+kpguSbJ9J6AhXKshBZ2Q2ruO5q41tDj7B7vX7984Vh6YfH0KHYjUrlEn0OGquSyJwp3w7rYcA/YFovYB3KOHnDhp+k57Cp5teI0QyCy5h4JGBDIhBODZbAz4L5jkfhodP+5s7d4/qX0mQdxv1fX05/aYzt5ktWSdjzE0eVNDzGq3xaEnYQyJwtdTYWGK8Z6cnthLlNttdXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8TdpI/UmZpZjOqT2rletsGEsRi4sNYaixS1yZvmS7+U=;
 b=GQLWGbVuYZHJc2EjJTOvGgKP5enPvK352v4HCX/BKhW9+fhBikhnVdZIRJJGxlV/A/o79jl15zzArjzcnrRKEzXxOY9h0BKXxof4pbuW7k/Y/cwfRMS0If2nMH0g6NzK1AZgOHzyfZMPptGz/J5LuApNlobhMuebmYaGinJZN9pa9Z0+5rWZlyzlgbcd3HQMB0i3TXY+LeL2/rBhAAOOqfbpURC1nr309vZ08MH0zpvHWmJs7OO0EKpZdU+/dRCCgz+5Bt18ajT/EaIES0kzXnh/SXEXj9cmFeIhxgp/3zxNlXQgHR44lQjZbnWBGLrfaMqdAs9gb35DlMmTH7P1Zg==
Received: from BN9P220CA0026.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::31)
 by BN9PR12MB5049.namprd12.prod.outlook.com (2603:10b6:408:132::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Thu, 25 Nov
 2021 11:17:51 +0000
Received: from BN8NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13e:cafe::19) by BN9P220CA0026.outlook.office365.com
 (2603:10b6:408:13e::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.21 via Frontend
 Transport; Thu, 25 Nov 2021 11:17:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT041.mail.protection.outlook.com (10.13.177.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Thu, 25 Nov 2021 11:17:51 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 25 Nov
 2021 11:17:50 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Thu, 25 Nov 2021 11:17:50 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 000/207] 4.9.291-rc1 review
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <0b75d8c049a84031ad55897b9986cf00@HQMAIL107.nvidia.com>
Date:   Thu, 25 Nov 2021 11:17:50 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2348b90-fd00-4bd1-ef3a-08d9b005386f
X-MS-TrafficTypeDiagnostic: BN9PR12MB5049:
X-Microsoft-Antispam-PRVS: <BN9PR12MB5049812641FA419C4C533A24D9629@BN9PR12MB5049.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zpxy/pimOwTGcJqYZwRJFEySH1ccXTlbhPtMQ+MJTiqPbhVwOWmupHPKssAp4/pgbWV5Pi85PDcjB2rZwBPSCuyD4lGJ8as4mU0MMpIzqZLy6WUuPN4gZGeQxgXvtzb0awpNomVN6MO5Zvs1amnMPKaQepJILmhHmzC/1qcCxZsASZsAdRrS1UylLdSpEc+Q6F0DjwtDdlf8VRQQ54ac2RZMdyeaOGtZ5sVMMe9E6Gt0GW3O+/UNbRMTnlkL5+LTTCV8nYykRRa5U0meMtjCc2yi+dMbtk4R46jpev4bMtbv27oW3bwPFkw8i8VwKBBTuJMusvtsKEF6e95K+do7zRzpUbshbQNGCJ+KOxli24axkWgO2c7oegOQRk++uECuGSooeaO7Xl/8oyNseRveZp4DfnDM9Veh30R74+oI1b8mOUxE1WOWumn4eK/UUkXqtxMrJH/9cx1yrnuqIh5u7nEobeeV/cK2gT2R4S5aT9+cLguGfAlwDL+rFO9FJzYa/YHRHurKZMFDjdnfdKAqaRq4/r7MHTiUNW6AJLHaBfY3EF4d39lbvjn2ai9EvI2/jEyq74YgJ66H3VXH3Pi/+tvHu43g8vQI1Ow+xEmQ2NI1iUC3uyGQX6n9HyHOF5TdukyWn8BoTEgXNWZShd6D+IX7XDZQP7Sn9E8EDnt0q1/y0adUe9eTXhHz8cnfJ1WKY8tElxR5rC0Cgvikbiu+29pKzWZ0gI2D9y01fbaixC+VQHRTzRCM6SFqPFEN7S4BwzghJCQLO5o7ESJzBTtgjCwXIppFMeaW6c6av1k35XA=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(2906002)(54906003)(186003)(508600001)(316002)(7636003)(426003)(336012)(82310400004)(356005)(108616005)(86362001)(7416002)(36860700001)(47076005)(24736004)(70586007)(26005)(6916009)(966005)(70206006)(4326008)(8676002)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 11:17:51.5372
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e2348b90-fd00-4bd1-ef3a-08d9b005386f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5049
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 24 Nov 2021 12:54:31 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.291 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.291-rc1.gz
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

Linux version:	4.9.291-rc1-gb2ae18f41670
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
