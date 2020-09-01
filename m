Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6942593B9
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730579AbgIAPaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:30:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:59774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730573AbgIAP3z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:29:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55FAB206C0;
        Tue,  1 Sep 2020 15:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974194;
        bh=R6W6fnSTZ1QTJue7Um2IqVtxneaYMRCI+li5qnZYrcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQpTy3SRivpUmlq9Sh5g8djRHfKSv1C1F9lvIkUehyv0xMc7BKW3FATMmJhGOm/km
         Gldm2wWt1vak3CUqksb1fpjg7sh93SVqPHwb3Z0kcIGUCUQzDGNIPjFVMgh5L446J0
         k9ZnV4kWyeyNOufJU4TZx/jwHr6bSG+3TGNYFUds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>, Will Deacon <will@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 081/214] mm: fix kthread_use_mm() vs TLB invalidate
Date:   Tue,  1 Sep 2020 17:09:21 +0200
Message-Id: <20200901150956.873446830@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 38cf307c1f2011d413750c5acb725456f47d9172 ]

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

Reported-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Jann Horn <jannh@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200721154106.GE10769@hirez.programming.kicks-ass.net
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mmu_context.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/mmu_context.c b/mm/mmu_context.c
index 3e612ae748e96..a1da47e027479 100644
--- a/mm/mmu_context.c
+++ b/mm/mmu_context.c
@@ -25,13 +25,16 @@ void use_mm(struct mm_struct *mm)
 	struct task_struct *tsk = current;
 
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
@@ -56,9 +59,11 @@ void unuse_mm(struct mm_struct *mm)
 
 	task_lock(tsk);
 	sync_mm_rss(mm);
+	local_irq_disable();
 	tsk->mm = NULL;
 	/* active_mm is still 'mm' */
 	enter_lazy_tlb(mm, tsk);
+	local_irq_enable();
 	task_unlock(tsk);
 }
 EXPORT_SYMBOL_GPL(unuse_mm);
-- 
2.25.1



