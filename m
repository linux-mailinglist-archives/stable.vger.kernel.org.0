Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07ED83E8014
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235822AbhHJRqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:46:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236144AbhHJRoe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:44:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7F8A6113D;
        Tue, 10 Aug 2021 17:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617178;
        bh=yNfy5sIQIBEiJGj6vws9CR/WP3ngWh9+PdmMUiRtloI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YLfQWaRucSCR1Jjmw1hX+iRuCbrcC5XUybja4Ap7IvD4xFM7luf9eG0Wv6chgFcnN
         G9YSgYlz9irvxtUV7llFOKrIHec+EDp5GSGCjnLfzSCFdOVaL/t3367KpfF7rBnyoG
         TM35K798kQRI61FYyOyAb59itsZOu69CmvrkwQfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
        Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>
Subject: [PATCH 5.10 080/135] arm64: stacktrace: avoid tracing arch_stack_walk()
Date:   Tue, 10 Aug 2021 19:30:14 +0200
Message-Id: <20210810172958.462287930@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

commit 0c32706dac1b0a72713184246952ab0f54327c21 upstream.

When the function_graph tracer is in use, arch_stack_walk() may unwind
the stack incorrectly, erroneously reporting itself, missing the final
entry which is being traced, and reporting all traced entries between
these off-by-one from where they should be.

When ftrace hooks a function return, the original return address is
saved to the fgraph ret_stack, and the return address  in the LR (or the
function's frame record) is replaced with `return_to_handler`.

When arm64's unwinder encounter frames returning to `return_to_handler`,
it finds the associated original return address from the fgraph ret
stack, assuming the most recent `ret_to_hander` entry on the stack
corresponds to the most recent entry in the fgraph ret stack, and so on.

When arch_stack_walk() is used to dump the current task's stack, it
starts from the caller of arch_stack_walk(). However, arch_stack_walk()
can be traced, and so may push an entry on to the fgraph ret stack,
leaving the fgraph ret stack offset by one from the expected position.

This can be seen when dumping the stack via /proc/self/stack, where
enabling the graph tracer results in an unexpected
`stack_trace_save_tsk` entry at the start of the trace, and `el0_svc`
missing form the end of the trace.

This patch fixes this by marking arch_stack_walk() as notrace, as we do
for all other functions on the path to ftrace_graph_get_ret_stack().
While a few helper functions are not marked notrace, their calls/returns
are balanced, and will have no observable effect when examining the
fgraph ret stack.

It is possible for an exeption boundary to cause a similar offset if the
return address of the interrupted context was in the LR. Fixing those
cases will require some more substantial rework, and is left for
subsequent patches.

Before:

| # cat /proc/self/stack
| [<0>] proc_pid_stack+0xc4/0x140
| [<0>] proc_single_show+0x6c/0x120
| [<0>] seq_read_iter+0x240/0x4e0
| [<0>] seq_read+0xe8/0x140
| [<0>] vfs_read+0xb8/0x1e4
| [<0>] ksys_read+0x74/0x100
| [<0>] __arm64_sys_read+0x28/0x3c
| [<0>] invoke_syscall+0x50/0x120
| [<0>] el0_svc_common.constprop.0+0xc4/0xd4
| [<0>] do_el0_svc+0x30/0x9c
| [<0>] el0_svc+0x2c/0x54
| [<0>] el0t_64_sync_handler+0x1a8/0x1b0
| [<0>] el0t_64_sync+0x198/0x19c
| # echo function_graph > /sys/kernel/tracing/current_tracer
| # cat /proc/self/stack
| [<0>] stack_trace_save_tsk+0xa4/0x110
| [<0>] proc_pid_stack+0xc4/0x140
| [<0>] proc_single_show+0x6c/0x120
| [<0>] seq_read_iter+0x240/0x4e0
| [<0>] seq_read+0xe8/0x140
| [<0>] vfs_read+0xb8/0x1e4
| [<0>] ksys_read+0x74/0x100
| [<0>] __arm64_sys_read+0x28/0x3c
| [<0>] invoke_syscall+0x50/0x120
| [<0>] el0_svc_common.constprop.0+0xc4/0xd4
| [<0>] do_el0_svc+0x30/0x9c
| [<0>] el0t_64_sync_handler+0x1a8/0x1b0
| [<0>] el0t_64_sync+0x198/0x19c

After:

| # cat /proc/self/stack
| [<0>] proc_pid_stack+0xc4/0x140
| [<0>] proc_single_show+0x6c/0x120
| [<0>] seq_read_iter+0x240/0x4e0
| [<0>] seq_read+0xe8/0x140
| [<0>] vfs_read+0xb8/0x1e4
| [<0>] ksys_read+0x74/0x100
| [<0>] __arm64_sys_read+0x28/0x3c
| [<0>] invoke_syscall+0x50/0x120
| [<0>] el0_svc_common.constprop.0+0xc4/0xd4
| [<0>] do_el0_svc+0x30/0x9c
| [<0>] el0_svc+0x2c/0x54
| [<0>] el0t_64_sync_handler+0x1a8/0x1b0
| [<0>] el0t_64_sync+0x198/0x19c
| # echo function_graph > /sys/kernel/tracing/current_tracer
| # cat /proc/self/stack
| [<0>] proc_pid_stack+0xc4/0x140
| [<0>] proc_single_show+0x6c/0x120
| [<0>] seq_read_iter+0x240/0x4e0
| [<0>] seq_read+0xe8/0x140
| [<0>] vfs_read+0xb8/0x1e4
| [<0>] ksys_read+0x74/0x100
| [<0>] __arm64_sys_read+0x28/0x3c
| [<0>] invoke_syscall+0x50/0x120
| [<0>] el0_svc_common.constprop.0+0xc4/0xd4
| [<0>] do_el0_svc+0x30/0x9c
| [<0>] el0_svc+0x2c/0x54
| [<0>] el0t_64_sync_handler+0x1a8/0x1b0
| [<0>] el0t_64_sync+0x198/0x19c

Cc: <stable@vger.kernel.org>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>
Reviwed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20210802164845.45506-3-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/stacktrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -199,7 +199,7 @@ void show_stack(struct task_struct *tsk,
 
 #ifdef CONFIG_STACKTRACE
 
-noinline void arch_stack_walk(stack_trace_consume_fn consume_entry,
+noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
 			      void *cookie, struct task_struct *task,
 			      struct pt_regs *regs)
 {


