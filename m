Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 712B657A45B
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 18:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234838AbiGSQx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 12:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234759AbiGSQx1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 12:53:27 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABC351421
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 09:53:25 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id g17so12490726plh.2
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 09:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EoDaqgrAHGBNbnVydHejL8jLbGI0Orhqw0A1Is/Hf1k=;
        b=WdjdS6yNzpFf37fwaTPlL5P8cavy47olmzNwDCBOXKlQ0Uf1u9+5FMDEfjure1bBVm
         T/dVR6zeopyHZiC7TM6PW8wOBQPv4TYcPIjKVt3ALjgaCcheQooncLhXxaykR0cq0DYY
         cAhjsfd+XWludJnuE9HqXHMD45c0paLy6JgoZ+S2kT2g4ULezwtYfabqm6dUODC9zqy8
         EklKjANJ8z5BpukBsSEUCGaxax2frmc/K9P+1mprEgHyWSIg/NvZXaKWTYf6CT/TwIMJ
         X65WkIeVxzLTPCYU4UcUeCrRpYFIyJNhDhOfoAuAhsHpWuWsHdIaCOvWi8Bk4X8BSSPj
         FuPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EoDaqgrAHGBNbnVydHejL8jLbGI0Orhqw0A1Is/Hf1k=;
        b=JQTE77+4f89gvgOWwLDwnEa1CPyHcVr2SU2VUrPgXfpZa8OdzA/aD95Ye1YuI6VsUT
         YSFoWV/BnCEKT+bTXyJ9K7yDGiuYUXounj5x9r6dY8oUMX2D2tbkaD/QmHUNLy/dpUyJ
         WxJ+g3oDtLJqpM8MWikgchZA60MTXKSoEYHyYMn8Ez8ZaKxcsvyAyftlBJCdzBAicW/V
         4vuIHs+52eSiHnAUY66gYj+ZHj7lUQ4rbE+aNuss6s0tbMMhZP3iGmTdkzrgaI7v7WMO
         wEoCpXsZZ4IcM4dMdzEDr3/FAf34sA7W31Tx7o/O2aE3oU5Ctlze491ZVj296C/d0aDE
         CgKQ==
X-Gm-Message-State: AJIora9UkIYX220VNLPGfsLdw+qjvvl/aCrd+h1Fxl4BdKsdS/ly3NzX
        gs4cDHhB2PSDXhmBT8eAaWRERw==
X-Google-Smtp-Source: AGRyM1uPInJKvCt5KS0hjyKpsbtZxidKKXWBNs7bgyTddEjm2uLYVaIXoVV2eRoMjw8JsZ4nqZVrgA==
X-Received: by 2002:a17:903:22ca:b0:16c:4145:75a1 with SMTP id y10-20020a17090322ca00b0016c414575a1mr34004300plg.134.1658249605076;
        Tue, 19 Jul 2022 09:53:25 -0700 (PDT)
Received: from localhost.localdomain ([139.177.225.225])
        by smtp.gmail.com with ESMTPSA id oj4-20020a17090b4d8400b001ef8fb72224sm13901963pjb.53.2022.07.19.09.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 09:53:24 -0700 (PDT)
From:   Jinke Han <hanjinke.666@bytedance.com>
X-Google-Original-From: Jinke Han <hnajinke.666@bytedance>
To:     axboe@kernel.dk, tj@kernel.org
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Jinke Han <hanjinke.666@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>, stable@vger.kernel.org
Subject: [PATCH v3] block: don't allow the same type rq_qos add more than once
Date:   Wed, 20 Jul 2022 00:53:13 +0800
Message-Id: <20220719165313.51887-1-hanjinke.666@bytedance.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jinke Han <hanjinke.666@bytedance.com>

In our test of iocost, we encounttered some list add/del corrutions of
inner_walk list in ioc_timer_fn.

The reason can be descripted as follow:
cpu 0						cpu 1
ioc_qos_write					ioc_qos_write

ioc = q_to_ioc(bdev_get_queue(bdev));
if (!ioc) {
        ioc = kzalloc();			ioc = q_to_ioc(bdev_get_queue(bdev));
						if (!ioc) {
							ioc = kzalloc();
							...
							rq_qos_add(q, rqos);
						}
        ...
        rq_qos_add(q, rqos);
        ...
}

When the io.cost.qos file is written by two cpu concurrently, rq_qos may
be added to one disk twice. In that case, there will be two iocs enabled
and running on one disk. They own different iocgs on their active list.
In the ioc_timer_fn function, because of the iocgs from two ioc have the
same root iocg, the root iocg's walk_list may be overwritten by each
other and this lead to list add/del corrutions in building or destorying
the inner_walk list.

And so far, the blk-rq-qos framework works in case that one instance for
one type rq_qos per queue by default. This patch make this explicit and
also fix the crash above.

Signed-off-by: Jinke Han <hanjinke.666@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
---
Changes in v2:
-use goto in incost and rename the ebusy label
Changes in v3
-use goto in all place

 block/blk-iocost.c    | 20 +++++++++++++-------
 block/blk-iolatency.c | 18 +++++++++++-------
 block/blk-ioprio.c    | 15 +++++++++++----
 block/blk-rq-qos.h    | 11 ++++++++++-
 block/blk-wbt.c       | 12 +++++++++++-
 5 files changed, 56 insertions(+), 20 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 33a11ba971ea..c6181357e545 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2886,15 +2886,21 @@ static int blk_iocost_init(struct request_queue *q)
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
index 9568bf8dfe82..7845dca5fcfd 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -773,19 +773,23 @@ int blk_iolatency_init(struct request_queue *q)
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
diff --git a/block/blk-ioprio.c b/block/blk-ioprio.c
index 79e797f5d194..528d3ffcd0ef 100644
--- a/block/blk-ioprio.c
+++ b/block/blk-ioprio.c
@@ -235,10 +235,8 @@ int blk_ioprio_init(struct request_queue *q)
 		return -ENOMEM;
 
 	ret = blkcg_activate_policy(q, &ioprio_policy);
-	if (ret) {
-		kfree(blkioprio_blkg);
-		return ret;
-	}
+	if (ret)
+		goto err_free;
 
 	rqos = &blkioprio_blkg->rqos;
 	rqos->id = RQ_QOS_IOPRIO;
@@ -251,8 +249,17 @@ int blk_ioprio_init(struct request_queue *q)
 	 * rq-qos callbacks.
 	 */
 	rq_qos_add(q, rqos);
+	if (ret)
+		goto err_deactivate_policy;
 
 	return 0;
+
+err_deactivate_policy:
+	blkcg_deactivate_policy(q, &ioprio_policy);
+err_free:
+	kfree(blkioprio_blkg);
+	return ret;
+
 }
 
 static int __init ioprio_init(void)
diff --git a/block/blk-rq-qos.h b/block/blk-rq-qos.h
index 0e46052b018a..08b856570ad1 100644
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
@@ -109,6 +111,13 @@ static inline void rq_qos_add(struct request_queue *q, struct rq_qos *rqos)
 		blk_mq_debugfs_register_rqos(rqos);
 		mutex_unlock(&q->debugfs_mutex);
 	}
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
2.20.1

