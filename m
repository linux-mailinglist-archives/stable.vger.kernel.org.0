Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A75FE840
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 18:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728823AbfD2Q7T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 12:59:19 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:33874 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728681AbfD2Q7T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Apr 2019 12:59:19 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BD91980D;
        Mon, 29 Apr 2019 09:59:18 -0700 (PDT)
Received: from fuggles.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7C0F03F5AF;
        Mon, 29 Apr 2019 09:59:17 -0700 (PDT)
From:   Will Deacon <will.deacon@arm.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     tglx@linutronix.de, Will Deacon <will.deacon@arm.com>,
        stable@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: [PATCH] arm64: arch_timer: Ensure counter register reads occur with seqlock held
Date:   Mon, 29 Apr 2019 17:59:12 +0100
Message-Id: <20190429165912.9497-1-will.deacon@arm.com>
X-Mailer: git-send-email 2.11.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When executing clock_gettime(), either in the vDSO or via a system call,
we need to ensure that the read of the counter register occurs within
the seqlock reader critical section. This ensures that updates to the
clocksource parameters (e.g. the multiplier) are consistent with the
counter value and therefore avoids the situation where time appears to
go backwards across multiple reads.

Extend the vDSO logic so that the seqlock critical section covers the
read of the counter register as well as accesses to the data page. Since
reads of the counter system registers are not ordered by memory barrier
instructions, introduce dependency ordering from the counter read to a
subsequent memory access so that the seqlock memory barriers apply to
the counter access in both the vDSO and the system call paths.

Cc: <stable@vger.kernel.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Link: https://lore.kernel.org/linux-arm-kernel/alpine.DEB.2.21.1902081950260.1662@nanos.tec.linutronix.de/
Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/arch_timer.h   | 33 +++++++++++++++++++++++++++++++--
 arch/arm64/kernel/vdso/gettimeofday.S | 15 +++++++++++----
 2 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index f2a234d6516c..93e07512b4b6 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -148,18 +148,47 @@ static inline void arch_timer_set_cntkctl(u32 cntkctl)
 	isb();
 }
 
+/*
+ * Ensure that reads of the counter are treated the same as memory reads
+ * for the purposes of ordering by subsequent memory barriers.
+ *
+ * This insanity brought to you by speculative system register reads,
+ * out-of-order memory accesses, sequence locks and Thomas Gleixner.
+ *
+ * http://lists.infradead.org/pipermail/linux-arm-kernel/2019-February/631195.html
+ */
+#define arch_counter_enforce_ordering(val) do {				\
+	u64 tmp, _val = (val);						\
+									\
+	asm volatile(							\
+	"	eor	%0, %1, %1\n"					\
+	"	add	%0, sp, %0\n"					\
+	"	ldr	xzr, [%0]"					\
+	: "=r" (tmp) : "r" (_val));					\
+} while (0)
+
 static inline u64 arch_counter_get_cntpct(void)
 {
+	u64 cnt;
+
 	isb();
-	return arch_timer_reg_read_stable(cntpct_el0);
+	cnt = arch_timer_reg_read_stable(cntpct_el0);
+	arch_counter_enforce_ordering(cnt);
+	return cnt;
 }
 
 static inline u64 arch_counter_get_cntvct(void)
 {
+	u64 cnt;
+
 	isb();
-	return arch_timer_reg_read_stable(cntvct_el0);
+	cnt = arch_timer_reg_read_stable(cntvct_el0);
+	arch_counter_enforce_ordering(cnt);
+	return cnt;
 }
 
+#undef arch_counter_enforce_ordering
+
 static inline int arch_timer_arch_init(void)
 {
 	return 0;
diff --git a/arch/arm64/kernel/vdso/gettimeofday.S b/arch/arm64/kernel/vdso/gettimeofday.S
index 21805e416483..856fee6d3512 100644
--- a/arch/arm64/kernel/vdso/gettimeofday.S
+++ b/arch/arm64/kernel/vdso/gettimeofday.S
@@ -73,6 +73,13 @@ x_tmp		.req	x8
 	movn	x_tmp, #0xff00, lsl #48
 	and	\res, x_tmp, \res
 	mul	\res, \res, \mult
+	/*
+	 * Fake address dependency from the value computed from the counter
+	 * register to subsequent data page accesses so that the sequence
+	 * locking also orders the read of the counter.
+	 */
+	and	x_tmp, \res, xzr
+	add	vdso_data, vdso_data, x_tmp
 	.endm
 
 	/*
@@ -147,12 +154,12 @@ ENTRY(__kernel_gettimeofday)
 	/* w11 = cs_mono_mult, w12 = cs_shift */
 	ldp	w11, w12, [vdso_data, #VDSO_CS_MONO_MULT]
 	ldp	x13, x14, [vdso_data, #VDSO_XTIME_CLK_SEC]
-	seqcnt_check fail=1b
 
 	get_nsec_per_sec res=x9
 	lsl	x9, x9, x12
 
 	get_clock_shifted_nsec res=x15, cycle_last=x10, mult=x11
+	seqcnt_check fail=1b
 	get_ts_realtime res_sec=x10, res_nsec=x11, \
 		clock_nsec=x15, xtime_sec=x13, xtime_nsec=x14, nsec_to_sec=x9
 
@@ -211,13 +218,13 @@ realtime:
 	/* w11 = cs_mono_mult, w12 = cs_shift */
 	ldp	w11, w12, [vdso_data, #VDSO_CS_MONO_MULT]
 	ldp	x13, x14, [vdso_data, #VDSO_XTIME_CLK_SEC]
-	seqcnt_check fail=realtime
 
 	/* All computations are done with left-shifted nsecs. */
 	get_nsec_per_sec res=x9
 	lsl	x9, x9, x12
 
 	get_clock_shifted_nsec res=x15, cycle_last=x10, mult=x11
+	seqcnt_check fail=realtime
 	get_ts_realtime res_sec=x10, res_nsec=x11, \
 		clock_nsec=x15, xtime_sec=x13, xtime_nsec=x14, nsec_to_sec=x9
 	clock_gettime_return, shift=1
@@ -231,7 +238,6 @@ monotonic:
 	ldp	w11, w12, [vdso_data, #VDSO_CS_MONO_MULT]
 	ldp	x13, x14, [vdso_data, #VDSO_XTIME_CLK_SEC]
 	ldp	x3, x4, [vdso_data, #VDSO_WTM_CLK_SEC]
-	seqcnt_check fail=monotonic
 
 	/* All computations are done with left-shifted nsecs. */
 	lsl	x4, x4, x12
@@ -239,6 +245,7 @@ monotonic:
 	lsl	x9, x9, x12
 
 	get_clock_shifted_nsec res=x15, cycle_last=x10, mult=x11
+	seqcnt_check fail=monotonic
 	get_ts_realtime res_sec=x10, res_nsec=x11, \
 		clock_nsec=x15, xtime_sec=x13, xtime_nsec=x14, nsec_to_sec=x9
 
@@ -253,13 +260,13 @@ monotonic_raw:
 	/* w11 = cs_raw_mult, w12 = cs_shift */
 	ldp	w12, w11, [vdso_data, #VDSO_CS_SHIFT]
 	ldp	x13, x14, [vdso_data, #VDSO_RAW_TIME_SEC]
-	seqcnt_check fail=monotonic_raw
 
 	/* All computations are done with left-shifted nsecs. */
 	get_nsec_per_sec res=x9
 	lsl	x9, x9, x12
 
 	get_clock_shifted_nsec res=x15, cycle_last=x10, mult=x11
+	seqcnt_check fail=monotonic_raw
 	get_ts_clock_raw res_sec=x10, res_nsec=x11, \
 		clock_nsec=x15, nsec_to_sec=x9
 
-- 
2.11.0

