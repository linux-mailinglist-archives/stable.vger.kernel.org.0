Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24DDA54160A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357828AbiFGUpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376452AbiFGUnu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:43:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB51F1F488C;
        Tue,  7 Jun 2022 11:39:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 715246163C;
        Tue,  7 Jun 2022 18:39:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807ADC385A2;
        Tue,  7 Jun 2022 18:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627148;
        bh=ipib4LDnsrNuYV39Hee7VITS/yTE8mNV/JLjcl2se30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uG8RA+ZW8f6+xEWczyH8tS0S9H7nmV40NnHwZcCGRvotqRiIVAtJbHwMr3aG8K8P2
         BggoVocez20QoYYJ+vTTA2A1u+rSTc+Ghw/r3vA899HECN1TheBFEqWEHg6eoDvuvl
         I+Nr9TwJauHRPF+2hIyaFwogEdeOoQ9ePRv+B0/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.17 634/772] bfq: Get rid of __bio_blkcg() usage
Date:   Tue,  7 Jun 2022 19:03:46 +0200
Message-Id: <20220607165007.618224249@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bfq-cgroup.c  |   63 ++++++++++++++++++----------------------------------
 block/bfq-iosched.c |   11 ---------
 block/bfq-iosched.h |    3 --
 3 files changed, 25 insertions(+), 52 deletions(-)

--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -586,27 +586,11 @@ static void bfq_group_set_parent(struct
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
@@ -623,8 +607,15 @@ struct bfq_group *bfq_find_set_group(str
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
@@ -706,25 +697,15 @@ void bfq_bfqq_move(struct bfq_data *bfqd
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
 
@@ -776,20 +757,24 @@ static struct bfq_group *__bfq_bic_chang
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
@@ -842,8 +827,6 @@ void bfq_bic_update_cgroup(struct bfq_io
 	 */
 	blkg_path(bfqg_to_blkg(bfqg), bfqg->blkg_path, sizeof(bfqg->blkg_path));
 	bic->blkcg_serial_nr = serial_nr;
-out:
-	rcu_read_unlock();
 }
 
 /**
@@ -1461,7 +1444,7 @@ void bfq_end_wr_async(struct bfq_data *b
 	bfq_end_wr_async_queues(bfqd, bfqd->root_group);
 }
 
-struct bfq_group *bfq_find_set_group(struct bfq_data *bfqd, struct blkcg *blkcg)
+struct bfq_group *bfq_bio_bfqg(struct bfq_data *bfqd, struct bio *bio)
 {
 	return bfqd->root_group;
 }
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5730,14 +5730,7 @@ static struct bfq_queue *bfq_get_queue(s
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
@@ -5783,8 +5776,6 @@ out:
 
 	if (bfqq != &bfqd->oom_bfqq && is_sync && !respawn)
 		bfqq = bfq_do_or_sched_stable_merge(bfqd, bfqq, bic);
-
-	rcu_read_unlock();
 	return bfqq;
 }
 
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -1011,8 +1011,7 @@ void bfq_bfqq_move(struct bfq_data *bfqd
 void bfq_init_entity(struct bfq_entity *entity, struct bfq_group *bfqg);
 void bfq_bic_update_cgroup(struct bfq_io_cq *bic, struct bio *bio);
 void bfq_end_wr_async(struct bfq_data *bfqd);
-struct bfq_group *bfq_find_set_group(struct bfq_data *bfqd,
-				     struct blkcg *blkcg);
+struct bfq_group *bfq_bio_bfqg(struct bfq_data *bfqd, struct bio *bio);
 struct blkcg_gq *bfqg_to_blkg(struct bfq_group *bfqg);
 struct bfq_group *bfqq_group(struct bfq_queue *bfqq);
 struct bfq_group *bfq_create_group_hierarchy(struct bfq_data *bfqd, int node);


