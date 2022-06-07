Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF7C653F942
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 11:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239129AbiFGJPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 05:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239106AbiFGJPg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 05:15:36 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52161B0A7D;
        Tue,  7 Jun 2022 02:15:34 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 83F6921B50;
        Tue,  7 Jun 2022 09:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654593329; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sg7PMCcZBQ27G7750WAquLF4In4PaH6ZF1MZj8QPU4M=;
        b=ROWbxK6scq6BiQdOGcJ7B/0RO8dvs+O3nhFhbgROE3ofT8iUdL//K8q8NGjKuHyoDoUg5u
        UShTnJFAqMYzLhcHNHFC1D0oTXCMPIelT2jycTvYMSXV828/VNKjdNP9zULQ9FxaeQ4N94
        OhTHZihGLhOjXSzp/fMfFvldhBqg8Is=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654593329;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sg7PMCcZBQ27G7750WAquLF4In4PaH6ZF1MZj8QPU4M=;
        b=5XBG21TgFfehaXz8jri0mUCQNrazavbPyEQuFs1RDPTRYZYNFPpMVnkAGMUq9RXdkSNHO3
        W7BgJ6W+oAoRtYAQ==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 6CE312C146;
        Tue,  7 Jun 2022 09:15:29 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 910D8A0638; Tue,  7 Jun 2022 11:15:28 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Paolo Valente <paolo.valente@linaro.org>,
        <linux-block@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        "yukuai (C)" <yukuai3@huawei.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/6] bfq: Get rid of __bio_blkcg() usage
Date:   Tue,  7 Jun 2022 11:15:12 +0200
Message-Id: <20220607091528.11906-4-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220607091209.24033-1-jack@suse.cz>
References: <20220607091209.24033-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6875; h=from:subject; bh=a5LTzZkNapz9chCL2j23V6jlrlCZrxyrMH3GEOEotwU=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBinxcf3Qlighhow2o0U8BI+Q5zBUDE7Ka9uMa1mk4L 094KHhaJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYp8XHwAKCRCcnaoHP2RA2Y7TB/ 9q6N2fpqYSB+zc6tCWMQCvNPT2lqc7S03Guwtj3Kt+qwZYB4w6DiqE1Yq/erkf+Qplrvdm3tQJsrhU 3ECjonx1Vkn9BaqtYQlQs5XxGYt02ADBrw6Ofbuhg0pzfObfvD28Gx+q5iIcvkffULgA2xDmQ6uG0X Obke6JYoRK69jlh9BFnL+P17Bdct+IU/wDU4NzYGwn93bpIt2iV13b3cEuMp4Ovl00+2lhHwFVVRc/ z4Vl9MVOOPOT68YFYsQ5PakK53GR+45AXD/5+LR9QvHhy1eu/OBU+qhByg1fgwqEi62OUN6KAKJYEG vAp3YWzVnmnSVAXwCKJ0fHYylGvGb4
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
index 095f2f65bc16..3835cd920587 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -565,27 +565,11 @@ static void bfq_group_set_parent(struct bfq_group *bfqg,
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
@@ -602,8 +586,15 @@ struct bfq_group *bfq_find_set_group(struct bfq_data *bfqd,
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
@@ -679,25 +670,15 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct bfq_queue *bfqq,
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
 
@@ -749,20 +730,24 @@ static struct bfq_group *__bfq_bic_change_cgroup(struct bfq_data *bfqd,
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
@@ -815,8 +800,6 @@ void bfq_bic_update_cgroup(struct bfq_io_cq *bic, struct bio *bio)
 	 */
 	blkg_path(bfqg_to_blkg(bfqg), bfqg->blkg_path, sizeof(bfqg->blkg_path));
 	bic->blkcg_serial_nr = serial_nr;
-out:
-	rcu_read_unlock();
 }
 
 /**
@@ -1433,7 +1416,7 @@ void bfq_end_wr_async(struct bfq_data *bfqd)
 	bfq_end_wr_async_queues(bfqd, bfqd->root_group);
 }
 
-struct bfq_group *bfq_find_set_group(struct bfq_data *bfqd, struct blkcg *blkcg)
+struct bfq_group *bfq_bio_bfqg(struct bfq_data *bfqd, struct bio *bio)
 {
 	return bfqd->root_group;
 }
diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index f91c9bb687a8..962701d3f46b 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5158,14 +5158,7 @@ static struct bfq_queue *bfq_get_queue(struct bfq_data *bfqd,
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
@@ -5209,7 +5202,6 @@ static struct bfq_queue *bfq_get_queue(struct bfq_data *bfqd,
 out:
 	bfqq->ref++; /* get a process reference to this queue */
 	bfq_log_bfqq(bfqd, bfqq, "get_queue, at end: %p, %d", bfqq, bfqq->ref);
-	rcu_read_unlock();
 	return bfqq;
 }
 
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index be1f4c1febf8..f6cc2b418008 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -978,8 +978,7 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct bfq_queue *bfqq,
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

