Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E259A8F1A
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732774AbfIDSBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:01:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388633AbfIDSBq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:01:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED53922CEA;
        Wed,  4 Sep 2019 18:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620105;
        bh=+53Q+EU2tryXha6WTapNQg8k7LYAIJZaIDagmdNGxg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k2fhBu3pkqFBdk29HgR5/tAgPesZ9O2MfY/mXOiGeWvlgN35kzrKYFRAbU7AtpYe5
         JYD6dfSf5jptger8zmBZOH/uX7jADpUsdfNpAfqwwHIlaTdTKPwMXVW3eJxVBiO5AQ
         JhfsrjkTgYJ9gNBSwQnz6P9FNG4Q7riTXGzZMtpE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Drake <drake@endlessm.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.9 34/83] x86/apic: Handle missing global clockevent gracefully
Date:   Wed,  4 Sep 2019 19:53:26 +0200
Message-Id: <20190904175306.833293046@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.488266791@linuxfoundation.org>
References: <20190904175303.488266791@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit f897e60a12f0b9146357780d317879bce2a877dc upstream.

Some newer machines do not advertise legacy timers. The kernel can handle
that situation if the TSC and the CPU frequency are enumerated by CPUID or
MSRs and the CPU supports TSC deadline timer. If the CPU does not support
TSC deadline timer the local APIC timer frequency has to be known as well.

Some Ryzens machines do not advertize legacy timers, but there is no
reliable way to determine the bus frequency which feeds the local APIC
timer when the machine allows overclocking of that frequency.

As there is no legacy timer the local APIC timer calibration crashes due to
a NULL pointer dereference when accessing the not installed global clock
event device.

Switch the calibration loop to a non interrupt based one, which polls
either TSC (if frequency is known) or jiffies. The latter requires a global
clockevent. As the machines which do not have a global clockevent installed
have a known TSC frequency this is a non issue. For older machines where
TSC frequency is not known, there is no known case where the legacy timers
do not exist as that would have been reported long ago.

Reported-by: Daniel Drake <drake@endlessm.com>
Reported-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Daniel Drake <drake@endlessm.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/alpine.DEB.2.21.1908091443030.21433@nanos.tec.linutronix.de
Link: http://bugzilla.opensuse.org/show_bug.cgi?id=1142926#c12
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/apic/apic.c |   68 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 53 insertions(+), 15 deletions(-)

--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -629,7 +629,7 @@ static __initdata unsigned long lapic_ca
 static __initdata unsigned long lapic_cal_j1, lapic_cal_j2;
 
 /*
- * Temporary interrupt handler.
+ * Temporary interrupt handler and polled calibration function.
  */
 static void __init lapic_cal_handler(struct clock_event_device *dev)
 {
@@ -713,7 +713,8 @@ calibrate_by_pmtimer(long deltapm, long
 static int __init calibrate_APIC_clock(void)
 {
 	struct clock_event_device *levt = this_cpu_ptr(&lapic_events);
-	void (*real_handler)(struct clock_event_device *dev);
+	u64 tsc_perj = 0, tsc_start = 0;
+	unsigned long jif_start;
 	unsigned long deltaj;
 	long delta, deltatsc;
 	int pm_referenced = 0;
@@ -742,29 +743,65 @@ static int __init calibrate_APIC_clock(v
 	apic_printk(APIC_VERBOSE, "Using local APIC timer interrupts.\n"
 		    "calibrating APIC timer ...\n");
 
+	/*
+	 * There are platforms w/o global clockevent devices. Instead of
+	 * making the calibration conditional on that, use a polling based
+	 * approach everywhere.
+	 */
 	local_irq_disable();
 
-	/* Replace the global interrupt handler */
-	real_handler = global_clock_event->event_handler;
-	global_clock_event->event_handler = lapic_cal_handler;
-
 	/*
 	 * Setup the APIC counter to maximum. There is no way the lapic
 	 * can underflow in the 100ms detection time frame
 	 */
 	__setup_APIC_LVTT(0xffffffff, 0, 0);
 
-	/* Let the interrupts run */
+	/*
+	 * Methods to terminate the calibration loop:
+	 *  1) Global clockevent if available (jiffies)
+	 *  2) TSC if available and frequency is known
+	 */
+	jif_start = READ_ONCE(jiffies);
+
+	if (tsc_khz) {
+		tsc_start = rdtsc();
+		tsc_perj = div_u64((u64)tsc_khz * 1000, HZ);
+	}
+
+	/*
+	 * Enable interrupts so the tick can fire, if a global
+	 * clockevent device is available
+	 */
 	local_irq_enable();
 
-	while (lapic_cal_loops <= LAPIC_CAL_LOOPS)
-		cpu_relax();
+	while (lapic_cal_loops <= LAPIC_CAL_LOOPS) {
+		/* Wait for a tick to elapse */
+		while (1) {
+			if (tsc_khz) {
+				u64 tsc_now = rdtsc();
+				if ((tsc_now - tsc_start) >= tsc_perj) {
+					tsc_start += tsc_perj;
+					break;
+				}
+			} else {
+				unsigned long jif_now = READ_ONCE(jiffies);
+
+				if (time_after(jif_now, jif_start)) {
+					jif_start = jif_now;
+					break;
+				}
+			}
+			cpu_relax();
+		}
+
+		/* Invoke the calibration routine */
+		local_irq_disable();
+		lapic_cal_handler(NULL);
+		local_irq_enable();
+	}
 
 	local_irq_disable();
 
-	/* Restore the real event handler */
-	global_clock_event->event_handler = real_handler;
-
 	/* Build delta t1-t2 as apic timer counts down */
 	delta = lapic_cal_t1 - lapic_cal_t2;
 	apic_printk(APIC_VERBOSE, "... lapic delta = %ld\n", delta);
@@ -814,10 +851,11 @@ static int __init calibrate_APIC_clock(v
 	levt->features &= ~CLOCK_EVT_FEAT_DUMMY;
 
 	/*
-	 * PM timer calibration failed or not turned on
-	 * so lets try APIC timer based calibration
+	 * PM timer calibration failed or not turned on so lets try APIC
+	 * timer based calibration, if a global clockevent device is
+	 * available.
 	 */
-	if (!pm_referenced) {
+	if (!pm_referenced && global_clock_event) {
 		apic_printk(APIC_VERBOSE, "... verify APIC timer\n");
 
 		/*


