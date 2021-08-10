Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F913E563E
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 11:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238623AbhHJJIJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 05:08:09 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:41874 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238592AbhHJJIH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 05:08:07 -0400
Date:   Tue, 10 Aug 2021 09:07:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1628586464;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7RoLM+/Zl2Hzzu1wmUyohshtKagiN7f/PkbVZcTZ35E=;
        b=uojMa8RK5ROZB3/L7yxYvg83rWaQhOkGM4yxB6mEBdIDu6LXrHTkH0rKL06c85jvjFAprr
        TzyvtgFXIqw4OKHYDCF/j3WjsaFVKgjenooT2UY3sUnSJrJTctqDwQ3epIy00AoxuFbE/7
        BEwdZ3Hvp5O/XDab5yU566yuAwI89lUmQ7XcNEL6ML3vlpGsYlAHh2q+ldvLojdt4O3jS1
        HpiPX6lSa6m1pz89oXOWcZsoCXOGB1FfPRVkYacLdQJIx0e1cGrUfXZNOdbioRkAUqqX41
        g9XSi3iq23gbOlz/58pbiwWj0B97J4sDq0lpje+BfRGaD8V3jKp8tVDNhz9Snw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1628586464;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7RoLM+/Zl2Hzzu1wmUyohshtKagiN7f/PkbVZcTZ35E=;
        b=apeXsFPQ2fVT1nrIXdP9yJjWBz0Tj1+crvnsqWzypnytQi0zHlSXydhC23rFQyp3fzQLxX
        T3MzXgDplDTJk4Bw==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/core] genirq: Provide IRQCHIP_AFFINITY_PRE_STARTUP
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210729222542.779791738@linutronix.de>
References: <20210729222542.779791738@linutronix.de>
MIME-Version: 1.0
Message-ID: <162858646338.395.3860924236017769816.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/core branch of tip:

Commit-ID:     826da771291fc25a428e871f9e7fb465e390f852
Gitweb:        https://git.kernel.org/tip/826da771291fc25a428e871f9e7fb465e390f852
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Thu, 29 Jul 2021 23:51:48 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 10 Aug 2021 10:59:20 +02:00

genirq: Provide IRQCHIP_AFFINITY_PRE_STARTUP

X86 IO/APIC and MSI interrupts (when used without interrupts remapping)
require that the affinity setup on startup is done before the interrupt is
enabled for the first time as the non-remapped operation mode cannot safely
migrate enabled interrupts from arbitrary contexts. Provide a new irq chip
flag which allows affected hardware to request this.

This has to be opt-in because there have been reports in the past that some
interrupt chips cannot handle affinity setting before startup.

Fixes: 18404756765c ("genirq: Expose default irq affinity mask (take 3)")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210729222542.779791738@linutronix.de

---
 include/linux/irq.h | 2 ++
 kernel/irq/chip.c   | 5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 8e9a9ae..c8293c8 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -569,6 +569,7 @@ struct irq_chip {
  * IRQCHIP_SUPPORTS_NMI:              Chip can deliver NMIs, only for root irqchips
  * IRQCHIP_ENABLE_WAKEUP_ON_SUSPEND:  Invokes __enable_irq()/__disable_irq() for wake irqs
  *                                    in the suspend path if they are in disabled state
+ * IRQCHIP_AFFINITY_PRE_STARTUP:      Default affinity update before startup
  */
 enum {
 	IRQCHIP_SET_TYPE_MASKED			= (1 <<  0),
@@ -581,6 +582,7 @@ enum {
 	IRQCHIP_SUPPORTS_LEVEL_MSI		= (1 <<  7),
 	IRQCHIP_SUPPORTS_NMI			= (1 <<  8),
 	IRQCHIP_ENABLE_WAKEUP_ON_SUSPEND	= (1 <<  9),
+	IRQCHIP_AFFINITY_PRE_STARTUP		= (1 << 10),
 };
 
 #include <linux/irqdesc.h>
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 7f04c7d..a98bcfc 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -265,8 +265,11 @@ int irq_startup(struct irq_desc *desc, bool resend, bool force)
 	} else {
 		switch (__irq_startup_managed(desc, aff, force)) {
 		case IRQ_STARTUP_NORMAL:
+			if (d->chip->flags & IRQCHIP_AFFINITY_PRE_STARTUP)
+				irq_setup_affinity(desc);
 			ret = __irq_startup(desc);
-			irq_setup_affinity(desc);
+			if (!(d->chip->flags & IRQCHIP_AFFINITY_PRE_STARTUP))
+				irq_setup_affinity(desc);
 			break;
 		case IRQ_STARTUP_MANAGED:
 			irq_do_set_affinity(d, aff, false);
