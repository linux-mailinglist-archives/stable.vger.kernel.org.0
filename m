Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA4B5FB5D8
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbiJKPAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbiJKO5f (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:57:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E6D9DFB9;
        Tue, 11 Oct 2022 07:52:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BB41B811F5;
        Tue, 11 Oct 2022 14:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2516C433D6;
        Tue, 11 Oct 2022 14:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499948;
        bh=eHV1aJFxZYib1ONBCUtCKxxKWY0nN7MLKb5IBx+tpRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uCumYCYvhuD0j3oj49VO808uctajQThBGjihRwpDxW/G+eM/z2giOchli8h97CQX2
         n5nx6sBrHmIT46Oj957prlFv29BHBA0ANlMepAkLuW65bCwlYkuGyY06Rdr4433HOA
         en4Tm/JMURlEVPJeHLhKytn1SljDhX4r3B2+bPwtl5ZFzPMk5qxXrhltFGTu3Leezr
         hAeEVdoP5MZki5Hxwf4aS0B3ABwfy2tERyTGXbMTsy1Q2gBXHdYZFkNTj0zADWwkFx
         1eaE9TEzMPBiLwURJ+0qWRecp9hmuJsx8gUD/H4evQrp0DQBWzPuTjnCVA/u74AFh+
         s15Wk7ZkAA7uA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Huafei <lihuafei1@huawei.com>,
        Linus Waleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        mhiramat@kernel.org, linyujun809@huawei.com, rostedt@goodmis.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 37/40] ARM: 9233/1: stacktrace: Skip frame pointer boundary check for call_with_stack()
Date:   Tue, 11 Oct 2022 10:51:26 -0400
Message-Id: <20221011145129.1623487-37-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145129.1623487-1-sashal@kernel.org>
References: <20221011145129.1623487-1-sashal@kernel.org>
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

