Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC3D40F4AA
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 11:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239350AbhIQJW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 05:22:29 -0400
Received: from mail-mw2nam10on2083.outbound.protection.outlook.com ([40.107.94.83]:28027
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245564AbhIQJUc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Sep 2021 05:20:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mn5TtWbsHdHHal7Dev1OihRtMgwACaffcqBCLpqdiyNG44d/vybI8riiBFhqBJ062EuBmLZPUM83Pydk/PaQQgI/87/e11T6kf3Hc6MTyHrdA98uN9FsyMOsa/7QZqQss+4AalOqrVjal5Iviw5Lq5vCheEpMYp0xF5i7GtQij830eRee7WHCwfo3/YHYaqgSbrHhtuD0rMjQNHNHMkCmwGUr0byYxDc9FcP4o2k7PPfxZYtEQ7/WGXwNHrzWdbny8IippxFT7OHZLt42YFL+sOUypOCC07ZbJZ49EetD+6nlbiT1NQhpcruMTHn6bXkvxEh56AqnpVKwDO8GN42xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=F3MuyfTi9HDYEPbGvk7aZfnmL5wIS7yolNuAv9ZFXVU=;
 b=jbzADuMCnzjMM9WDpLIIm42ldoh91+zHA22ejW/T2FmdMUJtz7R2s8GVW4xaQnNXrVdt5tc5VHwV+v8UZJrwQnbGDrRfJmOb0Rv3KWRMvTVZt9qhiQMvDI1blFulkUlZSUHBdDTMOt+p+FC3ZdO2KTsiQDF0EKy9NYNv54P7P233eC6qEnnC+D1F3Jx74uqp8sv+RSSPQvcnEfC2Z9rgCTA7dIYk8yiE6KEFLZCJqbgs8FVuSk1NzmqaH5ovFHX7uHov5AWzd3zc1Gf9YU+GSDDFQCzWuhvbzLX0y7Td1FUOMW4ZUOLP5jZdOGaWfHValvPSkB/LWA2MyRXLwtHJrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F3MuyfTi9HDYEPbGvk7aZfnmL5wIS7yolNuAv9ZFXVU=;
 b=W8Zdf41IuYGCwrTmbupTOdjzwusAa+paAzSSRuuHVsNnDs/lMhaUjudoKviPAbGxh2FoSbFk244EzUne7wEyPHUF/fEzCfsRe4xp/CdWTf02f9kjrW7pvFyQlVTvbBe1XVenJEWShDokXHAvdKivlHK/1j50su1OQbObi8L6EOjxuvZmsvlFFKD6X2sI7+QO0Sg85G6emvOjsNnuEJJkP46XTXUYA2I9lnPGWVm+QVjqqIMwXhlUCi+NhF9v9VyQw1TV6hFOe0I3+/k/LshqlV1xxktuVHrxyU22QNnhURUgcwN4qA44oPIhP8+u554fh/vW7hXGShVDGzP5M8RpHA==
Received: from MWHPR21CA0035.namprd21.prod.outlook.com (2603:10b6:300:129::21)
 by BL1PR12MB5189.namprd12.prod.outlook.com (2603:10b6:208:308::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.21; Fri, 17 Sep
 2021 09:19:02 +0000
Received: from CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:129:cafe::ed) by MWHPR21CA0035.outlook.office365.com
 (2603:10b6:300:129::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.1 via Frontend
 Transport; Fri, 17 Sep 2021 09:19:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT054.mail.protection.outlook.com (10.13.174.70) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4523.14 via Frontend Transport; Fri, 17 Sep 2021 09:19:01 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 17 Sep
 2021 09:19:00 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Fri, 17 Sep 2021 09:19:00 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.13 000/380] 5.13.19-rc1 review
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <0e6e80aaf3ed482493c4e25eeefb0347@HQMAIL107.nvidia.com>
Date:   Fri, 17 Sep 2021 09:19:00 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d0d0c70-c6e2-4731-f61b-08d979bc2feb
X-MS-TrafficTypeDiagnostic: BL1PR12MB5189:
X-Microsoft-Antispam-PRVS: <BL1PR12MB51892521AB647CF49C3062B4D9DD9@BL1PR12MB5189.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wnB2WbC/6lGptwYnE5Rb4MdsBgK1acqQUpP174kE36D3ejrHGaZ9jLH/R0TdFlNxtZXATjhdsTRbqBWwBK4114igoGvTB1uAINAUZvE/7jFXDOfziK6W1IR2EOo2MkH0zsYjV9oOvd5kmb6nctEY2lsh+WtdYBlzm8PlNBk9+Mk/I3erP5PvF9gxpNDKqgDO2/eA8oVyn7mA8ScK7qY6rapnYtG0W2HEYAjKatXZb9hkCwB/U3W9959L795bHIoTC9OO/jK6v4Io3joPKIpwIXcamTEkO3LdkQVdDm+rll0pZE2Mp9loR7HHBvJgFBj1MdryCiImUWNIgy1GE211H0DQhhmjXyCCorSiUOWEquHRKn2XfUd5fuPEghD0rU7ciCgvkMR5fG14cwlaKs3+LUYiIA0SaBpLBEUUX0PvE8rhA55EtH0FhmaJYjBjmuJhaV/EQTpdb/QjNqDkpltFgYeJ5ridhuCLH3m0kT45sJOqqhrCeQDVVw5UBEGZCnl6buvtigdkG35F221pj9M05EsdFKPNt8i1MnrIQxcM0y4BqhxlHJabh147MN2xM8JKQsWozuJIv0u7p9pqG7OcU6p+dRnp7/JnfAUWDlzbfOqgM3UKRxWyMgFhKZYYY78LF4I7CfHMfDzhPAj+csKqcf058MEhKkr7xvj+lmLVq87IVGcKb3ra+TEsEwtowXexth50qTTdCimV2lIFb5PyD/YsKXIIc4zronEt+YkpZgv7/pKLZbDsfR6saB0NoONrJqfDWw+dlTv5PTo3mnMUtvNNzHIe9tv7PktCtBZH69I=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(396003)(376002)(46966006)(36840700001)(5660300002)(336012)(82740400003)(47076005)(186003)(478600001)(8676002)(54906003)(4326008)(82310400003)(426003)(26005)(356005)(966005)(7416002)(70206006)(2906002)(24736004)(86362001)(7636003)(36906005)(8936002)(70586007)(108616005)(316002)(36860700001)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 09:19:01.3392
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d0d0c70-c6e2-4731-f61b-08d979bc2feb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5189
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 16 Sep 2021 17:55:57 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.19 release.
> There are 380 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Sep 2021 15:57:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.13:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    110 tests:	110 pass, 0 fail

Linux version:	5.13.19-rc1-gd32cd39db441
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
