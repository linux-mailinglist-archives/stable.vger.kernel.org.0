Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBD55596A2
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 11:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbiFXJaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 05:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbiFXJaG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 05:30:06 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4593B2BA;
        Fri, 24 Jun 2022 02:30:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nxppndL/jQ0+EvALAstn0240Z6H6hQJ7QmN1QEPGMAuDhzrS78SArTB/QE1bqIslH4Yj8i9TAnvlB0wqleANZe4BZ2bK/UcoYqUhuMKwltRxdaJN+2oaiTdhIki3R4i+gbcIGxWecV0q11iFjhadwDa+gy3zLZ3eK1RW0rykydtYhbm5uPRRDicKD/BoJYd7rEVcCw0XxhjoXKlfEBH7hV0zikhrZeXUQ45N8XzFCAAjtVgdaKtZ4pnx/CSX/VxVMRPdcWUUVDq+ZOGosprDx5BudFeBubFFGxyKdBatoBMlZFUzi23s7DxJYf4Sby6V8ux9qMa9QQ5i5e2/NnNfeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ejKnrhtzhsvZgejBVdP1Y0jJqv/D3BKpUYthNhkG82U=;
 b=CRA/CX/fITSO345PMQirbdjLQv6aup3yFlgshHX8PVjQymMI3bojTkW/zsFmkOb2dV5ZG3HUleN7cSENckfYP3EE5QXNyo//BHoJLpbgJprIkuHuAximZ1eP9MJAq93mt6cb2LZ/4gnf0fn++hAW/LrjyHmn+TJWNE5Um/hRgVXUj7RMQhT7mYq2KBV4XYJJef1s111oNpbZC5Vbg07m0sZqFd8j9dYK1wQELWCMEhpVhVAEF087Rkd6BAMRKikZJBnGpI+0leZkqugjCwCXYd8dhRgiP4U2fF6l6h8G4XvHHn5yOIeT4A3MQaL7llRrUxMZVCV0E4kSHJogvRWe0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ejKnrhtzhsvZgejBVdP1Y0jJqv/D3BKpUYthNhkG82U=;
 b=otuy2L183pBbsMTXG3pR0lpEOezYsmyZIStRZoiWQKaZYcRg4Gd/jONTEe/OfWP1HfIgodWBtlqIymYppkMBIYE3nfArurOQlMtF2KU3gosm6ZIQh7II55xVE25HKA69gDN0xSPOvNaymSWR76Nbg9A51YhiQ1AerkiyoC+2E8cvhR9HaWVy4pH6gJwXq+6cH9l13VnBeqHNYm/fmTvPGU8oT+iHcgtC3e0lDLLskX2lrtM5yM3csrzXBF6hJcaBEhgolZJEtjXpsf11YtD107eeYJ/SU4dBjiKwMi1XRHHX4WGfnNIq6FGK/gFwOt1ULu8W5PjzqMdlQHzHr8jfBQ==
Received: from DS7PR06CA0001.namprd06.prod.outlook.com (2603:10b6:8:2a::12) by
 MN2PR12MB3085.namprd12.prod.outlook.com (2603:10b6:208:c5::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.18; Fri, 24 Jun 2022 09:30:01 +0000
Received: from DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2a:cafe::5a) by DS7PR06CA0001.outlook.office365.com
 (2603:10b6:8:2a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15 via Frontend
 Transport; Fri, 24 Jun 2022 09:30:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT022.mail.protection.outlook.com (10.13.172.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Fri, 24 Jun 2022 09:30:00 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 24 Jun
 2022 09:29:59 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Fri, 24 Jun
 2022 02:29:59 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Fri, 24 Jun 2022 02:29:58 -0700
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
Subject: Re: [PATCH 5.18 00/11] 5.18.7-rc1 review
In-Reply-To: <20220623164322.315085512@linuxfoundation.org>
References: <20220623164322.315085512@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <f8eb9431-9176-4e32-9d1f-629ae33fc3fc@rnnvmail203.nvidia.com>
Date:   Fri, 24 Jun 2022 02:29:58 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd52e99d-27f9-4c6c-ce9e-08da55c41c9d
X-MS-TrafficTypeDiagnostic: MN2PR12MB3085:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vs53eSlcn4obPq+X8pzOzc8pQ+WPavz2TOB2trwObxxeEnP5oO5tveaYswCvGiiXlbYrU2EnuYRDNoeLQJcJN3FrlRDjf/pRAIpgTuK/bkWEEgAZsHRl6VdHOyqQQgNy7Vx1NbNOPgqYlXHllyGIKqeyp3n5gGSpu/p8r9nHPlijSG3Z09X1gvBWfcetTnwjXcC2yAj7GUUKMqxgL89C1gU3yaX+RrhBtOtLUT5E73tj51us0dEyjmkSmZ0GgJreLeVJYD8XE/HM71FV4Jz42nuw9VO7b+8iLQ2dcODKksSEudS2MCca5F5JhiWFd6JJ7DUVTehmIphMmdMTZ+KX9oJmDPVPX4jI56i3AnMnhlMsunAfk2NehGCDqwAFQ+k2aLCQTPOV6hZknp403o+Pu5xwPxz+pa/k9dyUXpfMASvCnAK5oN4GPwoeXGN7kUfWUVeo+ehlkQDTIncgeIJogw2/zjTAm/1WRw+1O5HvUprEdsba8XI0zWXpcFj3h8flJsKKIQncLbyEpeHVdfwuRVgzPnd7xdslg5ody+arKXCa19Nn3N776sI9S80VeToqWHm4EpIzBBKKzaChqEYH5P+4GBLuXN1qtUJdjjAp44jYQIyu3sntq04FiDueUEXvfNyJO9gRIlTtnzo/KBj7TeE+PxlC6Ff6RXlm5L5XIEjDaHvulkQo6WxZpBk3FaU/ZJzlS/PfncQZ0czCVSbVfcK9eWieBp3FUeW+7glzo6C1yZ+pIcar9rG1dzNWZdD9PH99jlMr5+gWDdCPM8dRJeAH6Rrlra0+V2eB8NZcvb3sRXtj3OjnfVhX3xeWE9902/XMEoNciKCRegOKakrUulr1Owk2lY5omnVpH1KMjbbuGkEjAtmza3dJ4lh5Y2JIIftPv5VJoLB2xcODLpQ5kYbiDOHtDopMoLsWmkZZSlU=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(39860400002)(136003)(36840700001)(46966006)(40470700004)(186003)(54906003)(6916009)(70206006)(5660300002)(4326008)(41300700001)(426003)(356005)(478600001)(7416002)(316002)(70586007)(8676002)(82310400005)(336012)(47076005)(82740400003)(81166007)(31696002)(8936002)(86362001)(40460700003)(31686004)(40480700001)(2906002)(26005)(966005)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 09:30:00.7307
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd52e99d-27f9-4c6c-ce9e-08da55c41c9d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3085
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 23 Jun 2022 18:45:12 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.7 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.18:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    130 tests:	130 pass, 0 fail

Linux version:	5.18.7-rc1-g1fbbb68b1ca9
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
