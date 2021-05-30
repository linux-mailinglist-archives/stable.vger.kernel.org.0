Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F1B394FAD
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 07:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbhE3FNy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 01:13:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:57294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229495AbhE3FNv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 30 May 2021 01:13:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B17C5611AE;
        Sun, 30 May 2021 05:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622351532;
        bh=8hHiF7BQAmIs6EOyfFqGWrdu/sX/MdtEoPC5OPz7fJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DTtusVXssmJ2WYBh3L0i4BA9xTs9IPlnAWlh4H4rWSED0Nh8JD3Juxv3kb30JFypF
         XnI1TbhibcfgEJwWIaK3j0M2JtF23hwbRKACNS2PTl3E3UcCYojLmjW2duZS4XIlEF
         v/yK88Gjsu4nvP26q133yKdB66+vB/4v8D47G1+q923Txb22rI1W9en9KvHkaY7F99
         cynd+8ffofoI6G5RSp5nR9zNrBejHkwfQZALpsfNxZWqvzXSBaqFarxyzIitSBDm8v
         U+EeBDGindYxET8o8DTuaG2xPY3fKyJ585IIDRXV8sHzksoyL+TXhqUfnMccy43RIF
         oDYqlTh3aN+qw==
From:   Andy Lutomirski <luto@kernel.org>
To:     x86@kernel.org
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org,
        syzbot+2067e764dbcd10721e2e@syzkaller.appspotmail.com
Subject: [RFC v2 1/2] x86/fpu: Fix state corruption in __fpu__restore_sig()
Date:   Sat, 29 May 2021 22:12:09 -0700
Message-Id: <b69df1e42d1235996682178013f61d4120b3b361.1622351443.git.luto@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1622351443.git.luto@kernel.org>
References: <cover.1622351443.git.luto@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Prior to adding XSAVES support, some of fpu__clear()'s callers
required that fpu__clear() successfully reset current's FPU state
even if current's XSAVE header was corrupt.  commit b860eb8dce59
("x86/fpu/xstate: Define new functions for clearing fpregs and
xstates") split fpu__clear() into two different functions, neither
of which was capable of correctly handling a corrupt header.

As a practical matter, trying to specify what
fpu__clear_user_states() is supposed to do if current's XSAVE area
is corrupt is difficult -- it's supposed to preverve supervisor
states, but the entire XSAVES buffer may be unusable due to corrupt
XFEATURES and/or XCOMP_BV.

Improve the situation by completely separating fpu__clear_all() and
fpu__clear_user_states().  The former is, once again, a full reset.
The latter requires an intact header and resets only user states.
Update and document __fpu__restore_sig() accordingly.

Cc: stable@vger.kernel.org
Fixes: b860eb8dce59 ("x86/fpu/xstate: Define new functions for clearing fpregs and xstates")
Reported-by: syzbot+2067e764dbcd10721e2e@syzkaller.appspotmail.com
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/kernel/fpu/core.c   | 62 ++++++++++++++++++++++++------------
 arch/x86/kernel/fpu/signal.c | 50 +++++++++++++++++++++++++----
 2 files changed, 84 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 571220ac8bea..55792ef6ba6d 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -354,45 +354,65 @@ static inline void copy_init_fpstate_to_fpregs(u64 features_mask)
 }
 
 /*
- * Clear the FPU state back to init state.
- *
- * Called by sys_execve(), by the signal handler code and by various
- * error paths.
+ * Reset current's user FPU states to the init states.  The caller promises
+ * that current's supervisor states (in memory or CPU regs as appropriate)
+ * as well as the XSAVE header in memory are intact.
  */
-static void fpu__clear(struct fpu *fpu, bool user_only)
+void fpu__clear_user_states(struct fpu *fpu)
 {
 	WARN_ON_FPU(fpu != &current->thread.fpu);
 
 	if (!static_cpu_has(X86_FEATURE_FPU)) {
-		fpu__drop(fpu);
-		fpu__initialize(fpu);
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
-	}
+	/*
+	 * Ensure that current's supervisor states are loaded into
+	 * their corresponding registers.
+	 */
+	if (!fpregs_state_valid(fpu, smp_processor_id()) &&
+	    xfeatures_mask_supervisor())
+		copy_kernel_to_xregs(&fpu->state.xsave,
+				     xfeatures_mask_supervisor());
 
+	/*
+	 * Reset user states in registers.
+	 */
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
diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index a4ec65317a7f..3ff7e75c7b8f 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -345,6 +345,7 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 		 */
 		fpregs_lock();
 		pagefault_disable();
+
 		ret = copy_user_to_fpregs_zeroing(buf_fx, user_xfeatures, fx_only);
 		pagefault_enable();
 		if (!ret) {
@@ -382,10 +383,9 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
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
 
@@ -406,10 +406,18 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
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
@@ -457,6 +465,15 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
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
@@ -464,8 +481,27 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 	fpregs_unlock();
 
 err_out:
-	if (ret)
-		fpu__clear_user_states(fpu);
+	if (ret) {
+		if (using_compacted_format()) {
+			/*
+			 * Our failed attempt to load the new state is
+			 * guaranteed to have preserved the XSAVE header
+			 * and all supervisor state.
+			 */
+			fpu__clear_user_states(fpu);
+		} else {
+			/*
+			 * If an error above caused garbage to be written
+			 * to XFEATURES, then XSAVE would preserve that
+			 * garbage in memory, and a subsequent XRSTOR would
+			 * fail or worse.  XSAVES does not have this problem.
+			 *
+			 * Wipe out the FPU state and start over from a clean
+			 * slate.
+			 */
+			fpu__clear_all(fpu);
+		}
+	}
 	return ret;
 }
 
-- 
2.31.1

