Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAAA75BA2A6
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 00:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbiIOWVC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 18:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiIOWVB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 18:21:01 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D8277EA3
        for <stable@vger.kernel.org>; Thu, 15 Sep 2022 15:21:00 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id x5-20020a056902102500b006af1376b813so12327457ybt.16
        for <stable@vger.kernel.org>; Thu, 15 Sep 2022 15:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=hwsBbOCukVOmmbNRJPkSdnPVZPJXqTOFjX96LXshtvw=;
        b=Spo98VOSTby2Le1Hze2WZq1/fiMoDhbdNBbMz+1fH1UtWkYDr6OUlNJ1GxWorydkND
         o2RdLuvrBihW27OTeQMnhtJxEtH5+0QLznsrfpGYjUVNbxpc84DEwIeAc3Bgd+QoSXni
         fJ8jYm81lx/hNz5+fY5+VQTMb+LGIb4avDSvpwHLnIOFjDo8S/UfSyp0WZ7XRdAHi2Ud
         /+ubiItzzfgjlj+YkMhVjeYXbaI3lvyJtcHjkTmXLw40e/RxKqj8WFWj/7k+546fMdCq
         Oqtnn2j5VP+1p8Q9ojAiZ5gXwicnn4WqgEMT2O8lCS557poHMNE407YzT9Wjs8qM62sM
         Y8fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=hwsBbOCukVOmmbNRJPkSdnPVZPJXqTOFjX96LXshtvw=;
        b=JzbOuJUqeIvCI1faQEvR61773+GWZtfXrvWaTUEuro04tn5PjpG9o4DZOb4sEF8MU7
         fXWAZFkGY4ZaUm2Qr4tLA1Wv+fsq9PQmPi4+8vLmaZbaVqs5liu4t/eRO9+ccqTae5iy
         ANAjZHkl+GYPCV4cBQtGcg9LKgGyS6A9O8WU2zTtXrGhM5wU8UwWTme1Dhl8oEJ16QQG
         a+qXgR/voS/YOkLZdum8vYsdy7t/W30Xr1IEEs8uhYhgUpDUeaAUOSD5Otqx6q/1ocyv
         YIAFpnkbMSXfYLnl49PfSyUlIJrdTZdLKlhLM/HkNBg0CuJZZ11H4Ywq8Z4u9Kyv8UW5
         tsyw==
X-Gm-Message-State: ACrzQf3a85ge10TihDHvCHsM15Hp2bp4VkJOMYxkJuVzUueJnHfbsc3h
        RLLFBTMF/KdzlshgJorTAAFQqxnD3d3k
X-Google-Smtp-Source: AMsMyM4JxUSjaIOLfacJwbXgulMZPMHHhgP6UGtSh7bLGCMZqats1zNy4nc4yHegB+IuKfsqYETV6ur/jzZi
X-Received: from eugenis.svl.corp.google.com ([2620:15c:2ce:200:d243:2f2b:afe4:86b4])
 (user=eugenis job=sendgmr) by 2002:a81:84c6:0:b0:345:1c4e:f6f3 with SMTP id
 u189-20020a8184c6000000b003451c4ef6f3mr1887660ywf.163.1663280459377; Thu, 15
 Sep 2022 15:20:59 -0700 (PDT)
Date:   Thu, 15 Sep 2022 15:20:53 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220915222053.3484231-1-eugenis@google.com>
Subject: [PATCH v5] arm64: mte: move register initialization to C
From:   Evgenii Stepanov <eugenis@google.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Peter Collingbourne <pcc@google.com>
Cc:     Kenny Root <kroot@google.com>, Marc Zyngier <maz@kernel.org>,
        Will Deacon <will@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Evgenii Stepanov <eugenis@google.com>,
        kernel test robot <lkp@intel.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Collingbourne <pcc@google.com>

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
---
Changelong since v3:
- Removed extra isb barrier.
- Fixed build without CONFIG_ARM64_MTE.

Changelog since v2:
- Fixed register initialization on cpu_resume code path.

Changelog since v1:
- Keep TBI1 off unless CONFIG_ARM64_MTE
- Fixed mask application in the RGSR_EL1 computation (bug found by Kenny
  Root).
- Changed code formatting

 arch/arm64/include/asm/mte.h   |  5 ++++
 arch/arm64/kernel/cpufeature.c |  3 +-
 arch/arm64/kernel/mte.c        | 51 ++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/suspend.c    |  2 ++
 arch/arm64/mm/proc.S           | 46 ++++--------------------------
 5 files changed, 65 insertions(+), 42 deletions(-)

diff --git a/arch/arm64/include/asm/mte.h b/arch/arm64/include/asm/mte.h
index aa523591a44e5..760c62f8e22f8 100644
--- a/arch/arm64/include/asm/mte.h
+++ b/arch/arm64/include/asm/mte.h
@@ -42,7 +42,9 @@ void mte_sync_tags(pte_t old_pte, pte_t pte);
 void mte_copy_page_tags(void *kto, const void *kfrom);
 void mte_thread_init_user(void);
 void mte_thread_switch(struct task_struct *next);
+void mte_cpu_setup(void);
 void mte_suspend_enter(void);
+void mte_suspend_exit(void);
 long set_mte_ctrl(struct task_struct *task, unsigned long arg);
 long get_mte_ctrl(struct task_struct *task);
 int mte_ptrace_copy_tags(struct task_struct *child, long request,
@@ -72,6 +74,9 @@ static inline void mte_thread_switch(struct task_struct *next)
 static inline void mte_suspend_enter(void)
 {
 }
+static inline void mte_suspend_exit(void)
+{
+}
 static inline long set_mte_ctrl(struct task_struct *task, unsigned long arg)
 {
 	return 0;
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index af4de817d7123..d7a077b5ccd1c 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2034,7 +2034,8 @@ static void bti_enable(const struct arm64_cpu_capabilities *__unused)
 static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
 {
 	sysreg_clear_set(sctlr_el1, 0, SCTLR_ELx_ATA | SCTLR_EL1_ATA0);
-	isb();
+
+	mte_cpu_setup();
 
 	/*
 	 * Clear the tags in the zero page. This needs to be done via the
diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index b2b730233274b..aca88470fb69d 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -285,6 +285,49 @@ void mte_thread_switch(struct task_struct *next)
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
@@ -301,6 +344,14 @@ void mte_suspend_enter(void)
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
diff --git a/arch/arm64/kernel/suspend.c b/arch/arm64/kernel/suspend.c
index 9135fe0f3df53..8b02d310838f9 100644
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
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 7837a69524c53..f38bccdd374a5 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -48,17 +48,19 @@
 
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
@@ -426,46 +428,8 @@ SYM_FUNC_START(__cpu_setup)
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
-- 
2.37.2.789.g6183377224-goog

