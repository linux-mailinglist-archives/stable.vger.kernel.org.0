Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 715956B5A54
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 11:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjCKKNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 05:13:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbjCKKM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 05:12:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E88BBB3;
        Sat, 11 Mar 2023 02:12:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C6FE60B08;
        Sat, 11 Mar 2023 10:12:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F607C433EF;
        Sat, 11 Mar 2023 10:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678529572;
        bh=XbyxEg3Hk5S76DoHn+AR+Uo0RoH8PxVlTrcx2mGviTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bbx5XaR2YBHxIbP7R8/wBRV1aKMi3wZp4vIeZVHHeLaqzHOJJMSjOqPVD8iNDXsaF
         8ZwFZ5DECvPwrdp+c6M6ir96nxTwvJfuH9G5I9bFzUA2FsNf0xgSXdKvAQN6uskA2z
         O/uleUAIlxHhvGqkR6RS0MJS3exydZJV2Hf/GNLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 6.2.4
Date:   Sat, 11 Mar 2023 11:12:42 +0100
Message-Id: <16785295611454@kroah.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <167852956118245@kroah.com>
References: <167852956118245@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index eef164b4172a..83cbbc3adbb1 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 6
 PATCHLEVEL = 2
-SUBLEVEL = 3
+SUBLEVEL = 4
 EXTRAVERSION =
 NAME = Hurr durr I'ma ninja sloth
 
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 45881f8c7913..9ac1efb053e0 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -118,32 +118,14 @@ static void blkg_free_workfn(struct work_struct *work)
 {
 	struct blkcg_gq *blkg = container_of(work, struct blkcg_gq,
 					     free_work);
-	struct request_queue *q = blkg->q;
 	int i;
 
-	/*
-	 * pd_free_fn() can also be called from blkcg_deactivate_policy(),
-	 * in order to make sure pd_free_fn() is called in order, the deletion
-	 * of the list blkg->q_node is delayed to here from blkg_destroy(), and
-	 * blkcg_mutex is used to synchronize blkg_free_workfn() and
-	 * blkcg_deactivate_policy().
-	 */
-	if (q)
-		mutex_lock(&q->blkcg_mutex);
-
 	for (i = 0; i < BLKCG_MAX_POLS; i++)
 		if (blkg->pd[i])
 			blkcg_policy[i]->pd_free_fn(blkg->pd[i]);
 
-	if (blkg->parent)
-		blkg_put(blkg->parent);
-
-	if (q) {
-		list_del_init(&blkg->q_node);
-		mutex_unlock(&q->blkcg_mutex);
-		blk_put_queue(q);
-	}
-
+	if (blkg->q)
+		blk_put_queue(blkg->q);
 	free_percpu(blkg->iostat_cpu);
 	percpu_ref_exit(&blkg->refcnt);
 	kfree(blkg);
@@ -176,6 +158,8 @@ static void __blkg_release(struct rcu_head *rcu)
 
 	/* release the blkcg and parent blkg refs this blkg has been holding */
 	css_put(&blkg->blkcg->css);
+	if (blkg->parent)
+		blkg_put(blkg->parent);
 	blkg_free(blkg);
 }
 
@@ -474,14 +458,9 @@ static void blkg_destroy(struct blkcg_gq *blkg)
 	lockdep_assert_held(&blkg->q->queue_lock);
 	lockdep_assert_held(&blkcg->lock);
 
-	/*
-	 * blkg stays on the queue list until blkg_free_workfn(), see details in
-	 * blkg_free_workfn(), hence this function can be called from
-	 * blkcg_destroy_blkgs() first and again from blkg_destroy_all() before
-	 * blkg_free_workfn().
-	 */
-	if (hlist_unhashed(&blkg->blkcg_node))
-		return;
+	/* Something wrong if we are trying to remove same group twice */
+	WARN_ON_ONCE(list_empty(&blkg->q_node));
+	WARN_ON_ONCE(hlist_unhashed(&blkg->blkcg_node));
 
 	for (i = 0; i < BLKCG_MAX_POLS; i++) {
 		struct blkcg_policy *pol = blkcg_policy[i];
@@ -493,6 +472,7 @@ static void blkg_destroy(struct blkcg_gq *blkg)
 	blkg->online = false;
 
 	radix_tree_delete(&blkcg->blkg_tree, blkg->q->id);
+	list_del_init(&blkg->q_node);
 	hlist_del_init_rcu(&blkg->blkcg_node);
 
 	/*
@@ -1293,7 +1273,6 @@ int blkcg_init_disk(struct gendisk *disk)
 	int ret;
 
 	INIT_LIST_HEAD(&q->blkg_list);
-	mutex_init(&q->blkcg_mutex);
 
 	new_blkg = blkg_alloc(&blkcg_root, disk, GFP_KERNEL);
 	if (!new_blkg)
@@ -1531,7 +1510,6 @@ void blkcg_deactivate_policy(struct request_queue *q,
 	if (queue_is_mq(q))
 		blk_mq_freeze_queue(q);
 
-	mutex_lock(&q->blkcg_mutex);
 	spin_lock_irq(&q->queue_lock);
 
 	__clear_bit(pol->plid, q->blkcg_pols);
@@ -1550,7 +1528,6 @@ void blkcg_deactivate_policy(struct request_queue *q,
 	}
 
 	spin_unlock_irq(&q->queue_lock);
-	mutex_unlock(&q->blkcg_mutex);
 
 	if (queue_is_mq(q))
 		blk_mq_unfreeze_queue(q);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 10ee92db680c..43d4e073b111 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -484,7 +484,6 @@ struct request_queue {
 	DECLARE_BITMAP		(blkcg_pols, BLKCG_MAX_POLS);
 	struct blkcg_gq		*root_blkg;
 	struct list_head	blkg_list;
-	struct mutex		blkcg_mutex;
 #endif
 
 	struct queue_limits	limits;
