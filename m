Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 633C051677B
	for <lists+stable@lfdr.de>; Sun,  1 May 2022 21:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbiEATfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 May 2022 15:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbiEATfN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 May 2022 15:35:13 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58FA64E3A5;
        Sun,  1 May 2022 12:31:46 -0700 (PDT)
Message-ID: <20220501193102.588689270@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1651433504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=Xh00mBTIPhiL8G3sTnLFewMyTOf/QnQuL4kbITowOlY=;
        b=mRcYKlxGiBvr0VWf1j+KfTraywDaOEabXj+tQJB0pXGtMuyfP7nekJI7hrH9snBEGrYi9t
        JW4Dw5xY7Lj0i/eYPLz7Ral3pHPrKLWtUdEYaEpzdWAoVeH45m7W8T/z8o2THgonrpbqL3
        qBLumciwRqgistyIEbuGYhWKZoCGvNP8E1YNPrcV0dxDQzEeC3CmSZ5yLCkXZZS3LqYV9Q
        VvMGH0X3lqNFvCtxcEUETgQjxoQQz96YY6gKCSfUvZ4AbLsCDSBH3rv9W/hiPWAQHzPIMS
        xjb8VZfAR5V8Y0Bfoke/2e5L8FVjReM7gPPLpmBORu4sCM77IjzoPlaUc7fqew==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1651433504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=Xh00mBTIPhiL8G3sTnLFewMyTOf/QnQuL4kbITowOlY=;
        b=ozCVrDoCzB05zO60lAMcMwkSCjU7hs4Zoly+Ar87eKVl14g1QXVIV6QIGQHT3a0mw9GUOC
        g9v8HsLGNrCX9bCg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Filipe Manana <fdmanana@suse.com>,
        stable@vger.kernel.org
Subject: [patch 1/3] x86/fpu: Prevent FPU state corruption
References: <20220501192740.203963477@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Sun,  1 May 2022 21:31:43 +0200 (CEST)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The FPU usage related to task FPU management is either protected by
disabling interrupts (switch_to, return to user) or via fpregs_lock() which
is a wrapper around local_bh_disable(). When kernel code wants to use the
FPU then it has to check whether it is possible by calling irq_fpu_usable().

But the condition in irq_fpu_usable() is wrong. It allows FPU to be used
when:

   !in_interrupt() || interrupted_user_mode() || interrupted_kernel_fpu_idle()

The latter is checking whether some other context already uses FPU in the
kernel, but if that's not the case then it allows FPU to be used
unconditionally even if the calling context interupted a fpregs_lock()
critical region. If that happens then the FPU state of the interrupted
context becomes corrupted.

Allow in kernel FPU usage only when no other context has in kernel FPU
usage and either the calling context is not hard interrupt context or the
hard interrupt did not interrupt a local bottomhalf disabled region.

It's hard to find a proper Fixes tag as the condition was broken in one way
or the other for a very long time and the eager/lazy FPU changes caused a
lot of churn. Picked something remotely connected from the history.

This survived undetected for quite some time as FPU usage in interrupt
context is rare, but the recent changes to the random code unearthed it at
least on a kernel which had FPU debugging enabled. There is probably a
higher rate of silent corruption as not all issues can be detected by the
FPU debugging code. This will be addressed in a subsequent change.

Fixes: 5d2bd7009f30 ("x86, fpu: decouple non-lazy/eager fpu restore from xsave")
Reported-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
---
 arch/x86/kernel/fpu/core.c |   67 +++++++++++++++++----------------------------
 1 file changed, 26 insertions(+), 41 deletions(-)

--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -41,17 +41,7 @@ struct fpu_state_config fpu_user_cfg __r
  */
 struct fpstate init_fpstate __ro_after_init;
 
-/*
- * Track whether the kernel is using the FPU state
- * currently.
- *
- * This flag is used:
- *
- *   - by IRQ context code to potentially use the FPU
- *     if it's unused.
- *
- *   - to debug kernel_fpu_begin()/end() correctness
- */
+/* Track in-kernel FPU usage */
 static DEFINE_PER_CPU(bool, in_kernel_fpu);
 
 /*
@@ -59,42 +49,37 @@ static DEFINE_PER_CPU(bool, in_kernel_fp
  */
 DEFINE_PER_CPU(struct fpu *, fpu_fpregs_owner_ctx);
 
-static bool kernel_fpu_disabled(void)
-{
-	return this_cpu_read(in_kernel_fpu);
-}
-
-static bool interrupted_kernel_fpu_idle(void)
-{
-	return !kernel_fpu_disabled();
-}
-
-/*
- * Were we in user mode (or vm86 mode) when we were
- * interrupted?
- *
- * Doing kernel_fpu_begin/end() is ok if we are running
- * in an interrupt context from user mode - we'll just
- * save the FPU state as required.
- */
-static bool interrupted_user_mode(void)
-{
-	struct pt_regs *regs = get_irq_regs();
-	return regs && user_mode(regs);
-}
-
 /*
  * Can we use the FPU in kernel mode with the
  * whole "kernel_fpu_begin/end()" sequence?
- *
- * It's always ok in process context (ie "not interrupt")
- * but it is sometimes ok even from an irq.
  */
 bool irq_fpu_usable(void)
 {
-	return !in_interrupt() ||
-		interrupted_user_mode() ||
-		interrupted_kernel_fpu_idle();
+	if (WARN_ON_ONCE(in_nmi()))
+		return false;
+
+	/* In kernel FPU usage already active? */
+	if (this_cpu_read(in_kernel_fpu))
+		return false;
+
+	/*
+	 * When not in NMI or hard interrupt context, FPU can be used:
+	 *
+	 * - Task context is safe except from within fpregs_lock()'ed
+	 *   critical regions.
+	 *
+	 * - Soft interrupt processing context which cannot happen
+	 *   while in a fpregs_lock()'ed critical region.
+	 */
+	if (!in_hardirq())
+		return true;
+
+	/*
+	 * In hard interrupt context it's safe when soft interrupts
+	 * are enabled, which means the interrupt did not hit in
+	 * a fpregs_lock()'ed critical region.
+	 */
+	return !softirq_count();
 }
 EXPORT_SYMBOL(irq_fpu_usable);
 

