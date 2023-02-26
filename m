Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 558696A2D8A
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 04:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjBZDoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 22:44:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbjBZDnt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 22:43:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027501716C;
        Sat, 25 Feb 2023 19:43:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DF89B80B87;
        Sun, 26 Feb 2023 03:43:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8FCC4339B;
        Sun, 26 Feb 2023 03:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677382995;
        bh=13YLkNN8arX1KfUTrzx4ohq91XIJWVVsVlw+6IDq2DY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eP8U8UfCt1ZmZpBiqGyKKvaVgqTenzDhZfr97XiHaUcOCtgBMTwAw9KqbDi1sIs3z
         9Zs+kunfBsMzut80hzaewUqrV0EW4+cPsvXlsXcjeI/Ac9rJERtl+fafaiFCOccOAQ
         KAW3HwipSFhzWaf6e1lISgkMKtzXNJEg6frJBqFtadq/n5JFxI7pSrHz8MjzuPCe7c
         eaTiQH9rYHk0x+Zu0U09TjRlLLBeGTxVHNahtrro1YOupr6yqn62tIknQQ9262areS
         qejxb6coK2D4potebDVYp9psbDPu4bqG8y1OAVsCI/HAHbALyJZ6dJ6m31T1tthDIu
         Q/UkH0zuomyfw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Kuai <yukuai3@huawei.com>, Tejun Heo <tj@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, josef@toxicpanda.com,
        cgroups@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 10/21] blk-cgroup: synchronize pd_free_fn() from blkg_free_workfn() and blkcg_deactivate_policy()
Date:   Sat, 25 Feb 2023 22:42:45 -0500
Message-Id: <20230226034256.771769-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226034256.771769-1-sashal@kernel.org>
References: <20230226034256.771769-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit f1c006f1c6850c14040f8337753a63119bba39b9 ]

Currently parent pd can be freed before child pd:

t1: remove cgroup C1
blkcg_destroy_blkgs
 blkg_destroy
  list_del_init(&blkg->q_node)
  // remove blkg from queue list
  percpu_ref_kill(&blkg->refcnt)
   blkg_release
    call_rcu

t2: from t1
__blkg_release
 blkg_free
  schedule_work
			t4: deactivate policy
			blkcg_deactivate_policy
			 pd_free_fn
			 // parent of C1 is freed first
t3: from t2
 blkg_free_workfn
  pd_free_fn

If policy(for example, ioc_timer_fn() from iocost) access parent pd from
child pd after pd_offline_fn(), then UAF can be triggered.

Fix the problem by delaying 'list_del_init(&blkg->q_node)' from
blkg_destroy() to blkg_free_workfn(), and using a new disk level mutex to
synchronize blkg_free_workfn() and blkcg_deactivate_policy().

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20230119110350.2287325-4-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c     | 35 +++++++++++++++++++++++++++++------
 include/linux/blkdev.h |  1 +
 2 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 8d1b7757f1e4f..f8b21bead6552 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -87,16 +87,32 @@ static void blkg_free_workfn(struct work_struct *work)
 {
 	struct blkcg_gq *blkg = container_of(work, struct blkcg_gq,
 					     free_work);
+	struct request_queue *q = blkg->q;
 	int i;
 
+	/*
+	 * pd_free_fn() can also be called from blkcg_deactivate_policy(),
+	 * in order to make sure pd_free_fn() is called in order, the deletion
+	 * of the list blkg->q_node is delayed to here from blkg_destroy(), and
+	 * blkcg_mutex is used to synchronize blkg_free_workfn() and
+	 * blkcg_deactivate_policy().
+	 */
+	if (q)
+		mutex_lock(&q->blkcg_mutex);
+
 	for (i = 0; i < BLKCG_MAX_POLS; i++)
 		if (blkg->pd[i])
 			blkcg_policy[i]->pd_free_fn(blkg->pd[i]);
 
 	if (blkg->parent)
 		blkg_put(blkg->parent);
-	if (blkg->q)
-		blk_put_queue(blkg->q);
+
+	if (q) {
+		list_del_init(&blkg->q_node);
+		mutex_unlock(&q->blkcg_mutex);
+		blk_put_queue(q);
+	}
+
 	free_percpu(blkg->iostat_cpu);
 	percpu_ref_exit(&blkg->refcnt);
 	kfree(blkg);
@@ -425,9 +441,14 @@ static void blkg_destroy(struct blkcg_gq *blkg)
 	lockdep_assert_held(&blkg->q->queue_lock);
 	lockdep_assert_held(&blkcg->lock);
 
-	/* Something wrong if we are trying to remove same group twice */
-	WARN_ON_ONCE(list_empty(&blkg->q_node));
-	WARN_ON_ONCE(hlist_unhashed(&blkg->blkcg_node));
+	/*
+	 * blkg stays on the queue list until blkg_free_workfn(), see details in
+	 * blkg_free_workfn(), hence this function can be called from
+	 * blkcg_destroy_blkgs() first and again from blkg_destroy_all() before
+	 * blkg_free_workfn().
+	 */
+	if (hlist_unhashed(&blkg->blkcg_node))
+		return;
 
 	for (i = 0; i < BLKCG_MAX_POLS; i++) {
 		struct blkcg_policy *pol = blkcg_policy[i];
@@ -439,7 +460,6 @@ static void blkg_destroy(struct blkcg_gq *blkg)
 	blkg->online = false;
 
 	radix_tree_delete(&blkcg->blkg_tree, blkg->q->id);
-	list_del_init(&blkg->q_node);
 	hlist_del_init_rcu(&blkg->blkcg_node);
 
 	/*
@@ -1226,6 +1246,7 @@ int blkcg_init_disk(struct gendisk *disk)
 	int ret;
 
 	INIT_LIST_HEAD(&q->blkg_list);
+	mutex_init(&q->blkcg_mutex);
 
 	new_blkg = blkg_alloc(&blkcg_root, disk, GFP_KERNEL);
 	if (!new_blkg)
@@ -1463,6 +1484,7 @@ void blkcg_deactivate_policy(struct request_queue *q,
 	if (queue_is_mq(q))
 		blk_mq_freeze_queue(q);
 
+	mutex_lock(&q->blkcg_mutex);
 	spin_lock_irq(&q->queue_lock);
 
 	__clear_bit(pol->plid, q->blkcg_pols);
@@ -1481,6 +1503,7 @@ void blkcg_deactivate_policy(struct request_queue *q,
 	}
 
 	spin_unlock_irq(&q->queue_lock);
+	mutex_unlock(&q->blkcg_mutex);
 
 	if (queue_is_mq(q))
 		blk_mq_unfreeze_queue(q);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 891f8cbcd0436..1680b6e1e5362 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -487,6 +487,7 @@ struct request_queue {
 	DECLARE_BITMAP		(blkcg_pols, BLKCG_MAX_POLS);
 	struct blkcg_gq		*root_blkg;
 	struct list_head	blkg_list;
+	struct mutex		blkcg_mutex;
 #endif
 
 	struct queue_limits	limits;
-- 
2.39.0

