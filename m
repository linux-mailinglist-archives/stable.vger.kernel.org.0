Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667C5228A55
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 23:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731041AbgGUVGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 17:06:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:58462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726658AbgGUVGz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jul 2020 17:06:55 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF4B220720;
        Tue, 21 Jul 2020 21:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595365614;
        bh=j88xDG5ZcNsXGw1qQwglXCQ1tuXFL/hEbx5gQSVtz2A=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Uq4/sKHVNiEdSL5MJ87IIheswTZyZqBdCSYJ4ypUzTfnNf0gx+EMJvHaJQ8i0AWCd
         vA9PSySnyjC51euNrx+2u2rlg5TsG2DTv6ukM/gg9X7LV4NXOaKLtjftzTLIvw7gFb
         49IEs5Moeit6HVuAWvD3Xq27RbgzCGx29uItEHYE=
Date:   Tue, 21 Jul 2020 14:06:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     axboe@kernel.dk, hch@lst.de, jannh@google.com,
        keescook@chromium.org, luto@amacapital.net,
        mathieu.desnoyers@efficios.com, mm-commits@vger.kernel.org,
        npiggin@gmail.com, peterz@infradead.org, stable@vger.kernel.org,
        will@kernel.org
Subject:  + mm-fix-kthread_use_mm-vs-tlb-invalidate.patch added to
 -mm tree
Message-ID: <20200721210653.mOWpKQDJQ%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: fix kthread_use_mm() vs TLB invalidate
has been added to the -mm tree.  Its filename is
     mm-fix-kthread_use_mm-vs-tlb-invalidate.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-kthread_use_mm-vs-tlb-invalidate.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-kthread_use_mm-vs-tlb-invalidate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Zijlstra <peterz@infradead.org>
Subject: mm: fix kthread_use_mm() vs TLB invalidate

For SMP systems using IPI based TLB invalidation, looking at
current->active_mm is entirely reasonable.  This then presents the
following race condition:

  CPU0			CPU1

  flush_tlb_mm(mm)	use_mm(mm)
    <send-IPI>
			  tsk->active_mm = mm;
			  <IPI>
			    if (tsk->active_mm == mm)
			      // flush TLBs
			  </IPI>
			  switch_mm(old_mm,mm,tsk);

Where it is possible the IPI flushed the TLBs for @old_mm, not @mm,
because the IPI lands before we actually switched.

Avoid this by disabling IRQs across changing ->active_mm and switch_mm().

[ There are all sorts of reasons this might be harmless for various
architecture specific reasons, but best not leave the door open at all.  ]

Link: http://lkml.kernel.org/r/20200721154106.GE10769@hirez.programming.kicks-ass.net
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reported-by: Andy Lutomirski <luto@amacapital.net>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Jann Horn <jannh@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/kthread.c~mm-fix-kthread_use_mm-vs-tlb-invalidate
+++ a/kernel/kthread.c
@@ -1239,13 +1239,15 @@ void kthread_use_mm(struct mm_struct *mm
 	WARN_ON_ONCE(tsk->mm);
 
 	task_lock(tsk);
+	local_irq_disable();
 	active_mm = tsk->active_mm;
 	if (active_mm != mm) {
 		mmgrab(mm);
 		tsk->active_mm = mm;
 	}
 	tsk->mm = mm;
-	switch_mm(active_mm, mm, tsk);
+	switch_mm_irqs_off(active_mm, mm, tsk);
+	local_irq_enable();
 	task_unlock(tsk);
 #ifdef finish_arch_post_lock_switch
 	finish_arch_post_lock_switch();
@@ -1274,9 +1276,11 @@ void kthread_unuse_mm(struct mm_struct *
 
 	task_lock(tsk);
 	sync_mm_rss(mm);
+	local_irq_disable();
 	tsk->mm = NULL;
 	/* active_mm is still 'mm' */
 	enter_lazy_tlb(mm, tsk);
+	local_irq_enable();
 	task_unlock(tsk);
 }
 EXPORT_SYMBOL_GPL(kthread_unuse_mm);
_

Patches currently in -mm which might be from peterz@infradead.org are

mm-fix-kthread_use_mm-vs-tlb-invalidate.patch

