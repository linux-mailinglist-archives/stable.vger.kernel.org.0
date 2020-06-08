Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3816B1F2D51
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733131AbgFIAcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:32:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728576AbgFHXPP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:15:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C84321531;
        Mon,  8 Jun 2020 23:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658114;
        bh=U4a716t1zfB5zL2gtGQ6ceowiQ4YOsRO6zDnhNKNyKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H9T0ycRFoGB813INPHrl1lodbv8tLA1ucqGA4UzV9rwFXyfdG/YOzkEHIhpn4bO8g
         JNiOnsjX9wD5pc91Hyx55MqflMAg8fclz+f5sN3h1Ic2Tb/7oXVM5CAUMGh4/wxDxH
         4XfNErw9HDAmU1RlXry/VbRukcw/TffSt+FuqNqc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Venkata Narendra Kumar Gutta <vnkgutta@codeaurora.org>,
        Maulik Shah <mkshah@codeaurora.org>,
        Douglas Anderson <dianders@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 152/606] pinctrl: qcom: Add affinity callbacks to msmgpio IRQ chip
Date:   Mon,  8 Jun 2020 19:04:37 -0400
Message-Id: <20200608231211.3363633-152-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Venkata Narendra Kumar Gutta <vnkgutta@codeaurora.org>

commit dca4f40742e09ec5d908a7fc2862498e6cf9d911 upstream.

Wakeup capable GPIO IRQs routed via PDC are not being migrated when a CPU
is hotplugged. Add affinity callbacks to msmgpio IRQ chip to update the
affinity of wakeup capable IRQs.

Fixes: e35a6ae0eb3a ("pinctrl/msm: Setup GPIO chip in hierarchy")
Signed-off-by: Venkata Narendra Kumar Gutta <vnkgutta@codeaurora.org>
[mkshah: updated commit text and minor code fixes]
Signed-off-by: Maulik Shah <mkshah@codeaurora.org>
Tested-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/1588314617-4556-1-git-send-email-mkshah@codeaurora.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/qcom/pinctrl-msm.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index 9f1c9951949e..14a8f8fa0ea3 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -1010,6 +1010,29 @@ static void msm_gpio_irq_relres(struct irq_data *d)
 	module_put(gc->owner);
 }
 
+static int msm_gpio_irq_set_affinity(struct irq_data *d,
+				const struct cpumask *dest, bool force)
+{
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct msm_pinctrl *pctrl = gpiochip_get_data(gc);
+
+	if (d->parent_data && test_bit(d->hwirq, pctrl->skip_wake_irqs))
+		return irq_chip_set_affinity_parent(d, dest, force);
+
+	return 0;
+}
+
+static int msm_gpio_irq_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
+{
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct msm_pinctrl *pctrl = gpiochip_get_data(gc);
+
+	if (d->parent_data && test_bit(d->hwirq, pctrl->skip_wake_irqs))
+		return irq_chip_set_vcpu_affinity_parent(d, vcpu_info);
+
+	return 0;
+}
+
 static void msm_gpio_irq_handler(struct irq_desc *desc)
 {
 	struct gpio_chip *gc = irq_desc_get_handler_data(desc);
@@ -1108,6 +1131,8 @@ static int msm_gpio_init(struct msm_pinctrl *pctrl)
 	pctrl->irq_chip.irq_set_wake = msm_gpio_irq_set_wake;
 	pctrl->irq_chip.irq_request_resources = msm_gpio_irq_reqres;
 	pctrl->irq_chip.irq_release_resources = msm_gpio_irq_relres;
+	pctrl->irq_chip.irq_set_affinity = msm_gpio_irq_set_affinity;
+	pctrl->irq_chip.irq_set_vcpu_affinity = msm_gpio_irq_set_vcpu_affinity;
 
 	np = of_parse_phandle(pctrl->dev->of_node, "wakeup-parent", 0);
 	if (np) {
-- 
2.25.1

