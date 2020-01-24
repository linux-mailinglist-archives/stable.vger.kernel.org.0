Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1B35147AC7
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730051AbgAXJhz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:37:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:35240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729971AbgAXJhy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:37:54 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E19920709;
        Fri, 24 Jan 2020 09:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858673;
        bh=jVGLbEpaWow1v62g/ZmWJOY/WsFgrGqB/Ly8GPdebuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1XozggkKHLtwNOm5b8CSqvBMUjgvqyXG1JtPGwDdAR8KoXfi831kg6CZiBcd19C6r
         YiA93iv6dQsnoVhTPvegK456VfJusscY4XXQ9TmYjRv+A7eNpL3WeqZ27ZNanW9cOd
         HVAesQ21BP7+H6PUS8RmssKcyVAke+CWkPbtt0LI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Finn Thain <fthain@telegraphics.com.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 639/639] m68k: Call timer_interrupt() with interrupts disabled
Date:   Fri, 24 Jan 2020 10:33:29 +0100
Message-Id: <20200124093209.652963517@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit 1efdd4bd254311498123a15fa0acd565f454da97 ]

Some platforms execute their timer handler with the interrupt priority
level set below 6. That means the handler could be interrupted by another
driver and this could lead to re-entry of the timer core.

Avoid this by use of local_irq_save/restore for timer interrupt dispatch.
This provides mutual exclusion around the timer interrupt flag access
which is needed later in this series for the clocksource conversion.

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/alpine.DEB.2.21.1811131407120.2697@nanos.tec.linutronix.de
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/amiga/cia.c       |  9 +++++++++
 arch/m68k/atari/ataints.c   |  4 ++--
 arch/m68k/atari/time.c      | 15 ++++++++++++++-
 arch/m68k/bvme6000/config.c | 20 ++++++++++----------
 arch/m68k/hp300/time.c      | 10 ++++++++--
 arch/m68k/mac/via.c         | 17 +++++++++++++++++
 arch/m68k/mvme147/config.c  | 18 ++++++++++--------
 arch/m68k/mvme16x/config.c  | 21 +++++++++++----------
 arch/m68k/q40/q40ints.c     | 19 +++++++++++--------
 arch/m68k/sun3/sun3ints.c   |  3 +++
 arch/m68k/sun3x/time.c      | 16 ++++++++++------
 11 files changed, 105 insertions(+), 47 deletions(-)

diff --git a/arch/m68k/amiga/cia.c b/arch/m68k/amiga/cia.c
index 2081b8cd5591c..b9aee983e6f4c 100644
--- a/arch/m68k/amiga/cia.c
+++ b/arch/m68k/amiga/cia.c
@@ -88,10 +88,19 @@ static irqreturn_t cia_handler(int irq, void *dev_id)
 	struct ciabase *base = dev_id;
 	int mach_irq;
 	unsigned char ints;
+	unsigned long flags;
 
+	/* Interrupts get disabled while the timer irq flag is cleared and
+	 * the timer interrupt serviced.
+	 */
 	mach_irq = base->cia_irq;
+	local_irq_save(flags);
 	ints = cia_set_irq(base, CIA_ICR_ALL);
 	amiga_custom.intreq = base->int_mask;
+	if (ints & 1)
+		generic_handle_irq(mach_irq);
+	local_irq_restore(flags);
+	mach_irq++, ints >>= 1;
 	for (; ints; mach_irq++, ints >>= 1) {
 		if (ints & 1)
 			generic_handle_irq(mach_irq);
diff --git a/arch/m68k/atari/ataints.c b/arch/m68k/atari/ataints.c
index 3d2b63bedf058..56f02ea2c248d 100644
--- a/arch/m68k/atari/ataints.c
+++ b/arch/m68k/atari/ataints.c
@@ -142,7 +142,7 @@ struct mfptimerbase {
 	.name		= "MFP Timer D"
 };
 
-static irqreturn_t mfptimer_handler(int irq, void *dev_id)
+static irqreturn_t mfp_timer_d_handler(int irq, void *dev_id)
 {
 	struct mfptimerbase *base = dev_id;
 	int mach_irq;
@@ -344,7 +344,7 @@ void __init atari_init_IRQ(void)
 	st_mfp.tim_ct_cd = (st_mfp.tim_ct_cd & 0xf0) | 0x6;
 
 	/* request timer D dispatch handler */
-	if (request_irq(IRQ_MFP_TIMD, mfptimer_handler, IRQF_SHARED,
+	if (request_irq(IRQ_MFP_TIMD, mfp_timer_d_handler, IRQF_SHARED,
 			stmfp_base.name, &stmfp_base))
 		pr_err("Couldn't register %s interrupt\n", stmfp_base.name);
 
diff --git a/arch/m68k/atari/time.c b/arch/m68k/atari/time.c
index 9cca64286464c..fafa20f75ab9a 100644
--- a/arch/m68k/atari/time.c
+++ b/arch/m68k/atari/time.c
@@ -24,6 +24,18 @@
 DEFINE_SPINLOCK(rtc_lock);
 EXPORT_SYMBOL_GPL(rtc_lock);
 
+static irqreturn_t mfp_timer_c_handler(int irq, void *dev_id)
+{
+	irq_handler_t timer_routine = dev_id;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	timer_routine(0, NULL);
+	local_irq_restore(flags);
+
+	return IRQ_HANDLED;
+}
+
 void __init
 atari_sched_init(irq_handler_t timer_routine)
 {
@@ -32,7 +44,8 @@ atari_sched_init(irq_handler_t timer_routine)
     /* start timer C, div = 1:100 */
     st_mfp.tim_ct_cd = (st_mfp.tim_ct_cd & 15) | 0x60;
     /* install interrupt service routine for MFP Timer C */
-    if (request_irq(IRQ_MFP_TIMC, timer_routine, 0, "timer", timer_routine))
+    if (request_irq(IRQ_MFP_TIMC, mfp_timer_c_handler, 0, "timer",
+                    timer_routine))
 	pr_err("Couldn't register timer interrupt\n");
 }
 
diff --git a/arch/m68k/bvme6000/config.c b/arch/m68k/bvme6000/config.c
index 143ee9fa3893e..0e5efed4da865 100644
--- a/arch/m68k/bvme6000/config.c
+++ b/arch/m68k/bvme6000/config.c
@@ -44,11 +44,6 @@ extern int bvme6000_hwclk (int, struct rtc_time *);
 extern void bvme6000_reset (void);
 void bvme6000_set_vectors (void);
 
-/* Save tick handler routine pointer, will point to xtime_update() in
- * kernel/timer/timekeeping.c, called via bvme6000_process_int() */
-
-static irq_handler_t tick_handler;
-
 
 int __init bvme6000_parse_bootinfo(const struct bi_record *bi)
 {
@@ -157,12 +152,18 @@ irqreturn_t bvme6000_abort_int (int irq, void *dev_id)
 
 static irqreturn_t bvme6000_timer_int (int irq, void *dev_id)
 {
+    irq_handler_t timer_routine = dev_id;
+    unsigned long flags;
     volatile RtcPtr_t rtc = (RtcPtr_t)BVME_RTC_BASE;
-    unsigned char msr = rtc->msr & 0xc0;
+    unsigned char msr;
 
+    local_irq_save(flags);
+    msr = rtc->msr & 0xc0;
     rtc->msr = msr | 0x20;		/* Ack the interrupt */
+    timer_routine(0, NULL);
+    local_irq_restore(flags);
 
-    return tick_handler(irq, dev_id);
+    return IRQ_HANDLED;
 }
 
 /*
@@ -181,9 +182,8 @@ void bvme6000_sched_init (irq_handler_t timer_routine)
 
     rtc->msr = 0;	/* Ensure timer registers accessible */
 
-    tick_handler = timer_routine;
-    if (request_irq(BVME_IRQ_RTC, bvme6000_timer_int, 0,
-				"timer", bvme6000_timer_int))
+    if (request_irq(BVME_IRQ_RTC, bvme6000_timer_int, 0, "timer",
+                    timer_routine))
 	panic ("Couldn't register timer int");
 
     rtc->t1cr_omr = 0x04;	/* Mode 2, ext clk */
diff --git a/arch/m68k/hp300/time.c b/arch/m68k/hp300/time.c
index 289d928a46cbe..d30b03ea93a27 100644
--- a/arch/m68k/hp300/time.c
+++ b/arch/m68k/hp300/time.c
@@ -38,13 +38,19 @@
 
 static irqreturn_t hp300_tick(int irq, void *dev_id)
 {
+	irq_handler_t timer_routine = dev_id;
+	unsigned long flags;
 	unsigned long tmp;
-	irq_handler_t vector = dev_id;
+
+	local_irq_save(flags);
 	in_8(CLOCKBASE + CLKSR);
 	asm volatile ("movpw %1@(5),%0" : "=d" (tmp) : "a" (CLOCKBASE));
+	timer_routine(0, NULL);
+	local_irq_restore(flags);
+
 	/* Turn off the network and SCSI leds */
 	blinken_leds(0, 0xe0);
-	return vector(irq, NULL);
+	return IRQ_HANDLED;
 }
 
 u32 hp300_gettimeoffset(void)
diff --git a/arch/m68k/mac/via.c b/arch/m68k/mac/via.c
index 288ec3aa5b575..038d5a1c4d484 100644
--- a/arch/m68k/mac/via.c
+++ b/arch/m68k/mac/via.c
@@ -387,6 +387,8 @@ void via_nubus_irq_shutdown(int irq)
  * via6522.c :-), disable/pending masks added.
  */
 
+#define VIA_TIMER_1_INT BIT(6)
+
 void via1_irq(struct irq_desc *desc)
 {
 	int irq_num;
@@ -396,6 +398,21 @@ void via1_irq(struct irq_desc *desc)
 	if (!events)
 		return;
 
+	irq_num = IRQ_MAC_TIMER_1;
+	irq_bit = VIA_TIMER_1_INT;
+	if (events & irq_bit) {
+		unsigned long flags;
+
+		local_irq_save(flags);
+		via1[vIFR] = irq_bit;
+		generic_handle_irq(irq_num);
+		local_irq_restore(flags);
+
+		events &= ~irq_bit;
+		if (!events)
+			return;
+	}
+
 	irq_num = VIA1_SOURCE_BASE;
 	irq_bit = 1;
 	do {
diff --git a/arch/m68k/mvme147/config.c b/arch/m68k/mvme147/config.c
index adea549d240e9..93c68d2b8e0ea 100644
--- a/arch/m68k/mvme147/config.c
+++ b/arch/m68k/mvme147/config.c
@@ -45,11 +45,6 @@ extern void mvme147_reset (void);
 
 static int bcd2int (unsigned char b);
 
-/* Save tick handler routine pointer, will point to xtime_update() in
- * kernel/time/timekeeping.c, called via mvme147_process_int() */
-
-irq_handler_t tick_handler;
-
 
 int __init mvme147_parse_bootinfo(const struct bi_record *bi)
 {
@@ -104,16 +99,23 @@ void __init config_mvme147(void)
 
 static irqreturn_t mvme147_timer_int (int irq, void *dev_id)
 {
+	irq_handler_t timer_routine = dev_id;
+	unsigned long flags;
+
+	local_irq_save(flags);
 	m147_pcc->t1_int_cntrl = PCC_TIMER_INT_CLR;
 	m147_pcc->t1_int_cntrl = PCC_INT_ENAB|PCC_LEVEL_TIMER1;
-	return tick_handler(irq, dev_id);
+	timer_routine(0, NULL);
+	local_irq_restore(flags);
+
+	return IRQ_HANDLED;
 }
 
 
 void mvme147_sched_init (irq_handler_t timer_routine)
 {
-	tick_handler = timer_routine;
-	if (request_irq(PCC_IRQ_TIMER1, mvme147_timer_int, 0, "timer 1", NULL))
+	if (request_irq(PCC_IRQ_TIMER1, mvme147_timer_int, 0, "timer 1",
+			timer_routine))
 		pr_err("Couldn't register timer interrupt\n");
 
 	/* Init the clock with a value */
diff --git a/arch/m68k/mvme16x/config.c b/arch/m68k/mvme16x/config.c
index 6ee36a5b528d8..5feb3ab484d08 100644
--- a/arch/m68k/mvme16x/config.c
+++ b/arch/m68k/mvme16x/config.c
@@ -50,11 +50,6 @@ extern void mvme16x_reset (void);
 
 int bcd2int (unsigned char b);
 
-/* Save tick handler routine pointer, will point to xtime_update() in
- * kernel/time/timekeeping.c, called via mvme16x_process_int() */
-
-static irq_handler_t tick_handler;
-
 
 unsigned short mvme16x_config;
 EXPORT_SYMBOL(mvme16x_config);
@@ -352,8 +347,15 @@ static irqreturn_t mvme16x_abort_int (int irq, void *dev_id)
 
 static irqreturn_t mvme16x_timer_int (int irq, void *dev_id)
 {
-    *(volatile unsigned char *)0xfff4201b |= 8;
-    return tick_handler(irq, dev_id);
+	irq_handler_t timer_routine = dev_id;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	*(volatile unsigned char *)0xfff4201b |= 8;
+	timer_routine(0, NULL);
+	local_irq_restore(flags);
+
+	return IRQ_HANDLED;
 }
 
 void mvme16x_sched_init (irq_handler_t timer_routine)
@@ -361,14 +363,13 @@ void mvme16x_sched_init (irq_handler_t timer_routine)
     uint16_t brdno = be16_to_cpu(mvme_bdid.brdno);
     int irq;
 
-    tick_handler = timer_routine;
     /* Using PCCchip2 or MC2 chip tick timer 1 */
     *(volatile unsigned long *)0xfff42008 = 0;
     *(volatile unsigned long *)0xfff42004 = 10000;	/* 10ms */
     *(volatile unsigned char *)0xfff42017 |= 3;
     *(volatile unsigned char *)0xfff4201b = 0x16;
-    if (request_irq(MVME16x_IRQ_TIMER, mvme16x_timer_int, 0,
-				"timer", mvme16x_timer_int))
+    if (request_irq(MVME16x_IRQ_TIMER, mvme16x_timer_int, 0, "timer",
+                    timer_routine))
 	panic ("Couldn't register timer int");
 
     if (brdno == 0x0162 || brdno == 0x172)
diff --git a/arch/m68k/q40/q40ints.c b/arch/m68k/q40/q40ints.c
index 3e7603202977e..1c696906c159f 100644
--- a/arch/m68k/q40/q40ints.c
+++ b/arch/m68k/q40/q40ints.c
@@ -127,10 +127,10 @@ void q40_mksound(unsigned int hz, unsigned int ticks)
 	sound_ticks = ticks << 1;
 }
 
-static irq_handler_t q40_timer_routine;
-
-static irqreturn_t q40_timer_int (int irq, void * dev)
+static irqreturn_t q40_timer_int(int irq, void *dev_id)
 {
+	irq_handler_t timer_routine = dev_id;
+
 	ql_ticks = ql_ticks ? 0 : 1;
 	if (sound_ticks) {
 		unsigned char sval=(sound_ticks & 1) ? 128-SVOL : 128+SVOL;
@@ -139,8 +139,13 @@ static irqreturn_t q40_timer_int (int irq, void * dev)
 		*DAC_RIGHT=sval;
 	}
 
-	if (!ql_ticks)
-		q40_timer_routine(irq, dev);
+	if (!ql_ticks) {
+		unsigned long flags;
+
+		local_irq_save(flags);
+		timer_routine(0, NULL);
+		local_irq_restore(flags);
+	}
 	return IRQ_HANDLED;
 }
 
@@ -148,11 +153,9 @@ void q40_sched_init (irq_handler_t timer_routine)
 {
 	int timer_irq;
 
-	q40_timer_routine = timer_routine;
 	timer_irq = Q40_IRQ_FRAME;
 
-	if (request_irq(timer_irq, q40_timer_int, 0,
-				"timer", q40_timer_int))
+	if (request_irq(timer_irq, q40_timer_int, 0, "timer", timer_routine))
 		panic("Couldn't register timer int");
 
 	master_outb(-1, FRAME_CLEAR_REG);
diff --git a/arch/m68k/sun3/sun3ints.c b/arch/m68k/sun3/sun3ints.c
index 6bbca30c91884..a5824abb4a39c 100644
--- a/arch/m68k/sun3/sun3ints.c
+++ b/arch/m68k/sun3/sun3ints.c
@@ -61,8 +61,10 @@ static irqreturn_t sun3_int7(int irq, void *dev_id)
 
 static irqreturn_t sun3_int5(int irq, void *dev_id)
 {
+	unsigned long flags;
 	unsigned int cnt;
 
+	local_irq_save(flags);
 #ifdef CONFIG_SUN3
 	intersil_clear();
 #endif
@@ -76,6 +78,7 @@ static irqreturn_t sun3_int5(int irq, void *dev_id)
 	cnt = kstat_irqs_cpu(irq, 0);
 	if (!(cnt % 20))
 		sun3_leds(led_pattern[cnt % 160 / 20]);
+	local_irq_restore(flags);
 	return IRQ_HANDLED;
 }
 
diff --git a/arch/m68k/sun3x/time.c b/arch/m68k/sun3x/time.c
index 047e2bcee3d7a..3c8a86d085084 100644
--- a/arch/m68k/sun3x/time.c
+++ b/arch/m68k/sun3x/time.c
@@ -80,15 +80,19 @@ u32 sun3x_gettimeoffset(void)
 }
 
 #if 0
-static void sun3x_timer_tick(int irq, void *dev_id, struct pt_regs *regs)
+static irqreturn_t sun3x_timer_tick(int irq, void *dev_id)
 {
-    void (*vector)(int, void *, struct pt_regs *) = dev_id;
+	irq_handler_t timer_routine = dev_id;
+	unsigned long flags;
 
-    /* Clear the pending interrupt - pulse the enable line low */
-    disable_irq(5);
-    enable_irq(5);
+	local_irq_save(flags);
+	/* Clear the pending interrupt - pulse the enable line low */
+	disable_irq(5);
+	enable_irq(5);
+	timer_routine(0, NULL);
+	local_irq_restore(flags);
 
-    vector(irq, NULL, regs);
+	return IRQ_HANDLED;
 }
 #endif
 
-- 
2.20.1



