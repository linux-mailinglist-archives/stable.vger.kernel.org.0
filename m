Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2337A576398
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 16:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233504AbiGOOZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 10:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232086AbiGOOZz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 10:25:55 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A38D68719;
        Fri, 15 Jul 2022 07:25:54 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 159531FEFD;
        Fri, 15 Jul 2022 14:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1657895153; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hzOhvTFCR82QZ7iKoRr+Nal/xjLFCKOCfmvvUa9Dxk8=;
        b=Z0JBV9s4Lfa87plttXYv1iKr47UlJrL14HRvAZPYuh8VEtPbZQBTUYjQ0fRmoA0fRHN6jZ
        6NAxb1ezCZIxkxQnkYRg8HS3eCF3aah417PQ9z1w76NKH3GdfOCv4VgCSjq1pnIa0qiRe+
        7CLyc6NdFJ3cN/zZbljXaomOKYAO4gk=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B50A913B28;
        Fri, 15 Jul 2022 14:25:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id yF3cKvB40WK+QQAAMHmgww
        (envelope-from <jgross@suse.com>); Fri, 15 Jul 2022 14:25:52 +0000
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     brchuckz@netscape.net, jbeulich@suse.com,
        Juergen Gross <jgross@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
Subject: [PATCH 1/3] x86: move some code out of arch/x86/kernel/cpu/mtrr
Date:   Fri, 15 Jul 2022 16:25:47 +0200
Message-Id: <20220715142549.25223-2-jgross@suse.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220715142549.25223-1-jgross@suse.com>
References: <20220715142549.25223-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Prepare making PAT and MTRR support independent from each other by
moving some code needed by both out of the MTRR specific sources.

Cc: <stable@vger.kernel.org> # 5.17
Fixes: bdd8b6c98239 ("drm/i915: replace X86_FEATURE_PAT with pat_enabled()")
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/include/asm/mtrr.h        |  4 ++
 arch/x86/include/asm/processor.h   |  3 ++
 arch/x86/kernel/cpu/common.c       | 76 ++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/mtrr/generic.c | 80 +++---------------------------
 4 files changed, 91 insertions(+), 72 deletions(-)

diff --git a/arch/x86/include/asm/mtrr.h b/arch/x86/include/asm/mtrr.h
index 76d726074c16..12a16caed395 100644
--- a/arch/x86/include/asm/mtrr.h
+++ b/arch/x86/include/asm/mtrr.h
@@ -48,6 +48,8 @@ extern void mtrr_aps_init(void);
 extern void mtrr_bp_restore(void);
 extern int mtrr_trim_uncached_memory(unsigned long end_pfn);
 extern int amd_special_default_mtrr(void);
+void mtrr_disable(void);
+void mtrr_enable(void);
 #  else
 static inline u8 mtrr_type_lookup(u64 addr, u64 end, u8 *uniform)
 {
@@ -87,6 +89,8 @@ static inline void mtrr_centaur_report_mcr(int mcr, u32 lo, u32 hi)
 #define set_mtrr_aps_delayed_init() do {} while (0)
 #define mtrr_aps_init() do {} while (0)
 #define mtrr_bp_restore() do {} while (0)
+#define mtrr_disable() do {} while (0)
+#define mtrr_enable() do {} while (0)
 #  endif
 
 #ifdef CONFIG_COMPAT
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 356308c73951..5c934b922450 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -865,4 +865,7 @@ bool arch_is_platform_page(u64 paddr);
 #define arch_is_platform_page arch_is_platform_page
 #endif
 
+void cache_disable(void);
+void cache_enable(void);
+
 #endif /* _ASM_X86_PROCESSOR_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 736262a76a12..e43322f8a4ef 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -61,6 +61,7 @@
 #include <asm/sigframe.h>
 #include <asm/traps.h>
 #include <asm/sev.h>
+#include <asm/mtrr.h>
 
 #include "cpu.h"
 
@@ -2327,3 +2328,78 @@ void arch_smt_update(void)
 	/* Check whether IPI broadcasting can be enabled */
 	apic_smt_update();
 }
+
+/*
+ * Disable and enable caches. Needed for changing MTRRs and the PAT MSR.
+ *
+ * Since we are disabling the cache don't allow any interrupts,
+ * they would run extremely slow and would only increase the pain.
+ *
+ * The caller must ensure that local interrupts are disabled and
+ * are reenabled after cache_enable() has been called.
+ */
+static unsigned long saved_cr4;
+static DEFINE_RAW_SPINLOCK(cache_disable_lock);
+
+void cache_disable(void) __acquires(cache_disable_lock)
+{
+	unsigned long cr0;
+
+	/*
+	 * Note that this is not ideal
+	 * since the cache is only flushed/disabled for this CPU while the
+	 * MTRRs are changed, but changing this requires more invasive
+	 * changes to the way the kernel boots
+	 */
+
+	raw_spin_lock(&cache_disable_lock);
+
+	/* Enter the no-fill (CD=1, NW=0) cache mode and flush caches. */
+	cr0 = read_cr0() | X86_CR0_CD;
+	write_cr0(cr0);
+
+	/*
+	 * Cache flushing is the most time-consuming step when programming
+	 * the MTRRs. Fortunately, as per the Intel Software Development
+	 * Manual, we can skip it if the processor supports cache self-
+	 * snooping.
+	 */
+	if (!static_cpu_has(X86_FEATURE_SELFSNOOP))
+		wbinvd();
+
+	/* Save value of CR4 and clear Page Global Enable (bit 7) */
+	if (boot_cpu_has(X86_FEATURE_PGE)) {
+		saved_cr4 = __read_cr4();
+		__write_cr4(saved_cr4 & ~X86_CR4_PGE);
+	}
+
+	/* Flush all TLBs via a mov %cr3, %reg; mov %reg, %cr3 */
+	count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ALL);
+	flush_tlb_local();
+
+	if (boot_cpu_has(X86_FEATURE_MTRR))
+		mtrr_disable();
+
+	/* Again, only flush caches if we have to. */
+	if (!static_cpu_has(X86_FEATURE_SELFSNOOP))
+		wbinvd();
+}
+
+void cache_enable(void) __releases(cache_disable_lock)
+{
+	/* Flush TLBs (no need to flush caches - they are disabled) */
+	count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ALL);
+	flush_tlb_local();
+
+	if (boot_cpu_has(X86_FEATURE_MTRR))
+		mtrr_enable();
+
+	/* Enable caches */
+	write_cr0(read_cr0() & ~X86_CR0_CD);
+
+	/* Restore value of CR4 */
+	if (boot_cpu_has(X86_FEATURE_PGE))
+		__write_cr4(saved_cr4);
+
+	raw_spin_unlock(&cache_disable_lock);
+}
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 558108296f3c..84732215b61d 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -396,9 +396,6 @@ print_fixed(unsigned base, unsigned step, const mtrr_type *types)
 	}
 }
 
-static void prepare_set(void);
-static void post_set(void);
-
 static void __init print_mtrr_state(void)
 {
 	unsigned int i;
@@ -450,11 +447,11 @@ void __init mtrr_bp_pat_init(void)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	prepare_set();
+	cache_disable();
 
 	pat_init();
 
-	post_set();
+	cache_enable();
 	local_irq_restore(flags);
 }
 
@@ -715,80 +712,19 @@ static unsigned long set_mtrr_state(void)
 	return change_mask;
 }
 
-
-static unsigned long cr4;
-static DEFINE_RAW_SPINLOCK(set_atomicity_lock);
-
-/*
- * Since we are disabling the cache don't allow any interrupts,
- * they would run extremely slow and would only increase the pain.
- *
- * The caller must ensure that local interrupts are disabled and
- * are reenabled after post_set() has been called.
- */
-static void prepare_set(void) __acquires(set_atomicity_lock)
+void mtrr_disable(void)
 {
-	unsigned long cr0;
-
-	/*
-	 * Note that this is not ideal
-	 * since the cache is only flushed/disabled for this CPU while the
-	 * MTRRs are changed, but changing this requires more invasive
-	 * changes to the way the kernel boots
-	 */
-
-	raw_spin_lock(&set_atomicity_lock);
-
-	/* Enter the no-fill (CD=1, NW=0) cache mode and flush caches. */
-	cr0 = read_cr0() | X86_CR0_CD;
-	write_cr0(cr0);
-
-	/*
-	 * Cache flushing is the most time-consuming step when programming
-	 * the MTRRs. Fortunately, as per the Intel Software Development
-	 * Manual, we can skip it if the processor supports cache self-
-	 * snooping.
-	 */
-	if (!static_cpu_has(X86_FEATURE_SELFSNOOP))
-		wbinvd();
-
-	/* Save value of CR4 and clear Page Global Enable (bit 7) */
-	if (boot_cpu_has(X86_FEATURE_PGE)) {
-		cr4 = __read_cr4();
-		__write_cr4(cr4 & ~X86_CR4_PGE);
-	}
-
-	/* Flush all TLBs via a mov %cr3, %reg; mov %reg, %cr3 */
-	count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ALL);
-	flush_tlb_local();
-
 	/* Save MTRR state */
 	rdmsr(MSR_MTRRdefType, deftype_lo, deftype_hi);
 
 	/* Disable MTRRs, and set the default type to uncached */
 	mtrr_wrmsr(MSR_MTRRdefType, deftype_lo & ~0xcff, deftype_hi);
-
-	/* Again, only flush caches if we have to. */
-	if (!static_cpu_has(X86_FEATURE_SELFSNOOP))
-		wbinvd();
 }
 
-static void post_set(void) __releases(set_atomicity_lock)
+void mtrr_enable(void)
 {
-	/* Flush TLBs (no need to flush caches - they are disabled) */
-	count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ALL);
-	flush_tlb_local();
-
 	/* Intel (P6) standard MTRRs */
 	mtrr_wrmsr(MSR_MTRRdefType, deftype_lo, deftype_hi);
-
-	/* Enable caches */
-	write_cr0(read_cr0() & ~X86_CR0_CD);
-
-	/* Restore value of CR4 */
-	if (boot_cpu_has(X86_FEATURE_PGE))
-		__write_cr4(cr4);
-	raw_spin_unlock(&set_atomicity_lock);
 }
 
 static void generic_set_all(void)
@@ -797,7 +733,7 @@ static void generic_set_all(void)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	prepare_set();
+	cache_disable();
 
 	/* Actually set the state */
 	mask = set_mtrr_state();
@@ -805,7 +741,7 @@ static void generic_set_all(void)
 	/* also set PAT */
 	pat_init();
 
-	post_set();
+	cache_enable();
 	local_irq_restore(flags);
 
 	/* Use the atomic bitops to update the global mask */
@@ -836,7 +772,7 @@ static void generic_set_mtrr(unsigned int reg, unsigned long base,
 	vr = &mtrr_state.var_ranges[reg];
 
 	local_irq_save(flags);
-	prepare_set();
+	cache_disable();
 
 	if (size == 0) {
 		/*
@@ -855,7 +791,7 @@ static void generic_set_mtrr(unsigned int reg, unsigned long base,
 		mtrr_wrmsr(MTRRphysMask_MSR(reg), vr->mask_lo, vr->mask_hi);
 	}
 
-	post_set();
+	cache_enable();
 	local_irq_restore(flags);
 }
 
-- 
2.35.3

