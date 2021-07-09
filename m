Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16AA23C280F
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 19:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbhGIROK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 13:14:10 -0400
Received: from mail-dm6nam10on2069.outbound.protection.outlook.com ([40.107.93.69]:12032
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229459AbhGIROJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 13:14:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ipR/3qGvKvmnV7cxAyXwQ4dXy3ZhIzn3qSAmUF9YG7oBMacQnsnNdXYbV57ASeBVGTJkfv6oskUcl3WKBmFdX12K722hN0c9RJ9E2ggFcqlfzEBt5BPFBSTZrtReKWDWC1BUTqlvfP8S1VSyPFil7tc1Jmh7rK5CIQvOSKcPRc/tXPlSuvnzm/lFxsC3LjU0wCUOtNVx4t0aDu5BgCBSicnTCMPIQ1l++gMi2VNZNks6lJVV+pGsD+zV93KNN2Lw1K2RxdRAe5tuC7k2Rx1WVjht3lhD7TQ2sPzm9DPxjBSNRxiiS4bFXlqTGwbTOVVBsSS0G/NCUUPLyBmXyekJnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NNKVNKafanOyTrtC4QQaPeHwn+mxUggQwipmuNjLOPU=;
 b=H+skMKgkl7gNmmAKgzXoGEcQJdwIY8k7AHGVgKLeAs5xE9rXd3VejLeIUOxTgj7Z9P/bf+9FAEcqogGoKX4dkRS5BiVMqAfqBn+gTGxRgfaHw/NxWmHk5wMSc0PjQknzkdGV+iLZ7WOM6U6COV/FMnhheJxe/u3Drxx4HaBsmt77dsvqBgHAnPrHw3djhg+W7QMNRtNmvJDFLTc4LnYlLLeIsgc4cVhZyQ7KzpemRIYZvV1krGsi6CXnCMlT8D8PP4lmcLvQlKl8gq8FugrHjIzaP59ZZF3tnKl9F/73sPeROUurit5l2mjppmbE1JHwKyjeF9xejMfyaCtpnhFNgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NNKVNKafanOyTrtC4QQaPeHwn+mxUggQwipmuNjLOPU=;
 b=FdJbX0ZJVN8XFkjXIvG/IxXsbHu9Y17kLDVM2QUL8rZ6f+ghqeXticKhLzewZDm98Fm1SVB0Chq63BvmnaAKnIE/9Vpagya5SpqnFmzdM1lo/SO8abJ2NVrbOIR+hipx0jVdG3qKV/rkGPfm/sDX46dz5W9xO/CR6t1RdQl3b6YFCji8jHLzg4TsOft4JIjHWJKhxpJzfvEsO38IFVBpezYmXYTYREVAlIcAEfQV9HBPhkDMdvEqZ6hh1FESevWswBmVdNdQ7IpEeVrlxj/9fWXdiXd+DpBk48yzfkohKmiNr1xHPzK/IOsHYpp1XCx5DLHQysgNe8eUAi1jGG6Erg==
Received: from MWHPR21CA0035.namprd21.prod.outlook.com (2603:10b6:300:129::21)
 by CH2PR12MB5561.namprd12.prod.outlook.com (2603:10b6:610:69::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.24; Fri, 9 Jul
 2021 17:11:24 +0000
Received: from CO1NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:129:cafe::be) by MWHPR21CA0035.outlook.office365.com
 (2603:10b6:300:129::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.1 via Frontend
 Transport; Fri, 9 Jul 2021 17:11:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT023.mail.protection.outlook.com (10.13.175.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Fri, 9 Jul 2021 17:11:24 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Jul
 2021 17:11:23 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Jul
 2021 17:11:23 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Jul 2021 17:11:23 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 0/9] 4.9.275-rc1 review
In-Reply-To: <20210709131542.410636747@linuxfoundation.org>
References: <20210709131542.410636747@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Message-ID: <e30a4dab9c4a433b92b6636f94b32adb@HQMAIL111.nvidia.com>
Date:   Fri, 9 Jul 2021 17:11:23 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 489589df-d2de-465a-89dd-08d942fc94c6
X-MS-TrafficTypeDiagnostic: CH2PR12MB5561:
X-Microsoft-Antispam-PRVS: <CH2PR12MB55612FB5D8F2F25A83989D33D9189@CH2PR12MB5561.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bK3z06PJ3l8hQmMMiHo3IQZIwJZXR5gVqGdvN1Izp/bb03Z4B/xg1xwZQ4dtGRL9JgjXmnsx6GSgrYtIlcA0aTA3s5QJ+rc85fxb5uU/krn45bjCpp9YprDyPKejhPf4ewPYXKDvEsO5/tNoXzvnbMUTgutOkgHHIG4U+aAfFK6t0D/qgbGYWVUQ9o90t5jImyDI4sTFEuFskNsZeGQwQL2fLbZY4n32cdvi2txYSju6bRBEwElooOmOvMEdbBk3gd0npTyP4V2uhnCQafEzi2ULFquzrgMLFBZqFCxwtmnn5qVatiuC55UBoQrMHTyuG+jTptj/ieqd/R4AHrjWpwF07Px1N4FGVE8S/W5vgYP3Y1E8WpyVp2BN5k3QPP2diXCyKloS6eBYiX0nu2X+Fl6pNZkQixWbmwP4EFooBruBQjOrOqGRX4cuqf7lNBJRAod1IOknqOt1rUB6/utcIE4G+T5Uq7OYNp8wBCiQ1IP4OYz+FUQSkUrpSk2hUuxJntF21yr2l6zQyoTZKAremolhsrW7h+3i5bq13cDjHLCrghU1/aWyYkhCEmzMQpU9LgwsHOxe7vtVom0VkPB2GW+cUx8jzxFvnfeFdCJBYRolHo0lVJZQxboxo7qa8mTY5fGq/5Q07dRuiIqtKugzHMVFNYwz5RJj9OBO7ErTxA6/U2cxUCV5y+NGO0VfPoy0XZPJgdFQwxKcv/oTwOVKsQCdugPCeVsdNfePwpmSPxPA4MxCGiWHGg1jr5sc04C0X12du4hX/qzsahAAqNHIY06amVVlFU9SZqOj2TfenptkUF3BjTCesksAHulxYwx2
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(136003)(376002)(46966006)(36840700001)(2906002)(47076005)(82740400003)(966005)(356005)(24736004)(4326008)(8936002)(70206006)(7636003)(426003)(36860700001)(5660300002)(83380400001)(26005)(108616005)(8676002)(7416002)(82310400003)(54906003)(66574015)(336012)(478600001)(316002)(86362001)(34070700002)(6916009)(186003)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 17:11:24.3717
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 489589df-d2de-465a-89dd-08d942fc94c6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5561
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 09 Jul 2021 15:18:27 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.275 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.275-r=
c1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git l=
inux-4.9.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h
>=20
> -------------
> Pseudo-Shortlog of commits:
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 4.9.275-rc1
>=20
> Juergen Gross <jgross@suse.com>
>     xen/events: reset active flag for lateeoi events later
>=20
> Petr Mladek <pmladek@suse.com>
>     kthread: prevent deadlock when kthread_mod_delayed_work() races with kt=
hread_cancel_delayed_work_sync()
>=20
> Petr Mladek <pmladek@suse.com>
>     kthread_worker: split code for canceling the delayed work timer
>=20
> Christian K=C3=B6nig <christian.koenig@amd.com>
>     drm/nouveau: fix dma_address check for CPU/GPU sync
>=20
> ManYi Li <limanyi@uniontech.com>
>     scsi: sr: Return appropriate error code when disk is ejected
>=20
> Hugh Dickins <hughd@google.com>
>     mm, futex: fix shared futex pgoff on shmem huge page
>=20
> Yang Shi <shy828301@gmail.com>
>     mm: thp: replace DEBUG_VM BUG with VM_WARN when unmap fails for split
>=20
> Alex Shi <alex.shi@linux.alibaba.com>
>     mm: add VM_WARN_ON_ONCE_PAGE() macro
>=20
> Michal Hocko <mhocko@kernel.org>
>     include/linux/mmdebug.h: make VM_WARN* non-rvals
>=20
>=20
> -------------
>=20
> Diffstat:
>=20
>  Makefile                             |  4 +-
>  drivers/gpu/drm/nouveau/nouveau_bo.c |  4 +-
>  drivers/scsi/sr.c                    |  2 +
>  drivers/xen/events/events_base.c     | 23 +++++++++--
>  include/linux/hugetlb.h              | 15 -------
>  include/linux/mmdebug.h              | 21 ++++++++--
>  include/linux/pagemap.h              | 13 +++---
>  kernel/futex.c                       |  2 +-
>  kernel/kthread.c                     | 77 ++++++++++++++++++++++++--------=
----
>  mm/huge_memory.c                     | 29 +++++---------
>  mm/hugetlb.c                         |  5 +--
>  11 files changed, 112 insertions(+), 83 deletions(-)
>=20
>=20
>=20

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.9.275-rc1-g972f4299f6ca
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
