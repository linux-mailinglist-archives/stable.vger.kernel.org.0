Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16F3A2E871
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 00:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbfE2Wpm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 18:45:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbfE2Wpm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 18:45:42 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D886B242AC;
        Wed, 29 May 2019 22:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559169941;
        bh=kHqOJImnqpdpCUI+iQlew1PvNxmv43AkjNiEJ40EiSI=;
        h=Date:From:To:Subject:From;
        b=eaCdcswvS8sBqT/5iuLVqmkvDwM0IhAsAvrhWktGvMYsubYDsqtGleSlIeN2vsBMW
         xhfYtJAS/xsmKPXoQ7kTkM8IXxFjN65zc5fYFpGHXFe083VrujdlkCLJFWUa0fizty
         fOtSMWfIU2Lu5mKSlR0OKPyZ+xb/QumeJnDyTRdE=
Date:   Wed, 29 May 2019 15:45:40 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        peterz@infradead.org, oleg@redhat.com, hch@lst.de, axboe@kernel.dk,
        akpm@linux-foundation.org, cai@lca.pw
Subject:  + mm-page_io-fix-a-crash-in-do_task_dead.patch added to -mm
 tree
Message-ID: <20190529224540.R3KdG%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/page_io.c: fix a crash in do_task_dead()
has been added to the -mm tree.  Its filename is
     mm-page_io-fix-a-crash-in-do_task_dead.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_io-fix-a-crash-in-do_task_dead.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_io-fix-a-crash-in-do_task_dead.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Qian Cai <cai@lca.pw>
Subject: mm/page_io.c: fix a crash in do_task_dead()

0619317ff8ba ("block: add polled wakeup task helper") replaced
wake_up_process() with blk_wake_io_task() in end_swap_bio_read() which
triggers a crash when running heavy swapping workloads.

[T114538] kernel BUG at kernel/sched/core.c:3462!
[T114538] Process oom01 (pid: 114538, stack limit = 0x000000004f40e0c1)
[T114538] Call trace:
[T114538]  do_task_dead+0xf0/0xf8
[T114538]  do_exit+0xd5c/0x10fc
[T114538]  do_group_exit+0xf4/0x110
[T114538]  get_signal+0x280/0xdd8
[T114538]  do_notify_resume+0x720/0x968
[T114538]  work_pending+0x8/0x10

This is because shortly after set_special_state(TASK_DEAD),
end_swap_bio_read() is called from an interrupt handler that revive the
task state to TASK_RUNNING causes __schedule() to return and trip the
BUG() later.

[  C206] Call trace:
[  C206]  dump_backtrace+0x0/0x268
[  C206]  show_stack+0x20/0x2c
[  C206]  dump_stack+0xb4/0x108
[  C206]  blk_wake_io_task+0x7c/0x80
[  C206]  end_swap_bio_read+0x22c/0x31c
[  C206]  bio_endio+0x3d8/0x414
[  C206]  dec_pending+0x280/0x378 [dm_mod]
[  C206]  clone_endio+0x128/0x2ac [dm_mod]
[  C206]  bio_endio+0x3d8/0x414
[  C206]  blk_update_request+0x3ac/0x924
[  C206]  scsi_end_request+0x54/0x350
[  C206]  scsi_io_completion+0xf0/0x6f4
[  C206]  scsi_finish_command+0x214/0x228
[  C206]  scsi_softirq_done+0x170/0x1a4
[  C206]  blk_done_softirq+0x100/0x194
[  C206]  __do_softirq+0x350/0x790
[  C206]  irq_exit+0x200/0x26c
[  C206]  handle_IPI+0x2e8/0x514
[  C206]  gic_handle_irq+0x224/0x228
[  C206]  el1_irq+0xb8/0x140
[  C206]  _raw_spin_unlock_irqrestore+0x3c/0x74
[  C206]  do_task_dead+0x88/0xf8
[  C206]  do_exit+0xd5c/0x10fc
[  C206]  do_group_exit+0xf4/0x110
[  C206]  get_signal+0x280/0xdd8
[  C206]  do_notify_resume+0x720/0x968
[  C206]  work_pending+0x8/0x10

Before the offensive commit, wake_up_process() will prevent this from
happening by taking the pi_lock and bail out immediately if TASK_DEAD is
set.

if (!(p->state & TASK_NORMAL))
	goto out;

Link: http://lkml.kernel.org/r/1559156813-30681-1-git-send-email-cai@lca.pw
Fixes: 0619317ff8ba ("block: add polled wakeup task helper")
Signed-off-by: Qian Cai <cai@lca.pw>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page_io.c~mm-page_io-fix-a-crash-in-do_task_dead
+++ a/mm/page_io.c
@@ -140,7 +140,8 @@ out:
 	unlock_page(page);
 	WRITE_ONCE(bio->bi_private, NULL);
 	bio_put(bio);
-	blk_wake_io_task(waiter);
+	/* end_swap_bio_read() could be called from an interrupt handler. */
+	wake_up_process(waiter);
 	put_task_struct(waiter);
 }
 
_

Patches currently in -mm which might be from cai@lca.pw are

iommu-intel-fix-variable-iommu-set-but-not-used.patch
mm-page_io-fix-a-crash-in-do_task_dead.patch

