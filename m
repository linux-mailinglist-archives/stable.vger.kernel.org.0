Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D04432DDB
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 08:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233874AbhJSGKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 02:10:55 -0400
Received: from mail-bn8nam11on2045.outbound.protection.outlook.com ([40.107.236.45]:25569
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229742AbhJSGKz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Oct 2021 02:10:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CaQ7Egdi56LxYQLk2cwYdJHl3QikNFi6S10muFQm6PWHycOohF1wGYZ4z0hAoTP/cDbVvrBeC77ZoaqCeLGHTO8DopbC5pe6hPuJz1Du32AVBKPkLL+xCL5R5D3UjAZo8IOB490p00qdgXHxLlWXy1hNwA8ikIR8L+wEPPjWlf7Tnn9qwAJZsshUbJPg9p05P2wVq/njTpg2OXEku23C+esqc+ynpdeA29FwwWKSuo/OyJ6vSpJv/VreDv5V7zidg1bNqMIcdhtY6acn03Y5mUshGIjBVbPAozNIdeITzFTHhQmScARJlBHklAPlOS63KvdbHg7zdGWcH6zNCSABwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aZ4V8Uh93CuH0CHAMeWUw8qasp0SbsMRqFV1be2i4U0=;
 b=Zgqf82Zvt4QxjCm/psKyUeAqeU/FuxcVH9YXZaqMkqpVfaOYmk14GvokC01Vgqk8AUmMHsUu+IC4ok/DSGIjC04tX4oHecNtQGjvLSO5tD+q4tAAmPL7BpMWK85nFjl7VvBGmXpNKihhDdid/iAhsdGgutwT52YyRF6/OCQm5slWgqOOX8aGUd1PgqFhQ1danh37/JptHEpEJGlCblZGNBeGqnD891bIy/4IENCXKlB3V2WFttjKPiPljxKWtIq96qg1MYE7Qjzl3LAdpM4ZV0bSl3q9ZIqZAP3rBMAfYQNB3qWQK0ma966MUx2XptKes0B339XkXyBuFAp9EzBfxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZ4V8Uh93CuH0CHAMeWUw8qasp0SbsMRqFV1be2i4U0=;
 b=XK9OAhLxGuMG8+7xaDnhhQwIWMIeLj9R06hsOqVn9D4FH6dLdIpJhVmdSUHeavzWuolMkLbgkf/bIfsoAx4W/+G5ns0/CcYV+P9oTX43xBLtmZrp9bu8ZJ7WGf26iEJEYvGb+rc1LyCIKUzNVHF4YVO0Ld4Nxg/aUp6bsDbUGEXHnHmFzYAxei5B5o1FmUFiRs14Yd5Vhqj5O4qoFQocKtXgfwvvQMU39YeS7cLdp9MRZf+kHv6oZYT8aK5Xi3LGzk+s95eipT63VCPCwFz1Mbdio8lg5/4WOzmRj550FrgBiezkmY+tUPKNKDG0OaDukEg0bD2FX5nxu9ND/YqbCQ==
Received: from DM5PR05CA0022.namprd05.prod.outlook.com (2603:10b6:3:d4::32) by
 DM6PR12MB3019.namprd12.prod.outlook.com (2603:10b6:5:3d::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4608.18; Tue, 19 Oct 2021 06:08:40 +0000
Received: from DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:d4:cafe::74) by DM5PR05CA0022.outlook.office365.com
 (2603:10b6:3:d4::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.8 via Frontend
 Transport; Tue, 19 Oct 2021 06:08:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT066.mail.protection.outlook.com (10.13.173.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 06:08:40 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 18 Oct
 2021 23:08:37 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 19 Oct 2021 06:08:37 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/103] 5.10.75-rc1 review
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <11a48572b9af48bfa083f49ce8b1a7a5@HQMAIL111.nvidia.com>
Date:   Tue, 19 Oct 2021 06:08:37 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 249286a0-2bbe-4fe0-fb34-08d992c6e5be
X-MS-TrafficTypeDiagnostic: DM6PR12MB3019:
X-Microsoft-Antispam-PRVS: <DM6PR12MB30193FDA76DC7D517DD99488D9BD9@DM6PR12MB3019.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iOyqKENTDXQoFksdDPPYbSLeT7FFz710+Px1zpNs9ZQxpeazcdrahzERNrPOrKLyYNkoVb8FVWfiuuZEm4FrARt4Xm8rA5nUyPRRJBFW29m4tkYgAj8ZOUDyoZR0Jo7klzYOe7nkqPZpHPp5DDMrIF2lUYsZgnVGOnM2h9ov9kc/qJ0MNFEfD0X3AZl04/WZfvbs/9/oXrJ6/yTLvoYkrU3sBELiE+3mQaBw8Fbb4y/Bc68yNUaDkC0c8Iza6h8BgPP69SV/MBhwQthT/CsxFuN0rIkeN+3tLMbc76jlHE7f4AiEb5OcF3YjkI4PiCUkF0WSUd2gLYK0vm7nz7naNgGewGEaWJ4lXDjck0M2u5ki1+BlTXFrxjdgg0erWEBBSdxFiE2AGjHHuqLC4uqw9QEXD9b4OIPz+AlUR78BsEPoNN2nhYG+gwaVvHojWNhiBQPOObJiJ5vxko3DKvxkAJZCRAYDPa2yDzfy39Kt10ICrk0X1oXpRhp9KrqQw06IyhBidQvP1QlyDr6vsQaFMlSRRD9ZkUqsyYU9p/QYjh9/LpjSomGZzHFZgzq0ruFn5cNUNjG5g91Q85ugtf6z/6Y9EoRi0zQh91utvLHFNngQmtPSv0SbnZQpHmFhJUHMq/PozntevPbAKhJkk1LnAdRmGrcdrGu5l5E0KbrCh7pCzxsMxY+mVbffC9xJ5If6ugmY/uHDcwK1v4vhPQf/LCpkLq3vCq3HXA1IraJ5CVXvTS/h1g9NKroBL0xJTSTfBohxPsLbK5AUzOFhpx5D1+UBxRxnzy7nary5Odwy12k=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(26005)(4326008)(36860700001)(5660300002)(54906003)(316002)(47076005)(82310400003)(7636003)(356005)(108616005)(6916009)(86362001)(2906002)(426003)(336012)(508600001)(7416002)(8676002)(24736004)(8936002)(186003)(70586007)(966005)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 06:08:40.4085
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 249286a0-2bbe-4fe0-fb34-08d992c6e5be
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3019
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 18 Oct 2021 15:23:36 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.75 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Oct 2021 13:23:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.75-rc1.gz
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

Linux version:	5.10.75-rc1-g211949e9074c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
