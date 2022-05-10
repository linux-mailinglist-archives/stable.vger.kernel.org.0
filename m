Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7F115219F8
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243570AbiEJNwp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245389AbiEJNrj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9575960BA2;
        Tue, 10 May 2022 06:35:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 904E5B81DAB;
        Tue, 10 May 2022 13:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16E5C385A6;
        Tue, 10 May 2022 13:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189740;
        bh=ovzqq1GLrorpGTsrq4MpUV1qbQaSEUKqp5DT427Lm2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tpf1GGN4VLy1MBjLYcSx8zDGg2fyfwe3gG6Oi3lZcWYfPc6bDKKHI2kQzfHRqCksy
         fAmvgNJ83x+jRAdL682j4tC8STPbBJPwqVjQqUyHsvs/6m0HwA/smcJ9StV2yYPKjl
         8ZAG0ezqNPr4r77HyG1m2roMBqxaEsEw08aeTDLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.17 014/140] x86/fpu: Prevent FPU state corruption
Date:   Tue, 10 May 2022 15:06:44 +0200
Message-Id: <20220510130742.015180321@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 59f5ede3bc0f00eb856425f636dab0c10feb06d8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
 


