Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21433ED678
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238851AbhHPNVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:21:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240565AbhHPNTx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:19:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 345C6632AC;
        Mon, 16 Aug 2021 13:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119690;
        bh=WAmHT34yVQgJu40/TxA72+kx/9DEUQpSPnp/Uxlnc7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QcQ3B4T/9hx+rpnxV2C/0LzyP6Fap9QPBgSF0NSwhGAjy4WGSuAptArXndnO3qhKe
         9muY/KW4CD350Dm45KkXjyXylVhzEAambwfiy4N43JtvBxCF2lGmJjg72PGbu4nWbc
         1tNZFp0E1nonzhCl8iPgTU1vCbucpEFQdoXcoe1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.13 123/151] x86/ioapic: Force affinity setup before startup
Date:   Mon, 16 Aug 2021 15:02:33 +0200
Message-Id: <20210816125448.116549586@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 0c0e37dc11671384e53ba6ede53a4d91162a2cc5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/apic/io_apic.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1986,7 +1986,8 @@ static struct irq_chip ioapic_chip __rea
 	.irq_set_affinity	= ioapic_set_affinity,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.irq_get_irqchip_state	= ioapic_irq_get_chip_state,
-	.flags			= IRQCHIP_SKIP_SET_WAKE,
+	.flags			= IRQCHIP_SKIP_SET_WAKE |
+				  IRQCHIP_AFFINITY_PRE_STARTUP,
 };
 
 static struct irq_chip ioapic_ir_chip __read_mostly = {
@@ -1999,7 +2000,8 @@ static struct irq_chip ioapic_ir_chip __
 	.irq_set_affinity	= ioapic_set_affinity,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.irq_get_irqchip_state	= ioapic_irq_get_chip_state,
-	.flags			= IRQCHIP_SKIP_SET_WAKE,
+	.flags			= IRQCHIP_SKIP_SET_WAKE |
+				  IRQCHIP_AFFINITY_PRE_STARTUP,
 };
 
 static inline void init_IO_APIC_traps(void)


