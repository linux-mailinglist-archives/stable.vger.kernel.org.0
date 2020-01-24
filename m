Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9E87147C9A
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387840AbgAXJxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:53:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:55666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387835AbgAXJxP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:53:15 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 873D0206D5;
        Fri, 24 Jan 2020 09:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859594;
        bh=ogdsnwmeqaKBTAR36iRDzbokIcv1R80wiadMcy6VvZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QSeB23kbBAXN3D09pn/bDrDEIr2WtUxOzs4inAf5ZZv3TccE+PIYq3g1QdHYCAaep
         gnEIGiVk260v6fEIdeyqlimQY2p+pk59GAecQ9RXLMbB6Dac8h1N6WC6dVQtXzox3V
         oDuKUcpFEK/PJUonDPNC1jA55zA73OvGM+q+a7rU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Finn Thain <fthain@telegraphics.com.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 151/343] m68k: mac: Fix VIA timer counter accesses
Date:   Fri, 24 Jan 2020 10:29:29 +0100
Message-Id: <20200124092939.867579106@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit 0ca7ce7db771580433bf24454f7a1542bd326078 ]

This resolves some bugs that affect VIA timer counter accesses.
Avoid lost interrupts caused by reading the counter low byte register.
Make allowance for the fact that the counter will be decremented to
0xFFFF before being reloaded.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/mac/via.c | 102 +++++++++++++++++++++++---------------------
 1 file changed, 53 insertions(+), 49 deletions(-)

diff --git a/arch/m68k/mac/via.c b/arch/m68k/mac/via.c
index 9f59a662ace57..7334245abf26f 100644
--- a/arch/m68k/mac/via.c
+++ b/arch/m68k/mac/via.c
@@ -54,16 +54,6 @@ static __u8 rbv_clear;
 
 static int gIER,gIFR,gBufA,gBufB;
 
-/*
- * Timer defs.
- */
-
-#define TICK_SIZE		10000
-#define MAC_CLOCK_TICK		(783300/HZ)		/* ticks per HZ */
-#define MAC_CLOCK_LOW		(MAC_CLOCK_TICK&0xFF)
-#define MAC_CLOCK_HIGH		(MAC_CLOCK_TICK>>8)
-
-
 /*
  * On Macs with a genuine VIA chip there is no way to mask an individual slot
  * interrupt. This limitation also seems to apply to VIA clone logic cores in
@@ -278,22 +268,6 @@ void __init via_init(void)
 	}
 }
 
-/*
- * Start the 100 Hz clock
- */
-
-void __init via_init_clock(irq_handler_t func)
-{
-	via1[vACR] |= 0x40;
-	via1[vT1LL] = MAC_CLOCK_LOW;
-	via1[vT1LH] = MAC_CLOCK_HIGH;
-	via1[vT1CL] = MAC_CLOCK_LOW;
-	via1[vT1CH] = MAC_CLOCK_HIGH;
-
-	if (request_irq(IRQ_MAC_TIMER_1, func, 0, "timer", func))
-		pr_err("Couldn't register %s interrupt\n", "timer");
-}
-
 /*
  * Debugging dump, used in various places to see what's going on.
  */
@@ -321,29 +295,6 @@ void via_debug_dump(void)
 	}
 }
 
-/*
- * This is always executed with interrupts disabled.
- *
- * TBI: get time offset between scheduling timer ticks
- */
-
-u32 mac_gettimeoffset(void)
-{
-	unsigned long ticks, offset = 0;
-
-	/* read VIA1 timer 2 current value */
-	ticks = via1[vT1CL] | (via1[vT1CH] << 8);
-	/* The probability of underflow is less than 2% */
-	if (ticks > MAC_CLOCK_TICK - MAC_CLOCK_TICK / 50)
-		/* Check for pending timer interrupt in VIA1 IFR */
-		if (via1[vIFR] & 0x40) offset = TICK_SIZE;
-
-	ticks = MAC_CLOCK_TICK - ticks;
-	ticks = ticks * 10000L / MAC_CLOCK_TICK;
-
-	return (ticks + offset) * 1000;
-}
-
 /*
  * Flush the L2 cache on Macs that have it by flipping
  * the system into 24-bit mode for an instant.
@@ -612,3 +563,56 @@ int via2_scsi_drq_pending(void)
 	return via2[gIFR] & (1 << IRQ_IDX(IRQ_MAC_SCSIDRQ));
 }
 EXPORT_SYMBOL(via2_scsi_drq_pending);
+
+/* timer and clock source */
+
+#define VIA_CLOCK_FREQ     783360                /* VIA "phase 2" clock in Hz */
+#define VIA_TIMER_INTERVAL (1000000 / HZ)        /* microseconds per jiffy */
+#define VIA_TIMER_CYCLES   (VIA_CLOCK_FREQ / HZ) /* clock cycles per jiffy */
+
+#define VIA_TC             (VIA_TIMER_CYCLES - 2) /* including 0 and -1 */
+#define VIA_TC_LOW         (VIA_TC & 0xFF)
+#define VIA_TC_HIGH        (VIA_TC >> 8)
+
+void __init via_init_clock(irq_handler_t timer_routine)
+{
+	if (request_irq(IRQ_MAC_TIMER_1, timer_routine, 0, "timer", NULL)) {
+		pr_err("Couldn't register %s interrupt\n", "timer");
+		return;
+	}
+
+	via1[vT1LL] = VIA_TC_LOW;
+	via1[vT1LH] = VIA_TC_HIGH;
+	via1[vT1CL] = VIA_TC_LOW;
+	via1[vT1CH] = VIA_TC_HIGH;
+	via1[vACR] |= 0x40;
+}
+
+u32 mac_gettimeoffset(void)
+{
+	unsigned long flags;
+	u8 count_high;
+	u16 count, offset = 0;
+
+	/*
+	 * Timer counter wrap-around is detected with the timer interrupt flag
+	 * but reading the counter low byte (vT1CL) would reset the flag.
+	 * Also, accessing both counter registers is essentially a data race.
+	 * These problems are avoided by ignoring the low byte. Clock accuracy
+	 * is 256 times worse (error can reach 0.327 ms) but CPU overhead is
+	 * reduced by avoiding slow VIA register accesses.
+	 */
+
+	local_irq_save(flags);
+	count_high = via1[vT1CH];
+	if (count_high == 0xFF)
+		count_high = 0;
+	if (count_high > 0 && (via1[vIFR] & VIA_TIMER_1_INT))
+		offset = VIA_TIMER_CYCLES;
+	local_irq_restore(flags);
+
+	count = count_high << 8;
+	count = VIA_TIMER_CYCLES - count + offset;
+
+	return ((count * VIA_TIMER_INTERVAL) / VIA_TIMER_CYCLES) * 1000;
+}
-- 
2.20.1



