Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C366448EEEC
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 18:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243696AbiANRCa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 12:02:30 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:57176 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243694AbiANRCa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 12:02:30 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 336F41F45F;
        Fri, 14 Jan 2022 17:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1642179749; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8oZ6OI4vNC5/+gMn7tJ9auCcFWXOZTZeQxpW3Q2dMEo=;
        b=rfFfOHA5ptlRzAcZGqTxhwqn9Uu0V9XQy9zFn89I88hUkMpNDXROQQ9yMBndh4W1nrH++I
        yVEsujDrwsWjKDaofaHkewhPa1nDM1gNI9Z9x49aMFoiRazEgSbaGGe0McIBqg+5JEsFAK
        s+dtGXh3IsJWvCoQbmqVKokPT3kSHQ4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1642179749;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8oZ6OI4vNC5/+gMn7tJ9auCcFWXOZTZeQxpW3Q2dMEo=;
        b=K1QgnusIdyFQFlMyKytqk1fgxOBydxsza406kdllMamw8uVsNf4KH2428oKA6v2oKtyZzY
        Mw4rBDTzqmrFU+Bw==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A983BA3B85;
        Fri, 14 Jan 2022 17:02:26 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 667D5A05E5; Fri, 14 Jan 2022 18:02:09 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     <linux-block@vger.kernel.org>
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>,
        "yukuai (C)" <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 4/4] bfq: Update cgroup information before merging bio
Date:   Fri, 14 Jan 2022 18:01:56 +0100
Message-Id: <20220114170209.8606-4-jack@suse.cz>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220114164215.28972-1-jack@suse.cz>
References: <20220114164215.28972-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3645; h=from:subject; bh=AYQTSSBM1FNRQJzQY4VA2R1js74Ch1BTbAaz/Tp2LuM=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBh4ayE5S3d98nNhJaUPQn0QhJjhvMS9DmowK/XsE25 34TczWaJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYeGshAAKCRCcnaoHP2RA2f80B/ 9lk5AXqMv4N0rcizkWZgYvboPZytslGgDLyrv5jgf2Ipfxo+UNC712UxFTexA6/QYiSWhTwKkGRA64 ezsHI5sKbiEfCBdSmLCBVS13aCug1U5R+kXNPp5LuIaI9m+EE7eOO5BjZfpfN54mmWiGIjE2z0BHvK EqWfN5aXpJNBAG2W7oR7tYxDubiA2haYfRhsr9lhHmDxzFp+KFcW/NEAQSkFQ7+2sW52eUMLBpoV/9 1IjcYc5oJawKzxCUoNf0EKHkVhbvJTp2SiuWT02/qs0UXMH+nziZFlR6EMAzz2tUUgCdUfGQbXZh1/ qpongWT8fVoH8F2YWHbvG0gxlHWv6G
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When the process is migrated to a different cgroup (or in case of
writeback just starts submitting bios associated with a different
cgroup) bfq_merge_bio() can operate with stale cgroup information in
bic. Thus the bio can be merged to a request from a different cgroup or
it can result in merging of bfqqs for different cgroups or bfqqs of
already dead cgroups and causing possible use-after-free issues. Fix the
problem by updating cgroup information in bfq_merge_bio().

CC: stable@vger.kernel.org
Fixes: e21b7a0b9887 ("block, bfq: add full hierarchical scheduling and cgroups support")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/bfq-cgroup.c  | 40 ++++++++++++++++++++++------------------
 block/bfq-iosched.c | 11 +++++++++--
 2 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index dbc117e00783..f6f5f156b9f2 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -729,30 +729,34 @@ static struct bfq_group *__bfq_bic_change_cgroup(struct bfq_data *bfqd,
 	}
 
 	if (sync_bfqq) {
-		entity = &sync_bfqq->entity;
-		if (entity->sched_data != &bfqg->sched_data) {
+		struct bfq_queue *orig_bfqq = sync_bfqq;
+
+		/* Traverse the merge chain to bfqq we will be using */
+		while (sync_bfqq->new_bfqq)
+			sync_bfqq = sync_bfqq->new_bfqq;
+		/*
+		 * Target bfqq got moved to a different cgroup or this process
+		 * started submitting bios for different cgroup?
+		 */
+		if (sync_bfqq->entity.sched_data != &bfqg->sched_data) {
 			/*
 			 * Was the queue we use merged to a different queue?
-			 * Detach process from the queue as merge need not be
-			 * valid anymore. We cannot easily cancel the merge as
-			 * there may be other processes scheduled to this
-			 * queue.
+			 * Detach process from the queue as the merge is not
+			 * valid anymore. We cannot easily just cancel the
+			 * merge (by clearing new_bfqq) as there may be other
+			 * processes using this queue and holding refs to all
+			 * queues below sync_bfqq->new_bfqq. Similarly if the
+			 * merge already happened, we need to detach from bfqq
+			 * now so that we cannot merge bio to a request from
+			 * the old cgroup.
 			 */
-			if (sync_bfqq->new_bfqq) {
-				bfq_put_cooperator(sync_bfqq);
-				bfq_release_process_ref(bfqd, sync_bfqq);
+			if (orig_bfqq != sync_bfqq || bfq_bfqq_coop(sync_bfqq)) {
+				bfq_put_cooperator(orig_bfqq);
+				bfq_release_process_ref(bfqd, orig_bfqq);
 				bic_set_bfqq(bic, NULL, 1);
 				return bfqg;
 			}
-			/*
-			 * Moving bfqq that is shared with another process?
-			 * Split the queues at the nearest occasion as the
-			 * processes can be in different cgroups now.
-			 */
-			if (bfq_bfqq_coop(sync_bfqq)) {
-				bic->stably_merged = false;
-				bfq_mark_bfqq_split_coop(sync_bfqq);
-			}
+			/* We are the only user of this bfqq, just move it */
 			bfq_bfqq_move(bfqd, sync_bfqq, bfqg);
 		}
 	}
diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 361d321b012a..8a088d77a0b6 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2337,10 +2337,17 @@ static bool bfq_bio_merge(struct request_queue *q, struct bio *bio,
 
 	spin_lock_irq(&bfqd->lock);
 
-	if (bic)
+	if (bic) {
+		/*
+		 * Make sure cgroup info is uptodate for current process before
+		 * considering the merge.
+		 */
+		bfq_bic_update_cgroup(bic, bio);
+
 		bfqd->bio_bfqq = bic_to_bfqq(bic, op_is_sync(bio->bi_opf));
-	else
+	} else {
 		bfqd->bio_bfqq = NULL;
+	}
 	bfqd->bio_bic = bic;
 
 	ret = blk_mq_sched_try_merge(q, bio, nr_segs, &free);
-- 
2.31.1

