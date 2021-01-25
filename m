Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E389130319F
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 03:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729952AbhAYSzf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:55:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:41474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731372AbhAYSzU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:55:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 585F12067B;
        Mon, 25 Jan 2021 18:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600879;
        bh=/DI96KZo8TZPVizWJqZbIZwmrWP7GY5JCLdjj13HAxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dEMtUBYyjJyNwXpwWe/j3VvvpA0tW84UBVEiR244hyM0Gphpyuw/k6s6Xq/t07fMS
         21fNzRHVvRLwUaD6/HaMeE4cfnajq+VWz8Ubkum28vKvqXBTLy6fR++p/8LX3seFqj
         VdNLhle+Nx4HgebUQH1c8oTgzMnaFANExazo8IGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Maulik Shah <mkshah@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.10 185/199] pinctrl: qcom: Properly clear "intr_ack_high" interrupts when unmasking
Date:   Mon, 25 Jan 2021 19:40:07 +0100
Message-Id: <20210125183223.986951189@linuxfoundation.org>
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

commit a95881d6aa2c000e3649f27a1a7329cf356e6bb3 upstream.

In commit 4b7618fdc7e6 ("pinctrl: qcom: Add irq_enable callback for
msm gpio") we tried to Ack interrupts during unmask.  However, that
patch forgot to check "intr_ack_high" so, presumably, it only worked
for a certain subset of SoCs.

Let's add a small accessor so we don't need to open-code the logic in
both places.

This was found by code inspection.  I don't have any access to the
hardware in question nor software that needs the Ack during unmask.

Fixes: 4b7618fdc7e6 ("pinctrl: qcom: Add irq_enable callback for msm gpio")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Maulik Shah <mkshah@codeaurora.org>
Tested-by: Maulik Shah <mkshah@codeaurora.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210114191601.v7.3.I32d0f4e174d45363b49ab611a13c3da8f1e87d0f@changeid
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/qcom/pinctrl-msm.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -96,6 +96,14 @@ MSM_ACCESSOR(intr_cfg)
 MSM_ACCESSOR(intr_status)
 MSM_ACCESSOR(intr_target)
 
+static void msm_ack_intr_status(struct msm_pinctrl *pctrl,
+				const struct msm_pingroup *g)
+{
+	u32 val = g->intr_ack_high ? BIT(g->intr_status_bit) : 0;
+
+	msm_writel_intr_status(val, pctrl, g);
+}
+
 static int msm_get_groups_count(struct pinctrl_dev *pctldev)
 {
 	struct msm_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
@@ -797,7 +805,7 @@ static void msm_gpio_irq_clear_unmask(st
 	 * when the interrupt is not in use.
 	 */
 	if (status_clear)
-		msm_writel_intr_status(0, pctrl, g);
+		msm_ack_intr_status(pctrl, g);
 
 	val = msm_readl_intr_cfg(pctrl, g);
 	val |= BIT(g->intr_raw_status_bit);
@@ -890,7 +898,6 @@ static void msm_gpio_irq_ack(struct irq_
 	struct msm_pinctrl *pctrl = gpiochip_get_data(gc);
 	const struct msm_pingroup *g;
 	unsigned long flags;
-	u32 val;
 
 	if (test_bit(d->hwirq, pctrl->skip_wake_irqs)) {
 		if (test_bit(d->hwirq, pctrl->dual_edge_irqs))
@@ -902,8 +909,7 @@ static void msm_gpio_irq_ack(struct irq_
 
 	raw_spin_lock_irqsave(&pctrl->lock, flags);
 
-	val = g->intr_ack_high ? BIT(g->intr_status_bit) : 0;
-	msm_writel_intr_status(val, pctrl, g);
+	msm_ack_intr_status(pctrl, g);
 
 	if (test_bit(d->hwirq, pctrl->dual_edge_irqs))
 		msm_gpio_update_dual_edge_pos(pctrl, g, d);


