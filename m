Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B7022F01E
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731811AbgG0OV5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:21:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:50724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731273AbgG0OV5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:21:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 318852070B;
        Mon, 27 Jul 2020 14:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859716;
        bh=ahte494R7mAucQiPHBCE15donQWdWRi9rtiAC5TFAFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sXqSbf5AGvJUiqO2lxLFRyJlbst/eDg8hZ3oo6LGuDW6jiyjnhMCF2nilhRKLR6zq
         mtZIJm9aG5zb3a3hfmdhBg/x2Yuc1CcrkIBw23KVl+lLBWLzWaHDrm7kBZRG7XaYRN
         pCECF4XEAAbMa67tRxY9FcHpYu+FjBrk4JY93oi8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 077/179] RDMA/mlx5: Prevent prefetch from racing with implicit destruction
Date:   Mon, 27 Jul 2020 16:04:12 +0200
Message-Id: <20200727134936.434847478@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit a862192e9227ad46e0447fd0a03869ba1b30d16f ]

Prefetch work in mlx5_ib_prefetch_mr_work can be queued and able to run
concurrently with destruction of the implicit MR. The num_deferred_work
was intended to serialize this, but there is a race:

       CPU0                                          CPU1

    mlx5_ib_free_implicit_mr()
      xa_erase(odp_mkeys)
      synchronize_srcu()
      __xa_erase(implicit_children)
                                      mlx5_ib_prefetch_mr_work()
                                        pagefault_mr()
                                         pagefault_implicit_mr()
                                          implicit_get_child_mr()
                                           xa_cmpxchg()
                                        atomic_dec_and_test(num_deferred_mr)
      wait_event(imr->q_deferred_work)
      ib_umem_odp_release(odp_imr)
        kfree(odp_imr)

At this point in mlx5_ib_free_implicit_mr() the implicit_children list is
supposed to be empty forever so that destroy_unused_implicit_child_mr()
and related are not and will not be running.

Since it is not empty the destroy_unused_implicit_child_mr() flow ends up
touching deallocated memory as mlx5_ib_free_implicit_mr() already tore down the
imr parent.

The solution is to flush out the prefetch wq by driving num_deferred_work
to zero after creation of new prefetch work is blocked.

Fixes: 5256edcb98a1 ("RDMA/mlx5: Rework implicit ODP destroy")
Link: https://lore.kernel.org/r/20200719065435.130722-1-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/odp.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 3de7606d4a1a7..bdeb6500a9191 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -601,6 +601,23 @@ void mlx5_ib_free_implicit_mr(struct mlx5_ib_mr *imr)
 	 */
 	synchronize_srcu(&dev->odp_srcu);
 
+	/*
+	 * All work on the prefetch list must be completed, xa_erase() prevented
+	 * new work from being created.
+	 */
+	wait_event(imr->q_deferred_work, !atomic_read(&imr->num_deferred_work));
+
+	/*
+	 * At this point it is forbidden for any other thread to enter
+	 * pagefault_mr() on this imr. It is already forbidden to call
+	 * pagefault_mr() on an implicit child. Due to this additions to
+	 * implicit_children are prevented.
+	 */
+
+	/*
+	 * Block destroy_unused_implicit_child_mr() from incrementing
+	 * num_deferred_work.
+	 */
 	xa_lock(&imr->implicit_children);
 	xa_for_each (&imr->implicit_children, idx, mtt) {
 		__xa_erase(&imr->implicit_children, idx);
@@ -609,9 +626,8 @@ void mlx5_ib_free_implicit_mr(struct mlx5_ib_mr *imr)
 	xa_unlock(&imr->implicit_children);
 
 	/*
-	 * num_deferred_work can only be incremented inside the odp_srcu, or
-	 * under xa_lock while the child is in the xarray. Thus at this point
-	 * it is only decreasing, and all work holding it is now on the wq.
+	 * Wait for any concurrent destroy_unused_implicit_child_mr() to
+	 * complete.
 	 */
 	wait_event(imr->q_deferred_work, !atomic_read(&imr->num_deferred_work));
 
-- 
2.25.1



