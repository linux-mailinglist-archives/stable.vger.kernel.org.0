Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E254417FA74
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730746AbgCJNEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:04:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726980AbgCJNEi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:04:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81EB5208E4;
        Tue, 10 Mar 2020 13:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845478;
        bh=R8RpqxlsEwipyw/H+lp42+s7YIm6hCQJvZOwnL+ebwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X1jvs5oIW33ZF5VdOgq08ESVXEgSEwRVOIjjW0H19JDlzgCjPszCm6eoFOXeoKVBF
         4Xkk/Vqkced0j23ZGdgJsvh5gQV0qrioE6oj1nz2XqdJ9cE1rB5bB7PBU6XyQdvcNf
         kp5/6SEeLeRMrzJ5NP7uovA02GSV8VzckUu+L0UE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.5 165/189] RDMA/core: Fix protection fault in ib_mr_pool_destroy
Date:   Tue, 10 Mar 2020 13:40:02 +0100
Message-Id: <20200310123656.675676108@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

commit e38b55ea0443da35a50a3eb2079ad3612cf763b9 upstream.

Fix NULL pointer dereference in the error flow of ib_create_qp_user
when accessing to uninitialized list pointers - rdma_mrs and sig_mrs.
The following crash from syzkaller revealed it.

  kasan: GPF could be caused by NULL-ptr deref or user memory access
  general protection fault: 0000 [#1] SMP KASAN PTI
  CPU: 1 PID: 23167 Comm: syz-executor.1 Not tainted 5.5.0-rc5 #2
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
  rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
  RIP: 0010:ib_mr_pool_destroy+0x81/0x1f0
  Code: 00 00 fc ff df 49 c1 ec 03 4d 01 fc e8 a8 ea 72 fe 41 80 3c 24 00
  0f 85 62 01 00 00 48 8b 13 48 89 d6 4c 8d 6a c8 48 c1 ee 03 <42> 80 3c
  3e 00 0f 85 34 01 00 00 48 8d 7a 08 4c 8b 02 48 89 fe 48
  RSP: 0018:ffffc9000951f8b0 EFLAGS: 00010046
  RAX: 0000000000040000 RBX: ffff88810f268038 RCX: ffffffff82c41628
  RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc9000951f850
  RBP: ffff88810f268020 R08: 0000000000000004 R09: fffff520012a3f0a
  R10: 0000000000000001 R11: fffff520012a3f0a R12: ffffed1021e4d007
  R13: ffffffffffffffc8 R14: 0000000000000246 R15: dffffc0000000000
  FS:  00007f54bc788700(0000) GS:ffff88811b100000(0000)
  knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000000 CR3: 0000000116920002 CR4: 0000000000360ee0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   rdma_rw_cleanup_mrs+0x15/0x30
   ib_destroy_qp_user+0x674/0x7d0
   ib_create_qp_user+0xb01/0x11c0
   create_qp+0x1517/0x2130
   ib_uverbs_create_qp+0x13e/0x190
   ib_uverbs_write+0xaa5/0xdf0
   __vfs_write+0x7c/0x100
   vfs_write+0x168/0x4a0
   ksys_write+0xc8/0x200
   do_syscall_64+0x9c/0x390
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  RIP: 0033:0x465b49
  Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48 89
  f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01
  f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
  RSP: 002b:00007f54bc787c58 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
  RAX: ffffffffffffffda RBX: 000000000073bf00 RCX: 0000000000465b49
  RDX: 0000000000000040 RSI: 0000000020000540 RDI: 0000000000000003
  RBP: 00007f54bc787c70 R08: 0000000000000000 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000246 R12: 00007f54bc7886bc
  R13: 00000000004ca2ec R14: 000000000070ded0 R15: 0000000000000005

Fixes: a060b5629ab0 ("IB/core: generic RDMA READ/WRITE API")
Link: https://lore.kernel.org/r/20200227112708.93023-1-leon@kernel.org
Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/core_priv.h  |   15 +++++++++++++++
 drivers/infiniband/core/uverbs_cmd.c |   10 ----------
 drivers/infiniband/core/verbs.c      |   10 ----------
 3 files changed, 15 insertions(+), 20 deletions(-)

--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -338,6 +338,21 @@ static inline struct ib_qp *_ib_create_q
 	qp->pd = pd;
 	qp->uobject = uobj;
 	qp->real_qp = qp;
+
+	qp->qp_type = attr->qp_type;
+	qp->qp_context = attr->qp_context;
+	qp->rwq_ind_tbl = attr->rwq_ind_tbl;
+	qp->send_cq = attr->send_cq;
+	qp->recv_cq = attr->recv_cq;
+	qp->srq = attr->srq;
+	qp->rwq_ind_tbl = attr->rwq_ind_tbl;
+	qp->event_handler = attr->event_handler;
+
+	atomic_set(&qp->usecnt, 0);
+	spin_lock_init(&qp->mr_lock);
+	INIT_LIST_HEAD(&qp->rdma_mrs);
+	INIT_LIST_HEAD(&qp->sig_mrs);
+
 	/*
 	 * We don't track XRC QPs for now, because they don't have PD
 	 * and more importantly they are created internaly by driver,
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1433,17 +1433,7 @@ static int create_qp(struct uverbs_attr_
 		if (ret)
 			goto err_cb;
 
-		qp->pd		  = pd;
-		qp->send_cq	  = attr.send_cq;
-		qp->recv_cq	  = attr.recv_cq;
-		qp->srq		  = attr.srq;
-		qp->rwq_ind_tbl	  = ind_tbl;
-		qp->event_handler = attr.event_handler;
-		qp->qp_context	  = attr.qp_context;
-		qp->qp_type	  = attr.qp_type;
-		atomic_set(&qp->usecnt, 0);
 		atomic_inc(&pd->usecnt);
-		qp->port = 0;
 		if (attr.send_cq)
 			atomic_inc(&attr.send_cq->usecnt);
 		if (attr.recv_cq)
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1182,16 +1182,6 @@ struct ib_qp *ib_create_qp_user(struct i
 	if (ret)
 		goto err;
 
-	qp->qp_type    = qp_init_attr->qp_type;
-	qp->rwq_ind_tbl = qp_init_attr->rwq_ind_tbl;
-
-	atomic_set(&qp->usecnt, 0);
-	qp->mrs_used = 0;
-	spin_lock_init(&qp->mr_lock);
-	INIT_LIST_HEAD(&qp->rdma_mrs);
-	INIT_LIST_HEAD(&qp->sig_mrs);
-	qp->port = 0;
-
 	if (qp_init_attr->qp_type == IB_QPT_XRC_TGT) {
 		struct ib_qp *xrc_qp =
 			create_xrc_qp_user(qp, qp_init_attr, udata);


