Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC2BC53E921
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236115AbiFFL6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 07:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236182AbiFFL6O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 07:58:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC2464C7
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 04:57:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD8A460FF4
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 11:57:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F2E7C34119;
        Mon,  6 Jun 2022 11:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654516668;
        bh=3xRWkVWY2pP9B0M/ZAeUYhEawIcJgyAoY5ulpYyFMh0=;
        h=Subject:To:Cc:From:Date:From;
        b=eN87zd7rK2YO0CDiWzBYaQZVjGIh3jFM+Lp7snEx/qKEHlqluFFVFGq+9iVKWVdKa
         xdVgJA5tt2QOfOIOo8I3jcDTLdabA5DYjFuZH5vgPnfRc8X982anCn0Az+lAMaOmyz
         6u40o5u8ND2UozW7XEce5aA2mjV1nZMpSmVehT/U=
Subject: FAILED: patch "[PATCH] bfq: Split shared queues on move between cgroups" failed to apply to 4.19-stable tree
To:     jack@suse.cz, axboe@kernel.dk, hch@lst.de, yukuai3@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 13:57:29 +0200
Message-ID: <16545166495292@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3bc5e683c67d94bd839a1da2e796c15847b51b69 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Fri, 1 Apr 2022 12:27:44 +0200
Subject: [PATCH] bfq: Split shared queues on move between cgroups

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220401102752.8599-3-jack@suse.cz
Signed-off-by: Jens Axboe <axboe@kernel.dk>

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

