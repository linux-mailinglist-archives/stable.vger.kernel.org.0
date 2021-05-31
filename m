Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6F43958A1
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 12:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbhEaKDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 06:03:18 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53364 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbhEaKDQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 06:03:16 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622455290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tkqHpSTt43qaIahMpXnGXGjx6VTa0nXeKqyUrO0DZR4=;
        b=cOKA0AZJryXm7P7GIkMFUBqPANAf7IfzXgdI7uMQPp7SeiSdS4iDNPzEVVlXs23NT1gKu8
        nu+AxaeahGh2BQsWy0RuNjixKLEqgn7RG/SgqkXICbAjUdGDPTLcneL2LNQBABDS2YatGo
        MNuqvQ2LlmR+FtxeVB0tbrSDKYiLg2aV9YOZp3+iulDpxftYldN750ZpbxCQrFB6v/vM6c
        3xPGupfpZTogJtL+bIof9gqkWskaOEZn4moDE8PHiW5/W5nlucf+rtKudE9m2y8g76/+NZ
        ff4XnS7DRYP67u8WPgD7+9wx3GGl0uWqsYDhj1JAYOipBtRVtl31mcRl0dbBNg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622455290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tkqHpSTt43qaIahMpXnGXGjx6VTa0nXeKqyUrO0DZR4=;
        b=VC2hkUG8s+OaDfwWsY8C2g8ekFg2yEAQHpXzNVTpeFgEVRbFNIfJJwz5QhPTetL/YeXzgp
        jh0NL3V9vjLk7mBw==
To:     Andy Lutomirski <luto@kernel.org>, x86@kernel.org
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org,
        syzbot+2067e764dbcd10721e2e@syzkaller.appspotmail.com
Subject: Re: [RFC v2 1/2] x86/fpu: Fix state corruption in __fpu__restore_sig()
In-Reply-To: <b69df1e42d1235996682178013f61d4120b3b361.1622351443.git.luto@kernel.org>
References: <cover.1622351443.git.luto@kernel.org> <b69df1e42d1235996682178013f61d4120b3b361.1622351443.git.luto@kernel.org>
Date:   Mon, 31 May 2021 12:01:30 +0200
Message-ID: <871r9n5iit.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 29 2021 at 22:12, Andy Lutomirski wrote:
>  /*
> - * Clear the FPU state back to init state.
> - *
> - * Called by sys_execve(), by the signal handler code and by various
> - * error paths.
> + * Reset current's user FPU states to the init states.  The caller promises
> + * that current's supervisor states (in memory or CPU regs as appropriate)
> + * as well as the XSAVE header in memory are intact.
>   */
> -static void fpu__clear(struct fpu *fpu, bool user_only)
> +void fpu__clear_user_states(struct fpu *fpu)
>  {
>  	WARN_ON_FPU(fpu != &current->thread.fpu);
>  
>  	if (!static_cpu_has(X86_FEATURE_FPU)) {

This can only be safely called if XSAVES is available. So this check is
bogus as it actually should check for !XSAVES. And if at all it should
be:

   if (WARN_ON_ONCE(!XSAVES))
      ....

This is exactly the stuff which causes subtle problems down the road.

I have no idea why you are insisting on having this conditional at the
call site. It's just an invitation for trouble because someone finds
this function and calls it unconditionally. And he will miss the
'promise' part in the comment as I did.

Something like the below.

Thanks,

        tglx
---
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -32,7 +32,7 @@ extern void fpu__save(struct fpu *fpu);
 extern int  fpu__restore_sig(void __user *buf, int ia32_frame);
 extern void fpu__drop(struct fpu *fpu);
 extern int  fpu__copy(struct task_struct *dst, struct task_struct *src);
-extern void fpu__clear_user_states(struct fpu *fpu);
+extern void fpu__handle_sig_restore_fail(struct fpu *fpu);
 extern void fpu__clear_all(struct fpu *fpu);
 extern int  fpu__exception_code(struct fpu *fpu, int trap_nr);
 
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -354,45 +354,72 @@ static inline void copy_init_fpstate_to_
 }
 
 /*
- * Clear the FPU state back to init state.
- *
- * Called by sys_execve(), by the signal handler code and by various
- * error paths.
+ * Reset current's user FPU states to the init states after a restore from
+ * user space supplied state failed in __fpu_restore_sig().
  */
-static void fpu__clear(struct fpu *fpu, bool user_only)
+void fpu__handle_sig_restore_fail(struct fpu *fpu)
 {
 	WARN_ON_FPU(fpu != &current->thread.fpu);
 
-	if (!static_cpu_has(X86_FEATURE_FPU)) {
-		fpu__drop(fpu);
-		fpu__initialize(fpu);
+	/*
+	 * With XSAVES this can just reset the user space state in the
+	 * registers. The content of task->fpu.state.xsave will be
+	 * overwritten by the next XSAVES, so it does not matter.
+	 *
+	 * For !XSAVES systems task->fpu.state.xsave must be
+	 * reinitialized. As these systems do not have supervisor states,
+	 * start over from a clean state.
+	 */
+	if (!static_cpu_has(X86_FEATURE_XSAVES)) {
+		fpu__clear_all(fpu);
 		return;
 	}
 
 	fpregs_lock();
 
-	if (user_only) {
-		if (!fpregs_state_valid(fpu, smp_processor_id()) &&
-		    xfeatures_mask_supervisor())
-			copy_kernel_to_xregs(&fpu->state.xsave,
-					     xfeatures_mask_supervisor());
-		copy_init_fpstate_to_fpregs(xfeatures_mask_user());
-	} else {
-		copy_init_fpstate_to_fpregs(xfeatures_mask_all);
+	/*
+	 * Ensure that current's supervisor states are loaded into
+	 * their corresponding registers.
+	 */
+	if (!fpregs_state_valid(fpu, smp_processor_id()) &&
+	    xfeatures_mask_supervisor()) {
+		copy_kernel_to_xregs(&fpu->state.xsave,
+				     xfeatures_mask_supervisor());
 	}
 
+	/* Reset user states in registers. */
+	copy_init_fpstate_to_fpregs(xfeatures_mask_user());
+
+	/*
+	 * Now all FPU registers have their desired values.  Inform the
+	 * FPU state machine that current's FPU registers are in the
+	 * hardware registers.
+	 */
 	fpregs_mark_activate();
+
 	fpregs_unlock();
 }
 
-void fpu__clear_user_states(struct fpu *fpu)
-{
-	fpu__clear(fpu, true);
-}
 
+/*
+ * Reset current's FPU registers (user and supervisor) to their INIT values.
+ * This function does not trust the in-memory XSAVE image to be valid at all;
+ * it is safe to call even if the contents of fpu->state may be entirely
+ * malicious, including the header.
+ *
+ * This means that it must not use XSAVE, as XSAVE reads the header from
+ * memory.
+ *
+ * This does not change the actual hardware registers; when fpu__clear_all()
+ * returns, TIF_NEED_FPU_LOAD will be set, and a subsequent exit to user mode
+ * will reload the hardware registers from memory.
+ */
 void fpu__clear_all(struct fpu *fpu)
 {
-	fpu__clear(fpu, false);
+	fpregs_lock();
+	fpu__drop(fpu);
+	fpu__initialize(fpu);
+	fpregs_unlock();
 }
 
 /*
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -345,6 +345,7 @@ static int __fpu__restore_sig(void __use
 		 */
 		fpregs_lock();
 		pagefault_disable();
+
 		ret = copy_user_to_fpregs_zeroing(buf_fx, user_xfeatures, fx_only);
 		pagefault_enable();
 		if (!ret) {
@@ -382,10 +383,9 @@ static int __fpu__restore_sig(void __use
 	}
 
 	/*
-	 * By setting TIF_NEED_FPU_LOAD it is ensured that our xstate is
-	 * not modified on context switch and that the xstate is considered
-	 * to be loaded again on return to userland (overriding last_cpu avoids
-	 * the optimisation).
+	 * By setting TIF_NEED_FPU_LOAD, we ensure that any context switches
+	 * or kernel_fpu_begin() operations (due to scheduling, page faults,
+	 * softirq, etc) do not access fpu->state.
 	 */
 	fpregs_lock();
 
@@ -406,10 +406,18 @@ static int __fpu__restore_sig(void __use
 		u64 init_bv = xfeatures_mask_user() & ~user_xfeatures;
 
 		if (using_compacted_format()) {
+			/*
+			 * copy_user_to_xstate() may write complete garbage
+			 * to the user states, but it will not corrupt the
+			 * XSAVE header, nor will it corrupt any supervisor
+			 * states.
+			 */
 			ret = copy_user_to_xstate(&fpu->state.xsave, buf_fx);
 		} else {
 			ret = __copy_from_user(&fpu->state.xsave, buf_fx, state_size);
-
+			/*
+			 * Careful, the XSAVE header may be corrupt now.
+			 */
 			if (!ret && state_size > offsetof(struct xregs_state, header))
 				ret = validate_user_xstate_header(&fpu->state.xsave.header);
 		}
@@ -457,6 +465,15 @@ static int __fpu__restore_sig(void __use
 		fpregs_lock();
 		ret = copy_kernel_to_fregs_err(&fpu->state.fsave);
 	}
+
+	/*
+	 * At this point, we have modified the hardware FPU regs.  We must
+	 * either mark them active for current or invalidate them for
+	 * any other task that may have owned them.
+	 *
+	 * Yes, the nonsensically named fpregs_deactivate() function
+	 * ignores its parameter and marks this CPU's regs invalid.
+	 */
 	if (!ret)
 		fpregs_mark_activate();
 	else
@@ -465,7 +482,7 @@ static int __fpu__restore_sig(void __use
 
 err_out:
 	if (ret)
-		fpu__clear_user_states(fpu);
+		fpu__handle_sig_restore_fail(fpu);
 	return ret;
 }
 







