Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63F9D34C956
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbhC2I32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:29:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233684AbhC2IZ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:25:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9371619A0;
        Mon, 29 Mar 2021 08:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006329;
        bh=bGayc2YXh4BbZm3nhhpsa38t+xHmVhk1xIR6XObiINM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UI+qIl4CdTMy37/RtRMPMnZHUT9p89PqK1FhSt6PcTQnOU3cVs6HV0TTyF8wjVTf1
         UeU1kURy7D1ImpQF40tqqfBLhuXnI5ndLFIqzLZSkvSvZveaWTeHhnCWK+CGeHJujJ
         Cec9B09hesJtkVloQg/cQOx75KUhZJFd8QhpXFh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Jeffery <djeffery@redhat.com>,
        Ming Lei <ming.lei@redhat.com>,
        Laurence Oberman <loberman@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 201/221] block: recalculate segment count for multi-segment discards correctly
Date:   Mon, 29 Mar 2021 09:58:52 +0200
Message-Id: <20210329075635.832773144@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
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
index 97b7c2821565..7cdd56696647 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -375,6 +375,14 @@ unsigned int blk_recalc_rq_segments(struct request *rq)
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



