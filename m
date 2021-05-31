Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3045B39618A
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbhEaOlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:41:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234194AbhEaOjh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:39:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6C4861C5E;
        Mon, 31 May 2021 13:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469177;
        bh=Y7gPqA2FJ85axZFS15qE4ple5UmOcKAzqJuaDpE6BSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dj/fZ5y0RmagtFpGQS0BUCJgvugIy743GMdXcDUXYEuxPNZWjr/CG1oOs3Pfu/9sc
         spMATJgakBbExBmNwGZ+QmQ3uCF21qqZ+cOO466LSI1AFAWqpNDAsaeohwiDat4Bjx
         rnJBNL+UhqYziFlGbXR3yNR8h0HzbONj90ElynJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Huang <chenhuang5@huawei.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.12 063/296] riscv: stacktrace: fix the riscv stacktrace when CONFIG_FRAME_POINTER enabled
Date:   Mon, 31 May 2021 15:11:58 +0200
Message-Id: <20210531130705.961214426@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Huang <chenhuang5@huawei.com>

commit eac2f3059e02382d91f8c887462083841d6ea2a3 upstream.

As [1] and [2] said, the arch_stack_walk should not to trace itself, or it will
leave the trace unexpectedly when called. The example is when we do "cat
/sys/kernel/debug/page_owner", all pages' stack is the same.

arch_stack_walk+0x18/0x20
stack_trace_save+0x40/0x60
register_dummy_stack+0x24/0x5e
init_page_owner+0x2e

So we use __builtin_frame_address(1) as the first frame to be walked. And mark
the arch_stack_walk() noinline.

We found that pr_cont will affact pages' stack whose task state is RUNNING when
testing "echo t > /proc/sysrq-trigger". So move the place of pr_cont and mark
the function dump_backtrace() noinline.

Also we move the case when task == NULL into else branch, and test for it in
"echo c > /proc/sysrq-trigger".

[1] https://lore.kernel.org/lkml/20210319184106.5688-1-mark.rutland@arm.com/
[2] https://lore.kernel.org/lkml/20210317142050.57712-1-chenjun102@huawei.com/

Signed-off-by: Chen Huang <chenhuang5@huawei.com>
Fixes: 5d8544e2d007 ("RISC-V: Generic library routines and assembly")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/stacktrace.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -27,10 +27,10 @@ void notrace walk_stackframe(struct task
 		fp = frame_pointer(regs);
 		sp = user_stack_pointer(regs);
 		pc = instruction_pointer(regs);
-	} else if (task == NULL || task == current) {
-		fp = (unsigned long)__builtin_frame_address(0);
-		sp = sp_in_global;
-		pc = (unsigned long)walk_stackframe;
+	} else if (task == current) {
+		fp = (unsigned long)__builtin_frame_address(1);
+		sp = (unsigned long)__builtin_frame_address(0);
+		pc = (unsigned long)__builtin_return_address(0);
 	} else {
 		/* task blocked in __switch_to */
 		fp = task->thread.s[0];
@@ -106,15 +106,15 @@ static bool print_trace_address(void *ar
 	return true;
 }
 
-void dump_backtrace(struct pt_regs *regs, struct task_struct *task,
+noinline void dump_backtrace(struct pt_regs *regs, struct task_struct *task,
 		    const char *loglvl)
 {
-	pr_cont("%sCall Trace:\n", loglvl);
 	walk_stackframe(task, regs, print_trace_address, (void *)loglvl);
 }
 
 void show_stack(struct task_struct *task, unsigned long *sp, const char *loglvl)
 {
+	pr_cont("%sCall Trace:\n", loglvl);
 	dump_backtrace(NULL, task, loglvl);
 }
 
@@ -139,7 +139,7 @@ unsigned long get_wchan(struct task_stru
 
 #ifdef CONFIG_STACKTRACE
 
-void arch_stack_walk(stack_trace_consume_fn consume_entry, void *cookie,
+noinline void arch_stack_walk(stack_trace_consume_fn consume_entry, void *cookie,
 		     struct task_struct *task, struct pt_regs *regs)
 {
 	walk_stackframe(task, regs, consume_entry, cookie);


