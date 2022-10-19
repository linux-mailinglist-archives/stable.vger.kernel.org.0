Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC236044E7
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 14:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232947AbiJSMSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 08:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232957AbiJSMRm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 08:17:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD179FF235;
        Wed, 19 Oct 2022 04:53:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2432B822F6;
        Wed, 19 Oct 2022 08:45:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3680FC433D6;
        Wed, 19 Oct 2022 08:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169145;
        bh=cNt7T6RmL3y/9iiO0cyR9PT7nxKXSZDGJ+iSkvgxvIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qTzh2qs5jq7cpuGiQ6MH8/M+ErxjaGR6i5k4LHR3Ksey7GkcFyGgZsXST9L9fFAfB
         9O8yXlMg98j5Grw+IqWLBisbxSwBRJqM3BFayfbG73H2AvuPh50riMl9YsUTxT8mb8
         GJ1G1jp24n7A5dJnBLD60NxPZTo6NZrqoO1GNobY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 173/862] blk-wbt: call rq_qos_add() after wb_normal is initialized
Date:   Wed, 19 Oct 2022 10:24:20 +0200
Message-Id: <20221019083257.596074416@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-wbt.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

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


