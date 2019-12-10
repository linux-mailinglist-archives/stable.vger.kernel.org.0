Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A732119E1A
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbfLJWm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:42:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:51484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728432AbfLJWbZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:31:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72B282077B;
        Tue, 10 Dec 2019 22:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576017085;
        bh=0YZFfgq7d40fJ7EltrHDzVO2zdHSpUWcOXdN0gPbhV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PP5MQHY0dO2h5ekp7bJuiV24dK02Z4pPNpuqYJK1lIt9zZRNwqjAp3sdGNsNaBvT1
         I3RLipsyjmArv+EmHTfFkjvRr0Z7ZrfwGE0j/z0MeStonpAvwEpdy3rXDJ6SYkO5Yx
         Ql/l+0dKPNowyuYv7FJjRfmqYtwkkCLsAkjNKvuE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 41/91] x86/ioapic: Prevent inconsistent state when moving an interrupt
Date:   Tue, 10 Dec 2019 17:29:45 -0500
Message-Id: <20191210223035.14270-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210223035.14270-1-sashal@kernel.org>
References: <20191210223035.14270-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 09dd95cabfc28..3401b28f13121 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1712,9 +1712,10 @@ static bool io_apic_level_ack_pending(struct mp_chip_data *data)
 
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
@@ -1751,7 +1752,9 @@ static inline void ioapic_irqd_unmask(struct irq_data *data, bool masked)
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

