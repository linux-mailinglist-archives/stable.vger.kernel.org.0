Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED3A1681170
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237303AbjA3ONe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237246AbjA3ON3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:13:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16176BBA4
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:13:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD715B811CC
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:13:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB0DC433EF;
        Mon, 30 Jan 2023 14:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087998;
        bh=AYzYYfJX1b2Ap5QGLxgzEbXeKJ131oOq+nTNsXyXVCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=029iiO0sshKPvTDGiOjOi/kQAR2tgtpR25CQGofnTs3uG8r2mKyRx5mXXwSmbw0VH
         UwJjriYcKk7YTRTiuE9T1lupmYePM0iVRkDK/inJWj6y+h4f5mlOywFJem53zf1tg/
         eygAhZSaFfZiZdSO0ICanqgWGJeQ0ncrc+E8Fe+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kevin Hao <haokexin@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 081/204] octeontx2-pf: Fix the use of GFP_KERNEL in atomic context on rt
Date:   Mon, 30 Jan 2023 14:50:46 +0100
Message-Id: <20230130134319.899284686@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Hao <haokexin@gmail.com>

[ Upstream commit 55ba18dc62deff5910c0fa64486dea1ff20832ff ]

The commit 4af1b64f80fb ("octeontx2-pf: Fix lmtst ID used in aura
free") uses the get/put_cpu() to protect the usage of percpu pointer
in ->aura_freeptr() callback, but it also unnecessarily disable the
preemption for the blockable memory allocation. The commit 87b93b678e95
("octeontx2-pf: Avoid use of GFP_KERNEL in atomic context") tried to
fix these sleep inside atomic warnings. But it only fix the one for
the non-rt kernel. For the rt kernel, we still get the similar warnings
like below.
  BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:46
  in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper/0
  preempt_count: 1, expected: 0
  RCU nest depth: 0, expected: 0
  3 locks held by swapper/0/1:
   #0: ffff800009fc5fe8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock+0x24/0x30
   #1: ffff000100c276c0 (&mbox->lock){+.+.}-{3:3}, at: otx2_init_hw_resources+0x8c/0x3a4
   #2: ffffffbfef6537e0 (&cpu_rcache->lock){+.+.}-{2:2}, at: alloc_iova_fast+0x1ac/0x2ac
  Preemption disabled at:
  [<ffff800008b1908c>] otx2_rq_aura_pool_init+0x14c/0x284
  CPU: 20 PID: 1 Comm: swapper/0 Tainted: G        W          6.2.0-rc3-rt1-yocto-preempt-rt #1
  Hardware name: Marvell OcteonTX CN96XX board (DT)
  Call trace:
   dump_backtrace.part.0+0xe8/0xf4
   show_stack+0x20/0x30
   dump_stack_lvl+0x9c/0xd8
   dump_stack+0x18/0x34
   __might_resched+0x188/0x224
   rt_spin_lock+0x64/0x110
   alloc_iova_fast+0x1ac/0x2ac
   iommu_dma_alloc_iova+0xd4/0x110
   __iommu_dma_map+0x80/0x144
   iommu_dma_map_page+0xe8/0x260
   dma_map_page_attrs+0xb4/0xc0
   __otx2_alloc_rbuf+0x90/0x150
   otx2_rq_aura_pool_init+0x1c8/0x284
   otx2_init_hw_resources+0xe4/0x3a4
   otx2_open+0xf0/0x610
   __dev_open+0x104/0x224
   __dev_change_flags+0x1e4/0x274
   dev_change_flags+0x2c/0x7c
   ic_open_devs+0x124/0x2f8
   ip_auto_config+0x180/0x42c
   do_one_initcall+0x90/0x4dc
   do_basic_setup+0x10c/0x14c
   kernel_init_freeable+0x10c/0x13c
   kernel_init+0x2c/0x140
   ret_from_fork+0x10/0x20

Of course, we can shuffle the get/put_cpu() to only wrap the invocation
of ->aura_freeptr() as what commit 87b93b678e95 does. But there are only
two ->aura_freeptr() callbacks, otx2_aura_freeptr() and
cn10k_aura_freeptr(). There is no usage of perpcu variable in the
otx2_aura_freeptr() at all, so the get/put_cpu() seems redundant to it.
We can move the get/put_cpu() into the corresponding callback which
really has the percpu variable usage and avoid the sprinkling of
get/put_cpu() in several places.

Fixes: 4af1b64f80fb ("octeontx2-pf: Fix lmtst ID used in aura free")
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Link: https://lore.kernel.org/r/20230118071300.3271125-1-haokexin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/nic/otx2_common.c  | 11 ++---------
 .../net/ethernet/marvell/octeontx2/nic/otx2_common.h  |  2 ++
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 30d4c0ad712d..2e225309de9c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -962,7 +962,6 @@ static void otx2_pool_refill_task(struct work_struct *work)
 	rbpool = cq->rbpool;
 	free_ptrs = cq->pool_ptrs;
 
-	get_cpu();
 	while (cq->pool_ptrs) {
 		if (otx2_alloc_rbuf(pfvf, rbpool, &bufptr)) {
 			/* Schedule a WQ if we fails to free atleast half of the
@@ -982,7 +981,6 @@ static void otx2_pool_refill_task(struct work_struct *work)
 		pfvf->hw_ops->aura_freeptr(pfvf, qidx, bufptr + OTX2_HEAD_ROOM);
 		cq->pool_ptrs--;
 	}
-	put_cpu();
 	cq->refill_task_sched = false;
 }
 
@@ -1333,9 +1331,7 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
 			err = otx2_alloc_rbuf(pfvf, pool, &bufptr);
 			if (err)
 				goto err_mem;
-			get_cpu();
 			pfvf->hw_ops->aura_freeptr(pfvf, pool_id, bufptr);
-			put_cpu();
 			sq->sqb_ptrs[sq->sqb_count++] = (u64)bufptr;
 		}
 	}
@@ -1381,21 +1377,18 @@ int otx2_rq_aura_pool_init(struct otx2_nic *pfvf)
 	if (err)
 		goto fail;
 
-	get_cpu();
 	/* Allocate pointers and free them to aura/pool */
 	for (pool_id = 0; pool_id < hw->rqpool_cnt; pool_id++) {
 		pool = &pfvf->qset.pool[pool_id];
 		for (ptr = 0; ptr < num_ptrs; ptr++) {
 			err = otx2_alloc_rbuf(pfvf, pool, &bufptr);
 			if (err)
-				goto err_mem;
+				return -ENOMEM;
 			pfvf->hw_ops->aura_freeptr(pfvf, pool_id,
 						   bufptr + OTX2_HEAD_ROOM);
 		}
 	}
-err_mem:
-	put_cpu();
-	return err ? -ENOMEM : 0;
+	return 0;
 fail:
 	otx2_mbox_reset(&pfvf->mbox.mbox, 0);
 	otx2_aura_pool_free(pfvf);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 095e5de78c0b..e685628b9294 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -605,8 +605,10 @@ static inline void cn10k_aura_freeptr(void *dev, int aura, u64 buf)
 	u64 ptrs[2];
 
 	ptrs[1] = buf;
+	get_cpu();
 	/* Free only one buffer at time during init and teardown */
 	__cn10k_aura_freeptr(pfvf, aura, ptrs, 2);
+	put_cpu();
 }
 
 /* Alloc pointer from pool/aura */
-- 
2.39.0



