Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E61D1D836B
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732799AbgERSEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:04:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732790AbgERSEc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:04:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2440B20715;
        Mon, 18 May 2020 18:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825070;
        bh=NXrrNf/jojGM7RP9reK/QcyWTDKdGM6nS++ECSboFQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kzEm213PJSst3P+uYVSSwt+eUBs9IDLZrZ/OIzuCPXSKEVAM/OpMUC19EXC0Tk2h9
         xcgZa/uiGzISUCkj5ZIyocctXqen6CufWlca+7AL4/57tLUKnLRfbiZwn8PJ0l8n0T
         0kGz9waSQj9Hmdl3ZGj104p/nZ/7cmVeVj/V7gGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Borislav Petkov <bp@alien8.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 116/194] x86/ftrace: Have ftrace trampolines turn read-only at the end of system boot up
Date:   Mon, 18 May 2020 19:36:46 +0200
Message-Id: <20200518173541.352620638@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

[ Upstream commit 59566b0b622e3e6ea928c0b8cac8a5601b00b383 ]

Booting one of my machines, it triggered the following crash:

 Kernel/User page tables isolation: enabled
 ftrace: allocating 36577 entries in 143 pages
 Starting tracer 'function'
 BUG: unable to handle page fault for address: ffffffffa000005c
 #PF: supervisor write access in kernel mode
 #PF: error_code(0x0003) - permissions violation
 PGD 2014067 P4D 2014067 PUD 2015063 PMD 7b253067 PTE 7b252061
 Oops: 0003 [#1] PREEMPT SMP PTI
 CPU: 0 PID: 0 Comm: swapper Not tainted 5.4.0-test+ #24
 Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M., BIOS SDBLI944.86P 05/08/2007
 RIP: 0010:text_poke_early+0x4a/0x58
 Code: 34 24 48 89 54 24 08 e8 bf 72 0b 00 48 8b 34 24 48 8b 4c 24 08 84 c0 74 0b 48 89 df f3 a4 48 83 c4 10 5b c3 9c 58 fa 48 89 df <f3> a4 50 9d 48 83 c4 10 5b e9 d6 f9 ff ff
0 41 57 49
 RSP: 0000:ffffffff82003d38 EFLAGS: 00010046
 RAX: 0000000000000046 RBX: ffffffffa000005c RCX: 0000000000000005
 RDX: 0000000000000005 RSI: ffffffff825b9a90 RDI: ffffffffa000005c
 RBP: ffffffffa000005c R08: 0000000000000000 R09: ffffffff8206e6e0
 R10: ffff88807b01f4c0 R11: ffffffff8176c106 R12: ffffffff8206e6e0
 R13: ffffffff824f2440 R14: 0000000000000000 R15: ffffffff8206eac0
 FS:  0000000000000000(0000) GS:ffff88807d400000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: ffffffffa000005c CR3: 0000000002012000 CR4: 00000000000006b0
 Call Trace:
  text_poke_bp+0x27/0x64
  ? mutex_lock+0x36/0x5d
  arch_ftrace_update_trampoline+0x287/0x2d5
  ? ftrace_replace_code+0x14b/0x160
  ? ftrace_update_ftrace_func+0x65/0x6c
  __register_ftrace_function+0x6d/0x81
  ftrace_startup+0x23/0xc1
  register_ftrace_function+0x20/0x37
  func_set_flag+0x59/0x77
  __set_tracer_option.isra.19+0x20/0x3e
  trace_set_options+0xd6/0x13e
  apply_trace_boot_options+0x44/0x6d
  register_tracer+0x19e/0x1ac
  early_trace_init+0x21b/0x2c9
  start_kernel+0x241/0x518
  ? load_ucode_intel_bsp+0x21/0x52
  secondary_startup_64+0xa4/0xb0

I was able to trigger it on other machines, when I added to the kernel
command line of both "ftrace=function" and "trace_options=func_stack_trace".

The cause is the "ftrace=function" would register the function tracer
and create a trampoline, and it will set it as executable and
read-only. Then the "trace_options=func_stack_trace" would then update
the same trampoline to include the stack tracer version of the function
tracer. But since the trampoline already exists, it updates it with
text_poke_bp(). The problem is that text_poke_bp() called while
system_state == SYSTEM_BOOTING, it will simply do a memcpy() and not
the page mapping, as it would think that the text is still read-write.
But in this case it is not, and we take a fault and crash.

Instead, lets keep the ftrace trampolines read-write during boot up,
and then when the kernel executable text is set to read-only, the
ftrace trampolines get set to read-only as well.

Link: https://lkml.kernel.org/r/20200430202147.4dc6e2de@oasis.local.home

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: stable@vger.kernel.org
Fixes: 768ae4406a5c ("x86/ftrace: Use text_poke()")
Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/ftrace.h  |  6 ++++++
 arch/x86/kernel/ftrace.c       | 29 ++++++++++++++++++++++++++++-
 arch/x86/mm/init_64.c          |  3 +++
 include/linux/ftrace.h         | 23 +++++++++++++++++++++++
 kernel/trace/ftrace_internal.h | 22 ----------------------
 5 files changed, 60 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index 85be2f5062728..89af0d2c62aab 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -56,6 +56,12 @@ struct dyn_arch_ftrace {
 
 #ifndef __ASSEMBLY__
 
+#if defined(CONFIG_FUNCTION_TRACER) && defined(CONFIG_DYNAMIC_FTRACE)
+extern void set_ftrace_ops_ro(void);
+#else
+static inline void set_ftrace_ops_ro(void) { }
+#endif
+
 #define ARCH_HAS_SYSCALL_MATCH_SYM_NAME
 static inline bool arch_syscall_match_sym_name(const char *sym, const char *name)
 {
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 37a0aeaf89e77..b0e641793be4f 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -407,7 +407,8 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 
 	set_vm_flush_reset_perms(trampoline);
 
-	set_memory_ro((unsigned long)trampoline, npages);
+	if (likely(system_state != SYSTEM_BOOTING))
+		set_memory_ro((unsigned long)trampoline, npages);
 	set_memory_x((unsigned long)trampoline, npages);
 	return (unsigned long)trampoline;
 fail:
@@ -415,6 +416,32 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 	return 0;
 }
 
+void set_ftrace_ops_ro(void)
+{
+	struct ftrace_ops *ops;
+	unsigned long start_offset;
+	unsigned long end_offset;
+	unsigned long npages;
+	unsigned long size;
+
+	do_for_each_ftrace_op(ops, ftrace_ops_list) {
+		if (!(ops->flags & FTRACE_OPS_FL_ALLOC_TRAMP))
+			continue;
+
+		if (ops->flags & FTRACE_OPS_FL_SAVE_REGS) {
+			start_offset = (unsigned long)ftrace_regs_caller;
+			end_offset = (unsigned long)ftrace_regs_caller_end;
+		} else {
+			start_offset = (unsigned long)ftrace_caller;
+			end_offset = (unsigned long)ftrace_epilogue;
+		}
+		size = end_offset - start_offset;
+		size = size + RET_SIZE + sizeof(void *);
+		npages = DIV_ROUND_UP(size, PAGE_SIZE);
+		set_memory_ro((unsigned long)ops->trampoline, npages);
+	} while_for_each_ftrace_op(ops);
+}
+
 static unsigned long calc_trampoline_call_offset(bool save_regs)
 {
 	unsigned long start_offset;
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index abbdecb75fad8..023e1ec5e1537 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -54,6 +54,7 @@
 #include <asm/init.h>
 #include <asm/uv/uv.h>
 #include <asm/setup.h>
+#include <asm/ftrace.h>
 
 #include "mm_internal.h"
 
@@ -1288,6 +1289,8 @@ void mark_rodata_ro(void)
 	all_end = roundup((unsigned long)_brk_end, PMD_SIZE);
 	set_memory_nx(text_end, (all_end - text_end) >> PAGE_SHIFT);
 
+	set_ftrace_ops_ro();
+
 #ifdef CONFIG_CPA_DEBUG
 	printk(KERN_INFO "Testing CPA: undo %lx-%lx\n", start, end);
 	set_memory_rw(start, (end-start) >> PAGE_SHIFT);
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index db95244a62d44..ab4bd15cbcdb3 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -210,6 +210,29 @@ struct ftrace_ops {
 #endif
 };
 
+extern struct ftrace_ops __rcu *ftrace_ops_list;
+extern struct ftrace_ops ftrace_list_end;
+
+/*
+ * Traverse the ftrace_global_list, invoking all entries.  The reason that we
+ * can use rcu_dereference_raw_check() is that elements removed from this list
+ * are simply leaked, so there is no need to interact with a grace-period
+ * mechanism.  The rcu_dereference_raw_check() calls are needed to handle
+ * concurrent insertions into the ftrace_global_list.
+ *
+ * Silly Alpha and silly pointer-speculation compiler optimizations!
+ */
+#define do_for_each_ftrace_op(op, list)			\
+	op = rcu_dereference_raw_check(list);			\
+	do
+
+/*
+ * Optimized for just a single item in the list (as that is the normal case).
+ */
+#define while_for_each_ftrace_op(op)				\
+	while (likely(op = rcu_dereference_raw_check((op)->next)) &&	\
+	       unlikely((op) != &ftrace_list_end))
+
 /*
  * Type of the current tracing.
  */
diff --git a/kernel/trace/ftrace_internal.h b/kernel/trace/ftrace_internal.h
index 0456e0a3dab14..382775edf6902 100644
--- a/kernel/trace/ftrace_internal.h
+++ b/kernel/trace/ftrace_internal.h
@@ -4,28 +4,6 @@
 
 #ifdef CONFIG_FUNCTION_TRACER
 
-/*
- * Traverse the ftrace_global_list, invoking all entries.  The reason that we
- * can use rcu_dereference_raw_check() is that elements removed from this list
- * are simply leaked, so there is no need to interact with a grace-period
- * mechanism.  The rcu_dereference_raw_check() calls are needed to handle
- * concurrent insertions into the ftrace_global_list.
- *
- * Silly Alpha and silly pointer-speculation compiler optimizations!
- */
-#define do_for_each_ftrace_op(op, list)			\
-	op = rcu_dereference_raw_check(list);			\
-	do
-
-/*
- * Optimized for just a single item in the list (as that is the normal case).
- */
-#define while_for_each_ftrace_op(op)				\
-	while (likely(op = rcu_dereference_raw_check((op)->next)) &&	\
-	       unlikely((op) != &ftrace_list_end))
-
-extern struct ftrace_ops __rcu *ftrace_ops_list;
-extern struct ftrace_ops ftrace_list_end;
 extern struct mutex ftrace_lock;
 extern struct ftrace_ops global_ops;
 
-- 
2.20.1



