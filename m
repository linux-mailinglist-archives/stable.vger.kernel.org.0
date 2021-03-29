Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F85634C82B
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233289AbhC2IUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:20:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233305AbhC2ITo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:19:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A980461601;
        Mon, 29 Mar 2021 08:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005984;
        bh=kqLmg3L6lM80tubfHMERXklbLXUxYHXEpWR/kI0I+q0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bDv5HsHLe4E1VQlqI1Fo/VzTVOkBhmqE++fE9Y+AqmqlxhR4leQ3z+10zdVexg7fe
         VG7YTHIB0gaosgwiFhsMK9/intsFhdBCEA+jpboBoD8IgDZhPbGnEYRU+mFUOytVZ0
         lKSbxRiirjtvU7vzVsuF1gWCDYx//FKYlfuHx0+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chen Jun <chenjun102@huawei.com>,
        Marco Elver <elver@google.com>,
        Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>
Subject: [PATCH 5.10 076/221] arm64: stacktrace: dont trace arch_stack_walk()
Date:   Mon, 29 Mar 2021 09:56:47 +0200
Message-Id: <20210329075631.725217944@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

commit c607ab4f916d4d5259072eca34055d3f5a795c21 upstream.

We recently converted arm64 to use arch_stack_walk() in commit:

  5fc57df2f6fd ("arm64: stacktrace: Convert to ARCH_STACKWALK")

The core stacktrace code expects that (when tracing the current task)
arch_stack_walk() starts a trace at its caller, and does not include
itself in the trace. However, arm64's arch_stack_walk() includes itself,
and so traces include one more entry than callers expect. The core
stacktrace code which calls arch_stack_walk() tries to skip a number of
entries to prevent itself appearing in a trace, and the additional entry
prevents skipping one of the core stacktrace functions, leaving this in
the trace unexpectedly.

We can fix this by having arm64's arch_stack_walk() begin the trace with
its caller. The first value returned by the trace will be
__builtin_return_address(0), i.e. the caller of arch_stack_walk(). The
first frame record to be unwound will be __builtin_frame_address(1),
i.e. the caller's frame record. To prevent surprises, arch_stack_walk()
is also marked noinline.

While __builtin_frame_address(1) is not safe in portable code, local GCC
developers have confirmed that it is safe on arm64. To find the caller's
frame record, the builtin can safely dereference the current function's
frame record or (in theory) could stash the original FP into another GPR
at function entry time, neither of which are problematic.

Prior to this patch, the tracing code would unexpectedly show up in
traces of the current task, e.g.

| # cat /proc/self/stack
| [<0>] stack_trace_save_tsk+0x98/0x100
| [<0>] proc_pid_stack+0xb4/0x130
| [<0>] proc_single_show+0x60/0x110
| [<0>] seq_read_iter+0x230/0x4d0
| [<0>] seq_read+0xdc/0x130
| [<0>] vfs_read+0xac/0x1e0
| [<0>] ksys_read+0x6c/0xfc
| [<0>] __arm64_sys_read+0x20/0x30
| [<0>] el0_svc_common.constprop.0+0x60/0x120
| [<0>] do_el0_svc+0x24/0x90
| [<0>] el0_svc+0x2c/0x54
| [<0>] el0_sync_handler+0x1a4/0x1b0
| [<0>] el0_sync+0x170/0x180

After this patch, the tracing code will not show up in such traces:

| # cat /proc/self/stack
| [<0>] proc_pid_stack+0xb4/0x130
| [<0>] proc_single_show+0x60/0x110
| [<0>] seq_read_iter+0x230/0x4d0
| [<0>] seq_read+0xdc/0x130
| [<0>] vfs_read+0xac/0x1e0
| [<0>] ksys_read+0x6c/0xfc
| [<0>] __arm64_sys_read+0x20/0x30
| [<0>] el0_svc_common.constprop.0+0x60/0x120
| [<0>] do_el0_svc+0x24/0x90
| [<0>] el0_svc+0x2c/0x54
| [<0>] el0_sync_handler+0x1a4/0x1b0
| [<0>] el0_sync+0x170/0x180

Erring on the side of caution, I've given this a spin with a bunch of
toolchains, verifying the output of /proc/self/stack and checking that
the assembly looked sound. For GCC (where we require version 5.1.0 or
later) I tested with the kernel.org crosstool binares for versions
5.5.0, 6.4.0, 6.5.0, 7.3.0, 7.5.0, 8.1.0, 8.3.0, 8.4.0, 9.2.0, and
10.1.0. For clang (where we require version 10.0.1 or later) I tested
with the llvm.org binary releases of 11.0.0, and 11.0.1.

Fixes: 5fc57df2f6fd ("arm64: stacktrace: Convert to ARCH_STACKWALK")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen Jun <chenjun102@huawei.com>
Cc: Marco Elver <elver@google.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org> # 5.10.x
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20210319184106.5688-1-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/stacktrace.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -199,8 +199,9 @@ void show_stack(struct task_struct *tsk,
 
 #ifdef CONFIG_STACKTRACE
 
-void arch_stack_walk(stack_trace_consume_fn consume_entry, void *cookie,
-		     struct task_struct *task, struct pt_regs *regs)
+noinline void arch_stack_walk(stack_trace_consume_fn consume_entry,
+			      void *cookie, struct task_struct *task,
+			      struct pt_regs *regs)
 {
 	struct stackframe frame;
 
@@ -208,8 +209,8 @@ void arch_stack_walk(stack_trace_consume
 		start_backtrace(&frame, regs->regs[29], regs->pc);
 	else if (task == current)
 		start_backtrace(&frame,
-				(unsigned long)__builtin_frame_address(0),
-				(unsigned long)arch_stack_walk);
+				(unsigned long)__builtin_frame_address(1),
+				(unsigned long)__builtin_return_address(0));
 	else
 		start_backtrace(&frame, thread_saved_fp(task),
 				thread_saved_pc(task));


