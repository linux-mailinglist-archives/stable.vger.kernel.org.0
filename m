Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18FC14BE1BA
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347940AbiBUJPM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:15:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349197AbiBUJMJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:12:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8BC2AC74;
        Mon, 21 Feb 2022 01:05:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1441D6114D;
        Mon, 21 Feb 2022 09:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A19C36AE2;
        Mon, 21 Feb 2022 09:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434300;
        bh=0E/SeavlfFJPRCXvDa8gF2rgjtqzO+JBB0+eJp6JAvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wrRmVFNiK9Toxn690rJmbyF+RXIcktvWGr1XzvzHuRpm4DUFENjeB7oPVuzGzkS91
         YZQ+wqETELvQrw4eCNXxPxcsLMKJohluGrjSV2wZIcBMEeB2YIXJkOaj67vUQf2Kej
         S2HjAEpavUWumpi97Y9V+DFV3j4bNQmiGsgLqK20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@rehdat.com>,
        Christoph Hellwig <hch@lst.de>,
        Laibin Qiu <qiulaibin@huawei.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 081/121] block/wbt: fix negative inflight counter when remove scsi device
Date:   Mon, 21 Feb 2022 09:49:33 +0100
Message-Id: <20220221084923.945989057@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
References: <20220221084921.147454846@linuxfoundation.org>
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
@@ -6404,6 +6404,8 @@ static void bfq_exit_queue(struct elevat
 	spin_unlock_irq(&bfqd->lock);
 #endif
 
+	wbt_enable_default(bfqd->queue);
+
 	kfree(bfqd);
 }
 
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -518,8 +518,6 @@ void elv_unregister_queue(struct request
 		kobject_del(&e->kobj);
 
 		e->registered = 0;
-		/* Re-enable throttling in case elevator disabled it */
-		wbt_enable_default(q);
 	}
 }
 


