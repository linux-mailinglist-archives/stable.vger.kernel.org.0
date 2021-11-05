Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D484444629D
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 12:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbhKEL0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 07:26:35 -0400
Received: from mail-mw2nam10on2063.outbound.protection.outlook.com ([40.107.94.63]:46112
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232115AbhKEL0f (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Nov 2021 07:26:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XOoIRY5EPXqQgEbTubZ7Azov+/bxHdwi4Ws1cdlVK08kW8KPS8k0Ks9pdVllhSz9WQ7q3NtRDP5qhJITBfF2hvcF9TXp6IHSjU+xcR4moMY6i46SnNgehix4nUUWvC1dt2G9oL/DvsrZaW2Wg74ohfJwZYAd8cwJBRDRTHTPvgIbxEfGmZ0SCbSmVtIYPTDEIMBFvKPrJyLQd+2JXdIG0MHEYYP8TadI6q2PMOwoQxtz3Fdi7dcNseTJgYtplL5CkFbZYBuqwGPSGkK/jJ4S1F0UMJ03aFLWl39mMIrvmcmu3r6RLt1ee5Zp1wvzfAQK2FPECMrYKGX6Uj3ysXqQqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E2xtk4co7ursdHqK1aqaLnszC+6D6C8aiDj8b9eVoyg=;
 b=QUC+Hv7L7k4i2w3+tPluzqHxMiOOsHYNAAiIslRTmhjZo6Ni+k6bp0I281jwiF2BkkxMgHS/tHBRowo1W+CXu5zf3ojmdfD3tWnqgBK3qWB0fQ0uuqB/vDtbli4xTXlHC0H77HI9KY6Q1uLRsHp+OIMquqfkgxTd8+kuR+EFzpd/FUpNaUYt8x9rFJdjnbjuHOee+uCk7WDscK4u4Fi7pT5h9OS7UW3GbEYmOkprQlgnPeRYoxPntL7t8fIXGK1N6f+9XQT4qWHWF1/3uFH0esQm4o3fo5LGqP9gCD4bSluvX3nzMQG1tcwgcAsmU42VGCLF8KEB/Wks44F4pS6b7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E2xtk4co7ursdHqK1aqaLnszC+6D6C8aiDj8b9eVoyg=;
 b=IZQA20e1veBk7AMtjRlUYBLATrYFuObezFixZFC6NASjy4ECimb0PcWCXc0u1bacA3/1ucV2cdrzWa1aWFqFfdhd1uEUrOxon7nRv9mGpiW1izID9/oYxMH90rORbZWVW2RjdQBGEIknlyVi0YsA1yqDbEo9J5NmWcym6wOSgy4aJ7S7u5DpIefMCyC/lhTgKA5dsGXKjR5R5xkygIBeT1GQ+35TN6sEga7MuIsdXtkxyZNbeS9x/XWk4va7zSQ4D21yrO+bYkld7nONBII9Pp96atkbw+1FOk0zO8e7mabpdJTj5nauW5ywbbigY2gCAC4xtlBTwZbrqIH8AOs96w==
Received: from MW4PR03CA0278.namprd03.prod.outlook.com (2603:10b6:303:b5::13)
 by DM8PR12MB5480.namprd12.prod.outlook.com (2603:10b6:8:24::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Fri, 5 Nov
 2021 11:23:53 +0000
Received: from CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::f2) by MW4PR03CA0278.outlook.office365.com
 (2603:10b6:303:b5::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend
 Transport; Fri, 5 Nov 2021 11:23:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT013.mail.protection.outlook.com (10.13.174.227) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4669.10 via Frontend Transport; Fri, 5 Nov 2021 11:23:52 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 5 Nov
 2021 11:23:52 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Fri, 5 Nov 2021 11:23:51 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.14 00/16] 5.14.17-rc1 review
In-Reply-To: <20211104141159.863820939@linuxfoundation.org>
References: <20211104141159.863820939@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <fa39e5ea54ee4bf9ba325bb6a5cf9eb4@HQMAIL105.nvidia.com>
Date:   Fri, 5 Nov 2021 11:23:51 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2943c083-4f08-424a-e7b3-08d9a04ebf7b
X-MS-TrafficTypeDiagnostic: DM8PR12MB5480:
X-Microsoft-Antispam-PRVS: <DM8PR12MB5480DCAF657FFB1649B8BDF3D98E9@DM8PR12MB5480.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gsfSqFlckmWERSwkSoHEZvw1XuFib+4mXqwaFGnPv8cnkpn4b8Ltc8iTGZB8RubiGHWIx5Lv5XQvB7rWgoJLCMa/JpqnU5iK+TbDMwt+UM/T8DMkG1gOLCAxUPEA9E7TXG0oG+mgkZ8flFT9rqw+IjMJu3mdNJbgLWhximv7hUGi3xnEhsnkpyRewMvmx6S7EEwQETSajiU814epa/axDc383vZXAdTnzG+lAahSRJK3jcYG+8f5stXDu1WEgy0dH2PL/3Y37JDVfzbfVtNmXTUchEq6vXR8KesAW0aFkuBQqBORQGpbkBcXYd8LEQmn0eXFE9ihe0xF/LJGG3ubXcEY4cjP570PgwcC8pusB/p9VzaAwDJi+9giV5eCGedV4sPDTR/ShAV5VN0O5AuKKHt13AS71E8Kql+Yh151S0JQhmtKZUGZBnC02BNkOXvXurUiHRtolq15tmYQERhttWBKqY3EgtM/R5CiFbjbNFjzjlekO0Oyr0df4eKSWoEFXdxMElrglEcMbrRr6dWYG5+svAzWx8/d2Nsb8rpWbBTDY4RpBorXhB73iowN4dW5LuOX7ejT2sHOZvLogSr6jVgvrGll7vnql105bmiSW2wflPYsAUh8byzV7BWd7cXiwX9ph6/c89KX88Ua7/iRzIlsa7+za7CLewBplp/QksiXXqAvXWe3r/BXf+Igu6rYSjUVqQFpAsq/7uyby+X+qcVcErTSji4+3mDRwQfz7GOYkNjpyDKv7dlb64VLkmmOYNkrg1FIGriDl3L7997Q07aczv+5kY2Yw2AlX7yhrwg=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(2906002)(6916009)(186003)(26005)(7416002)(8936002)(4326008)(70206006)(108616005)(24736004)(70586007)(86362001)(82310400003)(426003)(316002)(54906003)(7636003)(8676002)(356005)(336012)(47076005)(508600001)(966005)(5660300002)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2021 11:23:52.8908
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2943c083-4f08-424a-e7b3-08d9a04ebf7b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5480
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 04 Nov 2021 15:12:31 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.17 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Nov 2021 14:11:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.14:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    114 tests:	114 pass, 0 fail

Linux version:	5.14.17-rc1-g05ed8d6b833a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
