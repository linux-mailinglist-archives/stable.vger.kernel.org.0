Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 665D34EEB49
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 12:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245675AbiDAK34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 06:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245676AbiDAK3r (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 06:29:47 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A23426E57B;
        Fri,  1 Apr 2022 03:27:56 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id BC6811FD05;
        Fri,  1 Apr 2022 10:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1648808874; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p8HInWOn0JhCGNwoQJmTzRAGa2b1vZ1mm3a6v3TxOEk=;
        b=NHawarvg96YwPJfe8jGHAS35dQ6mnS1pIvyMP3ws8ulU8byrNgeqcz4irLxZXEuGcGRHbk
        gV670bS6uiOFTgUL88hZpe4+GfD2dSdqT57sVIuhrB9AidgJTyEn754T4CvRYrPsNUs2TN
        XAH/132sDS/rRNdxzXkWRwAGdLBgei4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1648808874;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p8HInWOn0JhCGNwoQJmTzRAGa2b1vZ1mm3a6v3TxOEk=;
        b=ZQouYWe8OkYwRJ/NLDM5n15237uB4542jZO3foQVEvnhiNRvZoR5ZS6R8LgrksJSr9MQwj
        EBfX193++MOc75DA==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 84B74A3B95;
        Fri,  1 Apr 2022 10:27:54 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id A09E1A061E; Fri,  1 Apr 2022 12:27:52 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Paolo Valente <paolo.valente@linaro.org>
Cc:     <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        "yukuai (C)" <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 8/9] bfq: Get rid of __bio_blkcg() usage
Date:   Fri,  1 Apr 2022 12:27:49 +0200
Message-Id: <20220401102752.8599-8-jack@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401102325.17617-1-jack@suse.cz>
References: <20220401102325.17617-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6636; h=from:subject; bh=hmCQcGPDWk91gsH0Ff6dqf205Vr5YwBuVPp7vIJKXHA=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBiRtOlRcq5SUVFcwdhJubzpp07pilAw1qLVVFvCC3T +GEjsv6JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYkbTpQAKCRCcnaoHP2RA2Uf6B/ 9NAj5dovT41inrRQ8Y2MKon+z3fJhzZEmJbYlQ8jJ0P4zuZo8FKMyQyz3XkdrJm9/9xKpLKlU/BJKz psMMCmdjOQbKHYY0xj00TkVHmZz+HTAbqQ/6V+ismZsh2I8rX7uvHk+Js03A7+xkMh33gr4jpLwwrb zSjYHKsfXfTb45CecRxO+iTjdbn6TY2BOmmbA7B+TCqOe2wqf0OvD2rr55cOYNpTt2C3QWjJqGnEJl XOfCn0D9EdG55dzTIFxY/w/6phN+YudB7XgiDH8mrKOW628kkYmHRLzpn0VZaD0AwsMqryqAoH0pf0 JFejz0ZV9632cZ50HZ+V6LtyB55rOa
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
---
 block/bfq-cgroup.c  | 63 +++++++++++++++++----------------------------
 block/bfq-iosched.c | 11 +-------
 block/bfq-iosched.h |  3 +--
 3 files changed, 25 insertions(+), 52 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 879380c2bc7e..32d2c2a47480 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -586,27 +586,11 @@ static void bfq_group_set_parent(struct bfq_group *bfqg,
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
@@ -623,8 +607,15 @@ struct bfq_group *bfq_find_set_group(struct bfq_data *bfqd,
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
@@ -714,25 +705,15 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct bfq_queue *bfqq,
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
 
@@ -784,20 +765,24 @@ static struct bfq_group *__bfq_bic_change_cgroup(struct bfq_data *bfqd,
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
@@ -850,8 +835,6 @@ void bfq_bic_update_cgroup(struct bfq_io_cq *bic, struct bio *bio)
 	 */
 	blkg_path(bfqg_to_blkg(bfqg), bfqg->blkg_path, sizeof(bfqg->blkg_path));
 	bic->blkcg_serial_nr = serial_nr;
-out:
-	rcu_read_unlock();
 }
 
 /**
@@ -1469,7 +1452,7 @@ void bfq_end_wr_async(struct bfq_data *bfqd)
 	bfq_end_wr_async_queues(bfqd, bfqd->root_group);
 }
 
-struct bfq_group *bfq_find_set_group(struct bfq_data *bfqd, struct blkcg *blkcg)
+struct bfq_group *bfq_bio_bfqg(struct bfq_data *bfqd, struct bio *bio)
 {
 	return bfqd->root_group;
 }
diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index d7cf930b47bb..e47c75f1fa0f 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5726,14 +5726,7 @@ static struct bfq_queue *bfq_get_queue(struct bfq_data *bfqd,
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
@@ -5779,8 +5772,6 @@ static struct bfq_queue *bfq_get_queue(struct bfq_data *bfqd,
 
 	if (bfqq != &bfqd->oom_bfqq && is_sync && !respawn)
 		bfqq = bfq_do_or_sched_stable_merge(bfqd, bfqq, bic);
-
-	rcu_read_unlock();
 	return bfqq;
 }
 
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index 4664e2f3e828..978ef5d6fe6a 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -1009,8 +1009,7 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct bfq_queue *bfqq,
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
2.34.1

