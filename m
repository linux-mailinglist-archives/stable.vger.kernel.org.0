Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 065CF59A472
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353816AbiHSQqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353937AbiHSQpb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:45:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514ED112FA3;
        Fri, 19 Aug 2022 09:11:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 618496182A;
        Fri, 19 Aug 2022 16:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C1BEC433C1;
        Fri, 19 Aug 2022 16:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925458;
        bh=PkHviObgBLy8JPi3KcjuCdVQdEyBgWUtmJpUkxhp7fA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KL+EN4O25200l+zPKDjRRoOfFHM8NiMKaHPaNp0bZ5nzJpmYiz9eOjz2LBVQRS8Th
         JX/IchMVv5OTZ147k43u8oYXgGLul+FUzXhfvJFD3LC17Lt0NW5GzHi1iSFibR/LSC
         GzGDZ2YNNf7nxf7O+JFTH/1/BYGqfhwPOYyzi6wY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 497/545] KVM: PPC: Book3S HV: Remove virt mode checks from real mode handlers
Date:   Fri, 19 Aug 2022 17:44:27 +0200
Message-Id: <20220819153851.727587818@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit dcbac73a5b374873bd6dfd8a0ee5d0b7fc844420 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/kvm_ppc.h      | 10 +--
 arch/powerpc/kvm/book3s.c               | 11 +--
 arch/powerpc/kvm/book3s_64_vio_hv.c     | 12 ----
 arch/powerpc/kvm/book3s_hv_builtin.c    | 91 ++++++-------------------
 arch/powerpc/kvm/book3s_hv_rmhandlers.S |  2 +-
 arch/powerpc/kvm/book3s_xive.c          | 18 -----
 arch/powerpc/kvm/book3s_xive.h          |  7 --
 arch/powerpc/kvm/book3s_xive_native.c   | 10 ---
 8 files changed, 23 insertions(+), 138 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 0a056c64c317..ec18d9b01625 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -654,8 +654,6 @@ extern int kvmppc_xive_get_xive(struct kvm *kvm, u32 irq, u32 *server,
 				u32 *priority);
 extern int kvmppc_xive_int_on(struct kvm *kvm, u32 irq);
 extern int kvmppc_xive_int_off(struct kvm *kvm, u32 irq);
-extern void kvmppc_xive_init_module(void);
-extern void kvmppc_xive_exit_module(void);
 
 extern int kvmppc_xive_connect_vcpu(struct kvm_device *dev,
 				    struct kvm_vcpu *vcpu, u32 cpu);
@@ -679,8 +677,6 @@ static inline int kvmppc_xive_enabled(struct kvm_vcpu *vcpu)
 extern int kvmppc_xive_native_connect_vcpu(struct kvm_device *dev,
 					   struct kvm_vcpu *vcpu, u32 cpu);
 extern void kvmppc_xive_native_cleanup_vcpu(struct kvm_vcpu *vcpu);
-extern void kvmppc_xive_native_init_module(void);
-extern void kvmppc_xive_native_exit_module(void);
 extern int kvmppc_xive_native_get_vp(struct kvm_vcpu *vcpu,
 				     union kvmppc_one_reg *val);
 extern int kvmppc_xive_native_set_vp(struct kvm_vcpu *vcpu,
@@ -694,8 +690,6 @@ static inline int kvmppc_xive_get_xive(struct kvm *kvm, u32 irq, u32 *server,
 				       u32 *priority) { return -1; }
 static inline int kvmppc_xive_int_on(struct kvm *kvm, u32 irq) { return -1; }
 static inline int kvmppc_xive_int_off(struct kvm *kvm, u32 irq) { return -1; }
-static inline void kvmppc_xive_init_module(void) { }
-static inline void kvmppc_xive_exit_module(void) { }
 
 static inline int kvmppc_xive_connect_vcpu(struct kvm_device *dev,
 					   struct kvm_vcpu *vcpu, u32 cpu) { return -EBUSY; }
@@ -716,8 +710,6 @@ static inline int kvmppc_xive_enabled(struct kvm_vcpu *vcpu)
 static inline int kvmppc_xive_native_connect_vcpu(struct kvm_device *dev,
 			  struct kvm_vcpu *vcpu, u32 cpu) { return -EBUSY; }
 static inline void kvmppc_xive_native_cleanup_vcpu(struct kvm_vcpu *vcpu) { }
-static inline void kvmppc_xive_native_init_module(void) { }
-static inline void kvmppc_xive_native_exit_module(void) { }
 static inline int kvmppc_xive_native_get_vp(struct kvm_vcpu *vcpu,
 					    union kvmppc_one_reg *val)
 { return 0; }
@@ -753,7 +745,7 @@ long kvmppc_rm_h_stuff_tce(struct kvm_vcpu *vcpu,
 			   unsigned long tce_value, unsigned long npages);
 long int kvmppc_rm_h_confer(struct kvm_vcpu *vcpu, int target,
                             unsigned int yield_count);
-long kvmppc_h_random(struct kvm_vcpu *vcpu);
+long kvmppc_rm_h_random(struct kvm_vcpu *vcpu);
 void kvmhv_commence_exit(int trap);
 void kvmppc_realmode_machine_check(struct kvm_vcpu *vcpu);
 void kvmppc_subcore_enter_guest(void);
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 44bf567b6589..1888aedfd410 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -1046,13 +1046,10 @@ static int kvmppc_book3s_init(void)
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
@@ -1062,12 +1059,6 @@ static int kvmppc_book3s_init(void)
 
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
index 57af53a6a2d8..5f8573774383 100644
--- a/arch/powerpc/kvm/book3s_64_vio_hv.c
+++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
@@ -404,10 +404,6 @@ long kvmppc_rm_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
 	/* udbg_printf("H_PUT_TCE(): liobn=0x%lx ioba=0x%lx, tce=0x%lx\n", */
 	/* 	    liobn, ioba, tce); */
 
-	/* For radix, we might be in virtual mode, so punt */
-	if (kvm_is_radix(vcpu->kvm))
-		return H_TOO_HARD;
-
 	stt = kvmppc_find_table(vcpu->kvm, liobn);
 	if (!stt)
 		return H_TOO_HARD;
@@ -500,10 +496,6 @@ long kvmppc_rm_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 	bool prereg = false;
 	struct kvmppc_spapr_tce_iommu_table *stit;
 
-	/* For radix, we might be in virtual mode, so punt */
-	if (kvm_is_radix(vcpu->kvm))
-		return H_TOO_HARD;
-
 	/*
 	 * used to check for invalidations in progress
 	 */
@@ -609,10 +601,6 @@ long kvmppc_rm_h_stuff_tce(struct kvm_vcpu *vcpu,
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
index 121fca2bcd82..856a04ca833c 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -33,21 +33,6 @@
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
@@ -195,16 +180,9 @@ int kvmppc_hwrng_present(void)
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
@@ -557,22 +535,13 @@ static long kvmppc_read_one_intr(bool *again)
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
 
@@ -581,13 +550,9 @@ unsigned long kvmppc_rm_h_xirr_x(struct kvm_vcpu *vcpu)
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
 
@@ -595,13 +560,9 @@ unsigned long kvmppc_rm_h_ipoll(struct kvm_vcpu *vcpu, unsigned long server)
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
 
@@ -610,13 +571,9 @@ int kvmppc_rm_h_ipi(struct kvm_vcpu *vcpu, unsigned long server,
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
 
@@ -624,13 +581,9 @@ int kvmppc_rm_h_cppr(struct kvm_vcpu *vcpu, unsigned long cppr)
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
 
@@ -638,13 +591,9 @@ int kvmppc_rm_h_eoi(struct kvm_vcpu *vcpu, unsigned long xirr)
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
index b1d9afffd841..274d62efa866 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -2535,7 +2535,7 @@ hcall_real_table:
 #else
 	.long	0		/* 0x2fc - H_XIRR_X*/
 #endif
-	.long	DOTSYM(kvmppc_h_random) - hcall_real_table
+	.long	DOTSYM(kvmppc_rm_h_random) - hcall_real_table
 	.globl	hcall_real_table_end
 hcall_real_table_end:
 
diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
index a0ebc29f30b2..8dfda8e01ac1 100644
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -2245,21 +2245,3 @@ struct kvm_device_ops kvm_xive_ops = {
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
index 382e3a56e789..8504389b130e 100644
--- a/arch/powerpc/kvm/book3s_xive.h
+++ b/arch/powerpc/kvm/book3s_xive.h
@@ -278,13 +278,6 @@ extern int xive_rm_h_ipi(struct kvm_vcpu *vcpu, unsigned long server,
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
index a59a94f02733..4b00d4efb709 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -1271,13 +1271,3 @@ struct kvm_device_ops kvm_xive_native_ops = {
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
-- 
2.35.1



