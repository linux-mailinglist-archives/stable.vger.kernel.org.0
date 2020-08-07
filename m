Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C38A23E72B
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 08:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgHGGRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 02:17:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGRS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Aug 2020 02:17:18 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A1E72177B;
        Fri,  7 Aug 2020 06:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781037;
        bh=Qt1PcoJNJQycui0r/yXB5pNj6s8z3BlaXbgYR0ObX4g=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LiR/rG0YPlk2vr+rAOhGWbsIYfsp/d+QouqBGOTjN/0bikSPNXa4wtLmX4p484Ti8
         02Gdk/S3ZZBOLON/Ef5FKAndMjSca3rXkiKWEGuyiuz5y+XofpWQFoeN+LOMWP1lu5
         U8REiVn21Xc0uldeDIg1O7HJDGKSq8ce8LA5OHG4=
Date:   Thu, 06 Aug 2020 23:17:16 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axboe@kernel.dk, hch@lst.de,
        jannh@google.com, keescook@chromium.org, linux-mm@kvack.org,
        luto@amacapital.net, mathieu.desnoyers@efficios.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com,
        peterz@infradead.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, will@kernel.org
Subject:  [patch 004/163] mm: fix kthread_use_mm() vs TLB
 invalidate
Message-ID: <20200807061716.0Q5HJvMJ8%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Avoid this by disabling IRQs across changing ->active_mm and
switch_mm().

Of the (SMP) architectures that have IPI based TLB invalidate:

  Alpha    - checks active_mm
  ARC      - ASID specific
  IA64     - checks active_mm
  MIPS     - ASID specific flush
  OpenRISC - shoots down world
  PARISC   - shoots down world
  SH       - ASID specific
  SPARC    - ASID specific
  x86      - N/A
  xtensa   - checks active_mm

So at the very least Alpha, IA64 and Xtensa are suspect.

On top of this, for scheduler consistency we need at least preemption
disabled across changing tsk->mm and doing switch_mm(), which is
currently provided by task_lock(), but that's not sufficient for
PREEMPT_RT.

[akpm@linux-foundation.org: add comment]
Link: http://lkml.kernel.org/r/20200721154106.GE10769@hirez.programming.kicks-ass.net
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reported-by: Andy Lutomirski <luto@amacapital.net>
Cc: Nicholas Piggin <npiggin@gmail.com>
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

 kernel/kthread.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/kernel/kthread.c~mm-fix-kthread_use_mm-vs-tlb-invalidate
+++ a/kernel/kthread.c
@@ -1241,13 +1241,16 @@ void kthread_use_mm(struct mm_struct *mm
 	WARN_ON_ONCE(tsk->mm);
 
 	task_lock(tsk);
+	/* Hold off tlb flush IPIs while switching mm's */
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
@@ -1276,9 +1279,11 @@ void kthread_unuse_mm(struct mm_struct *
 
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
