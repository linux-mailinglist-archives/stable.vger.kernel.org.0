Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6C5560205A
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 03:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbiJRBVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 21:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiJRBVd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 21:21:33 -0400
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B5A7EFEB;
        Mon, 17 Oct 2022 18:21:28 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4MrwxQ0n7Nz6R63t;
        Tue, 18 Oct 2022 09:19:06 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
        by APP4 (Coremail) with SMTP id gCh0CgAXCzKR_01jxSkfAA--.17823S6;
        Tue, 18 Oct 2022 09:21:23 +0800 (CST)
From:   Yu Kuai <yukuai1@huaweicloud.com>
To:     gregkh@linuxfoundation.org, axboe@kernel.dk, yukuai3@huawei.com
Cc:     stable@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, yukuai1@huaweicloud.com,
        yi.zhang@hawei.com
Subject: [PATCH 5.10 2/3] blk-wbt: call rq_qos_add() after wb_normal is initialized
Date:   Tue, 18 Oct 2022 09:43:25 +0800
Message-Id: <20221018014326.467842-3-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221018014326.467842-1-yukuai1@huaweicloud.com>
References: <20221018014326.467842-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgAXCzKR_01jxSkfAA--.17823S6
X-Coremail-Antispam: 1UD129KBjvJXoWxAFyrWryfZr15ZFWrWFW7urg_yoW5Xr4kpa
        y2kFW5tr42grs2vF4xJr47ZFW3Kws5Jry7ur43G3yFqr9rKryjvanagF15W34rArWkCF43
        tr1FvFZ8GFyUZ37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9m14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
        x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
        Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
        A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
        0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
        IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
        Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF04k20xvY0x0EwIxGrwCFx2
        IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v2
        6r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67
        AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IY
        s7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr
        0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUc6pPUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

commit 8c5035dfbb9475b67c82b3fdb7351236525bf52b upstream.

Our test found a problem that wbt inflight counter is negative, which
will cause io hang(noted that this problem doesn't exist in mainline):

t1: device create	t2: issue io
add_disk
 blk_register_queue
  wbt_enable_default
   wbt_init
    rq_qos_add
    // wb_normal is still 0
			/*
			 * in mainline, disk can't be opened before
			 * bdev_add(), however, in old kernels, disk
			 * can be opened before blk_register_queue().
			 */
			blkdev_issue_flush
                        // disk size is 0, however, it's not checked
                         submit_bio_wait
                          submit_bio
                           blk_mq_submit_bio
                            rq_qos_throttle
                             wbt_wait
			      bio_to_wbt_flags
                               rwb_enabled
			       // wb_normal is 0, inflight is not increased

    wbt_queue_depth_changed(&rwb->rqos);
     wbt_update_limits
     // wb_normal is initialized
                            rq_qos_track
                             wbt_track
                              rq->wbt_flags |= bio_to_wbt_flags(rwb, bio);
			      // wb_normal is not 0，wbt_flags will be set
t3: io completion
blk_mq_free_request
 rq_qos_done
  wbt_done
   wbt_is_tracked
   // return true
   __wbt_done
    wbt_rqw_done
     atomic_dec_return(&rqw->inflight);
     // inflight is decreased

commit 8235b5c1e8c1 ("block: call bdev_add later in device_add_disk") can
avoid this problem, however it's better to fix this problem in wbt:

1) Lower kernel can't backport this patch due to lots of refactor.
2) Root cause is that wbt call rq_qos_add() before wb_normal is
initialized.

Fixes: e34cbd307477 ("blk-wbt: add general throttling mechanism")
Cc: <stable@vger.kernel.org>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20220913105749.3086243-1-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/blk-wbt.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/block/blk-wbt.c b/block/blk-wbt.c
index 4ec0a018a2ad..bafdb8098893 100644
--- a/block/blk-wbt.c
+++ b/block/blk-wbt.c
@@ -840,6 +840,10 @@ int wbt_init(struct request_queue *q)
 	rwb->enable_state = WBT_STATE_ON_DEFAULT;
 	rwb->wc = 1;
 	rwb->rq_depth.default_depth = RWB_DEF_DEPTH;
+	rwb->min_lat_nsec = wbt_default_latency_nsec(q);
+
+	wbt_queue_depth_changed(&rwb->rqos);
+	wbt_set_write_cache(q, test_bit(QUEUE_FLAG_WC, &q->queue_flags));
 
 	/*
 	 * Assign rwb and add the stats callback.
@@ -847,10 +851,5 @@ int wbt_init(struct request_queue *q)
 	rq_qos_add(q, &rwb->rqos);
 	blk_stat_add_callback(q, rwb->cb);
 
-	rwb->min_lat_nsec = wbt_default_latency_nsec(q);
-
-	wbt_queue_depth_changed(&rwb->rqos);
-	wbt_set_write_cache(q, test_bit(QUEUE_FLAG_WC, &q->queue_flags));
-
 	return 0;
 }
-- 
2.31.1

