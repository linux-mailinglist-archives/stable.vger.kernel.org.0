Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B84A4142DC
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 09:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbhIVHrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 03:47:47 -0400
Received: from mail-dm6nam11on2084.outbound.protection.outlook.com ([40.107.223.84]:4707
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233283AbhIVHrr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 03:47:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d69leNaH20M8GxJuaKoxaQ2ADEn8ld5iih0IFItiQRwxs2fPYjKAWcwgpSRTUgJ0BAldeZvK+orypaFhdzzWr+X8cE4Dt1m/3nNwZ9zMb8fYyvh7Ty+HTuXeOm6LfundgVvs+nxffFTikZk7rZRYYkvWWVViPO/i3iMMCcH8EApC7v6Rso/ZVoaIF0n9/8sY+FnkrTDUhinFkhDvoOeH9BrzPE2JHPle6TuniYBiyAhI654fQ/uB5a6ow+/bFAxDKikG/JxcwtAyksE09ziZaPNaCxKMrW0lto783RrPk1/7vQMs9jdcvx91TpZ0g1PoD3684cKvwQscc4ZrXj6RRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=nlTFxdcjgdWWLkIuQoUBEtYhHkPIqiVxMaio+ouY2YU=;
 b=BHY8tNGMRbse7VRzHwQolCjpt0zdMDeYDrVLWUmzSyA5Q5H1exOfCtEf3xKYJvDayBjwftWCNySYuQ22HigwOP3Z/Fw4zQi9LB/Twk8ed49VAwTI5XYbyxLAtu1Xe8wvCTCTTfOQ1Mjbs3OW63ryRcPYEKxcQho7wGPjmSW23RpsiF/F6vR9AgWaR2EQtPGLz2ODiNJsDzX9mB3hU4vtiPjcYYjvfl0tbqmUhVGMHmeRUZrYGcIS+TqSduQ8r20go9CJHVCKl2RePT1Oelt+a7ZeIPvmo8ZerK8RJevBoh1ASOeGI3ITOgpv0G5kBAdx+voXhnjrjubsHRIMCaHjWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nlTFxdcjgdWWLkIuQoUBEtYhHkPIqiVxMaio+ouY2YU=;
 b=dismCeEoQrZTs5RusF79ZFhszRyIn5P1jUZG0h5KSgpqhBdQL3523hUp8sF5L1H9YwHaZBLwfWoTHdUxEz+ewCeI7i24L8ggAW6j68q4TgRBqCkiHqIMAuw1/TBKVUOCp/t/YRPFD9RCu9HwTMMzRzUggkbXBVaVKlcEtCrCdke6uYrC7PB2vGoqzSUJ/FTa0DqE9hMSOUjdLrlIjCWW15L1mEhoGNBLEDrlDCBFn0pRZwvT4XUlhp3s85PPfJiP6cfsXpqHQcL3zgFVjnShe+c2wchyswaxSz5MkX8xWTSzU7suMDjG8Qlb+2eCWDTCsNWv+b01PetXmghWqugiDw==
Received: from MW4PR03CA0289.namprd03.prod.outlook.com (2603:10b6:303:b5::24)
 by SN6PR12MB4717.namprd12.prod.outlook.com (2603:10b6:805:e2::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.17; Wed, 22 Sep
 2021 07:46:15 +0000
Received: from CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::6d) by MW4PR03CA0289.outlook.office365.com
 (2603:10b6:303:b5::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend
 Transport; Wed, 22 Sep 2021 07:46:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT049.mail.protection.outlook.com (10.13.175.50) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 07:46:14 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 22 Sep
 2021 07:46:14 +0000
Received: from localhost (172.20.187.5) by DRHQMAIL107.nvidia.com (10.27.9.16)
 with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 22 Sep 2021 07:46:13
 +0000
Date:   Wed, 22 Sep 2021 10:46:10 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     <linux-rdma@vger.kernel.org>, <stable@vger.kernel.org>,
        <syzbot+6bb0528b13611047209c@syzkaller.appspotmail.com>
Subject: Re: [PATCH] RDMA/cma: Do not change route.addr.src_addr.ss_family
Message-ID: <YUrfQpuFlX4Uk0L1@unreal>
References: <0-v1-9fbb33f5e201+2a-cma_listen_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0-v1-9fbb33f5e201+2a-cma_listen_jgg@nvidia.com>
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d0ef722-39ad-4471-228e-08d97d9d0e1e
X-MS-TrafficTypeDiagnostic: SN6PR12MB4717:
X-Microsoft-Antispam-PRVS: <SN6PR12MB4717D727603D4C491E372D90BDA29@SN6PR12MB4717.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eR9jkvGe2TJ9yOoEEgX0MhMnk181OLAwLCbqPDH6r+FuGqt9+xyrS7SJGfMXIyupZnX8+7o0LmIWrOM4Wi9/GL26beTPCUiHPmZy6GvTE4Yi94yrv0N5pLxsURY3PidXGQxn9I/QKLt3nHHC6Phzd3pklMe4SPU8domL5XdWoaZx73NJNsji2LtFi5pz0kRbDDipCqTXF4l5Ak4vwmValAPWM4N+Lk3yGqVkA81gJgOHDg6WJeAb/DFFk3UknOrl59rXW2O/6r6qLKOITO4ZjGEyWWiHWyqTy9hATfs7B4P2RhOi4N3Wb8ggBaEf5JFBrUIAm2z5a52/0Z6wc9QGbr1qAywQcITNI5OYqaUystbI+7a+4RbIy1V8QahrK5F54wRx7dqDU19rhPoKhYUUrI+ZwM5kBBhWjnMeEefw7p3lf05eP9rdD/DgHVR/SjKYi78USBcOxvYQJXaNIuEuCrIgKKE8KN3anKthztCHlRs0pD9MUDXuTIlGYPPRj/ifs6MFtqQwnyKHP0UmABxxcmsdwlwUHocTJg3ScvhxeAOAZfisVOeY4lUiNxS9cdXNFNuyzLqszltG2ysP8N883aGNpDtFcFR1QV8XzltD0jihfCXeeL6tfyUPBXmw+2k4S9SML6+Rt0YuWN6nVwow8OnChRJ9KUnXnVFT2J44wW5560JdwIXmcph/2xBQY7jhXaoP5AhvC/BbEw4njScpwA==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(7916004)(4636009)(46966006)(36840700001)(2906002)(86362001)(54906003)(508600001)(9686003)(6636002)(16526019)(70586007)(8676002)(336012)(36860700001)(33716001)(6862004)(186003)(26005)(70206006)(7636003)(8936002)(47076005)(5660300002)(316002)(36906005)(4326008)(83380400001)(426003)(82310400003)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 07:46:14.8629
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d0ef722-39ad-4471-228e-08d97d9d0e1e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4717
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 15, 2021 at 05:21:43PM -0300, Jason Gunthorpe wrote:
> If the state is not idle then rdma_bind_addr() will immediately fail and
> no change to global state should happen.
> 
> For instance if the state is already RDMA_CM_LISTEN then this will corrupt
> the src_addr and would cause the test in cma_cancel_operation():
> 
> 		if (cma_any_addr(cma_src_addr(id_priv)) && !id_priv->cma_dev)
> 
> To view a mangled src_addr, eg with a IPv6 loopback address but an IPv4
> family, failing the test.
> 
> This would manifest as this trace from syzkaller:
> 
>   BUG: KASAN: use-after-free in __list_add_valid+0x93/0xa0 lib/list_debug.c:26
>   Read of size 8 at addr ffff8881546491e0 by task syz-executor.1/32204
> 
>   CPU: 1 PID: 32204 Comm: syz-executor.1 Not tainted 5.12.0-rc8-syzkaller #0
>   Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>   Call Trace:
>    __dump_stack lib/dump_stack.c:79 [inline]
>    dump_stack+0x141/0x1d7 lib/dump_stack.c:120
>    print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:232
>    __kasan_report mm/kasan/report.c:399 [inline]
>    kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:416
>    __list_add_valid+0x93/0xa0 lib/list_debug.c:26
>    __list_add include/linux/list.h:67 [inline]
>    list_add_tail include/linux/list.h:100 [inline]
>    cma_listen_on_all drivers/infiniband/core/cma.c:2557 [inline]
>    rdma_listen+0x787/0xe00 drivers/infiniband/core/cma.c:3751
>    ucma_listen+0x16a/0x210 drivers/infiniband/core/ucma.c:1102
>    ucma_write+0x259/0x350 drivers/infiniband/core/ucma.c:1732
>    vfs_write+0x28e/0xa30 fs/read_write.c:603
>    ksys_write+0x1ee/0x250 fs/read_write.c:658
>    do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Which is likely indicating that an rdma_id_private was destroyed without
> doing cma_cancel_listens().
> 
> Instead of trying to re-use the src_addr memory to indirectly create an
> any address build one explicitly on the stack and bind to that as any
> other normal flow would do.
> 
> Cc: stable@vger.kernel.org
> Fixes: 732d41c545bb ("RDMA/cma: Make the locking for automatic state transition more clear")
> Reported-by: syzbot+6bb0528b13611047209c@syzkaller.appspotmail.com
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/infiniband/core/cma.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
