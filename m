Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED18D34CAF1
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234536AbhC2IlI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:41:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:35302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234884AbhC2IkP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:40:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 863796196E;
        Mon, 29 Mar 2021 08:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007201;
        bh=TE0WJF4oG0nmO9NT0gwEmSkgqQEdN8DAIiowraIa6oE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bH8YllltYy9SB0UUleHlFqW9tLqzqGS6h+C7bl/e98N9IMSCdfDNhSzy4/tPgPn9N
         z21Q87nb6sYCZYFQAqSXPGJ8hSCYaFqktBw40RVW8rq2ReWMEyoG/OijMdSdi5ak0m
         r9HywI7vA5mW4LWXbigmXCj9kF1ZrAEv2MdN6IO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Jeffery <djeffery@redhat.com>,
        Ming Lei <ming.lei@redhat.com>,
        Laurence Oberman <loberman@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 235/254] block: recalculate segment count for multi-segment discards correctly
Date:   Mon, 29 Mar 2021 09:59:11 +0200
Message-Id: <20210329075640.808534260@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Jeffery <djeffery@redhat.com>

[ Upstream commit a958937ff166fc60d1c3a721036f6ff41bfa2821 ]

When a stacked block device inserts a request into another block device
using blk_insert_cloned_request, the request's nr_phys_segments field gets
recalculated by a call to blk_recalc_rq_segments in
blk_cloned_rq_check_limits. But blk_recalc_rq_segments does not know how to
handle multi-segment discards. For disk types which can handle
multi-segment discards like nvme, this results in discard requests which
claim a single segment when it should report several, triggering a warning
in nvme and causing nvme to fail the discard from the invalid state.

 WARNING: CPU: 5 PID: 191 at drivers/nvme/host/core.c:700 nvme_setup_discard+0x170/0x1e0 [nvme_core]
 ...
 nvme_setup_cmd+0x217/0x270 [nvme_core]
 nvme_loop_queue_rq+0x51/0x1b0 [nvme_loop]
 __blk_mq_try_issue_directly+0xe7/0x1b0
 blk_mq_request_issue_directly+0x41/0x70
 ? blk_account_io_start+0x40/0x50
 dm_mq_queue_rq+0x200/0x3e0
 blk_mq_dispatch_rq_list+0x10a/0x7d0
 ? __sbitmap_queue_get+0x25/0x90
 ? elv_rb_del+0x1f/0x30
 ? deadline_remove_request+0x55/0xb0
 ? dd_dispatch_request+0x181/0x210
 __blk_mq_do_dispatch_sched+0x144/0x290
 ? bio_attempt_discard_merge+0x134/0x1f0
 __blk_mq_sched_dispatch_requests+0x129/0x180
 blk_mq_sched_dispatch_requests+0x30/0x60
 __blk_mq_run_hw_queue+0x47/0xe0
 __blk_mq_delay_run_hw_queue+0x15b/0x170
 blk_mq_sched_insert_requests+0x68/0xe0
 blk_mq_flush_plug_list+0xf0/0x170
 blk_finish_plug+0x36/0x50
 xlog_cil_committed+0x19f/0x290 [xfs]
 xlog_cil_process_committed+0x57/0x80 [xfs]
 xlog_state_do_callback+0x1e0/0x2a0 [xfs]
 xlog_ioend_work+0x2f/0x80 [xfs]
 process_one_work+0x1b6/0x350
 worker_thread+0x53/0x3e0
 ? process_one_work+0x350/0x350
 kthread+0x11b/0x140
 ? __kthread_bind_mask+0x60/0x60
 ret_from_fork+0x22/0x30

This patch fixes blk_recalc_rq_segments to be aware of devices which can
have multi-segment discards. It calculates the correct discard segment
count by counting the number of bio as each discard bio is considered its
own segment.

Fixes: 1e739730c5b9 ("block: optionally merge discontiguous discard bios into a single request")
Signed-off-by: David Jeffery <djeffery@redhat.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Link: https://lore.kernel.org/r/20210211143807.GA115624@redhat
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-merge.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 808768f6b174..756473295f19 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -383,6 +383,14 @@ unsigned int blk_recalc_rq_segments(struct request *rq)
 	switch (bio_op(rq->bio)) {
 	case REQ_OP_DISCARD:
 	case REQ_OP_SECURE_ERASE:
+		if (queue_max_discard_segments(rq->q) > 1) {
+			struct bio *bio = rq->bio;
+
+			for_each_bio(bio)
+				nr_phys_segs++;
+			return nr_phys_segs;
+		}
+		return 1;
 	case REQ_OP_WRITE_ZEROES:
 		return 0;
 	case REQ_OP_WRITE_SAME:
-- 
2.30.1



