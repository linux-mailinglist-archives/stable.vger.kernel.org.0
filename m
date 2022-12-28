Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01AAC658080
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbiL1QR6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:17:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234672AbiL1QRL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:17:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827AD1AD8D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:15:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32C1AB81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:15:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8630AC433D2;
        Wed, 28 Dec 2022 16:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244114;
        bh=xRj2zAE3lEOGlozonGI9PfAv12yBVV/t3FQ8OXG8rNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cEgrhxD6udTaqcNKp87ukC91kC/c8IWdkoSgm5LGIUW3Lr2XPNMI4rhFg62MP1g65
         xesu4BVdVtX+HJiQf24OZwswZrJ+krHxLLI0hBjN6ckghhIUtnbwwctc2mximmFTfb
         JfA7j8hRkCNpV31q7hUEm+RDuaDGDzio3j6Dy7Zc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrew Bresticker <abrestic@rivosinc.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0653/1073] RISC-V: Fix unannoted hardirqs-on in return to userspace slow-path
Date:   Wed, 28 Dec 2022 15:37:21 +0100
Message-Id: <20221228144345.783119307@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Bresticker <abrestic@rivosinc.com>

[ Upstream commit b0f4c74eadbf69a3298f38566bfaa2e202541f2f ]

The return to userspace path in entry.S may enable interrupts without the
corresponding lockdep annotation, producing a splat[0] when DEBUG_LOCKDEP
is enabled. Simply calling __trace_hardirqs_on() here gets a bit messy
due to the use of RA to point back to ret_from_exception, so just move
the whole slow-path loop into C. It's more readable and it lets us use
local_irq_{enable,disable}(), avoiding the need for manual annotations
altogether.

[0]:
  ------------[ cut here ]------------
  DEBUG_LOCKS_WARN_ON(!lockdep_hardirqs_enabled())
  WARNING: CPU: 2 PID: 1 at kernel/locking/lockdep.c:5512 check_flags+0x10a/0x1e0
  Modules linked in:
  CPU: 2 PID: 1 Comm: init Not tainted 6.1.0-rc4-00160-gb56b6e2b4f31 #53
  Hardware name: riscv-virtio,qemu (DT)
  epc : check_flags+0x10a/0x1e0
  ra : check_flags+0x10a/0x1e0
  <snip>
   status: 0000000200000100 badaddr: 0000000000000000 cause: 0000000000000003
  [<ffffffff808edb90>] lock_is_held_type+0x78/0x14e
  [<ffffffff8003dae2>] __might_resched+0x26/0x22c
  [<ffffffff8003dd24>] __might_sleep+0x3c/0x66
  [<ffffffff80022c60>] get_signal+0x9e/0xa70
  [<ffffffff800054a2>] do_notify_resume+0x6e/0x422
  [<ffffffff80003c68>] ret_from_exception+0x0/0x10
  irq event stamp: 44512
  hardirqs last  enabled at (44511): [<ffffffff808f901c>] _raw_spin_unlock_irqrestore+0x54/0x62
  hardirqs last disabled at (44512): [<ffffffff80008200>] __trace_hardirqs_off+0xc/0x14
  softirqs last  enabled at (44472): [<ffffffff808f9fbe>] __do_softirq+0x3de/0x51e
  softirqs last disabled at (44467): [<ffffffff80017760>] irq_exit+0xd6/0x104
  ---[ end trace 0000000000000000 ]---
  possible reason: unannotated irqs-on.

Signed-off-by: Andrew Bresticker <abrestic@rivosinc.com>
Fixes: 3c4697982982 ("riscv: Enable LOCKDEP_SUPPORT & fixup TRACE_IRQFLAGS_SUPPORT")
Link: https://lore.kernel.org/r/20221111223108.1976562-1-abrestic@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/entry.S  | 18 +++++-------------
 arch/riscv/kernel/signal.c | 34 +++++++++++++++++++++-------------
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index 186abd146eaf..3221a9e5f372 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -263,12 +263,11 @@ ret_from_exception:
 #endif
 	bnez s0, resume_kernel
 
-resume_userspace:
 	/* Interrupts must be disabled here so flags are checked atomically */
 	REG_L s0, TASK_TI_FLAGS(tp) /* current_thread_info->flags */
 	andi s1, s0, _TIF_WORK_MASK
-	bnez s1, work_pending
-
+	bnez s1, resume_userspace_slow
+resume_userspace:
 #ifdef CONFIG_CONTEXT_TRACKING_USER
 	call user_enter_callable
 #endif
@@ -368,19 +367,12 @@ resume_kernel:
 	j restore_all
 #endif
 
-work_pending:
+resume_userspace_slow:
 	/* Enter slow path for supplementary processing */
-	la ra, ret_from_exception
-	andi s1, s0, _TIF_NEED_RESCHED
-	bnez s1, work_resched
-work_notifysig:
-	/* Handle pending signals and notify-resume requests */
-	csrs CSR_STATUS, SR_IE /* Enable interrupts for do_notify_resume() */
 	move a0, sp /* pt_regs */
 	move a1, s0 /* current_thread_info->flags */
-	tail do_notify_resume
-work_resched:
-	tail schedule
+	call do_work_pending
+	j resume_userspace
 
 /* Slow paths for ptrace. */
 handle_syscall_trace_enter:
diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
index 5c591123c440..bfb2afa4135f 100644
--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -313,19 +313,27 @@ static void do_signal(struct pt_regs *regs)
 }
 
 /*
- * notification of userspace execution resumption
- * - triggered by the _TIF_WORK_MASK flags
+ * Handle any pending work on the resume-to-userspace path, as indicated by
+ * _TIF_WORK_MASK. Entered from assembly with IRQs off.
  */
-asmlinkage __visible void do_notify_resume(struct pt_regs *regs,
-					   unsigned long thread_info_flags)
+asmlinkage __visible void do_work_pending(struct pt_regs *regs,
+					  unsigned long thread_info_flags)
 {
-	if (thread_info_flags & _TIF_UPROBE)
-		uprobe_notify_resume(regs);
-
-	/* Handle pending signal delivery */
-	if (thread_info_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
-		do_signal(regs);
-
-	if (thread_info_flags & _TIF_NOTIFY_RESUME)
-		resume_user_mode_work(regs);
+	do {
+		if (thread_info_flags & _TIF_NEED_RESCHED) {
+			schedule();
+		} else {
+			local_irq_enable();
+			if (thread_info_flags & _TIF_UPROBE)
+				uprobe_notify_resume(regs);
+			/* Handle pending signal delivery */
+			if (thread_info_flags & (_TIF_SIGPENDING |
+						 _TIF_NOTIFY_SIGNAL))
+				do_signal(regs);
+			if (thread_info_flags & _TIF_NOTIFY_RESUME)
+				resume_user_mode_work(regs);
+		}
+		local_irq_disable();
+		thread_info_flags = read_thread_flags();
+	} while (thread_info_flags & _TIF_WORK_MASK);
 }
-- 
2.35.1



