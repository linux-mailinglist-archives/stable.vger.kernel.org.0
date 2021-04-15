Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D05C9360DA2
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234354AbhDOPEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:04:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235418AbhDOPBT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:01:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A97A1613C3;
        Thu, 15 Apr 2021 14:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498642;
        bh=r8NYNX8R+BsOY+tC+5q7KQYsf+tn9BaP5kOazWivmaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KxCxHNTUnIunSqsyM9Y/jNj73SgdIoe6u2+b7AhPcHtTkuKx8bqHSGQUnC/Z307iA
         M40pqfk+JRbcbI0ffuX0qFytjZkqUnKmpbY76LE4rZLYYASJs4mafpAzJSm5wSf1yg
         fCH1crN75iLHXwW2q+vSKTMnY7QPGLmSgQ5KmyJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 17/25] null_blk: fix command timeout completion handling
Date:   Thu, 15 Apr 2021 16:48:11 +0200
Message-Id: <20210415144413.699420129@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.165663182@linuxfoundation.org>
References: <20210415144413.165663182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

[ Upstream commit de3510e52b0a398261271455562458003b8eea62 ]

Memory backed or zoned null block devices may generate actual request
timeout errors due to the submission path being blocked on memory
allocation or zone locking. Unlike fake timeouts or injected timeouts,
the request submission path will call blk_mq_complete_request() or
blk_mq_end_request() for these real timeout errors, causing a double
completion and use after free situation as the block layer timeout
handler executes blk_mq_rq_timed_out() and __blk_mq_free_request() in
blk_mq_check_expired(). This problem often triggers a NULL pointer
dereference such as:

BUG: kernel NULL pointer dereference, address: 0000000000000050
RIP: 0010:blk_mq_sched_mark_restart_hctx+0x5/0x20
...
Call Trace:
  dd_finish_request+0x56/0x80
  blk_mq_free_request+0x37/0x130
  null_handle_cmd+0xbf/0x250 [null_blk]
  ? null_queue_rq+0x67/0xd0 [null_blk]
  blk_mq_dispatch_rq_list+0x122/0x850
  __blk_mq_do_dispatch_sched+0xbb/0x2c0
  __blk_mq_sched_dispatch_requests+0x13d/0x190
  blk_mq_sched_dispatch_requests+0x30/0x60
  __blk_mq_run_hw_queue+0x49/0x90
  process_one_work+0x26c/0x580
  worker_thread+0x55/0x3c0
  ? process_one_work+0x580/0x580
  kthread+0x134/0x150
  ? kthread_create_worker_on_cpu+0x70/0x70
  ret_from_fork+0x1f/0x30

This problem very often triggers when running the full btrfs xfstests
on a memory-backed zoned null block device in a VM with limited amount
of memory.

Avoid this by executing blk_mq_complete_request() in null_timeout_rq()
only for commands that are marked for a fake timeout completion using
the fake_timeout boolean in struct null_cmd. For timeout errors injected
through debugfs, the timeout handler will execute
blk_mq_complete_request()i as before. This is safe as the submission
path does not execute complete requests in this case.

In null_timeout_rq(), also make sure to set the command error field to
BLK_STS_TIMEOUT and to propagate this error through to the request
completion.

Reported-by: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Tested-by: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Reviewed-by: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20210331225244.126426-1-damien.lemoal@wdc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk.h      |  1 +
 drivers/block/null_blk_main.c | 26 +++++++++++++++++++++-----
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/block/null_blk.h b/drivers/block/null_blk.h
index c24d9b5ad81a..7de703f28617 100644
--- a/drivers/block/null_blk.h
+++ b/drivers/block/null_blk.h
@@ -20,6 +20,7 @@ struct nullb_cmd {
 	blk_status_t error;
 	struct nullb_queue *nq;
 	struct hrtimer timer;
+	bool fake_timeout;
 };
 
 struct nullb_queue {
diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index 4685ea401d5b..bb3686c3869d 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -1367,10 +1367,13 @@ static blk_status_t null_handle_cmd(struct nullb_cmd *cmd, sector_t sector,
 	}
 
 	if (dev->zoned)
-		cmd->error = null_process_zoned_cmd(cmd, op,
-						    sector, nr_sectors);
+		sts = null_process_zoned_cmd(cmd, op, sector, nr_sectors);
 	else
-		cmd->error = null_process_cmd(cmd, op, sector, nr_sectors);
+		sts = null_process_cmd(cmd, op, sector, nr_sectors);
+
+	/* Do not overwrite errors (e.g. timeout errors) */
+	if (cmd->error == BLK_STS_OK)
+		cmd->error = sts;
 
 out:
 	nullb_complete_cmd(cmd);
@@ -1449,8 +1452,20 @@ static bool should_requeue_request(struct request *rq)
 
 static enum blk_eh_timer_return null_timeout_rq(struct request *rq, bool res)
 {
+	struct nullb_cmd *cmd = blk_mq_rq_to_pdu(rq);
+
 	pr_info("rq %p timed out\n", rq);
-	blk_mq_complete_request(rq);
+
+	/*
+	 * If the device is marked as blocking (i.e. memory backed or zoned
+	 * device), the submission path may be blocked waiting for resources
+	 * and cause real timeouts. For these real timeouts, the submission
+	 * path will complete the request using blk_mq_complete_request().
+	 * Only fake timeouts need to execute blk_mq_complete_request() here.
+	 */
+	cmd->error = BLK_STS_TIMEOUT;
+	if (cmd->fake_timeout)
+		blk_mq_complete_request(rq);
 	return BLK_EH_DONE;
 }
 
@@ -1471,6 +1486,7 @@ static blk_status_t null_queue_rq(struct blk_mq_hw_ctx *hctx,
 	cmd->rq = bd->rq;
 	cmd->error = BLK_STS_OK;
 	cmd->nq = nq;
+	cmd->fake_timeout = should_timeout_request(bd->rq);
 
 	blk_mq_start_request(bd->rq);
 
@@ -1487,7 +1503,7 @@ static blk_status_t null_queue_rq(struct blk_mq_hw_ctx *hctx,
 			return BLK_STS_OK;
 		}
 	}
-	if (should_timeout_request(bd->rq))
+	if (cmd->fake_timeout)
 		return BLK_STS_OK;
 
 	return null_handle_cmd(cmd, sector, nr_sectors, req_op(bd->rq));
-- 
2.30.2



