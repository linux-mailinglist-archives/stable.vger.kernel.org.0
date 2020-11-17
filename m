Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7032B6460
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732769AbgKQNq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:46:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:48324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732918AbgKQNhR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:37:17 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B711820870;
        Tue, 17 Nov 2020 13:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620234;
        bh=myYv0he5p2CdkcgI5uEpZSWy6z0e2rA2qvajbIVRYqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cf/pz+WZzA2aNsNB8ju1LR2o2a0VfJSCTqGH6gA1uziCzAsMOLKfuR0aLwTr0ZNL4
         jJDAEvQPOdZ34jcG4cv1lSs6B6u10jmaS8u3aQVdDoQ36fYvMmAIkXA3XnzO59elER
         AN49seZyX1Pnx2j/8AdufKJdCkB2x2793ELVa0KI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maulik Shah <mkshah@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 150/255] pinctrl: qcom: Move clearing pending IRQ to .irq_request_resources callback
Date:   Tue, 17 Nov 2020 14:04:50 +0100
Message-Id: <20201117122146.265586695@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maulik Shah <mkshah@codeaurora.org>

[ Upstream commit 71266d9d39366c9b24b866d811b3facaf837f13f ]

When GPIOs that are routed to PDC are used as output they can still latch
the IRQ pending at GIC. As a result the spurious IRQ was handled when the
client driver change the direction to input to starts using it as IRQ.

Currently such erroneous latched IRQ are cleared with .irq_enable callback
however if the driver continue to use GPIO as interrupt and invokes
disable_irq() followed by enable_irq() then everytime during enable_irq()
previously latched interrupt gets cleared.

This can make edge IRQs not seen after enable_irq() if they had arrived
after the driver has invoked disable_irq() and were pending at GIC.

Move clearing erroneous IRQ to .irq_request_resources callback as this is
the place where GPIO direction is changed as input and its locked as IRQ.

While at this add a missing check to invoke msm_gpio_irq_clear_unmask()
from .irq_enable callback only when GPIO is not routed to PDC.

Fixes: e35a6ae0eb3a ("pinctrl/msm: Setup GPIO chip in hierarchy")
Signed-off-by: Maulik Shah <mkshah@codeaurora.org>
Link: https://lore.kernel.org/r/1604561884-10166-1-git-send-email-mkshah@codeaurora.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-msm.c | 32 ++++++++++++++++++------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index 1df232266f63a..1554f0275067e 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -815,21 +815,14 @@ static void msm_gpio_irq_clear_unmask(struct irq_data *d, bool status_clear)
 
 static void msm_gpio_irq_enable(struct irq_data *d)
 {
-	/*
-	 * Clear the interrupt that may be pending before we enable
-	 * the line.
-	 * This is especially a problem with the GPIOs routed to the
-	 * PDC. These GPIOs are direct-connect interrupts to the GIC.
-	 * Disabling the interrupt line at the PDC does not prevent
-	 * the interrupt from being latched at the GIC. The state at
-	 * GIC needs to be cleared before enabling.
-	 */
-	if (d->parent_data) {
-		irq_chip_set_parent_state(d, IRQCHIP_STATE_PENDING, 0);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct msm_pinctrl *pctrl = gpiochip_get_data(gc);
+
+	if (d->parent_data)
 		irq_chip_enable_parent(d);
-	}
 
-	msm_gpio_irq_clear_unmask(d, true);
+	if (!test_bit(d->hwirq, pctrl->skip_wake_irqs))
+		msm_gpio_irq_clear_unmask(d, true);
 }
 
 static void msm_gpio_irq_disable(struct irq_data *d)
@@ -1104,6 +1097,19 @@ static int msm_gpio_irq_reqres(struct irq_data *d)
 		ret = -EINVAL;
 		goto out;
 	}
+
+	/*
+	 * Clear the interrupt that may be pending before we enable
+	 * the line.
+	 * This is especially a problem with the GPIOs routed to the
+	 * PDC. These GPIOs are direct-connect interrupts to the GIC.
+	 * Disabling the interrupt line at the PDC does not prevent
+	 * the interrupt from being latched at the GIC. The state at
+	 * GIC needs to be cleared before enabling.
+	 */
+	if (d->parent_data && test_bit(d->hwirq, pctrl->skip_wake_irqs))
+		irq_chip_set_parent_state(d, IRQCHIP_STATE_PENDING, 0);
+
 	return 0;
 out:
 	module_put(gc->owner);
-- 
2.27.0



