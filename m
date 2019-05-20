Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 856362335F
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732798AbfETMQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:16:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:56888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732794AbfETMQN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:16:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E92C20862;
        Mon, 20 May 2019 12:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354572;
        bh=hSBsjb0qBcj82K4Q4as66E42q3kuDe2ckcAVEud7e94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f4wrao6xPLWLrHsR1ptcdjSLujSlYkIbI1m0607WJlyZZKkjLJFYi3yqko2azmsRi
         PS1wcR0LsHpUwUyLcEZEE6ywiem95V/Zm06HvAC+rF22M5dJ3VIUieshacWa5bGzDO
         ukhqes/+gvJhF2hAJV93m6z/kKekTrZxe9EhBENI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julien Thierry <julien.thierry@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Borislav Petkov <bp@alien8.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.9 11/44] sched/x86: Save [ER]FLAGS on context switch
Date:   Mon, 20 May 2019 14:14:00 +0200
Message-Id: <20190520115232.329399629@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115230.720347034@linuxfoundation.org>
References: <20190520115230.720347034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 6690e86be83ac75832e461c141055b5d601c0a6d upstream.

Effectively reverts commit:

  2c7577a75837 ("sched/x86_64: Don't save flags on context switch")

Specifically because SMAP uses FLAGS.AC which invalidates the claim
that the kernel has clean flags.

In particular; while preemption from interrupt return is fine (the
IRET frame on the exception stack contains FLAGS) it breaks any code
that does synchonous scheduling, including preempt_enable().

This has become a significant issue ever since commit:

  5b24a7a2aa20 ("Add 'unsafe' user access functions for batched accesses")

provided for means of having 'normal' C code between STAC / CLAC,
exposing the FLAGS.AC state. So far this hasn't led to trouble,
however fix it before it comes apart.

Reported-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Andy Lutomirski <luto@amacapital.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@kernel.org
Fixes: 5b24a7a2aa20 ("Add 'unsafe' user access functions for batched accesses")
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/entry/entry_32.S        |    2 ++
 arch/x86/entry/entry_64.S        |    2 ++
 arch/x86/include/asm/switch_to.h |    1 +
 arch/x86/kernel/process_32.c     |    7 +++++++
 arch/x86/kernel/process_64.c     |    8 ++++++++
 5 files changed, 20 insertions(+)

--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -219,6 +219,7 @@ ENTRY(__switch_to_asm)
 	pushl	%ebx
 	pushl	%edi
 	pushl	%esi
+	pushfl
 
 	/* switch stack */
 	movl	%esp, TASK_threadsp(%eax)
@@ -241,6 +242,7 @@ ENTRY(__switch_to_asm)
 #endif
 
 	/* restore callee-saved registers */
+	popfl
 	popl	%esi
 	popl	%edi
 	popl	%ebx
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -313,6 +313,7 @@ ENTRY(__switch_to_asm)
 	pushq	%r13
 	pushq	%r14
 	pushq	%r15
+	pushfq
 
 	/* switch stack */
 	movq	%rsp, TASK_threadsp(%rdi)
@@ -335,6 +336,7 @@ ENTRY(__switch_to_asm)
 #endif
 
 	/* restore callee-saved registers */
+	popfq
 	popq	%r15
 	popq	%r14
 	popq	%r13
--- a/arch/x86/include/asm/switch_to.h
+++ b/arch/x86/include/asm/switch_to.h
@@ -35,6 +35,7 @@ asmlinkage void ret_from_fork(void);
 
 /* data that is pointed to by thread.sp */
 struct inactive_task_frame {
+	unsigned long flags;
 #ifdef CONFIG_X86_64
 	unsigned long r15;
 	unsigned long r14;
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -129,6 +129,13 @@ int copy_thread_tls(unsigned long clone_
 	struct task_struct *tsk;
 	int err;
 
+	/*
+	 * For a new task use the RESET flags value since there is no before.
+	 * All the status flags are zero; DF and all the system flags must also
+	 * be 0, specifically IF must be 0 because we context switch to the new
+	 * task with interrupts disabled.
+	 */
+	frame->flags = X86_EFLAGS_FIXED;
 	frame->bp = 0;
 	frame->ret_addr = (unsigned long) ret_from_fork;
 	p->thread.sp = (unsigned long) fork_frame;
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -268,6 +268,14 @@ int copy_thread_tls(unsigned long clone_
 	childregs = task_pt_regs(p);
 	fork_frame = container_of(childregs, struct fork_frame, regs);
 	frame = &fork_frame->frame;
+
+	/*
+	 * For a new task use the RESET flags value since there is no before.
+	 * All the status flags are zero; DF and all the system flags must also
+	 * be 0, specifically IF must be 0 because we context switch to the new
+	 * task with interrupts disabled.
+	 */
+	frame->flags = X86_EFLAGS_FIXED;
 	frame->bp = 0;
 	frame->ret_addr = (unsigned long) ret_from_fork;
 	p->thread.sp = (unsigned long) fork_frame;


