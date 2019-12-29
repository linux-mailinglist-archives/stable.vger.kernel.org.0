Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA53012C4C5
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729345AbfL2Rcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:32:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:33342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729342AbfL2Rck (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:32:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7A51208E4;
        Sun, 29 Dec 2019 17:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640760;
        bh=+Kf9WqdIqt2OINxaomJUPTrMY0shwAmeuuV8RdUx/7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n4RzOkECTfYuK2ft21KL6Wsr7mlbSffYal/MJm5yyIPgt8P8G9vAFfoLRW+mbQadk
         9Nrs2NPr04WIppI+oTZG/YuE86W8y1na96UwL9pChShmkgIsFsNaX3xpl3CyohMzmC
         2S/Inl5LjQgZegbt/aVxc8XEVfnnZ5gXDAS4xV2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 090/219] x86/ioapic: Prevent inconsistent state when moving an interrupt
Date:   Sun, 29 Dec 2019 18:18:12 +0100
Message-Id: <20191229162520.902452219@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit df4393424af3fbdcd5c404077176082a8ce459c4 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/apic/io_apic.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ab22eded61d2..fa3b85b222e3 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1724,9 +1724,10 @@ static bool io_apic_level_ack_pending(struct mp_chip_data *data)
 
 static inline bool ioapic_irqd_mask(struct irq_data *data)
 {
-	/* If we are moving the irq we need to mask it */
+	/* If we are moving the IRQ we need to mask it */
 	if (unlikely(irqd_is_setaffinity_pending(data))) {
-		mask_ioapic_irq(data);
+		if (!irqd_irq_masked(data))
+			mask_ioapic_irq(data);
 		return true;
 	}
 	return false;
@@ -1763,7 +1764,9 @@ static inline void ioapic_irqd_unmask(struct irq_data *data, bool masked)
 		 */
 		if (!io_apic_level_ack_pending(data->chip_data))
 			irq_move_masked_irq(data);
-		unmask_ioapic_irq(data);
+		/* If the IRQ is masked in the core, leave it: */
+		if (!irqd_irq_masked(data))
+			unmask_ioapic_irq(data);
 	}
 }
 #else
-- 
2.20.1



