Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728573C2815
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 19:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhGIROM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 13:14:12 -0400
Received: from mail-mw2nam08on2041.outbound.protection.outlook.com ([40.107.101.41]:25506
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229618AbhGIROL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 13:14:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MyHsXZZJr8B8ypmvIOiWi5bvXFYUNMh1R9W0NU1HKXJG7Dqeebx+rNmGlfK5UoxFrcx/zQM5B12RYacWkubFwxDUkDEb+XVjS3qLYcIlP98ZN1AzcJOvod0PK1pVh9j7ffzdnVqEwwlWsJb1rKEsSw6zfOXv0wxOjDmV2IKdZV9oRwy+YXF4WHT0ypgDhwmUBja9OUUFTZKeKAgkM4t17pQeV6kx6Q3L5xDRgdYYOekVG74d6lXrXhaaI41ZO4NErrfaOtCjHUYZeg3Bh8zJlfBs+eQiIutptT8scAVz8Da0padm5DrSqbtTn8wRl5b6U/as8YA+JpUgFpkZjc6SjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HRfMDayjjPeeChmyWwpjwzgHlJcaa62VSJQtCDibwsk=;
 b=c5EX083KvNGcnGJ3FoWLPccREpx26SWH3fEFhsI0kGQCfd1X/sni2Qh5KVxKvPx4R5kr9WOtY3d3DXKSLrwPGz2/bcJHAK6kAkfXyN/yIyzQ0VagjX3pjc5ISn0FLZt3g3WHR3Su87Y6vIQKf9c67n2CpU9mV+j/0keEwpFiiUa+x17zSxBhHZBU/9icY5FLa48CoFUk/TAMkyrM/fWilqYdQrpCLBo/CN/1AALmYtcxC0tuY208+UevueX6dZdkZ0YiTYexNdZElv/mRWyp2EQ1Gj0aefStl4kfgkpfVOkx8O6J43JHFLGUENI5DaUv0axNyjBEJ+9aQ5hB5kl6GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HRfMDayjjPeeChmyWwpjwzgHlJcaa62VSJQtCDibwsk=;
 b=Q+xWWRGaEJOXniZOEB9UB0BcOIT6Mdub9lnwif7s/xkhV/MrmoimnixH6Q1AAYt7LuTcZaXUatqds7Rit6rkisfjkcp6rNVuVAnk6+uG/ARAZT1Euir6jTOKvN4q3WArXTqZoBJrbqyIBAUbQVwWCIjls7p3dtcN7LJpIVuy2+yKiYFU9xKGhj39Hl0hEgbeGjtHm/i4D7BbVWCMBaa6RwfCvzzGic/OpnstonwApt2ffI/trtI0B65JWSiAbPcIHKIbBAcR2u72KZCasGd1+xZs1XHT8vwga7HJFYNCiMOgeDi8MM+BIBN5HtI/1C6JMDi2fPVpoVP1wBEVBXROlg==
Received: from CO1PR15CA0102.namprd15.prod.outlook.com (2603:10b6:101:21::22)
 by DM6PR12MB5550.namprd12.prod.outlook.com (2603:10b6:5:1b6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19; Fri, 9 Jul
 2021 17:11:27 +0000
Received: from CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:21:cafe::e2) by CO1PR15CA0102.outlook.office365.com
 (2603:10b6:101:21::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend
 Transport; Fri, 9 Jul 2021 17:11:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT030.mail.protection.outlook.com (10.13.174.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Fri, 9 Jul 2021 17:11:26 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Jul
 2021 17:11:25 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Jul 2021 17:11:25 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 0/4] 4.4.275-rc1 review
In-Reply-To: <20210709131529.395072769@linuxfoundation.org>
References: <20210709131529.395072769@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Message-ID: <5fd4cd436e68418e8001e9b7bc01cc9f@HQMAIL111.nvidia.com>
Date:   Fri, 9 Jul 2021 17:11:25 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 70428915-1bbc-458c-64a1-08d942fc9622
X-MS-TrafficTypeDiagnostic: DM6PR12MB5550:
X-Microsoft-Antispam-PRVS: <DM6PR12MB555070F7C5B9E9B644E73EC6D9189@DM6PR12MB5550.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TQdv15uKdzYOXkRZH6SAHHwFZCzHvw7NKpD4wGb1NZ88Ybi8t2xmnIgFOA9dZSxit+UOo4fMzG4UCI6hS0WD2NGsdTkNPLOpnhVzlwEokbw3+Y2NQ+ArMbhbx4cXQUYGAwMXDbZixPbMjDbxMo+fg7v4+WZ4di5m4lnlWYn42wifDuTP5qC9nySM3RXWXKRQxJU02C5RGDO7S50Hs2TJ+UTf0xh3mYoGnKaSIuZhz7Lm67uyIVYl14+y/kkVVbls9t67U6ElO69qIl8RCiJqUXruJe0GUxuPG93Ob08q7sDGOQX1AlM2KcVlsWTrBB+nDAE4G5EIJLliHArRuXQF/LeoBHVVxE8OdoX3zaVBqsGiTG1cNLEzWE37iokvVn0Cv68NF4UP0OXASPlTAuTjkPG91zMswymlPQ3wElztliYO+E+Jg4nDtVFMu5dguIUM6bI+RfNUjUK332kkVeHorPu1TezcEqt4rHyAyDXmDpTYOiMbZW81KNaTczRIKXeFzjZt3L9/vKcI8iYzv3hGSc16MQOBayfHXyAg6+Ghy0eEs6u19OgQllVYt+Es579eiLZOONTmu+9zxUKkaYsFvV2iy+YvaCfFiunc6a9wvihZQEPsZDtxvc1jz+tuA+jcmKiy29FtYkpeGiFRGPeWD0We5mDQ1SCTehHWHGbFqygo0GJGITZ4ejoGazCaFBODfLYxl3VlnyS4QBcjfLQEy+FFdNr+Ze9boQJ38FJvEVcAllPSrZ9geWqV7dFMqAiGnGMhsw91mK0H12LOBs5fqm9L31LOas6B5iPZklgLGHkGlJI8TOfEZYzbXycF/L57
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(396003)(346002)(36840700001)(46966006)(47076005)(316002)(82310400003)(36860700001)(478600001)(70586007)(186003)(66574015)(83380400001)(54906003)(336012)(2906002)(7636003)(8676002)(82740400003)(966005)(426003)(356005)(70206006)(24736004)(108616005)(26005)(4326008)(5660300002)(7416002)(6916009)(86362001)(34070700002)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 17:11:26.6604
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 70428915-1bbc-458c-64a1-08d942fc9622
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5550
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 09 Jul 2021 15:18:12 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.275 release.
> There are 4 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.275-r=
c1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git l=
inux-4.4.y
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
>     Linux 4.4.275-rc1
>=20
> Masami Hiramatsu <mhiramat@kernel.org>
>     arm: kprobes: Allow to handle reentered kprobe on single-stepping
>=20
> Juergen Gross <jgross@suse.com>
>     xen/events: reset active flag for lateeoi events later
>=20
> Christian K=C3=B6nig <christian.koenig@amd.com>
>     drm/nouveau: fix dma_address check for CPU/GPU sync
>=20
> ManYi Li <limanyi@uniontech.com>
>     scsi: sr: Return appropriate error code when disk is ejected
>=20
>=20
> -------------
>=20
> Diffstat:
>=20
>  Makefile                             |  4 ++--
>  arch/arm/probes/kprobes/core.c       |  6 ++++++
>  drivers/gpu/drm/nouveau/nouveau_bo.c |  4 ++--
>  drivers/scsi/sr.c                    |  2 ++
>  drivers/xen/events/events_base.c     | 23 +++++++++++++++++++----
>  5 files changed, 31 insertions(+), 8 deletions(-)
>=20
>=20
>=20

All tests passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.4.275-rc1-gaaf5d64b8bc0
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
