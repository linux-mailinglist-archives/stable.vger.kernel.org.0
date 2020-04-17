Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7221ADA89
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 11:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbgDQJ4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 05:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727976AbgDQJ4t (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Apr 2020 05:56:49 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0470CC061A0C;
        Fri, 17 Apr 2020 02:56:49 -0700 (PDT)
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jPNjp-0005er-Dm; Fri, 17 Apr 2020 11:56:45 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 12C621C0072;
        Fri, 17 Apr 2020 11:56:45 +0200 (CEST)
Date:   Fri, 17 Apr 2020 09:56:44 -0000
From:   "tip-bot2 for Grygorii Strashko" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/urgent] irqchip/ti-sci-inta: Fix processing of masked irqs
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Marc Zyngier <maz@kernel.org>,
        Lokesh Vutla <lokeshvutla@ti.com>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200408191532.31252-1-grygorii.strashko@ti.com>
References: <20200408191532.31252-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Message-ID: <158711740470.28353.5640568811566417444.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/urgent branch of tip:

Commit-ID:     3688b0db5c331f4ec3fa5eb9f670a4b04f530700
Gitweb:        https://git.kernel.org/tip/3688b0db5c331f4ec3fa5eb9f670a4b04f530700
Author:        Grygorii Strashko <grygorii.strashko@ti.com>
AuthorDate:    Wed, 08 Apr 2020 22:15:32 +03:00
Committer:     Marc Zyngier <maz@kernel.org>
CommitterDate: Fri, 17 Apr 2020 08:59:28 +01:00

irqchip/ti-sci-inta: Fix processing of masked irqs

The ti_sci_inta_irq_handler() does not take into account INTA IRQs state
(masked/unmasked) as it uses INTA_STATUS_CLEAR_j register to get INTA IRQs
status, which provides raw status value.
This causes hard IRQ handlers to be called or threaded handlers to be
scheduled many times even if corresponding INTA IRQ is masked.
Above, first of all, affects the LEVEL interrupts processing and causes
unexpected behavior up the system stack or crash.

Fix it by using the Interrupt Masked Status INTA_STATUSM_j register which
provides masked INTA IRQs status.

Fixes: 9f1463b86c13 ("irqchip/ti-sci-inta: Add support for Interrupt Aggregator driver")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Lokesh Vutla <lokeshvutla@ti.com>
Link: https://lore.kernel.org/r/20200408191532.31252-1-grygorii.strashko@ti.com
Cc: stable@vger.kernel.org
---
 drivers/irqchip/irq-ti-sci-inta.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-ti-sci-inta.c b/drivers/irqchip/irq-ti-sci-inta.c
index 8f6e6b0..7e3ebf6 100644
--- a/drivers/irqchip/irq-ti-sci-inta.c
+++ b/drivers/irqchip/irq-ti-sci-inta.c
@@ -37,6 +37,7 @@
 #define VINT_ENABLE_SET_OFFSET	0x0
 #define VINT_ENABLE_CLR_OFFSET	0x8
 #define VINT_STATUS_OFFSET	0x18
+#define VINT_STATUS_MASKED_OFFSET	0x20
 
 /**
  * struct ti_sci_inta_event_desc - Description of an event coming to
@@ -116,7 +117,7 @@ static void ti_sci_inta_irq_handler(struct irq_desc *desc)
 	chained_irq_enter(irq_desc_get_chip(desc), desc);
 
 	val = readq_relaxed(inta->base + vint_desc->vint_id * 0x1000 +
-			    VINT_STATUS_OFFSET);
+			    VINT_STATUS_MASKED_OFFSET);
 
 	for_each_set_bit(bit, &val, MAX_EVENTS_PER_VINT) {
 		virq = irq_find_mapping(domain, vint_desc->events[bit].hwirq);
