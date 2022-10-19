Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE632604011
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234047AbiJSJmo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234458AbiJSJk2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:40:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF09F0191;
        Wed, 19 Oct 2022 02:16:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6037C61777;
        Wed, 19 Oct 2022 09:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714F4C433B5;
        Wed, 19 Oct 2022 09:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170879;
        bh=eHV1aJFxZYib1ONBCUtCKxxKWY0nN7MLKb5IBx+tpRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RM78CWkpXU/CmRjYjFdhaX6nS/nMiAbVyY6CcrZo+ZD5fyVSqfiB4+CuXzPR8ZNIi
         jQPUuDcgomP47rr1C3suvZjq+Bj+qYDHtaUBqGP5BiD0rQ1MneXV2Lz+nsmBf3cjPv
         IjPo2hO/1ztW6WPjJaF317lzphIKqUHVxjWyQ4hA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Huafei <lihuafei1@huawei.com>,
        Linus Waleij <linus.walleij@linaro.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 789/862] ARM: 9233/1: stacktrace: Skip frame pointer boundary check for call_with_stack()
Date:   Wed, 19 Oct 2022 10:34:36 +0200
Message-Id: <20221019083324.769545934@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Huafei <lihuafei1@huawei.com>

[ Upstream commit 5854e4d8530e6ed4c2532a71a6b0474e199d44dd ]

When using the frame pointer unwinder, it was found that the stack trace
output of stack_trace_save() is incomplete if the stack contains
call_with_stack():

 [0x7f00002c] dump_stack_task+0x2c/0x90 [hrtimer]
 [0x7f0000a0] hrtimer_hander+0x10/0x18 [hrtimer]
 [0x801a67f0] __hrtimer_run_queues+0x1b0/0x3b4
 [0x801a7350] hrtimer_run_queues+0xc4/0xd8
 [0x801a597c] update_process_times+0x3c/0x88
 [0x801b5a98] tick_periodic+0x50/0xd8
 [0x801b5bf4] tick_handle_periodic+0x24/0x84
 [0x8010ffc4] twd_handler+0x38/0x48
 [0x8017d220] handle_percpu_devid_irq+0xa8/0x244
 [0x80176e9c] generic_handle_domain_irq+0x2c/0x3c
 [0x8052e3a8] gic_handle_irq+0x7c/0x90
 [0x808ab15c] generic_handle_arch_irq+0x60/0x80
 [0x8051191c] call_with_stack+0x1c/0x20

For the frame pointer unwinder, unwind_frame() checks stackframe::fp by
stackframe::sp. Since call_with_stack() switches the SP from one stack
to another, stackframe::fp and stackframe: :sp will point to different
stacks, so we can no longer check stackframe::fp by stackframe::sp. Skip
checking stackframe::fp at this point to avoid this problem.

Signed-off-by: Li Huafei <lihuafei1@huawei.com>
Reviewed-by: Linus Waleij <linus.walleij@linaro.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/stacktrace.c   | 40 ++++++++++++++++++++++++++++------
 arch/arm/lib/call_with_stack.S |  2 ++
 2 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/arch/arm/kernel/stacktrace.c b/arch/arm/kernel/stacktrace.c
index d0fa2037460a..af87040b0353 100644
--- a/arch/arm/kernel/stacktrace.c
+++ b/arch/arm/kernel/stacktrace.c
@@ -9,6 +9,8 @@
 #include <asm/stacktrace.h>
 #include <asm/traps.h>
 
+#include "reboot.h"
+
 #if defined(CONFIG_FRAME_POINTER) && !defined(CONFIG_ARM_UNWIND)
 /*
  * Unwind the current stack frame and store the new register values in the
@@ -39,29 +41,53 @@
  * Note that with framepointer enabled, even the leaf functions have the same
  * prologue and epilogue, therefore we can ignore the LR value in this case.
  */
-int notrace unwind_frame(struct stackframe *frame)
+
+extern unsigned long call_with_stack_end;
+
+static int frame_pointer_check(struct stackframe *frame)
 {
 	unsigned long high, low;
 	unsigned long fp = frame->fp;
+	unsigned long pc = frame->pc;
+
+	/*
+	 * call_with_stack() is the only place we allow SP to jump from one
+	 * stack to another, with FP and SP pointing to different stacks,
+	 * skipping the FP boundary check at this point.
+	 */
+	if (pc >= (unsigned long)&call_with_stack &&
+			pc < (unsigned long)&call_with_stack_end)
+		return 0;
 
 	/* only go to a higher address on the stack */
 	low = frame->sp;
 	high = ALIGN(low, THREAD_SIZE);
 
-#ifdef CONFIG_CC_IS_CLANG
 	/* check current frame pointer is within bounds */
+#ifdef CONFIG_CC_IS_CLANG
 	if (fp < low + 4 || fp > high - 4)
 		return -EINVAL;
-
-	frame->sp = frame->fp;
-	frame->fp = READ_ONCE_NOCHECK(*(unsigned long *)(fp));
-	frame->pc = READ_ONCE_NOCHECK(*(unsigned long *)(fp + 4));
 #else
-	/* check current frame pointer is within bounds */
 	if (fp < low + 12 || fp > high - 4)
 		return -EINVAL;
+#endif
+
+	return 0;
+}
+
+int notrace unwind_frame(struct stackframe *frame)
+{
+	unsigned long fp = frame->fp;
+
+	if (frame_pointer_check(frame))
+		return -EINVAL;
 
 	/* restore the registers from the stack frame */
+#ifdef CONFIG_CC_IS_CLANG
+	frame->sp = frame->fp;
+	frame->fp = READ_ONCE_NOCHECK(*(unsigned long *)(fp));
+	frame->pc = READ_ONCE_NOCHECK(*(unsigned long *)(fp + 4));
+#else
 	frame->fp = READ_ONCE_NOCHECK(*(unsigned long *)(fp - 12));
 	frame->sp = READ_ONCE_NOCHECK(*(unsigned long *)(fp - 8));
 	frame->pc = READ_ONCE_NOCHECK(*(unsigned long *)(fp - 4));
diff --git a/arch/arm/lib/call_with_stack.S b/arch/arm/lib/call_with_stack.S
index 0a268a6c513c..5030d4e8d126 100644
--- a/arch/arm/lib/call_with_stack.S
+++ b/arch/arm/lib/call_with_stack.S
@@ -46,4 +46,6 @@ UNWIND( .setfp	fpreg, sp	)
 	pop	{fpreg, pc}
 UNWIND( .fnend			)
 #endif
+	.globl call_with_stack_end
+call_with_stack_end:
 ENDPROC(call_with_stack)
-- 
2.35.1



