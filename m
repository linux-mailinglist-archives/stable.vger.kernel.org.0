Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19C58F7F3B
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbfKKSeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:34:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:52090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727632AbfKKSeZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:34:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEEEC21925;
        Mon, 11 Nov 2019 18:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497264;
        bh=34iO7JmVcXpXn7LTOurI6kkO/0cJKor/J47L6tLTihY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NH+DRLPAFg5Np+ClwIqZ2lVhWTVNvo+FbC3s9wgUY+U/sxzGG0YDNRvqR1k/LDS/M
         KbSHNjZ/X+p/faI0zXk4ef5CcCSJmtFBY2U2eblcLTparonmSybQavWHOTNK6O9BDF
         D4h2a4tN15G6NM+Yo0u1uNdUc2H/kAwMZOXbhtGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dou Liyang <douly.fnst@cn.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>, bhe@redhat.com,
        ebiederm@xmission.com, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 60/65] x86/apic: Move pending interrupt check code into its own function
Date:   Mon, 11 Nov 2019 19:29:00 +0100
Message-Id: <20191111181355.364498204@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181331.917659011@linuxfoundation.org>
References: <20191111181331.917659011@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dou Liyang <douly.fnst@cn.fujitsu.com>

[ Upstream commit 9b217f33017715903d0956dfc58f82d2a2d00e63 ]

The pending interrupt check code is mixed with the local APIC setup code,
that looks messy.

Extract the related code, move it into a new function named
apic_pending_intr_clear().

Signed-off-by: Dou Liyang <douly.fnst@cn.fujitsu.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: bhe@redhat.com
Cc: ebiederm@xmission.com
Link: https://lkml.kernel.org/r/20180301055930.2396-2-douly.fnst@cn.fujitsu.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/apic/apic.c | 100 ++++++++++++++++++++----------------
 1 file changed, 55 insertions(+), 45 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 232350519062b..264daf1f49915 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1281,6 +1281,56 @@ static void lapic_setup_esr(void)
 			oldvalue, value);
 }
 
+static void apic_pending_intr_clear(void)
+{
+	long long max_loops = cpu_khz ? cpu_khz : 1000000;
+	unsigned long long tsc = 0, ntsc;
+	unsigned int value, queued;
+	int i, j, acked = 0;
+
+	if (boot_cpu_has(X86_FEATURE_TSC))
+		tsc = rdtsc();
+	/*
+	 * After a crash, we no longer service the interrupts and a pending
+	 * interrupt from previous kernel might still have ISR bit set.
+	 *
+	 * Most probably by now CPU has serviced that pending interrupt and
+	 * it might not have done the ack_APIC_irq() because it thought,
+	 * interrupt came from i8259 as ExtInt. LAPIC did not get EOI so it
+	 * does not clear the ISR bit and cpu thinks it has already serivced
+	 * the interrupt. Hence a vector might get locked. It was noticed
+	 * for timer irq (vector 0x31). Issue an extra EOI to clear ISR.
+	 */
+	do {
+		queued = 0;
+		for (i = APIC_ISR_NR - 1; i >= 0; i--)
+			queued |= apic_read(APIC_IRR + i*0x10);
+
+		for (i = APIC_ISR_NR - 1; i >= 0; i--) {
+			value = apic_read(APIC_ISR + i*0x10);
+			for (j = 31; j >= 0; j--) {
+				if (value & (1<<j)) {
+					ack_APIC_irq();
+					acked++;
+				}
+			}
+		}
+		if (acked > 256) {
+			printk(KERN_ERR "LAPIC pending interrupts after %d EOI\n",
+			       acked);
+			break;
+		}
+		if (queued) {
+			if (boot_cpu_has(X86_FEATURE_TSC) && cpu_khz) {
+				ntsc = rdtsc();
+				max_loops = (cpu_khz << 10) - (ntsc - tsc);
+			} else
+				max_loops--;
+		}
+	} while (queued && max_loops > 0);
+	WARN_ON(max_loops <= 0);
+}
+
 /**
  * setup_local_APIC - setup the local APIC
  *
@@ -1290,13 +1340,11 @@ static void lapic_setup_esr(void)
 void setup_local_APIC(void)
 {
 	int cpu = smp_processor_id();
-	unsigned int value, queued;
-	int i, j, acked = 0;
-	unsigned long long tsc = 0, ntsc;
-	long long max_loops = cpu_khz ? cpu_khz : 1000000;
+	unsigned int value;
+#ifdef CONFIG_X86_32
+	int i;
+#endif
 
-	if (boot_cpu_has(X86_FEATURE_TSC))
-		tsc = rdtsc();
 
 	if (disable_apic) {
 		disable_ioapic_support();
@@ -1356,45 +1404,7 @@ void setup_local_APIC(void)
 	value &= ~APIC_TPRI_MASK;
 	apic_write(APIC_TASKPRI, value);
 
-	/*
-	 * After a crash, we no longer service the interrupts and a pending
-	 * interrupt from previous kernel might still have ISR bit set.
-	 *
-	 * Most probably by now CPU has serviced that pending interrupt and
-	 * it might not have done the ack_APIC_irq() because it thought,
-	 * interrupt came from i8259 as ExtInt. LAPIC did not get EOI so it
-	 * does not clear the ISR bit and cpu thinks it has already serivced
-	 * the interrupt. Hence a vector might get locked. It was noticed
-	 * for timer irq (vector 0x31). Issue an extra EOI to clear ISR.
-	 */
-	do {
-		queued = 0;
-		for (i = APIC_ISR_NR - 1; i >= 0; i--)
-			queued |= apic_read(APIC_IRR + i*0x10);
-
-		for (i = APIC_ISR_NR - 1; i >= 0; i--) {
-			value = apic_read(APIC_ISR + i*0x10);
-			for (j = 31; j >= 0; j--) {
-				if (value & (1<<j)) {
-					ack_APIC_irq();
-					acked++;
-				}
-			}
-		}
-		if (acked > 256) {
-			printk(KERN_ERR "LAPIC pending interrupts after %d EOI\n",
-			       acked);
-			break;
-		}
-		if (queued) {
-			if (boot_cpu_has(X86_FEATURE_TSC) && cpu_khz) {
-				ntsc = rdtsc();
-				max_loops = (cpu_khz << 10) - (ntsc - tsc);
-			} else
-				max_loops--;
-		}
-	} while (queued && max_loops > 0);
-	WARN_ON(max_loops <= 0);
+	apic_pending_intr_clear();
 
 	/*
 	 * Now that we are all set up, enable the APIC
-- 
2.20.1



