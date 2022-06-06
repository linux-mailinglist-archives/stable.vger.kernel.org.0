Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C25BC53ED62
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbiFFR5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 13:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbiFFR5H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 13:57:07 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1290531CC89;
        Mon,  6 Jun 2022 10:57:02 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 1959D1FAB6;
        Mon,  6 Jun 2022 17:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654538221; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dbPawdX5B3E2oP+8USedKhNrEeSZHwGBIF1v9bBKK74=;
        b=d9fftP95D+h379D3aU9+n7a9dWJQ1ztc48AaDQkes9jhv4UT2AOG+DIHvyJcjTjDh/Pmph
        slCyyELy7mgrJKWENiv+OnQgXug1sueM82pjHyPzmtN9dT2UYKzhWMFnGKMjxGniIetLEQ
        dvNrFZ2vh7VuK+pxcoyGpr/glzNkheg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654538221;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dbPawdX5B3E2oP+8USedKhNrEeSZHwGBIF1v9bBKK74=;
        b=q/QdY6k4dYkQOeR6NwITI+R/k766BN+xHlelDDJJd89dZjoNlYOih7XICW6htUPpyeUgHi
        sM0cU3nvAb8oosDA==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id E60642C146;
        Mon,  6 Jun 2022 17:57:00 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 225D6A0638; Mon,  6 Jun 2022 19:56:55 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     stable@vger.kernel.org
Cc:     <linux-block@vger.kernel.org>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
        "yukuai (C)" <yukuai3@huawei.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/6] bfq: Get rid of __bio_blkcg() usage
Date:   Mon,  6 Jun 2022 19:56:39 +0200
Message-Id: <20220606175655.8993-4-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220606174118.10992-1-jack@suse.cz>
References: <20220606174118.10992-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6875; h=from:subject; bh=Rw0dwNVbs0zoYjRv4tJ+QqUwOTZHh+Gw2mfV8IF+vow=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBinj/W3oPd+MsbUKCsjgJV7G1h3BWzeS6lVPEyhrz2 tvCWo2yJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYp4/1gAKCRCcnaoHP2RA2dJHCA DJzh+5bEjwNm/r752tDgnTB0y+tHEyzov8fijOC1VT72Xszcb8ZAPwXp40Mx4CV96Hm93+6/w1it7h eIq7Xi1LpccOBKe4IWa7Y25vCKMi3eH9MkO28bfi/exXYISMgOX+oFX0MCoFgfmK9Llx4Z2EpCvQDI bK9m8Lh6YobBeVhXml+UpnjpHiyCVi1YIQ9M0ghusjwJ8mYrnn1HISebTWxnssCtCDjTAeylarZiDc FED9D3ZBcoTiA7+YVw93gJpg5IQ9Tt+MkRRwWcGUudLUEhmlNQOv9UiW79i23ZZvxZMpwOqG6f+hbh WSnmfiYHwHKB8tjzP+Pg6zDnr0veAu
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
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

commit 4e54a2493e582361adc3bfbf06c7d50d19d18837 upstream.

BFQ usage of __bio_blkcg() is a relict from the past. Furthermore if bio
would not be associated with any blkcg, the usage of __bio_blkcg() in
BFQ is prone to races with the task being migrated between cgroups as
__bio_blkcg() calls at different places could return different blkcgs.

Convert BFQ to the new situation where bio->bi_blkg is initialized in
bio_set_dev() and thus practically always valid. This allows us to save
blkcg_gq lookup and noticeably simplify the code.

CC: stable@vger.kernel.org
Fixes: 0fe061b9f03c ("blkcg: fix ref count issue with bio_blkcg() using task_css")
Tested-by: "yukuai (C)" <yukuai3@huawei.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220401102752.8599-8-jack@suse.cz
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/bfq-cgroup.c  | 63 +++++++++++++++++----------------------------
 block/bfq-iosched.c | 10 +------
 block/bfq-iosched.h |  3 +--
 3 files changed, 25 insertions(+), 51 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 0077f44ad63f..622c9a13e496 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -582,27 +582,11 @@ static void bfq_group_set_parent(struct bfq_group *bfqg,
 	entity->sched_data = &parent->sched_data;
 }
 
-static struct bfq_group *bfq_lookup_bfqg(struct bfq_data *bfqd,
-					 struct blkcg *blkcg)
+static void bfq_link_bfqg(struct bfq_data *bfqd, struct bfq_group *bfqg)
 {
-	struct blkcg_gq *blkg;
-
-	blkg = blkg_lookup(blkcg, bfqd->queue);
-	if (likely(blkg))
-		return blkg_to_bfqg(blkg);
-	return NULL;
-}
-
-struct bfq_group *bfq_find_set_group(struct bfq_data *bfqd,
-				     struct blkcg *blkcg)
-{
-	struct bfq_group *bfqg, *parent;
+	struct bfq_group *parent;
 	struct bfq_entity *entity;
 
-	bfqg = bfq_lookup_bfqg(bfqd, blkcg);
-	if (unlikely(!bfqg))
-		return NULL;
-
 	/*
 	 * Update chain of bfq_groups as we might be handling a leaf group
 	 * which, along with some of its relatives, has not been hooked yet
@@ -619,8 +603,15 @@ struct bfq_group *bfq_find_set_group(struct bfq_data *bfqd,
 			bfq_group_set_parent(curr_bfqg, parent);
 		}
 	}
+}
 
-	return bfqg;
+struct bfq_group *bfq_bio_bfqg(struct bfq_data *bfqd, struct bio *bio)
+{
+	struct blkcg_gq *blkg = bio->bi_blkg;
+
+	if (!blkg)
+		return bfqd->root_group;
+	return blkg_to_bfqg(blkg);
 }
 
 /**
@@ -696,25 +687,15 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct bfq_queue *bfqq,
  * Move bic to blkcg, assuming that bfqd->lock is held; which makes
  * sure that the reference to cgroup is valid across the call (see
  * comments in bfq_bic_update_cgroup on this issue)
- *
- * NOTE: an alternative approach might have been to store the current
- * cgroup in bfqq and getting a reference to it, reducing the lookup
- * time here, at the price of slightly more complex code.
  */
-static struct bfq_group *__bfq_bic_change_cgroup(struct bfq_data *bfqd,
-						struct bfq_io_cq *bic,
-						struct blkcg *blkcg)
+static void *__bfq_bic_change_cgroup(struct bfq_data *bfqd,
+				     struct bfq_io_cq *bic,
+				     struct bfq_group *bfqg)
 {
 	struct bfq_queue *async_bfqq = bic_to_bfqq(bic, 0);
 	struct bfq_queue *sync_bfqq = bic_to_bfqq(bic, 1);
-	struct bfq_group *bfqg;
 	struct bfq_entity *entity;
 
-	bfqg = bfq_find_set_group(bfqd, blkcg);
-
-	if (unlikely(!bfqg))
-		bfqg = bfqd->root_group;
-
 	if (async_bfqq) {
 		entity = &async_bfqq->entity;
 
@@ -766,20 +747,24 @@ static struct bfq_group *__bfq_bic_change_cgroup(struct bfq_data *bfqd,
 void bfq_bic_update_cgroup(struct bfq_io_cq *bic, struct bio *bio)
 {
 	struct bfq_data *bfqd = bic_to_bfqd(bic);
-	struct bfq_group *bfqg = NULL;
+	struct bfq_group *bfqg = bfq_bio_bfqg(bfqd, bio);
 	uint64_t serial_nr;
 
-	rcu_read_lock();
-	serial_nr = __bio_blkcg(bio)->css.serial_nr;
+	serial_nr = bfqg_to_blkg(bfqg)->blkcg->css.serial_nr;
 
 	/*
 	 * Check whether blkcg has changed.  The condition may trigger
 	 * spuriously on a newly created cic but there's no harm.
 	 */
 	if (unlikely(!bfqd) || likely(bic->blkcg_serial_nr == serial_nr))
-		goto out;
+		return;
 
-	bfqg = __bfq_bic_change_cgroup(bfqd, bic, __bio_blkcg(bio));
+	/*
+	 * New cgroup for this process. Make sure it is linked to bfq internal
+	 * cgroup hierarchy.
+	 */
+	bfq_link_bfqg(bfqd, bfqg);
+	__bfq_bic_change_cgroup(bfqd, bic, bfqg);
 	/*
 	 * Update blkg_path for bfq_log_* functions. We cache this
 	 * path, and update it here, for the following
@@ -832,8 +817,6 @@ void bfq_bic_update_cgroup(struct bfq_io_cq *bic, struct bio *bio)
 	 */
 	blkg_path(bfqg_to_blkg(bfqg), bfqg->blkg_path, sizeof(bfqg->blkg_path));
 	bic->blkcg_serial_nr = serial_nr;
-out:
-	rcu_read_unlock();
 }
 
 /**
@@ -1451,7 +1434,7 @@ void bfq_end_wr_async(struct bfq_data *bfqd)
 	bfq_end_wr_async_queues(bfqd, bfqd->root_group);
 }
 
-struct bfq_group *bfq_find_set_group(struct bfq_data *bfqd, struct blkcg *blkcg)
+struct bfq_group *bfq_bio_bfqg(struct bfq_data *bfqd, struct bio *bio)
 {
 	return bfqd->root_group;
 }
diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 3b605d8d99bf..592d32a46c4c 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5162,14 +5162,7 @@ static struct bfq_queue *bfq_get_queue(struct bfq_data *bfqd,
 	struct bfq_queue *bfqq;
 	struct bfq_group *bfqg;
 
-	rcu_read_lock();
-
-	bfqg = bfq_find_set_group(bfqd, __bio_blkcg(bio));
-	if (!bfqg) {
-		bfqq = &bfqd->oom_bfqq;
-		goto out;
-	}
-
+	bfqg = bfq_bio_bfqg(bfqd, bio);
 	if (!is_sync) {
 		async_bfqq = bfq_async_queue_prio(bfqd, bfqg, ioprio_class,
 						  ioprio);
@@ -5213,7 +5206,6 @@ static struct bfq_queue *bfq_get_queue(struct bfq_data *bfqd,
 out:
 	bfqq->ref++; /* get a process reference to this queue */
 	bfq_log_bfqq(bfqd, bfqq, "get_queue, at end: %p, %d", bfqq, bfqq->ref);
-	rcu_read_unlock();
 	return bfqq;
 }
 
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index b116ed48d27d..2a4a6f44efff 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -984,8 +984,7 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 void bfq_init_entity(struct bfq_entity *entity, struct bfq_group *bfqg);
 void bfq_bic_update_cgroup(struct bfq_io_cq *bic, struct bio *bio);
 void bfq_end_wr_async(struct bfq_data *bfqd);
-struct bfq_group *bfq_find_set_group(struct bfq_data *bfqd,
-				     struct blkcg *blkcg);
+struct bfq_group *bfq_bio_bfqg(struct bfq_data *bfqd, struct bio *bio);
 struct blkcg_gq *bfqg_to_blkg(struct bfq_group *bfqg);
 struct bfq_group *bfqq_group(struct bfq_queue *bfqq);
 struct bfq_group *bfq_create_group_hierarchy(struct bfq_data *bfqd, int node);
-- 
2.35.3

