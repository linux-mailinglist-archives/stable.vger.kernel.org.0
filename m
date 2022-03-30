Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD75F4EC4CE
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 14:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345538AbiC3MrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 08:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343840AbiC3Mqy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 08:46:54 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A9B7DE0B;
        Wed, 30 Mar 2022 05:43:02 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 3702F1F86A;
        Wed, 30 Mar 2022 12:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1648644181; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uPmivVOPJBGDUdJhi3hnlYMRdFUbE2YZW82iLvFOdwY=;
        b=hc9hx9eGpAJNxnbA5HOoTm6CZwVwuhOGlVX8JgREGkR+c+iOWi274zDKOhzTQuAPbE8BZg
        NaB2seVsiS6p6I1TYsaNZSF1Km/o8S+Y8qGSbHSvYSA4j2lBwMAPvCiMC4fYHmPSrKcfLz
        r+5h0/CPJtJR++Vv1RWGryPItLTKEZE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1648644181;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uPmivVOPJBGDUdJhi3hnlYMRdFUbE2YZW82iLvFOdwY=;
        b=tSon/zF8llvLhu7ZRMxgAChT/DCRUH3+5TndANxfHPnLvaN0mlq/5risiy9IBeAPD6Vet2
        zsyTG+ucRT5lmDAA==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 261D1A3B9A;
        Wed, 30 Mar 2022 12:43:01 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 736A3A0619; Wed, 30 Mar 2022 14:42:56 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     <linux-block@vger.kernel.org>
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>,
        "yukuai (C)" <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 3/9] bfq: Split shared queues on move between cgroups
Date:   Wed, 30 Mar 2022 14:42:46 +0200
Message-Id: <20220330124255.24581-3-jack@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330123438.32719-1-jack@suse.cz>
References: <20220330123438.32719-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3501; h=from:subject; bh=wo8o0yMjT769m1S0iQKPUbqiFN7StyovImd+Ke6tEJM=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBiRFBGe4zgneYJoI7GeIBBbnV7ZRXSR3wDxmoiOVzL foKh/naJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYkRQRgAKCRCcnaoHP2RA2YsiB/ 9CMf931CZelWEL44mTYfcON9A3tgpJoZhn5buQ9PXGhyiYCsljNHYSYaZThsmEMtiFhZjBeAXYC33O Vc7K1+2M8+WGt4wFxZoytbRmd8ODtwDt9UBhtpMP0fFby8x6hz3GppJg1MFLVE+3fgZEXKzSO+JKLl dOWci+UnfOmJjvMaJT0dAf08nNliMd6dQX2ETASRyDjeH6Mr7t9ek6Wg3seQ2wwXKoVD54J3RdEa8E zKWAAV1KqkyfizAczg5V+c5rkno3JAtpVlUFA2h9xKRzqS/oIeWS7unPglStAC4yucpfYvqR3bSWIH 5jTw1i5CmN8zkGkHF0Enoih9m3Ju/v
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

