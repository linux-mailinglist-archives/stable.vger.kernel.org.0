Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373011E2C7D
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404422AbgEZTPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:15:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404112AbgEZTPX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:15:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDAFD2053B;
        Tue, 26 May 2020 19:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520523;
        bh=REz7Kk+v4Xq5M2/sBIog3pQekmC3KHv8xVU42CFKSc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WyH7eTeozeH5ADPsQ7D6xZdZgPjiHvRWmJ0SSP3NNKgEci3kx6OZFG+jz6G3k2Ri2
         to3GagT4g2rtw/JKv/guWcYzinUj0YZaaQqfwLCgVZUUtceXHjRWFHmvAjyJgv5sRw
         375VeGIEEOqWWxnvjvYRDjS1bd7bEHX9dFkqbWr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Venkata Narendra Kumar Gutta <vnkgutta@codeaurora.org>,
        Maulik Shah <mkshah@codeaurora.org>,
        Douglas Anderson <dianders@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.6 073/126] pinctrl: qcom: Add affinity callbacks to msmgpio IRQ chip
Date:   Tue, 26 May 2020 20:53:30 +0200
Message-Id: <20200526183944.365007908@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 drivers/pinctrl/qcom/pinctrl-msm.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -1010,6 +1010,29 @@ static void msm_gpio_irq_relres(struct i
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
@@ -1108,6 +1131,8 @@ static int msm_gpio_init(struct msm_pinc
 	pctrl->irq_chip.irq_set_wake = msm_gpio_irq_set_wake;
 	pctrl->irq_chip.irq_request_resources = msm_gpio_irq_reqres;
 	pctrl->irq_chip.irq_release_resources = msm_gpio_irq_relres;
+	pctrl->irq_chip.irq_set_affinity = msm_gpio_irq_set_affinity;
+	pctrl->irq_chip.irq_set_vcpu_affinity = msm_gpio_irq_set_vcpu_affinity;
 
 	np = of_parse_phandle(pctrl->dev->of_node, "wakeup-parent", 0);
 	if (np) {


