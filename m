Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C1E2A57AE
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732360AbgKCVpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:45:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:51656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732367AbgKCUxe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:53:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 600BC223AC;
        Tue,  3 Nov 2020 20:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436813;
        bh=f0Gbn9jbJqxfQbUcd7yt9h1zWmYOK/yFEO9uOh39WtA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nvIfjH3Elgn5Ma1GY7fOzVgEdJgPvOAjcVEk8DahveWSjSGeoYRVjTI2ExSx/N2uR
         yNQcL+nRou7J3xwwhxQJ4WuoWsQDjOfKBPA30UGQcJyw8Nh1rXiRDJ+0MesArZd16m
         bA369D/XabXKvN2ZbtMreMLO5hZUQZWyaYHGYBxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 022/214] mm: fix exec activate_mm vs TLB shootdown and lazy tlb switching race
Date:   Tue,  3 Nov 2020 21:34:30 +0100
Message-Id: <20201103203252.045316664@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit d53c3dfb23c45f7d4f910c3a3ca84bf0a99c6143 ]

Reading and modifying current->mm and current->active_mm and switching
mm should be done with irqs off, to prevent races seeing an intermediate
state.

This is similar to commit 38cf307c1f20 ("mm: fix kthread_use_mm() vs TLB
invalidate"). At exec-time when the new mm is activated, the old one
should usually be single-threaded and no longer used, unless something
else is holding an mm_users reference (which may be possible).

Absent other mm_users, there is also a race with preemption and lazy tlb
switching. Consider the kernel_execve case where the current thread is
using a lazy tlb active mm:

  call_usermodehelper()
    kernel_execve()
      old_mm = current->mm;
      active_mm = current->active_mm;
      *** preempt *** -------------------->  schedule()
                                               prev->active_mm = NULL;
                                               mmdrop(prev active_mm);
                                             ...
                      <--------------------  schedule()
      current->mm = mm;
      current->active_mm = mm;
      if (!old_mm)
          mmdrop(active_mm);

If we switch back to the kernel thread from a different mm, there is a
double free of the old active_mm, and a missing free of the new one.

Closing this race only requires interrupts to be disabled while ->mm
and ->active_mm are being switched, but the TLB problem requires also
holding interrupts off over activate_mm. Unfortunately not all archs
can do that yet, e.g., arm defers the switch if irqs are disabled and
expects finish_arch_post_lock_switch() to be called to complete the
flush; um takes a blocking lock in activate_mm().

So as a first step, disable interrupts across the mm/active_mm updates
to close the lazy tlb preempt race, and provide an arch option to
extend that to activate_mm which allows architectures doing IPI based
TLB shootdowns to close the second race.

This is a bit ugly, but in the interest of fixing the bug and backporting
before all architectures are converted this is a compromise.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200914045219.3736466-2-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/Kconfig |  7 +++++++
 fs/exec.c    | 17 +++++++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 238dccfa76910..84653a823d3b0 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -405,6 +405,13 @@ config MMU_GATHER_NO_RANGE
 config HAVE_MMU_GATHER_NO_GATHER
 	bool
 
+config ARCH_WANT_IRQS_OFF_ACTIVATE_MM
+	bool
+	help
+	  Temporary select until all architectures can be converted to have
+	  irqs disabled over activate_mm. Architectures that do IPI based TLB
+	  shootdowns should enable this.
+
 config ARCH_HAVE_NMI_SAFE_CMPXCHG
 	bool
 
diff --git a/fs/exec.c b/fs/exec.c
index de833553ae27d..2441eb1a1e2d0 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1044,11 +1044,24 @@ static int exec_mmap(struct mm_struct *mm)
 	}
 
 	task_lock(tsk);
-	active_mm = tsk->active_mm;
 	membarrier_exec_mmap(mm);
-	tsk->mm = mm;
+
+	local_irq_disable();
+	active_mm = tsk->active_mm;
 	tsk->active_mm = mm;
+	tsk->mm = mm;
+	/*
+	 * This prevents preemption while active_mm is being loaded and
+	 * it and mm are being updated, which could cause problems for
+	 * lazy tlb mm refcounting when these are updated by context
+	 * switches. Not all architectures can handle irqs off over
+	 * activate_mm yet.
+	 */
+	if (!IS_ENABLED(CONFIG_ARCH_WANT_IRQS_OFF_ACTIVATE_MM))
+		local_irq_enable();
 	activate_mm(active_mm, mm);
+	if (IS_ENABLED(CONFIG_ARCH_WANT_IRQS_OFF_ACTIVATE_MM))
+		local_irq_enable();
 	tsk->mm->vmacache_seqnum = 0;
 	vmacache_flush(tsk);
 	task_unlock(tsk);
-- 
2.27.0



