Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9884223A6DE
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgHCMWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:22:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727061AbgHCMWh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:22:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 492E720738;
        Mon,  3 Aug 2020 12:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457355;
        bh=mWAdEnj/kBFJWMdhtZDkNv8Iu4orU8ClLj6g/mEu+wY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vmohLk61iZ5SP4e/lsFOCC1WrzC82ve6xkoHOLPz8wA4vBWf+sPklsaxVGV7k3xFT
         F9cXPIjf14gEteS3O32VFhaQv0l/7dcHEsEjlSix88IoCM4Y2k/+hvmLBWQbMWP8Rd
         VKd+Nb3fX7YnfmgztEMn1NqA+ptMPw4Lf//z8QB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Marc Zyngier <maz@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 038/120] pinctrl: qcom: Handle broken/missing PDC dual edge IRQs on sc7180
Date:   Mon,  3 Aug 2020 14:18:16 +0200
Message-Id: <20200803121904.681793180@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit c3c0c2e18d943ec4a84162ac679970b592555a4a ]

Depending on how you look at it, you can either say that:
a) There is a PDC hardware issue (with the specific IP rev that exists
   on sc7180) that causes the PDC not to work properly when configured
   to handle dual edges.
b) The dual edge feature of the PDC hardware was only added in later
   HW revisions and thus isn't in all hardware.

Regardless of how you look at it, let's work around the lack of dual
edge support by only ever letting our parent see requests for single
edge interrupts on affected hardware.

NOTE: it's possible that a driver requesting a dual edge interrupt
might get several edges coalesced into a single IRQ.  For instance if
a line starts low and then goes high and low again, the driver that
requested the IRQ is not guaranteed to be called twice.  However, it
is guaranteed that once the driver's interrupt handler starts running
its first instruction that any new edges coming in will cause the
interrupt to fire again.  This is relatively commonplace for dual-edge
gpio interrupts (many gpio controllers require software to emulate
dual edge with single edge) so client drivers should be setup to
handle it.

Fixes: e35a6ae0eb3a ("pinctrl/msm: Setup GPIO chip in hierarchy")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200714080254.v3.1.Ie0d730120b232a86a4eac1e2909bcbec844d1766@changeid
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/Kconfig          |  2 +
 drivers/pinctrl/qcom/pinctrl-msm.c    | 74 ++++++++++++++++++++++++++-
 drivers/pinctrl/qcom/pinctrl-msm.h    |  4 ++
 drivers/pinctrl/qcom/pinctrl-sc7180.c |  1 +
 4 files changed, 79 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/qcom/Kconfig b/drivers/pinctrl/qcom/Kconfig
index c5d4428f1f948..2a1233b41aa41 100644
--- a/drivers/pinctrl/qcom/Kconfig
+++ b/drivers/pinctrl/qcom/Kconfig
@@ -7,6 +7,8 @@ config PINCTRL_MSM
 	select PINCONF
 	select GENERIC_PINCONF
 	select GPIOLIB_IRQCHIP
+	select IRQ_DOMAIN_HIERARCHY
+	select IRQ_FASTEOI_HIERARCHY_HANDLERS
 
 config PINCTRL_APQ8064
 	tristate "Qualcomm APQ8064 pin controller driver"
diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index 85858c1d56d02..4ebce5b738454 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -833,6 +833,52 @@ static void msm_gpio_irq_unmask(struct irq_data *d)
 	msm_gpio_irq_clear_unmask(d, false);
 }
 
+/**
+ * msm_gpio_update_dual_edge_parent() - Prime next edge for IRQs handled by parent.
+ * @d: The irq dta.
+ *
+ * This is much like msm_gpio_update_dual_edge_pos() but for IRQs that are
+ * normally handled by the parent irqchip.  The logic here is slightly
+ * different due to what's easy to do with our parent, but in principle it's
+ * the same.
+ */
+static void msm_gpio_update_dual_edge_parent(struct irq_data *d)
+{
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct msm_pinctrl *pctrl = gpiochip_get_data(gc);
+	const struct msm_pingroup *g = &pctrl->soc->groups[d->hwirq];
+	int loop_limit = 100;
+	unsigned int val;
+	unsigned int type;
+
+	/* Read the value and make a guess about what edge we need to catch */
+	val = msm_readl_io(pctrl, g) & BIT(g->in_bit);
+	type = val ? IRQ_TYPE_EDGE_FALLING : IRQ_TYPE_EDGE_RISING;
+
+	do {
+		/* Set the parent to catch the next edge */
+		irq_chip_set_type_parent(d, type);
+
+		/*
+		 * Possibly the line changed between when we last read "val"
+		 * (and decided what edge we needed) and when set the edge.
+		 * If the value didn't change (or changed and then changed
+		 * back) then we're done.
+		 */
+		val = msm_readl_io(pctrl, g) & BIT(g->in_bit);
+		if (type == IRQ_TYPE_EDGE_RISING) {
+			if (!val)
+				return;
+			type = IRQ_TYPE_EDGE_FALLING;
+		} else if (type == IRQ_TYPE_EDGE_FALLING) {
+			if (val)
+				return;
+			type = IRQ_TYPE_EDGE_RISING;
+		}
+	} while (loop_limit-- > 0);
+	dev_warn_once(pctrl->dev, "dual-edge irq failed to stabilize\n");
+}
+
 static void msm_gpio_irq_ack(struct irq_data *d)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
@@ -841,8 +887,11 @@ static void msm_gpio_irq_ack(struct irq_data *d)
 	unsigned long flags;
 	u32 val;
 
-	if (test_bit(d->hwirq, pctrl->skip_wake_irqs))
+	if (test_bit(d->hwirq, pctrl->skip_wake_irqs)) {
+		if (test_bit(d->hwirq, pctrl->dual_edge_irqs))
+			msm_gpio_update_dual_edge_parent(d);
 		return;
+	}
 
 	g = &pctrl->soc->groups[d->hwirq];
 
@@ -861,6 +910,17 @@ static void msm_gpio_irq_ack(struct irq_data *d)
 	raw_spin_unlock_irqrestore(&pctrl->lock, flags);
 }
 
+static bool msm_gpio_needs_dual_edge_parent_workaround(struct irq_data *d,
+						       unsigned int type)
+{
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct msm_pinctrl *pctrl = gpiochip_get_data(gc);
+
+	return type == IRQ_TYPE_EDGE_BOTH &&
+	       pctrl->soc->wakeirq_dual_edge_errata && d->parent_data &&
+	       test_bit(d->hwirq, pctrl->skip_wake_irqs);
+}
+
 static int msm_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
@@ -869,11 +929,21 @@ static int msm_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 	unsigned long flags;
 	u32 val;
 
+	if (msm_gpio_needs_dual_edge_parent_workaround(d, type)) {
+		set_bit(d->hwirq, pctrl->dual_edge_irqs);
+		irq_set_handler_locked(d, handle_fasteoi_ack_irq);
+		msm_gpio_update_dual_edge_parent(d);
+		return 0;
+	}
+
 	if (d->parent_data)
 		irq_chip_set_type_parent(d, type);
 
-	if (test_bit(d->hwirq, pctrl->skip_wake_irqs))
+	if (test_bit(d->hwirq, pctrl->skip_wake_irqs)) {
+		clear_bit(d->hwirq, pctrl->dual_edge_irqs);
+		irq_set_handler_locked(d, handle_fasteoi_irq);
 		return 0;
+	}
 
 	g = &pctrl->soc->groups[d->hwirq];
 
diff --git a/drivers/pinctrl/qcom/pinctrl-msm.h b/drivers/pinctrl/qcom/pinctrl-msm.h
index 9452da18a78bd..7486fe08eb9b6 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.h
+++ b/drivers/pinctrl/qcom/pinctrl-msm.h
@@ -113,6 +113,9 @@ struct msm_gpio_wakeirq_map {
  * @pull_no_keeper: The SoC does not support keeper bias.
  * @wakeirq_map:    The map of wakeup capable GPIOs and the pin at PDC/MPM
  * @nwakeirq_map:   The number of entries in @wakeirq_map
+ * @wakeirq_dual_edge_errata: If true then GPIOs using the wakeirq_map need
+ *                            to be aware that their parent can't handle dual
+ *                            edge interrupts.
  */
 struct msm_pinctrl_soc_data {
 	const struct pinctrl_pin_desc *pins;
@@ -128,6 +131,7 @@ struct msm_pinctrl_soc_data {
 	const int *reserved_gpios;
 	const struct msm_gpio_wakeirq_map *wakeirq_map;
 	unsigned int nwakeirq_map;
+	bool wakeirq_dual_edge_errata;
 };
 
 extern const struct dev_pm_ops msm_pinctrl_dev_pm_ops;
diff --git a/drivers/pinctrl/qcom/pinctrl-sc7180.c b/drivers/pinctrl/qcom/pinctrl-sc7180.c
index 1b6465a882f21..1d9acad3c1ce2 100644
--- a/drivers/pinctrl/qcom/pinctrl-sc7180.c
+++ b/drivers/pinctrl/qcom/pinctrl-sc7180.c
@@ -1147,6 +1147,7 @@ static const struct msm_pinctrl_soc_data sc7180_pinctrl = {
 	.ntiles = ARRAY_SIZE(sc7180_tiles),
 	.wakeirq_map = sc7180_pdc_map,
 	.nwakeirq_map = ARRAY_SIZE(sc7180_pdc_map),
+	.wakeirq_dual_edge_errata = true,
 };
 
 static int sc7180_pinctrl_probe(struct platform_device *pdev)
-- 
2.25.1



