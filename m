Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A14845BB9C
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243883AbhKXMVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:21:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:33140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242560AbhKXMTL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:19:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2EE460174;
        Wed, 24 Nov 2021 12:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755932;
        bh=zG+cTgU/cgzT+whxBjmF9B2uwKVnin/k184ulNCR8Qk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U5fdBlA7R+o8DxnATTw41EHkn66zFgC7pVDcyBsOifOcSApc4ARSWql8+IA+T01BN
         fsGXkKD9oR7KBx9LudOmCcXB4Ja9OddYE6eKtZAIsEu0dEF0grT0WP+fRqu+/hEQMe
         IqGNrke0G+r2lZvZQ2sacny2v3YIf/asThGv7Aa0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 110/207] irq: mips: avoid nested irq_enter()
Date:   Wed, 24 Nov 2021 12:56:21 +0100
Message-Id: <20211124115707.638836722@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit c65b52d02f6c1a06ddb20cba175ad49eccd6410d ]

As bcm6345_l1_irq_handle() is a chained irqchip handler, it will be
invoked within the context of the root irqchip handler, which must have
entered IRQ context already.

When bcm6345_l1_irq_handle() calls arch/mips's do_IRQ() , this will nest
another call to irq_enter(), and the resulting nested increment to
`rcu_data.dynticks_nmi_nesting` will cause rcu_is_cpu_rrupt_from_idle()
to fail to identify wakeups from idle, resulting in failure to preempt,
and RCU stalls.

Chained irqchip handlers must invoke IRQ handlers by way of thee core
irqchip code, i.e. generic_handle_irq() or generic_handle_domain_irq()
and should not call do_IRQ(), which is intended only for root irqchip
handlers.

Fix bcm6345_l1_irq_handle() by calling generic_handle_irq() directly.

Fixes: c7c42ec2baa1de7a ("irqchips/bmips: Add bcm6345-l1 interrupt controller")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-bcm6345-l1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-bcm6345-l1.c b/drivers/irqchip/irq-bcm6345-l1.c
index daa4ae89e466e..7ed976d436b25 100644
--- a/drivers/irqchip/irq-bcm6345-l1.c
+++ b/drivers/irqchip/irq-bcm6345-l1.c
@@ -143,7 +143,7 @@ static void bcm6345_l1_irq_handle(struct irq_desc *desc)
 		for_each_set_bit(hwirq, &pending, IRQS_PER_WORD) {
 			irq = irq_linear_revmap(intc->domain, base + hwirq);
 			if (irq)
-				do_IRQ(irq);
+				generic_handle_irq(irq);
 			else
 				spurious_interrupt();
 		}
-- 
2.33.0



