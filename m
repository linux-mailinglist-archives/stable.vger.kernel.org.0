Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08246354436
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241961AbhDEQEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:04:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241883AbhDEQEd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:04:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C373613C7;
        Mon,  5 Apr 2021 16:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617638666;
        bh=ccyQP+6I1vEkbRqttbNW6yMUbXUI93U+OiRwV2py3c8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JmUx7e0lPZAzX8FAmFLVl3dJY3DvetXkh75M5xyqgVGLw5YS5hoxR3Ldl93749lje
         +HH5GhMzWssOoGQA2jlRuPvJ7BJMkGGaRyvmJ9wM6nFmzmomIpVYVUUj73C/T2UUZN
         m/RlB0xdv0AEVgCUSMD8DH6/CtbQsiG5bhV+jz3+YQmX2cTkNFVmM89B96lnol5gW/
         pjEetIdIgmWMm8dL/rE+Um4RK9gZgo8ojoiL8C8MlImTtFa2DUMnrjrBgy3yqTyFAC
         wyZ/iCcqkoz7rpohkJZzbdPWC5TrMsWsA477lrdg5d7Vlkib+aZdG643BhZcKQCP9D
         RsmXyNac6fjCQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Damien Le Moal <damien.lemoal@wdc.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 18/22] null_blk: fix command timeout completion handling
Date:   Mon,  5 Apr 2021 12:04:01 -0400
Message-Id: <20210405160406.268132-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405160406.268132-1-sashal@kernel.org>
References: <20210405160406.268132-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
 drivers/block/null_blk/main.c     | 26 +++++++++++++++++++++-----
 drivers/block/null_blk/null_blk.h |  1 +
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 5357c3a4a36f..4f6af7a5921e 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -1369,10 +1369,13 @@ static blk_status_t null_handle_cmd(struct nullb_cmd *cmd, sector_t sector,
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
@@ -1451,8 +1454,20 @@ static bool should_requeue_request(struct request *rq)
 
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
 
@@ -1473,6 +1488,7 @@ static blk_status_t null_queue_rq(struct blk_mq_hw_ctx *hctx,
 	cmd->rq = bd->rq;
 	cmd->error = BLK_STS_OK;
 	cmd->nq = nq;
+	cmd->fake_timeout = should_timeout_request(bd->rq);
 
 	blk_mq_start_request(bd->rq);
 
@@ -1489,7 +1505,7 @@ static blk_status_t null_queue_rq(struct blk_mq_hw_ctx *hctx,
 			return BLK_STS_OK;
 		}
 	}
-	if (should_timeout_request(bd->rq))
+	if (cmd->fake_timeout)
 		return BLK_STS_OK;
 
 	return null_handle_cmd(cmd, sector, nr_sectors, req_op(bd->rq));
diff --git a/drivers/block/null_blk/null_blk.h b/drivers/block/null_blk/null_blk.h
index 83504f3cc9d6..4876d5adb12d 100644
--- a/drivers/block/null_blk/null_blk.h
+++ b/drivers/block/null_blk/null_blk.h
@@ -22,6 +22,7 @@ struct nullb_cmd {
 	blk_status_t error;
 	struct nullb_queue *nq;
 	struct hrtimer timer;
+	bool fake_timeout;
 };
 
 struct nullb_queue {
-- 
2.30.2

