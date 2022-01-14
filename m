Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0861D48EEE7
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 18:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243692AbiANRC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 12:02:29 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:57144 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243669AbiANRC2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 12:02:28 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 8C2291F3CE;
        Fri, 14 Jan 2022 17:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1642179747; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XDO9AoyYXUqNubgEMjGkarVJG9Cnl1gqG+4zB1S+g74=;
        b=VrOW3guuZ7JfO69WNQmCDOAA5wVHE8+DMQNVA2/5e4/9iAKaYMLsfwXb2kiEQDhPCXHRY3
        /FZlZJXhWbz2m97zvYh3WbZwPxkBF4NdIO6Rf33Aye0SmMtcd+TM6cizccSnSqBBf7m3az
        5pMaqSpr0bhcpmqANTSDESy/Cgt9GRo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1642179747;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XDO9AoyYXUqNubgEMjGkarVJG9Cnl1gqG+4zB1S+g74=;
        b=E+DEh6OkbelTwfoepxIeKtUZeDZnTgCejH3LDlgBDr1wwmebXy1zooTOPm4dqn9lDaCVfT
        yhfvlVrWOGylYnAw==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id AE4D1A3B88;
        Fri, 14 Jan 2022 17:02:26 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 61898A05E4; Fri, 14 Jan 2022 18:02:09 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     <linux-block@vger.kernel.org>
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>,
        "yukuai (C)" <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 3/4] bfq: Split shared queues on move between cgroups
Date:   Fri, 14 Jan 2022 18:01:55 +0100
Message-Id: <20220114170209.8606-3-jack@suse.cz>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220114164215.28972-1-jack@suse.cz>
References: <20220114164215.28972-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3120; h=from:subject; bh=sel642sWuiTv4fTM2Qie+70W8d84IsCChDwU6N1j7ME=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBh4ayDVLgObrwe59D8NKzRlluH0Q2g/dZqDtSdIidY msl+z9GJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYeGsgwAKCRCcnaoHP2RA2SVrB/ 0RVegAQpvso8W0jRw/W5kzKers9ra3JaibwFllmXKVFV7BUGL0G84jp0cYNNe8NuRv96+3a+iwFT1U 5Eb2lywKfbg7/xZVFngPJscGnHiNVH9NbQ22o6Pn54X+Qgj6XCzD57qWXI4MEda1bVSJbSafHtHTuW a0QEAt3iB2hA+FaQ2Lr5M3827xCfpNjmEY8IMeLRsG97me3i8NJVMys+3PUp1LWZNZyxmMXEf2vIt5 3hWDf8ts7Gv06rOLsfTmgkMqTmjtOSdYE9ThfRiP1XPCg3tiPN4n0PbXHGGIt5j7mSVlTRRvA7MLUt 8lE3P0Jg/8RhrEv8hQag9QUXtMGS5u
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/bfq-cgroup.c  | 25 ++++++++++++++++++++++++-
 block/bfq-iosched.c |  2 +-
 block/bfq-iosched.h |  1 +
 3 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 24a5c5329bcd..dbc117e00783 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -730,8 +730,31 @@ static struct bfq_group *__bfq_bic_change_cgroup(struct bfq_data *bfqd,
 
 	if (sync_bfqq) {
 		entity = &sync_bfqq->entity;
-		if (entity->sched_data != &bfqg->sched_data)
+		if (entity->sched_data != &bfqg->sched_data) {
+			/*
+			 * Was the queue we use merged to a different queue?
+			 * Detach process from the queue as merge need not be
+			 * valid anymore. We cannot easily cancel the merge as
+			 * there may be other processes scheduled to this
+			 * queue.
+			 */
+			if (sync_bfqq->new_bfqq) {
+				bfq_put_cooperator(sync_bfqq);
+				bfq_release_process_ref(bfqd, sync_bfqq);
+				bic_set_bfqq(bic, NULL, 1);
+				return bfqg;
+			}
+			/*
+			 * Moving bfqq that is shared with another process?
+			 * Split the queues at the nearest occasion as the
+			 * processes can be in different cgroups now.
+			 */
+			if (bfq_bfqq_coop(sync_bfqq)) {
+				bic->stably_merged = false;
+				bfq_mark_bfqq_split_coop(sync_bfqq);
+			}
 			bfq_bfqq_move(bfqd, sync_bfqq, bfqg);
+		}
 	}
 
 	return bfqg;
diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 0da47f2ca781..361d321b012a 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5184,7 +5184,7 @@ static void bfq_put_stable_ref(struct bfq_queue *bfqq)
 	bfq_put_queue(bfqq);
 }
 
-static void bfq_put_cooperator(struct bfq_queue *bfqq)
+void bfq_put_cooperator(struct bfq_queue *bfqq)
 {
 	struct bfq_queue *__bfqq, *next;
 
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index a73488eec8a4..6e250db2138e 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -976,6 +976,7 @@ void bfq_weights_tree_remove(struct bfq_data *bfqd,
 void bfq_bfqq_expire(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 		     bool compensate, enum bfqq_expiration reason);
 void bfq_put_queue(struct bfq_queue *bfqq);
+void bfq_put_cooperator(struct bfq_queue *bfqq);
 void bfq_end_wr_async_queues(struct bfq_data *bfqd, struct bfq_group *bfqg);
 void bfq_release_process_ref(struct bfq_data *bfqd, struct bfq_queue *bfqq);
 void bfq_schedule_dispatch(struct bfq_data *bfqd);
-- 
2.31.1

