Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7592E611062
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 14:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbiJ1ME7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 08:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbiJ1ME4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 08:04:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6102AC74
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 05:04:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BBB662806
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 12:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6C1C433C1;
        Fri, 28 Oct 2022 12:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666958690;
        bh=HqRxgCAcwRo7Vj35j42nf+TqkpGbX3Siy8B/pS+HHHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZslSUm8uBld9RcpzjyGZ3MF2eMUYaMhyc4l/dwUyPmjSH5w4oQxI+789lmkHK+jbZ
         VUkB8xpQs8z/VwnlgcUp2dQx1sDFnEQlwUPVMtFLw8Tra3dK7rREDZg44Yof+R0mpQ
         birxhI4GSNWM4bXmq0GUhyk79VRi99ZUS8Do2YlE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yu Kuai <yukuai3@huawei.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 16/73] blk-wbt: call rq_qos_add() after wb_normal is initialized
Date:   Fri, 28 Oct 2022 14:03:13 +0200
Message-Id: <20221028120233.068971425@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
References: <20221028120232.344548477@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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


