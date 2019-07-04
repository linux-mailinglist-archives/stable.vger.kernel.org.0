Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 257E05FD71
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 21:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbfGDTdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 15:33:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:52232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726844AbfGDTdV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Jul 2019 15:33:21 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B74C82189E;
        Thu,  4 Jul 2019 19:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562268800;
        bh=PNBbeHTik+dSN7ZvGJR3BYBhQUoIdzSeJ4xiTPAseTM=;
        h=Date:From:To:Subject:From;
        b=zWWepHx5IyD/fATx1VYmYvzPYxlqrsj7+bN3JVqrzLQP10cNzGC68mvklmHV5VQSu
         mNkWcmM8tdHaGyx59SXy87o+O6Lzjxn0cgCJ9u5pRUGhoh8FKSgdLLgUAOWTWNTku2
         l/K9ufOZuBJjmRCXkLqfGLKaHtXyjbKZNmF7VNlY=
Date:   Thu, 04 Jul 2019 12:33:19 -0700
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, cai@lca.pw, hughd@google.com,
        mm-commits@vger.kernel.org, oleg@redhat.com, stable@vger.kernel.org
Subject:  +
 swap_readpage-avoid-blk_wake_io_task-if-synchronous.patch added to -mm tree
Message-ID: <20190704193319.dhWFBjHg5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: swap_readpage(): avoid blk_wake_io_task() if !synchronous
has been added to the -mm tree.  Its filename is
     swap_readpage-avoid-blk_wake_io_task-if-synchronous.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/swap_readpage-avoid-blk_wake_io_task-if-synchronous.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/swap_readpage-avoid-blk_wake_io_task-if-synchronous.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: swap_readpage(): avoid blk_wake_io_task() if !synchronous

swap_readpage() sets waiter = bio->bi_private even if synchronous = F,
this means that the caller can get the spurious wakeup after return.  This
can be fatal if blk_wake_io_task() does set_current_state(TASK_RUNNING)
after the caller does set_special_state(), in the worst case the kernel
can crash in do_task_dead().

Link: http://lkml.kernel.org/r/20190704160301.GA5956@redhat.com
Fixes: 0619317ff8baa2d ("block: add polled wakeup task helper")
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Qian Cai <cai@lca.pw>
Acked-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/page_io.c~swap_readpage-avoid-blk_wake_io_task-if-synchronous
+++ a/mm/page_io.c
@@ -137,8 +137,10 @@ out:
 	unlock_page(page);
 	WRITE_ONCE(bio->bi_private, NULL);
 	bio_put(bio);
-	blk_wake_io_task(waiter);
-	put_task_struct(waiter);
+	if (waiter) {
+		blk_wake_io_task(waiter);
+		put_task_struct(waiter);
+	}
 }
 
 int generic_swapfile_activate(struct swap_info_struct *sis,
@@ -395,11 +397,12 @@ int swap_readpage(struct page *page, boo
 	 * Keep this task valid during swap readpage because the oom killer may
 	 * attempt to access it in the page fault retry time check.
 	 */
-	get_task_struct(current);
-	bio->bi_private = current;
 	bio_set_op_attrs(bio, REQ_OP_READ, 0);
-	if (synchronous)
+	if (synchronous) {
 		bio->bi_opf |= REQ_HIPRI;
+		get_task_struct(current);
+		bio->bi_private = current;
+	}
 	count_vm_event(PSWPIN);
 	bio_get(bio);
 	qc = submit_bio(bio);
_

Patches currently in -mm which might be from oleg@redhat.com are

swap_readpage-avoid-blk_wake_io_task-if-synchronous.patch
signal-simplify-set_user_sigmask-restore_user_sigmask.patch
select-change-do_poll-to-return-erestartnohand-rather-than-eintr.patch
select-shift-restore_saved_sigmask_unless-into-poll_select_copy_remaining.patch
aio-simplify-read_events.patch

