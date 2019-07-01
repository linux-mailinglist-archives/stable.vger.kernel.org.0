Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB51528A76
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388381AbfEWTPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:15:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388900AbfEWTPJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:15:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91732217D7;
        Thu, 23 May 2019 19:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638908;
        bh=Zyi6/V6Q9wxuy+2AalVKF76usHYRC+U6nu1asExXwKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uu+CkX8J/ISODK0ZEGbpiTqIqCElpeWpkDY31ZzlJyp9+AmQOE4v+lSRoZ8YKxuNx
         FfHQcpeNcICDmbMom/1CP8fdxFxLwWh8CUuLPTgdQusDe0epNVhN5BAGC4CPxbNO2H
         NJKroF++6f0SLWzYG4nODf7+q5wNxr9aKBzg3oz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiao Ni <xni@redhat.com>,
        NeilBrown <neilb@suse.com>, Song Liu <songliubraving@fb.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.19 025/114] Revert "MD: fix lock contention for flush bios"
Date:   Thu, 23 May 2019 21:05:24 +0200
Message-Id: <20190523181734.144559010@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181731.372074275@linuxfoundation.org>
References: <20190523181731.372074275@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NeilBrown <neilb@suse.com>

commit 4bc034d35377196c854236133b07730a777c4aba upstream.

This reverts commit 5a409b4f56d50b212334f338cb8465d65550cd85.

This patch has two problems.

1/ it make multiple calls to submit_bio() from inside a make_request_fn.
 The bios thus submitted will be queued on current->bio_list and not
 submitted immediately.  As the bios are allocated from a mempool,
 this can theoretically result in a deadlock - all the pool of requests
 could be in various ->bio_list queues and a subsequent mempool_alloc
 could block waiting for one of them to be released.

2/ It aims to handle a case when there are many concurrent flush requests.
  It handles this by submitting many requests in parallel - all of which
  are identical and so most of which do nothing useful.
  It would be more efficient to just send one lower-level request, but
  allow that to satisfy multiple upper-level requests.

Fixes: 5a409b4f56d5 ("MD: fix lock contention for flush bios")
Cc: <stable@vger.kernel.org> # v4.19+
Tested-by: Xiao Ni <xni@redhat.com>
Signed-off-by: NeilBrown <neilb@suse.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/md.c |  163 ++++++++++++++++++--------------------------------------
 drivers/md/md.h |   22 ++-----
 2 files changed, 62 insertions(+), 123 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -132,24 +132,6 @@ static inline int speed_max(struct mddev
 		mddev->sync_speed_max : sysctl_speed_limit_max;
 }
 
-static void * flush_info_alloc(gfp_t gfp_flags, void *data)
-{
-        return kzalloc(sizeof(struct flush_info), gfp_flags);
-}
-static void flush_info_free(void *flush_info, void *data)
-{
-        kfree(flush_info);
-}
-
-static void * flush_bio_alloc(gfp_t gfp_flags, void *data)
-{
-	return kzalloc(sizeof(struct flush_bio), gfp_flags);
-}
-static void flush_bio_free(void *flush_bio, void *data)
-{
-	kfree(flush_bio);
-}
-
 static struct ctl_table_header *raid_table_header;
 
 static struct ctl_table raid_table[] = {
@@ -429,54 +411,30 @@ static int md_congested(void *data, int
 /*
  * Generic flush handling for md
  */
-static void submit_flushes(struct work_struct *ws)
-{
-	struct flush_info *fi = container_of(ws, struct flush_info, flush_work);
-	struct mddev *mddev = fi->mddev;
-	struct bio *bio = fi->bio;
-
-	bio->bi_opf &= ~REQ_PREFLUSH;
-	md_handle_request(mddev, bio);
-
-	mempool_free(fi, mddev->flush_pool);
-}
 
-static void md_end_flush(struct bio *fbio)
+static void md_end_flush(struct bio *bio)
 {
-	struct flush_bio *fb = fbio->bi_private;
-	struct md_rdev *rdev = fb->rdev;
-	struct flush_info *fi = fb->fi;
-	struct bio *bio = fi->bio;
-	struct mddev *mddev = fi->mddev;
+	struct md_rdev *rdev = bio->bi_private;
+	struct mddev *mddev = rdev->mddev;
 
 	rdev_dec_pending(rdev, mddev);
 
-	if (atomic_dec_and_test(&fi->flush_pending)) {
-		if (bio->bi_iter.bi_size == 0) {
-			/* an empty barrier - all done */
-			bio_endio(bio);
-			mempool_free(fi, mddev->flush_pool);
-		} else {
-			INIT_WORK(&fi->flush_work, submit_flushes);
-			queue_work(md_wq, &fi->flush_work);
-		}
+	if (atomic_dec_and_test(&mddev->flush_pending)) {
+		/* The pre-request flush has finished */
+		queue_work(md_wq, &mddev->flush_work);
 	}
-
-	mempool_free(fb, mddev->flush_bio_pool);
-	bio_put(fbio);
+	bio_put(bio);
 }
 
-void md_flush_request(struct mddev *mddev, struct bio *bio)
+static void md_submit_flush_data(struct work_struct *ws);
+
+static void submit_flushes(struct work_struct *ws)
 {
+	struct mddev *mddev = container_of(ws, struct mddev, flush_work);
 	struct md_rdev *rdev;
-	struct flush_info *fi;
-
-	fi = mempool_alloc(mddev->flush_pool, GFP_NOIO);
-
-	fi->bio = bio;
-	fi->mddev = mddev;
-	atomic_set(&fi->flush_pending, 1);
 
+	INIT_WORK(&mddev->flush_work, md_submit_flush_data);
+	atomic_set(&mddev->flush_pending, 1);
 	rcu_read_lock();
 	rdev_for_each_rcu(rdev, mddev)
 		if (rdev->raid_disk >= 0 &&
@@ -486,40 +444,59 @@ void md_flush_request(struct mddev *mdde
 			 * we reclaim rcu_read_lock
 			 */
 			struct bio *bi;
-			struct flush_bio *fb;
 			atomic_inc(&rdev->nr_pending);
 			atomic_inc(&rdev->nr_pending);
 			rcu_read_unlock();
-
-			fb = mempool_alloc(mddev->flush_bio_pool, GFP_NOIO);
-			fb->fi = fi;
-			fb->rdev = rdev;
-
 			bi = bio_alloc_mddev(GFP_NOIO, 0, mddev);
-			bio_set_dev(bi, rdev->bdev);
 			bi->bi_end_io = md_end_flush;
-			bi->bi_private = fb;
+			bi->bi_private = rdev;
+			bio_set_dev(bi, rdev->bdev);
 			bi->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
-
-			atomic_inc(&fi->flush_pending);
+			atomic_inc(&mddev->flush_pending);
 			submit_bio(bi);
-
 			rcu_read_lock();
 			rdev_dec_pending(rdev, mddev);
 		}
 	rcu_read_unlock();
+	if (atomic_dec_and_test(&mddev->flush_pending))
+		queue_work(md_wq, &mddev->flush_work);
+}
 
-	if (atomic_dec_and_test(&fi->flush_pending)) {
-		if (bio->bi_iter.bi_size == 0) {
-			/* an empty barrier - all done */
-			bio_endio(bio);
-			mempool_free(fi, mddev->flush_pool);
-		} else {
-			INIT_WORK(&fi->flush_work, submit_flushes);
-			queue_work(md_wq, &fi->flush_work);
-		}
+static void md_submit_flush_data(struct work_struct *ws)
+{
+	struct mddev *mddev = container_of(ws, struct mddev, flush_work);
+	struct bio *bio = mddev->flush_bio;
+
+	/*
+	 * must reset flush_bio before calling into md_handle_request to avoid a
+	 * deadlock, because other bios passed md_handle_request suspend check
+	 * could wait for this and below md_handle_request could wait for those
+	 * bios because of suspend check
+	 */
+	mddev->flush_bio = NULL;
+	wake_up(&mddev->sb_wait);
+
+	if (bio->bi_iter.bi_size == 0) {
+		/* an empty barrier - all done */
+		bio_endio(bio);
+	} else {
+		bio->bi_opf &= ~REQ_PREFLUSH;
+		md_handle_request(mddev, bio);
 	}
 }
+
+void md_flush_request(struct mddev *mddev, struct bio *bio)
+{
+	spin_lock_irq(&mddev->lock);
+	wait_event_lock_irq(mddev->sb_wait,
+			    !mddev->flush_bio,
+			    mddev->lock);
+	mddev->flush_bio = bio;
+	spin_unlock_irq(&mddev->lock);
+
+	INIT_WORK(&mddev->flush_work, submit_flushes);
+	queue_work(md_wq, &mddev->flush_work);
+}
 EXPORT_SYMBOL(md_flush_request);
 
 static inline struct mddev *mddev_get(struct mddev *mddev)
@@ -566,6 +543,7 @@ void mddev_init(struct mddev *mddev)
 	atomic_set(&mddev->openers, 0);
 	atomic_set(&mddev->active_io, 0);
 	spin_lock_init(&mddev->lock);
+	atomic_set(&mddev->flush_pending, 0);
 	init_waitqueue_head(&mddev->sb_wait);
 	init_waitqueue_head(&mddev->recovery_wait);
 	mddev->reshape_position = MaxSector;
@@ -5519,22 +5497,6 @@ int md_run(struct mddev *mddev)
 		if (err)
 			return err;
 	}
-	if (mddev->flush_pool == NULL) {
-		mddev->flush_pool = mempool_create(NR_FLUSH_INFOS, flush_info_alloc,
-						flush_info_free, mddev);
-		if (!mddev->flush_pool) {
-			err = -ENOMEM;
-			goto abort;
-		}
-	}
-	if (mddev->flush_bio_pool == NULL) {
-		mddev->flush_bio_pool = mempool_create(NR_FLUSH_BIOS, flush_bio_alloc,
-						flush_bio_free, mddev);
-		if (!mddev->flush_bio_pool) {
-			err = -ENOMEM;
-			goto abort;
-		}
-	}
 
 	spin_lock(&pers_lock);
 	pers = find_pers(mddev->level, mddev->clevel);
@@ -5694,15 +5656,8 @@ int md_run(struct mddev *mddev)
 	return 0;
 
 abort:
-	if (mddev->flush_bio_pool) {
-		mempool_destroy(mddev->flush_bio_pool);
-		mddev->flush_bio_pool = NULL;
-	}
-	if (mddev->flush_pool){
-		mempool_destroy(mddev->flush_pool);
-		mddev->flush_pool = NULL;
-	}
-
+	bioset_exit(&mddev->bio_set);
+	bioset_exit(&mddev->sync_set);
 	return err;
 }
 EXPORT_SYMBOL_GPL(md_run);
@@ -5906,14 +5861,6 @@ static void __md_stop(struct mddev *mdde
 		mddev->to_remove = &md_redundancy_group;
 	module_put(pers->owner);
 	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-	if (mddev->flush_bio_pool) {
-		mempool_destroy(mddev->flush_bio_pool);
-		mddev->flush_bio_pool = NULL;
-	}
-	if (mddev->flush_pool) {
-		mempool_destroy(mddev->flush_pool);
-		mddev->flush_pool = NULL;
-	}
 }
 
 void md_stop(struct mddev *mddev)
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -252,19 +252,6 @@ enum mddev_sb_flags {
 	MD_SB_NEED_REWRITE,	/* metadata write needs to be repeated */
 };
 
-#define NR_FLUSH_INFOS 8
-#define NR_FLUSH_BIOS 64
-struct flush_info {
-	struct bio			*bio;
-	struct mddev			*mddev;
-	struct work_struct		flush_work;
-	atomic_t			flush_pending;
-};
-struct flush_bio {
-	struct flush_info *fi;
-	struct md_rdev *rdev;
-};
-
 struct mddev {
 	void				*private;
 	struct md_personality		*pers;
@@ -470,8 +457,13 @@ struct mddev {
 						   * metadata and bitmap writes
 						   */
 
-	mempool_t			*flush_pool;
-	mempool_t			*flush_bio_pool;
+	/* Generic flush handling.
+	 * The last to finish preflush schedules a worker to submit
+	 * the rest of the request (without the REQ_PREFLUSH flag).
+	 */
+	struct bio *flush_bio;
+	atomic_t flush_pending;
+	struct work_struct flush_work;
 	struct work_struct event_work;	/* used by dm to report failure event */
 	void (*sync_super)(struct mddev *mddev, struct md_rdev *rdev);
 	struct md_cluster_info		*cluster_info;


