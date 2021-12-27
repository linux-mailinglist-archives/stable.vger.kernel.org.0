Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1AA747FED2
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237941AbhL0Pcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:32:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237917AbhL0Pcr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:32:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAEA4C061401;
        Mon, 27 Dec 2021 07:32:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2384F610B1;
        Mon, 27 Dec 2021 15:32:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A25C36AEA;
        Mon, 27 Dec 2021 15:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619165;
        bh=bkkvtuQHKQ7JDM2j8xAkA1tAuuHC0E51A1juq3voA+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K8nhjFJ+W4ZlGmqFXev3EtdiMR1FiW4QUXnJ1ekO6JXyvyauZ3avndvfbtt1pOfyZ
         eslEVo+23EssmZF1WRlfpg1xu0LKp5Oj2oZcL4lTURkQZG3E1PmjsBRNmmTjvRQ0ss
         LYDz/c2bCixAhB75Fb1tc4IkSaGwJ+xU2MJv68jc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH 4.19 05/38] block, bfq: fix queue removal from weights tree
Date:   Mon, 27 Dec 2021 16:30:42 +0100
Message-Id: <20211227151319.558352245@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151319.379265346@linuxfoundation.org>
References: <20211227151319.379265346@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Valente <paolo.valente@linaro.org>

commit 9dee8b3b057e1da26f85f1842f2aaf3bb200fb94 upstream.

bfq maintains an ordered list, through a red-black tree, of unique
weights of active bfq_queues. This list is used to detect whether there
are active queues with differentiated weights. The weight of a queue is
removed from the list when both the following two conditions become
true:

(1) the bfq_queue is flagged as inactive
(2) the has no in-flight request any longer;

Unfortunately, in the rare cases where condition (2) becomes true before
condition (1), the removal fails, because the function to remove the
weight of the queue (bfq_weights_tree_remove) is rightly invoked in the
path that deactivates the bfq_queue, but mistakenly invoked *before* the
function that actually performs the deactivation (bfq_deactivate_bfqq).

This commits moves the invocation of bfq_weights_tree_remove for
condition (1) to after bfq_deactivate_bfqq. As a consequence of this
move, it is necessary to add a further reference to the queue when the
weight of a queue is added, because the queue might otherwise be freed
before bfq_weights_tree_remove is invoked. This commit adds this
reference and makes all related modifications.

Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bfq-iosched.c |   17 +++++++++++++----
 block/bfq-wf2q.c    |    6 +++---
 2 files changed, 16 insertions(+), 7 deletions(-)

--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -748,6 +748,7 @@ void bfq_weights_tree_add(struct bfq_dat
 
 inc_counter:
 	bfqq->weight_counter->num_active++;
+	bfqq->ref++;
 }
 
 /*
@@ -772,6 +773,7 @@ void __bfq_weights_tree_remove(struct bf
 
 reset_entity_pointer:
 	bfqq->weight_counter = NULL;
+	bfq_put_queue(bfqq);
 }
 
 /*
@@ -783,9 +785,6 @@ void bfq_weights_tree_remove(struct bfq_
 {
 	struct bfq_entity *entity = bfqq->entity.parent;
 
-	__bfq_weights_tree_remove(bfqd, bfqq,
-				  &bfqd->queue_weights_tree);
-
 	for_each_entity(entity) {
 		struct bfq_sched_data *sd = entity->my_sched_data;
 
@@ -819,6 +818,15 @@ void bfq_weights_tree_remove(struct bfq_
 			bfqd->num_groups_with_pending_reqs--;
 		}
 	}
+
+	/*
+	 * Next function is invoked last, because it causes bfqq to be
+	 * freed if the following holds: bfqq is not in service and
+	 * has no dispatched request. DO NOT use bfqq after the next
+	 * function invocation.
+	 */
+	__bfq_weights_tree_remove(bfqd, bfqq,
+				  &bfqd->queue_weights_tree);
 }
 
 /*
@@ -1012,7 +1020,8 @@ bfq_bfqq_resume_state(struct bfq_queue *
 
 static int bfqq_process_refs(struct bfq_queue *bfqq)
 {
-	return bfqq->ref - bfqq->allocated - bfqq->entity.on_st;
+	return bfqq->ref - bfqq->allocated - bfqq->entity.on_st -
+		(bfqq->weight_counter != NULL);
 }
 
 /* Empty burst list and add just bfqq (see comments on bfq_handle_burst) */
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -1668,15 +1668,15 @@ void bfq_del_bfqq_busy(struct bfq_data *
 
 	bfqd->busy_queues--;
 
-	if (!bfqq->dispatched)
-		bfq_weights_tree_remove(bfqd, bfqq);
-
 	if (bfqq->wr_coeff > 1)
 		bfqd->wr_busy_queues--;
 
 	bfqg_stats_update_dequeue(bfqq_group(bfqq));
 
 	bfq_deactivate_bfqq(bfqd, bfqq, true, expiration);
+
+	if (!bfqq->dispatched)
+		bfq_weights_tree_remove(bfqd, bfqq);
 }
 
 /*


