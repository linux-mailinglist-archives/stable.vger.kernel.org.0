Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 050D5233EF
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387413AbfETMV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:21:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387506AbfETMV2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:21:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC9D5213F2;
        Mon, 20 May 2019 12:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354887;
        bh=JDbR6yD0S0b+vjlwwNjCZXrruQmzJ3nnstiZDzZHZ2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eGl1M/jFDYoS13k/JyBENb8W+N0vVcwEVZ0NTEbcOzJlz2dlF54P2eNpB+ZwrImNx
         SGKyWMOKht3850Pz6ccOwf2FK6zhMxYjdmsNIfsDGIuCa9NhhnRwxSVgeH0Yydnegb
         y8XJQQyrnoatsE9dCYZqD8ha6BumoJn9jgehd1BE=
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
Subject: [PATCH 4.19 017/105] sched/x86: Save [ER]FLAGS on context switch
Date:   Mon, 20 May 2019 14:13:23 +0200
Message-Id: <20190520115248.202554691@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
References: <20190520115247.060821231@linuxfoundation.org>
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
@@ -648,6 +648,7 @@ ENTRY(__switch_to_asm)
 	pushl	%ebx
 	pushl	%edi
 	pushl	%esi
+	pushfl
 
 	/* switch stack */
 	movl	%esp, TASK_threadsp(%eax)
@@ -670,6 +671,7 @@ ENTRY(__switch_to_asm)
 #endif
 
 	/* restore callee-saved registers */
+	popfl
 	popl	%esi
 	popl	%edi
 	popl	%ebx
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -352,6 +352,7 @@ ENTRY(__switch_to_asm)
 	pushq	%r13
 	pushq	%r14
 	pushq	%r15
+	pushfq
 
 	/* switch stack */
 	movq	%rsp, TASK_threadsp(%rdi)
@@ -374,6 +375,7 @@ ENTRY(__switch_to_asm)
 #endif
 
 	/* restore callee-saved registers */
+	popfq
 	popq	%r15
 	popq	%r14
 	popq	%r13
--- a/arch/x86/include/asm/switch_to.h
+++ b/arch/x86/include/asm/switch_to.h
@@ -40,6 +40,7 @@ asmlinkage void ret_from_fork(void);
  * order of the fields must match the code in __switch_to_asm().
  */
 struct inactive_task_frame {
+	unsigned long flags;
 #ifdef CONFIG_X86_64
 	unsigned long r15;
 	unsigned long r14;
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -130,6 +130,13 @@ int copy_thread_tls(unsigned long clone_
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
@@ -300,6 +300,14 @@ int copy_thread_tls(unsigned long clone_
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


