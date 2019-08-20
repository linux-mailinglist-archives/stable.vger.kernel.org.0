Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 369829606D
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730248AbfHTNk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:40:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:35882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730233AbfHTNk5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:40:57 -0400
Received: from sasha-vm.mshome.net (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8293E2087E;
        Tue, 20 Aug 2019 13:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566308456;
        bh=zgzScHswSTZjD4IaXhHruQt/HjSOxyZatTyX+KkDTFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UHN2UULCqKmrWxtUbvfoFwR/+6ElOWx1e2Yg7Rh+6wXrd13M2UZfMRvSNjyTMUsJZ
         al1vIn8Ymkopmac6/b+7h2uRd7KBydA1TKJIw46BZwRNOoqiaQ5jAswcd0va6Xajiz
         ZK3gcsPeG1vCIsfJtvOWnObCtnayt8kWj6zBncZ8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yishai Hadas <yishaih@mellanox.com>,
        Artemy Kovalyov <artemyko@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 23/44] IB/mlx5: Fix implicit MR release flow
Date:   Tue, 20 Aug 2019 09:40:07 -0400
Message-Id: <20190820134028.10829-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190820134028.10829-1-sashal@kernel.org>
References: <20190820134028.10829-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

[ Upstream commit f591822c3cf314442819486f45ff7dc1f690e0c0 ]

Once implicit MR is being called to be released by
ib_umem_notifier_release() its leaves were marked as "dying".

However, when dereg_mr()->mlx5_ib_free_implicit_mr()->mr_leaf_free() is
called, it skips running the mr_leaf_free_action (i.e. umem_odp->work)
when those leaves were marked as "dying".

As such ib_umem_release() for the leaves won't be called and their MRs
will be leaked as well.

When an application exits/killed without calling dereg_mr we might hit the
above flow.

This fatal scenario is reported by WARN_ON() upon
mlx5_ib_dealloc_ucontext() as ibcontext->per_mm_list is not empty, the
call trace can be seen below.

Originally the "dying" mark as part of ib_umem_notifier_release() was
introduced to prevent pagefault_mr() from returning a success response
once this happened. However, we already have today the completion
mechanism so no need for that in those flows any more.  Even in case a
success response will be returned the firmware will not find the pages and
an error will be returned in the following call as a released mm will
cause ib_umem_odp_map_dma_pages() to permanently fail mmget_not_zero().

Fix the above issue by dropping the "dying" from the above flows.  The
other flows that are using "dying" are still needed it for their
synchronization purposes.

   WARNING: CPU: 1 PID: 7218 at
   drivers/infiniband/hw/mlx5/main.c:2004
		  mlx5_ib_dealloc_ucontext+0x84/0x90 [mlx5_ib]
   CPU: 1 PID: 7218 Comm: ibv_rc_pingpong Tainted: G     E
	       5.2.0-rc6+ #13
   Call Trace:
   uverbs_destroy_ufile_hw+0xb5/0x120 [ib_uverbs]
   ib_uverbs_close+0x1f/0x80 [ib_uverbs]
   __fput+0xbe/0x250
   task_work_run+0x88/0xa0
   do_exit+0x2cb/0xc30
   ? __fput+0x14b/0x250
   do_group_exit+0x39/0xb0
   get_signal+0x191/0x920
   ? _raw_spin_unlock_bh+0xa/0x20
   ? inet_csk_accept+0x229/0x2f0
   do_signal+0x36/0x5e0
   ? put_unused_fd+0x5b/0x70
   ? __sys_accept4+0x1a6/0x1e0
   ? inet_hash+0x35/0x40
   ? release_sock+0x43/0x90
   ? _raw_spin_unlock_bh+0xa/0x20
   ? inet_listen+0x9f/0x120
   exit_to_usermode_loop+0x5c/0xc6
   do_syscall_64+0x182/0x1b0
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 81713d3788d2 ("IB/mlx5: Add implicit MR support")
Link: https://lore.kernel.org/r/20190805083010.21777-1-leon@kernel.org
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/umem_odp.c |  4 ----
 drivers/infiniband/hw/mlx5/odp.c   | 24 +++++++++---------------
 2 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index e4b13a32692a9..5e5f7dd82c50d 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -114,10 +114,6 @@ static int ib_umem_notifier_release_trampoline(struct ib_umem_odp *umem_odp,
 	 * prevent any further fault handling on this MR.
 	 */
 	ib_umem_notifier_start_account(umem_odp);
-	umem_odp->dying = 1;
-	/* Make sure that the fact the umem is dying is out before we release
-	 * all pending page faults. */
-	smp_wmb();
 	complete_all(&umem_odp->notifier_completion);
 	umem->context->invalidate_range(umem_odp, ib_umem_start(umem),
 					ib_umem_end(umem));
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 91507a2e92900..d711f3e31fa74 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -581,7 +581,6 @@ static int pagefault_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr,
 			u32 flags)
 {
 	int npages = 0, current_seq, page_shift, ret, np;
-	bool implicit = false;
 	struct ib_umem_odp *odp_mr = to_ib_umem_odp(mr->umem);
 	bool downgrade = flags & MLX5_PF_FLAGS_DOWNGRADE;
 	bool prefetch = flags & MLX5_PF_FLAGS_PREFETCH;
@@ -596,7 +595,6 @@ static int pagefault_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr,
 		if (IS_ERR(odp))
 			return PTR_ERR(odp);
 		mr = odp->private;
-		implicit = true;
 	} else {
 		odp = odp_mr;
 	}
@@ -684,19 +682,15 @@ static int pagefault_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr,
 
 out:
 	if (ret == -EAGAIN) {
-		if (implicit || !odp->dying) {
-			unsigned long timeout =
-				msecs_to_jiffies(MMU_NOTIFIER_TIMEOUT);
-
-			if (!wait_for_completion_timeout(
-					&odp->notifier_completion,
-					timeout)) {
-				mlx5_ib_warn(dev, "timeout waiting for mmu notifier. seq %d against %d. notifiers_count=%d\n",
-					     current_seq, odp->notifiers_seq, odp->notifiers_count);
-			}
-		} else {
-			/* The MR is being killed, kill the QP as well. */
-			ret = -EFAULT;
+		unsigned long timeout = msecs_to_jiffies(MMU_NOTIFIER_TIMEOUT);
+
+		if (!wait_for_completion_timeout(&odp->notifier_completion,
+						 timeout)) {
+			mlx5_ib_warn(
+				dev,
+				"timeout waiting for mmu notifier. seq %d against %d. notifiers_count=%d\n",
+				current_seq, odp->notifiers_seq,
+				odp->notifiers_count);
 		}
 	}
 
-- 
2.20.1

