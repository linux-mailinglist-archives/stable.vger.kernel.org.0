Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F74E65D0F8
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 11:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbjADKyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 05:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234419AbjADKxx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 05:53:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D07A5FCF;
        Wed,  4 Jan 2023 02:53:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AF92B81627;
        Wed,  4 Jan 2023 10:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEAD6C433EF;
        Wed,  4 Jan 2023 10:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672829623;
        bh=IJnH9TItMLNUsL+CX3WVfYAHjoBjkevZLHy3Do7wATs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ROHgzunlzu2/1wvF6lOD21BPNot+4dG64x8nvz/8+N0JpEvJ0icCbKLQ0YX3eY67e
         DXp2c2Qm5fqCCLH3BHF90i2H3GKoL6x/OrhzX1fSnOgdUjyWg0v7y8+lhvvH6u+7hl
         BmJh2KtPxxsTIopDshepKG3KgwWTSZW7ZDuYisJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 6.0.17
Date:   Wed,  4 Jan 2023 11:53:39 +0100
Message-Id: <1672829618210230@kroah.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <167282961870246@kroah.com>
References: <167282961870246@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/trace/kprobes.rst b/Documentation/trace/kprobes.rst
index f318bceda1e6..97d086b23ce8 100644
--- a/Documentation/trace/kprobes.rst
+++ b/Documentation/trace/kprobes.rst
@@ -131,8 +131,7 @@ For example, if the function is non-recursive and is called with a
 spinlock held, maxactive = 1 should be enough.  If the function is
 non-recursive and can never relinquish the CPU (e.g., via a semaphore
 or preemption), NR_CPUS should be enough.  If maxactive <= 0, it is
-set to a default value.  If CONFIG_PREEMPT is enabled, the default
-is max(10, 2*NR_CPUS).  Otherwise, the default is NR_CPUS.
+set to a default value: max(10, 2*NR_CPUS).
 
 It's not a disaster if you set maxactive too low; you'll just miss
 some probes.  In the kretprobe struct, the nmissed field is set to
diff --git a/Makefile b/Makefile
index ff8d88b11391..a0ddac5b7caf 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 6
 PATCHLEVEL = 0
-SUBLEVEL = 16
+SUBLEVEL = 17
 EXTRAVERSION =
 NAME = Hurr durr I'ma ninja sloth
 
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 0b8a858aa847..5a873d4fbd7b 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -875,6 +875,7 @@ void __noreturn rtas_halt(void)
 
 /* Must be in the RMO region, so we place it here */
 static char rtas_os_term_buf[2048];
+static s32 ibm_os_term_token = RTAS_UNKNOWN_SERVICE;
 
 void rtas_os_term(char *str)
 {
@@ -886,16 +887,20 @@ void rtas_os_term(char *str)
 	 * this property may terminate the partition which we want to avoid
 	 * since it interferes with panic_timeout.
 	 */
-	if (RTAS_UNKNOWN_SERVICE == rtas_token("ibm,os-term") ||
-	    RTAS_UNKNOWN_SERVICE == rtas_token("ibm,extended-os-term"))
+	if (ibm_os_term_token == RTAS_UNKNOWN_SERVICE)
 		return;
 
 	snprintf(rtas_os_term_buf, 2048, "OS panic: %s", str);
 
+	/*
+	 * Keep calling as long as RTAS returns a "try again" status,
+	 * but don't use rtas_busy_delay(), which potentially
+	 * schedules.
+	 */
 	do {
-		status = rtas_call(rtas_token("ibm,os-term"), 1, 1, NULL,
+		status = rtas_call(ibm_os_term_token, 1, 1, NULL,
 				   __pa(rtas_os_term_buf));
-	} while (rtas_busy_delay(status));
+	} while (rtas_busy_delay_time(status));
 
 	if (status != 0)
 		printk(KERN_EMERG "ibm,os-term call failed %d\n", status);
@@ -1255,6 +1260,13 @@ void __init rtas_initialize(void)
 	no_entry = of_property_read_u32(rtas.dev, "linux,rtas-entry", &entry);
 	rtas.entry = no_entry ? rtas.base : entry;
 
+	/*
+	 * Discover these now to avoid device tree lookups in the
+	 * panic path.
+	 */
+	if (of_property_read_bool(rtas.dev, "ibm,extended-os-term"))
+		ibm_os_term_token = rtas_token("ibm,os-term");
+
 	/* If RTAS was found, allocate the RMO buffer for it and look for
 	 * the stop-self token if any
 	 */
diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 528ca21044a5..7d2ca122362f 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5385,8 +5385,8 @@ static void bfq_exit_icq_bfqq(struct bfq_io_cq *bic, bool is_sync)
 		unsigned long flags;
 
 		spin_lock_irqsave(&bfqd->lock, flags);
-		bfq_exit_bfqq(bfqd, bfqq);
 		bic_set_bfqq(bic, NULL, is_sync);
+		bfq_exit_bfqq(bfqd, bfqq);
 		spin_unlock_irqrestore(&bfqd->lock, flags);
 	}
 }
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index c8f0c865bf4e..ee517fb06aa6 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -33,6 +33,7 @@
 #include "blk-cgroup.h"
 #include "blk-ioprio.h"
 #include "blk-throttle.h"
+#include "blk-rq-qos.h"
 
 /*
  * blkcg_pol_mutex protects blkcg_policy[] and policy [de]activation.
@@ -263,29 +264,13 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct request_queue *q,
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
@@ -324,7 +309,7 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 
 	/* link parent */
 	if (blkcg_parent(blkcg)) {
-		blkg->parent = __blkg_lookup(blkcg_parent(blkcg), q, false);
+		blkg->parent = blkg_lookup(blkcg_parent(blkcg), q);
 		if (WARN_ON_ONCE(!blkg->parent)) {
 			ret = -ENODEV;
 			goto err_put_css;
@@ -397,9 +382,11 @@ static struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
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
@@ -412,7 +399,7 @@ static struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
 		struct blkcg_gq *ret_blkg = q->root_blkg;
 
 		while (parent) {
-			blkg = __blkg_lookup(parent, q, false);
+			blkg = blkg_lookup(parent, q);
 			if (blkg) {
 				/* remember closest blkg */
 				ret_blkg = blkg;
@@ -476,14 +463,9 @@ static void blkg_destroy(struct blkcg_gq *blkg)
 	percpu_ref_kill(&blkg->refcnt);
 }
 
-/**
- * blkg_destroy_all - destroy all blkgs associated with a request_queue
- * @q: request_queue of interest
- *
- * Destroy all blkgs associated with @q.
- */
-static void blkg_destroy_all(struct request_queue *q)
+static void blkg_destroy_all(struct gendisk *disk)
 {
+	struct request_queue *q = disk->queue;
 	struct blkcg_gq *blkg, *n;
 	int count = BLKG_DESTROY_BATCH_SIZE;
 
@@ -621,12 +603,18 @@ static struct blkcg_gq *blkg_lookup_check(struct blkcg *blkcg,
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
@@ -724,7 +712,7 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 		struct blkcg_gq *new_blkg;
 
 		parent = blkcg_parent(blkcg);
-		while (parent && !__blkg_lookup(parent, q, false)) {
+		while (parent && !blkg_lookup(parent, q)) {
 			pos = parent;
 			parent = blkcg_parent(parent);
 		}
@@ -915,8 +903,7 @@ static void blkcg_fill_root_iostats(void)
 	class_dev_iter_init(&iter, &block_class, NULL, &disk_type);
 	while ((dev = class_dev_iter_next(&iter))) {
 		struct block_device *bdev = dev_to_bdev(dev);
-		struct blkcg_gq *blkg =
-			blk_queue_root_blkg(bdev_get_queue(bdev));
+		struct blkcg_gq *blkg = bdev->bd_disk->queue->root_blkg;
 		struct blkg_iostat tmp;
 		int cpu;
 		unsigned long flags;
@@ -1255,18 +1242,9 @@ static int blkcg_css_online(struct cgroup_subsys_state *css)
 	return 0;
 }
 
-/**
- * blkcg_init_queue - initialize blkcg part of request queue
- * @q: request_queue to initialize
- *
- * Called from blk_alloc_queue(). Responsible for initializing blkcg
- * part of new request_queue @q.
- *
- * RETURNS:
- * 0 on success, -errno on failure.
- */
-int blkcg_init_queue(struct request_queue *q)
+int blkcg_init_disk(struct gendisk *disk)
 {
+	struct request_queue *q = disk->queue;
 	struct blkcg_gq *new_blkg, *blkg;
 	bool preloaded;
 	int ret;
@@ -1295,21 +1273,22 @@ int blkcg_init_queue(struct request_queue *q)
 	if (ret)
 		goto err_destroy_all;
 
-	ret = blk_throtl_init(q);
+	ret = blk_throtl_init(disk);
 	if (ret)
-		goto err_destroy_all;
+		goto err_ioprio_exit;
 
 	ret = blk_iolatency_init(q);
-	if (ret) {
-		blk_throtl_exit(q);
-		blk_ioprio_exit(q);
-		goto err_destroy_all;
-	}
+	if (ret)
+		goto err_throtl_exit;
 
 	return 0;
 
+err_throtl_exit:
+	blk_throtl_exit(disk);
+err_ioprio_exit:
+	blk_ioprio_exit(q);
 err_destroy_all:
-	blkg_destroy_all(q);
+	blkg_destroy_all(disk);
 	return ret;
 err_unlock:
 	spin_unlock_irq(&q->queue_lock);
@@ -1318,16 +1297,11 @@ int blkcg_init_queue(struct request_queue *q)
 	return PTR_ERR(blkg);
 }
 
-/**
- * blkcg_exit_queue - exit and release blkcg part of request_queue
- * @q: request_queue being released
- *
- * Called from blk_exit_queue().  Responsible for exiting blkcg part.
- */
-void blkcg_exit_queue(struct request_queue *q)
+void blkcg_exit_disk(struct gendisk *disk)
 {
-	blkg_destroy_all(q);
-	blk_throtl_exit(q);
+	blkg_destroy_all(disk);
+	rq_qos_exit(disk->queue);
+	blk_throtl_exit(disk);
 }
 
 static void blkcg_bind(struct cgroup_subsys_state *root_css)
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index d2724d1dd7c9..aa2b286bc825 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -178,10 +178,8 @@ struct blkcg_policy {
 extern struct blkcg blkcg_root;
 extern bool blkcg_debug_stats;
 
-struct blkcg_gq *blkg_lookup_slowpath(struct blkcg *blkcg,
-				      struct request_queue *q, bool update_hint);
-int blkcg_init_queue(struct request_queue *q);
-void blkcg_exit_queue(struct request_queue *q);
+int blkcg_init_disk(struct gendisk *disk);
+void blkcg_exit_disk(struct gendisk *disk);
 
 /* Blkio controller policy registration */
 int blkcg_policy_register(struct blkcg_policy *pol);
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
 
@@ -250,33 +247,10 @@ static inline struct blkcg_gq *__blkg_lookup(struct blkcg *blkcg,
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
-}
-
-/**
- * blk_queue_root_blkg - return blkg for the (blkcg_root, @q) pair
- * @q: request_queue of interest
- *
- * Lookup blkg for @q at the root level. See also blkg_lookup().
- */
-static inline struct blkcg_gq *blk_queue_root_blkg(struct request_queue *q)
-{
-	return q->root_blkg;
+	blkg = radix_tree_lookup(&blkcg->blkg_tree, q->id);
+	if (blkg && blkg->q != q)
+		blkg = NULL;
+	return blkg;
 }
 
 /**
@@ -373,8 +347,8 @@ static inline void blkg_put(struct blkcg_gq *blkg)
  */
 #define blkg_for_each_descendant_pre(d_blkg, pos_css, p_blkg)		\
 	css_for_each_descendant_pre((pos_css), &(p_blkg)->blkcg->css)	\
-		if (((d_blkg) = __blkg_lookup(css_to_blkcg(pos_css),	\
-					      (p_blkg)->q, false)))
+		if (((d_blkg) = blkg_lookup(css_to_blkcg(pos_css),	\
+					    (p_blkg)->q)))
 
 /**
  * blkg_for_each_descendant_post - post-order walk of a blkg's descendants
@@ -388,8 +362,8 @@ static inline void blkg_put(struct blkcg_gq *blkg)
  */
 #define blkg_for_each_descendant_post(d_blkg, pos_css, p_blkg)		\
 	css_for_each_descendant_post((pos_css), &(p_blkg)->blkcg->css)	\
-		if (((d_blkg) = __blkg_lookup(css_to_blkcg(pos_css),	\
-					      (p_blkg)->q, false)))
+		if (((d_blkg) = blkg_lookup(css_to_blkcg(pos_css),	\
+					    (p_blkg)->q)))
 
 bool __blkcg_punt_bio_submit(struct bio *bio);
 
@@ -507,10 +481,8 @@ struct blkcg {
 };
 
 static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg, void *key) { return NULL; }
-static inline struct blkcg_gq *blk_queue_root_blkg(struct request_queue *q)
-{ return NULL; }
-static inline int blkcg_init_queue(struct request_queue *q) { return 0; }
-static inline void blkcg_exit_queue(struct request_queue *q) { }
+static inline int blkcg_init_disk(struct gendisk *disk) { return 0; }
+static inline void blkcg_exit_disk(struct gendisk *disk) { }
 static inline int blkcg_policy_register(struct blkcg_policy *pol) { return 0; }
 static inline void blkcg_policy_unregister(struct blkcg_policy *pol) { }
 static inline int blkcg_activate_policy(struct request_queue *q,
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 35cf744ea9d1..f84a6ed440c9 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2276,8 +2276,9 @@ void blk_throtl_bio_endio(struct bio *bio)
 }
 #endif
 
-int blk_throtl_init(struct request_queue *q)
+int blk_throtl_init(struct gendisk *disk)
 {
+	struct request_queue *q = disk->queue;
 	struct throtl_data *td;
 	int ret;
 
@@ -2319,8 +2320,10 @@ int blk_throtl_init(struct request_queue *q)
 	return ret;
 }
 
-void blk_throtl_exit(struct request_queue *q)
+void blk_throtl_exit(struct gendisk *disk)
 {
+	struct request_queue *q = disk->queue;
+
 	BUG_ON(!q->td);
 	del_timer_sync(&q->td->service_queue.pending_timer);
 	throtl_shutdown_wq(q);
diff --git a/block/blk-throttle.h b/block/blk-throttle.h
index ee7299e6dea9..e8c2b3d4a18b 100644
--- a/block/blk-throttle.h
+++ b/block/blk-throttle.h
@@ -159,14 +159,14 @@ static inline struct throtl_grp *blkg_to_tg(struct blkcg_gq *blkg)
  * Internal throttling interface
  */
 #ifndef CONFIG_BLK_DEV_THROTTLING
-static inline int blk_throtl_init(struct request_queue *q) { return 0; }
-static inline void blk_throtl_exit(struct request_queue *q) { }
+static inline int blk_throtl_init(struct gendisk *disk) { return 0; }
+static inline void blk_throtl_exit(struct gendisk *disk) { }
 static inline void blk_throtl_register_queue(struct request_queue *q) { }
 static inline bool blk_throtl_bio(struct bio *bio) { return false; }
 static inline void blk_throtl_cancel_bios(struct request_queue *q) { }
 #else /* CONFIG_BLK_DEV_THROTTLING */
-int blk_throtl_init(struct request_queue *q);
-void blk_throtl_exit(struct request_queue *q);
+int blk_throtl_init(struct gendisk *disk);
+void blk_throtl_exit(struct gendisk *disk);
 void blk_throtl_register_queue(struct request_queue *q);
 bool __blk_throtl_bio(struct bio *bio);
 void blk_throtl_cancel_bios(struct request_queue *q);
diff --git a/block/blk.h b/block/blk.h
index ff0bec16f0fa..c24afffc3678 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -429,7 +429,7 @@ static inline struct kmem_cache *blk_get_queue_kmem_cache(bool srcu)
 }
 struct request_queue *blk_alloc_queue(int node_id, bool alloc_srcu);
 
-int disk_scan_partitions(struct gendisk *disk, fmode_t mode);
+int disk_scan_partitions(struct gendisk *disk, fmode_t mode, void *owner);
 
 int disk_alloc_events(struct gendisk *disk);
 void disk_add_events(struct gendisk *disk);
diff --git a/block/genhd.c b/block/genhd.c
index 28654723bc2b..a7b962303195 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -356,7 +356,7 @@ void disk_uevent(struct gendisk *disk, enum kobject_action action)
 }
 EXPORT_SYMBOL_GPL(disk_uevent);
 
-int disk_scan_partitions(struct gendisk *disk, fmode_t mode)
+int disk_scan_partitions(struct gendisk *disk, fmode_t mode, void *owner)
 {
 	struct block_device *bdev;
 
@@ -366,6 +366,9 @@ int disk_scan_partitions(struct gendisk *disk, fmode_t mode)
 		return -EINVAL;
 	if (disk->open_partitions)
 		return -EBUSY;
+	/* Someone else has bdev exclusively open? */
+	if (disk->part0->bd_holder && disk->part0->bd_holder != owner)
+		return -EBUSY;
 
 	set_bit(GD_NEED_PART_SCAN, &disk->state);
 	bdev = blkdev_get_by_dev(disk_devt(disk), mode, NULL);
@@ -499,7 +502,7 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
 
 		bdev_add(disk->part0, ddev->devt);
 		if (get_capacity(disk))
-			disk_scan_partitions(disk, FMODE_READ);
+			disk_scan_partitions(disk, FMODE_READ, NULL);
 
 		/*
 		 * Announce the disk and partitions after all partitions are
@@ -1154,7 +1157,8 @@ static void disk_release(struct device *dev)
 	    !test_bit(GD_ADDED, &disk->state))
 		blk_mq_exit_queue(disk->queue);
 
-	blkcg_exit_queue(disk->queue);
+	blkcg_exit_disk(disk);
+
 	bioset_exit(&disk->bio_split);
 
 	disk_release_events(disk);
@@ -1367,7 +1371,7 @@ struct gendisk *__alloc_disk_node(struct request_queue *q, int node_id,
 	if (xa_insert(&disk->part_tbl, 0, disk->part0, GFP_KERNEL))
 		goto out_destroy_part_tbl;
 
-	if (blkcg_init_queue(q))
+	if (blkcg_init_disk(disk))
 		goto out_erase_part0;
 
 	rand_initialize_disk(disk);
diff --git a/block/ioctl.c b/block/ioctl.c
index 60121e89052b..96617512982e 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -467,9 +467,10 @@ static int blkdev_bszset(struct block_device *bdev, fmode_t mode,
  * user space. Note the separate arg/argp parameters that are needed
  * to deal with the compat_ptr() conversion.
  */
-static int blkdev_common_ioctl(struct block_device *bdev, fmode_t mode,
-				unsigned cmd, unsigned long arg, void __user *argp)
+static int blkdev_common_ioctl(struct file *file, fmode_t mode, unsigned cmd,
+			       unsigned long arg, void __user *argp)
 {
+	struct block_device *bdev = I_BDEV(file->f_mapping->host);
 	unsigned int max_sectors;
 
 	switch (cmd) {
@@ -527,7 +528,8 @@ static int blkdev_common_ioctl(struct block_device *bdev, fmode_t mode,
 			return -EACCES;
 		if (bdev_is_partition(bdev))
 			return -EINVAL;
-		return disk_scan_partitions(bdev->bd_disk, mode & ~FMODE_EXCL);
+		return disk_scan_partitions(bdev->bd_disk, mode & ~FMODE_EXCL,
+					    file);
 	case BLKTRACESTART:
 	case BLKTRACESTOP:
 	case BLKTRACETEARDOWN:
@@ -605,7 +607,7 @@ long blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 		break;
 	}
 
-	ret = blkdev_common_ioctl(bdev, mode, cmd, arg, argp);
+	ret = blkdev_common_ioctl(file, mode, cmd, arg, argp);
 	if (ret != -ENOIOCTLCMD)
 		return ret;
 
@@ -674,7 +676,7 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 		break;
 	}
 
-	ret = blkdev_common_ioctl(bdev, mode, cmd, arg, argp);
+	ret = blkdev_common_ioctl(file, mode, cmd, arg, argp);
 	if (ret == -ENOIOCTLCMD && disk->fops->compat_ioctl)
 		ret = disk->fops->compat_ioctl(bdev, mode, cmd, arg);
 
diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 510cdec375c4..98daea0db979 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -399,16 +399,68 @@ static const struct dmi_system_id medion_laptop[] = {
 	{ }
 };
 
+static const struct dmi_system_id asus_laptop[] = {
+	{
+		.ident = "Asus Vivobook K3402ZA",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "K3402ZA"),
+		},
+	},
+	{
+		.ident = "Asus Vivobook K3502ZA",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "K3502ZA"),
+		},
+	},
+	{ }
+};
+
+static const struct dmi_system_id lenovo_laptop[] = {
+	{
+		.ident = "LENOVO IdeaPad Flex 5 14ALC7",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "82R9"),
+		},
+	},
+	{
+		.ident = "LENOVO IdeaPad Flex 5 16ALC7",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "82RA"),
+		},
+	},
+	{ }
+};
+
+static const struct dmi_system_id schenker_gm_rg[] = {
+	{
+		.ident = "XMG CORE 15 (M22)",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SchenkerTechnologiesGmbH"),
+			DMI_MATCH(DMI_BOARD_NAME, "GMxRGxx"),
+		},
+	},
+	{ }
+};
+
 struct irq_override_cmp {
 	const struct dmi_system_id *system;
 	unsigned char irq;
 	unsigned char triggering;
 	unsigned char polarity;
 	unsigned char shareable;
+	bool override;
 };
 
-static const struct irq_override_cmp skip_override_table[] = {
-	{ medion_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0 },
+static const struct irq_override_cmp override_table[] = {
+	{ medion_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, false },
+	{ asus_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, false },
+	{ lenovo_laptop, 6, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, true },
+	{ lenovo_laptop, 10, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, true },
+	{ schenker_gm_rg, 1, ACPI_EDGE_SENSITIVE, ACPI_ACTIVE_LOW, 1, true },
 };
 
 static bool acpi_dev_irq_override(u32 gsi, u8 triggering, u8 polarity,
@@ -416,6 +468,17 @@ static bool acpi_dev_irq_override(u32 gsi, u8 triggering, u8 polarity,
 {
 	int i;
 
+	for (i = 0; i < ARRAY_SIZE(override_table); i++) {
+		const struct irq_override_cmp *entry = &override_table[i];
+
+		if (dmi_check_system(entry->system) &&
+		    entry->irq == gsi &&
+		    entry->triggering == triggering &&
+		    entry->polarity == polarity &&
+		    entry->shareable == shareable)
+			return entry->override;
+	}
+
 #ifdef CONFIG_X86
 	/*
 	 * IRQ override isn't needed on modern AMD Zen systems and
@@ -426,17 +489,6 @@ static bool acpi_dev_irq_override(u32 gsi, u8 triggering, u8 polarity,
 		return false;
 #endif
 
-	for (i = 0; i < ARRAY_SIZE(skip_override_table); i++) {
-		const struct irq_override_cmp *entry = &skip_override_table[i];
-
-		if (dmi_check_system(entry->system) &&
-		    entry->irq == gsi &&
-		    entry->triggering == triggering &&
-		    entry->polarity == polarity &&
-		    entry->shareable == shareable)
-			return false;
-	}
-
 	return true;
 }
 
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index c1eca72b4575..28d8c56cb4dd 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -84,6 +84,7 @@ enum board_ids {
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 static void ahci_remove_one(struct pci_dev *dev);
 static void ahci_shutdown_one(struct pci_dev *dev);
+static void ahci_intel_pcs_quirk(struct pci_dev *pdev, struct ahci_host_priv *hpriv);
 static int ahci_vt8251_hardreset(struct ata_link *link, unsigned int *class,
 				 unsigned long deadline);
 static int ahci_avn_hardreset(struct ata_link *link, unsigned int *class,
@@ -677,6 +678,25 @@ static void ahci_pci_save_initial_config(struct pci_dev *pdev,
 	ahci_save_initial_config(&pdev->dev, hpriv);
 }
 
+static int ahci_pci_reset_controller(struct ata_host *host)
+{
+	struct pci_dev *pdev = to_pci_dev(host->dev);
+	struct ahci_host_priv *hpriv = host->private_data;
+	int rc;
+
+	rc = ahci_reset_controller(host);
+	if (rc)
+		return rc;
+
+	/*
+	 * If platform firmware failed to enable ports, try to enable
+	 * them here.
+	 */
+	ahci_intel_pcs_quirk(pdev, hpriv);
+
+	return 0;
+}
+
 static void ahci_pci_init_controller(struct ata_host *host)
 {
 	struct ahci_host_priv *hpriv = host->private_data;
@@ -871,7 +891,7 @@ static int ahci_pci_device_runtime_resume(struct device *dev)
 	struct ata_host *host = pci_get_drvdata(pdev);
 	int rc;
 
-	rc = ahci_reset_controller(host);
+	rc = ahci_pci_reset_controller(host);
 	if (rc)
 		return rc;
 	ahci_pci_init_controller(host);
@@ -907,7 +927,7 @@ static int ahci_pci_device_resume(struct device *dev)
 		ahci_mcp89_apple_enable(pdev);
 
 	if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
-		rc = ahci_reset_controller(host);
+		rc = ahci_pci_reset_controller(host);
 		if (rc)
 			return rc;
 
@@ -1788,12 +1808,6 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* save initial config */
 	ahci_pci_save_initial_config(pdev, hpriv);
 
-	/*
-	 * If platform firmware failed to enable ports, try to enable
-	 * them here.
-	 */
-	ahci_intel_pcs_quirk(pdev, hpriv);
-
 	/* prepare host */
 	if (hpriv->cap & HOST_CAP_NCQ) {
 		pi.flags |= ATA_FLAG_NCQ;
@@ -1903,7 +1917,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
-	rc = ahci_reset_controller(host);
+	rc = ahci_pci_reset_controller(host);
 	if (rc)
 		return rc;
 
diff --git a/drivers/char/tpm/eventlog/acpi.c b/drivers/char/tpm/eventlog/acpi.c
index 1b18ce5ebab1..0913d3eb8d51 100644
--- a/drivers/char/tpm/eventlog/acpi.c
+++ b/drivers/char/tpm/eventlog/acpi.c
@@ -90,16 +90,21 @@ int tpm_read_log_acpi(struct tpm_chip *chip)
 			return -ENODEV;
 
 		if (tbl->header.length <
-				sizeof(*tbl) + sizeof(struct acpi_tpm2_phy))
+				sizeof(*tbl) + sizeof(struct acpi_tpm2_phy)) {
+			acpi_put_table((struct acpi_table_header *)tbl);
 			return -ENODEV;
+		}
 
 		tpm2_phy = (void *)tbl + sizeof(*tbl);
 		len = tpm2_phy->log_area_minimum_length;
 
 		start = tpm2_phy->log_area_start_address;
-		if (!start || !len)
+		if (!start || !len) {
+			acpi_put_table((struct acpi_table_header *)tbl);
 			return -ENODEV;
+		}
 
+		acpi_put_table((struct acpi_table_header *)tbl);
 		format = EFI_TCG2_EVENT_LOG_FORMAT_TCG_2;
 	} else {
 		/* Find TCPA entry in RSDT (ACPI_LOGICAL_ADDRESSING) */
@@ -120,8 +125,10 @@ int tpm_read_log_acpi(struct tpm_chip *chip)
 			break;
 		}
 
+		acpi_put_table((struct acpi_table_header *)buff);
 		format = EFI_TCG2_EVENT_LOG_FORMAT_TCG_1_2;
 	}
+
 	if (!len) {
 		dev_warn(&chip->dev, "%s: TCPA log area empty\n", __func__);
 		return -EIO;
@@ -156,5 +163,4 @@ int tpm_read_log_acpi(struct tpm_chip *chip)
 	kfree(log->bios_event_log);
 	log->bios_event_log = NULL;
 	return ret;
-
 }
diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 65f8f179a27f..16fc481d6095 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -676,12 +676,16 @@ static int crb_acpi_add(struct acpi_device *device)
 
 	/* Should the FIFO driver handle this? */
 	sm = buf->start_method;
-	if (sm == ACPI_TPM2_MEMORY_MAPPED)
-		return -ENODEV;
+	if (sm == ACPI_TPM2_MEMORY_MAPPED) {
+		rc = -ENODEV;
+		goto out;
+	}
 
 	priv = devm_kzalloc(dev, sizeof(struct crb_priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
+	if (!priv) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	if (sm == ACPI_TPM2_COMMAND_BUFFER_WITH_ARM_SMC) {
 		if (buf->header.length < (sizeof(*buf) + sizeof(*crb_smc))) {
@@ -689,7 +693,8 @@ static int crb_acpi_add(struct acpi_device *device)
 				FW_BUG "TPM2 ACPI table has wrong size %u for start method type %d\n",
 				buf->header.length,
 				ACPI_TPM2_COMMAND_BUFFER_WITH_ARM_SMC);
-			return -EINVAL;
+			rc = -EINVAL;
+			goto out;
 		}
 		crb_smc = ACPI_ADD_PTR(struct tpm2_crb_smc, buf, sizeof(*buf));
 		priv->smc_func_id = crb_smc->smc_func_id;
@@ -700,17 +705,23 @@ static int crb_acpi_add(struct acpi_device *device)
 
 	rc = crb_map_io(device, priv, buf);
 	if (rc)
-		return rc;
+		goto out;
 
 	chip = tpmm_chip_alloc(dev, &tpm_crb);
-	if (IS_ERR(chip))
-		return PTR_ERR(chip);
+	if (IS_ERR(chip)) {
+		rc = PTR_ERR(chip);
+		goto out;
+	}
 
 	dev_set_drvdata(&chip->dev, priv);
 	chip->acpi_dev_handle = device->handle;
 	chip->flags = TPM_CHIP_FLAG_TPM2;
 
-	return tpm_chip_register(chip);
+	rc = tpm_chip_register(chip);
+
+out:
+	acpi_put_table((struct acpi_table_header *)buf);
+	return rc;
 }
 
 static int crb_acpi_remove(struct acpi_device *device)
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index bcff6429e0b4..ed5dabd3c72d 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -125,6 +125,7 @@ static int check_acpi_tpm2(struct device *dev)
 	const struct acpi_device_id *aid = acpi_match_device(tpm_acpi_tbl, dev);
 	struct acpi_table_tpm2 *tbl;
 	acpi_status st;
+	int ret = 0;
 
 	if (!aid || aid->driver_data != DEVICE_IS_TPM2)
 		return 0;
@@ -132,8 +133,7 @@ static int check_acpi_tpm2(struct device *dev)
 	/* If the ACPI TPM2 signature is matched then a global ACPI_SIG_TPM2
 	 * table is mandatory
 	 */
-	st =
-	    acpi_get_table(ACPI_SIG_TPM2, 1, (struct acpi_table_header **)&tbl);
+	st = acpi_get_table(ACPI_SIG_TPM2, 1, (struct acpi_table_header **)&tbl);
 	if (ACPI_FAILURE(st) || tbl->header.length < sizeof(*tbl)) {
 		dev_err(dev, FW_BUG "failed to get TPM2 ACPI table\n");
 		return -EINVAL;
@@ -141,9 +141,10 @@ static int check_acpi_tpm2(struct device *dev)
 
 	/* The tpm2_crb driver handles this device */
 	if (tbl->start_method != ACPI_TPM2_MEMORY_MAPPED)
-		return -ENODEV;
+		ret = -ENODEV;
 
-	return 0;
+	acpi_put_table((struct acpi_table_header *)tbl);
+	return ret;
 }
 #else
 static int check_acpi_tpm2(struct device *dev)
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 86e754b9400f..5680543e97fd 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -995,7 +995,10 @@
 #define USB_DEVICE_ID_ORTEK_IHOME_IMAC_A210S	0x8003
 
 #define USB_VENDOR_ID_PLANTRONICS	0x047f
+#define USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3210_SERIES	0xc055
 #define USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3220_SERIES	0xc056
+#define USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3215_SERIES	0xc057
+#define USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3225_SERIES	0xc058
 
 #define USB_VENDOR_ID_PANASONIC		0x04da
 #define USB_DEVICE_ID_PANABOARD_UBT780	0x1044
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 91a4d3fc30e0..372cbdd223e0 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1967,6 +1967,10 @@ static const struct hid_device_id mt_devices[] = {
 		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
 			USB_VENDOR_ID_ELAN, 0x313a) },
 
+	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT,
+		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
+			USB_VENDOR_ID_ELAN, 0x3148) },
+
 	/* Elitegroup panel */
 	{ .driver_data = MT_CLS_SERIAL,
 		MT_USB_DEVICE(USB_VENDOR_ID_ELITEGROUP,
diff --git a/drivers/hid/hid-plantronics.c b/drivers/hid/hid-plantronics.c
index e81b7cec2d12..3d414ae194ac 100644
--- a/drivers/hid/hid-plantronics.c
+++ b/drivers/hid/hid-plantronics.c
@@ -198,9 +198,18 @@ static int plantronics_probe(struct hid_device *hdev,
 }
 
 static const struct hid_device_id plantronics_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PLANTRONICS,
+					 USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3210_SERIES),
+		.driver_data = PLT_QUIRK_DOUBLE_VOLUME_KEYS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PLANTRONICS,
 					 USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3220_SERIES),
 		.driver_data = PLT_QUIRK_DOUBLE_VOLUME_KEYS },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PLANTRONICS,
+					 USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3215_SERIES),
+		.driver_data = PLT_QUIRK_DOUBLE_VOLUME_KEYS },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PLANTRONICS,
+					 USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3225_SERIES),
+		.driver_data = PLT_QUIRK_DOUBLE_VOLUME_KEYS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PLANTRONICS, HID_ANY_ID) },
 	{ }
 };
diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
index ec73720e239b..15fa380b1f84 100644
--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -452,7 +452,7 @@ static irqreturn_t mtk_iommu_isr(int irq, void *dev_id)
 		fault_larb = data->plat_data->larbid_remap[fault_larb][sub_comm];
 	}
 
-	if (report_iommu_fault(&dom->domain, bank->parent_dev, fault_iova,
+	if (!dom || report_iommu_fault(&dom->domain, bank->parent_dev, fault_iova,
 			       write ? IOMMU_FAULT_WRITE : IOMMU_FAULT_READ)) {
 		dev_err_ratelimited(
 			bank->parent_dev,
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 470a975e4be9..cd7f8e6cfc71 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -509,13 +509,14 @@ static void md_end_flush(struct bio *bio)
 	struct md_rdev *rdev = bio->bi_private;
 	struct mddev *mddev = rdev->mddev;
 
+	bio_put(bio);
+
 	rdev_dec_pending(rdev, mddev);
 
 	if (atomic_dec_and_test(&mddev->flush_pending)) {
 		/* The pre-request flush has finished */
 		queue_work(md_wq, &mddev->flush_work);
 	}
-	bio_put(bio);
 }
 
 static void md_submit_flush_data(struct work_struct *ws);
@@ -913,10 +914,12 @@ static void super_written(struct bio *bio)
 	} else
 		clear_bit(LastDev, &rdev->flags);
 
+	bio_put(bio);
+
+	rdev_dec_pending(rdev, mddev);
+
 	if (atomic_dec_and_test(&mddev->pending_writes))
 		wake_up(&mddev->sb_wait);
-	rdev_dec_pending(rdev, mddev);
-	bio_put(bio);
 }
 
 void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
diff --git a/drivers/mfd/mt6360-core.c b/drivers/mfd/mt6360-core.c
index 6eaa6775b888..d3b32eb79837 100644
--- a/drivers/mfd/mt6360-core.c
+++ b/drivers/mfd/mt6360-core.c
@@ -402,7 +402,7 @@ static int mt6360_regmap_read(void *context, const void *reg, size_t reg_size,
 	struct mt6360_ddata *ddata = context;
 	u8 bank = *(u8 *)reg;
 	u8 reg_addr = *(u8 *)(reg + 1);
-	struct i2c_client *i2c = ddata->i2c[bank];
+	struct i2c_client *i2c;
 	bool crc_needed = false;
 	u8 *buf;
 	int buf_len = MT6360_ALLOC_READ_SIZE(val_size);
@@ -410,6 +410,11 @@ static int mt6360_regmap_read(void *context, const void *reg, size_t reg_size,
 	u8 crc;
 	int ret;
 
+	if (bank >= MT6360_SLAVE_MAX)
+		return -EINVAL;
+
+	i2c = ddata->i2c[bank];
+
 	if (bank == MT6360_SLAVE_PMIC || bank == MT6360_SLAVE_LDO) {
 		crc_needed = true;
 		ret = mt6360_xlate_pmicldo_addr(&reg_addr, val_size);
@@ -453,13 +458,18 @@ static int mt6360_regmap_write(void *context, const void *val, size_t val_size)
 	struct mt6360_ddata *ddata = context;
 	u8 bank = *(u8 *)val;
 	u8 reg_addr = *(u8 *)(val + 1);
-	struct i2c_client *i2c = ddata->i2c[bank];
+	struct i2c_client *i2c;
 	bool crc_needed = false;
 	u8 *buf;
 	int buf_len = MT6360_ALLOC_WRITE_SIZE(val_size);
 	int write_size = val_size - MT6360_REGMAP_REG_BYTE_SIZE;
 	int ret;
 
+	if (bank >= MT6360_SLAVE_MAX)
+		return -EINVAL;
+
+	i2c = ddata->i2c[bank];
+
 	if (bank == MT6360_SLAVE_PMIC || bank == MT6360_SLAVE_LDO) {
 		crc_needed = true;
 		ret = mt6360_xlate_pmicldo_addr(&reg_addr, val_size - MT6360_REGMAP_REG_BYTE_SIZE);
diff --git a/drivers/mmc/host/vub300.c b/drivers/mmc/host/vub300.c
index ab36ec479747..72f65f32abbc 100644
--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -2049,6 +2049,7 @@ static void vub300_enable_sdio_irq(struct mmc_host *mmc, int enable)
 		return;
 	kref_get(&vub300->kref);
 	if (enable) {
+		set_current_state(TASK_RUNNING);
 		mutex_lock(&vub300->irq_mutex);
 		if (vub300->irqs_queued) {
 			vub300->irqs_queued -= 1;
@@ -2064,6 +2065,7 @@ static void vub300_enable_sdio_irq(struct mmc_host *mmc, int enable)
 			vub300_queue_poll_work(vub300, 0);
 		}
 		mutex_unlock(&vub300->irq_mutex);
+		set_current_state(TASK_INTERRUPTIBLE);
 	} else {
 		vub300->irq_enabled = 0;
 	}
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 6867620bcc98..529b424ef9b2 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -35,7 +35,7 @@
 #define SQ_SIZE(q)	((q)->q_depth << (q)->sqes)
 #define CQ_SIZE(q)	((q)->q_depth * sizeof(struct nvme_completion))
 
-#define SGES_PER_PAGE	(PAGE_SIZE / sizeof(struct nvme_sgl_desc))
+#define SGES_PER_PAGE	(NVME_CTRL_PAGE_SIZE / sizeof(struct nvme_sgl_desc))
 
 /*
  * These can be higher, but we need to ensure that any command doesn't
@@ -144,9 +144,9 @@ struct nvme_dev {
 	mempool_t *iod_mempool;
 
 	/* shadow doorbell buffer support: */
-	u32 *dbbuf_dbs;
+	__le32 *dbbuf_dbs;
 	dma_addr_t dbbuf_dbs_dma_addr;
-	u32 *dbbuf_eis;
+	__le32 *dbbuf_eis;
 	dma_addr_t dbbuf_eis_dma_addr;
 
 	/* host memory buffer support: */
@@ -210,10 +210,10 @@ struct nvme_queue {
 #define NVMEQ_SQ_CMB		1
 #define NVMEQ_DELETE_ERROR	2
 #define NVMEQ_POLLED		3
-	u32 *dbbuf_sq_db;
-	u32 *dbbuf_cq_db;
-	u32 *dbbuf_sq_ei;
-	u32 *dbbuf_cq_ei;
+	__le32 *dbbuf_sq_db;
+	__le32 *dbbuf_cq_db;
+	__le32 *dbbuf_sq_ei;
+	__le32 *dbbuf_cq_ei;
 	struct completion delete_done;
 };
 
@@ -340,11 +340,11 @@ static inline int nvme_dbbuf_need_event(u16 event_idx, u16 new_idx, u16 old)
 }
 
 /* Update dbbuf and return true if an MMIO is required */
-static bool nvme_dbbuf_update_and_check_event(u16 value, u32 *dbbuf_db,
-					      volatile u32 *dbbuf_ei)
+static bool nvme_dbbuf_update_and_check_event(u16 value, __le32 *dbbuf_db,
+					      volatile __le32 *dbbuf_ei)
 {
 	if (dbbuf_db) {
-		u16 old_value;
+		u16 old_value, event_idx;
 
 		/*
 		 * Ensure that the queue is written before updating
@@ -352,8 +352,8 @@ static bool nvme_dbbuf_update_and_check_event(u16 value, u32 *dbbuf_db,
 		 */
 		wmb();
 
-		old_value = *dbbuf_db;
-		*dbbuf_db = value;
+		old_value = le32_to_cpu(*dbbuf_db);
+		*dbbuf_db = cpu_to_le32(value);
 
 		/*
 		 * Ensure that the doorbell is updated before reading the event
@@ -363,7 +363,8 @@ static bool nvme_dbbuf_update_and_check_event(u16 value, u32 *dbbuf_db,
 		 */
 		mb();
 
-		if (!nvme_dbbuf_need_event(*dbbuf_ei, value, old_value))
+		event_idx = le32_to_cpu(*dbbuf_ei);
+		if (!nvme_dbbuf_need_event(event_idx, value, old_value))
 			return false;
 	}
 
@@ -377,9 +378,9 @@ static bool nvme_dbbuf_update_and_check_event(u16 value, u32 *dbbuf_db,
  */
 static int nvme_pci_npages_prp(void)
 {
-	unsigned nprps = DIV_ROUND_UP(NVME_MAX_KB_SZ + NVME_CTRL_PAGE_SIZE,
-				      NVME_CTRL_PAGE_SIZE);
-	return DIV_ROUND_UP(8 * nprps, PAGE_SIZE - 8);
+	unsigned max_bytes = (NVME_MAX_KB_SZ * 1024) + NVME_CTRL_PAGE_SIZE;
+	unsigned nprps = DIV_ROUND_UP(max_bytes, NVME_CTRL_PAGE_SIZE);
+	return DIV_ROUND_UP(8 * nprps, NVME_CTRL_PAGE_SIZE - 8);
 }
 
 /*
@@ -389,7 +390,7 @@ static int nvme_pci_npages_prp(void)
 static int nvme_pci_npages_sgl(void)
 {
 	return DIV_ROUND_UP(NVME_MAX_SEGS * sizeof(struct nvme_sgl_desc),
-			PAGE_SIZE);
+			NVME_CTRL_PAGE_SIZE);
 }
 
 static size_t nvme_pci_iod_alloc_size(void)
@@ -720,7 +721,7 @@ static void nvme_pci_sgl_set_seg(struct nvme_sgl_desc *sge,
 		sge->length = cpu_to_le32(entries * sizeof(*sge));
 		sge->type = NVME_SGL_FMT_LAST_SEG_DESC << 4;
 	} else {
-		sge->length = cpu_to_le32(PAGE_SIZE);
+		sge->length = cpu_to_le32(NVME_CTRL_PAGE_SIZE);
 		sge->type = NVME_SGL_FMT_SEG_DESC << 4;
 	}
 }
diff --git a/drivers/nvme/target/passthru.c b/drivers/nvme/target/passthru.c
index 94d3153bae54..09537000d817 100644
--- a/drivers/nvme/target/passthru.c
+++ b/drivers/nvme/target/passthru.c
@@ -333,14 +333,13 @@ static void nvmet_passthru_execute_cmd(struct nvmet_req *req)
 	}
 
 	/*
-	 * If there are effects for the command we are about to execute, or
-	 * an end_req function we need to use nvme_execute_passthru_rq()
-	 * synchronously in a work item seeing the end_req function and
-	 * nvme_passthru_end() can't be called in the request done callback
-	 * which is typically in interrupt context.
+	 * If a command needs post-execution fixups, or there are any
+	 * non-trivial effects, make sure to execute the command synchronously
+	 * in a workqueue so that nvme_passthru_end gets called.
 	 */
 	effects = nvme_command_effects(ctrl, ns, req->cmd->common.opcode);
-	if (req->p.use_workqueue || effects) {
+	if (req->p.use_workqueue ||
+	    (effects & ~(NVME_CMD_EFFECTS_CSUPP | NVME_CMD_EFFECTS_LBCC))) {
 		INIT_WORK(&req->p.work, nvmet_passthru_execute_cmd_work);
 		req->p.rq = rq;
 		queue_work(nvmet_wq, &req->p.work);
diff --git a/drivers/rtc/rtc-msc313.c b/drivers/rtc/rtc-msc313.c
index f3fde013c4b8..8d7737e0e2e0 100644
--- a/drivers/rtc/rtc-msc313.c
+++ b/drivers/rtc/rtc-msc313.c
@@ -212,22 +212,12 @@ static int msc313_rtc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	clk = devm_clk_get(dev, NULL);
+	clk = devm_clk_get_enabled(dev, NULL);
 	if (IS_ERR(clk)) {
 		dev_err(dev, "No input reference clock\n");
 		return PTR_ERR(clk);
 	}
 
-	ret = clk_prepare_enable(clk);
-	if (ret) {
-		dev_err(dev, "Failed to enable the reference clock, %d\n", ret);
-		return ret;
-	}
-
-	ret = devm_add_action_or_reset(dev, (void (*) (void *))clk_disable_unprepare, clk);
-	if (ret)
-		return ret;
-
 	rate = clk_get_rate(clk);
 	writew(rate & 0xFFFF, priv->rtc_base + REG_RTC_FREQ_CW_L);
 	writew((rate >> 16) & 0xFFFF, priv->rtc_base + REG_RTC_FREQ_CW_H);
diff --git a/drivers/soundwire/dmi-quirks.c b/drivers/soundwire/dmi-quirks.c
index f81cdd83ec26..7969881f126d 100644
--- a/drivers/soundwire/dmi-quirks.c
+++ b/drivers/soundwire/dmi-quirks.c
@@ -90,6 +90,14 @@ static const struct dmi_system_id adr_remap_quirk_table[] = {
 		},
 		.driver_data = (void *)intel_tgl_bios,
 	},
+	{
+		/* quirk used for NUC15 LAPBC710 skew */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
+			DMI_MATCH(DMI_BOARD_NAME, "LAPBC710"),
+		},
+		.driver_data = (void *)intel_tgl_bios,
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
index d3f3937d7005..e7d37b6000ad 100644
--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -260,7 +260,8 @@ static int dwc3_qcom_interconnect_init(struct dwc3_qcom *qcom)
 	if (IS_ERR(qcom->icc_path_apps)) {
 		dev_err(dev, "failed to get apps-usb path: %ld\n",
 				PTR_ERR(qcom->icc_path_apps));
-		return PTR_ERR(qcom->icc_path_apps);
+		ret = PTR_ERR(qcom->icc_path_apps);
+		goto put_path_ddr;
 	}
 
 	if (usb_get_maximum_speed(&qcom->dwc3->dev) >= USB_SPEED_SUPER ||
@@ -273,17 +274,23 @@ static int dwc3_qcom_interconnect_init(struct dwc3_qcom *qcom)
 
 	if (ret) {
 		dev_err(dev, "failed to set bandwidth for usb-ddr path: %d\n", ret);
-		return ret;
+		goto put_path_apps;
 	}
 
 	ret = icc_set_bw(qcom->icc_path_apps,
 		APPS_USB_AVG_BW, APPS_USB_PEAK_BW);
 	if (ret) {
 		dev_err(dev, "failed to set bandwidth for apps-usb path: %d\n", ret);
-		return ret;
+		goto put_path_apps;
 	}
 
 	return 0;
+
+put_path_apps:
+	icc_put(qcom->icc_path_apps);
+put_path_ddr:
+	icc_put(qcom->icc_path_ddr);
+	return ret;
 }
 
 /**
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 08d0c8797828..9ce5e1f41c26 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -434,8 +434,9 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm)
 	current->mm->start_stack = current->mm->start_brk + stack_size;
 #endif
 
-	if (create_elf_fdpic_tables(bprm, current->mm,
-				    &exec_params, &interp_params) < 0)
+	retval = create_elf_fdpic_tables(bprm, current->mm, &exec_params,
+					 &interp_params);
+	if (retval < 0)
 		goto error;
 
 	kdebug("- start_code  %lx", current->mm->start_code);
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 4992b43616a7..ba6cc50af390 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -122,8 +122,8 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
 		struct smb2_hdr *hdr = err_iov.iov_base;
 
 		if (unlikely(!err_iov.iov_base || err_buftype == CIFS_NO_BUFFER))
-			rc = -ENOMEM;
-		else if (hdr->Status == STATUS_STOPPED_ON_SYMLINK && oparms->cifs_sb) {
+			goto out;
+		if (hdr->Status == STATUS_STOPPED_ON_SYMLINK) {
 			rc = smb2_parse_symlink_response(oparms->cifs_sb, &err_iov,
 							 &data->symlink_target);
 			if (!rc) {
diff --git a/fs/eventfd.c b/fs/eventfd.c
index c0ffee99ad23..249ca6c0b784 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -43,21 +43,7 @@ struct eventfd_ctx {
 	int id;
 };
 
-/**
- * eventfd_signal - Adds @n to the eventfd counter.
- * @ctx: [in] Pointer to the eventfd context.
- * @n: [in] Value of the counter to be added to the eventfd internal counter.
- *          The value cannot be negative.
- *
- * This function is supposed to be called by the kernel in paths that do not
- * allow sleeping. In this function we allow the counter to reach the ULLONG_MAX
- * value, and we signal this as overflow condition by returning a EPOLLERR
- * to poll(2).
- *
- * Returns the amount by which the counter was incremented.  This will be less
- * than @n if the counter has overflowed.
- */
-__u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
+__u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n, unsigned mask)
 {
 	unsigned long flags;
 
@@ -78,12 +64,31 @@ __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
 		n = ULLONG_MAX - ctx->count;
 	ctx->count += n;
 	if (waitqueue_active(&ctx->wqh))
-		wake_up_locked_poll(&ctx->wqh, EPOLLIN);
+		wake_up_locked_poll(&ctx->wqh, EPOLLIN | mask);
 	current->in_eventfd = 0;
 	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 
 	return n;
 }
+
+/**
+ * eventfd_signal - Adds @n to the eventfd counter.
+ * @ctx: [in] Pointer to the eventfd context.
+ * @n: [in] Value of the counter to be added to the eventfd internal counter.
+ *          The value cannot be negative.
+ *
+ * This function is supposed to be called by the kernel in paths that do not
+ * allow sleeping. In this function we allow the counter to reach the ULLONG_MAX
+ * value, and we signal this as overflow condition by returning a EPOLLERR
+ * to poll(2).
+ *
+ * Returns the amount by which the counter was incremented.  This will be less
+ * than @n if the counter has overflowed.
+ */
+__u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
+{
+	return eventfd_signal_mask(ctx, n, 0);
+}
 EXPORT_SYMBOL_GPL(eventfd_signal);
 
 static void eventfd_free_ctx(struct eventfd_ctx *ctx)
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 8b56b94e2f56..1b23cc16f957 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -491,7 +491,8 @@ static inline void ep_set_busy_poll_napi_id(struct epitem *epi)
  */
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
-static void ep_poll_safewake(struct eventpoll *ep, struct epitem *epi)
+static void ep_poll_safewake(struct eventpoll *ep, struct epitem *epi,
+			     unsigned pollflags)
 {
 	struct eventpoll *ep_src;
 	unsigned long flags;
@@ -522,16 +523,17 @@ static void ep_poll_safewake(struct eventpoll *ep, struct epitem *epi)
 	}
 	spin_lock_irqsave_nested(&ep->poll_wait.lock, flags, nests);
 	ep->nests = nests + 1;
-	wake_up_locked_poll(&ep->poll_wait, EPOLLIN);
+	wake_up_locked_poll(&ep->poll_wait, EPOLLIN | pollflags);
 	ep->nests = 0;
 	spin_unlock_irqrestore(&ep->poll_wait.lock, flags);
 }
 
 #else
 
-static void ep_poll_safewake(struct eventpoll *ep, struct epitem *epi)
+static void ep_poll_safewake(struct eventpoll *ep, struct epitem *epi,
+			     unsigned pollflags)
 {
-	wake_up_poll(&ep->poll_wait, EPOLLIN);
+	wake_up_poll(&ep->poll_wait, EPOLLIN | pollflags);
 }
 
 #endif
@@ -742,7 +744,7 @@ static void ep_free(struct eventpoll *ep)
 
 	/* We need to release all tasks waiting for these file */
 	if (waitqueue_active(&ep->poll_wait))
-		ep_poll_safewake(ep, NULL);
+		ep_poll_safewake(ep, NULL, 0);
 
 	/*
 	 * We need to lock this because we could be hit by
@@ -1208,7 +1210,7 @@ static int ep_poll_callback(wait_queue_entry_t *wait, unsigned mode, int sync, v
 
 	/* We have to call this outside the lock */
 	if (pwake)
-		ep_poll_safewake(ep, epi);
+		ep_poll_safewake(ep, epi, pollflags & EPOLL_URING_WAKE);
 
 	if (!(epi->event.events & EPOLLEXCLUSIVE))
 		ewake = 1;
@@ -1553,7 +1555,7 @@ static int ep_insert(struct eventpoll *ep, const struct epoll_event *event,
 
 	/* We have to call this outside the lock */
 	if (pwake)
-		ep_poll_safewake(ep, NULL);
+		ep_poll_safewake(ep, NULL, 0);
 
 	return 0;
 }
@@ -1629,7 +1631,7 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi,
 
 	/* We have to call this outside the lock */
 	if (pwake)
-		ep_poll_safewake(ep, NULL);
+		ep_poll_safewake(ep, NULL, 0);
 
 	return 0;
 }
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 68eb1d33128b..d58100dc6e89 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1109,6 +1109,7 @@ static bool is_alive(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 	if (ofs_in_node >= max_addrs) {
 		f2fs_err(sbi, "Inconsistent ofs_in_node:%u in summary, ino:%u, nid:%u, max:%u",
 			ofs_in_node, dni->ino, dni->nid, max_addrs);
+		f2fs_put_page(node_page, 1);
 		return false;
 	}
 
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index e06a0c478b39..f168dce9b586 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1358,8 +1358,7 @@ static int read_node_page(struct page *page, blk_opf_t op_flags)
 		return err;
 
 	/* NEW_ADDR can be seen, after cp_error drops some dirty node pages */
-	if (unlikely(ni.blk_addr == NULL_ADDR || ni.blk_addr == NEW_ADDR) ||
-			is_sbi_flag_set(sbi, SBI_IS_SHUTDOWN)) {
+	if (unlikely(ni.blk_addr == NULL_ADDR || ni.blk_addr == NEW_ADDR)) {
 		ClearPageUptodate(page);
 		return -ENOENT;
 	}
diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index a5db2e3b2980..6aa919e59483 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -198,6 +198,8 @@ struct hfsplus_sb_info {
 #define HFSPLUS_SB_HFSX		3
 #define HFSPLUS_SB_CASEFOLD	4
 #define HFSPLUS_SB_NOBARRIER	5
+#define HFSPLUS_SB_UID		6
+#define HFSPLUS_SB_GID		7
 
 static inline struct hfsplus_sb_info *HFSPLUS_SB(struct super_block *sb)
 {
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index aeab83ed1c9c..b675581aa9d0 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -192,11 +192,11 @@ static void hfsplus_get_perms(struct inode *inode,
 	mode = be16_to_cpu(perms->mode);
 
 	i_uid_write(inode, be32_to_cpu(perms->owner));
-	if (!i_uid_read(inode) && !mode)
+	if ((test_bit(HFSPLUS_SB_UID, &sbi->flags)) || (!i_uid_read(inode) && !mode))
 		inode->i_uid = sbi->uid;
 
 	i_gid_write(inode, be32_to_cpu(perms->group));
-	if (!i_gid_read(inode) && !mode)
+	if ((test_bit(HFSPLUS_SB_GID, &sbi->flags)) || (!i_gid_read(inode) && !mode))
 		inode->i_gid = sbi->gid;
 
 	if (dir) {
diff --git a/fs/hfsplus/options.c b/fs/hfsplus/options.c
index 047e05c57560..c94a58762ad6 100644
--- a/fs/hfsplus/options.c
+++ b/fs/hfsplus/options.c
@@ -140,6 +140,8 @@ int hfsplus_parse_options(char *input, struct hfsplus_sb_info *sbi)
 			if (!uid_valid(sbi->uid)) {
 				pr_err("invalid uid specified\n");
 				return 0;
+			} else {
+				set_bit(HFSPLUS_SB_UID, &sbi->flags);
 			}
 			break;
 		case opt_gid:
@@ -151,6 +153,8 @@ int hfsplus_parse_options(char *input, struct hfsplus_sb_info *sbi)
 			if (!gid_valid(sbi->gid)) {
 				pr_err("invalid gid specified\n");
 				return 0;
+			} else {
+				set_bit(HFSPLUS_SB_GID, &sbi->flags);
 			}
 			break;
 		case opt_part:
diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index 71f870d497ae..578c2bcfb1d9 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -101,6 +101,10 @@ static int attr_load_runs(struct ATTRIB *attr, struct ntfs_inode *ni,
 
 	asize = le32_to_cpu(attr->size);
 	run_off = le16_to_cpu(attr->nres.run_off);
+
+	if (run_off > asize)
+		return -EINVAL;
+
 	err = run_unpack_ex(run, ni->mi.sbi, ni->mi.rno, svcn, evcn,
 			    vcn ? *vcn : svcn, Add2Ptr(attr, run_off),
 			    asize - run_off);
@@ -1217,6 +1221,11 @@ int attr_load_runs_vcn(struct ntfs_inode *ni, enum ATTR_TYPE type,
 	CLST svcn, evcn;
 	u16 ro;
 
+	if (!ni) {
+		/* Is record corrupted? */
+		return -ENOENT;
+	}
+
 	attr = ni_find_attr(ni, NULL, NULL, type, name, name_len, &vcn, NULL);
 	if (!attr) {
 		/* Is record corrupted? */
@@ -1232,6 +1241,10 @@ int attr_load_runs_vcn(struct ntfs_inode *ni, enum ATTR_TYPE type,
 	}
 
 	ro = le16_to_cpu(attr->nres.run_off);
+
+	if (ro > le32_to_cpu(attr->size))
+		return -EINVAL;
+
 	err = run_unpack_ex(run, ni->mi.sbi, ni->mi.rno, svcn, evcn, svcn,
 			    Add2Ptr(attr, ro), le32_to_cpu(attr->size) - ro);
 	if (err < 0)
@@ -1901,6 +1914,11 @@ int attr_collapse_range(struct ntfs_inode *ni, u64 vbo, u64 bytes)
 			u16 le_sz;
 			u16 roff = le16_to_cpu(attr->nres.run_off);
 
+			if (roff > le32_to_cpu(attr->size)) {
+				err = -EINVAL;
+				goto out;
+			}
+
 			run_unpack_ex(RUN_DEALLOCATE, sbi, ni->mi.rno, svcn,
 				      evcn1 - 1, svcn, Add2Ptr(attr, roff),
 				      le32_to_cpu(attr->size) - roff);
diff --git a/fs/ntfs3/attrlist.c b/fs/ntfs3/attrlist.c
index bad6d8a849a2..c0c6bcbc8c05 100644
--- a/fs/ntfs3/attrlist.c
+++ b/fs/ntfs3/attrlist.c
@@ -68,6 +68,11 @@ int ntfs_load_attr_list(struct ntfs_inode *ni, struct ATTRIB *attr)
 
 		run_init(&ni->attr_list.run);
 
+		if (run_off > le32_to_cpu(attr->size)) {
+			err = -EINVAL;
+			goto out;
+		}
+
 		err = run_unpack_ex(&ni->attr_list.run, ni->mi.sbi, ni->mi.rno,
 				    0, le64_to_cpu(attr->nres.evcn), 0,
 				    Add2Ptr(attr, run_off),
diff --git a/fs/ntfs3/bitmap.c b/fs/ntfs3/bitmap.c
index 087282cb130b..bb29bc1782fb 100644
--- a/fs/ntfs3/bitmap.c
+++ b/fs/ntfs3/bitmap.c
@@ -661,7 +661,7 @@ int wnd_init(struct wnd_bitmap *wnd, struct super_block *sb, size_t nbits)
 	if (!wnd->bits_last)
 		wnd->bits_last = wbits;
 
-	wnd->free_bits = kcalloc(wnd->nwnd, sizeof(u16), GFP_NOFS);
+	wnd->free_bits = kcalloc(wnd->nwnd, sizeof(u16), GFP_NOFS | __GFP_NOWARN);
 	if (!wnd->free_bits)
 		return -ENOMEM;
 
diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 381a38a06ec2..b1b476fb7229 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -568,6 +568,12 @@ static int ni_repack(struct ntfs_inode *ni)
 		}
 
 		roff = le16_to_cpu(attr->nres.run_off);
+
+		if (roff > le32_to_cpu(attr->size)) {
+			err = -EINVAL;
+			break;
+		}
+
 		err = run_unpack(&run, sbi, ni->mi.rno, svcn, evcn, svcn,
 				 Add2Ptr(attr, roff),
 				 le32_to_cpu(attr->size) - roff);
@@ -1589,6 +1595,9 @@ int ni_delete_all(struct ntfs_inode *ni)
 		asize = le32_to_cpu(attr->size);
 		roff = le16_to_cpu(attr->nres.run_off);
 
+		if (roff > asize)
+			return -EINVAL;
+
 		/* run==1 means unpack and deallocate. */
 		run_unpack_ex(RUN_DEALLOCATE, sbi, ni->mi.rno, svcn, evcn, svcn,
 			      Add2Ptr(attr, roff), asize - roff);
@@ -2291,6 +2300,11 @@ int ni_decompress_file(struct ntfs_inode *ni)
 		asize = le32_to_cpu(attr->size);
 		roff = le16_to_cpu(attr->nres.run_off);
 
+		if (roff > asize) {
+			err = -EINVAL;
+			goto out;
+		}
+
 		/*run==1  Means unpack and deallocate. */
 		run_unpack_ex(RUN_DEALLOCATE, sbi, ni->mi.rno, svcn, evcn, svcn,
 			      Add2Ptr(attr, roff), asize - roff);
diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index e7c494005122..4236194af35e 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -1132,7 +1132,7 @@ static int read_log_page(struct ntfs_log *log, u32 vbo,
 		return -EINVAL;
 
 	if (!*buffer) {
-		to_free = kmalloc(bytes, GFP_NOFS);
+		to_free = kmalloc(log->page_size, GFP_NOFS);
 		if (!to_free)
 			return -ENOMEM;
 		*buffer = to_free;
@@ -1180,10 +1180,7 @@ static int log_read_rst(struct ntfs_log *log, u32 l_size, bool first,
 			struct restart_info *info)
 {
 	u32 skip, vbo;
-	struct RESTART_HDR *r_page = kmalloc(DefaultLogPageSize, GFP_NOFS);
-
-	if (!r_page)
-		return -ENOMEM;
+	struct RESTART_HDR *r_page = NULL;
 
 	/* Determine which restart area we are looking for. */
 	if (first) {
@@ -1197,7 +1194,6 @@ static int log_read_rst(struct ntfs_log *log, u32 l_size, bool first,
 	/* Loop continuously until we succeed. */
 	for (; vbo < l_size; vbo = 2 * vbo + skip, skip = 0) {
 		bool usa_error;
-		u32 sys_page_size;
 		bool brst, bchk;
 		struct RESTART_AREA *ra;
 
@@ -1251,24 +1247,6 @@ static int log_read_rst(struct ntfs_log *log, u32 l_size, bool first,
 			goto check_result;
 		}
 
-		/* Read the entire restart area. */
-		sys_page_size = le32_to_cpu(r_page->sys_page_size);
-		if (DefaultLogPageSize != sys_page_size) {
-			kfree(r_page);
-			r_page = kzalloc(sys_page_size, GFP_NOFS);
-			if (!r_page)
-				return -ENOMEM;
-
-			if (read_log_page(log, vbo,
-					  (struct RECORD_PAGE_HDR **)&r_page,
-					  &usa_error)) {
-				/* Ignore any errors. */
-				kfree(r_page);
-				r_page = NULL;
-				continue;
-			}
-		}
-
 		if (is_client_area_valid(r_page, usa_error)) {
 			info->valid_page = true;
 			ra = Add2Ptr(r_page, le16_to_cpu(r_page->ra_off));
@@ -2727,6 +2705,9 @@ static inline bool check_attr(const struct MFT_REC *rec,
 			return false;
 		}
 
+		if (run_off > asize)
+			return false;
+
 		if (run_unpack(NULL, sbi, 0, svcn, evcn, svcn,
 			       Add2Ptr(attr, run_off), asize - run_off) < 0) {
 			return false;
@@ -4771,6 +4752,12 @@ int log_replay(struct ntfs_inode *ni, bool *initialized)
 		u16 roff = le16_to_cpu(attr->nres.run_off);
 		CLST svcn = le64_to_cpu(attr->nres.svcn);
 
+		if (roff > t32) {
+			kfree(oa->attr);
+			oa->attr = NULL;
+			goto fake_attr;
+		}
+
 		err = run_unpack(&oa->run0, sbi, inode->i_ino, svcn,
 				 le64_to_cpu(attr->nres.evcn), svcn,
 				 Add2Ptr(attr, roff), t32 - roff);
diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index 4ed15f64b17f..b6e22bcb929b 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -1849,9 +1849,10 @@ int ntfs_security_init(struct ntfs_sb_info *sbi)
 		goto out;
 	}
 
-	root_sdh = resident_data(attr);
+	root_sdh = resident_data_ex(attr, sizeof(struct INDEX_ROOT));
 	if (root_sdh->type != ATTR_ZERO ||
-	    root_sdh->rule != NTFS_COLLATION_TYPE_SECURITY_HASH) {
+	    root_sdh->rule != NTFS_COLLATION_TYPE_SECURITY_HASH ||
+	    offsetof(struct INDEX_ROOT, ihdr) + root_sdh->ihdr.used > attr->res.data_size) {
 		err = -EINVAL;
 		goto out;
 	}
@@ -1867,9 +1868,10 @@ int ntfs_security_init(struct ntfs_sb_info *sbi)
 		goto out;
 	}
 
-	root_sii = resident_data(attr);
+	root_sii = resident_data_ex(attr, sizeof(struct INDEX_ROOT));
 	if (root_sii->type != ATTR_ZERO ||
-	    root_sii->rule != NTFS_COLLATION_TYPE_UINT) {
+	    root_sii->rule != NTFS_COLLATION_TYPE_UINT ||
+	    offsetof(struct INDEX_ROOT, ihdr) + root_sii->ihdr.used > attr->res.data_size) {
 		err = -EINVAL;
 		goto out;
 	}
diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
index 440328147e7e..c27b4fe57513 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -1017,6 +1017,12 @@ int indx_read(struct ntfs_index *indx, struct ntfs_inode *ni, CLST vbn,
 		err = 0;
 	}
 
+	/* check for index header length */
+	if (offsetof(struct INDEX_BUFFER, ihdr) + ib->ihdr.used > bytes) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	in->index = ib;
 	*node = in;
 
diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 26a76ebfe58f..471ea4d813ad 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -129,6 +129,9 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 	rsize = attr->non_res ? 0 : le32_to_cpu(attr->res.data_size);
 	asize = le32_to_cpu(attr->size);
 
+	if (le16_to_cpu(attr->name_off) + attr->name_len > asize)
+		goto out;
+
 	switch (attr->type) {
 	case ATTR_STD:
 		if (attr->non_res ||
@@ -364,7 +367,13 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 attr_unpack_run:
 	roff = le16_to_cpu(attr->nres.run_off);
 
+	if (roff > asize) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	t64 = le64_to_cpu(attr->nres.svcn);
+
 	err = run_unpack_ex(run, sbi, ino, t64, le64_to_cpu(attr->nres.evcn),
 			    t64, Add2Ptr(attr, roff), asize - roff);
 	if (err < 0)
diff --git a/fs/ntfs3/record.c b/fs/ntfs3/record.c
index 7d2fac5ee215..af1e4b364ea8 100644
--- a/fs/ntfs3/record.c
+++ b/fs/ntfs3/record.c
@@ -220,6 +220,11 @@ struct ATTRIB *mi_enum_attr(struct mft_inode *mi, struct ATTRIB *attr)
 			return NULL;
 		}
 
+		if (off + asize < off) {
+			/* overflow check */
+			return NULL;
+		}
+
 		attr = Add2Ptr(attr, asize);
 		off += asize;
 	}
@@ -260,6 +265,11 @@ struct ATTRIB *mi_enum_attr(struct mft_inode *mi, struct ATTRIB *attr)
 		if (t16 + t32 > asize)
 			return NULL;
 
+		if (attr->name_len &&
+		    le16_to_cpu(attr->name_off) + sizeof(short) * attr->name_len > t16) {
+			return NULL;
+		}
+
 		return attr;
 	}
 
diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index adc4f73722b7..8e2fe0f69203 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -789,7 +789,7 @@ static int ntfs_init_from_boot(struct super_block *sb, u32 sector_size,
 						 : (u32)boot->record_size
 							   << sbi->cluster_bits;
 
-	if (record_size > MAXIMUM_BYTES_PER_MFT)
+	if (record_size > MAXIMUM_BYTES_PER_MFT || record_size < SECTOR_SIZE)
 		goto out;
 
 	sbi->record_bits = blksize_bits(record_size);
@@ -1141,7 +1141,7 @@ static int ntfs_fill_super(struct super_block *sb, struct fs_context *fc)
 		goto put_inode_out;
 	}
 	bytes = inode->i_size;
-	sbi->def_table = t = kmalloc(bytes, GFP_NOFS);
+	sbi->def_table = t = kmalloc(bytes, GFP_NOFS | __GFP_NOWARN);
 	if (!t) {
 		err = -ENOMEM;
 		goto put_inode_out;
@@ -1260,9 +1260,9 @@ static int ntfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	ref.low = cpu_to_le32(MFT_REC_ROOT);
 	ref.seq = cpu_to_le16(MFT_REC_ROOT);
 	inode = ntfs_iget5(sb, &ref, &NAME_ROOT);
-	if (IS_ERR(inode)) {
+	if (IS_ERR(inode) || !inode->i_op) {
 		ntfs_err(sb, "Failed to load root.");
-		err = PTR_ERR(inode);
+		err = IS_ERR(inode) ? PTR_ERR(inode) : -EINVAL;
 		goto out;
 	}
 
@@ -1281,6 +1281,7 @@ static int ntfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	 * Free resources here.
 	 * ntfs_fs_free will be called with fc->s_fs_info = NULL
 	 */
+	put_mount_options(sbi->options);
 	put_ntfs(sbi);
 	sb->s_fs_info = NULL;
 
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 6b03457f72bb..c3032cef391e 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -592,28 +592,42 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
 			goto out_revert_creds;
 	}
 
-	err = -ENOMEM;
-	override_cred = prepare_creds();
-	if (override_cred) {
+	if (!attr->hardlink) {
+		err = -ENOMEM;
+		override_cred = prepare_creds();
+		if (!override_cred)
+			goto out_revert_creds;
+		/*
+		 * In the creation cases(create, mkdir, mknod, symlink),
+		 * ovl should transfer current's fs{u,g}id to underlying
+		 * fs. Because underlying fs want to initialize its new
+		 * inode owner using current's fs{u,g}id. And in this
+		 * case, the @inode is a new inode that is initialized
+		 * in inode_init_owner() to current's fs{u,g}id. So use
+		 * the inode's i_{u,g}id to override the cred's fs{u,g}id.
+		 *
+		 * But in the other hardlink case, ovl_link() does not
+		 * create a new inode, so just use the ovl mounter's
+		 * fs{u,g}id.
+		 */
 		override_cred->fsuid = inode->i_uid;
 		override_cred->fsgid = inode->i_gid;
-		if (!attr->hardlink) {
-			err = security_dentry_create_files_as(dentry,
-					attr->mode, &dentry->d_name, old_cred,
-					override_cred);
-			if (err) {
-				put_cred(override_cred);
-				goto out_revert_creds;
-			}
+		err = security_dentry_create_files_as(dentry,
+				attr->mode, &dentry->d_name, old_cred,
+				override_cred);
+		if (err) {
+			put_cred(override_cred);
+			goto out_revert_creds;
 		}
 		put_cred(override_creds(override_cred));
 		put_cred(override_cred);
-
-		if (!ovl_dentry_is_whiteout(dentry))
-			err = ovl_create_upper(dentry, inode, attr);
-		else
-			err = ovl_create_over_whiteout(dentry, inode, attr);
 	}
+
+	if (!ovl_dentry_is_whiteout(dentry))
+		err = ovl_create_upper(dentry, inode, attr);
+	else
+		err = ovl_create_over_whiteout(dentry, inode, attr);
+
 out_revert_creds:
 	revert_creds(old_cred);
 	return err;
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index a34f8042724c..172cde9d2e56 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -96,6 +96,7 @@ static int ovl_change_flags(struct file *file, unsigned int flags)
 
 	spin_lock(&file->f_lock);
 	file->f_flags = (file->f_flags & ~OVL_SETFL_MASK) | flags;
+	file->f_iocb_flags = iocb_flags(file);
 	spin_unlock(&file->f_lock);
 
 	return 0;
diff --git a/fs/pnode.c b/fs/pnode.c
index 1106137c747a..468e4e65a615 100644
--- a/fs/pnode.c
+++ b/fs/pnode.c
@@ -244,7 +244,7 @@ static int propagate_one(struct mount *m)
 		}
 		do {
 			struct mount *parent = last_source->mnt_parent;
-			if (last_source == first_source)
+			if (peers(last_source, first_source))
 				break;
 			done = parent->mnt_master == p;
 			if (done && peers(n, parent))
diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 74e4d93f3e08..f3fa3625d772 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -670,7 +670,7 @@ static int ramoops_parse_dt(struct platform_device *pdev,
 		field = value;						\
 	}
 
-	parse_u32("mem-type", pdata->record_size, pdata->mem_type);
+	parse_u32("mem-type", pdata->mem_type, pdata->mem_type);
 	parse_u32("record-size", pdata->record_size, 0);
 	parse_u32("console-size", pdata->console_size, 0);
 	parse_u32("ftrace-size", pdata->ftrace_size, 0);
diff --git a/fs/pstore/zone.c b/fs/pstore/zone.c
index 017d0d4ad329..2770746bb7aa 100644
--- a/fs/pstore/zone.c
+++ b/fs/pstore/zone.c
@@ -761,7 +761,7 @@ static inline int notrace psz_kmsg_write_record(struct psz_context *cxt,
 		/* avoid destroying old data, allocate a new one */
 		len = zone->buffer_size + sizeof(*zone->buffer);
 		zone->oldbuf = zone->buffer;
-		zone->buffer = kzalloc(len, GFP_KERNEL);
+		zone->buffer = kzalloc(len, GFP_ATOMIC);
 		if (!zone->buffer) {
 			zone->buffer = zone->oldbuf;
 			return -ENOMEM;
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index 3cd202d3eefb..36a486505b08 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -40,6 +40,7 @@ struct file *eventfd_fget(int fd);
 struct eventfd_ctx *eventfd_ctx_fdget(int fd);
 struct eventfd_ctx *eventfd_ctx_fileget(struct file *file);
 __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n);
+__u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n, unsigned mask);
 int eventfd_ctx_remove_wait_queue(struct eventfd_ctx *ctx, wait_queue_entry_t *wait,
 				  __u64 *cnt);
 void eventfd_ctx_do_read(struct eventfd_ctx *ctx, __u64 *cnt);
@@ -66,6 +67,12 @@ static inline int eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
 	return -ENOSYS;
 }
 
+static inline int eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n,
+				      unsigned mask)
+{
+	return -ENOSYS;
+}
+
 static inline void eventfd_ctx_put(struct eventfd_ctx *ctx)
 {
 
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index ae53d74f3696..e2dbb9755cca 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -7,6 +7,7 @@
 #ifndef _LINUX_NVME_H
 #define _LINUX_NVME_H
 
+#include <linux/bits.h>
 #include <linux/types.h>
 #include <linux/uuid.h>
 
@@ -639,7 +640,7 @@ enum {
 	NVME_CMD_EFFECTS_NCC		= 1 << 2,
 	NVME_CMD_EFFECTS_NIC		= 1 << 3,
 	NVME_CMD_EFFECTS_CCC		= 1 << 4,
-	NVME_CMD_EFFECTS_CSE_MASK	= 3 << 16,
+	NVME_CMD_EFFECTS_CSE_MASK	= GENMASK(18, 16),
 	NVME_CMD_EFFECTS_UUID_SEL	= 1 << 19,
 };
 
diff --git a/include/uapi/linux/eventpoll.h b/include/uapi/linux/eventpoll.h
index 8a3432d0f0dc..e687658843b1 100644
--- a/include/uapi/linux/eventpoll.h
+++ b/include/uapi/linux/eventpoll.h
@@ -41,6 +41,12 @@
 #define EPOLLMSG	(__force __poll_t)0x00000400
 #define EPOLLRDHUP	(__force __poll_t)0x00002000
 
+/*
+ * Internal flag - wakeup generated by io_uring, used to detect recursion back
+ * into the io_uring poll handler.
+ */
+#define EPOLL_URING_WAKE	((__force __poll_t)(1U << 27))
+
 /* Set exclusive wakeup mode for the target file descriptor */
 #define EPOLLEXCLUSIVE	((__force __poll_t)(1U << 28))
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1b6c25dc3f0c..b8a39be3bcb4 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1607,7 +1607,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 		return ret;
 
 	/* If the op doesn't have a file, we're not polling for it */
-	if ((req->ctx->flags & IORING_SETUP_IOPOLL) && req->file)
+	if ((req->ctx->flags & IORING_SETUP_IOPOLL) && def->iopoll_queue)
 		io_iopoll_req_issued(req, issue_flags);
 
 	return 0;
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 080867143f28..a49ccab262d5 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -169,9 +169,5 @@ int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
-	/* put file to avoid an attempt to IOPOLL the req */
-	if (!(req->flags & REQ_F_FIXED_FILE))
-		io_put_file(req->file);
-	req->file = NULL;
 	return IOU_OK;
 }
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 3b15cdb6dbbc..b3746458741b 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -63,6 +63,7 @@ const struct io_op_def io_op_defs[] = {
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.iopoll			= 1,
+		.iopoll_queue		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.name			= "READV",
 		.prep			= io_prep_rw,
@@ -80,6 +81,7 @@ const struct io_op_def io_op_defs[] = {
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.iopoll			= 1,
+		.iopoll_queue		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.name			= "WRITEV",
 		.prep			= io_prep_rw,
@@ -103,6 +105,7 @@ const struct io_op_def io_op_defs[] = {
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.iopoll			= 1,
+		.iopoll_queue		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.name			= "READ_FIXED",
 		.prep			= io_prep_rw,
@@ -118,6 +121,7 @@ const struct io_op_def io_op_defs[] = {
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.iopoll			= 1,
+		.iopoll_queue		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.name			= "WRITE_FIXED",
 		.prep			= io_prep_rw,
@@ -275,6 +279,7 @@ const struct io_op_def io_op_defs[] = {
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.iopoll			= 1,
+		.iopoll_queue		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.name			= "READ",
 		.prep			= io_prep_rw,
@@ -290,6 +295,7 @@ const struct io_op_def io_op_defs[] = {
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.iopoll			= 1,
+		.iopoll_queue		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.name			= "WRITE",
 		.prep			= io_prep_rw,
@@ -475,6 +481,7 @@ const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.plug			= 1,
 		.name			= "URING_CMD",
+		.iopoll_queue		= 1,
 		.async_size		= uring_cmd_pdu_size(1),
 		.prep			= io_uring_cmd_prep,
 		.issue			= io_uring_cmd,
diff --git a/io_uring/opdef.h b/io_uring/opdef.h
index 3efe06d25473..df7e13d9bfba 100644
--- a/io_uring/opdef.h
+++ b/io_uring/opdef.h
@@ -25,6 +25,8 @@ struct io_op_def {
 	unsigned		ioprio : 1;
 	/* supports iopoll */
 	unsigned		iopoll : 1;
+	/* have to be put into the iopoll list */
+	unsigned		iopoll_queue : 1;
 	/* opcode specific path will handle ->async_data allocation if needed */
 	unsigned		manual_alloc : 1;
 	/* size of async data needed, if any */
diff --git a/kernel/futex/syscalls.c b/kernel/futex/syscalls.c
index 086a22d1adb7..a8074079b09e 100644
--- a/kernel/futex/syscalls.c
+++ b/kernel/futex/syscalls.c
@@ -286,19 +286,22 @@ SYSCALL_DEFINE5(futex_waitv, struct futex_waitv __user *, waiters,
 	}
 
 	futexv = kcalloc(nr_futexes, sizeof(*futexv), GFP_KERNEL);
-	if (!futexv)
-		return -ENOMEM;
+	if (!futexv) {
+		ret = -ENOMEM;
+		goto destroy_timer;
+	}
 
 	ret = futex_parse_waitv(futexv, waiters, nr_futexes);
 	if (!ret)
 		ret = futex_wait_multiple(futexv, nr_futexes, timeout ? &to : NULL);
 
+	kfree(futexv);
+
+destroy_timer:
 	if (timeout) {
 		hrtimer_cancel(&to.timer);
 		destroy_hrtimer_on_stack(&to.timer);
 	}
-
-	kfree(futexv);
 	return ret;
 }
 
diff --git a/kernel/kcsan/core.c b/kernel/kcsan/core.c
index fe12dfe254ec..54d077e1a2dc 100644
--- a/kernel/kcsan/core.c
+++ b/kernel/kcsan/core.c
@@ -14,10 +14,12 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
+#include <linux/minmax.h>
 #include <linux/moduleparam.h>
 #include <linux/percpu.h>
 #include <linux/preempt.h>
 #include <linux/sched.h>
+#include <linux/string.h>
 #include <linux/uaccess.h>
 
 #include "encoding.h"
@@ -1308,3 +1310,51 @@ noinline void __tsan_atomic_signal_fence(int memorder)
 	}
 }
 EXPORT_SYMBOL(__tsan_atomic_signal_fence);
+
+#ifdef __HAVE_ARCH_MEMSET
+void *__tsan_memset(void *s, int c, size_t count);
+noinline void *__tsan_memset(void *s, int c, size_t count)
+{
+	/*
+	 * Instead of not setting up watchpoints where accessed size is greater
+	 * than MAX_ENCODABLE_SIZE, truncate checked size to MAX_ENCODABLE_SIZE.
+	 */
+	size_t check_len = min_t(size_t, count, MAX_ENCODABLE_SIZE);
+
+	check_access(s, check_len, KCSAN_ACCESS_WRITE, _RET_IP_);
+	return memset(s, c, count);
+}
+#else
+void *__tsan_memset(void *s, int c, size_t count) __alias(memset);
+#endif
+EXPORT_SYMBOL(__tsan_memset);
+
+#ifdef __HAVE_ARCH_MEMMOVE
+void *__tsan_memmove(void *dst, const void *src, size_t len);
+noinline void *__tsan_memmove(void *dst, const void *src, size_t len)
+{
+	size_t check_len = min_t(size_t, len, MAX_ENCODABLE_SIZE);
+
+	check_access(dst, check_len, KCSAN_ACCESS_WRITE, _RET_IP_);
+	check_access(src, check_len, 0, _RET_IP_);
+	return memmove(dst, src, len);
+}
+#else
+void *__tsan_memmove(void *dst, const void *src, size_t len) __alias(memmove);
+#endif
+EXPORT_SYMBOL(__tsan_memmove);
+
+#ifdef __HAVE_ARCH_MEMCPY
+void *__tsan_memcpy(void *dst, const void *src, size_t len);
+noinline void *__tsan_memcpy(void *dst, const void *src, size_t len)
+{
+	size_t check_len = min_t(size_t, len, MAX_ENCODABLE_SIZE);
+
+	check_access(dst, check_len, KCSAN_ACCESS_WRITE, _RET_IP_);
+	check_access(src, check_len, 0, _RET_IP_);
+	return memcpy(dst, src, len);
+}
+#else
+void *__tsan_memcpy(void *dst, const void *src, size_t len) __alias(memcpy);
+#endif
+EXPORT_SYMBOL(__tsan_memcpy);
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 771fcce54fac..fb88278978fe 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2209,13 +2209,9 @@ int register_kretprobe(struct kretprobe *rp)
 	rp->kp.post_handler = NULL;
 
 	/* Pre-allocate memory for max kretprobe instances */
-	if (rp->maxactive <= 0) {
-#ifdef CONFIG_PREEMPTION
+	if (rp->maxactive <= 0)
 		rp->maxactive = max_t(unsigned int, 10, 2*num_possible_cpus());
-#else
-		rp->maxactive = num_possible_cpus();
-#endif
-	}
+
 #ifdef CONFIG_KRETPROBE_ON_RETHOOK
 	rp->rh = rethook_alloc((void *)rp, kretprobe_rethook_handler);
 	if (!rp->rh)
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index 7779ee8abc2a..010cf4e6d0b8 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -89,15 +89,31 @@ static inline int __ww_mutex_check_kill(struct rt_mutex *lock,
  * set this bit before looking at the lock.
  */
 
-static __always_inline void
-rt_mutex_set_owner(struct rt_mutex_base *lock, struct task_struct *owner)
+static __always_inline struct task_struct *
+rt_mutex_owner_encode(struct rt_mutex_base *lock, struct task_struct *owner)
 {
 	unsigned long val = (unsigned long)owner;
 
 	if (rt_mutex_has_waiters(lock))
 		val |= RT_MUTEX_HAS_WAITERS;
 
-	WRITE_ONCE(lock->owner, (struct task_struct *)val);
+	return (struct task_struct *)val;
+}
+
+static __always_inline void
+rt_mutex_set_owner(struct rt_mutex_base *lock, struct task_struct *owner)
+{
+	/*
+	 * lock->wait_lock is held but explicit acquire semantics are needed
+	 * for a new lock owner so WRITE_ONCE is insufficient.
+	 */
+	xchg_acquire(&lock->owner, rt_mutex_owner_encode(lock, owner));
+}
+
+static __always_inline void rt_mutex_clear_owner(struct rt_mutex_base *lock)
+{
+	/* lock->wait_lock is held so the unlock provides release semantics. */
+	WRITE_ONCE(lock->owner, rt_mutex_owner_encode(lock, NULL));
 }
 
 static __always_inline void clear_rt_mutex_waiters(struct rt_mutex_base *lock)
@@ -106,7 +122,8 @@ static __always_inline void clear_rt_mutex_waiters(struct rt_mutex_base *lock)
 			((unsigned long)lock->owner & ~RT_MUTEX_HAS_WAITERS);
 }
 
-static __always_inline void fixup_rt_mutex_waiters(struct rt_mutex_base *lock)
+static __always_inline void
+fixup_rt_mutex_waiters(struct rt_mutex_base *lock, bool acquire_lock)
 {
 	unsigned long owner, *p = (unsigned long *) &lock->owner;
 
@@ -172,8 +189,21 @@ static __always_inline void fixup_rt_mutex_waiters(struct rt_mutex_base *lock)
 	 * still set.
 	 */
 	owner = READ_ONCE(*p);
-	if (owner & RT_MUTEX_HAS_WAITERS)
-		WRITE_ONCE(*p, owner & ~RT_MUTEX_HAS_WAITERS);
+	if (owner & RT_MUTEX_HAS_WAITERS) {
+		/*
+		 * See rt_mutex_set_owner() and rt_mutex_clear_owner() on
+		 * why xchg_acquire() is used for updating owner for
+		 * locking and WRITE_ONCE() for unlocking.
+		 *
+		 * WRITE_ONCE() would work for the acquire case too, but
+		 * in case that the lock acquisition failed it might
+		 * force other lockers into the slow path unnecessarily.
+		 */
+		if (acquire_lock)
+			xchg_acquire(p, owner & ~RT_MUTEX_HAS_WAITERS);
+		else
+			WRITE_ONCE(*p, owner & ~RT_MUTEX_HAS_WAITERS);
+	}
 }
 
 /*
@@ -208,6 +238,13 @@ static __always_inline void mark_rt_mutex_waiters(struct rt_mutex_base *lock)
 		owner = *p;
 	} while (cmpxchg_relaxed(p, owner,
 				 owner | RT_MUTEX_HAS_WAITERS) != owner);
+
+	/*
+	 * The cmpxchg loop above is relaxed to avoid back-to-back ACQUIRE
+	 * operations in the event of contention. Ensure the successful
+	 * cmpxchg is visible.
+	 */
+	smp_mb__after_atomic();
 }
 
 /*
@@ -1243,7 +1280,7 @@ static int __sched __rt_mutex_slowtrylock(struct rt_mutex_base *lock)
 	 * try_to_take_rt_mutex() sets the lock waiters bit
 	 * unconditionally. Clean this up.
 	 */
-	fixup_rt_mutex_waiters(lock);
+	fixup_rt_mutex_waiters(lock, true);
 
 	return ret;
 }
@@ -1604,7 +1641,7 @@ static int __sched __rt_mutex_slowlock(struct rt_mutex_base *lock,
 	 * try_to_take_rt_mutex() sets the waiter bit
 	 * unconditionally. We might have to fix that up.
 	 */
-	fixup_rt_mutex_waiters(lock);
+	fixup_rt_mutex_waiters(lock, true);
 
 	trace_contention_end(lock, ret);
 
@@ -1719,7 +1756,7 @@ static void __sched rtlock_slowlock_locked(struct rt_mutex_base *lock)
 	 * try_to_take_rt_mutex() sets the waiter bit unconditionally.
 	 * We might have to fix that up:
 	 */
-	fixup_rt_mutex_waiters(lock);
+	fixup_rt_mutex_waiters(lock, true);
 	debug_rt_mutex_free_waiter(&waiter);
 
 	trace_contention_end(lock, 0);
diff --git a/kernel/locking/rtmutex_api.c b/kernel/locking/rtmutex_api.c
index 900220941caa..cb9fdff76a8a 100644
--- a/kernel/locking/rtmutex_api.c
+++ b/kernel/locking/rtmutex_api.c
@@ -267,7 +267,7 @@ void __sched rt_mutex_init_proxy_locked(struct rt_mutex_base *lock,
 void __sched rt_mutex_proxy_unlock(struct rt_mutex_base *lock)
 {
 	debug_rt_mutex_proxy_unlock(lock);
-	rt_mutex_set_owner(lock, NULL);
+	rt_mutex_clear_owner(lock);
 }
 
 /**
@@ -382,7 +382,7 @@ int __sched rt_mutex_wait_proxy_lock(struct rt_mutex_base *lock,
 	 * try_to_take_rt_mutex() sets the waiter bit unconditionally. We might
 	 * have to fix that up.
 	 */
-	fixup_rt_mutex_waiters(lock);
+	fixup_rt_mutex_waiters(lock, true);
 	raw_spin_unlock_irq(&lock->wait_lock);
 
 	return ret;
@@ -438,7 +438,7 @@ bool __sched rt_mutex_cleanup_proxy_lock(struct rt_mutex_base *lock,
 	 * try_to_take_rt_mutex() sets the waiter bit unconditionally. We might
 	 * have to fix that up.
 	 */
-	fixup_rt_mutex_waiters(lock);
+	fixup_rt_mutex_waiters(lock, false);
 
 	raw_spin_unlock_irq(&lock->wait_lock);
 
diff --git a/mm/compaction.c b/mm/compaction.c
index 88fea74c3a86..8552f5ea358d 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1346,7 +1346,7 @@ move_freelist_tail(struct list_head *freelist, struct page *freepage)
 }
 
 static void
-fast_isolate_around(struct compact_control *cc, unsigned long pfn, unsigned long nr_isolated)
+fast_isolate_around(struct compact_control *cc, unsigned long pfn)
 {
 	unsigned long start_pfn, end_pfn;
 	struct page *page;
@@ -1367,21 +1367,13 @@ fast_isolate_around(struct compact_control *cc, unsigned long pfn, unsigned long
 	if (!page)
 		return;
 
-	/* Scan before */
-	if (start_pfn != pfn) {
-		isolate_freepages_block(cc, &start_pfn, pfn, &cc->freepages, 1, false);
-		if (cc->nr_freepages >= cc->nr_migratepages)
-			return;
-	}
-
-	/* Scan after */
-	start_pfn = pfn + nr_isolated;
-	if (start_pfn < end_pfn)
-		isolate_freepages_block(cc, &start_pfn, end_pfn, &cc->freepages, 1, false);
+	isolate_freepages_block(cc, &start_pfn, end_pfn, &cc->freepages, 1, false);
 
 	/* Skip this pageblock in the future as it's full or nearly full */
 	if (cc->nr_freepages < cc->nr_migratepages)
 		set_pageblock_skip(page);
+
+	return;
 }
 
 /* Search orders in round-robin fashion */
@@ -1558,7 +1550,7 @@ fast_isolate_freepages(struct compact_control *cc)
 		return cc->free_pfn;
 
 	low_pfn = page_to_pfn(page);
-	fast_isolate_around(cc, low_pfn, nr_isolated);
+	fast_isolate_around(cc, low_pfn);
 	return low_pfn;
 }
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index b73d3248d976..dd385d774947 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1525,6 +1525,7 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned long, start, unsigned long, le
 		 * the home node for vmas we already updated before.
 		 */
 		if (new->mode != MPOL_BIND && new->mode != MPOL_PREFERRED_MANY) {
+			mpol_put(new);
 			err = -EOPNOTSUPP;
 			break;
 		}
diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index bcd74dddbe2d..9a5db285d4ae 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1162,18 +1162,23 @@ static int gss_read_proxy_verf(struct svc_rqst *rqstp,
 		return res;
 
 	inlen = svc_getnl(argv);
-	if (inlen > (argv->iov_len + rqstp->rq_arg.page_len))
+	if (inlen > (argv->iov_len + rqstp->rq_arg.page_len)) {
+		kfree(in_handle->data);
 		return SVC_DENIED;
+	}
 
 	pages = DIV_ROUND_UP(inlen, PAGE_SIZE);
 	in_token->pages = kcalloc(pages, sizeof(struct page *), GFP_KERNEL);
-	if (!in_token->pages)
+	if (!in_token->pages) {
+		kfree(in_handle->data);
 		return SVC_DENIED;
+	}
 	in_token->page_base = 0;
 	in_token->page_len = inlen;
 	for (i = 0; i < pages; i++) {
 		in_token->pages[i] = alloc_page(GFP_KERNEL);
 		if (!in_token->pages[i]) {
+			kfree(in_handle->data);
 			gss_free_in_token_pages(in_token);
 			return SVC_DENIED;
 		}
diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 913509b29f93..8c0668304cbb 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -167,6 +167,7 @@ struct hdmi_spec {
 	struct hdmi_ops ops;
 
 	bool dyn_pin_out;
+	bool static_pcm_mapping;
 	/* hdmi interrupt trigger control flag for Nvidia codec */
 	bool hdmi_intr_trig_ctrl;
 	bool nv_dp_workaround; /* workaround DP audio infoframe for Nvidia */
@@ -1525,13 +1526,16 @@ static void update_eld(struct hda_codec *codec,
 	 */
 	pcm_jack = pin_idx_to_pcm_jack(codec, per_pin);
 
-	if (eld->eld_valid) {
-		hdmi_attach_hda_pcm(spec, per_pin);
-		hdmi_pcm_setup_pin(spec, per_pin);
-	} else {
-		hdmi_pcm_reset_pin(spec, per_pin);
-		hdmi_detach_hda_pcm(spec, per_pin);
+	if (!spec->static_pcm_mapping) {
+		if (eld->eld_valid) {
+			hdmi_attach_hda_pcm(spec, per_pin);
+			hdmi_pcm_setup_pin(spec, per_pin);
+		} else {
+			hdmi_pcm_reset_pin(spec, per_pin);
+			hdmi_detach_hda_pcm(spec, per_pin);
+		}
 	}
+
 	/* if pcm_idx == -1, it means this is in monitor connection event
 	 * we can get the correct pcm_idx now.
 	 */
@@ -2281,8 +2285,8 @@ static int generic_hdmi_build_pcms(struct hda_codec *codec)
 	struct hdmi_spec *spec = codec->spec;
 	int idx, pcm_num;
 
-	/* limit the PCM devices to the codec converters */
-	pcm_num = spec->num_cvts;
+	/* limit the PCM devices to the codec converters or available PINs */
+	pcm_num = min(spec->num_cvts, spec->num_pins);
 	codec_dbg(codec, "hdmi: pcm_num set to %d\n", pcm_num);
 
 	for (idx = 0; idx < pcm_num; idx++) {
@@ -2379,6 +2383,11 @@ static int generic_hdmi_build_controls(struct hda_codec *codec)
 		struct hdmi_spec_per_pin *per_pin = get_pin(spec, pin_idx);
 		struct hdmi_eld *pin_eld = &per_pin->sink_eld;
 
+		if (spec->static_pcm_mapping) {
+			hdmi_attach_hda_pcm(spec, per_pin);
+			hdmi_pcm_setup_pin(spec, per_pin);
+		}
+
 		pin_eld->eld_valid = false;
 		hdmi_present_sense(per_pin, 0);
 	}
@@ -4419,6 +4428,8 @@ static int patch_atihdmi(struct hda_codec *codec)
 
 	spec = codec->spec;
 
+	spec->static_pcm_mapping = true;
+
 	spec->ops.pin_get_eld = atihdmi_pin_get_eld;
 	spec->ops.pin_setup_infoframe = atihdmi_pin_setup_infoframe;
 	spec->ops.pin_hbr_setup = atihdmi_pin_hbr_setup;
diff --git a/sound/usb/line6/driver.c b/sound/usb/line6/driver.c
index 59faa5a9a714..b67617b68e50 100644
--- a/sound/usb/line6/driver.c
+++ b/sound/usb/line6/driver.c
@@ -304,7 +304,8 @@ static void line6_data_received(struct urb *urb)
 		for (;;) {
 			done =
 				line6_midibuf_read(mb, line6->buffer_message,
-						LINE6_MIDI_MESSAGE_MAXLEN);
+						   LINE6_MIDI_MESSAGE_MAXLEN,
+						   LINE6_MIDIBUF_READ_RX);
 
 			if (done <= 0)
 				break;
diff --git a/sound/usb/line6/midi.c b/sound/usb/line6/midi.c
index ba0e2b7e8fe1..0838632c788e 100644
--- a/sound/usb/line6/midi.c
+++ b/sound/usb/line6/midi.c
@@ -44,7 +44,8 @@ static void line6_midi_transmit(struct snd_rawmidi_substream *substream)
 	int req, done;
 
 	for (;;) {
-		req = min(line6_midibuf_bytes_free(mb), line6->max_packet_size);
+		req = min3(line6_midibuf_bytes_free(mb), line6->max_packet_size,
+			   LINE6_FALLBACK_MAXPACKETSIZE);
 		done = snd_rawmidi_transmit_peek(substream, chunk, req);
 
 		if (done == 0)
@@ -56,7 +57,8 @@ static void line6_midi_transmit(struct snd_rawmidi_substream *substream)
 
 	for (;;) {
 		done = line6_midibuf_read(mb, chunk,
-					  LINE6_FALLBACK_MAXPACKETSIZE);
+					  LINE6_FALLBACK_MAXPACKETSIZE,
+					  LINE6_MIDIBUF_READ_TX);
 
 		if (done == 0)
 			break;
diff --git a/sound/usb/line6/midibuf.c b/sound/usb/line6/midibuf.c
index 6a70463f82c4..e7f830f7526c 100644
--- a/sound/usb/line6/midibuf.c
+++ b/sound/usb/line6/midibuf.c
@@ -9,6 +9,7 @@
 
 #include "midibuf.h"
 
+
 static int midibuf_message_length(unsigned char code)
 {
 	int message_length;
@@ -20,12 +21,7 @@ static int midibuf_message_length(unsigned char code)
 
 		message_length = length[(code >> 4) - 8];
 	} else {
-		/*
-		   Note that according to the MIDI specification 0xf2 is
-		   the "Song Position Pointer", but this is used by Line 6
-		   to send sysex messages to the host.
-		 */
-		static const int length[] = { -1, 2, -1, 2, -1, -1, 1, 1, 1, 1,
+		static const int length[] = { -1, 2, 2, 2, -1, -1, 1, 1, 1, -1,
 			1, 1, 1, -1, 1, 1
 		};
 		message_length = length[code & 0x0f];
@@ -125,7 +121,7 @@ int line6_midibuf_write(struct midi_buffer *this, unsigned char *data,
 }
 
 int line6_midibuf_read(struct midi_buffer *this, unsigned char *data,
-		       int length)
+		       int length, int read_type)
 {
 	int bytes_used;
 	int length1, length2;
@@ -148,9 +144,22 @@ int line6_midibuf_read(struct midi_buffer *this, unsigned char *data,
 
 	length1 = this->size - this->pos_read;
 
-	/* check MIDI command length */
 	command = this->buf[this->pos_read];
+	/*
+	   PODxt always has status byte lower nibble set to 0010,
+	   when it means to send 0000, so we correct if here so
+	   that control/program changes come on channel 1 and
+	   sysex message status byte is correct
+	 */
+	if (read_type == LINE6_MIDIBUF_READ_RX) {
+		if (command == 0xb2 || command == 0xc2 || command == 0xf2) {
+			unsigned char fixed = command & 0xf0;
+			this->buf[this->pos_read] = fixed;
+			command = fixed;
+		}
+	}
 
+	/* check MIDI command length */
 	if (command & 0x80) {
 		midi_length = midibuf_message_length(command);
 		this->command_prev = command;
diff --git a/sound/usb/line6/midibuf.h b/sound/usb/line6/midibuf.h
index 124a8f9f7e96..542e8d836f87 100644
--- a/sound/usb/line6/midibuf.h
+++ b/sound/usb/line6/midibuf.h
@@ -8,6 +8,9 @@
 #ifndef MIDIBUF_H
 #define MIDIBUF_H
 
+#define LINE6_MIDIBUF_READ_TX 0
+#define LINE6_MIDIBUF_READ_RX 1
+
 struct midi_buffer {
 	unsigned char *buf;
 	int size;
@@ -23,7 +26,7 @@ extern void line6_midibuf_destroy(struct midi_buffer *mb);
 extern int line6_midibuf_ignore(struct midi_buffer *mb, int length);
 extern int line6_midibuf_init(struct midi_buffer *mb, int size, int split);
 extern int line6_midibuf_read(struct midi_buffer *mb, unsigned char *data,
-			      int length);
+			      int length, int read_type);
 extern void line6_midibuf_reset(struct midi_buffer *mb);
 extern int line6_midibuf_write(struct midi_buffer *mb, unsigned char *data,
 			       int length);
diff --git a/sound/usb/line6/pod.c b/sound/usb/line6/pod.c
index cd41aa7f0385..d173971e5f02 100644
--- a/sound/usb/line6/pod.c
+++ b/sound/usb/line6/pod.c
@@ -159,8 +159,9 @@ static struct line6_pcm_properties pod_pcm_properties = {
 	.bytes_per_channel = 3 /* SNDRV_PCM_FMTBIT_S24_3LE */
 };
 
+
 static const char pod_version_header[] = {
-	0xf2, 0x7e, 0x7f, 0x06, 0x02
+	0xf0, 0x7e, 0x7f, 0x06, 0x02
 };
 
 static char *pod_alloc_sysex_buffer(struct usb_line6_pod *pod, int code,
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 67afdce3421f..274bc3d4bc3f 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -207,7 +207,7 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
 		return false;
 
 	insn = find_insn(file, func->sec, func->offset);
-	if (!insn->func)
+	if (!insn || !insn->func)
 		return false;
 
 	func_for_each_insn(file, func, insn) {
