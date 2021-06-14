Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8653A64A6
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235741AbhFNL1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:27:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233826AbhFNLZr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:25:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B324D619A9;
        Mon, 14 Jun 2021 10:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623668075;
        bh=AdvAlk2XjJ93Yp9FH0iy+xJSk6GCoKJdFtkav7fB8AY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QbOtlao2tbjpIZinzi0qVxhjmMCOLfYJyoJcaCMEhTolhSZeKrWNiLMUnSkcGIwtp
         dZL/cGrIEssrRLVeGbQM+R3lc+k/4Ry0R135fggC9AbTjFX1C0NP9y6PoVA9Vc7NE9
         bkAe8C1iKdF3ZOW7/tHIRd5GpRZ18pWhYHSs4wiE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.12 137/173] RDMA/ipoib: Fix warning caused by destroying non-initial netns
Date:   Mon, 14 Jun 2021 12:27:49 +0200
Message-Id: <20210614102702.722165869@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Heib <kamalheib1@gmail.com>

commit a3e74fb9247cd530dca246699d5eb5a691884d32 upstream.

After the commit 5ce2dced8e95 ("RDMA/ipoib: Set rtnl_link_ops for ipoib
interfaces"), if the IPoIB device is moved to non-initial netns,
destroying that netns lets the device vanish instead of moving it back to
the initial netns, This is happening because default_device_exit() skips
the interfaces due to having rtnl_link_ops set.

Steps to reporoduce:
  ip netns add foo
  ip link set mlx5_ib0 netns foo
  ip netns delete foo

WARNING: CPU: 1 PID: 704 at net/core/dev.c:11435 netdev_exit+0x3f/0x50
Modules linked in: xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT
nf_reject_ipv4 nft_compat nft_counter nft_chain_nat nf_nat nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 nf_tables nfnetlink tun d
 fuse
CPU: 1 PID: 704 Comm: kworker/u64:3 Tainted: G S      W  5.13.0-rc1+ #1
Hardware name: Dell Inc. PowerEdge R630/02C2CP, BIOS 2.1.5 04/11/2016
Workqueue: netns cleanup_net
RIP: 0010:netdev_exit+0x3f/0x50
Code: 48 8b bb 30 01 00 00 e8 ef 81 b1 ff 48 81 fb c0 3a 54 a1 74 13 48
8b 83 90 00 00 00 48 81 c3 90 00 00 00 48 39 d8 75 02 5b c3 <0f> 0b 5b
c3 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 0f 1f 44 00
RSP: 0018:ffffb297079d7e08 EFLAGS: 00010206
RAX: ffff8eb542c00040 RBX: ffff8eb541333150 RCX: 000000008010000d
RDX: 000000008010000e RSI: 000000008010000d RDI: ffff8eb440042c00
RBP: ffffb297079d7e48 R08: 0000000000000001 R09: ffffffff9fdeac00
R10: ffff8eb5003be000 R11: 0000000000000001 R12: ffffffffa1545620
R13: ffffffffa1545628 R14: 0000000000000000 R15: ffffffffa1543b20
FS:  0000000000000000(0000) GS:ffff8ed37fa00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005601b5f4c2e8 CR3: 0000001fc8c10002 CR4: 00000000003706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ops_exit_list.isra.9+0x36/0x70
 cleanup_net+0x234/0x390
 process_one_work+0x1cb/0x360
 ? process_one_work+0x360/0x360
 worker_thread+0x30/0x370
 ? process_one_work+0x360/0x360
 kthread+0x116/0x130
 ? kthread_park+0x80/0x80
 ret_from_fork+0x22/0x30

To avoid the above warning and later on the kernel panic that could happen
on shutdown due to a NULL pointer dereference, make sure to set the
netns_refund flag that was introduced by commit 3a5ca857079e ("can: dev:
Move device back to init netns on owning netns delete") to properly
restore the IPoIB interfaces to the initial netns.

Fixes: 5ce2dced8e95 ("RDMA/ipoib: Set rtnl_link_ops for ipoib interfaces")
Link: https://lore.kernel.org/r/20210525150134.139342-1-kamalheib1@gmail.com
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
@@ -163,6 +163,7 @@ static size_t ipoib_get_size(const struc
 
 static struct rtnl_link_ops ipoib_link_ops __read_mostly = {
 	.kind		= "ipoib",
+	.netns_refund   = true,
 	.maxtype	= IFLA_IPOIB_MAX,
 	.policy		= ipoib_policy,
 	.priv_size	= sizeof(struct ipoib_dev_priv),


