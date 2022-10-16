Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A75976000D3
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 17:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiJPPpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 11:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiJPPpC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 11:45:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E85BDFF7
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 08:45:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3953FB80CCA
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 15:44:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86220C433D6;
        Sun, 16 Oct 2022 15:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665935097;
        bh=8wsSW/uVMQnfPNGcCua9yaR5uSjhURSyambkkZn4X2s=;
        h=Subject:To:Cc:From:Date:From;
        b=PYO061ITLRZ/zbP2UQrUuyeDexAknV/8Y9VMMq1vQZqfo8B47n2OAdexwlAX5tcsZ
         lnWiyERgOb7hd21ME60Vc6npiAyFpEj7fpDC8A3fREh+M5NRLxmfxTdymPcwIBIdtD
         kpEv0S1mmbsfkMFycvjQqknAFAYx4SJyn25UK/00=
Subject: FAILED: patch "[PATCH] blk-wbt: call rq_qos_add() after wb_normal is initialized" failed to apply to 5.4-stable tree
To:     yukuai3@huawei.com, axboe@kernel.dk, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 17:45:42 +0200
Message-ID: <166593514272193@kroah.com>
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

8c5035dfbb94 ("blk-wbt: call rq_qos_add() after wb_normal is initialized")
5a20d073ec54 ("block: wbt: Remove unnecessary invoking of wbt_update_limits in wbt_init")
4d89e1d112a9 ("blk-wbt: rename __wbt_update_limits to wbt_update_limits")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8c5035dfbb9475b67c82b3fdb7351236525bf52b Mon Sep 17 00:00:00 2001
From: Yu Kuai <yukuai3@huawei.com>
Date: Tue, 13 Sep 2022 18:57:49 +0800
Subject: [PATCH] blk-wbt: call rq_qos_add() after wb_normal is initialized
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/block/blk-wbt.c b/block/blk-wbt.c
index a9982000b667..246467926253 100644
--- a/block/blk-wbt.c
+++ b/block/blk-wbt.c
@@ -843,6 +843,10 @@ int wbt_init(struct request_queue *q)
 	rwb->enable_state = WBT_STATE_ON_DEFAULT;
 	rwb->wc = 1;
 	rwb->rq_depth.default_depth = RWB_DEF_DEPTH;
+	rwb->min_lat_nsec = wbt_default_latency_nsec(q);
+
+	wbt_queue_depth_changed(&rwb->rqos);
+	wbt_set_write_cache(q, test_bit(QUEUE_FLAG_WC, &q->queue_flags));
 
 	/*
 	 * Assign rwb and add the stats callback.
@@ -853,11 +857,6 @@ int wbt_init(struct request_queue *q)
 
 	blk_stat_add_callback(q, rwb->cb);
 
-	rwb->min_lat_nsec = wbt_default_latency_nsec(q);
-
-	wbt_queue_depth_changed(&rwb->rqos);
-	wbt_set_write_cache(q, test_bit(QUEUE_FLAG_WC, &q->queue_flags));
-
 	return 0;
 
 err_free:

