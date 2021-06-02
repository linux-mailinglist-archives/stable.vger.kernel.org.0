Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7255A3993E0
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 21:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhFBTvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Jun 2021 15:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbhFBTvL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Jun 2021 15:51:11 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74EA7C06175F;
        Wed,  2 Jun 2021 12:49:23 -0700 (PDT)
Date:   Wed, 02 Jun 2021 19:49:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622663361;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wq1DiU17V6QVP4P7QNg4Y5vGsgcYnSpWD7mlO5ygWbo=;
        b=HMvNl5honnxjr7X+Q/d7ps2GGLyG4UJlxVztuZJVCTR2qb58LBG4chV8wBowt8ApnWq2XU
        dRUwYBOl3Hg2pRNNEP7Xl/DTQVeVyWfg+Y3IfJ67L8xWgKv43QCpCRf+K78JdZ9sTzImti
        ogkBsgEHMMoVEDpWupy3WfPcKXvPallaTq+W3F0gdtP0/vRDerKWWYdyuExnhfmfYhtBYP
        8UJcL9z2AFFXGMR+go955ZnGJEEjD2Uy671upV423NWc6XQq1NGIeQIxmJ/tudZG9Vua54
        XM1yKziuARbfb8/Rb5FR1wVuergR9MiM58tyI1qwWUvrNN3WxG6rzxtxQ6Bimw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622663361;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wq1DiU17V6QVP4P7QNg4Y5vGsgcYnSpWD7mlO5ygWbo=;
        b=MgHlh9GB+5bCSILAsU64NmAqL2YFXap5KFzZmWOSK/gF06pmpP7hE/mwS69IIAT+HFcJLp
        n5mLF+aDGxPx1GBA==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/cpufeatures: Force disable X86_FEATURE_ENQCMD
 and remove update_pasid()
Cc:     Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <87mtsd6gr9.ffs@nanos.tec.linutronix.de>
References: <87mtsd6gr9.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Message-ID: <162266336080.29796.8357995289642365045.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     6867ee8bcb754c59a8304f4a9d693ed6cfb96b31
Gitweb:        https://git.kernel.org/tip/6867ee8bcb754c59a8304f4a9d693ed6cfb96b31
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Sat, 29 May 2021 11:17:30 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 02 Jun 2021 12:29:00 +02:00

x86/cpufeatures: Force disable X86_FEATURE_ENQCMD and remove update_pasid()

While digesting the XSAVE-related horrors which got introduced with
the supervisor/user split, the recent addition of ENQCMD-related
functionality got on the radar and turned out to be similarly broken.

update_pasid(), which is only required when X86_FEATURE_ENQCMD is
available, is invoked from two places:

 1) From switch_to() for the incoming task

 2) Via a SMP function call from the IOMMU/SMV code

#1 is half-ways correct as it hacks around the brokenness of get_xsave_addr()
   by enforcing the state to be 'present', but all the conditionals in that
   code are completely pointless for that.

   Also the invocation is just useless overhead because at that point
   it's guaranteed that TIF_NEED_FPU_LOAD is set on the incoming task
   and all of this can be handled at return to user space.

#2 is broken beyond repair. The comment in the code claims that it is safe
   to invoke this in an IPI, but that's just wishful thinking.

   FPU state of a running task is protected by fregs_lock() which is
   nothing else than a local_bh_disable(). As BH-disabled regions run
   usually with interrupts enabled the IPI can hit a code section which
   modifies FPU state and there is absolutely no guarantee that any of the
   assumptions which are made for the IPI case is true.

   Also the IPI is sent to all CPUs in mm_cpumask(mm), but the IPI is
   invoked with a NULL pointer argument, so it can hit a completely
   unrelated task and unconditionally force an update for nothing.
   Worse, it can hit a kernel thread which operates on a user space
   address space and set a random PASID for it.

The offending commit does not cleanly revert, but it's sufficient to
force disable X86_FEATURE_ENQCMD and to remove the broken update_pasid()
code to make this dysfunctional all over the place. Anything more
complex would require more surgery and none of the related functions
outside of the x86 core code are blatantly wrong, so removing those
would be overkill.

As nothing enables the PASID bit in the IA32_XSS MSR yet, which is
required to make this actually work, this cannot result in a regression
except for related out of tree train-wrecks, but they are broken already
today.

Fixes: 20f0afd1fb3d ("x86/mmu: Allocate/free a PASID")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Andy Lutomirski <luto@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/87mtsd6gr9.ffs@nanos.tec.linutronix.de
---
 arch/x86/include/asm/disabled-features.h |  7 +---
 arch/x86/include/asm/fpu/api.h           |  6 +--
 arch/x86/include/asm/fpu/internal.h      |  7 +---
 arch/x86/kernel/fpu/xstate.c             | 57 +-----------------------
 4 files changed, 3 insertions(+), 74 deletions(-)

diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index b7dd944..8f28faf 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -56,11 +56,8 @@
 # define DISABLE_PTI		(1 << (X86_FEATURE_PTI & 31))
 #endif
 
-#ifdef CONFIG_IOMMU_SUPPORT
-# define DISABLE_ENQCMD	0
-#else
-# define DISABLE_ENQCMD (1 << (X86_FEATURE_ENQCMD & 31))
-#endif
+/* Force disable because it's broken beyond repair */
+#define DISABLE_ENQCMD		(1 << (X86_FEATURE_ENQCMD & 31))
 
 #ifdef CONFIG_X86_SGX
 # define DISABLE_SGX	0
diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index ed33a14..23bef08 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -106,10 +106,6 @@ extern int cpu_has_xfeatures(u64 xfeatures_mask, const char **feature_name);
  */
 #define PASID_DISABLED	0
 
-#ifdef CONFIG_IOMMU_SUPPORT
-/* Update current's PASID MSR/state by mm's PASID. */
-void update_pasid(void);
-#else
 static inline void update_pasid(void) { }
-#endif
+
 #endif /* _ASM_X86_FPU_API_H */
diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index 8d33ad8..ceeba9f 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -584,13 +584,6 @@ static inline void switch_fpu_finish(struct fpu *new_fpu)
 			pkru_val = pk->pkru;
 	}
 	__write_pkru(pkru_val);
-
-	/*
-	 * Expensive PASID MSR write will be avoided in update_pasid() because
-	 * TIF_NEED_FPU_LOAD was set. And the PASID state won't be updated
-	 * unless it's different from mm->pasid to reduce overhead.
-	 */
-	update_pasid();
 }
 
 #endif /* _ASM_X86_FPU_INTERNAL_H */
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index a85c640..d0eef96 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1402,60 +1402,3 @@ int proc_pid_arch_status(struct seq_file *m, struct pid_namespace *ns,
 	return 0;
 }
 #endif /* CONFIG_PROC_PID_ARCH_STATUS */
-
-#ifdef CONFIG_IOMMU_SUPPORT
-void update_pasid(void)
-{
-	u64 pasid_state;
-	u32 pasid;
-
-	if (!cpu_feature_enabled(X86_FEATURE_ENQCMD))
-		return;
-
-	if (!current->mm)
-		return;
-
-	pasid = READ_ONCE(current->mm->pasid);
-	/* Set the valid bit in the PASID MSR/state only for valid pasid. */
-	pasid_state = pasid == PASID_DISABLED ?
-		      pasid : pasid | MSR_IA32_PASID_VALID;
-
-	/*
-	 * No need to hold fregs_lock() since the task's fpstate won't
-	 * be changed by others (e.g. ptrace) while the task is being
-	 * switched to or is in IPI.
-	 */
-	if (!test_thread_flag(TIF_NEED_FPU_LOAD)) {
-		/* The MSR is active and can be directly updated. */
-		wrmsrl(MSR_IA32_PASID, pasid_state);
-	} else {
-		struct fpu *fpu = &current->thread.fpu;
-		struct ia32_pasid_state *ppasid_state;
-		struct xregs_state *xsave;
-
-		/*
-		 * The CPU's xstate registers are not currently active. Just
-		 * update the PASID state in the memory buffer here. The
-		 * PASID MSR will be loaded when returning to user mode.
-		 */
-		xsave = &fpu->state.xsave;
-		xsave->header.xfeatures |= XFEATURE_MASK_PASID;
-		ppasid_state = get_xsave_addr(xsave, XFEATURE_PASID);
-		/*
-		 * Since XFEATURE_MASK_PASID is set in xfeatures, ppasid_state
-		 * won't be NULL and no need to check its value.
-		 *
-		 * Only update the task's PASID state when it's different
-		 * from the mm's pasid.
-		 */
-		if (ppasid_state->pasid != pasid_state) {
-			/*
-			 * Invalid fpregs so that state restoring will pick up
-			 * the PASID state.
-			 */
-			__fpu_invalidate_fpregs_state(fpu);
-			ppasid_state->pasid = pasid_state;
-		}
-	}
-}
-#endif /* CONFIG_IOMMU_SUPPORT */
