Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58411593B74
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345543AbiHOTyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344797AbiHOTxX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:53:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491B132045;
        Mon, 15 Aug 2022 11:51:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA24260C0B;
        Mon, 15 Aug 2022 18:51:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E194AC433D6;
        Mon, 15 Aug 2022 18:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589467;
        bh=ZDedPVNiO2p3vtp2hCa02ePm6bGyq2JGqgfFc1XihvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FOIrey3DikGD1H/5HqZsfc5bdx6F24eTLUFvaOX6woMldCAMYD1vuJ4HcW0Z2/2tO
         McZbOYml9tr6cEtm66CThX0+vXzeKOAVkg0V2UlwBCBtp+EYQh4y945Eyon4jymnXO
         V3vSFi/uaLqmXTjrVkVvA9bksfTE8xMTHRykc318=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jinke Han <hanjinke.666@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 726/779] block: dont allow the same type rq_qos add more than once
Date:   Mon, 15 Aug 2022 20:06:10 +0200
Message-Id: <20220815180408.498309603@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jinke Han <hanjinke.666@bytedance.com>

[ Upstream commit 14a6e2eb7df5c7897c15b109cba29ab0c4a791b6 ]

In our test of iocost, we encountered some list add/del corruptions of
inner_walk list in ioc_timer_fn.

The reason can be described as follows:

cpu 0					cpu 1
ioc_qos_write				ioc_qos_write

ioc = q_to_ioc(queue);
if (!ioc) {
        ioc = kzalloc();
					ioc = q_to_ioc(queue);
					if (!ioc) {
						ioc = kzalloc();
						...
						rq_qos_add(q, rqos);
					}
        ...
        rq_qos_add(q, rqos);
        ...
}

When the io.cost.qos file is written by two cpus concurrently, rq_qos may
be added to one disk twice. In that case, there will be two iocs enabled
and running on one disk. They own different iocgs on their active list. In
the ioc_timer_fn function, because of the iocgs from two iocs have the
same root iocg, the root iocg's walk_list may be overwritten by each other
and this leads to list add/del corruptions in building or destroying the
inner_walk list.

And so far, the blk-rq-qos framework works in case that one instance for
one type rq_qos per queue by default. This patch make this explicit and
also fix the crash above.

Signed-off-by: Jinke Han <hanjinke.666@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220720093616.70584-1-hanjinke.666@bytedance.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c    | 20 +++++++++++++-------
 block/blk-iolatency.c | 18 +++++++++++-------
 block/blk-rq-qos.h    | 11 ++++++++++-
 block/blk-wbt.c       | 12 +++++++++++-
 4 files changed, 45 insertions(+), 16 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 10851493940c..069193dee95b 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2893,15 +2893,21 @@ static int blk_iocost_init(struct request_queue *q)
 	 * called before policy activation completion, can't assume that the
 	 * target bio has an iocg associated and need to test for NULL iocg.
 	 */
-	rq_qos_add(q, rqos);
+	ret = rq_qos_add(q, rqos);
+	if (ret)
+		goto err_free_ioc;
+
 	ret = blkcg_activate_policy(q, &blkcg_policy_iocost);
-	if (ret) {
-		rq_qos_del(q, rqos);
-		free_percpu(ioc->pcpu_stat);
-		kfree(ioc);
-		return ret;
-	}
+	if (ret)
+		goto err_del_qos;
 	return 0;
+
+err_del_qos:
+	rq_qos_del(q, rqos);
+err_free_ioc:
+	free_percpu(ioc->pcpu_stat);
+	kfree(ioc);
+	return ret;
 }
 
 static struct blkcg_policy_data *ioc_cpd_alloc(gfp_t gfp)
diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index d85f30a85ee7..bdef8395af6e 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -772,19 +772,23 @@ int blk_iolatency_init(struct request_queue *q)
 	rqos->ops = &blkcg_iolatency_ops;
 	rqos->q = q;
 
-	rq_qos_add(q, rqos);
-
+	ret = rq_qos_add(q, rqos);
+	if (ret)
+		goto err_free;
 	ret = blkcg_activate_policy(q, &blkcg_policy_iolatency);
-	if (ret) {
-		rq_qos_del(q, rqos);
-		kfree(blkiolat);
-		return ret;
-	}
+	if (ret)
+		goto err_qos_del;
 
 	timer_setup(&blkiolat->timer, blkiolatency_timer_fn, 0);
 	INIT_WORK(&blkiolat->enable_work, blkiolatency_enable_work_fn);
 
 	return 0;
+
+err_qos_del:
+	rq_qos_del(q, rqos);
+err_free:
+	kfree(blkiolat);
+	return ret;
 }
 
 static void iolatency_set_min_lat_nsec(struct blkcg_gq *blkg, u64 val)
diff --git a/block/blk-rq-qos.h b/block/blk-rq-qos.h
index 68267007da1c..1655f76b6a1b 100644
--- a/block/blk-rq-qos.h
+++ b/block/blk-rq-qos.h
@@ -86,7 +86,7 @@ static inline void rq_wait_init(struct rq_wait *rq_wait)
 	init_waitqueue_head(&rq_wait->wait);
 }
 
-static inline void rq_qos_add(struct request_queue *q, struct rq_qos *rqos)
+static inline int rq_qos_add(struct request_queue *q, struct rq_qos *rqos)
 {
 	/*
 	 * No IO can be in-flight when adding rqos, so freeze queue, which
@@ -98,6 +98,8 @@ static inline void rq_qos_add(struct request_queue *q, struct rq_qos *rqos)
 	blk_mq_freeze_queue(q);
 
 	spin_lock_irq(&q->queue_lock);
+	if (rq_qos_id(q, rqos->id))
+		goto ebusy;
 	rqos->next = q->rq_qos;
 	q->rq_qos = rqos;
 	spin_unlock_irq(&q->queue_lock);
@@ -106,6 +108,13 @@ static inline void rq_qos_add(struct request_queue *q, struct rq_qos *rqos)
 
 	if (rqos->ops->debugfs_attrs)
 		blk_mq_debugfs_register_rqos(rqos);
+
+	return 0;
+ebusy:
+	spin_unlock_irq(&q->queue_lock);
+	blk_mq_unfreeze_queue(q);
+	return -EBUSY;
+
 }
 
 static inline void rq_qos_del(struct request_queue *q, struct rq_qos *rqos)
diff --git a/block/blk-wbt.c b/block/blk-wbt.c
index 0c119be0e813..ae6ea0b54579 100644
--- a/block/blk-wbt.c
+++ b/block/blk-wbt.c
@@ -820,6 +820,7 @@ int wbt_init(struct request_queue *q)
 {
 	struct rq_wb *rwb;
 	int i;
+	int ret;
 
 	rwb = kzalloc(sizeof(*rwb), GFP_KERNEL);
 	if (!rwb)
@@ -846,7 +847,10 @@ int wbt_init(struct request_queue *q)
 	/*
 	 * Assign rwb and add the stats callback.
 	 */
-	rq_qos_add(q, &rwb->rqos);
+	ret = rq_qos_add(q, &rwb->rqos);
+	if (ret)
+		goto err_free;
+
 	blk_stat_add_callback(q, rwb->cb);
 
 	rwb->min_lat_nsec = wbt_default_latency_nsec(q);
@@ -855,4 +859,10 @@ int wbt_init(struct request_queue *q)
 	wbt_set_write_cache(q, test_bit(QUEUE_FLAG_WC, &q->queue_flags));
 
 	return 0;
+
+err_free:
+	blk_stat_free_callback(rwb->cb);
+	kfree(rwb);
+	return ret;
+
 }
-- 
2.35.1



