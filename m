Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30EEF234E3
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390357AbfETMbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:31:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390351AbfETMbe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:31:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 945F0216FD;
        Mon, 20 May 2019 12:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355493;
        bh=jHnr8GD1aKn2Y3iOscmw3lW7VcwC0q2BQGI0AZcz3N8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O6Wwx4apx/MVLroV3NrPk2LWsU0Gk9+6CmiqZ+X5NVGR9vobvmzHUWkjBT5vGp9FY
         QBGEHs6RMBnuHDgnvqWb7wLvIzlQJk/exIunQyiQgY24iRgLuUppeeWA9gKrdIx3Qm
         BSjkHEg2IanYaJgF5yBzgTOl3F3mUzMB9n0fx7DA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 5.1 016/128] arm64: arch_timer: Ensure counter register reads occur with seqlock held
Date:   Mon, 20 May 2019 14:13:23 +0200
Message-Id: <20190520115250.577618868@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

commit 75a19a0202db21638a1c2b424afb867e1f9a2376 upstream.

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
Tested-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Link: https://lore.kernel.org/linux-arm-kernel/alpine.DEB.2.21.1902081950260.1662@nanos.tec.linutronix.de/
Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/arch_timer.h   |   33 +++++++++++++++++++++++++++++++--
 arch/arm64/kernel/vdso/gettimeofday.S |   15 +++++++++++----
 2 files changed, 42 insertions(+), 6 deletions(-)

--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -148,18 +148,47 @@ static inline void arch_timer_set_cntkct
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
 


