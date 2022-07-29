Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F5F584C78
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 09:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234652AbiG2HT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 03:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234630AbiG2HT1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 03:19:27 -0400
X-Greylist: delayed 1200 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 29 Jul 2022 00:19:25 PDT
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0432380F47;
        Fri, 29 Jul 2022 00:19:24 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4LvHtg4Xrrz6PjSJ;
        Fri, 29 Jul 2022 14:39:39 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
        by APP3 (Coremail) with SMTP id _Ch0CgD3_9PlgONidnlHBQ--.46322S4;
        Fri, 29 Jul 2022 14:40:52 +0800 (CST)
From:   Zhang Wensheng <zhangwensheng@huaweicloud.com>
To:     stable@vger.kernel.org
Cc:     axboe@kernel.dk, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhangwensheng5@huawei.com, yukuai3@huawei.com
Subject: [PATCH 5.10] block: fix null-deref in percpu_ref_put
Date:   Fri, 29 Jul 2022 14:52:43 +0800
Message-Id: <20220729065243.1786222-1-zhangwensheng@huaweicloud.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _Ch0CgD3_9PlgONidnlHBQ--.46322S4
X-Coremail-Antispam: 1UD129KBjvJXoWxur18Ar1fWF1xKr4kAr48Xrb_yoWrAry3pF
        WDKF4Ikw10gr4UWrW8Jw47ZasFgw4qkFyxCa93KrWYyFnFgF1vvr1kCrs8Xr48Cr4kArWU
        ZrWDWrsIkryUWFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkIb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6r1S6rWUM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxAIw28I
        cxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2
        IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI
        42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42
        IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2
        z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1zuWJUUUUU==
X-CM-SenderInfo: x2kd0wpzhq2xhhqjqx5xdzvxpfor3voofrz/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Wensheng <zhangwensheng5@huawei.com>

In the use of q_usage_counter of request_queue, blk_cleanup_queue using
"wait_event(q->mq_freeze_wq, percpu_ref_is_zero(&q->q_usage_counter))"
to wait q_usage_counter becoming zero. however, if the q_usage_counter
becoming zero quickly, and percpu_ref_exit will execute and ref->data
will be freed, maybe another process will cause a null-defef problem
like below:

	CPU0                             CPU1
blk_cleanup_queue
 blk_freeze_queue
  blk_mq_freeze_queue_wait
				scsi_end_request
				 percpu_ref_get
				 ...
				 percpu_ref_put
				  atomic_long_sub_and_test
  percpu_ref_exit
   ref->data -> NULL
   				   ref->data->release(ref) -> null-deref

Fix it by setting flag(QUEUE_FLAG_USAGE_COUNT_SYNC) to add synchronization
mechanism, when ref->data->release is called, the flag will be setted,
and the "wait_event" in blk_mq_freeze_queue_wait must wait flag becoming
true as well, which will limit percpu_ref_exit to execute ahead of time.

Signed-off-by: Zhang Wensheng <zhangwensheng5@huawei.com>
---
 block/blk-core.c       | 4 +++-
 block/blk-mq.c         | 7 +++++++
 include/linux/blk-mq.h | 1 +
 include/linux/blkdev.h | 2 ++
 4 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 26664f2a139e..238d0f3cd279 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -385,7 +385,8 @@ void blk_cleanup_queue(struct request_queue *q)
 	 * prevent that blk_mq_run_hw_queues() accesses the hardware queues
 	 * after draining finished.
 	 */
-	blk_freeze_queue(q);
+	blk_freeze_queue_start(q);
+	blk_mq_freeze_queue_wait_sync(q);
 
 	rq_qos_exit(q);
 
@@ -500,6 +501,7 @@ static void blk_queue_usage_counter_release(struct percpu_ref *ref)
 	struct request_queue *q =
 		container_of(ref, struct request_queue, q_usage_counter);
 
+	blk_queue_flag_set(QUEUE_FLAG_USAGE_COUNT_SYNC, q);
 	wake_up_all(&q->mq_freeze_wq);
 }
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index c5d82b21a1cc..15c4e4530c87 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -134,6 +134,7 @@ void blk_freeze_queue_start(struct request_queue *q)
 {
 	mutex_lock(&q->mq_freeze_lock);
 	if (++q->mq_freeze_depth == 1) {
+		blk_queue_flag_clear(QUEUE_FLAG_USAGE_COUNT_SYNC, q);
 		percpu_ref_kill(&q->q_usage_counter);
 		mutex_unlock(&q->mq_freeze_lock);
 		if (queue_is_mq(q))
@@ -144,6 +145,12 @@ void blk_freeze_queue_start(struct request_queue *q)
 }
 EXPORT_SYMBOL_GPL(blk_freeze_queue_start);
 
+void blk_mq_freeze_queue_wait_sync(struct request_queue *q)
+{
+	wait_event(q->mq_freeze_wq, percpu_ref_is_zero(&q->q_usage_counter) &&
+			test_bit(QUEUE_FLAG_USAGE_COUNT_SYNC, &q->queue_flags));
+}
+
 void blk_mq_freeze_queue_wait(struct request_queue *q)
 {
 	wait_event(q->mq_freeze_wq, percpu_ref_is_zero(&q->q_usage_counter));
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index f8ea27423d1d..95b2c904375f 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -522,6 +522,7 @@ void blk_mq_freeze_queue(struct request_queue *q);
 void blk_mq_unfreeze_queue(struct request_queue *q);
 void blk_freeze_queue_start(struct request_queue *q);
 void blk_mq_freeze_queue_wait(struct request_queue *q);
+void blk_mq_freeze_queue_wait_sync(struct request_queue *q);
 int blk_mq_freeze_queue_wait_timeout(struct request_queue *q,
 				     unsigned long timeout);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 98fdf5a31fd6..b61461e3a734 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -629,6 +629,8 @@ struct request_queue {
 #define QUEUE_FLAG_RQ_ALLOC_TIME 27	/* record rq->alloc_time_ns */
 #define QUEUE_FLAG_HCTX_ACTIVE	28	/* at least one blk-mq hctx is active */
 #define QUEUE_FLAG_NOWAIT       29	/* device supports NOWAIT */
+/* sync for q_usage_counter */
+#define QUEUE_FLAG_USAGE_COUNT_SYNC    30
 
 #define QUEUE_FLAG_MQ_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_SAME_COMP) |		\
-- 
2.31.1

