Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640E4495E02
	for <lists+stable@lfdr.de>; Fri, 21 Jan 2022 11:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350083AbiAUK6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jan 2022 05:58:22 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:48142 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380040AbiAUK6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jan 2022 05:58:18 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id ACA9F1F88C;
        Fri, 21 Jan 2022 10:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1642762696; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xsNow785fNlV7cvSdCWuHorXrq54SLGkf0IkK8trwHE=;
        b=KwUFuYg5hjxkDGq3g1rtR6eOrYX0zRYruNypbiA0Fpe/khgMDP2c7+fRDu58JYmSDqSAag
        OYmK26Hgqe2dZ6FDGZ2RmcpdKbBUbj6Ee8Fe04ivKKP/Lw7oR26J0CSWY/lwXw9XN4LIrq
        7wcb7n18UKJRVCaBNCQQ8+3xEWGrl80=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1642762696;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xsNow785fNlV7cvSdCWuHorXrq54SLGkf0IkK8trwHE=;
        b=esWIZdZKT6WDKdHnUN2UYVRaksQCzvplI9JWjJHzFpCDn6uAomwVk/H539LyN220FubFb5
        Hz7DmhydiH/hbdBg==
Received: from quack3.suse.cz (unknown [10.100.200.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A09E5A3B96;
        Fri, 21 Jan 2022 10:58:16 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 3623DA05E8; Fri, 21 Jan 2022 11:58:16 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     <linux-block@vger.kernel.org>
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>,
        "yukuai (C)" <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 3/4] bfq: Split shared queues on move between cgroups
Date:   Fri, 21 Jan 2022 11:56:44 +0100
Message-Id: <20220121105816.27320-3-jack@suse.cz>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220121105503.14069-1-jack@suse.cz>
References: <20220121105503.14069-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3501; h=from:subject; bh=BQykiJFlu5FJfTkQTB0E1rhHc7iDqb6KaRLCtSsuwag=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBh6pFrScWdjbasUM11EOIptN4959qo0vOdXmy/RiTQ 2MIu7qaJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYeqRawAKCRCcnaoHP2RA2fcGB/ wNKhkDTxn1JnBS7HoYUAB1qYg0aTypX77+rAZdS/ac2+Mc8ROscxTP2gdsUwVjws19Ettv7KhIIM3p B0RSrfoiGnon7guEdjU4ZoR8AnBzsM+KEl32UGZJC/1JmYSHpXfO+83UbEByxoJ4HbP6ydB0KMlCDJ qPpwg+F3MtEOGRPSBWZzUkuH4DwY+hofBzsrJx0fsuvv2L39q3o6Cz2V7lhMQwVwvkJkZBjlQRlNUw NaFqS6NgDU9uuLxoKkpVOke7Ocqx2rCOkxlr6Iw2yZyJs6i7sRCqjQDSAqWpnGI7+qbJJw9E4s9Lsg XhGrWxlM7/01tr5rxy5KudGjoTgNG9
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
 block/bfq-cgroup.c  | 36 +++++++++++++++++++++++++++++++++---
 block/bfq-iosched.c |  2 +-
 block/bfq-iosched.h |  1 +
 3 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 24a5c5329bcd..00184530c644 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -729,9 +729,39 @@ static struct bfq_group *__bfq_bic_change_cgroup(struct bfq_data *bfqd,
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

