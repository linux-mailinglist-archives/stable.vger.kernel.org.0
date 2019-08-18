Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6D891516
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 08:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbfHRGgy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 02:36:54 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42251 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726115AbfHRGgy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Aug 2019 02:36:54 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 815D421C4E;
        Sun, 18 Aug 2019 02:36:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 18 Aug 2019 02:36:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=AL0zJE
        C3rBuku70cMO5sXECxw0WTiSTUZZjvkKaRmWg=; b=BBOVSQJgbbvs3lkpT3ZP/3
        659LaB5iFFrQ3wpIDuPI4WamfDOjODOUwHELrj7Ncu3GZ8Emjc68wYsUqHMEzsho
        JCWZjfXO63t2ZmHJc6hRFFBfBWMbXH6kQpK5VmBGomNW4uuQCnG7mYpHUAojvppG
        QBOa2qZU8MPGBAG8Nelcp7JrQs3yg16cGTcgLrrnpRDvrOgtbBCFElKjS2XzZYfp
        DtKC7rcxhinwC81uFjEi7cWYZSPJ6V1IabxoVLBqmliQ3wcF0OrYiaj4/EAr4VEn
        rV+noxRbvaiy7yYqBUelt6R+SHHFuNvqBgL3Z4pekqSjX9A+1bTjOwmtb6DTC6pA
        ==
X-ME-Sender: <xms:BfJYXXxKeoR5zx88GimJHY7n_QUM6l83KfZ_4JqPCjbbMR-BCiZh5g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudefiedguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedv
X-ME-Proxy: <xmx:BfJYXSM9TokogaLaSUp39CJTGAjWykRjQcbDQX7szFqzCChkH5NHPA>
    <xmx:BfJYXZjOSdTSjhMWI3Zv3aj6Ejb5sC65-CdiVixdy2td39OReYYA1g>
    <xmx:BfJYXQUrI5RBQnwEuAQMZJjlPS2unMk925z13JCypF8T9GZcBrCEVg>
    <xmx:BfJYXSKfTezbV4cdhhLYL23a0tHGgW_Fd65A5gzQK8ksAMnnBNqGBg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 067888005C;
        Sun, 18 Aug 2019 02:36:52 -0400 (EDT)
Subject: FAILED: patch "[PATCH] blk-mq: move cancel of requeue_work to the front of" failed to apply to 4.19-stable tree
To:     zhengbin13@huawei.com, axboe@kernel.dk, ming.lei@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 18 Aug 2019 08:36:42 +0200
Message-ID: <15661102029372@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e26cc08265dda37d2acc8394604f220ef412299d Mon Sep 17 00:00:00 2001
From: zhengbin <zhengbin13@huawei.com>
Date: Mon, 12 Aug 2019 20:36:55 +0800
Subject: [PATCH] blk-mq: move cancel of requeue_work to the front of
 blk_exit_queue

blk_exit_queue will free elevator_data, while blk_mq_requeue_work
will access it. Move cancel of requeue_work to the front of
blk_exit_queue to avoid use-after-free.

blk_exit_queue                blk_mq_requeue_work
  __elevator_exit               blk_mq_run_hw_queues
    blk_mq_exit_sched             blk_mq_run_hw_queue
      dd_exit_queue                 blk_mq_hctx_has_pending
        kfree(elevator_data)          blk_mq_sched_has_work
                                        dd_has_work

Fixes: fbc2a15e3433 ("blk-mq: move cancel of requeue_work into blk_mq_release")
Cc: stable@vger.kernel.org
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/block/blk-mq.c b/block/blk-mq.c
index f78d3287dd82..a8e6a58f5f28 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2666,8 +2666,6 @@ void blk_mq_release(struct request_queue *q)
 	struct blk_mq_hw_ctx *hctx, *next;
 	int i;
 
-	cancel_delayed_work_sync(&q->requeue_work);
-
 	queue_for_each_hw_ctx(q, hctx, i)
 		WARN_ON_ONCE(hctx && list_empty(&hctx->hctx_list));
 
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 977c659dcd18..9bfa3ea4ed63 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -892,6 +892,9 @@ static void __blk_release_queue(struct work_struct *work)
 
 	blk_free_queue_stats(q->stats);
 
+	if (queue_is_mq(q))
+		cancel_delayed_work_sync(&q->requeue_work);
+
 	blk_exit_queue(q);
 
 	blk_queue_free_zone_bitmaps(q);

