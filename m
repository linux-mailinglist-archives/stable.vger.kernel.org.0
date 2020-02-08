Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06ADE156605
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbgBHSbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:31:17 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34818 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727975AbgBHS3u (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:50 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrG-0003d3-7P; Sat, 08 Feb 2020 18:29:34 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrF-000CL2-F4; Sat, 08 Feb 2020 18:29:33 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Andy Shevchenko" <andy.shevchenko@gmail.com>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Sebastian Siewior" <bigeasy@linutronix.de>
Date:   Sat, 08 Feb 2020 18:19:32 +0000
Message-ID: <lsq.1581185940.70008285@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 033/148] x86/ioapic: Prevent inconsistent state when
 moving an interrupt
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit df4393424af3fbdcd5c404077176082a8ce459c4 upstream.

There is an issue with threaded interrupts which are marked ONESHOT
and using the fasteoi handler:

  if (IS_ONESHOT())
    mask_irq();
  ....
  cond_unmask_eoi_irq()
    chip->irq_eoi();
      if (setaffinity_pending) {
         mask_ioapic();
         ...
	 move_affinity();
	 unmask_ioapic();
      }

So if setaffinity is pending the interrupt will be moved and then
unconditionally unmasked at the ioapic level, which is wrong in two
aspects:

 1) It should be kept masked up to the point where the threaded handler
    finished.

 2) The physical chip state and the software masked state are inconsistent

Guard both the mask and the unmask with a check for the software masked
state. If the line is marked masked then the ioapic line is also masked, so
both mask_ioapic() and unmask_ioapic() can be skipped safely.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sebastian Siewior <bigeasy@linutronix.de>
Fixes: 3aa551c9b4c4 ("genirq: add threaded interrupt handler support")
Link: https://lkml.kernel.org/r/20191017101938.321393687@linutronix.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[bwh: Backported to 3.16: Keep using {,un}mask_iopaic_irq()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/apic/io_apic.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2377,9 +2377,10 @@ static bool io_apic_level_ack_pending(st
 
 static inline bool ioapic_irqd_mask(struct irq_data *data, struct irq_cfg *cfg)
 {
-	/* If we are moving the irq we need to mask it */
+	/* If we are moving the IRQ we need to mask it */
 	if (unlikely(irqd_is_setaffinity_pending(data))) {
-		mask_ioapic(cfg);
+		if (!irqd_irq_masked(data))
+			mask_ioapic(cfg);
 		return true;
 	}
 	return false;
@@ -2417,7 +2418,9 @@ static inline void ioapic_irqd_unmask(st
 		 */
 		if (!io_apic_level_ack_pending(cfg))
 			irq_move_masked_irq(data);
-		unmask_ioapic(cfg);
+		/* If the IRQ is masked in the core, leave it: */
+		if (!irqd_irq_masked(data))
+			unmask_ioapic(cfg);
 	}
 }
 #else

