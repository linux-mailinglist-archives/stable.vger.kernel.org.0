Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C14155415FF
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348477AbiFGUnv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377515AbiFGUmX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:42:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD8B1F2328;
        Tue,  7 Jun 2022 11:38:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 373DE612EC;
        Tue,  7 Jun 2022 18:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A92C385A2;
        Tue,  7 Jun 2022 18:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627132;
        bh=ewdy6qI+zNcVA4LzLV2LoHonucFCar9pGJjy0gVPUhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e/TnBvdp1ptrccUAEvyCSkeZs1kar0Nmc3i3rHCKJuoyfrMWASyUbFJ0EN4dngZ/7
         sNwpeS64uZNUnASst/czJg3cTRtUEuiL2Z4+IDIzOdHbv97n1woRR3CXnMMnsV7GHF
         /o/NHKaVtyYB76dSYOhEKA5x50UG/sU8xLUdZykk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.17 629/772] bfq: Split shared queues on move between cgroups
Date:   Tue,  7 Jun 2022 19:03:41 +0200
Message-Id: <20220607165007.470258831@linuxfoundation.org>
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

commit 3bc5e683c67d94bd839a1da2e796c15847b51b69 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bfq-cgroup.c  |   36 +++++++++++++++++++++++++++++++++---
 block/bfq-iosched.c |    2 +-
 block/bfq-iosched.h |    1 +
 3 files changed, 35 insertions(+), 4 deletions(-)

--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -735,9 +735,39 @@ static struct bfq_group *__bfq_bic_chang
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
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5319,7 +5319,7 @@ static void bfq_put_stable_ref(struct bf
 	bfq_put_queue(bfqq);
 }
 
-static void bfq_put_cooperator(struct bfq_queue *bfqq)
+void bfq_put_cooperator(struct bfq_queue *bfqq)
 {
 	struct bfq_queue *__bfqq, *next;
 
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -981,6 +981,7 @@ void bfq_weights_tree_remove(struct bfq_
 void bfq_bfqq_expire(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 		     bool compensate, enum bfqq_expiration reason);
 void bfq_put_queue(struct bfq_queue *bfqq);
+void bfq_put_cooperator(struct bfq_queue *bfqq);
 void bfq_end_wr_async_queues(struct bfq_data *bfqd, struct bfq_group *bfqg);
 void bfq_release_process_ref(struct bfq_data *bfqd, struct bfq_queue *bfqq);
 void bfq_schedule_dispatch(struct bfq_data *bfqd);


