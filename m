Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 182C3541719
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377664AbiFGU6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377482AbiFGU6j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:58:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A93207ED3;
        Tue,  7 Jun 2022 11:44:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6AE1DB8220B;
        Tue,  7 Jun 2022 18:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D964AC385A5;
        Tue,  7 Jun 2022 18:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627469;
        bh=aRlPwxNLkZg+TDcv3cXKRr+RZS2yV2FCDnrg7jiN4go=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kaC/P9oh44RsaEY3tXwiF2UvRgcPYaOxogH6YwXnu2Nm+ijozGpP7UBNwofow+50P
         ZsnEOkOT6JG9qg+s9cBuwAb7ShU3Cx5JgGnJo+reQibaUNwqePS1jZof5NR+vEXCb4
         Yum10v2qiIrBQM/Kct4RI/6R/xKdr2iECXG7vTLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.17 734/772] bcache: improve multithreaded bch_sectors_dirty_init()
Date:   Tue,  7 Jun 2022 19:05:26 +0200
Message-Id: <20220607165010.667985567@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

commit 4dc34ae1b45fe26e772a44379f936c72623dd407 upstream.

Commit b144e45fc576 ("bcache: make bch_sectors_dirty_init() to be
multithreaded") makes bch_sectors_dirty_init() to be much faster
when counting dirty sectors by iterating all dirty keys in the btree.
But it isn't in ideal shape yet, still can be improved.

This patch does the following changes to improve current parallel dirty
keys iteration on the btree,
- Add read lock to root node when multiple threads iterating the btree,
  to prevent the root node gets split by I/Os from other registered
  bcache devices.
- Remove local variable "char name[32]" and generate kernel thread name
  string directly when calling kthread_run().
- Allocate "struct bch_dirty_init_state state" directly on stack and
  avoid the unnecessary dynamic memory allocation for it.
- Decrease BCH_DIRTY_INIT_THRD_MAX from 64 to 12 which is enough indeed.
- Increase &state->started to count created kernel thread after it
  succeeds to create.
- When wait for all dirty key counting threads to finish, use
  wait_event() to replace wait_event_interruptible().

With the above changes, the code is more clear, and some potential error
conditions are avoided.

Fixes: b144e45fc576 ("bcache: make bch_sectors_dirty_init() to be multithreaded")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220524102336.10684-3-colyli@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/bcache/writeback.c |   60 ++++++++++++++++--------------------------
 drivers/md/bcache/writeback.h |    2 -
 2 files changed, 25 insertions(+), 37 deletions(-)

--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -945,10 +945,10 @@ void bch_sectors_dirty_init(struct bcach
 	struct btree_iter iter;
 	struct sectors_dirty_init op;
 	struct cache_set *c = d->c;
-	struct bch_dirty_init_state *state;
-	char name[32];
+	struct bch_dirty_init_state state;
 
 	/* Just count root keys if no leaf node */
+	rw_lock(0, c->root, c->root->level);
 	if (c->root->level == 0) {
 		bch_btree_op_init(&op.op, -1);
 		op.inode = d->id;
@@ -958,54 +958,42 @@ void bch_sectors_dirty_init(struct bcach
 		for_each_key_filter(&c->root->keys,
 				    k, &iter, bch_ptr_invalid)
 			sectors_dirty_init_fn(&op.op, c->root, k);
+		rw_unlock(0, c->root);
 		return;
 	}
 
-	state = kzalloc(sizeof(struct bch_dirty_init_state), GFP_KERNEL);
-	if (!state) {
-		pr_warn("sectors dirty init failed: cannot allocate memory\n");
-		return;
-	}
+	state.c = c;
+	state.d = d;
+	state.total_threads = bch_btre_dirty_init_thread_nr();
+	state.key_idx = 0;
+	spin_lock_init(&state.idx_lock);
+	atomic_set(&state.started, 0);
+	atomic_set(&state.enough, 0);
+	init_waitqueue_head(&state.wait);
 
-	state->c = c;
-	state->d = d;
-	state->total_threads = bch_btre_dirty_init_thread_nr();
-	state->key_idx = 0;
-	spin_lock_init(&state->idx_lock);
-	atomic_set(&state->started, 0);
-	atomic_set(&state->enough, 0);
-	init_waitqueue_head(&state->wait);
-
-	for (i = 0; i < state->total_threads; i++) {
-		/* Fetch latest state->enough earlier */
+	for (i = 0; i < state.total_threads; i++) {
+		/* Fetch latest state.enough earlier */
 		smp_mb__before_atomic();
-		if (atomic_read(&state->enough))
+		if (atomic_read(&state.enough))
 			break;
 
-		state->infos[i].state = state;
-		atomic_inc(&state->started);
-		snprintf(name, sizeof(name), "bch_dirty_init[%d]", i);
-
-		state->infos[i].thread =
-			kthread_run(bch_dirty_init_thread,
-				    &state->infos[i],
-				    name);
-		if (IS_ERR(state->infos[i].thread)) {
+		state.infos[i].state = &state;
+		state.infos[i].thread =
+			kthread_run(bch_dirty_init_thread, &state.infos[i],
+				    "bch_dirtcnt[%d]", i);
+		if (IS_ERR(state.infos[i].thread)) {
 			pr_err("fails to run thread bch_dirty_init[%d]\n", i);
 			for (--i; i >= 0; i--)
-				kthread_stop(state->infos[i].thread);
+				kthread_stop(state.infos[i].thread);
 			goto out;
 		}
+		atomic_inc(&state.started);
 	}
 
-	/*
-	 * Must wait for all threads to stop.
-	 */
-	wait_event_interruptible(state->wait,
-		 atomic_read(&state->started) == 0);
-
 out:
-	kfree(state);
+	/* Must wait for all threads to stop. */
+	wait_event(state.wait, atomic_read(&state.started) == 0);
+	rw_unlock(0, c->root);
 }
 
 void bch_cached_dev_writeback_init(struct cached_dev *dc)
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -20,7 +20,7 @@
 #define BCH_WRITEBACK_FRAGMENT_THRESHOLD_MID 57
 #define BCH_WRITEBACK_FRAGMENT_THRESHOLD_HIGH 64
 
-#define BCH_DIRTY_INIT_THRD_MAX	64
+#define BCH_DIRTY_INIT_THRD_MAX	12
 /*
  * 14 (16384ths) is chosen here as something that each backing device
  * should be a reasonable fraction of the share, and not to blow up


