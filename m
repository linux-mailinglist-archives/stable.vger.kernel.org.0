Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C31923ECF85
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 09:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234208AbhHPHku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 03:40:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234197AbhHPHkt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 03:40:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F43961AAB;
        Mon, 16 Aug 2021 07:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629099618;
        bh=pVYwlXCoKZbE7wNjj9jpZoDhWbZNTyOHodnnBc9cgzQ=;
        h=Subject:To:Cc:From:Date:From;
        b=C04MxGS6aXO3AqJNo1jpEGsC+gmU8+dPxcRmo1vQy7hh9ZY9/cc11EoDRqBVmqWdk
         ycj80Duf8Kod96ir89EX8sUndjcL1e2xHUbF7gMhmAgK+hc5advTLF2LxAG4veJR4o
         Z+H1HZS5xShBrWttdjbug11pzANPeFUuWi9pCr4E=
Subject: FAILED: patch "[PATCH] x86/ioapic: Force affinity setup before startup" failed to apply to 4.4-stable tree
To:     tglx@linutronix.de, maz@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Aug 2021 09:40:16 +0200
Message-ID: <162909961618135@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0c0e37dc11671384e53ba6ede53a4d91162a2cc5 Mon Sep 17 00:00:00 2001
From: Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 29 Jul 2021 23:51:49 +0200
Subject: [PATCH] x86/ioapic: Force affinity setup before startup

The IO/APIC cannot handle interrupt affinity changes safely after startup
other than from an interrupt handler. The startup sequence in the generic
interrupt code violates that assumption.

Mark the irq chip with the new IRQCHIP_AFFINITY_PRE_STARTUP flag so that
the default interrupt setting happens before the interrupt is started up
for the first time.

Fixes: 18404756765c ("genirq: Expose default irq affinity mask (take 3)")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210729222542.832143400@linutronix.de

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index d5c691a3208b..39224e035e47 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1986,7 +1986,8 @@ static struct irq_chip ioapic_chip __read_mostly = {
 	.irq_set_affinity	= ioapic_set_affinity,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.irq_get_irqchip_state	= ioapic_irq_get_chip_state,
-	.flags			= IRQCHIP_SKIP_SET_WAKE,
+	.flags			= IRQCHIP_SKIP_SET_WAKE |
+				  IRQCHIP_AFFINITY_PRE_STARTUP,
 };
 
 static struct irq_chip ioapic_ir_chip __read_mostly = {
@@ -1999,7 +2000,8 @@ static struct irq_chip ioapic_ir_chip __read_mostly = {
 	.irq_set_affinity	= ioapic_set_affinity,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.irq_get_irqchip_state	= ioapic_irq_get_chip_state,
-	.flags			= IRQCHIP_SKIP_SET_WAKE,
+	.flags			= IRQCHIP_SKIP_SET_WAKE |
+				  IRQCHIP_AFFINITY_PRE_STARTUP,
 };
 
 static inline void init_IO_APIC_traps(void)

