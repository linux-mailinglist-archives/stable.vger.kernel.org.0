Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFCC52FE77
	for <lists+stable@lfdr.de>; Sat, 21 May 2022 19:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343779AbiEURFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 May 2022 13:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiEURFO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 May 2022 13:05:14 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F5973BA5C;
        Sat, 21 May 2022 10:05:13 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 9463121B25;
        Sat, 21 May 2022 17:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653152711; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z16zL+M+oJaoh/XJ6M0tFx94DDwj/2XE3+JLveI34QU=;
        b=uz6lJIpN44MFGM8lJxwY+oscEP03Kk+Hvq9nqODdq6xUkaR7DeJkfBSZfdEu35HinlPV15
        GZZs+aWPWF4dZkm7QI1+X2hGLZRsqBFJVL9Z+V8xA1vaZEyRpwt+OPvjFWegOg5kpWchYL
        a3LsHzWh1TEi3zQL7uxXFeWn5QA6Drg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653152711;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z16zL+M+oJaoh/XJ6M0tFx94DDwj/2XE3+JLveI34QU=;
        b=zAXn8iRDIBYy1VitxtJIJYW1d1gTvQTnnE5FAT7nIc69ndHEGeoKc8t7erjnRaG0Ua4zIy
        Sqqh0hSkmfKAYsCA==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 119762C141;
        Sat, 21 May 2022 17:05:09 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        stable@vger.kernel.org
Subject: [PATCH 2/4] bcache: improve multithreaded bch_sectors_dirty_init()
Date:   Sun, 22 May 2022 01:05:00 +0800
Message-Id: <20220521170502.20026-2-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220521170502.20026-1-colyli@suse.de>
References: <20220521170502.20026-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
- Increase &state->started to count created kernel thread after it
  succeeds to create.
- When wait for all dirty key counting threads to finish, use
  wait_event() to replace wait_event_interruptible().

With the above changes, the code is more clear, and some potential error
conditions are avoided.

Fixes: b144e45fc576 ("bcache: make bch_sectors_dirty_init() to be multithreaded")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org
---
 drivers/md/bcache/writeback.c | 62 ++++++++++++++---------------------
 1 file changed, 25 insertions(+), 37 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 9ee0005874cd..d24c09490f8e 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -948,10 +948,10 @@ void bch_sectors_dirty_init(struct bcache_device *d)
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
@@ -961,54 +961,42 @@ void bch_sectors_dirty_init(struct bcache_device *d)
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
-
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
+	state.c = c;
+	state.d = d;
+	state.total_threads = bch_btre_dirty_init_thread_nr();
+	state.key_idx = 0;
+	spin_lock_init(&state.idx_lock);
+	atomic_set(&state.started, 0);
+	atomic_set(&state.enough, 0);
+	init_waitqueue_head(&state.wait);
+
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
-- 
2.35.3

