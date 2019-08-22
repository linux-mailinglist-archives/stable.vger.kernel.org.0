Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBCE99ADC
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbfHVRQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:16:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:58198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390381AbfHVRId (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:33 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD24F2341C;
        Thu, 22 Aug 2019 17:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493713;
        bh=ORNdI1zlp/E7iN4DUgSccbD2JFR8fxTNr0muvKA4eyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wbCrOkYVNeUi+bisw+et9pCPBuEuAfkRwP7MlJ5CNcEjzoMpIUg0C1g8Yskhmgnuu
         HUSXHCZS2HA8BdHdAfQuE+1KZD1VHXtdDjJed5S7mvF/rQM7y1SArgJgf04feOct1B
         ZrkUmvqU97tkkOJ8I5NLd+49a9kTo60tuqOhtxsg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhengbin <zhengbin13@huawei.com>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 035/135] blk-mq: move cancel of requeue_work to the front of blk_exit_queue
Date:   Thu, 22 Aug 2019 13:06:31 -0400
Message-Id: <20190822170811.13303-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhengbin <zhengbin13@huawei.com>

commit e26cc08265dda37d2acc8394604f220ef412299d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq.c    | 2 --
 block/blk-sysfs.c | 3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index ce0f5f4ede70c..68106a41f90d2 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2674,8 +2674,6 @@ void blk_mq_release(struct request_queue *q)
 	struct blk_mq_hw_ctx *hctx, *next;
 	int i;
 
-	cancel_delayed_work_sync(&q->requeue_work);
-
 	queue_for_each_hw_ctx(q, hctx, i)
 		WARN_ON_ONCE(hctx && list_empty(&hctx->hctx_list));
 
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 977c659dcd184..9bfa3ea4ed630 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -892,6 +892,9 @@ static void __blk_release_queue(struct work_struct *work)
 
 	blk_free_queue_stats(q->stats);
 
+	if (queue_is_mq(q))
+		cancel_delayed_work_sync(&q->requeue_work);
+
 	blk_exit_queue(q);
 
 	blk_queue_free_zone_bitmaps(q);
-- 
2.20.1

