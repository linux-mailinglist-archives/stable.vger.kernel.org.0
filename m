Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E77A608A7B
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234978AbiJVI5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234979AbiJVI4a (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:56:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2483641515;
        Sat, 22 Oct 2022 01:14:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB44D60AE9;
        Sat, 22 Oct 2022 07:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7AA8C433D7;
        Sat, 22 Oct 2022 07:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424237;
        bh=NFaMQHnoZ9KjOYZHCfJIJjOmo+xQqEzeKxhiyS9RSVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uazWaS8MKQUHUa51toi/A+f8lf7bQNgPhr8zP0kavl0sjeEmoidvEYBDnm7avVAZk
         kElw5IaRthnWFS+wSw5wo70O7TOOJvYwADSZpOOkefTL9zUqSwpgAlPousBM4oFMQE
         Wi0UhLKE4qbm3tDAxmtBCYYn0m5z1jttplqNx+iY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Collingbourne <pcc@google.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 5.19 072/717] arm64: mte: move register initialization to C
Date:   Sat, 22 Oct 2022 09:19:11 +0200
Message-Id: <20221022072427.951220482@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Collingbourne <pcc@google.com>

commit 973b9e37330656dec719ede508e4dc40e5c2d80c upstream.

If FEAT_MTE2 is disabled via the arm64.nomte command line argument on a
CPU that claims to support FEAT_MTE2, the kernel will use Tagged Normal
in the MAIR. If we interpret arm64.nomte to mean that the CPU does not
in fact implement FEAT_MTE2, setting the system register like this may
lead to UNSPECIFIED behavior. Fix it by arranging for MAIR to be set
in the C function cpu_enable_mte which is called based on the sanitized
version of the system register.

There is no need for the rest of the MTE-related system register
initialization to happen from assembly, with the exception of TCR_EL1,
which must be set to include at least TBI1 because the secondary CPUs
access KASan-allocated data structures early. Therefore, make the TCR_EL1
initialization unconditional and move the rest of the initialization to
cpu_enable_mte so that we no longer have a dependency on the unsanitized
ID register value.

Co-developed-by: Evgenii Stepanov <eugenis@google.com>
Signed-off-by: Peter Collingbourne <pcc@google.com>
Signed-off-by: Evgenii Stepanov <eugenis@google.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: kernel test robot <lkp@intel.com>
Fixes: 3b714d24ef17 ("arm64: mte: CPU feature detection and initial sysreg configuration")
Cc: <stable@vger.kernel.org> # 5.10.x
Link: https://lore.kernel.org/r/20220915222053.3484231-1-eugenis@google.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/mte.h   |    5 ++++
 arch/arm64/kernel/cpufeature.c |    3 +-
 arch/arm64/kernel/mte.c        |   51 +++++++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/suspend.c    |    2 +
 arch/arm64/mm/proc.S           |   46 ++++--------------------------------
 5 files changed, 65 insertions(+), 42 deletions(-)

--- a/arch/arm64/include/asm/mte.h
+++ b/arch/arm64/include/asm/mte.h
@@ -42,7 +42,9 @@ void mte_sync_tags(pte_t old_pte, pte_t
 void mte_copy_page_tags(void *kto, const void *kfrom);
 void mte_thread_init_user(void);
 void mte_thread_switch(struct task_struct *next);
+void mte_cpu_setup(void);
 void mte_suspend_enter(void);
+void mte_suspend_exit(void);
 long set_mte_ctrl(struct task_struct *task, unsigned long arg);
 long get_mte_ctrl(struct task_struct *task);
 int mte_ptrace_copy_tags(struct task_struct *child, long request,
@@ -72,6 +74,9 @@ static inline void mte_thread_switch(str
 static inline void mte_suspend_enter(void)
 {
 }
+static inline void mte_suspend_exit(void)
+{
+}
 static inline long set_mte_ctrl(struct task_struct *task, unsigned long arg)
 {
 	return 0;
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1962,7 +1962,8 @@ static void bti_enable(const struct arm6
 static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
 {
 	sysreg_clear_set(sctlr_el1, 0, SCTLR_ELx_ATA | SCTLR_EL1_ATA0);
-	isb();
+
+	mte_cpu_setup();
 
 	/*
 	 * Clear the tags in the zero page. This needs to be done via the
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -294,6 +294,49 @@ void mte_thread_switch(struct task_struc
 	mte_check_tfsr_el1();
 }
 
+void mte_cpu_setup(void)
+{
+	u64 rgsr;
+
+	/*
+	 * CnP must be enabled only after the MAIR_EL1 register has been set
+	 * up. Inconsistent MAIR_EL1 between CPUs sharing the same TLB may
+	 * lead to the wrong memory type being used for a brief window during
+	 * CPU power-up.
+	 *
+	 * CnP is not a boot feature so MTE gets enabled before CnP, but let's
+	 * make sure that is the case.
+	 */
+	BUG_ON(read_sysreg(ttbr0_el1) & TTBR_CNP_BIT);
+	BUG_ON(read_sysreg(ttbr1_el1) & TTBR_CNP_BIT);
+
+	/* Normal Tagged memory type at the corresponding MAIR index */
+	sysreg_clear_set(mair_el1,
+			 MAIR_ATTRIDX(MAIR_ATTR_MASK, MT_NORMAL_TAGGED),
+			 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_TAGGED,
+				      MT_NORMAL_TAGGED));
+
+	write_sysreg_s(KERNEL_GCR_EL1, SYS_GCR_EL1);
+
+	/*
+	 * If GCR_EL1.RRND=1 is implemented the same way as RRND=0, then
+	 * RGSR_EL1.SEED must be non-zero for IRG to produce
+	 * pseudorandom numbers. As RGSR_EL1 is UNKNOWN out of reset, we
+	 * must initialize it.
+	 */
+	rgsr = (read_sysreg(CNTVCT_EL0) & SYS_RGSR_EL1_SEED_MASK) <<
+	       SYS_RGSR_EL1_SEED_SHIFT;
+	if (rgsr == 0)
+		rgsr = 1 << SYS_RGSR_EL1_SEED_SHIFT;
+	write_sysreg_s(rgsr, SYS_RGSR_EL1);
+
+	/* clear any pending tag check faults in TFSR*_EL1 */
+	write_sysreg_s(0, SYS_TFSR_EL1);
+	write_sysreg_s(0, SYS_TFSRE0_EL1);
+
+	local_flush_tlb_all();
+}
+
 void mte_suspend_enter(void)
 {
 	if (!system_supports_mte())
@@ -310,6 +353,14 @@ void mte_suspend_enter(void)
 	mte_check_tfsr_el1();
 }
 
+void mte_suspend_exit(void)
+{
+	if (!system_supports_mte())
+		return;
+
+	mte_cpu_setup();
+}
+
 long set_mte_ctrl(struct task_struct *task, unsigned long arg)
 {
 	u64 mte_ctrl = (~((arg & PR_MTE_TAG_MASK) >> PR_MTE_TAG_SHIFT) &
--- a/arch/arm64/kernel/suspend.c
+++ b/arch/arm64/kernel/suspend.c
@@ -43,6 +43,8 @@ void notrace __cpu_suspend_exit(void)
 {
 	unsigned int cpu = smp_processor_id();
 
+	mte_suspend_exit();
+
 	/*
 	 * We are resuming from reset with the idmap active in TTBR0_EL1.
 	 * We must uninstall the idmap and restore the expected MMU
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -47,17 +47,19 @@
 
 #ifdef CONFIG_KASAN_HW_TAGS
 #define TCR_MTE_FLAGS TCR_TCMA1 | TCR_TBI1 | TCR_TBID1
-#else
+#elif defined(CONFIG_ARM64_MTE)
 /*
  * The mte_zero_clear_page_tags() implementation uses DC GZVA, which relies on
  * TBI being enabled at EL1.
  */
 #define TCR_MTE_FLAGS TCR_TBI1 | TCR_TBID1
+#else
+#define TCR_MTE_FLAGS 0
 #endif
 
 /*
  * Default MAIR_EL1. MT_NORMAL_TAGGED is initially mapped as Normal memory and
- * changed during __cpu_setup to Normal Tagged if the system supports MTE.
+ * changed during mte_cpu_setup to Normal Tagged if the system supports MTE.
  */
 #define MAIR_EL1_SET							\
 	(MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRnE, MT_DEVICE_nGnRnE) |	\
@@ -421,46 +423,8 @@ SYM_FUNC_START(__cpu_setup)
 	mov_q	mair, MAIR_EL1_SET
 	mov_q	tcr, TCR_TxSZ(VA_BITS) | TCR_CACHE_FLAGS | TCR_SMP_FLAGS | \
 			TCR_TG_FLAGS | TCR_KASLR_FLAGS | TCR_ASID16 | \
-			TCR_TBI0 | TCR_A1 | TCR_KASAN_SW_FLAGS
-
-#ifdef CONFIG_ARM64_MTE
-	/*
-	 * Update MAIR_EL1, GCR_EL1 and TFSR*_EL1 if MTE is supported
-	 * (ID_AA64PFR1_EL1[11:8] > 1).
-	 */
-	mrs	x10, ID_AA64PFR1_EL1
-	ubfx	x10, x10, #ID_AA64PFR1_MTE_SHIFT, #4
-	cmp	x10, #ID_AA64PFR1_MTE
-	b.lt	1f
-
-	/* Normal Tagged memory type at the corresponding MAIR index */
-	mov	x10, #MAIR_ATTR_NORMAL_TAGGED
-	bfi	mair, x10, #(8 *  MT_NORMAL_TAGGED), #8
+			TCR_TBI0 | TCR_A1 | TCR_KASAN_SW_FLAGS | TCR_MTE_FLAGS
 
-	mov	x10, #KERNEL_GCR_EL1
-	msr_s	SYS_GCR_EL1, x10
-
-	/*
-	 * If GCR_EL1.RRND=1 is implemented the same way as RRND=0, then
-	 * RGSR_EL1.SEED must be non-zero for IRG to produce
-	 * pseudorandom numbers. As RGSR_EL1 is UNKNOWN out of reset, we
-	 * must initialize it.
-	 */
-	mrs	x10, CNTVCT_EL0
-	ands	x10, x10, #SYS_RGSR_EL1_SEED_MASK
-	csinc	x10, x10, xzr, ne
-	lsl	x10, x10, #SYS_RGSR_EL1_SEED_SHIFT
-	msr_s	SYS_RGSR_EL1, x10
-
-	/* clear any pending tag check faults in TFSR*_EL1 */
-	msr_s	SYS_TFSR_EL1, xzr
-	msr_s	SYS_TFSRE0_EL1, xzr
-
-	/* set the TCR_EL1 bits */
-	mov_q	x10, TCR_MTE_FLAGS
-	orr	tcr, tcr, x10
-1:
-#endif
 	tcr_clear_errata_bits tcr, x9, x5
 
 #ifdef CONFIG_ARM64_VA_BITS_52


