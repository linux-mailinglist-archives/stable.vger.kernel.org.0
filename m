Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE65451123
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243405AbhKOTB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:01:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:59676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243477AbhKOS7x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:59:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CE946121F;
        Mon, 15 Nov 2021 18:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000007;
        bh=WUOszUa6abMStEzb5VLy1TxoqPiX+++P2jKUYPXEycQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DHBICv4DxS+nuRPxwrnas+SRx55uxZG0300ziUPXjOs1PJg/cwAGl/MHGwLjOs0E9
         lHHJaGuYB7bs65uTMm0c9llm9CTie7C+H/R6XBs3Wl6ehFPBCb+ZqhC6okzapiTp9R
         kI4oIRcvDc784bRyqwGgAvk8u6tDTFbxEjtL9MRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 504/849] irq: mips: avoid nested irq_enter()
Date:   Mon, 15 Nov 2021 17:59:47 +0100
Message-Id: <20211115165437.332336962@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index e3483789f4df3..1bd0621c4ce2a 100644
--- a/drivers/irqchip/irq-bcm6345-l1.c
+++ b/drivers/irqchip/irq-bcm6345-l1.c
@@ -140,7 +140,7 @@ static void bcm6345_l1_irq_handle(struct irq_desc *desc)
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



