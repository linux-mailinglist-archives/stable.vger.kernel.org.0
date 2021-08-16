Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAAAE3ECFE1
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 10:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234476AbhHPIEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 04:04:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234495AbhHPIED (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 04:04:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 445C161AF8;
        Mon, 16 Aug 2021 08:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629101012;
        bh=uQgebRSznMuibr2k6VHiBIVlCWRuXhvUKMoWEarpC+Y=;
        h=Subject:To:Cc:From:Date:From;
        b=JPkT4tTXAoQLG3AJj5K1NvExxrRYDUdQFx0mExheu9/sC9Sb7+JMclRr2aorIiFKW
         BFDsO6Gu9W5qJ58SWfr/tfCkamSUv0xcGLyEjb+EPA/WRlZ98/EG3IF6ByKzkmjKSt
         J7qthobAYaGttOoD2l/4q6kbf22ROw8hPmpfVo3o=
Subject: FAILED: patch "[PATCH] genirq: Provide IRQCHIP_AFFINITY_PRE_STARTUP" failed to apply to 4.9-stable tree
To:     tglx@linutronix.de, maz@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Aug 2021 10:03:30 +0200
Message-ID: <1629101010183174@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 826da771291fc25a428e871f9e7fb465e390f852 Mon Sep 17 00:00:00 2001
From: Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 29 Jul 2021 23:51:48 +0200
Subject: [PATCH] genirq: Provide IRQCHIP_AFFINITY_PRE_STARTUP

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

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 8e9a9ae471a6..c8293c817646 100644
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
index 7f04c7d8296e..a98bcfc4be7b 100644
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

