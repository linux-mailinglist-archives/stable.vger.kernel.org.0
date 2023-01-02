Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468D665B0EE
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236024AbjABL3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:29:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbjABL24 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:28:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D617B64C5
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:28:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84292B80D1D
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:28:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7173C433EF;
        Mon,  2 Jan 2023 11:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658883;
        bh=I+KSZFo8815wudxjwwWuZ6cpOcdctx/JJt98fcXmyHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KQFfZd0k1t7KUtAtAknveoGXzmN9Zyqm7bZj7RMk2kd9D+KzhzAgVuhPr5Q/V4CD1
         5qdtoC0sFOCLLV56wiXc5gmXvU8xtZoyWnJQbyQJM8w8CwmalSc/mNHsppPh7pdYPb
         yTGhL4yWzuCwOUgefLhH/ALqVmoNWDxJqcZT+8nI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Andreas Herrmann <aherrmann@suse.de>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 05/74] blk-cgroup: cleanup the blkg_lookup family of functions
Date:   Mon,  2 Jan 2023 12:21:38 +0100
Message-Id: <20230102110552.286732948@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 4a69f325aa43847e0827fbfe4b3623307b0c9baa ]

Add a fully inlined blkg_lookup as the extra two checks aren't going
to generated a lot more code vs the call to the slowpath routine, and
open code the hint update in the two callers that care.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Andreas Herrmann <aherrmann@suse.de>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20220921180501.1539876-5-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 813e693023ba ("blk-iolatency: Fix memory leak on add_disk() failures")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 38 +++++++++++++++-----------------------
 block/blk-cgroup.h | 39 ++++++++++++---------------------------
 2 files changed, 27 insertions(+), 50 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index ee48b6f4d5d4..f66cf1734e84 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -263,29 +263,13 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct request_queue *q,
 	return NULL;
 }
 
-struct blkcg_gq *blkg_lookup_slowpath(struct blkcg *blkcg,
-				      struct request_queue *q, bool update_hint)
+static void blkg_update_hint(struct blkcg *blkcg, struct blkcg_gq *blkg)
 {
-	struct blkcg_gq *blkg;
-
-	/*
-	 * Hint didn't match.  Look up from the radix tree.  Note that the
-	 * hint can only be updated under queue_lock as otherwise @blkg
-	 * could have already been removed from blkg_tree.  The caller is
-	 * responsible for grabbing queue_lock if @update_hint.
-	 */
-	blkg = radix_tree_lookup(&blkcg->blkg_tree, q->id);
-	if (blkg && blkg->q == q) {
-		if (update_hint) {
-			lockdep_assert_held(&q->queue_lock);
-			rcu_assign_pointer(blkcg->blkg_hint, blkg);
-		}
-		return blkg;
-	}
+	lockdep_assert_held(&blkg->q->queue_lock);
 
-	return NULL;
+	if (blkcg != &blkcg_root && blkg != rcu_dereference(blkcg->blkg_hint))
+		rcu_assign_pointer(blkcg->blkg_hint, blkg);
 }
-EXPORT_SYMBOL_GPL(blkg_lookup_slowpath);
 
 /*
  * If @new_blkg is %NULL, this function tries to allocate a new one as
@@ -397,9 +381,11 @@ static struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
 		return blkg;
 
 	spin_lock_irqsave(&q->queue_lock, flags);
-	blkg = __blkg_lookup(blkcg, q, true);
-	if (blkg)
+	blkg = blkg_lookup(blkcg, q);
+	if (blkg) {
+		blkg_update_hint(blkcg, blkg);
 		goto found;
+	}
 
 	/*
 	 * Create blkgs walking down from blkcg_root to @blkcg, so that all
@@ -621,12 +607,18 @@ static struct blkcg_gq *blkg_lookup_check(struct blkcg *blkcg,
 					  const struct blkcg_policy *pol,
 					  struct request_queue *q)
 {
+	struct blkcg_gq *blkg;
+
 	WARN_ON_ONCE(!rcu_read_lock_held());
 	lockdep_assert_held(&q->queue_lock);
 
 	if (!blkcg_policy_enabled(q, pol))
 		return ERR_PTR(-EOPNOTSUPP);
-	return __blkg_lookup(blkcg, q, true /* update_hint */);
+
+	blkg = blkg_lookup(blkcg, q);
+	if (blkg)
+		blkg_update_hint(blkcg, blkg);
+	return blkg;
 }
 
 /**
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 30396cad50e9..91b7ae0773be 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -178,8 +178,6 @@ struct blkcg_policy {
 extern struct blkcg blkcg_root;
 extern bool blkcg_debug_stats;
 
-struct blkcg_gq *blkg_lookup_slowpath(struct blkcg *blkcg,
-				      struct request_queue *q, bool update_hint);
 int blkcg_init_queue(struct request_queue *q);
 void blkcg_exit_queue(struct request_queue *q);
 
@@ -227,22 +225,21 @@ static inline bool bio_issue_as_root_blkg(struct bio *bio)
 }
 
 /**
- * __blkg_lookup - internal version of blkg_lookup()
+ * blkg_lookup - lookup blkg for the specified blkcg - q pair
  * @blkcg: blkcg of interest
  * @q: request_queue of interest
- * @update_hint: whether to update lookup hint with the result or not
  *
- * This is internal version and shouldn't be used by policy
- * implementations.  Looks up blkgs for the @blkcg - @q pair regardless of
- * @q's bypass state.  If @update_hint is %true, the caller should be
- * holding @q->queue_lock and lookup hint is updated on success.
+ * Lookup blkg for the @blkcg - @q pair.
+
+ * Must be called in a RCU critical section.
  */
-static inline struct blkcg_gq *__blkg_lookup(struct blkcg *blkcg,
-					     struct request_queue *q,
-					     bool update_hint)
+static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg,
+					   struct request_queue *q)
 {
 	struct blkcg_gq *blkg;
 
+	WARN_ON_ONCE(!rcu_read_lock_held());
+
 	if (blkcg == &blkcg_root)
 		return q->root_blkg;
 
@@ -250,22 +247,10 @@ static inline struct blkcg_gq *__blkg_lookup(struct blkcg *blkcg,
 	if (blkg && blkg->q == q)
 		return blkg;
 
-	return blkg_lookup_slowpath(blkcg, q, update_hint);
-}
-
-/**
- * blkg_lookup - lookup blkg for the specified blkcg - q pair
- * @blkcg: blkcg of interest
- * @q: request_queue of interest
- *
- * Lookup blkg for the @blkcg - @q pair.  This function should be called
- * under RCU read lock.
- */
-static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg,
-					   struct request_queue *q)
-{
-	WARN_ON_ONCE(!rcu_read_lock_held());
-	return __blkg_lookup(blkcg, q, false);
+	blkg = radix_tree_lookup(&blkcg->blkg_tree, q->id);
+	if (blkg && blkg->q != q)
+		blkg = NULL;
+	return blkg;
 }
 
 /**
-- 
2.35.1



