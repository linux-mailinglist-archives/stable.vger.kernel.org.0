Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACE84541E91
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380738AbiFGWcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383847AbiFGWbA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:31:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4AF4DF06;
        Tue,  7 Jun 2022 12:24:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 300F0B823CA;
        Tue,  7 Jun 2022 19:24:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2C2C385A2;
        Tue,  7 Jun 2022 19:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629852;
        bh=MNGbb0y6lx7BzfYUSDabvaF+OEPYHabK0nbEfAzr7mo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FCiiG9nYlyF9+IsMSeAJ/rePXDTwn9TW35ST2NzQKV5xfvtD6GZVOKKEER6efKPe1
         HxUWlJ8ZXX236Ow5rPpppJbOwDQmf++2XN3iHmhflaMXnahaIEQ/RjXIzyvFPwlC8R
         znqhaetkCl2qdQwzZx2uLXa+opWu3EKJcjk+hCn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.18 839/879] bcache: improve multithreaded bch_btree_check()
Date:   Tue,  7 Jun 2022 19:05:57 +0200
Message-Id: <20220607165027.207360448@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

commit 622536443b6731ec82c563aae7807165adbe9178 upstream.

Commit 8e7102273f59 ("bcache: make bch_btree_check() to be
multithreaded") makes bch_btree_check() to be much faster when checking
all btree nodes during cache device registration. But it isn't in ideal
shap yet, still can be improved.

This patch does the following thing to improve current parallel btree
nodes check by multiple threads in bch_btree_check(),
- Add read lock to root node while checking all the btree nodes with
  multiple threads. Although currently it is not mandatory but it is
  good to have a read lock in code logic.
- Remove local variable 'char name[32]', and generate kernel thread name
  string directly when calling kthread_run().
- Allocate local variable "struct btree_check_state check_state" on the
  stack and avoid unnecessary dynamic memory allocation for it.
- Reduce BCH_BTR_CHKTHREAD_MAX from 64 to 12 which is enough indeed.
- Increase check_state->started to count created kernel thread after it
  succeeds to create.
- When wait for all checking kernel threads to finish, use wait_event()
  to replace wait_event_interruptible().

With this change, the code is more clear, and some potential error
conditions are avoided.

Fixes: 8e7102273f59 ("bcache: make bch_btree_check() to be multithreaded")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220524102336.10684-2-colyli@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/bcache/btree.c |   58 ++++++++++++++++++++--------------------------
 drivers/md/bcache/btree.h |    2 -
 2 files changed, 27 insertions(+), 33 deletions(-)

--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -2006,8 +2006,7 @@ int bch_btree_check(struct cache_set *c)
 	int i;
 	struct bkey *k = NULL;
 	struct btree_iter iter;
-	struct btree_check_state *check_state;
-	char name[32];
+	struct btree_check_state check_state;
 
 	/* check and mark root node keys */
 	for_each_key_filter(&c->root->keys, k, &iter, bch_ptr_invalid)
@@ -2018,63 +2017,58 @@ int bch_btree_check(struct cache_set *c)
 	if (c->root->level == 0)
 		return 0;
 
-	check_state = kzalloc(sizeof(struct btree_check_state), GFP_KERNEL);
-	if (!check_state)
-		return -ENOMEM;
-
-	check_state->c = c;
-	check_state->total_threads = bch_btree_chkthread_nr();
-	check_state->key_idx = 0;
-	spin_lock_init(&check_state->idx_lock);
-	atomic_set(&check_state->started, 0);
-	atomic_set(&check_state->enough, 0);
-	init_waitqueue_head(&check_state->wait);
+	check_state.c = c;
+	check_state.total_threads = bch_btree_chkthread_nr();
+	check_state.key_idx = 0;
+	spin_lock_init(&check_state.idx_lock);
+	atomic_set(&check_state.started, 0);
+	atomic_set(&check_state.enough, 0);
+	init_waitqueue_head(&check_state.wait);
 
+	rw_lock(0, c->root, c->root->level);
 	/*
 	 * Run multiple threads to check btree nodes in parallel,
-	 * if check_state->enough is non-zero, it means current
+	 * if check_state.enough is non-zero, it means current
 	 * running check threads are enough, unncessary to create
 	 * more.
 	 */
-	for (i = 0; i < check_state->total_threads; i++) {
-		/* fetch latest check_state->enough earlier */
+	for (i = 0; i < check_state.total_threads; i++) {
+		/* fetch latest check_state.enough earlier */
 		smp_mb__before_atomic();
-		if (atomic_read(&check_state->enough))
+		if (atomic_read(&check_state.enough))
 			break;
 
-		check_state->infos[i].result = 0;
-		check_state->infos[i].state = check_state;
-		snprintf(name, sizeof(name), "bch_btrchk[%u]", i);
-		atomic_inc(&check_state->started);
+		check_state.infos[i].result = 0;
+		check_state.infos[i].state = &check_state;
 
-		check_state->infos[i].thread =
+		check_state.infos[i].thread =
 			kthread_run(bch_btree_check_thread,
-				    &check_state->infos[i],
-				    name);
-		if (IS_ERR(check_state->infos[i].thread)) {
+				    &check_state.infos[i],
+				    "bch_btrchk[%d]", i);
+		if (IS_ERR(check_state.infos[i].thread)) {
 			pr_err("fails to run thread bch_btrchk[%d]\n", i);
 			for (--i; i >= 0; i--)
-				kthread_stop(check_state->infos[i].thread);
+				kthread_stop(check_state.infos[i].thread);
 			ret = -ENOMEM;
 			goto out;
 		}
+		atomic_inc(&check_state.started);
 	}
 
 	/*
 	 * Must wait for all threads to stop.
 	 */
-	wait_event_interruptible(check_state->wait,
-				 atomic_read(&check_state->started) == 0);
+	wait_event(check_state.wait, atomic_read(&check_state.started) == 0);
 
-	for (i = 0; i < check_state->total_threads; i++) {
-		if (check_state->infos[i].result) {
-			ret = check_state->infos[i].result;
+	for (i = 0; i < check_state.total_threads; i++) {
+		if (check_state.infos[i].result) {
+			ret = check_state.infos[i].result;
 			goto out;
 		}
 	}
 
 out:
-	kfree(check_state);
+	rw_unlock(0, c->root);
 	return ret;
 }
 
--- a/drivers/md/bcache/btree.h
+++ b/drivers/md/bcache/btree.h
@@ -226,7 +226,7 @@ struct btree_check_info {
 	int				result;
 };
 
-#define BCH_BTR_CHKTHREAD_MAX	64
+#define BCH_BTR_CHKTHREAD_MAX	12
 struct btree_check_state {
 	struct cache_set		*c;
 	int				total_threads;


