Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5197853277B
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 12:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236060AbiEXKYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 06:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236055AbiEXKYB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 06:24:01 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80EF8B09F;
        Tue, 24 May 2022 03:24:00 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 9506621A33;
        Tue, 24 May 2022 10:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653387839; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9kjfZ17/ruoaTQnJvYhTQS9cRBP4eTRXwhgVvBnbNYg=;
        b=oSHxcOdjt49hLLYzL9q+838dBG9MHwh9kgdH4B0UNRo6irv687YY7y4FfGdH5rN2bOILRe
        ojAzUE9V+g84+cZVOIG4aPps9lYg0fyA4eNReOEJKqK7AeKv6/pSBOZndyEvy9zuwW8+rt
        H9Lala7u54oiOe3tdaoLKcS3GDJ+Ws8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653387839;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9kjfZ17/ruoaTQnJvYhTQS9cRBP4eTRXwhgVvBnbNYg=;
        b=aZuP0r6rUyfq51A2vzbvsWw8LB8ykyS4mOtSN/xymIyr82a1tlszPUj4x1nlpSbgUqQ352
        GfWcsJfbkC3TFDCA==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id E27122C141;
        Tue, 24 May 2022 10:23:57 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, stable@vger.kernel.org
Subject: [PATCH 3/4] bcache: remove incremental dirty sector counting for bch_sectors_dirty_init()
Date:   Tue, 24 May 2022 18:23:35 +0800
Message-Id: <20220524102336.10684-4-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220524102336.10684-1-colyli@suse.de>
References: <20220524102336.10684-1-colyli@suse.de>
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

After making bch_sectors_dirty_init() being multithreaded, the existing
incremental dirty sector counting in bch_root_node_dirty_init() doesn't
release btree occupation after iterating 500000 (INIT_KEYS_EACH_TIME)
bkeys. Because a read lock is added on btree root node to prevent the
btree to be split during the dirty sectors counting, other I/O requester
has no chance to gain the write lock even restart bcache_btree().

That is to say, the incremental dirty sectors counting is incompatible
to the multhreaded bch_sectors_dirty_init(). We have to choose one and
drop another one.

In my testing, with 512 bytes random writes, I generate 1.2T dirty data
and a btree with 400K nodes. With single thread and incremental dirty
sectors counting, it takes 30+ minites to register the backing device.
And with multithreaded dirty sectors counting, the backing device
registration can be accomplished within 2 minutes.

The 30+ minutes V.S. 2- minutes difference makes me decide to keep
multithreaded bch_sectors_dirty_init() and drop the incremental dirty
sectors counting. This is what this patch does.

But INIT_KEYS_EACH_TIME is kept, in sectors_dirty_init_fn() the CPU
will be released by cond_resched() after every INIT_KEYS_EACH_TIME keys
iterated. This is to avoid the watchdog reports a bogus soft lockup
warning.

Fixes: b144e45fc576 ("bcache: make bch_sectors_dirty_init() to be multithreaded")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org
---
 drivers/md/bcache/writeback.c | 41 +++++++++++------------------------
 1 file changed, 13 insertions(+), 28 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index d24c09490f8e..75b71199800d 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -805,13 +805,11 @@ static int bch_writeback_thread(void *arg)
 
 /* Init */
 #define INIT_KEYS_EACH_TIME	500000
-#define INIT_KEYS_SLEEP_MS	100
 
 struct sectors_dirty_init {
 	struct btree_op	op;
 	unsigned int	inode;
 	size_t		count;
-	struct bkey	start;
 };
 
 static int sectors_dirty_init_fn(struct btree_op *_op, struct btree *b,
@@ -827,11 +825,8 @@ static int sectors_dirty_init_fn(struct btree_op *_op, struct btree *b,
 					     KEY_START(k), KEY_SIZE(k));
 
 	op->count++;
-	if (atomic_read(&b->c->search_inflight) &&
-	    !(op->count % INIT_KEYS_EACH_TIME)) {
-		bkey_copy_key(&op->start, k);
-		return -EAGAIN;
-	}
+	if (!(op->count % INIT_KEYS_EACH_TIME))
+		cond_resched();
 
 	return MAP_CONTINUE;
 }
@@ -846,24 +841,16 @@ static int bch_root_node_dirty_init(struct cache_set *c,
 	bch_btree_op_init(&op.op, -1);
 	op.inode = d->id;
 	op.count = 0;
-	op.start = KEY(op.inode, 0, 0);
-
-	do {
-		ret = bcache_btree(map_keys_recurse,
-				   k,
-				   c->root,
-				   &op.op,
-				   &op.start,
-				   sectors_dirty_init_fn,
-				   0);
-		if (ret == -EAGAIN)
-			schedule_timeout_interruptible(
-				msecs_to_jiffies(INIT_KEYS_SLEEP_MS));
-		else if (ret < 0) {
-			pr_warn("sectors dirty init failed, ret=%d!\n", ret);
-			break;
-		}
-	} while (ret == -EAGAIN);
+
+	ret = bcache_btree(map_keys_recurse,
+			   k,
+			   c->root,
+			   &op.op,
+			   &KEY(op.inode, 0, 0),
+			   sectors_dirty_init_fn,
+			   0);
+	if (ret < 0)
+		pr_warn("sectors dirty init failed, ret=%d!\n", ret);
 
 	return ret;
 }
@@ -907,7 +894,6 @@ static int bch_dirty_init_thread(void *arg)
 				goto out;
 			}
 			skip_nr--;
-			cond_resched();
 		}
 
 		if (p) {
@@ -917,7 +903,6 @@ static int bch_dirty_init_thread(void *arg)
 
 		p = NULL;
 		prev_idx = cur_idx;
-		cond_resched();
 	}
 
 out:
@@ -956,11 +941,11 @@ void bch_sectors_dirty_init(struct bcache_device *d)
 		bch_btree_op_init(&op.op, -1);
 		op.inode = d->id;
 		op.count = 0;
-		op.start = KEY(op.inode, 0, 0);
 
 		for_each_key_filter(&c->root->keys,
 				    k, &iter, bch_ptr_invalid)
 			sectors_dirty_init_fn(&op.op, c->root, k);
+
 		rw_unlock(0, c->root);
 		return;
 	}
-- 
2.35.3

