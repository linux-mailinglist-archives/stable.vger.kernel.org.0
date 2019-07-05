Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 011C660BDB
	for <lists+stable@lfdr.de>; Fri,  5 Jul 2019 21:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbfGETrT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jul 2019 15:47:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:42204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726794AbfGETrS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jul 2019 15:47:18 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 961D92184C;
        Fri,  5 Jul 2019 19:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562356037;
        bh=8HHUDDlxiUaXAriGJ4NiAfv/lfoXp4QXbwAYy0bPg/4=;
        h=Date:From:To:Subject:From;
        b=nerpQLJ7LOUkHeoTFct/+c2GA9Cg3u0fIDxnVqkB1kX2/CzAYtJFPWmKjb6Ul6qOF
         AdpFqlGTusCLXbLQfog6mec+qwdv1coJ8+8fgGpekIzAe+pAPkybaELlzP+M02lxUM
         eZueniRJNV0AV1Ew6Gi/7vmsEp2xkA+UqC2eHnR8=
Date:   Fri, 05 Jul 2019 12:47:17 -0700
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, cai@lca.pw, hughd@google.com,
        mm-commits@vger.kernel.org, oleg@redhat.com, stable@vger.kernel.org
Subject:  [merged]
 swap_readpage-avoid-blk_wake_io_task-if-synchronous.patch removed from -mm
 tree
Message-ID: <20190705194717.l5LNsH5ii%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: swap_readpage(): avoid blk_wake_io_task() if !synchronous
has been removed from the -mm tree.  Its filename was
     swap_readpage-avoid-blk_wake_io_task-if-synchronous.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

signal-simplify-set_user_sigmask-restore_user_sigmask.patch
select-change-do_poll-to-return-erestartnohand-rather-than-eintr.patch
select-shift-restore_saved_sigmask_unless-into-poll_select_copy_remaining.patch
aio-simplify-read_events.patch

