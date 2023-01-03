Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 719ED65BBD7
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237019AbjACIQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237004AbjACIP7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:15:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE19B5E
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 00:15:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17E2C611DD
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 08:15:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D83C433D2;
        Tue,  3 Jan 2023 08:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733756;
        bh=80/vf2xzBZEXaobcI/OhiAjurtbJObkdBvERCsw4qYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tkd8Fg5jS34lfh0Nb4z1E4okrdo/JfMjq4aF3MmaONyyxdcjfS6wJSH4wWul09Xne
         YKXrLprgpYLi5Fz6yl+fdOR/PGNjuzZPhgjcNzTYeeA64hHNLGXHya9Gx/Xw4M92r9
         EGeUsGO5uSNqS1h/3KkCsoHPRn5GsiLGQPVsG/2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 32/63] arm: add support for TIF_NOTIFY_SIGNAL
Date:   Tue,  3 Jan 2023 09:14:02 +0100
Message-Id: <20230103081310.500082820@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
References: <20230103081308.548338576@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 32d59773da38cd83e497a70eb9754d4bbae3aeae ]

Wire up TIF_NOTIFY_SIGNAL handling for arm.

Cc: linux-arm-kernel@lists.infradead.org
Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/thread_info.h |    7 ++++++-
 arch/arm/kernel/entry-common.S     |    6 +++---
 arch/arm/kernel/entry-v7m.S        |    2 +-
 arch/arm/kernel/signal.c           |    2 +-
 4 files changed, 11 insertions(+), 6 deletions(-)

--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -126,6 +126,8 @@ extern int vfp_restore_user_hwstate(stru
  * thread information flags:
  *  TIF_USEDFPU		- FPU was used by this task this quantum (SMP)
  *  TIF_POLLING_NRFLAG	- true if poll_idle() is polling TIF_NEED_RESCHED
+ *
+ * Any bit in the range of 0..15 will cause do_work_pending() to be invoked.
  */
 #define TIF_SIGPENDING		0	/* signal pending */
 #define TIF_NEED_RESCHED	1	/* rescheduling necessary */
@@ -135,6 +137,7 @@ extern int vfp_restore_user_hwstate(stru
 #define TIF_SYSCALL_AUDIT	5	/* syscall auditing active */
 #define TIF_SYSCALL_TRACEPOINT	6	/* syscall tracepoint instrumentation */
 #define TIF_SECCOMP		7	/* seccomp syscall filtering active */
+#define TIF_NOTIFY_SIGNAL	8	/* signal notifications exist */
 
 #define TIF_USING_IWMMXT	17
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
@@ -148,6 +151,7 @@ extern int vfp_restore_user_hwstate(stru
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
+#define _TIF_NOTIFY_SIGNAL	(1 << TIF_NOTIFY_SIGNAL)
 #define _TIF_USING_IWMMXT	(1 << TIF_USING_IWMMXT)
 
 /* Checks for any syscall work in entry-common.S */
@@ -158,7 +162,8 @@ extern int vfp_restore_user_hwstate(stru
  * Change these and you break ASM code in entry-common.S
  */
 #define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | \
-				 _TIF_NOTIFY_RESUME | _TIF_UPROBE)
+				 _TIF_NOTIFY_RESUME | _TIF_UPROBE | \
+				 _TIF_NOTIFY_SIGNAL)
 
 #endif /* __KERNEL__ */
 #endif /* __ASM_ARM_THREAD_INFO_H */
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -53,7 +53,7 @@ __ret_fast_syscall:
 	cmp	r2, #TASK_SIZE
 	blne	addr_limit_check_failed
 	ldr	r1, [tsk, #TI_FLAGS]		@ re-check for syscall tracing
-	tst	r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
+	movs	r1, r1, lsl #16
 	bne	fast_work_pending
 
 
@@ -90,7 +90,7 @@ __ret_fast_syscall:
 	cmp	r2, #TASK_SIZE
 	blne	addr_limit_check_failed
 	ldr	r1, [tsk, #TI_FLAGS]		@ re-check for syscall tracing
-	tst	r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
+	movs	r1, r1, lsl #16
 	beq	no_work_pending
  UNWIND(.fnend		)
 ENDPROC(ret_fast_syscall)
@@ -131,7 +131,7 @@ ENTRY(ret_to_user_from_irq)
 	cmp	r2, #TASK_SIZE
 	blne	addr_limit_check_failed
 	ldr	r1, [tsk, #TI_FLAGS]
-	tst	r1, #_TIF_WORK_MASK
+	movs	r1, r1, lsl #16
 	bne	slow_work_pending
 no_work_pending:
 	asm_trace_hardirqs_on save = 0
--- a/arch/arm/kernel/entry-v7m.S
+++ b/arch/arm/kernel/entry-v7m.S
@@ -59,7 +59,7 @@ __irq_entry:
 
 	get_thread_info tsk
 	ldr	r2, [tsk, #TI_FLAGS]
-	tst	r2, #_TIF_WORK_MASK
+	movs	r2, r2, lsl #16
 	beq	2f			@ no work pending
 	mov	r0, #V7M_SCB_ICSR_PENDSVSET
 	str	r0, [r1, V7M_SCB_ICSR]	@ raise PendSV
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -655,7 +655,7 @@ do_work_pending(struct pt_regs *regs, un
 			if (unlikely(!user_mode(regs)))
 				return 0;
 			local_irq_enable();
-			if (thread_flags & _TIF_SIGPENDING) {
+			if (thread_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL)) {
 				int restart = do_signal(regs, syscall);
 				if (unlikely(restart)) {
 					/*


