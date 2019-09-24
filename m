Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3C4BD571
	for <lists+stable@lfdr.de>; Wed, 25 Sep 2019 01:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411193AbfIXXXF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 19:23:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411192AbfIXXXE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 19:23:04 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 251422146E;
        Tue, 24 Sep 2019 23:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569367383;
        bh=IZOGoiThbQyHcoidP4y3x1AvffuwXT6fGxUOub48fVo=;
        h=Date:From:To:Subject:From;
        b=VtHUxfOCcusMaypO3VaBFL0USUsx16USQHH73wl5YS5ukqax/r0VivxTo6xOXXHea
         I91fNRS0TtbzP2LtzPKK51Skfv0V282APAS/Ect8/OtRf3ZPM3Q1ZYYFYTY+kqbF0R
         SUdIXN//qEP1zNUXz13Tl/ICzsdO9Rfz1a8OHcxc=
Date:   Tue, 24 Sep 2019 16:23:02 -0700
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, clm@fb.com, jack@suse.cz,
        mm-commits@vger.kernel.org, stable@vger.kernel.org, tj@kernel.org
Subject:  +
 writeback-fix-use-after-free-in-finish_writeback_work.patch added to -mm
 tree
Message-ID: <20190924232302.Y87slbHE_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: writeback: fix use-after-free in finish_writeback_work()
has been added to the -mm tree.  Its filename is
     writeback-fix-use-after-free-in-finish_writeback_work.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/writeback-fix-use-after-free-in-finish_writeback_work.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/writeback-fix-use-after-free-in-finish_writeback_work.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: writeback: fix use-after-free in finish_writeback_work()

finish_writeback_work() reads @done->waitq after decrementing @done->cnt. 
However, once @done->cnt reaches zero, @done may be freed (from stack) at
any moment and @done->waitq can contain something unrelated by the time
finish_writeback_work() tries to read it.  This led to the following
crash.

  "BUG: kernel NULL pointer dereference, address: 0000000000000002"
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0002) - not-present page
  PGD 0 P4D 0
  Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
  CPU: 40 PID: 555153 Comm: kworker/u98:50 Kdump: loaded Not tainted
  ...
  Workqueue: writeback wb_workfn (flush-btrfs-1)
  RIP: 0010:_raw_spin_lock_irqsave+0x10/0x30
  Code: 48 89 d8 5b c3 e8 50 db 6b ff eb f4 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 53 9c 5b fa 31 c0 ba 01 00 00 00 <f0> 0f b1 17 75 05 48 89 d8 5b c3 89 c6 e8 fe ca 6b ff eb f2 66 90
  RSP: 0018:ffffc90049b27d98 EFLAGS: 00010046
  RAX: 0000000000000000 RBX: 0000000000000246 RCX: 0000000000000000
  RDX: 0000000000000001 RSI: 0000000000000003 RDI: 0000000000000002
  RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
  R10: ffff889fff407600 R11: ffff88ba9395d740 R12: 000000000000e300
  R13: 0000000000000003 R14: 0000000000000000 R15: 0000000000000000
  FS:  0000000000000000(0000) GS:ffff88bfdfa00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000002 CR3: 0000000002409005 CR4: 00000000001606e0
  Call Trace:
   __wake_up_common_lock+0x63/0xc0
   wb_workfn+0xd2/0x3e0
   process_one_work+0x1f5/0x3f0
   worker_thread+0x2d/0x3d0
   kthread+0x111/0x130
   ret_from_fork+0x1f/0x30

Fix it by reading and caching @done->waitq before decrementing
@done->cnt.

Link: http://lkml.kernel.org/r/20190924010631.GH2233839@devbig004.ftw2.facebook.com
Fixes: 5b9cce4c7eb069 ("writeback: Generalize and expose wb_completion")
Signed-off-by: Tejun Heo <tj@kernel.org>
Debugged-by: Chris Mason <clm@fb.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>	[5.2+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/fs-writeback.c~writeback-fix-use-after-free-in-finish_writeback_work
+++ a/fs/fs-writeback.c
@@ -164,8 +164,13 @@ static void finish_writeback_work(struct
 
 	if (work->auto_free)
 		kfree(work);
-	if (done && atomic_dec_and_test(&done->cnt))
-		wake_up_all(done->waitq);
+	if (done) {
+		wait_queue_head_t *waitq = done->waitq;
+
+		/* @done can't be accessed after the following dec */
+		if (atomic_dec_and_test(&done->cnt))
+			wake_up_all(waitq);
+	}
 }
 
 static void wb_queue_work(struct bdi_writeback *wb,
_

Patches currently in -mm which might be from tj@kernel.org are

writeback-fix-use-after-free-in-finish_writeback_work.patch

