Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFEE20E6D7
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404502AbgF2Vux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:50:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726660AbgF2Sfk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAFB9246E1;
        Mon, 29 Jun 2020 15:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444027;
        bh=+85BCrhMl4avR7Mdde403GEQ02BYJJXhgxi8M8Ui5Do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zCu77SjbRVy/Jzs+LP2kCnzmofhmZ5qu2p3Ojgtvl2tfGzOx/VjM7oYHstZwGiYxD
         J4yBIb/rEb9ol4Ju7UixTS//ie93PCQX+cE8Nu0cyGInAsDv8nktwMVc8ph1gZEiYy
         7uDDNuUk8BT2PDXQ9ufHUoZXjMdgSEcFpfBXLhcA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Zhang <markz@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 134/265] RDMA/cma: Protect bind_list and listen_list while finding matching cm id
Date:   Mon, 29 Jun 2020 11:16:07 -0400
Message-Id: <20200629151818.2493727-135-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

[ Upstream commit 730c8912484186d4623d0c76509066d285c3a755 ]

The bind_list and listen_list must be accessed under a lock, add the
missing locking around the access in cm_ib_id_from_event()

In addition add lockdep asserts to make it clearer what the locking
semantic is here.

  general protection fault: 0000 [#1] SMP NOPTI
  CPU: 226 PID: 126135 Comm: kworker/226:1 Tainted: G OE 4.12.14-150.47-default #1 SLE15
  Hardware name: Cray Inc. Windom/Windom, BIOS 0.8.7 01-10-2020
  Workqueue: ib_cm cm_work_handler [ib_cm]
  task: ffff9c5a60a1d2c0 task.stack: ffffc1d91f554000
  RIP: 0010:cma_ib_req_handler+0x3f1/0x11b0 [rdma_cm]
  RSP: 0018:ffffc1d91f557b40 EFLAGS: 00010286
  RAX: deacffffffffff30 RBX: 0000000000000001 RCX: ffff9c2af5bb6000
  RDX: 00000000000000a9 RSI: ffff9c5aa4ed2f10 RDI: ffffc1d91f557b08
  RBP: ffffc1d91f557d90 R08: ffff9c340cc80000 R09: ffff9c2c0f901900
  R10: 0000000000000000 R11: 0000000000000001 R12: deacffffffffff30
  R13: ffff9c5a48aeec00 R14: ffffc1d91f557c30 R15: ffff9c5c2eea3688
  FS: 0000000000000000(0000) GS:ffff9c5c2fa80000(0000) knlGS:0000000000000000
  CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00002b5cc03fa320 CR3: 0000003f8500a000 CR4: 00000000003406e0
  Call Trace:
  ? rdma_addr_cancel+0xa0/0xa0 [ib_core]
  ? cm_process_work+0x28/0x140 [ib_cm]
  cm_process_work+0x28/0x140 [ib_cm]
  ? cm_get_bth_pkey.isra.44+0x34/0xa0 [ib_cm]
  cm_work_handler+0xa06/0x1a6f [ib_cm]
  ? __switch_to_asm+0x34/0x70
  ? __switch_to_asm+0x34/0x70
  ? __switch_to_asm+0x40/0x70
  ? __switch_to_asm+0x34/0x70
  ? __switch_to_asm+0x40/0x70
  ? __switch_to_asm+0x34/0x70
  ? __switch_to_asm+0x40/0x70
  ? __switch_to+0x7c/0x4b0
  ? __switch_to_asm+0x40/0x70
  ? __switch_to_asm+0x34/0x70
  process_one_work+0x1da/0x400
  worker_thread+0x2b/0x3f0
  ? process_one_work+0x400/0x400
  kthread+0x118/0x140
  ? kthread_create_on_node+0x40/0x40
  ret_from_fork+0x22/0x40
  Code: 00 66 83 f8 02 0f 84 ca 05 00 00 49 8b 84 24 d0 01 00 00 48 85 c0 0f 84 68 07 00 00 48 2d d0 01
  00 00 49 89 c4 0f 84 59 07 00 00 <41> 0f b7 44 24 20 49 8b 77 50 66 83 f8 0a 75 9e 49 8b 7c 24 28

Fixes: 4c21b5bcef73 ("IB/cma: Add net_dev and private data checks to RDMA CM")
Link: https://lore.kernel.org/r/20200616104304.2426081-1-leon@kernel.org
Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 26e6f7df247b6..12ada58c96a90 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1619,6 +1619,8 @@ static struct rdma_id_private *cma_find_listener(
 {
 	struct rdma_id_private *id_priv, *id_priv_dev;
 
+	lockdep_assert_held(&lock);
+
 	if (!bind_list)
 		return ERR_PTR(-EINVAL);
 
@@ -1665,6 +1667,7 @@ cma_ib_id_from_event(struct ib_cm_id *cm_id,
 		}
 	}
 
+	mutex_lock(&lock);
 	/*
 	 * Net namespace might be getting deleted while route lookup,
 	 * cm_id lookup is in progress. Therefore, perform netdevice
@@ -1706,6 +1709,7 @@ cma_ib_id_from_event(struct ib_cm_id *cm_id,
 	id_priv = cma_find_listener(bind_list, cm_id, ib_event, req, *net_dev);
 err:
 	rcu_read_unlock();
+	mutex_unlock(&lock);
 	if (IS_ERR(id_priv) && *net_dev) {
 		dev_put(*net_dev);
 		*net_dev = NULL;
@@ -2481,6 +2485,8 @@ static void cma_listen_on_dev(struct rdma_id_private *id_priv,
 	struct net *net = id_priv->id.route.addr.dev_addr.net;
 	int ret;
 
+	lockdep_assert_held(&lock);
+
 	if (cma_family(id_priv) == AF_IB && !rdma_cap_ib_cm(cma_dev->device, 1))
 		return;
 
@@ -3308,6 +3314,8 @@ static void cma_bind_port(struct rdma_bind_list *bind_list,
 	u64 sid, mask;
 	__be16 port;
 
+	lockdep_assert_held(&lock);
+
 	addr = cma_src_addr(id_priv);
 	port = htons(bind_list->port);
 
@@ -3336,6 +3344,8 @@ static int cma_alloc_port(enum rdma_ucm_port_space ps,
 	struct rdma_bind_list *bind_list;
 	int ret;
 
+	lockdep_assert_held(&lock);
+
 	bind_list = kzalloc(sizeof *bind_list, GFP_KERNEL);
 	if (!bind_list)
 		return -ENOMEM;
@@ -3362,6 +3372,8 @@ static int cma_port_is_unique(struct rdma_bind_list *bind_list,
 	struct sockaddr  *saddr = cma_src_addr(id_priv);
 	__be16 dport = cma_port(daddr);
 
+	lockdep_assert_held(&lock);
+
 	hlist_for_each_entry(cur_id, &bind_list->owners, node) {
 		struct sockaddr  *cur_daddr = cma_dst_addr(cur_id);
 		struct sockaddr  *cur_saddr = cma_src_addr(cur_id);
@@ -3401,6 +3413,8 @@ static int cma_alloc_any_port(enum rdma_ucm_port_space ps,
 	unsigned int rover;
 	struct net *net = id_priv->id.route.addr.dev_addr.net;
 
+	lockdep_assert_held(&lock);
+
 	inet_get_local_port_range(net, &low, &high);
 	remaining = (high - low) + 1;
 	rover = prandom_u32() % remaining + low;
@@ -3448,6 +3462,8 @@ static int cma_check_port(struct rdma_bind_list *bind_list,
 	struct rdma_id_private *cur_id;
 	struct sockaddr *addr, *cur_addr;
 
+	lockdep_assert_held(&lock);
+
 	addr = cma_src_addr(id_priv);
 	hlist_for_each_entry(cur_id, &bind_list->owners, node) {
 		if (id_priv == cur_id)
@@ -3478,6 +3494,8 @@ static int cma_use_port(enum rdma_ucm_port_space ps,
 	unsigned short snum;
 	int ret;
 
+	lockdep_assert_held(&lock);
+
 	snum = ntohs(cma_port(cma_src_addr(id_priv)));
 	if (snum < PROT_SOCK && !capable(CAP_NET_BIND_SERVICE))
 		return -EACCES;
-- 
2.25.1

