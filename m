Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2223C616EA
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbfGGTnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:43:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57408 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727575AbfGGTiK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:10 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz7-0006ig-El; Sun, 07 Jul 2019 20:38:05 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz5-0005cf-Om; Sun, 07 Jul 2019 20:38:03 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        "Doug Berger" <opendmb@gmail.com>,
        "Marc Zyngier" <marc.zyngier@arm.com>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.981020944@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 079/129] irqchip/brcmstb-l2: Use _irqsave locking
 variants in non-interrupt code
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Doug Berger <opendmb@gmail.com>

commit 33517881ede742107f416533b8c3e4abc56763da upstream.

Using the irq_gc_lock/irq_gc_unlock functions in the suspend and
resume functions creates the opportunity for a deadlock during
suspend, resume, and shutdown. Using the irq_gc_lock_irqsave/
irq_gc_unlock_irqrestore variants prevents this possible deadlock.

Fixes: 7f646e92766e2 ("irqchip: brcmstb-l2: Add Broadcom Set Top Box Level-2 interrupt controller")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
[maz: tidied up $SUBJECT]
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/irqchip/irq-brcmstb-l2.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/irqchip/irq-brcmstb-l2.c
+++ b/drivers/irqchip/irq-brcmstb-l2.c
@@ -82,8 +82,9 @@ static void brcmstb_l2_intc_suspend(stru
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	struct brcmstb_l2_intc_data *b = gc->private;
+	unsigned long flags;
 
-	irq_gc_lock(gc);
+	irq_gc_lock_irqsave(gc, flags);
 	/* Save the current mask */
 	b->saved_mask = __raw_readl(b->base + CPU_MASK_STATUS);
 
@@ -92,22 +93,23 @@ static void brcmstb_l2_intc_suspend(stru
 		__raw_writel(~gc->wake_active, b->base + CPU_MASK_SET);
 		__raw_writel(gc->wake_active, b->base + CPU_MASK_CLEAR);
 	}
-	irq_gc_unlock(gc);
+	irq_gc_unlock_irqrestore(gc, flags);
 }
 
 static void brcmstb_l2_intc_resume(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	struct brcmstb_l2_intc_data *b = gc->private;
+	unsigned long flags;
 
-	irq_gc_lock(gc);
+	irq_gc_lock_irqsave(gc, flags);
 	/* Clear unmasked non-wakeup interrupts */
 	__raw_writel(~b->saved_mask & ~gc->wake_active, b->base + CPU_CLEAR);
 
 	/* Restore the saved mask */
 	__raw_writel(b->saved_mask, b->base + CPU_MASK_SET);
 	__raw_writel(~b->saved_mask, b->base + CPU_MASK_CLEAR);
-	irq_gc_unlock(gc);
+	irq_gc_unlock_irqrestore(gc, flags);
 }
 
 int __init brcmstb_l2_intc_of_init(struct device_node *np,

