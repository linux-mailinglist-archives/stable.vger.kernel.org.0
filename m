Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B34730FD0A
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 20:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239293AbhBDTim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 14:38:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238242AbhBDTii (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 14:38:38 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96746C0613D6;
        Thu,  4 Feb 2021 11:37:57 -0800 (PST)
Date:   Thu, 04 Feb 2021 19:37:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1612467474;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=unTbX9DkV91+E94tIlqsuxju0szg0vnESRuI78Z46es=;
        b=YLgBWwvPjUD+7CUz4xRENIGrNudHxJsHCA7fn72uLp2ZvwkoN6K9LOH0vUr7BlcIN/eoMf
        V503PZca7JOL+hYTKUTVOC+XtbtWcXLrOrgK23a0vxWN0uaMtH+BZ50lnA/A/RpTmHOAn5
        o0gIOlLpKheoib9YXFE5xCjlTLFe/SOFPtopaHCxxtAAgkq/binc2Nx2kVMXiGp1KCIpxZ
        aY1Y9kjCwhJr57jlfGoWWJLcIt1cEkWAaGleYHY9esHWgJaXpFUagkvmGDZaK+kCG3D9dz
        cQ77NqwacG9TQ/pvrcErqlhMQ7+jW0PICe7UoYCRxIn4MBg34Xq3IJhfi1MPDA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1612467474;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=unTbX9DkV91+E94tIlqsuxju0szg0vnESRuI78Z46es=;
        b=+RpMN1A4RdjW+xbShd5kTTY0Pi/Nk8XgZ4AdLeDtxWAv00TyHOhF5OUtdfiYIZjlsZoUNJ
        bib0dELuTw38LfBg==
From:   "tip-bot2 for Dave Hansen" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/apic: Add extra serialization for non-serializing MSRs
Cc:     Jan Kiszka <jan.kiszka@siemens.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, <stable@vger.kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20200305174708.F77040DD@viggo.jf.intel.com>
References: <20200305174708.F77040DD@viggo.jf.intel.com>
MIME-Version: 1.0
Message-ID: <161246747348.23325.3048620311121031887.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     25a068b8e9a4eb193d755d58efcb3c98928636e0
Gitweb:        https://git.kernel.org/tip/25a068b8e9a4eb193d755d58efcb3c98928636e0
Author:        Dave Hansen <dave.hansen@linux.intel.com>
AuthorDate:    Thu, 05 Mar 2020 09:47:08 -08:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Thu, 04 Feb 2021 19:36:31 +01:00

x86/apic: Add extra serialization for non-serializing MSRs

Jan Kiszka reported that the x2apic_wrmsr_fence() function uses a plain
MFENCE while the Intel SDM (10.12.3 MSR Access in x2APIC Mode) calls for
MFENCE; LFENCE.

Short summary: we have special MSRs that have weaker ordering than all
the rest. Add fencing consistent with current SDM recommendations.

This is not known to cause any issues in practice, only in theory.

Longer story below:

The reason the kernel uses a different semantic is that the SDM changed
(roughly in late 2017). The SDM changed because folks at Intel were
auditing all of the recommended fences in the SDM and realized that the
x2apic fences were insufficient.

Why was the pain MFENCE judged insufficient?

WRMSR itself is normally a serializing instruction. No fences are needed
because the instruction itself serializes everything.

But, there are explicit exceptions for this serializing behavior written
into the WRMSR instruction documentation for two classes of MSRs:
IA32_TSC_DEADLINE and the X2APIC MSRs.

Back to x2apic: WRMSR is *not* serializing in this specific case.
But why is MFENCE insufficient? MFENCE makes writes visible, but
only affects load/store instructions. WRMSR is unfortunately not a
load/store instruction and is unaffected by MFENCE. This means that a
non-serializing WRMSR could be reordered by the CPU to execute before
the writes made visible by the MFENCE have even occurred in the first
place.

This means that an x2apic IPI could theoretically be triggered before
there is any (visible) data to process.

Does this affect anything in practice? I honestly don't know. It seems
quite possible that by the time an interrupt gets to consume the (not
yet) MFENCE'd data, it has become visible, mostly by accident.

To be safe, add the SDM-recommended fences for all x2apic WRMSRs.

This also leaves open the question of the _other_ weakly-ordered WRMSR:
MSR_IA32_TSC_DEADLINE. While it has the same ordering architecture as
the x2APIC MSRs, it seems substantially less likely to be a problem in
practice. While writes to the in-memory Local Vector Table (LVT) might
theoretically be reordered with respect to a weakly-ordered WRMSR like
TSC_DEADLINE, the SDM has this to say:

  In x2APIC mode, the WRMSR instruction is used to write to the LVT
  entry. The processor ensures the ordering of this write and any
  subsequent WRMSR to the deadline; no fencing is required.

But, that might still leave xAPIC exposed. The safest thing to do for
now is to add the extra, recommended LFENCE.

 [ bp: Massage commit message, fix typos, drop accidentally added
   newline to tools/arch/x86/include/asm/barrier.h. ]

Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20200305174708.F77040DD@viggo.jf.intel.com
---
 arch/x86/include/asm/apic.h           | 10 ----------
 arch/x86/include/asm/barrier.h        | 18 ++++++++++++++++++
 arch/x86/kernel/apic/apic.c           |  4 ++++
 arch/x86/kernel/apic/x2apic_cluster.c |  6 ++++--
 arch/x86/kernel/apic/x2apic_phys.c    |  9 ++++++---
 5 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 34cb3c1..412b51e 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -197,16 +197,6 @@ static inline bool apic_needs_pit(void) { return true; }
 #endif /* !CONFIG_X86_LOCAL_APIC */
 
 #ifdef CONFIG_X86_X2APIC
-/*
- * Make previous memory operations globally visible before
- * sending the IPI through x2apic wrmsr. We need a serializing instruction or
- * mfence for this.
- */
-static inline void x2apic_wrmsr_fence(void)
-{
-	asm volatile("mfence" : : : "memory");
-}
-
 static inline void native_apic_msr_write(u32 reg, u32 v)
 {
 	if (reg == APIC_DFR || reg == APIC_ID || reg == APIC_LDR ||
diff --git a/arch/x86/include/asm/barrier.h b/arch/x86/include/asm/barrier.h
index 7f828fe..4819d5e 100644
--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -84,4 +84,22 @@ do {									\
 
 #include <asm-generic/barrier.h>
 
+/*
+ * Make previous memory operations globally visible before
+ * a WRMSR.
+ *
+ * MFENCE makes writes visible, but only affects load/store
+ * instructions.  WRMSR is unfortunately not a load/store
+ * instruction and is unaffected by MFENCE.  The LFENCE ensures
+ * that the WRMSR is not reordered.
+ *
+ * Most WRMSRs are full serializing instructions themselves and
+ * do not require this barrier.  This is only required for the
+ * IA32_TSC_DEADLINE and X2APIC MSRs.
+ */
+static inline void weak_wrmsr_fence(void)
+{
+	asm volatile("mfence; lfence" : : : "memory");
+}
+
 #endif /* _ASM_X86_BARRIER_H */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 6bd20c0..7f4c081 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -41,6 +41,7 @@
 #include <asm/perf_event.h>
 #include <asm/x86_init.h>
 #include <linux/atomic.h>
+#include <asm/barrier.h>
 #include <asm/mpspec.h>
 #include <asm/i8259.h>
 #include <asm/proto.h>
@@ -477,6 +478,9 @@ static int lapic_next_deadline(unsigned long delta,
 {
 	u64 tsc;
 
+	/* This MSR is special and need a special fence: */
+	weak_wrmsr_fence();
+
 	tsc = rdtsc();
 	wrmsrl(MSR_IA32_TSC_DEADLINE, tsc + (((u64) delta) * TSC_DIVISOR));
 	return 0;
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index df6adc5..f4da9bb 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -29,7 +29,8 @@ static void x2apic_send_IPI(int cpu, int vector)
 {
 	u32 dest = per_cpu(x86_cpu_to_logical_apicid, cpu);
 
-	x2apic_wrmsr_fence();
+	/* x2apic MSRs are special and need a special fence: */
+	weak_wrmsr_fence();
 	__x2apic_send_IPI_dest(dest, vector, APIC_DEST_LOGICAL);
 }
 
@@ -41,7 +42,8 @@ __x2apic_send_IPI_mask(const struct cpumask *mask, int vector, int apic_dest)
 	unsigned long flags;
 	u32 dest;
 
-	x2apic_wrmsr_fence();
+	/* x2apic MSRs are special and need a special fence: */
+	weak_wrmsr_fence();
 	local_irq_save(flags);
 
 	tmpmsk = this_cpu_cpumask_var_ptr(ipi_mask);
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index 0e4e819..6bde05a 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -43,7 +43,8 @@ static void x2apic_send_IPI(int cpu, int vector)
 {
 	u32 dest = per_cpu(x86_cpu_to_apicid, cpu);
 
-	x2apic_wrmsr_fence();
+	/* x2apic MSRs are special and need a special fence: */
+	weak_wrmsr_fence();
 	__x2apic_send_IPI_dest(dest, vector, APIC_DEST_PHYSICAL);
 }
 
@@ -54,7 +55,8 @@ __x2apic_send_IPI_mask(const struct cpumask *mask, int vector, int apic_dest)
 	unsigned long this_cpu;
 	unsigned long flags;
 
-	x2apic_wrmsr_fence();
+	/* x2apic MSRs are special and need a special fence: */
+	weak_wrmsr_fence();
 
 	local_irq_save(flags);
 
@@ -125,7 +127,8 @@ void __x2apic_send_IPI_shorthand(int vector, u32 which)
 {
 	unsigned long cfg = __prepare_ICR(which, vector, 0);
 
-	x2apic_wrmsr_fence();
+	/* x2apic MSRs are special and need a special fence: */
+	weak_wrmsr_fence();
 	native_x2apic_icr_write(cfg, 0);
 }
 
