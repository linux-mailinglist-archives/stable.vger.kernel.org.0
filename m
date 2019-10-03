Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC65CA978
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404727AbfJCQnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:43:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405207AbfJCQnD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:43:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4A6B2054F;
        Thu,  3 Oct 2019 16:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120982;
        bh=zZTgHccHDWS/buFoyAmnZgUe+Dc+MY2IQTRiMP7Y4oY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zeN+iL7ZnroGNyLrylw5vzoDv6tFL8KrED4L/2dYc7GUj60vLl/5T+4K9184lx9vT
         dzllYXMsBI68R1eyQgR13P+7YNPpIl/d6QEqG4UvB97BkRcwJ+ypa9ABbp1chCY1Z7
         rp38te26km2kjP0MAFSmwJOHQtlMYkkLUqGjUhXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 064/344] x86/apic: Make apic_pending_intr_clear() more robust
Date:   Thu,  3 Oct 2019 17:50:29 +0200
Message-Id: <20191003154546.420245051@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit cc8bf191378c1da8ad2b99cf470ee70193ace84e ]

In course of developing shorthand based IPI support issues with the
function which tries to clear eventually pending ISR bits in the local APIC
were observed.

  1) O-day testing triggered the WARN_ON() in apic_pending_intr_clear().

     This warning is emitted when the function fails to clear pending ISR
     bits or observes pending IRR bits which are not delivered to the CPU
     after the stale ISR bit(s) are ACK'ed.

     Unfortunately the function only emits a WARN_ON() and fails to dump
     the IRR/ISR content. That's useless for debugging.

     Feng added spot on debug printk's which revealed that the stale IRR
     bit belonged to the APIC timer interrupt vector, but adding ad hoc
     debug code does not help with sporadic failures in the field.

     Rework the loop so the full IRR/ISR contents are saved and on failure
     dumped.

  2) The loop termination logic is interesting at best.

     If the machine has no TSC or cpu_khz is not known yet it tries 1
     million times to ack stale IRR/ISR bits. What?

     With TSC it uses the TSC to calculate the loop termination. It takes a
     timestamp at entry and terminates the loop when:

     	  (rdtsc() - start_timestamp) >= (cpu_hkz << 10)

     That's roughly one second.

     Both methods are problematic. The APIC has 256 vectors, which means
     that in theory max. 256 IRR/ISR bits can be set. In practice this is
     impossible and the chance that more than a few bits are set is close
     to zero.

     With the pure loop based approach the 1 million retries are complete
     overkill.

     With TSC this can terminate too early in a guest which is running on a
     heavily loaded host even with only a couple of IRR/ISR bits set. The
     reason is that after acknowledging the highest priority ISR bit,
     pending IRRs must get serviced first before the next round of
     acknowledge can take place as the APIC (real and virtualized) does not
     honour EOI without a preceeding interrupt on the CPU. And every APIC
     read/write takes a VMEXIT if the APIC is virtualized. While trying to
     reproduce the issue 0-day reported it was observed that the guest was
     scheduled out long enough under heavy load that it terminated after 8
     iterations.

     Make the loop terminate after 512 iterations. That's plenty enough
     in any case and does not take endless time to complete.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20190722105219.158847694@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/apic/apic.c | 107 +++++++++++++++++++++---------------
 1 file changed, 63 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 08fb79f377936..436d462dde715 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1495,54 +1495,72 @@ static void lapic_setup_esr(void)
 			oldvalue, value);
 }
 
-static void apic_pending_intr_clear(void)
+#define APIC_IR_REGS		APIC_ISR_NR
+#define APIC_IR_BITS		(APIC_IR_REGS * 32)
+#define APIC_IR_MAPSIZE		(APIC_IR_BITS / BITS_PER_LONG)
+
+union apic_ir {
+	unsigned long	map[APIC_IR_MAPSIZE];
+	u32		regs[APIC_IR_REGS];
+};
+
+static bool apic_check_and_ack(union apic_ir *irr, union apic_ir *isr)
 {
-	long long max_loops = cpu_khz ? cpu_khz : 1000000;
-	unsigned long long tsc = 0, ntsc;
-	unsigned int queued;
-	unsigned long value;
-	int i, j, acked = 0;
+	int i, bit;
+
+	/* Read the IRRs */
+	for (i = 0; i < APIC_IR_REGS; i++)
+		irr->regs[i] = apic_read(APIC_IRR + i * 0x10);
+
+	/* Read the ISRs */
+	for (i = 0; i < APIC_IR_REGS; i++)
+		isr->regs[i] = apic_read(APIC_ISR + i * 0x10);
 
-	if (boot_cpu_has(X86_FEATURE_TSC))
-		tsc = rdtsc();
 	/*
-	 * After a crash, we no longer service the interrupts and a pending
-	 * interrupt from previous kernel might still have ISR bit set.
-	 *
-	 * Most probably by now CPU has serviced that pending interrupt and
-	 * it might not have done the ack_APIC_irq() because it thought,
-	 * interrupt came from i8259 as ExtInt. LAPIC did not get EOI so it
-	 * does not clear the ISR bit and cpu thinks it has already serivced
-	 * the interrupt. Hence a vector might get locked. It was noticed
-	 * for timer irq (vector 0x31). Issue an extra EOI to clear ISR.
+	 * If the ISR map is not empty. ACK the APIC and run another round
+	 * to verify whether a pending IRR has been unblocked and turned
+	 * into a ISR.
 	 */
-	do {
-		queued = 0;
-		for (i = APIC_ISR_NR - 1; i >= 0; i--)
-			queued |= apic_read(APIC_IRR + i*0x10);
-
-		for (i = APIC_ISR_NR - 1; i >= 0; i--) {
-			value = apic_read(APIC_ISR + i*0x10);
-			for_each_set_bit(j, &value, 32) {
-				ack_APIC_irq();
-				acked++;
-			}
-		}
-		if (acked > 256) {
-			pr_err("LAPIC pending interrupts after %d EOI\n", acked);
-			break;
-		}
-		if (queued) {
-			if (boot_cpu_has(X86_FEATURE_TSC) && cpu_khz) {
-				ntsc = rdtsc();
-				max_loops = (long long)cpu_khz << 10;
-				max_loops -= ntsc - tsc;
-			} else {
-				max_loops--;
-			}
-		}
-	} while (queued && max_loops > 0);
-	WARN_ON(max_loops <= 0);
+	if (!bitmap_empty(isr->map, APIC_IR_BITS)) {
+		/*
+		 * There can be multiple ISR bits set when a high priority
+		 * interrupt preempted a lower priority one. Issue an ACK
+		 * per set bit.
+		 */
+		for_each_set_bit(bit, isr->map, APIC_IR_BITS)
+			ack_APIC_irq();
+		return true;
+	}
+
+	return !bitmap_empty(irr->map, APIC_IR_BITS);
+}
+
+/*
+ * After a crash, we no longer service the interrupts and a pending
+ * interrupt from previous kernel might still have ISR bit set.
+ *
+ * Most probably by now the CPU has serviced that pending interrupt and it
+ * might not have done the ack_APIC_irq() because it thought, interrupt
+ * came from i8259 as ExtInt. LAPIC did not get EOI so it does not clear
+ * the ISR bit and cpu thinks it has already serivced the interrupt. Hence
+ * a vector might get locked. It was noticed for timer irq (vector
+ * 0x31). Issue an extra EOI to clear ISR.
+ *
+ * If there are pending IRR bits they turn into ISR bits after a higher
+ * priority ISR bit has been acked.
+ */
+static void apic_pending_intr_clear(void)
+{
+	union apic_ir irr, isr;
+	unsigned int i;
+
+	/* 512 loops are way oversized and give the APIC a chance to obey. */
+	for (i = 0; i < 512; i++) {
+		if (!apic_check_and_ack(&irr, &isr))
+			return;
+	}
+	/* Dump the IRR/ISR content if that failed */
+	pr_warn("APIC: Stale IRR: %256pb ISR: %256pb\n", irr.map, isr.map);
 }
 
 /**
@@ -1610,6 +1628,7 @@ static void setup_local_APIC(void)
 	value &= ~APIC_TPRI_MASK;
 	apic_write(APIC_TASKPRI, value);
 
+	/* Clear eventually stale ISR/IRR bits */
 	apic_pending_intr_clear();
 
 	/*
-- 
2.20.1



