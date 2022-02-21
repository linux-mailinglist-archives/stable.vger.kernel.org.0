Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A96C4BE624
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349704AbiBUJa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:30:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349779AbiBUJ3O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:29:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA3F24F23;
        Mon, 21 Feb 2022 01:13:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3401160EF0;
        Mon, 21 Feb 2022 09:13:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E7F8C354B9;
        Mon, 21 Feb 2022 09:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434783;
        bh=w+UicoM5DkkuhGVLBhKd8GylSa81D5HTmjneWjIRTwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B8BqM33xE60TbtFugAkVaONMTlBv+J2eixnFPW4iojOcQB55oo8lNE+WgvT2147O9
         z1Pdlim7DACKEXw1UtQKJmtJcvaAudkvEJgMY3RnEPB2igOThdZJkHa/LeYqKgzacy
         Odd0TF2l6ERhdwROHt+zqMBiWi9p313uLLrhf/KY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@rehdat.com>,
        Christoph Hellwig <hch@lst.de>,
        Laibin Qiu <qiulaibin@huawei.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 130/196] block/wbt: fix negative inflight counter when remove scsi device
Date:   Mon, 21 Feb 2022 09:49:22 +0100
Message-Id: <20220221084935.280505852@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Laibin Qiu <qiulaibin@huawei.com>

commit e92bc4cd34de2ce454bdea8cd198b8067ee4e123 upstream.

Now that we disable wbt by set WBT_STATE_OFF_DEFAULT in
wbt_disable_default() when switch elevator to bfq. And when
we remove scsi device, wbt will be enabled by wbt_enable_default.
If it become false positive between wbt_wait() and wbt_track()
when submit write request.

The following is the scenario that triggered the problem.

T1                          T2                           T3
                            elevator_switch_mq
                            bfq_init_queue
                            wbt_disable_default <= Set
                            rwb->enable_state (OFF)
Submit_bio
blk_mq_make_request
rq_qos_throttle
<= rwb->enable_state (OFF)
                                                         scsi_remove_device
                                                         sd_remove
                                                         del_gendisk
                                                         blk_unregister_queue
                                                         elv_unregister_queue
                                                         wbt_enable_default
                                                         <= Set rwb->enable_state (ON)
q_qos_track
<= rwb->enable_state (ON)
^^^^^^ this request will mark WBT_TRACKED without inflight add and will
lead to drop rqw->inflight to -1 in wbt_done() which will trigger IO hung.

Fix this by move wbt_enable_default() from elv_unregister to
bfq_exit_queue(). Only re-enable wbt when bfq exit.

Fixes: 76a8040817b4b ("blk-wbt: make sure throttle is enabled properly")

Remove oneline stale comment, and kill one oneshot local variable.

Signed-off-by: Ming Lei <ming.lei@rehdat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/linux-block/20211214133103.551813-1-qiulaibin@huawei.com/
Signed-off-by: Laibin Qiu <qiulaibin@huawei.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bfq-iosched.c |    2 ++
 block/elevator.c    |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -6878,6 +6878,8 @@ static void bfq_exit_queue(struct elevat
 	spin_unlock_irq(&bfqd->lock);
 #endif
 
+	wbt_enable_default(bfqd->queue);
+
 	kfree(bfqd);
 }
 
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -523,8 +523,6 @@ void elv_unregister_queue(struct request
 		kobject_del(&e->kobj);
 
 		e->registered = 0;
-		/* Re-enable throttling in case elevator disabled it */
-		wbt_enable_default(q);
 	}
 }
 


