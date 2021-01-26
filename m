Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A02A23031A3
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 03:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731366AbhAYSzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:55:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:40936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731062AbhAYSy5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:54:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF8BD2074B;
        Mon, 25 Jan 2021 18:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600882;
        bh=F2KhbkdM5kdozMCfnf+UP0A137aoseQ2sDhZjGYPWG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f6nikJQKSQGFRg1wc5nYp/LgAlPOCMwrces0wSTsgzB44I2lJOsIAMaPywf7s4jLG
         rUnsRM/0Zt1gNYNdvnXLD1/JxqKqNmipI9zI5tGqJYhpD1q8IITcQlRCXdfJiKXAvS
         bPq62YWjVBKF+DV/+reWatt2C1g3/qO/6Xuxt35M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Maulik Shah <mkshah@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.10 186/199] pinctrl: qcom: Dont clear pending interrupts when enabling
Date:   Mon, 25 Jan 2021 19:40:08 +0100
Message-Id: <20210125183224.028424479@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

commit cf9d052aa6005f1e8dfaf491d83bf37f368af69e upstream.

In Linux, if a driver does disable_irq() and later does enable_irq()
on its interrupt, I believe it's expecting these properties:
* If an interrupt was pending when the driver disabled then it will
  still be pending after the driver re-enables.
* If an edge-triggered interrupt comes in while an interrupt is
  disabled it should assert when the interrupt is re-enabled.

If you think that the above sounds a lot like the disable_irq() and
enable_irq() are supposed to be masking/unmasking the interrupt
instead of disabling/enabling it then you've made an astute
observation.  Specifically when talking about interrupts, "mask"
usually means to stop posting interrupts but keep tracking them and
"disable" means to fully shut off interrupt detection.  It's
unfortunate that this is so confusing, but presumably this is all the
way it is for historical reasons.

Perhaps more confusing than the above is that, even though clients of
IRQs themselves don't have a way to request mask/unmask
vs. disable/enable calls, IRQ chips themselves can implement both.
...and yet more confusing is that if an IRQ chip implements
disable/enable then they will be called when a client driver calls
disable_irq() / enable_irq().

It does feel like some of the above could be cleared up.  However,
without any other core interrupt changes it should be clear that when
an IRQ chip gets a request to "disable" an IRQ that it has to treat it
like a mask of that IRQ.

In any case, after that long interlude you can see that the "unmask
and clear" can break things.  Maulik tried to fix it so that we no
longer did "unmask and clear" in commit 71266d9d3936 ("pinctrl: qcom:
Move clearing pending IRQ to .irq_request_resources callback"), but it
only handled the PDC case and it had problems (it caused
sc7180-trogdor devices to fail to suspend).  Let's fix.

>From my understanding the source of the phantom interrupt in the
were these two things:
1. One that could have been introduced in msm_gpio_irq_set_type()
   (only for the non-PDC case).
2. Edges could have been detected when a GPIO was muxed away.

Fixing case #1 is easy.  We can just add a clear in
msm_gpio_irq_set_type().

Fixing case #2 is harder.  Let's use a concrete example.  In
sc7180-trogdor.dtsi we configure the uart3 to have two pinctrl states,
sleep and default, and mux between the two during runtime PM and
system suspend (see geni_se_resources_{on,off}() for more
details). The difference between the sleep and default state is that
the RX pin is muxed to a GPIO during sleep and muxed to the UART
otherwise.

As per Qualcomm, when we mux the pin over to the UART function the PDC
(or the non-PDC interrupt detection logic) is still watching it /
latching edges.  These edges don't cause interrupts because the
current code masks the interrupt unless we're entering suspend.
However, as soon as we enter suspend we unmask the interrupt and it's
counted as a wakeup.

Let's deal with the problem like this:
* When we mux away, we'll mask our interrupt.  This isn't necessary in
  the above case since the client already masked us, but it's a good
  idea in general.
* When we mux back will clear any interrupts and unmask.

Fixes: 4b7618fdc7e6 ("pinctrl: qcom: Add irq_enable callback for msm gpio")
Fixes: 71266d9d3936 ("pinctrl: qcom: Move clearing pending IRQ to .irq_request_resources callback")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Maulik Shah <mkshah@codeaurora.org>
Tested-by: Maulik Shah <mkshah@codeaurora.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20210114191601.v7.4.I7cf3019783720feb57b958c95c2b684940264cd1@changeid
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/qcom/pinctrl-msm.c |   74 +++++++++++++++++++++++++------------
 1 file changed, 50 insertions(+), 24 deletions(-)

--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -51,6 +51,7 @@
  * @dual_edge_irqs: Bitmap of irqs that need sw emulated dual edge
  *                  detection.
  * @skip_wake_irqs: Skip IRQs that are handled by wakeup interrupt controller
+ * @disabled_for_mux: These IRQs were disabled because we muxed away.
  * @soc:            Reference to soc_data of platform specific data.
  * @regs:           Base addresses for the TLMM tiles.
  * @phys_base:      Physical base address
@@ -72,6 +73,7 @@ struct msm_pinctrl {
 	DECLARE_BITMAP(dual_edge_irqs, MAX_NR_GPIO);
 	DECLARE_BITMAP(enabled_irqs, MAX_NR_GPIO);
 	DECLARE_BITMAP(skip_wake_irqs, MAX_NR_GPIO);
+	DECLARE_BITMAP(disabled_for_mux, MAX_NR_GPIO);
 
 	const struct msm_pinctrl_soc_data *soc;
 	void __iomem *regs[MAX_NR_TILES];
@@ -179,6 +181,10 @@ static int msm_pinmux_set_mux(struct pin
 			      unsigned group)
 {
 	struct msm_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
+	struct gpio_chip *gc = &pctrl->chip;
+	unsigned int irq = irq_find_mapping(gc->irq.domain, group);
+	struct irq_data *d = irq_get_irq_data(irq);
+	unsigned int gpio_func = pctrl->soc->gpio_func;
 	const struct msm_pingroup *g;
 	unsigned long flags;
 	u32 val, mask;
@@ -195,6 +201,20 @@ static int msm_pinmux_set_mux(struct pin
 	if (WARN_ON(i == g->nfuncs))
 		return -EINVAL;
 
+	/*
+	 * If an GPIO interrupt is setup on this pin then we need special
+	 * handling.  Specifically interrupt detection logic will still see
+	 * the pin twiddle even when we're muxed away.
+	 *
+	 * When we see a pin with an interrupt setup on it then we'll disable
+	 * (mask) interrupts on it when we mux away until we mux back.  Note
+	 * that disable_irq() refcounts and interrupts are disabled as long as
+	 * at least one disable_irq() has been called.
+	 */
+	if (d && i != gpio_func &&
+	    !test_and_set_bit(d->hwirq, pctrl->disabled_for_mux))
+		disable_irq(irq);
+
 	raw_spin_lock_irqsave(&pctrl->lock, flags);
 
 	val = msm_readl_ctl(pctrl, g);
@@ -204,6 +224,20 @@ static int msm_pinmux_set_mux(struct pin
 
 	raw_spin_unlock_irqrestore(&pctrl->lock, flags);
 
+	if (d && i == gpio_func &&
+	    test_and_clear_bit(d->hwirq, pctrl->disabled_for_mux)) {
+		/*
+		 * Clear interrupts detected while not GPIO since we only
+		 * masked things.
+		 */
+		if (d->parent_data && test_bit(d->hwirq, pctrl->skip_wake_irqs))
+			irq_chip_set_parent_state(d, IRQCHIP_STATE_PENDING, false);
+		else
+			msm_ack_intr_status(pctrl, g);
+
+		enable_irq(irq);
+	}
+
 	return 0;
 }
 
@@ -781,7 +815,7 @@ static void msm_gpio_irq_mask(struct irq
 	raw_spin_unlock_irqrestore(&pctrl->lock, flags);
 }
 
-static void msm_gpio_irq_clear_unmask(struct irq_data *d, bool status_clear)
+static void msm_gpio_irq_unmask(struct irq_data *d)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct msm_pinctrl *pctrl = gpiochip_get_data(gc);
@@ -799,14 +833,6 @@ static void msm_gpio_irq_clear_unmask(st
 
 	raw_spin_lock_irqsave(&pctrl->lock, flags);
 
-	/*
-	 * clear the interrupt status bit before unmask to avoid
-	 * any erroneous interrupts that would have got latched
-	 * when the interrupt is not in use.
-	 */
-	if (status_clear)
-		msm_ack_intr_status(pctrl, g);
-
 	val = msm_readl_intr_cfg(pctrl, g);
 	val |= BIT(g->intr_raw_status_bit);
 	val |= BIT(g->intr_enable_bit);
@@ -826,7 +852,7 @@ static void msm_gpio_irq_enable(struct i
 		irq_chip_enable_parent(d);
 
 	if (!test_bit(d->hwirq, pctrl->skip_wake_irqs))
-		msm_gpio_irq_clear_unmask(d, true);
+		msm_gpio_irq_unmask(d);
 }
 
 static void msm_gpio_irq_disable(struct irq_data *d)
@@ -841,11 +867,6 @@ static void msm_gpio_irq_disable(struct
 		msm_gpio_irq_mask(d);
 }
 
-static void msm_gpio_irq_unmask(struct irq_data *d)
-{
-	msm_gpio_irq_clear_unmask(d, false);
-}
-
 /**
  * msm_gpio_update_dual_edge_parent() - Prime next edge for IRQs handled by parent.
  * @d: The irq dta.
@@ -934,6 +955,7 @@ static int msm_gpio_irq_set_type(struct
 	struct msm_pinctrl *pctrl = gpiochip_get_data(gc);
 	const struct msm_pingroup *g;
 	unsigned long flags;
+	bool was_enabled;
 	u32 val;
 
 	if (msm_gpio_needs_dual_edge_parent_workaround(d, type)) {
@@ -995,6 +1017,7 @@ static int msm_gpio_irq_set_type(struct
 	 * could cause the INTR_STATUS to be set for EDGE interrupts.
 	 */
 	val = msm_readl_intr_cfg(pctrl, g);
+	was_enabled = val & BIT(g->intr_raw_status_bit);
 	val |= BIT(g->intr_raw_status_bit);
 	if (g->intr_detection_width == 2) {
 		val &= ~(3 << g->intr_detection_bit);
@@ -1044,6 +1067,14 @@ static int msm_gpio_irq_set_type(struct
 	}
 	msm_writel_intr_cfg(val, pctrl, g);
 
+	/*
+	 * The first time we set RAW_STATUS_EN it could trigger an interrupt.
+	 * Clear the interrupt.  This is safe because we have
+	 * IRQCHIP_SET_TYPE_MASKED.
+	 */
+	if (!was_enabled)
+		msm_ack_intr_status(pctrl, g);
+
 	if (test_bit(d->hwirq, pctrl->dual_edge_irqs))
 		msm_gpio_update_dual_edge_pos(pctrl, g, d);
 
@@ -1097,16 +1128,11 @@ static int msm_gpio_irq_reqres(struct ir
 	}
 
 	/*
-	 * Clear the interrupt that may be pending before we enable
-	 * the line.
-	 * This is especially a problem with the GPIOs routed to the
-	 * PDC. These GPIOs are direct-connect interrupts to the GIC.
-	 * Disabling the interrupt line at the PDC does not prevent
-	 * the interrupt from being latched at the GIC. The state at
-	 * GIC needs to be cleared before enabling.
+	 * The disable / clear-enable workaround we do in msm_pinmux_set_mux()
+	 * only works if disable is not lazy since we only clear any bogus
+	 * interrupt in hardware. Explicitly mark the interrupt as UNLAZY.
 	 */
-	if (d->parent_data && test_bit(d->hwirq, pctrl->skip_wake_irqs))
-		irq_chip_set_parent_state(d, IRQCHIP_STATE_PENDING, 0);
+	irq_set_status_flags(d->irq, IRQ_DISABLE_UNLAZY);
 
 	return 0;
 out:


