Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1105031380A
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbhBHPf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:35:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:38210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233862AbhBHPaz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:30:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0445364ECC;
        Mon,  8 Feb 2021 15:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797436;
        bh=76BY/y5ZDL8/dm1mGgYZ74bZPVk6D/S10e5elCGID00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EmPiszeefMkTpByydS0mOc4YDddLnb0nJLkKWbn5oYzX7/4LM2wJmHJ2457EhJ3M9
         OQWxWbi81rQmQZau3EZ8BV63rGN94OaS8LDjd7yERTLGlE3NY5+bjwNp7HAh8CtHCa
         SSr4zZ5lcYhuSDzbXZIN9VilWdOd4BjN3jFpay9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.10 110/120] x86/apic: Add extra serialization for non-serializing MSRs
Date:   Mon,  8 Feb 2021 16:01:37 +0100
Message-Id: <20210208145822.769523332@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Hansen <dave.hansen@linux.intel.com>

commit 25a068b8e9a4eb193d755d58efcb3c98928636e0 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/apic.h           |   10 ----------
 arch/x86/include/asm/barrier.h        |   18 ++++++++++++++++++
 arch/x86/kernel/apic/apic.c           |    4 ++++
 arch/x86/kernel/apic/x2apic_cluster.c |    6 ++++--
 arch/x86/kernel/apic/x2apic_phys.c    |    9 ++++++---
 5 files changed, 32 insertions(+), 15 deletions(-)

--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -197,16 +197,6 @@ static inline bool apic_needs_pit(void)
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
@@ -472,6 +473,9 @@ static int lapic_next_deadline(unsigned
 {
 	u64 tsc;
 
+	/* This MSR is special and need a special fence: */
+	weak_wrmsr_fence();
+
 	tsc = rdtsc();
 	wrmsrl(MSR_IA32_TSC_DEADLINE, tsc + (((u64) delta) * TSC_DIVISOR));
 	return 0;
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -29,7 +29,8 @@ static void x2apic_send_IPI(int cpu, int
 {
 	u32 dest = per_cpu(x86_cpu_to_logical_apicid, cpu);
 
-	x2apic_wrmsr_fence();
+	/* x2apic MSRs are special and need a special fence: */
+	weak_wrmsr_fence();
 	__x2apic_send_IPI_dest(dest, vector, APIC_DEST_LOGICAL);
 }
 
@@ -41,7 +42,8 @@ __x2apic_send_IPI_mask(const struct cpum
 	unsigned long flags;
 	u32 dest;
 
-	x2apic_wrmsr_fence();
+	/* x2apic MSRs are special and need a special fence: */
+	weak_wrmsr_fence();
 	local_irq_save(flags);
 
 	tmpmsk = this_cpu_cpumask_var_ptr(ipi_mask);
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -43,7 +43,8 @@ static void x2apic_send_IPI(int cpu, int
 {
 	u32 dest = per_cpu(x86_cpu_to_apicid, cpu);
 
-	x2apic_wrmsr_fence();
+	/* x2apic MSRs are special and need a special fence: */
+	weak_wrmsr_fence();
 	__x2apic_send_IPI_dest(dest, vector, APIC_DEST_PHYSICAL);
 }
 
@@ -54,7 +55,8 @@ __x2apic_send_IPI_mask(const struct cpum
 	unsigned long this_cpu;
 	unsigned long flags;
 
-	x2apic_wrmsr_fence();
+	/* x2apic MSRs are special and need a special fence: */
+	weak_wrmsr_fence();
 
 	local_irq_save(flags);
 
@@ -125,7 +127,8 @@ void __x2apic_send_IPI_shorthand(int vec
 {
 	unsigned long cfg = __prepare_ICR(which, vector, 0);
 
-	x2apic_wrmsr_fence();
+	/* x2apic MSRs are special and need a special fence: */
+	weak_wrmsr_fence();
 	native_x2apic_icr_write(cfg, 0);
 }
 


