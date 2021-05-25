Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B55BA38FCCC
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 10:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbhEYI31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 04:29:27 -0400
Received: from mail-bn1nam07on2048.outbound.protection.outlook.com ([40.107.212.48]:11910
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230224AbhEYI31 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 May 2021 04:29:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lhLTIqoI40viVDqvaide3g/eMIICIklRaTJmf+/AumAx6al1X4ZEhi1YPBFWe0CLKnEguj94vcxmDUr+iS7lMCpjcGq/nvYW4bGVWcFBwH3b2pDmRm9tTCqkGsxKSkgXjaYctPkfgvQbju3ACulUerB0eSuhsbixUg49k9xl4d4cn9fDKVqBfOb2rUPTPSufc7OOKNgSSJuAw5oNwcS/EsQqnSiSNWECwb5SvbAbGyZQ82TodfkMwM7qoEnmij65Ot824V5p7W32OK1Zx9+x5vc1T7QpLUBY+LUNjNr/Pv10cMYfEgwljlDrt/aBnWd7BHhTz/t2fI5JfwSkQAnabw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WIwMqSblMea8j6GKtUOlaLmLa27wRmKPjUKdZLsSl/4=;
 b=XEuF+VgiiUhwdMQXfaMqWabGscUWNZN5+bvxKajU6n1nI/r7YhgiZmIMrVVhLY4BtCQlGK/ZV7qupV0Q++mPyuVAy/PNErpaqwqUXowUNaoMYADWRwkGFMPZrYu3UxJrqtYHOm3SdQoZ15bZLpxs4c84Vl55/Y05B2voEdKxiqzh4anJ+fsrMBH4SUt4aTuG/fN9wgkWuWIcVVuhvGUkGpwf6YPeubYAokUluEBxCVD9ZPG84J77bkzRm1CguDSzBTEV6e4FJLCO35kRLKmNGYaA422Kbd3Q0H9BmC1JHjH8DOs4f3R1GHGyuOkLHfePMeDiXkbz0rrow2/vhE/z5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WIwMqSblMea8j6GKtUOlaLmLa27wRmKPjUKdZLsSl/4=;
 b=R2NHKhYsH4FypJ6p95q+80Kf0vsPzqw3p0Ma+/WlRWxMc08O6BG35jt/nD/PYo6WWkXohkfTD9VQlsCDRqCh084AV9ulb9wm06OZp+aIu6zpI8si9NHPpg2nbIcZepXpQqphJBocqQxivWbwqbKjPLOSDark3esO5Vhd3FTlTE59/QZdhdW5plSpsxabQBfxwGI9WAeP9xvRVajq2Z1KjMbpMOSaVQI4+1dG++CDK/oHtxdW7KIBDdVZldkylfjl0TSjcIlGub2pkBq5NHuVMFEk50tTM8l7oX0FqUdW9qvoqtKw/RJu4unGKMtlRncX1B9/Fv7G49Tb1JOq42VzPQ==
Received: from MW4PR04CA0221.namprd04.prod.outlook.com (2603:10b6:303:87::16)
 by MN2PR12MB3167.namprd12.prod.outlook.com (2603:10b6:208:a9::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 08:27:56 +0000
Received: from CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::1b) by MW4PR04CA0221.outlook.office365.com
 (2603:10b6:303:87::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend
 Transport; Tue, 25 May 2021 08:27:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT043.mail.protection.outlook.com (10.13.174.193) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Tue, 25 May 2021 08:27:56 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 25 May
 2021 08:27:55 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 25 May 2021 01:27:55 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/71] 5.4.122-rc1 review
In-Reply-To: <20210524152326.447759938@linuxfoundation.org>
References: <20210524152326.447759938@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <5e1f7cd0485f496499de46aa1aba7969@HQMAIL109.nvidia.com>
Date:   Tue, 25 May 2021 01:27:55 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36163118-37e5-40f4-b30a-08d91f56ff5c
X-MS-TrafficTypeDiagnostic: MN2PR12MB3167:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3167F77B90462EAF1FF28F72D9259@MN2PR12MB3167.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r5LCKy1pMeneisgY8Kc0d4ZIRqL05YYhz5D05zkmhl5HhxJaBONTSD40GGAxvuPQ7VMfHTZpLsi4P9M8Tt4Q+VCVu7+2e22a6k6FiYo3RSMYr+iObvbX/+DF2wjFDZR7bR2Oith0JpqR/I2nRMXwfsr4hj+tbohjTO8i95w+SNg0TD2JkHAI9FR0ldAuW7zIe712GHFQVMGEy7PCed9BtiFx0v6wdEJmXLX5mpP8kJ/12WWNnmpAAfp8fv6YMGeYOv3GxnZN3WLA++3Duj61rsT0VS5jT+xUJzkZQwCgAlLz9eZpUGbwPva60knY4uqWW7wcDvYJ+2Caer2SVDFk6ZiPTSmSOdgB+ZbXn0UU3BvCL/fz24IGgZE+ftDiBCtVnkCl+zzCG3/Y37FzZGftulagxy9aldkI1K7egBvum6EeWzeTAx9vzi0sDn/2Jl6L/21eHpDnHgDFzPSgK3Uo6Kqbk0mjEO0Q06r5VYvmXaccgXlkSdN5yi1Z4IlHcmdB49ecBmsoydX/xvjvLsJqHC6IlvI3jPAx56u8QWIFoER8p6KfYo342+mbUjMnU2Ud+xI8P+u26bzShwpp8QE9l3V9gXVF6sc9IBp2FtUitQa5P3rRU0GE5zX9bDzTw6a4po8nOjC78bgVvXJBPwxs5I667e0a2ycvcMOCTqUC9ge2zMzHfgPdxmQItd/ivBkWXMumTv7T068IwIwwQfbTZKCEQlGsRutfL330qOo7kpowT/3VfrTUerc299pRKGvYlav374Jm4RxqjrS9KvykoQ==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(39860400002)(376002)(36840700001)(46966006)(70586007)(356005)(70206006)(8936002)(6916009)(7416002)(426003)(966005)(82310400003)(47076005)(86362001)(186003)(36860700001)(7636003)(8676002)(24736004)(5660300002)(26005)(478600001)(108616005)(82740400003)(54906003)(2906002)(336012)(36906005)(316002)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 08:27:56.0720
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 36163118-37e5-40f4-b30a-08d91f56ff5c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3167
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 May 2021 17:25:06 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.122 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.122-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    59 tests:	59 pass, 0 fail

Linux version:	5.4.122-rc1-gee309f4d1199
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
