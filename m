Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B00420B40
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 14:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233335AbhJDM4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 08:56:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:57258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233340AbhJDM4A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 08:56:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E4276124C;
        Mon,  4 Oct 2021 12:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352051;
        bh=BvO/G+c7/2ViGYhMAqkPVGKTR/3WY0MCv2IX0iVIVLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tEwsoQhEYtfMGZnjYiYWaaufXSvTntENSld7QJwbM9S+ko/kLceOl9ugySbcc/YFg
         KOVE8B2qjzHETiNbOQrPS5PYXP1AWZPvHh1+CzAIvKnBSUkp2PotWgerSZwoHRZJlk
         jVplkwlkymcSN9sdooMAtmvUC1plDFpolemSr9xI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 13/41] blktrace: Fix uaf in blk_trace access after removing by sysfs
Date:   Mon,  4 Oct 2021 14:52:04 +0200
Message-Id: <20211004125027.010673526@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125026.597501645@linuxfoundation.org>
References: <20211004125026.597501645@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 5afedf670caf30a2b5a52da96eb7eac7dee6a9c9 ]

There is an use-after-free problem triggered by following process:

      P1(sda)				P2(sdb)
			echo 0 > /sys/block/sdb/trace/enable
			  blk_trace_remove_queue
			    synchronize_rcu
			    blk_trace_free
			      relay_close
rcu_read_lock
__blk_add_trace
  trace_note_tsk
  (Iterate running_trace_list)
			        relay_close_buf
				  relay_destroy_buf
				    kfree(buf)
    trace_note(sdb's bt)
      relay_reserve
        buf->offset <- nullptr deference (use-after-free) !!!
rcu_read_unlock

[  502.714379] BUG: kernel NULL pointer dereference, address:
0000000000000010
[  502.715260] #PF: supervisor read access in kernel mode
[  502.715903] #PF: error_code(0x0000) - not-present page
[  502.716546] PGD 103984067 P4D 103984067 PUD 17592b067 PMD 0
[  502.717252] Oops: 0000 [#1] SMP
[  502.720308] RIP: 0010:trace_note.isra.0+0x86/0x360
[  502.732872] Call Trace:
[  502.733193]  __blk_add_trace.cold+0x137/0x1a3
[  502.733734]  blk_add_trace_rq+0x7b/0xd0
[  502.734207]  blk_add_trace_rq_issue+0x54/0xa0
[  502.734755]  blk_mq_start_request+0xde/0x1b0
[  502.735287]  scsi_queue_rq+0x528/0x1140
...
[  502.742704]  sg_new_write.isra.0+0x16e/0x3e0
[  502.747501]  sg_ioctl+0x466/0x1100

Reproduce method:
  ioctl(/dev/sda, BLKTRACESETUP, blk_user_trace_setup[buf_size=127])
  ioctl(/dev/sda, BLKTRACESTART)
  ioctl(/dev/sdb, BLKTRACESETUP, blk_user_trace_setup[buf_size=127])
  ioctl(/dev/sdb, BLKTRACESTART)

  echo 0 > /sys/block/sdb/trace/enable &
  // Add delay(mdelay/msleep) before kernel enters blk_trace_free()

  ioctl$SG_IO(/dev/sda, SG_IO, ...)
  // Enters trace_note_tsk() after blk_trace_free() returned
  // Use mdelay in rcu region rather than msleep(which may schedule out)

Remove blk_trace from running_list before calling blk_trace_free() by
sysfs if blk_trace is at Blktrace_running state.

Fixes: c71a896154119f ("blktrace: add ftrace plugin")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Link: https://lore.kernel.org/r/20210923134921.109194-1-chengzhihao1@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/blktrace.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 8ac3663e0012..c142e100840e 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1581,6 +1581,14 @@ static int blk_trace_remove_queue(struct request_queue *q)
 	if (bt == NULL)
 		return -EINVAL;
 
+	if (bt->trace_state == Blktrace_running) {
+		bt->trace_state = Blktrace_stopped;
+		spin_lock_irq(&running_trace_lock);
+		list_del_init(&bt->running_list);
+		spin_unlock_irq(&running_trace_lock);
+		relay_flush(bt->rchan);
+	}
+
 	put_probe_ref();
 	synchronize_rcu();
 	blk_trace_free(bt);
-- 
2.33.0



