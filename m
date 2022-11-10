Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEFC6246AB
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 17:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiKJQOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 11:14:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbiKJQOg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 11:14:36 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A4AEE0A;
        Thu, 10 Nov 2022 08:14:35 -0800 (PST)
Date:   Thu, 10 Nov 2022 16:14:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1668096873;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qqUz/+ZIm84a5MGcesgiYEEHMgajdSK9pGpAekBbKYs=;
        b=LV2HHKg6XAO4C166KK4EmouHK9tldM9DHcLrVLaQnbVsAfnNNXLhWw5LUPwrlMxDW0ECAn
        XpEO/3OF9jQL9S5/6W+ejOq3J7cgnDWJkq6gwrIVtPdK2DyD272a6CsGLeg3hyC7Gja3Oa
        QQDIDNPhMPk1D4wuwvdKTownZHPssXA5/FkiC7fERbJ09mnfIORW3OEOOBWGGOlvqQJdPW
        HHTNGcNAWHxD2bKZEglL0aPLxHMwXcEVpUczchNG9qDa3FikBxU5rem46nP5I10lNj8X+l
        pbb26xlKnDiuQS20lV9AckjFD6gVkYkp/O65Sm4hXaJRFy4tcb2ft9aXKBY/QA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1668096873;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qqUz/+ZIm84a5MGcesgiYEEHMgajdSK9pGpAekBbKYs=;
        b=QuwqpX568h8yWO/HVgMJaAs8olnVLnX6xJrxSqEMAdtO8rZq1NKTUJlBTdQY3Q8tWYe5Nx
        ov1Y0/wsitzTmbBw==
From:   "tip-bot2 for Mel Gorman" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/fpu: Drop fpregs lock before inheriting FPU permissions
Cc:     Mike Galbraith <efault@gmx.de>,
        Mel Gorman <mgorman@techsingularity.net>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>, <stable@vger.kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20221110124400.zgymc2lnwqjukgfh@techsingularity.net>
References: <20221110124400.zgymc2lnwqjukgfh@techsingularity.net>
MIME-Version: 1.0
Message-ID: <166809687209.4906.5542537765622302733.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     36b038791e1e2baea892e9276588815fd14894b4
Gitweb:        https://git.kernel.org/tip/36b038791e1e2baea892e9276588815fd14894b4
Author:        Mel Gorman <mgorman@techsingularity.net>
AuthorDate:    Thu, 10 Nov 2022 12:44:00 
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Thu, 10 Nov 2022 16:57:38 +01:00

x86/fpu: Drop fpregs lock before inheriting FPU permissions

Mike Galbraith reported the following against an old fork of preempt-rt
but the same issue also applies to the current preempt-rt tree.

   BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:46
   in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1, name: systemd
   preempt_count: 1, expected: 0
   RCU nest depth: 0, expected: 0
   Preemption disabled at:
   fpu_clone
   CPU: 6 PID: 1 Comm: systemd Tainted: G            E       (unreleased)
   Call Trace:
    <TASK>
    dump_stack_lvl
    ? fpu_clone
    __might_resched
    rt_spin_lock
    fpu_clone
    ? copy_thread
    ? copy_process
    ? shmem_alloc_inode
    ? kmem_cache_alloc
    ? kernel_clone
    ? __do_sys_clone
    ? do_syscall_64
    ? __x64_sys_rt_sigprocmask
    ? syscall_exit_to_user_mode
    ? do_syscall_64
    ? syscall_exit_to_user_mode
    ? do_syscall_64
    ? syscall_exit_to_user_mode
    ? do_syscall_64
    ? exc_page_fault
    ? entry_SYSCALL_64_after_hwframe
    </TASK>

Mike says:

  The splat comes from fpu_inherit_perms() being called under fpregs_lock(),
  and us reaching the spin_lock_irq() therein due to fpu_state_size_dynamic()
  returning true despite static key __fpu_state_size_dynamic having never
  been enabled.

Mike's assessment looks correct. fpregs_lock on a PREEMPT_RT kernel disables
preemption so calling spin_lock_irq() in fpu_inherit_perms() is unsafe. This
problem exists since commit

  9e798e9aa14c ("x86/fpu: Prepare fpu_clone() for dynamically enabled features").

Even though the original bug report should not have enabled the paths at
all, the bug still exists.

fpregs_lock is necessary when editing the FPU registers or a task's FP
state but it is not necessary for fpu_inherit_perms(). The only write
of any FP state in fpu_inherit_perms() is for the new child which is
not running yet and cannot context switch or be borrowed by a kernel
thread yet. Hence, fpregs_lock is not protecting anything in the new
child until clone() completes and can be dropped earlier. The siglock
still needs to be acquired by fpu_inherit_perms() as the read of the
parent's permissions has to be serialised.

  [ bp: Cleanup splat. ]

Fixes: 9e798e9aa14c ("x86/fpu: Prepare fpu_clone() for dynamically enabled features")
Reported-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221110124400.zgymc2lnwqjukgfh@techsingularity.net
---
 arch/x86/kernel/fpu/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 3b28c5b..d00db56 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -605,9 +605,9 @@ int fpu_clone(struct task_struct *dst, unsigned long clone_flags, bool minimal)
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
 		fpregs_restore_userregs();
 	save_fpregs_to_fpstate(dst_fpu);
+	fpregs_unlock();
 	if (!(clone_flags & CLONE_THREAD))
 		fpu_inherit_perms(dst_fpu);
-	fpregs_unlock();
 
 	/*
 	 * Children never inherit PASID state.
