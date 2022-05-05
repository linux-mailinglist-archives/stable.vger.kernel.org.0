Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C5051B4CB
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 02:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232806AbiEEAqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 20:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbiEEAqj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 20:46:39 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426311DA49;
        Wed,  4 May 2022 17:43:01 -0700 (PDT)
Date:   Thu, 05 May 2022 00:42:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1651711378;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eMX5uveEfhMAmowLmNC4/0zMLBt146piZZ8X4FSp4h0=;
        b=c6w66Oc7AiYeK4pCe8crjP9DAF1hwniGOH88izGxNVuGbgiKgUnCq1A6SLrDSZjSIq1Ygm
        n/taVe12Zr4B7zwx5DvpzKRjXC7gEeI/hD2FkifD814nFQczxqacrXMXnDA3k7DXNcrVCm
        UlvnSUkI9Ln8cS/ArrJihEicGziI+k2febY7d0UmTn7BxfFI/JtF0kqfrzS0uteLR6qIgE
        ctbAo0frQE1VST5drei3/Q5AQVvRF4qRubVbZvcoj6/JAQOZn+673bx9vKITEj8GVpN6Rm
        +ed/SC8Z7/uE30payJvWsD/FXnMaLjW6Kg+SC72YMfJD4izruah2w7FKZ1d1BQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1651711378;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eMX5uveEfhMAmowLmNC4/0zMLBt146piZZ8X4FSp4h0=;
        b=EBrHlIq7f9XfFjPS1klMuQdO4242KUDPnzXU+908D960nVlAB6B4Rf5pHJd7icKxqYxnDV
        v6Q1jL2vh3LtP/Dw==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/fpu: Prevent FPU state corruption
Cc:     Filipe Manana <fdmanana@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20220501193102.588689270@linutronix.de>
References: <20220501193102.588689270@linutronix.de>
MIME-Version: 1.0
Message-ID: <165171137765.4207.5136455788055472062.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     59f5ede3bc0f00eb856425f636dab0c10feb06d8
Gitweb:        https://git.kernel.org/tip/59f5ede3bc0f00eb856425f636dab0c10feb06d8
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Sun, 01 May 2022 21:31:43 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Thu, 05 May 2022 02:40:19 +02:00

x86/fpu: Prevent FPU state corruption

The FPU usage related to task FPU management is either protected by
disabling interrupts (switch_to, return to user) or via fpregs_lock() which
is a wrapper around local_bh_disable(). When kernel code wants to use the
FPU then it has to check whether it is possible by calling irq_fpu_usable().

But the condition in irq_fpu_usable() is wrong. It allows FPU to be used
when:

   !in_interrupt() || interrupted_user_mode() || interrupted_kernel_fpu_idle()

The latter is checking whether some other context already uses FPU in the
kernel, but if that's not the case then it allows FPU to be used
unconditionally even if the calling context interrupted a fpregs_lock()
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
Tested-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220501193102.588689270@linutronix.de

---
 arch/x86/kernel/fpu/core.c | 67 ++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index c049561..e28ab0e 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -41,17 +41,7 @@ struct fpu_state_config fpu_user_cfg __ro_after_init;
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
@@ -59,42 +49,37 @@ static DEFINE_PER_CPU(bool, in_kernel_fpu);
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
+	 * When not in NMI or hard interrupt context, FPU can be used in:
+	 *
+	 * - Task context except from within fpregs_lock()'ed critical
+	 *   regions.
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
 
