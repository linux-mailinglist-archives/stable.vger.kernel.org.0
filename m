Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C248C60402C
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233999AbiJSJmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234402AbiJSJkW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:40:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1EAEF584;
        Wed, 19 Oct 2022 02:16:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B190617E6;
        Wed, 19 Oct 2022 09:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D31C433D6;
        Wed, 19 Oct 2022 09:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170905;
        bh=zEE9owPpFs4A8sJh3hD8BeRA5HFzdvgeo26rkxlE52M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fYivneM6oDjIwQPZBrZdQkr8qnjRD0OsTsy0lTXLfUYCYynyjRX84XLULO3fEODLx
         ZiGd1ybU5wt4d1k0p4yfOikwAaTDQiNmFVRMWYEOvxQ2i/UJWsidgwOSHRlx0uHwf0
         0AhoAisAcROXqPxGMkontHLt3XC8QICMK0yTghY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 832/862] blk-mq: use quiesced elevator switch when reinitializing queues
Date:   Wed, 19 Oct 2022 10:35:19 +0200
Message-Id: <20221019083326.657974784@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 8237c01f1696bc53c470493bf1fe092a107648a6 ]

The hctx's run_work may be racing with the elevator switch when
reinitializing hardware queues. The queue is merely frozen in this
context, but that only prevents requests from allocating and doesn't
stop the hctx work from running. The work may get an elevator pointer
that's being torn down, and can result in use-after-free errors and
kernel panics (example below). Use the quiesced elevator switch instead,
and make the previous one static since it is now only used locally.

  nvme nvme0: resetting controller
  nvme nvme0: 32/0/0 default/read/poll queues
  BUG: kernel NULL pointer dereference, address: 0000000000000008
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 80000020c8861067 P4D 80000020c8861067 PUD 250f8c8067 PMD 0
  Oops: 0000 [#1] SMP PTI
  Workqueue: kblockd blk_mq_run_work_fn
  RIP: 0010:kyber_has_work+0x29/0x70

...

  Call Trace:
   __blk_mq_do_dispatch_sched+0x83/0x2b0
   __blk_mq_sched_dispatch_requests+0x12e/0x170
   blk_mq_sched_dispatch_requests+0x30/0x60
   __blk_mq_run_hw_queue+0x2b/0x50
   process_one_work+0x1ef/0x380
   worker_thread+0x2d/0x3e0

Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220927155652.3260724-1-kbusch@fb.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c   | 6 +++---
 block/blk.h      | 3 +--
 block/elevator.c | 4 ++--
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index c96c8c4f751b..887b8682eb69 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4473,14 +4473,14 @@ static bool blk_mq_elv_switch_none(struct list_head *head,
 	list_add(&qe->node, head);
 
 	/*
-	 * After elevator_switch_mq, the previous elevator_queue will be
+	 * After elevator_switch, the previous elevator_queue will be
 	 * released by elevator_release. The reference of the io scheduler
 	 * module get by elevator_get will also be put. So we need to get
 	 * a reference of the io scheduler module here to prevent it to be
 	 * removed.
 	 */
 	__module_get(qe->type->elevator_owner);
-	elevator_switch_mq(q, NULL);
+	elevator_switch(q, NULL);
 	mutex_unlock(&q->sysfs_lock);
 
 	return true;
@@ -4512,7 +4512,7 @@ static void blk_mq_elv_switch_back(struct list_head *head,
 	kfree(qe);
 
 	mutex_lock(&q->sysfs_lock);
-	elevator_switch_mq(q, t);
+	elevator_switch(q, t);
 	mutex_unlock(&q->sysfs_lock);
 }
 
diff --git a/block/blk.h b/block/blk.h
index d7142c4d2fef..52432eab621e 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -270,8 +270,7 @@ bool blk_bio_list_merge(struct request_queue *q, struct list_head *list,
 
 void blk_insert_flush(struct request *rq);
 
-int elevator_switch_mq(struct request_queue *q,
-			      struct elevator_type *new_e);
+int elevator_switch(struct request_queue *q, struct elevator_type *new_e);
 void elevator_exit(struct request_queue *q);
 int elv_register_queue(struct request_queue *q, bool uevent);
 void elv_unregister_queue(struct request_queue *q);
diff --git a/block/elevator.c b/block/elevator.c
index c319765892bb..bd71f0fc4e4b 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -588,7 +588,7 @@ void elv_unregister(struct elevator_type *e)
 }
 EXPORT_SYMBOL_GPL(elv_unregister);
 
-int elevator_switch_mq(struct request_queue *q,
+static int elevator_switch_mq(struct request_queue *q,
 			      struct elevator_type *new_e)
 {
 	int ret;
@@ -723,7 +723,7 @@ void elevator_init_mq(struct request_queue *q)
  * need for the new one. this way we have a chance of going back to the old
  * one, if the new one fails init for some reason.
  */
-static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
+int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
 {
 	int err;
 
-- 
2.35.1



