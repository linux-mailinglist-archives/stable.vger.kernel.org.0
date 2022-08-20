Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D9D59B271
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 09:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiHUHBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 03:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbiHUHAv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 03:00:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6D324F32
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 00:00:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBA58B80BA7
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 07:00:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238CCC433C1;
        Sun, 21 Aug 2022 07:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661065246;
        bh=9Gkbi30wZwP2y1UD4m/oTzkLlra+AfsJKAc2l0dvziU=;
        h=Subject:To:Cc:From:Date:From;
        b=1TzCCKWoOQ23fs9N+U6edc+zrUTj7q1tvDI52S1kByvVfi/mkeXWqqVELisrQab7B
         sMwjBJW93yoH0hzbBRglBSzPlSf3liym1cQ6pom/aRI8E10xBFkbmlPxSaPmDXeskf
         zSoYjKW9XAg+kDOjsk0UKVt6bf4VgSSHNXrKKMfI=
Subject: FAILED: patch "[PATCH] KVM: PPC: Book3S HV: Remove virt mode checks from real mode" failed to apply to 5.10-stable tree
To:     npiggin@gmail.com, clg@kaod.org, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 20 Aug 2022 20:27:18 +0200
Message-ID: <166102003817493@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From dcbac73a5b374873bd6dfd8a0ee5d0b7fc844420 Mon Sep 17 00:00:00 2001
From: Nicholas Piggin <npiggin@gmail.com>
Date: Fri, 28 May 2021 19:07:44 +1000
Subject: [PATCH] KVM: PPC: Book3S HV: Remove virt mode checks from real mode
 handlers
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Now that the P7/8 path no longer supports radix, real-mode handlers
do not need to deal with being called in virt mode.

This change effectively reverts commit acde25726bc6 ("KVM: PPC: Book3S
HV: Add radix checks in real-mode hypercall handlers").

It removes a few more real-mode tests in rm hcall handlers, which
allows the indirect ops for the xive module to be removed from the
built-in xics rm handlers.

kvmppc_h_random is renamed to kvmppc_rm_h_random to be a bit more
descriptive and consistent with other rm handlers.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210528090752.3542186-25-npiggin@gmail.com

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index cb9e3c85c605..2d88944f9f34 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -659,8 +659,6 @@ extern int kvmppc_xive_get_xive(struct kvm *kvm, u32 irq, u32 *server,
 				u32 *priority);
 extern int kvmppc_xive_int_on(struct kvm *kvm, u32 irq);
 extern int kvmppc_xive_int_off(struct kvm *kvm, u32 irq);
-extern void kvmppc_xive_init_module(void);
-extern void kvmppc_xive_exit_module(void);
 
 extern int kvmppc_xive_connect_vcpu(struct kvm_device *dev,
 				    struct kvm_vcpu *vcpu, u32 cpu);
@@ -686,8 +684,6 @@ static inline int kvmppc_xive_enabled(struct kvm_vcpu *vcpu)
 extern int kvmppc_xive_native_connect_vcpu(struct kvm_device *dev,
 					   struct kvm_vcpu *vcpu, u32 cpu);
 extern void kvmppc_xive_native_cleanup_vcpu(struct kvm_vcpu *vcpu);
-extern void kvmppc_xive_native_init_module(void);
-extern void kvmppc_xive_native_exit_module(void);
 extern int kvmppc_xive_native_get_vp(struct kvm_vcpu *vcpu,
 				     union kvmppc_one_reg *val);
 extern int kvmppc_xive_native_set_vp(struct kvm_vcpu *vcpu,
@@ -701,8 +697,6 @@ static inline int kvmppc_xive_get_xive(struct kvm *kvm, u32 irq, u32 *server,
 				       u32 *priority) { return -1; }
 static inline int kvmppc_xive_int_on(struct kvm *kvm, u32 irq) { return -1; }
 static inline int kvmppc_xive_int_off(struct kvm *kvm, u32 irq) { return -1; }
-static inline void kvmppc_xive_init_module(void) { }
-static inline void kvmppc_xive_exit_module(void) { }
 
 static inline int kvmppc_xive_connect_vcpu(struct kvm_device *dev,
 					   struct kvm_vcpu *vcpu, u32 cpu) { return -EBUSY; }
@@ -725,8 +719,6 @@ static inline int kvmppc_xive_enabled(struct kvm_vcpu *vcpu)
 static inline int kvmppc_xive_native_connect_vcpu(struct kvm_device *dev,
 			  struct kvm_vcpu *vcpu, u32 cpu) { return -EBUSY; }
 static inline void kvmppc_xive_native_cleanup_vcpu(struct kvm_vcpu *vcpu) { }
-static inline void kvmppc_xive_native_init_module(void) { }
-static inline void kvmppc_xive_native_exit_module(void) { }
 static inline int kvmppc_xive_native_get_vp(struct kvm_vcpu *vcpu,
 					    union kvmppc_one_reg *val)
 { return 0; }
@@ -762,7 +754,7 @@ long kvmppc_rm_h_stuff_tce(struct kvm_vcpu *vcpu,
 			   unsigned long tce_value, unsigned long npages);
 long int kvmppc_rm_h_confer(struct kvm_vcpu *vcpu, int target,
                             unsigned int yield_count);
-long kvmppc_h_random(struct kvm_vcpu *vcpu);
+long kvmppc_rm_h_random(struct kvm_vcpu *vcpu);
 void kvmhv_commence_exit(int trap);
 void kvmppc_realmode_machine_check(struct kvm_vcpu *vcpu);
 void kvmppc_subcore_enter_guest(void);
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index d69560d5bf16..5e1e1cff0ee3 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -1050,13 +1050,10 @@ static int kvmppc_book3s_init(void)
 #ifdef CONFIG_KVM_XICS
 #ifdef CONFIG_KVM_XIVE
 	if (xics_on_xive()) {
-		kvmppc_xive_init_module();
 		kvm_register_device_ops(&kvm_xive_ops, KVM_DEV_TYPE_XICS);
-		if (kvmppc_xive_native_supported()) {
-			kvmppc_xive_native_init_module();
+		if (kvmppc_xive_native_supported())
 			kvm_register_device_ops(&kvm_xive_native_ops,
 						KVM_DEV_TYPE_XIVE);
-		}
 	} else
 #endif
 		kvm_register_device_ops(&kvm_xics_ops, KVM_DEV_TYPE_XICS);
@@ -1066,12 +1063,6 @@ static int kvmppc_book3s_init(void)
 
 static void kvmppc_book3s_exit(void)
 {
-#ifdef CONFIG_KVM_XICS
-	if (xics_on_xive()) {
-		kvmppc_xive_exit_module();
-		kvmppc_xive_native_exit_module();
-	}
-#endif
 #ifdef CONFIG_KVM_BOOK3S_32_HANDLER
 	kvmppc_book3s_exit_pr();
 #endif
diff --git a/arch/powerpc/kvm/book3s_64_vio_hv.c b/arch/powerpc/kvm/book3s_64_vio_hv.c
index 083a4e037718..dc6591548f0c 100644
--- a/arch/powerpc/kvm/book3s_64_vio_hv.c
+++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
@@ -391,10 +391,6 @@ long kvmppc_rm_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
 	/* udbg_printf("H_PUT_TCE(): liobn=0x%lx ioba=0x%lx, tce=0x%lx\n", */
 	/* 	    liobn, ioba, tce); */
 
-	/* For radix, we might be in virtual mode, so punt */
-	if (kvm_is_radix(vcpu->kvm))
-		return H_TOO_HARD;
-
 	stt = kvmppc_find_table(vcpu->kvm, liobn);
 	if (!stt)
 		return H_TOO_HARD;
@@ -489,10 +485,6 @@ long kvmppc_rm_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 	bool prereg = false;
 	struct kvmppc_spapr_tce_iommu_table *stit;
 
-	/* For radix, we might be in virtual mode, so punt */
-	if (kvm_is_radix(vcpu->kvm))
-		return H_TOO_HARD;
-
 	/*
 	 * used to check for invalidations in progress
 	 */
@@ -602,10 +594,6 @@ long kvmppc_rm_h_stuff_tce(struct kvm_vcpu *vcpu,
 	long i, ret;
 	struct kvmppc_spapr_tce_iommu_table *stit;
 
-	/* For radix, we might be in virtual mode, so punt */
-	if (kvm_is_radix(vcpu->kvm))
-		return H_TOO_HARD;
-
 	stt = kvmppc_find_table(vcpu->kvm, liobn);
 	if (!stt)
 		return H_TOO_HARD;
diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
index 7a0e33a9c980..8d669a0e15f8 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -34,21 +34,6 @@
 #include "book3s_xics.h"
 #include "book3s_xive.h"
 
-/*
- * The XIVE module will populate these when it loads
- */
-unsigned long (*__xive_vm_h_xirr)(struct kvm_vcpu *vcpu);
-unsigned long (*__xive_vm_h_ipoll)(struct kvm_vcpu *vcpu, unsigned long server);
-int (*__xive_vm_h_ipi)(struct kvm_vcpu *vcpu, unsigned long server,
-		       unsigned long mfrr);
-int (*__xive_vm_h_cppr)(struct kvm_vcpu *vcpu, unsigned long cppr);
-int (*__xive_vm_h_eoi)(struct kvm_vcpu *vcpu, unsigned long xirr);
-EXPORT_SYMBOL_GPL(__xive_vm_h_xirr);
-EXPORT_SYMBOL_GPL(__xive_vm_h_ipoll);
-EXPORT_SYMBOL_GPL(__xive_vm_h_ipi);
-EXPORT_SYMBOL_GPL(__xive_vm_h_cppr);
-EXPORT_SYMBOL_GPL(__xive_vm_h_eoi);
-
 /*
  * Hash page table alignment on newer cpus(CPU_FTR_ARCH_206)
  * should be power of 2.
@@ -196,16 +181,9 @@ int kvmppc_hwrng_present(void)
 }
 EXPORT_SYMBOL_GPL(kvmppc_hwrng_present);
 
-long kvmppc_h_random(struct kvm_vcpu *vcpu)
+long kvmppc_rm_h_random(struct kvm_vcpu *vcpu)
 {
-	int r;
-
-	/* Only need to do the expensive mfmsr() on radix */
-	if (kvm_is_radix(vcpu->kvm) && (mfmsr() & MSR_IR))
-		r = powernv_get_random_long(&vcpu->arch.regs.gpr[4]);
-	else
-		r = powernv_get_random_real_mode(&vcpu->arch.regs.gpr[4]);
-	if (r)
+	if (powernv_get_random_real_mode(&vcpu->arch.regs.gpr[4]))
 		return H_SUCCESS;
 
 	return H_HARDWARE;
@@ -541,22 +519,13 @@ static long kvmppc_read_one_intr(bool *again)
 }
 
 #ifdef CONFIG_KVM_XICS
-static inline bool is_rm(void)
-{
-	return !(mfmsr() & MSR_DR);
-}
-
 unsigned long kvmppc_rm_h_xirr(struct kvm_vcpu *vcpu)
 {
 	if (!kvmppc_xics_enabled(vcpu))
 		return H_TOO_HARD;
-	if (xics_on_xive()) {
-		if (is_rm())
-			return xive_rm_h_xirr(vcpu);
-		if (unlikely(!__xive_vm_h_xirr))
-			return H_NOT_AVAILABLE;
-		return __xive_vm_h_xirr(vcpu);
-	} else
+	if (xics_on_xive())
+		return xive_rm_h_xirr(vcpu);
+	else
 		return xics_rm_h_xirr(vcpu);
 }
 
@@ -565,13 +534,9 @@ unsigned long kvmppc_rm_h_xirr_x(struct kvm_vcpu *vcpu)
 	if (!kvmppc_xics_enabled(vcpu))
 		return H_TOO_HARD;
 	vcpu->arch.regs.gpr[5] = get_tb();
-	if (xics_on_xive()) {
-		if (is_rm())
-			return xive_rm_h_xirr(vcpu);
-		if (unlikely(!__xive_vm_h_xirr))
-			return H_NOT_AVAILABLE;
-		return __xive_vm_h_xirr(vcpu);
-	} else
+	if (xics_on_xive())
+		return xive_rm_h_xirr(vcpu);
+	else
 		return xics_rm_h_xirr(vcpu);
 }
 
@@ -579,13 +544,9 @@ unsigned long kvmppc_rm_h_ipoll(struct kvm_vcpu *vcpu, unsigned long server)
 {
 	if (!kvmppc_xics_enabled(vcpu))
 		return H_TOO_HARD;
-	if (xics_on_xive()) {
-		if (is_rm())
-			return xive_rm_h_ipoll(vcpu, server);
-		if (unlikely(!__xive_vm_h_ipoll))
-			return H_NOT_AVAILABLE;
-		return __xive_vm_h_ipoll(vcpu, server);
-	} else
+	if (xics_on_xive())
+		return xive_rm_h_ipoll(vcpu, server);
+	else
 		return H_TOO_HARD;
 }
 
@@ -594,13 +555,9 @@ int kvmppc_rm_h_ipi(struct kvm_vcpu *vcpu, unsigned long server,
 {
 	if (!kvmppc_xics_enabled(vcpu))
 		return H_TOO_HARD;
-	if (xics_on_xive()) {
-		if (is_rm())
-			return xive_rm_h_ipi(vcpu, server, mfrr);
-		if (unlikely(!__xive_vm_h_ipi))
-			return H_NOT_AVAILABLE;
-		return __xive_vm_h_ipi(vcpu, server, mfrr);
-	} else
+	if (xics_on_xive())
+		return xive_rm_h_ipi(vcpu, server, mfrr);
+	else
 		return xics_rm_h_ipi(vcpu, server, mfrr);
 }
 
@@ -608,13 +565,9 @@ int kvmppc_rm_h_cppr(struct kvm_vcpu *vcpu, unsigned long cppr)
 {
 	if (!kvmppc_xics_enabled(vcpu))
 		return H_TOO_HARD;
-	if (xics_on_xive()) {
-		if (is_rm())
-			return xive_rm_h_cppr(vcpu, cppr);
-		if (unlikely(!__xive_vm_h_cppr))
-			return H_NOT_AVAILABLE;
-		return __xive_vm_h_cppr(vcpu, cppr);
-	} else
+	if (xics_on_xive())
+		return xive_rm_h_cppr(vcpu, cppr);
+	else
 		return xics_rm_h_cppr(vcpu, cppr);
 }
 
@@ -622,13 +575,9 @@ int kvmppc_rm_h_eoi(struct kvm_vcpu *vcpu, unsigned long xirr)
 {
 	if (!kvmppc_xics_enabled(vcpu))
 		return H_TOO_HARD;
-	if (xics_on_xive()) {
-		if (is_rm())
-			return xive_rm_h_eoi(vcpu, xirr);
-		if (unlikely(!__xive_vm_h_eoi))
-			return H_NOT_AVAILABLE;
-		return __xive_vm_h_eoi(vcpu, xirr);
-	} else
+	if (xics_on_xive())
+		return xive_rm_h_eoi(vcpu, xirr);
+	else
 		return xics_rm_h_eoi(vcpu, xirr);
 }
 #endif /* CONFIG_KVM_XICS */
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index bf441b9b03cb..33aa0ef496e5 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -2306,7 +2306,7 @@ hcall_real_table:
 #else
 	.long	0		/* 0x2fc - H_XIRR_X*/
 #endif
-	.long	DOTSYM(kvmppc_h_random) - hcall_real_table
+	.long	DOTSYM(kvmppc_rm_h_random) - hcall_real_table
 	.globl	hcall_real_table_end
 hcall_real_table_end:
 
diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
index 24c07094651a..9268d386b128 100644
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -2352,21 +2352,3 @@ struct kvm_device_ops kvm_xive_ops = {
 	.get_attr = xive_get_attr,
 	.has_attr = xive_has_attr,
 };
-
-void kvmppc_xive_init_module(void)
-{
-	__xive_vm_h_xirr = xive_vm_h_xirr;
-	__xive_vm_h_ipoll = xive_vm_h_ipoll;
-	__xive_vm_h_ipi = xive_vm_h_ipi;
-	__xive_vm_h_cppr = xive_vm_h_cppr;
-	__xive_vm_h_eoi = xive_vm_h_eoi;
-}
-
-void kvmppc_xive_exit_module(void)
-{
-	__xive_vm_h_xirr = NULL;
-	__xive_vm_h_ipoll = NULL;
-	__xive_vm_h_ipi = NULL;
-	__xive_vm_h_cppr = NULL;
-	__xive_vm_h_eoi = NULL;
-}
diff --git a/arch/powerpc/kvm/book3s_xive.h b/arch/powerpc/kvm/book3s_xive.h
index 86c24a4ad809..afe9eeac6d56 100644
--- a/arch/powerpc/kvm/book3s_xive.h
+++ b/arch/powerpc/kvm/book3s_xive.h
@@ -289,13 +289,6 @@ extern int xive_rm_h_ipi(struct kvm_vcpu *vcpu, unsigned long server,
 extern int xive_rm_h_cppr(struct kvm_vcpu *vcpu, unsigned long cppr);
 extern int xive_rm_h_eoi(struct kvm_vcpu *vcpu, unsigned long xirr);
 
-extern unsigned long (*__xive_vm_h_xirr)(struct kvm_vcpu *vcpu);
-extern unsigned long (*__xive_vm_h_ipoll)(struct kvm_vcpu *vcpu, unsigned long server);
-extern int (*__xive_vm_h_ipi)(struct kvm_vcpu *vcpu, unsigned long server,
-			      unsigned long mfrr);
-extern int (*__xive_vm_h_cppr)(struct kvm_vcpu *vcpu, unsigned long cppr);
-extern int (*__xive_vm_h_eoi)(struct kvm_vcpu *vcpu, unsigned long xirr);
-
 /*
  * Common Xive routines for XICS-over-XIVE and XIVE native
  */
diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
index 76800c84f2a3..1253666dd4d8 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -1281,13 +1281,3 @@ struct kvm_device_ops kvm_xive_native_ops = {
 	.has_attr = kvmppc_xive_native_has_attr,
 	.mmap = kvmppc_xive_native_mmap,
 };
-
-void kvmppc_xive_native_init_module(void)
-{
-	;
-}
-
-void kvmppc_xive_native_exit_module(void)
-{
-	;
-}

