Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69FE441665C
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 22:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243037AbhIWUIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Sep 2021 16:08:52 -0400
Received: from mail-dm6nam08on2049.outbound.protection.outlook.com ([40.107.102.49]:18697
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229932AbhIWUIv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Sep 2021 16:08:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cDv6MVHETef+1zuZmAnX7/HlRUAkFseQdNYBkNZyE75D5lrGG1lDK0+MgjzefJhJdEplXzo/bU4zya6ijJLZgn5fK39hPWu6HuUwuH/OoOOu3GI78304pRORui21brtX4eus1GCLvisoddprOChoo9H248fvaG8mgd2ZdLZZohVAzxKdnIP4rEQ056Sme7Kry1vtz6cMMa+X6d2miXuf0hvyRK9brtL9RbD/JyxfojC/+EdlBL5q2r5ajYHpUNuyotmRxKUojF9eFdupvZm4LDwiUwH6wWHjk6FWCOm6uN2UkqP9dQyFCu2aXIhSJ2p3cabDKZjMz8eG0TxMNz0tug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=mgDHWsSx8wDmUzOlCN74lFtSDO/aY5xYQK4a/ZmYZ+k=;
 b=NeTqLiB8+1e8rs83LBlVoNntapMQCsg6rSxmtWmlzzdB9G6Fn4/bfUQAgpuhjiQwNy3qQsJqScckedqfOj31O3fED9XiakAOd7WvHR3gClLuplVRAFFOKorhqVC5rMUeRZH32M7cFupmOEYQbwTWcsoF9rHZerXbJ2w9fKZYrNKsSJRiNbZXx/MVHi0LwMLGFBuqLN8zzej7Pz/Gqgl3jI37ADmyJCI/fNru8EflE4LRU8sXMIGgRif2zDez+yo/bOWC/xboC+aXHZbDNA1MmkDc+BTUubow82vEm8rxXY/d6qpf50jzkdrJiuT6Bcl1wY9RhxJJ8t8kKfd0gvnPNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mgDHWsSx8wDmUzOlCN74lFtSDO/aY5xYQK4a/ZmYZ+k=;
 b=ZBx0vrNcIE0xLS6wcemO58H4a5Xf8jo9OGtldxF64Gp835hfrJG7broZUShMbkcduX4RFvg4sjnZ40WdAlXiXaE1/oqwuGkVf9p3r+fFNsydl8wSgN1UlaC5v/y33SOf8bEDUxObP/YgUUDw507UacfhWaKPUZuPSZm8eON9KNa0zZJJOVFeAjxUfJ3a6SBKI2bn6RCxROWI0bxtF1A7+TpqQpjnbCRfLK9pXWn/PdRNJCaVKP0kF1gZUpG9f4lHrAc35vOjRW5iEbnZxNVXTm2zxfQpP+MRsI9kDauy5XZbsTFZMUwSDTN1mlhnl8SpjQxzqaYrZ1elO+8vMZsY4A==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5126.namprd12.prod.outlook.com (2603:10b6:208:312::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Thu, 23 Sep
 2021 20:07:18 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.015; Thu, 23 Sep 2021
 20:07:18 +0000
Date:   Thu, 23 Sep 2021 17:07:16 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     linux-rdma@vger.kernel.org
Cc:     Leon Romanovsky <leonro@nvidia.com>, stable@vger.kernel.org,
        syzbot+6bb0528b13611047209c@syzkaller.appspotmail.com
Subject: Re: [PATCH] RDMA/cma: Do not change route.addr.src_addr.ss_family
Message-ID: <20210923200716.GA1080044@nvidia.com>
References: <0-v1-9fbb33f5e201+2a-cma_listen_jgg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-9fbb33f5e201+2a-cma_listen_jgg@nvidia.com>
X-ClientProxiedBy: MN2PR16CA0019.namprd16.prod.outlook.com
 (2603:10b6:208:134::32) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR16CA0019.namprd16.prod.outlook.com (2603:10b6:208:134::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Thu, 23 Sep 2021 20:07:18 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mTV00-004Wyr-U8; Thu, 23 Sep 2021 17:07:16 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1638eb2c-dd1d-4110-db4a-08d97ecdbe9e
X-MS-TrafficTypeDiagnostic: BL1PR12MB5126:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB512615BF0D94B250CC123B34C2A39@BL1PR12MB5126.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N8Xz3HzRo5PO0Qu6cOIdRHUoCmb4FPEEO+GlOzJL1GAZy44gq6n5LdCEdvZ6Ruj9MBzp+igJDwENLLMuFpLCe+QOXaPiw0GlGPHV6Jj3YipJhO/5Y8jYWNnfUjrJzFZRO1FalZMuapGSLk0O3Xv55h/nPr//hrAsmGy7MGfmBeCNMVhkg1sc0y8PD78mg29vRrYTOrfxtXIlWr4i6+PoHV0NFmZyzZ39RCaOToSvPsjqR86+22pl8lAX4o0/8OWXQwHcxBKjEgOBU3LRTPIHjcog149dOIyIxbGx7IYHj6uFGx1/g8fAQA+HNdHNUlLetOBp2hfB/S8UD++A4kM4BA5RTqvpWhkRyi0lx6Og2cmWkJJY7QgLBAQVQ9QEL2bNojp07YV/3KYScuvIitgNTWJLcY0OkvSJyNZE6vs78TBn5/kuTUskNRAJ4JTdlmmTKIAjzsD3yYW6HlBXcHiZAw2MdAxxhp3Nnbn4Vovh11XWj0K9dO5KU3z/k+za8PC0ONZ5AbNPcvUcjJ1GobtXldhzVOoddXm9XDMaWBBKlyoyY8HlxvIv6P9Rnldueu57h73+psdCWBDuiA8lFFDjzynVPhZ8ZXDMxoaHpQfzAhLASVbCjoTjxWHzhoNkVnD89Z1GGbZFOl7SJ3j33t8ing==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(4326008)(8936002)(9746002)(1076003)(36756003)(186003)(2616005)(9786002)(6916009)(66556008)(83380400001)(66946007)(38100700002)(508600001)(66476007)(5660300002)(2906002)(26005)(426003)(33656002)(316002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bIPvFONLT4FsgQTarbhtkOd4kstzHQgJFdnsuV0HAviW25+Q6EqOkLWERn/r?=
 =?us-ascii?Q?7KAsIiLADXPO+THlbYxPN09/OekmypWXFdDQf9KsTTkuiUnlcmKlHuXMdUgY?=
 =?us-ascii?Q?2tnkddRb2EkP5YHuYhdPQ5El3u9u/zFEHIpIs8dLTNSANnuMHRtNEHhOrZNl?=
 =?us-ascii?Q?2v5gcWtyXrp7iqN5re3KZyjnDXfvq+uLF4Yk2Cfk74KWp8X42p+c2b4B/bQ2?=
 =?us-ascii?Q?/HAFixGahq1YDFbo+tC1f3hnBTCcGdLP8ZbFnV6RiCrPPwn5L9nqn+MFhrSp?=
 =?us-ascii?Q?tjSDSbQrEhniZJhLQ/xW3sultFqU0ikynXiMai3I2lP8fhERrKTYOuAvq3l7?=
 =?us-ascii?Q?LjCUhHXLhor+2himdPFLJlhMtlSh/CqbuDnhJL43WI8sC0WY4MKLhEkfqWhc?=
 =?us-ascii?Q?fR7iQQScxTjgVstCTm35JOk5iMXb7f+ALiQsUg1qmbM19HfnyFuAkRT3VmN/?=
 =?us-ascii?Q?Mg2MgpuuHOZou2/I1iD9d9rtp2eUrcdpBS2yRxT3xMLCxuy5to2ModwBr7hv?=
 =?us-ascii?Q?d8Y2tAl0tvAr5/lBERm+WUYUSoNTzr1lKOhUzM/oi50NiaXo3mXrcfsunELo?=
 =?us-ascii?Q?Iw9jdjN6rWco4ZaHKlX/mOXB+0VMTckSB4qjkzTwLN/+lUbrLBqMQEMcTRt4?=
 =?us-ascii?Q?7zSenbNHTghMK92adLxX5xU1Ep/ITWhUjP6Wo5vkvDjQTHzjObd8wYb2x8kk?=
 =?us-ascii?Q?Hh1tHlYGFMabk+n/8tTRRwJkiDHH0VRmF4asb9IMgtQWsOyUOwMhP/iQ5ddr?=
 =?us-ascii?Q?HgJxHrR+aTA6EoWUS/AIGySqXu7RKiciCRgBUdLLYmzah5iXg8RoId3Q6kez?=
 =?us-ascii?Q?B+LhqzVGxuC/NPCfbwYP2XOpIVR2LL5Qhc9vrKBKlNRSeLjqLpBPo65CtePm?=
 =?us-ascii?Q?bAta6j2DX01Q1rfXybP52Q3zGPigChRVrklasVOIysBItu8uAtYmjsspG4gN?=
 =?us-ascii?Q?BGeJ6zH2ACNnWTtqxGtVzetu6qThjumuDY26VIAXRHf6nG7tZZ1VgTL68bzs?=
 =?us-ascii?Q?7S7lp5REGs9dBTbh+ZlOikzMGfuLAjWPcXRBq/eVUAnYM9fLhJmDKJsYQz8b?=
 =?us-ascii?Q?0D4ps80W2jqegMSX6Vnf9KALfk1p7J8BmYQIUDOPva/GxHTsrYgrgLDRtkcl?=
 =?us-ascii?Q?beeDuAJOqciE7WcsbN2Qc15u0PnfBJq9FrCYGdC/Y8Zba1dz1UzNTKrtD0CZ?=
 =?us-ascii?Q?vglPByj7zn/FChyAJYAnhtWbIPREofati7+2+SatEcjneFMRAj6wReybhHvG?=
 =?us-ascii?Q?5pIiwWtY/ssxi82/unK7ZuZyytpO9ZyGnDB6O4jEC7mbHuE/TnnmzYSnS6Rv?=
 =?us-ascii?Q?cLWXV6/9cPfQ0GoS/kFy1pZP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1638eb2c-dd1d-4110-db4a-08d97ecdbe9e
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2021 20:07:18.2785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aEtUDvTjviWtqTuQtxs6lbf6uwdu5CoBhUyhV5e506YteNoUpLR8DqopvIo2iA2K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5126
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
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/infiniband/core/cma.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)

Applied to for-rc

Jason
