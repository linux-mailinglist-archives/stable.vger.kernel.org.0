Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8CD426DDD
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 17:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243137AbhJHPp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 11:45:59 -0400
Received: from mail-bn8nam12on2045.outbound.protection.outlook.com ([40.107.237.45]:32353
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243294AbhJHPph (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 11:45:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QuI6/HOZZfc0CncTqosMQP/VXSS9CfBmGG8jAV0Cp43HYQvqi4RoA+uKXW8AxKtxQjuQciRVdoVHjeqTvWfL7WYfMCBUVWBMrwmls5d6DsC3Kqm+H1FdrTlVxIkMvn4AOn1tcpnxDl35R9p2S+5dDjASeAtHxXCNLdAhDffhBHTc6wEfM+QrzcgaVCfGNnXc+RnN3+1h16AOoE7+N5WfAKQ6ldbxumtIECfQrjsjNViZG3urGTB8Swpige5+myWnQU/P98ZCP7LwMew7kc/Pu0yjnPFplnTbIh2/ueAP8nPVaIPYwpYZotnr9z94zLNbrL+VK/f65VHG65AzYc7JXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+VkIIFXZzVcsEUCq1YYzfno0p9HI9NUlNqSFBXk2/Pk=;
 b=AT3njpFxB6FltNgnes/lVUMvhDB/3PsvRzeFrA6qR+qQpy7yk2b25Afo4B9Xp9KT9XFXpLloldrH3FNL7qkDgGzhKnBgcVPl8zce9K75TIuN+u2hTeTQnStG/102JhoP3bWGGHMcqAanS7OsPdotOUQNEkyQYXejxxm5bpTxA9ANxm499acbo8Y/wkTf56oib30nbrTqpb/NXivk/kfT8hOv2+dnZ6x/EuJ4bVY7krEJi4KmR+gQFxNL8lBCmpnLjlmQ+0QmrBLxo3Wo4OFfLA/Iv8gt9eIqLWthJGlHj5VhYqNL1sQyr8WfNsabDDq7m0gxrUZ6JH+LpxVUfshOPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+VkIIFXZzVcsEUCq1YYzfno0p9HI9NUlNqSFBXk2/Pk=;
 b=LX62isRP0FUcpuGZ269PhpZs0umBQn+ApvIvA8JmeInxr+3JTgiYH41/bkdSA+BwUwxugBa6f1OCS//sbW0Wqd51khd/YmTXoTPVGogrb9sUv7LiF0zWfM2KVcuI79JcdqsCbHJAa0olbrEs/nbvskaTOEruQou3QcZ44d5lVGdR1J1jIzD8xewhqMM0q4nWWxmLeq6yd54AK4uvRxIxImFrntGYg3b0b4QMMVeEZ+cGsAXJdIMIWmFongL3k2n2FktglQGDYz/9vrpunDwxtEqPSA90LjDAlgFkuUCZdxZcV/3IYYTKz8ObZ3lMLsIZRSE/Cn3pA8T5qgUOlWAUCw==
Received: from DS7PR03CA0288.namprd03.prod.outlook.com (2603:10b6:5:3ad::23)
 by BY5PR12MB4933.namprd12.prod.outlook.com (2603:10b6:a03:1d5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Fri, 8 Oct
 2021 15:43:39 +0000
Received: from DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::a3) by DS7PR03CA0288.outlook.office365.com
 (2603:10b6:5:3ad::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend
 Transport; Fri, 8 Oct 2021 15:43:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT045.mail.protection.outlook.com (10.13.173.123) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4587.18 via Frontend Transport; Fri, 8 Oct 2021 15:43:39 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 8 Oct
 2021 15:43:38 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Fri, 8 Oct 2021 15:43:38 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/16] 5.4.152-rc1 review
In-Reply-To: <20211008112715.444305067@linuxfoundation.org>
References: <20211008112715.444305067@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <b7fa915263334447867ab8db1d70fa31@HQMAIL105.nvidia.com>
Date:   Fri, 8 Oct 2021 15:43:38 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ef96a0a-448e-41d4-a169-08d98a726602
X-MS-TrafficTypeDiagnostic: BY5PR12MB4933:
X-Microsoft-Antispam-PRVS: <BY5PR12MB49334DE8D6FE7F4F91ADC9E1D9B29@BY5PR12MB4933.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hTR3COlNuj4u1JW6XT0GV9J7JsTkcQSGH4ZX9hpBqkP3IL/2VCDwMupgGzNNsgJ/R38E11tlZqKpcLH8Fo6dpTr8jby0n0+IFneVr4OA5Luq1HPGejozQYf+p4dLXOSFuaEESCxNIZJNMk7CypnKRT6z2IpdDD7OvwScH5+OerzcVn4RqYVVuB2gf+Vptw95RuCLVq/D8pNu68RPhpB+puqWYYjFdUQt2/nZfT8OdL4rlc0+DNy/Rw4STr2OkoN+UeCakkB5IuqMoPQOim4kJqMqMs+ToQ8x+8Z8wAfMqFwMQSMmzD0tGnEMPJ6tPOD0jqwQp7CH0Ls9nJZ3LfL0noIuqjyFBv54TiiTXXZvrYCQSCPynttmd1Hf8f8MBGA8ztkKjFKPiFfmnFkncxEsncM30awHj7rtJSpKcu/5/cPaf+Oe3Yko62qRpzcBfWWD2WDoVUqtQln1fnCKXZFsThH0ABeQ5kqd2Mx57OFfH8paRrcDJmMwiCZInVaCr+/IpBROK+Xa4lHKG1j+NM6JyIPpLE924qlsznfgsnXWRtMR0f81CZ7JdDXNSgYsTvaDMJnuL08QYgfLHMgaBTwEvZwOSWBsDog81NkhhXa15PXCWxanBDOvd8x67iaqWU5XHvRvGK6tdYN8j+emRjK4yGUa+9vhJfljM16yoJDNSFJEq5/l3KGbCcGc5bOHIzoe0JcOf4ZIWYs/Rlp2AqNiSDDhPwTV9jrzcyc/8C2raIQWDqcC9M+E+7meftnknIVEKISyMyJQbBhyFcMLiKryUw1tC6lcIR0NzIr98TiiUpk=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(356005)(508600001)(6916009)(36860700001)(8936002)(316002)(47076005)(5660300002)(82310400003)(7636003)(4326008)(54906003)(186003)(24736004)(70206006)(966005)(336012)(70586007)(426003)(8676002)(7416002)(86362001)(2906002)(26005)(108616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 15:43:39.0879
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ef96a0a-448e-41d4-a169-08d98a726602
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4933
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 08 Oct 2021 13:27:50 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.152 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.152-rc1.gz
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

Linux version:	5.4.152-rc1-g0a25e1455412
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
