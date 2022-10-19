Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF7FA603E0C
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232457AbiJSJKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232704AbiJSJI6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:08:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B574769F62;
        Wed, 19 Oct 2022 02:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AB3C61753;
        Wed, 19 Oct 2022 08:59:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A3AC433D6;
        Wed, 19 Oct 2022 08:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169977;
        bh=Z8z7NmhwuLQmvcvxN30n/bAav7tobujWdMIlqIkzE8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zu+MSE9t6viVtG2fuKe+8cHfN4+JMrM3PPaZDXUAj/Bj77JFMmC6ybhaSq3R7gsYH
         XGpqClr3QU1YHXtjd/rNxJbjrZ2Hbr5WAj5AlXRi1S5FmzLl/kroH0amTbL3dSnBVo
         EPfxSNJ+glbHNwYootMSjrsxeHdbX/+NQTDiOYKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 479/862] sbitmap: fix possible io hung due to lost wakeup
Date:   Wed, 19 Oct 2022 10:29:26 +0200
Message-Id: <20221019083311.114449669@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 040b83fcecfb86f3225d3a5de7fd9b3fbccf83b4 ]

There are two problems can lead to lost wakeup:

1) invalid wakeup on the wrong waitqueue:

For example, 2 * wake_batch tags are put, while only wake_batch threads
are woken:

__sbq_wake_up
 atomic_cmpxchg -> reset wait_cnt
			__sbq_wake_up -> decrease wait_cnt
			...
			__sbq_wake_up -> wait_cnt is decreased to 0 again
			 atomic_cmpxchg
			 sbq_index_atomic_inc -> increase wake_index
			 wake_up_nr -> wake up and waitqueue might be empty
 sbq_index_atomic_inc -> increase again, one waitqueue is skipped
 wake_up_nr -> invalid wake up because old wakequeue might be empty

To fix the problem, increasing 'wake_index' before resetting 'wait_cnt'.

2) 'wait_cnt' can be decreased while waitqueue is empty

As pointed out by Jan Kara, following race is possible:

CPU1				CPU2
__sbq_wake_up			 __sbq_wake_up
 sbq_wake_ptr()			 sbq_wake_ptr() -> the same
 wait_cnt = atomic_dec_return()
 /* decreased to 0 */
 sbq_index_atomic_inc()
 /* move to next waitqueue */
 atomic_set()
 /* reset wait_cnt */
 wake_up_nr()
 /* wake up on the old waitqueue */
				 wait_cnt = atomic_dec_return()
				 /*
				  * decrease wait_cnt in the old
				  * waitqueue, while it can be
				  * empty.
				  */

Fix the problem by waking up before updating 'wake_index' and
'wait_cnt'.

With this patch, noted that 'wait_cnt' is still decreased in the old
empty waitqueue, however, the wakeup is redirected to a active waitqueue,
and the extra decrement on the old empty waitqueue is not handled.

Fixes: 88459642cba4 ("blk-mq: abstract tag allocation out into sbitmap library")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220803121504.212071-1-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/sbitmap.c | 55 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 33 insertions(+), 22 deletions(-)

diff --git a/lib/sbitmap.c b/lib/sbitmap.c
index 29eb0484215a..1f31147872e6 100644
--- a/lib/sbitmap.c
+++ b/lib/sbitmap.c
@@ -611,32 +611,43 @@ static bool __sbq_wake_up(struct sbitmap_queue *sbq)
 		return false;
 
 	wait_cnt = atomic_dec_return(&ws->wait_cnt);
-	if (wait_cnt <= 0) {
-		int ret;
+	/*
+	 * For concurrent callers of this, callers should call this function
+	 * again to wakeup a new batch on a different 'ws'.
+	 */
+	if (wait_cnt < 0 || !waitqueue_active(&ws->wait))
+		return true;
 
-		wake_batch = READ_ONCE(sbq->wake_batch);
+	if (wait_cnt > 0)
+		return false;
 
-		/*
-		 * Pairs with the memory barrier in sbitmap_queue_resize() to
-		 * ensure that we see the batch size update before the wait
-		 * count is reset.
-		 */
-		smp_mb__before_atomic();
+	wake_batch = READ_ONCE(sbq->wake_batch);
 
-		/*
-		 * For concurrent callers of this, the one that failed the
-		 * atomic_cmpxhcg() race should call this function again
-		 * to wakeup a new batch on a different 'ws'.
-		 */
-		ret = atomic_cmpxchg(&ws->wait_cnt, wait_cnt, wake_batch);
-		if (ret == wait_cnt) {
-			sbq_index_atomic_inc(&sbq->wake_index);
-			wake_up_nr(&ws->wait, wake_batch);
-			return false;
-		}
+	/*
+	 * Wake up first in case that concurrent callers decrease wait_cnt
+	 * while waitqueue is empty.
+	 */
+	wake_up_nr(&ws->wait, wake_batch);
 
-		return true;
-	}
+	/*
+	 * Pairs with the memory barrier in sbitmap_queue_resize() to
+	 * ensure that we see the batch size update before the wait
+	 * count is reset.
+	 *
+	 * Also pairs with the implicit barrier between decrementing wait_cnt
+	 * and checking for waitqueue_active() to make sure waitqueue_active()
+	 * sees result of the wakeup if atomic_dec_return() has seen the result
+	 * of atomic_set().
+	 */
+	smp_mb__before_atomic();
+
+	/*
+	 * Increase wake_index before updating wait_cnt, otherwise concurrent
+	 * callers can see valid wait_cnt in old waitqueue, which can cause
+	 * invalid wakeup on the old waitqueue.
+	 */
+	sbq_index_atomic_inc(&sbq->wake_index);
+	atomic_set(&ws->wait_cnt, wake_batch);
 
 	return false;
 }
-- 
2.35.1



