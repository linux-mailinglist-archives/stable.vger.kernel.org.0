Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70DD9A9074
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389986AbfIDSJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:09:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732902AbfIDSJt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:09:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 840F5206BA;
        Wed,  4 Sep 2019 18:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620588;
        bh=bDUqGV5JzXUfjzIyjKnGcEd3QLuWzA8BwTnGFxkzJZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2pfIFhyNjrlcEYUUOINOZtGU/vTPL9R/911B7dFLGtO4o1NFZZ2KM7xS+k4q4JMvX
         Jcjbz4LDP5YuEpF8g0j85Ma+PPHcivQ52r0th18t1Z5JNAqBd5YWeC3uW9crpvU8mj
         PxQb1wzsqw33GNLbum2fZg8TUOjt+eCCKbufgIrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yishai Hadas <yishaih@mellanox.com>,
        Artemy Kovalyov <artemyko@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 021/143] IB/mlx5: Fix implicit MR release flow
Date:   Wed,  4 Sep 2019 19:52:44 +0200
Message-Id: <20190904175314.898759822@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index f6e5351ba4d50..fda3dfd6f87b6 100644
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
@@ -684,19 +682,15 @@ next_mr:
 
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



