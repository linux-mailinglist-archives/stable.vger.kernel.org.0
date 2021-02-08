Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31DB31361E
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhBHPGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:06:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:52606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232069AbhBHPEe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:04:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11E6364EC6;
        Mon,  8 Feb 2021 15:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796594;
        bh=LR+kDNitNvyx7VUN5n6sTcfsb1K0y9tTwUld4cJXk6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v3tOIKzGqM7fST8VTgebwwbCbnkWZWM9QUOuoadA4gZSXZ2i3vQhsmRq4xW+1h81s
         aOwXXo5Zjueohim0LI3AEei6Fa/gqzeCa/YcsE9fGzeerWgg94QI+126mKLUaP9bW4
         DrkDC9khrrfpuVpca8kYNJIzbMuU3hyxpv6NOC5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.4 35/38] x86/apic: Add extra serialization for non-serializing MSRs
Date:   Mon,  8 Feb 2021 16:00:57 +0100
Message-Id: <20210208145806.631981840@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145805.279815326@linuxfoundation.org>
References: <20210208145805.279815326@linuxfoundation.org>
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
 arch/x86/kernel/apic/x2apic_cluster.c |    3 ++-
 arch/x86/kernel/apic/x2apic_phys.c    |    3 ++-
 5 files changed, 26 insertions(+), 12 deletions(-)

--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -168,16 +168,6 @@ static inline void disable_local_APIC(vo
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
@@ -119,4 +119,22 @@ do {									\
 #define smp_mb__before_atomic()	do { } while (0)
 #define smp_mb__after_atomic()	do { } while (0)
 
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
 #include <asm/x86_init.h>
 #include <asm/pgalloc.h>
 #include <linux/atomic.h>
+#include <asm/barrier.h>
 #include <asm/mpspec.h>
 #include <asm/i8259.h>
 #include <asm/proto.h>
@@ -464,6 +465,9 @@ static int lapic_next_deadline(unsigned
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
@@ -32,7 +32,8 @@ __x2apic_send_IPI_mask(const struct cpum
 	unsigned long flags;
 	u32 dest;
 
-	x2apic_wrmsr_fence();
+	/* x2apic MSRs are special and need a special fence: */
+	weak_wrmsr_fence();
 
 	local_irq_save(flags);
 
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -43,7 +43,8 @@ __x2apic_send_IPI_mask(const struct cpum
 	unsigned long this_cpu;
 	unsigned long flags;
 
-	x2apic_wrmsr_fence();
+	/* x2apic MSRs are special and need a special fence: */
+	weak_wrmsr_fence();
 
 	local_irq_save(flags);
 


