Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644AE39CBDF
	for <lists+stable@lfdr.de>; Sun,  6 Jun 2021 02:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhFFAeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Jun 2021 20:34:15 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:32984 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbhFFAeN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Jun 2021 20:34:13 -0400
Message-Id: <20210606001323.322361712@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622939543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=w2Xumy/rtK5QoqT4f2Tnf/imsYWuYuiwFBdOvm2F8TA=;
        b=uKd5jkxegS0loy+5ksBg1yiDzZ1BvmuYn9puJ5C0gup64PNY5LywHmFooEUBaftiCP9qgZ
        yP6Z0FqO7T66YlKBraGpoAH15tmh3JwkBVxdTC8YgQ1H+DfaSRFK54i4o1AxiWuY19v/Gq
        9RoY7VW0WVS6TKYHsaiaOoQQ3rrLu51QFNBPAMOj/fX1xMeV8veQEM5GOMi4mxgySJ5mLm
        2diqPv5499BK7MVRyqzfPLwNOuMA/6qyoH1hG/ZArNe15Jyowmwin6K8rPUsNNG/ymTkP+
        7UJiheEv7YEVYpBuA8nZMD3BLk2c6ZrQrDqOhH30qxvz5vEZv/Aur4Ex4gt+kQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622939543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=w2Xumy/rtK5QoqT4f2Tnf/imsYWuYuiwFBdOvm2F8TA=;
        b=DcAVMuvc3KAWjKKVWpO5nzDwiDBCcsCwVgJ+Bfs7/PCZOhX+ALKB8CXgTt7vn40JVMPWEg
        qJ4VNVWRtx9HJIDg==
Date:   Sun, 06 Jun 2021 01:47:46 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        stable@vger.kernel.org
Subject: [patch V2 04/14] x86/pkru: Make the fpinit state update work
References: <20210605234742.712464974@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It's unclear how this ever made any difference because
init_fpstate.xsave.header.xfeatures is always 0 so get_xsave_addr() will
always return a NULL pointer.

Fix this by:

 - Creating a propagation function instead of several open coded instances
   and invoke it only once after the boot CPU has been initialized and from
   the debugfs file write function.

 - Set the PKRU feature bit in init_fpstate.xsave.header.xfeatures to make
   get_xsave_addr() work which allows to store the default value for real.

 - Having the feature bit set also gets rid of copy_init_pkru_to_fpregs()
   because now copy_init_fpstate_to_fpregs() already loads the default PKRU
   value.

Fixes: a5eff7259790 ("x86/pkeys: Add PKRU value to init_fpstate")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
---
V2: New patch
--- 
 arch/x86/include/asm/pkeys.h |    3 ++-
 arch/x86/kernel/cpu/bugs.c   |    3 +++
 arch/x86/kernel/cpu/common.c |    5 -----
 arch/x86/kernel/fpu/core.c   |    3 ---
 arch/x86/mm/pkeys.c          |   31 ++++++++++++++-----------------
 include/linux/pkeys.h        |    2 +-
 6 files changed, 20 insertions(+), 27 deletions(-)

--- a/arch/x86/include/asm/pkeys.h
+++ b/arch/x86/include/asm/pkeys.h
@@ -124,7 +124,8 @@ extern int arch_set_user_pkey_access(str
 		unsigned long init_val);
 extern int __arch_set_user_pkey_access(struct task_struct *tsk, int pkey,
 		unsigned long init_val);
-extern void copy_init_pkru_to_fpregs(void);
+
+extern void pkru_propagate_default(void);
 
 static inline int vma_pkey(struct vm_area_struct *vma)
 {
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -16,6 +16,7 @@
 #include <linux/prctl.h>
 #include <linux/sched/smt.h>
 #include <linux/pgtable.h>
+#include <linux/pkeys.h>
 
 #include <asm/spec-ctrl.h>
 #include <asm/cmdline.h>
@@ -120,6 +121,8 @@ void __init check_bugs(void)
 
 	arch_smt_update();
 
+	pkru_propagate_default();
+
 #ifdef CONFIG_X86_32
 	/*
 	 * Check whether we are able to run this kernel safely on SMP.
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -465,8 +465,6 @@ static bool pku_disabled;
 
 static __always_inline void setup_pku(struct cpuinfo_x86 *c)
 {
-	struct pkru_state *pk;
-
 	/* check the boot processor, plus compile options for PKU: */
 	if (!cpu_feature_enabled(X86_FEATURE_PKU))
 		return;
@@ -477,9 +475,6 @@ static __always_inline void setup_pku(st
 		return;
 
 	cr4_set_bits(X86_CR4_PKE);
-	pk = get_xsave_addr(&init_fpstate.xsave, XFEATURE_PKRU);
-	if (pk)
-		pk->pkru = init_pkru_value;
 	/*
 	 * Setting X86_CR4_PKE will cause the X86_FEATURE_OSPKE
 	 * cpuid bit to be set.  We need to ensure that we
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -348,9 +348,6 @@ static inline void copy_init_fpstate_to_
 		copy_kernel_to_fxregs(&init_fpstate.fxsave);
 	else
 		copy_kernel_to_fregs(&init_fpstate.fsave);
-
-	if (boot_cpu_has(X86_FEATURE_OSPKE))
-		copy_init_pkru_to_fpregs();
 }
 
 /*
--- a/arch/x86/mm/pkeys.c
+++ b/arch/x86/mm/pkeys.c
@@ -125,20 +125,20 @@ u32 init_pkru_value = PKRU_AD_KEY( 1) |
 		      PKRU_AD_KEY(10) | PKRU_AD_KEY(11) | PKRU_AD_KEY(12) |
 		      PKRU_AD_KEY(13) | PKRU_AD_KEY(14) | PKRU_AD_KEY(15);
 
-/*
- * Called from the FPU code when creating a fresh set of FPU
- * registers.  This is called from a very specific context where
- * we know the FPU registers are safe for use and we can use PKRU
- * directly.
- */
-void copy_init_pkru_to_fpregs(void)
+void pkru_propagate_default(void)
 {
-	u32 init_pkru_value_snapshot = READ_ONCE(init_pkru_value);
+	struct pkru_state *pk;
+
+	if (!boot_cpu_has(X86_FEATURE_OSPKE))
+		return;
 	/*
-	 * Override the PKRU state that came from 'init_fpstate'
-	 * with the baseline from the process.
+	 * Force XFEATURE_PKRU to be set in the header otherwise
+	 * get_xsave_addr() does not work and it needs to be set
+	 * to make XRSTOR(S) load it.
 	 */
-	write_pkru(init_pkru_value_snapshot);
+	init_fpstate.xsave.header.xfeatures |= XFEATURE_MASK_PKRU;
+	pk = get_xsave_addr(&init_fpstate.xsave, XFEATURE_PKRU);
+	pk->pkru = READ_ONCE(init_pkru_value);
 }
 
 static ssize_t init_pkru_read_file(struct file *file, char __user *user_buf,
@@ -154,10 +154,9 @@ static ssize_t init_pkru_read_file(struc
 static ssize_t init_pkru_write_file(struct file *file,
 		 const char __user *user_buf, size_t count, loff_t *ppos)
 {
-	struct pkru_state *pk;
+	u32 new_init_pkru;
 	char buf[32];
 	ssize_t len;
-	u32 new_init_pkru;
 
 	len = min(count, sizeof(buf) - 1);
 	if (copy_from_user(buf, user_buf, len))
@@ -177,10 +176,8 @@ static ssize_t init_pkru_write_file(stru
 		return -EINVAL;
 
 	WRITE_ONCE(init_pkru_value, new_init_pkru);
-	pk = get_xsave_addr(&init_fpstate.xsave, XFEATURE_PKRU);
-	if (!pk)
-		return -EINVAL;
-	pk->pkru = new_init_pkru;
+
+	pkru_propagate_default();
 	return count;
 }
 
--- a/include/linux/pkeys.h
+++ b/include/linux/pkeys.h
@@ -44,7 +44,7 @@ static inline bool arch_pkeys_enabled(vo
 	return false;
 }
 
-static inline void copy_init_pkru_to_fpregs(void)
+static inline void pkru_propagate_default(void)
 {
 }
 

