Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCB274EEB3C
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 12:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245560AbiDAK3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 06:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245593AbiDAK3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 06:29:45 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF9026E56A;
        Fri,  1 Apr 2022 03:27:55 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id CB8C721A98;
        Fri,  1 Apr 2022 10:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1648808873; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UCkvPmMdlj5gKMX4b0BFS+C6otL8e89DKbtDixo1Hbo=;
        b=Ko2QF1yIadeBb+JAECXJwhRb74uOUZ0p3M8g2JeWtEwYskUjTGDfl02hHbxUj9cFKrPDfO
        JhXArnxkelbGo0iWhwt/CqB6p7B1Z2LP/7uUrDy8R2addh6lmXLceQOOKRU9atHVcswtMr
        oMBxXbjA+8hgVdqMnRrI1Jmq7oLjnIk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1648808873;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UCkvPmMdlj5gKMX4b0BFS+C6otL8e89DKbtDixo1Hbo=;
        b=fT71xnm8VBy1iRrq1QHxp7Oh22p7+tYSlcGE3xHakjqhP95YA8by5tyvuqq5cehGJgID79
        awKit219buOtQtBA==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id AA4CDA3B92;
        Fri,  1 Apr 2022 10:27:53 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 822F9A0619; Fri,  1 Apr 2022 12:27:52 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Paolo Valente <paolo.valente@linaro.org>
Cc:     <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        "yukuai (C)" <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 3/9] bfq: Split shared queues on move between cgroups
Date:   Fri,  1 Apr 2022 12:27:44 +0200
Message-Id: <20220401102752.8599-3-jack@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401102325.17617-1-jack@suse.cz>
References: <20220401102325.17617-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3547; h=from:subject; bh=tITHR38wOCpdaxdNhhZ40lzu6OcKz//GDfn54YLu2Tw=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBiRtOgm2v7JAE7UPLNtQcBXxB32BvEhwmwHfVNZsST how2FiCJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYkbToAAKCRCcnaoHP2RA2XFIB/ 9XCvOu1Q0vTruGS3UgE8EBNsZx/+KbGOd38hH4ugYihBvXAyrX4H0r8eeZVFgl2//Ix56ui617goxz h7/c7T5D9qTmW5SCtPS/9HD/M5NZlIlGBv2vN7jTnZKBijhW2sZ52Lv/LwLgJoWffpWEnI5FjAtUgz fagVNDuwIHJ1hHzibhEfYsD1mLe+UtJYpxHmsaPnTlBsU5J8jb0YSnkoamhrq/Mgu1/M8t2ZdquC20 CIjWJxdphFTAR4k00IGZbi5Jz6dSqu8bpejOR2ZYMS9GU6gCvxz1Lg5cux88zao2OWxxVxi05FIdxn n19+71pzuZf/48/RkxwiTGu0bxuMFI
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

When bfqq is shared by multiple processes it can happen that one of the
processes gets moved to a different cgroup (or just starts submitting IO
for different cgroup). In case that happens we need to split the merged
bfqq as otherwise we will have IO for multiple cgroups in one bfqq and
we will just account IO time to wrong entities etc.

Similarly if the bfqq is scheduled to merge with another bfqq but the
merge didn't happen yet, cancel the merge as it need not be valid
anymore.

CC: stable@vger.kernel.org
Fixes: e21b7a0b9887 ("block, bfq: add full hierarchical scheduling and cgroups support")
Tested-by: "yukuai (C)" <yukuai3@huawei.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/bfq-cgroup.c  | 36 +++++++++++++++++++++++++++++++++---
 block/bfq-iosched.c |  2 +-
 block/bfq-iosched.h |  1 +
 3 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 420eda2589c0..9352f3cc2377 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -743,9 +743,39 @@ static struct bfq_group *__bfq_bic_change_cgroup(struct bfq_data *bfqd,
 	}
 
 	if (sync_bfqq) {
-		entity = &sync_bfqq->entity;
-		if (entity->sched_data != &bfqg->sched_data)
-			bfq_bfqq_move(bfqd, sync_bfqq, bfqg);
+		if (!sync_bfqq->new_bfqq && !bfq_bfqq_coop(sync_bfqq)) {
+			/* We are the only user of this bfqq, just move it */
+			if (sync_bfqq->entity.sched_data != &bfqg->sched_data)
+				bfq_bfqq_move(bfqd, sync_bfqq, bfqg);
+		} else {
+			struct bfq_queue *bfqq;
+
+			/*
+			 * The queue was merged to a different queue. Check
+			 * that the merge chain still belongs to the same
+			 * cgroup.
+			 */
+			for (bfqq = sync_bfqq; bfqq; bfqq = bfqq->new_bfqq)
+				if (bfqq->entity.sched_data !=
+				    &bfqg->sched_data)
+					break;
+			if (bfqq) {
+				/*
+				 * Some queue changed cgroup so the merge is
+				 * not valid anymore. We cannot easily just
+				 * cancel the merge (by clearing new_bfqq) as
+				 * there may be other processes using this
+				 * queue and holding refs to all queues below
+				 * sync_bfqq->new_bfqq. Similarly if the merge
+				 * already happened, we need to detach from
+				 * bfqq now so that we cannot merge bio to a
+				 * request from the old cgroup.
+				 */
+				bfq_put_cooperator(sync_bfqq);
+				bfq_release_process_ref(bfqd, sync_bfqq);
+				bic_set_bfqq(bic, NULL, 1);
+			}
+		}
 	}
 
 	return bfqg;
diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 7d00b21ebe5d..89fe3f85eb3c 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5315,7 +5315,7 @@ static void bfq_put_stable_ref(struct bfq_queue *bfqq)
 	bfq_put_queue(bfqq);
 }
 
-static void bfq_put_cooperator(struct bfq_queue *bfqq)
+void bfq_put_cooperator(struct bfq_queue *bfqq)
 {
 	struct bfq_queue *__bfqq, *next;
 
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index 3b83e3d1c2e5..a56763045d19 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -979,6 +979,7 @@ void bfq_weights_tree_remove(struct bfq_data *bfqd,
 void bfq_bfqq_expire(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 		     bool compensate, enum bfqq_expiration reason);
 void bfq_put_queue(struct bfq_queue *bfqq);
+void bfq_put_cooperator(struct bfq_queue *bfqq);
 void bfq_end_wr_async_queues(struct bfq_data *bfqd, struct bfq_group *bfqg);
 void bfq_release_process_ref(struct bfq_data *bfqd, struct bfq_queue *bfqq);
 void bfq_schedule_dispatch(struct bfq_data *bfqd);
-- 
2.34.1

