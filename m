Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06E745417FE
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358610AbiFGVHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377448AbiFGU7t (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:59:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373D320C278;
        Tue,  7 Jun 2022 11:45:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29C0561295;
        Tue,  7 Jun 2022 18:45:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3C1C385A5;
        Tue,  7 Jun 2022 18:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627499;
        bh=wEN67JUF7h90gFRJYEPgOYbXPQQrDcNRic4aTK3LJmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RiI/2K2NALua44dQYWsRful3aWEBubsA4t3cBTpxg5/CYOIgFuJVYt1mIVkRbaSQO
         62SAo2ZTrtD/b9glQkMOhiPFkdN1WZmx/83evsd7UzAmszhuBZFzR7GBiXFg9KQACy
         fWUsoctoJ9wj59qYe3IxpojNEmHDt4yfhxaeo15g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.17 735/772] bcache: remove incremental dirty sector counting for bch_sectors_dirty_init()
Date:   Tue,  7 Jun 2022 19:05:27 +0200
Message-Id: <20220607165010.696584347@linuxfoundation.org>
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

commit 80db4e4707e78cb22287da7d058d7274bd4cb370 upstream.

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
Link: https://lore.kernel.org/r/20220524102336.10684-4-colyli@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/bcache/writeback.c |   39 ++++++++++++---------------------------
 1 file changed, 12 insertions(+), 27 deletions(-)

--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -802,13 +802,11 @@ static int bch_writeback_thread(void *ar
 
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
@@ -824,11 +822,8 @@ static int sectors_dirty_init_fn(struct
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
@@ -843,24 +838,16 @@ static int bch_root_node_dirty_init(stru
 	bch_btree_op_init(&op.op, -1);
 	op.inode = d->id;
 	op.count = 0;
-	op.start = KEY(op.inode, 0, 0);
 
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
@@ -904,7 +891,6 @@ static int bch_dirty_init_thread(void *a
 				goto out;
 			}
 			skip_nr--;
-			cond_resched();
 		}
 
 		if (p) {
@@ -914,7 +900,6 @@ static int bch_dirty_init_thread(void *a
 
 		p = NULL;
 		prev_idx = cur_idx;
-		cond_resched();
 	}
 
 out:
@@ -953,11 +938,11 @@ void bch_sectors_dirty_init(struct bcach
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


