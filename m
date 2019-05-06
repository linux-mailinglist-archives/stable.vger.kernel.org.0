Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10F6E14DA4
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbfEFOrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:47:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727528AbfEFOrL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:47:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C67642087F;
        Mon,  6 May 2019 14:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557154030;
        bh=u6zsrgbc/lo1IdgqzPtxPGcokxb+8OIYqG41zIYwrbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nsdh32KBGbQrwXpeOK1cArqwdsGr0EJXaj5pkRr+YXK8B5wt4ax/LzQwpXix9zwJK
         j0s9bI9ongtjD3o5L7t3bX9u0MMVnXTvXYXJYKkFtDRWYxadwr7B8dYLhHaPKGOsY2
         BplUvJnAarl7TXu/4sc9oYRVzanDC8dbb88+tyOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Brian Gerst <brgerst@gmail.com>,
        Dave Jones <davej@codemonkey.org.uk>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Andrey Konovalov <andreyknvl@google.com>
Subject: [PATCH 4.9 12/62] x86/unwind: Disable KASAN checks for non-current tasks
Date:   Mon,  6 May 2019 16:32:43 +0200
Message-Id: <20190506143052.148955125@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143051.102535767@linuxfoundation.org>
References: <20190506143051.102535767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit 84936118bdf37bda513d4a361c38181a216427e0 upstream.

There are a handful of callers to save_stack_trace_tsk() and
show_stack() which try to unwind the stack of a task other than current.
In such cases, it's remotely possible that the task is running on one
CPU while the unwinder is reading its stack from another CPU, causing
the unwinder to see stack corruption.

These cases seem to be mostly harmless.  The unwinder has checks which
prevent it from following bad pointers beyond the bounds of the stack.
So it's not really a bug as long as the caller understands that
unwinding another task will not always succeed.

In such cases, it's possible that the unwinder may read a KASAN-poisoned
region of the stack.  Account for that by using READ_ONCE_NOCHECK() when
reading the stack of another task.

Use READ_ONCE() when reading the stack of the current task, since KASAN
warnings can still be useful for finding bugs in that case.

Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/4c575eb288ba9f73d498dfe0acde2f58674598f1.1483978430.git.jpoimboe@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/stacktrace.h |    5 ++++-
 arch/x86/kernel/unwind_frame.c    |   20 ++++++++++++++++++--
 2 files changed, 22 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/stacktrace.h
+++ b/arch/x86/include/asm/stacktrace.h
@@ -55,13 +55,16 @@ extern int kstack_depth_to_print;
 static inline unsigned long *
 get_frame_pointer(struct task_struct *task, struct pt_regs *regs)
 {
+	struct inactive_task_frame *frame;
+
 	if (regs)
 		return (unsigned long *)regs->bp;
 
 	if (task == current)
 		return __builtin_frame_address(0);
 
-	return (unsigned long *)((struct inactive_task_frame *)task->thread.sp)->bp;
+	frame = (struct inactive_task_frame *)task->thread.sp;
+	return (unsigned long *)READ_ONCE_NOCHECK(frame->bp);
 }
 #else
 static inline unsigned long *
--- a/arch/x86/kernel/unwind_frame.c
+++ b/arch/x86/kernel/unwind_frame.c
@@ -6,6 +6,21 @@
 
 #define FRAME_HEADER_SIZE (sizeof(long) * 2)
 
+/*
+ * This disables KASAN checking when reading a value from another task's stack,
+ * since the other task could be running on another CPU and could have poisoned
+ * the stack in the meantime.
+ */
+#define READ_ONCE_TASK_STACK(task, x)			\
+({							\
+	unsigned long val;				\
+	if (task == current)				\
+		val = READ_ONCE(x);			\
+	else						\
+		val = READ_ONCE_NOCHECK(x);		\
+	val;						\
+})
+
 unsigned long unwind_get_return_address(struct unwind_state *state)
 {
 	unsigned long addr;
@@ -14,7 +29,8 @@ unsigned long unwind_get_return_address(
 	if (unwind_done(state))
 		return 0;
 
-	addr = ftrace_graph_ret_addr(state->task, &state->graph_idx, *addr_p,
+	addr = READ_ONCE_TASK_STACK(state->task, *addr_p);
+	addr = ftrace_graph_ret_addr(state->task, &state->graph_idx, addr,
 				     addr_p);
 
 	return __kernel_text_address(addr) ? addr : 0;
@@ -48,7 +64,7 @@ bool unwind_next_frame(struct unwind_sta
 	if (unwind_done(state))
 		return false;
 
-	next_bp = (unsigned long *)*state->bp;
+	next_bp = (unsigned long *)READ_ONCE_TASK_STACK(state->task,*state->bp);
 
 	/* make sure the next frame's data is accessible */
 	if (!update_stack_state(state, next_bp, FRAME_HEADER_SIZE))


