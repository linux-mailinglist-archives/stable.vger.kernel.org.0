Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3C75FB580
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 16:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbiJKOyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 10:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbiJKOxi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:53:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F397D9B87E;
        Tue, 11 Oct 2022 07:51:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7A5C6CE17EF;
        Tue, 11 Oct 2022 14:51:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936CDC433D6;
        Tue, 11 Oct 2022 14:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499885;
        bh=G8CuIdsxyRmJZ0HZZZ+6AWbhH4w906IufRABNPKTnM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OAWrL0PtTxTG38DdalIleXf6vnOhNZQQYw9Kxl6f5/9SHCcfXhhXAmHWLzBNU5S9o
         kvrHtdTFCEc5emXE1o8+n7JBJqICTTE18KA6a6Cx2MPJamQApnC5rjMH9Wv7bFRGIT
         BXnxosYtXDSEP2EI8W3yZEl2WS7Z14z6q1cxSH5vO25QHSoZSJFICFnF3eS6lI5sOo
         2KtyCG09J+LIijWRfasd1oGO5VTkWeJZ2PoSz5jl/XUKN8KxzJVJUMvvxU9ncCAMJU
         vTALMQ4aDAs048ClsrZSN+7uGnOHBLYcw1suTTqW2+2DG3goZmzR+pe19pWN+t6+Xa
         /WLwV6i/4PJNQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Huafei <lihuafei1@huawei.com>,
        Linus Waleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        linyujun809@huawei.com, rostedt@goodmis.org,
        ndesaulniers@google.com, mhiramat@kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 44/46] ARM: 9234/1: stacktrace: Avoid duplicate saving of exception PC value
Date:   Tue, 11 Oct 2022 10:50:12 -0400
Message-Id: <20221011145015.1622882-44-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145015.1622882-1-sashal@kernel.org>
References: <20221011145015.1622882-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Huafei <lihuafei1@huawei.com>

[ Upstream commit 752ec621ef5c30777958cc5eb5f1cf394f7733f4 ]

Because an exception stack frame is not created in the exception entry,
save_trace() does special handling for the exception PC, but this is
only needed when CONFIG_FRAME_POINTER_UNWIND=y. When
CONFIG_ARM_UNWIND=y, unwind annotations have been added to the exception
entry and save_trace() will repeatedly save the exception PC:

    [0x7f000090] hrtimer_hander+0x8/0x10 [hrtimer]
    [0x8019ec50] __hrtimer_run_queues+0x18c/0x394
    [0x8019f760] hrtimer_run_queues+0xbc/0xd0
    [0x8019def0] update_process_times+0x34/0x80
    [0x801ad2a4] tick_periodic+0x48/0xd0
    [0x801ad3dc] tick_handle_periodic+0x1c/0x7c
    [0x8010f2e0] twd_handler+0x30/0x40
    [0x80177620] handle_percpu_devid_irq+0xa0/0x23c
    [0x801718d0] generic_handle_domain_irq+0x24/0x34
    [0x80502d28] gic_handle_irq+0x74/0x88
    [0x8085817c] generic_handle_arch_irq+0x58/0x78
    [0x80100ba8] __irq_svc+0x88/0xc8
    [0x80108114] arch_cpu_idle+0x38/0x3c
    [0x80108114] arch_cpu_idle+0x38/0x3c    <==== duplicate saved exception PC
    [0x80861bf8] default_idle_call+0x38/0x130
    [0x8015d5cc] do_idle+0x150/0x214
    [0x8015d978] cpu_startup_entry+0x18/0x1c
    [0x808589c0] rest_init+0xd8/0xdc
    [0x80c00a44] arch_post_acpi_subsys_init+0x0/0x8

We can move the special handling of the exception PC in save_trace() to
the unwind_frame() of the frame pointer unwinder.

Signed-off-by: Li Huafei <lihuafei1@huawei.com>
Reviewed-by: Linus Waleij <linus.walleij@linaro.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/include/asm/stacktrace.h |  6 +++++
 arch/arm/kernel/return_address.c  |  1 +
 arch/arm/kernel/stacktrace.c      | 44 +++++++++++++++++++++----------
 3 files changed, 37 insertions(+), 14 deletions(-)

diff --git a/arch/arm/include/asm/stacktrace.h b/arch/arm/include/asm/stacktrace.h
index 3e78f921b8b2..39be2d1aa27b 100644
--- a/arch/arm/include/asm/stacktrace.h
+++ b/arch/arm/include/asm/stacktrace.h
@@ -21,6 +21,9 @@ struct stackframe {
 	struct llist_node *kr_cur;
 	struct task_struct *tsk;
 #endif
+#ifdef CONFIG_UNWINDER_FRAME_POINTER
+	bool ex_frame;
+#endif
 };
 
 static __always_inline
@@ -34,6 +37,9 @@ void arm_get_current_stackframe(struct pt_regs *regs, struct stackframe *frame)
 		frame->kr_cur = NULL;
 		frame->tsk = current;
 #endif
+#ifdef CONFIG_UNWINDER_FRAME_POINTER
+		frame->ex_frame = in_entry_text(frame->pc);
+#endif
 }
 
 extern int unwind_frame(struct stackframe *frame);
diff --git a/arch/arm/kernel/return_address.c b/arch/arm/kernel/return_address.c
index 8aac1e10b117..38f1ea9c724d 100644
--- a/arch/arm/kernel/return_address.c
+++ b/arch/arm/kernel/return_address.c
@@ -47,6 +47,7 @@ void *return_address(unsigned int level)
 	frame.kr_cur = NULL;
 	frame.tsk = current;
 #endif
+	frame.ex_frame = false;
 
 	walk_stackframe(&frame, save_return_addr, &data);
 
diff --git a/arch/arm/kernel/stacktrace.c b/arch/arm/kernel/stacktrace.c
index af87040b0353..85443b5d1922 100644
--- a/arch/arm/kernel/stacktrace.c
+++ b/arch/arm/kernel/stacktrace.c
@@ -82,6 +82,27 @@ int notrace unwind_frame(struct stackframe *frame)
 	if (frame_pointer_check(frame))
 		return -EINVAL;
 
+	/*
+	 * When we unwind through an exception stack, include the saved PC
+	 * value into the stack trace.
+	 */
+	if (frame->ex_frame) {
+		struct pt_regs *regs = (struct pt_regs *)frame->sp;
+
+		/*
+		 * We check that 'regs + sizeof(struct pt_regs)' (that is,
+		 * &regs[1]) does not exceed the bottom of the stack to avoid
+		 * accessing data outside the task's stack. This may happen
+		 * when frame->ex_frame is a false positive.
+		 */
+		if ((unsigned long)&regs[1] > ALIGN(frame->sp, THREAD_SIZE))
+			return -EINVAL;
+
+		frame->pc = regs->ARM_pc;
+		frame->ex_frame = false;
+		return 0;
+	}
+
 	/* restore the registers from the stack frame */
 #ifdef CONFIG_CC_IS_CLANG
 	frame->sp = frame->fp;
@@ -98,6 +119,9 @@ int notrace unwind_frame(struct stackframe *frame)
 					(void *)frame->fp, &frame->kr_cur);
 #endif
 
+	if (in_entry_text(frame->pc))
+		frame->ex_frame = true;
+
 	return 0;
 }
 #endif
@@ -128,7 +152,6 @@ static int save_trace(struct stackframe *frame, void *d)
 {
 	struct stack_trace_data *data = d;
 	struct stack_trace *trace = data->trace;
-	struct pt_regs *regs;
 	unsigned long addr = frame->pc;
 
 	if (data->no_sched_functions && in_sched_functions(addr))
@@ -139,19 +162,6 @@ static int save_trace(struct stackframe *frame, void *d)
 	}
 
 	trace->entries[trace->nr_entries++] = addr;
-
-	if (trace->nr_entries >= trace->max_entries)
-		return 1;
-
-	if (!in_entry_text(frame->pc))
-		return 0;
-
-	regs = (struct pt_regs *)frame->sp;
-	if ((unsigned long)&regs[1] > ALIGN(frame->sp, THREAD_SIZE))
-		return 0;
-
-	trace->entries[trace->nr_entries++] = regs->ARM_pc;
-
 	return trace->nr_entries >= trace->max_entries;
 }
 
@@ -193,6 +203,9 @@ static noinline void __save_stack_trace(struct task_struct *tsk,
 	frame.kr_cur = NULL;
 	frame.tsk = tsk;
 #endif
+#ifdef CONFIG_UNWINDER_FRAME_POINTER
+	frame.ex_frame = false;
+#endif
 
 	walk_stackframe(&frame, save_trace, &data);
 }
@@ -214,6 +227,9 @@ void save_stack_trace_regs(struct pt_regs *regs, struct stack_trace *trace)
 	frame.kr_cur = NULL;
 	frame.tsk = current;
 #endif
+#ifdef CONFIG_UNWINDER_FRAME_POINTER
+	frame.ex_frame = in_entry_text(frame.pc);
+#endif
 
 	walk_stackframe(&frame, save_trace, &data);
 }
-- 
2.35.1

