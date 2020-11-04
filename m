Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8482D2A5B9F
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 02:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730176AbgKDBOS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 20:14:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729144AbgKDBOS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 20:14:18 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB2BC040203;
        Tue,  3 Nov 2020 17:14:17 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4CQpZv09RBz9sT6; Wed,  4 Nov 2020 12:14:14 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1604452455;
        bh=L9+aN6uN2wgac4rv/jHRrYhBNqmampUYZI4+b+mvtBY=;
        h=From:To:Cc:Subject:Date:From;
        b=ibXCrtZzs7jfeUQi/EC7Dj82Al1W+o0KGfOhSNW+CvlQ7SP5aW0R67XglvUj1o/+u
         l5sQxbrX5SdrAtw4IlYSUJHPScXYDgY98UtKip7Yg901AA1OBcdfnz4GdeoXTNjV6x
         YARGmI6w+xg9i/zBM2cHwdp1xBLH69fptx4KSJzWgzX3yUe26LFiXaaCikYTJjrD3L
         w40EWyAGHEZwilJvm//WEZiEJ0o6l5HsAEpEDa5dOBhXNTYl0haYAGpRLgyc7ibi29
         6H8Vk7am17V1ytAnGeZwyNm+N3luO+ge6TDMxjn6d0/podAJGNzMgL4feNCfzg0/gf
         /t6LnuL2wJIJQ==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     stable@vger.kernel.org
Cc:     linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        npiggin@gmail.com, gregkh@linuxfoundation.org, peterz@infradead.org
Subject: [PATCH 4.19] mm: fix exec activate_mm vs TLB shootdown and lazy tlb switching race
Date:   Wed,  4 Nov 2020 12:14:06 +1100
Message-Id: <20201104011406.598487-1-mpe@ellerman.id.au>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

commit d53c3dfb23c45f7d4f910c3a3ca84bf0a99c6143 upstream.

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
[mpe: Manual backport to 4.19 due to membarrier_exec_mmap(mm) changes]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200914045219.3736466-2-npiggin@gmail.com
---
 arch/Kconfig |  7 +++++++
 fs/exec.c    | 15 ++++++++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index a336548487e6..e3a030f7a722 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -366,6 +366,13 @@ config HAVE_RCU_TABLE_FREE
 config HAVE_RCU_TABLE_INVALIDATE
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
index cece8c14f377..52788644c4af 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1028,10 +1028,23 @@ static int exec_mmap(struct mm_struct *mm)
 		}
 	}
 	task_lock(tsk);
+
+	local_irq_disable();
 	active_mm = tsk->active_mm;
-	tsk->mm = mm;
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
2.25.1

