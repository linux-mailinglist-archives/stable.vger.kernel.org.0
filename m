Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F323C4AF6
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237996AbhGLGzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:55:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239786AbhGLGxC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:53:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE83E6102A;
        Mon, 12 Jul 2021 06:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072614;
        bh=E7ge9jQPZTI8Uszon43XeG9uOEHm12g6HwZhkqYgS8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yq/h7al/QAbCU4xr19FTfKXS9wiu8IRNczK/ZfhRANI6BaADEk653aXSL7r/Y22Wn
         InzKyJ6t7VQm07VaYqKB5GaJUunajqi9esulock79JqZfSxKQyJ47kGAjsHLLewYVz
         xCqcHLTId8i1BdfoBesCRl9+FE70SKlqoXIEKljs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 555/593] powerpc/64s: Fix copy-paste data exposure into newly created tasks
Date:   Mon, 12 Jul 2021 08:11:55 +0200
Message-Id: <20210712060955.528351398@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit f35d2f249ef05b9671e7898f09ad89aa78f99122 ]

copy-paste contains implicit "copy buffer" state that can contain
arbitrary user data (if the user process executes a copy instruction).
This could be snooped by another process if a context switch hits while
the state is live. So cp_abort is executed on context switch to clear
out possible sensitive data and prevent the leak.

cp_abort is done after the low level _switch(), which means it is never
reached by newly created tasks, so they could snoop on this buffer
between their first and second context switch.

Fix this by doing the cp_abort before calling _switch. Add some
comments which should make the issue harder to miss.

Fixes: 07d2a628bc000 ("powerpc/64s: Avoid cpabort in context switch when possible")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210622053036.474678-1-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/process.c | 48 +++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 1a1d2657fe8d..3064694afea1 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1227,6 +1227,19 @@ struct task_struct *__switch_to(struct task_struct *prev,
 			__flush_tlb_pending(batch);
 		batch->active = 0;
 	}
+
+	/*
+	 * On POWER9 the copy-paste buffer can only paste into
+	 * foreign real addresses, so unprivileged processes can not
+	 * see the data or use it in any way unless they have
+	 * foreign real mappings. If the new process has the foreign
+	 * real address mappings, we must issue a cp_abort to clear
+	 * any state and prevent snooping, corruption or a covert
+	 * channel. ISA v3.1 supports paste into local memory.
+	 */
+	if (new->mm && (cpu_has_feature(CPU_FTR_ARCH_31) ||
+			atomic_read(&new->mm->context.vas_windows)))
+		asm volatile(PPC_CP_ABORT);
 #endif /* CONFIG_PPC_BOOK3S_64 */
 
 #ifdef CONFIG_PPC_ADV_DEBUG_REGS
@@ -1272,30 +1285,33 @@ struct task_struct *__switch_to(struct task_struct *prev,
 
 	last = _switch(old_thread, new_thread);
 
+	/*
+	 * Nothing after _switch will be run for newly created tasks,
+	 * because they switch directly to ret_from_fork/ret_from_kernel_thread
+	 * etc. Code added here should have a comment explaining why that is
+	 * okay.
+	 */
+
 #ifdef CONFIG_PPC_BOOK3S_64
+	/*
+	 * This applies to a process that was context switched while inside
+	 * arch_enter_lazy_mmu_mode(), to re-activate the batch that was
+	 * deactivated above, before _switch(). This will never be the case
+	 * for new tasks.
+	 */
 	if (current_thread_info()->local_flags & _TLF_LAZY_MMU) {
 		current_thread_info()->local_flags &= ~_TLF_LAZY_MMU;
 		batch = this_cpu_ptr(&ppc64_tlb_batch);
 		batch->active = 1;
 	}
 
-	if (current->thread.regs) {
+	/*
+	 * Math facilities are masked out of the child MSR in copy_thread.
+	 * A new task does not need to restore_math because it will
+	 * demand fault them.
+	 */
+	if (current->thread.regs)
 		restore_math(current->thread.regs);
-
-		/*
-		 * On POWER9 the copy-paste buffer can only paste into
-		 * foreign real addresses, so unprivileged processes can not
-		 * see the data or use it in any way unless they have
-		 * foreign real mappings. If the new process has the foreign
-		 * real address mappings, we must issue a cp_abort to clear
-		 * any state and prevent snooping, corruption or a covert
-		 * channel. ISA v3.1 supports paste into local memory.
-		 */
-		if (current->mm &&
-			(cpu_has_feature(CPU_FTR_ARCH_31) ||
-			atomic_read(&current->mm->context.vas_windows)))
-			asm volatile(PPC_CP_ABORT);
-	}
 #endif /* CONFIG_PPC_BOOK3S_64 */
 
 	return last;
-- 
2.30.2



