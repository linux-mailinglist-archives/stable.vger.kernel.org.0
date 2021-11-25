Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E55945DACD
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 14:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349393AbhKYNRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 08:17:47 -0500
Received: from mail-dm6nam10on2078.outbound.protection.outlook.com ([40.107.93.78]:38721
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1354662AbhKYNPo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 08:15:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gXQzqNwRX+PMoJSdShyqcHCC04xZ5Cu3QY6oJgbZ3Zf72U4882ilV6mDVm2ccx54p/FWPCUu1kW8ql1v8rxqPQASApPNJlt4eaEpbLk3jr8NH7FcJ+6SvIIoxKvh7ixjKUxcDrltkqiy0ZChk9JmdVdK6ajL+VxEC57eTmzU4eenBx/yQvVVzxzg7ZDhCQBFlH1rZk2QoVazi4B2h2sWpR9CCw0f3pAIWCpcqigpslEmP0L3E5bP9mhJHsIS/EeExW6XUb5hBZLUUkD3qAkgafiEJCthMWsDwnjRl4HHq+4/grdN9uSHBNZ/Uso1pLqchSdOT3Kgs68SbvQ8cV6B7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yX4u5ucEk7MpTbzYdqD14mpMgsottfgPvFVDXvlcquo=;
 b=S6iMNvVQZ5EChx5c2bEsxaHBB6gE5kDClQBSYnIArdsHaQayzjtsT8Lmdl2IDAbl86YitIZWGhRZJm9ZrlE461/MKrTS9RMxQBkMIqedUntJk68xV/1vptKssA4iK++a5nv4sjtEa6/OXjBneG+67xUi6R1bKWrYtreEE7Unuxypzsnwfids8QeSj/uuPsqHlX2+11BpWoRJcNoSZAXVQWnLCzkxLhmC9+G/7Fy9PTJCG9I8NpvOZ7Cuj6EVfRWxaamPfs791H9QpUBtRZe4zzeHkPx8xCRbY7/vjM0asyZpZbIa/zUfijAgaFL9YNYIiJVZFiWsXZg6iXB0w5FF3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yX4u5ucEk7MpTbzYdqD14mpMgsottfgPvFVDXvlcquo=;
 b=fzmWRlrb0RNZJwdcY92Aq1A+v4qzmjWjasz7cdBqXQvhVbTDTDST66jfV9zt2mjsBJn60Mddq+f+MM37WymGYhQQp6xcPbFFo1qD/9IJJJghIGCDjs6Vbp9B2LsM63guCZqb/RZtpNHpb5q8bJA40rhwj1tlGpK4Hz0Bl0JRoxCXYdmcQj0zz9YvK38NJAYzTidGkdRIjT7BTocb6HXIZBAaaWvRPIG1bkpckWL0sIQhfkjwn2dMYa5VIp5XWQNHhfGdKj7bDFk78dgT790gJ5H8yL/uSlhcFBPqvjKV4JUUtUmEnv41+pC6CHu1oQmup1e2yaPFOxq+nNxbtKU8vw==
Received: from MW4PR03CA0309.namprd03.prod.outlook.com (2603:10b6:303:dd::14)
 by DM6PR12MB2809.namprd12.prod.outlook.com (2603:10b6:5:4a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Thu, 25 Nov
 2021 13:12:31 +0000
Received: from CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dd:cafe::15) by MW4PR03CA0309.outlook.office365.com
 (2603:10b6:303:dd::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend
 Transport; Thu, 25 Nov 2021 13:12:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT045.mail.protection.outlook.com (10.13.175.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Thu, 25 Nov 2021 13:12:31 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 25 Nov
 2021 13:12:30 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Thu, 25 Nov 2021 13:12:30 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/321] 4.19.218-rc2 review
In-Reply-To: <20211125111805.368660289@linuxfoundation.org>
References: <20211125111805.368660289@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <f246a0384d9c4774800e23831b5ab28e@HQMAIL107.nvidia.com>
Date:   Thu, 25 Nov 2021 13:12:30 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8976bd44-ffd5-493f-66e8-08d9b0153cfa
X-MS-TrafficTypeDiagnostic: DM6PR12MB2809:
X-Microsoft-Antispam-PRVS: <DM6PR12MB280951CBCF8867BCA5E162F9D9629@DM6PR12MB2809.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IRfuqSr2aoPbvBu6O8dBEULXBoQgQkfBfe41lTJf48OX/1UftFVqpx90p6RT8qyEqzePL7OjZ9qwxwp+/bqoxs4vBCsdvu4jTQ2II2YzpDdkEsq/d2sqvIJpDAwQz2GAg7AMymo1TEAq/S+0Xb8IkQiKoH7kXe4aPCG4nShReERmEnQ+GWzLFk9p5y+7AhgBNFHWPu/RnmoOQdRb8LqL0WpOdQx7GjHk7tWGQB0rM7izIfiNn5NJkpXTaS6y18mOGGeoI+mVbw9jM50nefNUIdCpdZbW4rJ58swmr24zv+eK++Kn0uHhoXm2vG2AQFenBI/QBf9r0u+n6hXDg1nhUNtJrjjKH0Bp3+VJHkgo/5jH404fXS1Dbc5uGubpybOU47ukrBktdwPkkj8DoYDsQ4YGK14BhIGP4QDH6HX3H1PBl4UkAISR/WXG6O3TL3zRbsUvq6f1loiZ754uLgrgBe73auz8jJNxVVAv2KnaYQwTCYSyZ7nYNlADSJW1iJFfOjaOHetva3d2gUHYLjNzzip93jZduv2d/y6npVBbco754Vdssf71vg2rkxprwsHMIzhc1xyhL3kIcmFrM7xqe2iUniZiN4qos1M1oTssDZB5CyVszXj47FY+Zjaz3C1sNUn2aZ1306yy4XQuCHWhZIYfB3GTsyX0g+D0Nw9AZ02Lu3Wk81c438H1MW2LId0E1NpqovTVnfmRWqTLCdW5i72t3hTr8ZP70diT4dNwELrf8NRYyRZmDvRvvn8Pgk9dMNvIaqzvNeA6NE7Xf9MDrN1x+MfhHhThVTClX+OUcK0=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(36860700001)(54906003)(508600001)(4326008)(5660300002)(7636003)(7416002)(24736004)(86362001)(2906002)(8936002)(966005)(8676002)(47076005)(70206006)(336012)(186003)(316002)(70586007)(426003)(82310400004)(6916009)(108616005)(356005)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 13:12:31.2532
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8976bd44-ffd5-493f-66e8-08d9b0153cfa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2809
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 25 Nov 2021 12:19:40 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.218 release.
> There are 321 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Nov 2021 11:17:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.218-rc2.gz
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

Linux version:	4.19.218-rc2-gce77af71d765
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
