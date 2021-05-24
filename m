Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8721238EFF8
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234556AbhEXQAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:00:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235601AbhEXP7s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:59:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A14776197B;
        Mon, 24 May 2021 15:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871131;
        bh=ySwN1vJxApLi8y0eY292G8HYXaeIbbwM7aDyxINP+h4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YaMuty5GFQoQB6g2OKWMMRduQMZOapDbolsTDRaEeUxW4tlTYq3qVObXCf1xtFz3k
         GSD0ahZUuyAJAoxsXi+UAiRpf6usg/elIzCaMFMK9xlTxn5MVfA7eCyn7FKxluFAIg
         EmBtrIXzF1Z9F0qAsJq2cP1OwhzmvauJ8n4arYuI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.12 087/127] gpio: tegra186: Dont set parent IRQ affinity
Date:   Mon, 24 May 2021 17:26:44 +0200
Message-Id: <20210524152337.800955781@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Hunter <jonathanh@nvidia.com>

commit bdbe871ef0caa660e16461a2a94579d9f9ef7ba4 upstream.

When hotplugging CPUs on Tegra186 and Tegra194 errors such as the
following are seen ...

 IRQ63: set affinity failed(-22).
 IRQ65: set affinity failed(-22).
 IRQ66: set affinity failed(-22).
 IRQ67: set affinity failed(-22).

Looking at the /proc/interrupts the above are all interrupts associated
with GPIOs. The reason why these error messages occur is because there
is no 'parent_data' associated with any of the GPIO interrupts and so
tegra186_irq_set_affinity() simply returns -EINVAL.

To understand why there is no 'parent_data' it is first necessary to
understand that in addition to the GPIO interrupts being routed to the
interrupt controller (GIC), the interrupts for some GPIOs are also
routed to the Tegra Power Management Controller (PMC) to wake up the
system from low power states. In order to configure GPIO events as
wake events in the PMC, the PMC is configured as IRQ parent domain
for the GPIO IRQ domain. Originally the GIC was the IRQ parent domain
of the PMC and although this was working, this started causing issues
once commit 64a267e9a41c ("irqchip/gic: Configure SGIs as standard
interrupts") was added, because technically, the GIC is not a parent
of the PMC. Commit c351ab7bf2a5 ("soc/tegra: pmc: Don't create fake
interrupt hierarchy levels") fixed this by severing the IRQ domain
hierarchy for the Tegra GPIOs and hence, there may be no IRQ parent
domain for the GPIOs.

The GPIO controllers on Tegra186 and Tegra194 have either one or six
interrupt lines to the interrupt controller. For GPIO controllers with
six interrupts, the mapping of the GPIO interrupt to the controller
interrupt is configurable within the GPIO controller. Currently a
default mapping is used, however, it could be possible to use the
set affinity callback for the Tegra186 GPIO driver to do something a
bit more interesting. Currently, because interrupts for all GPIOs are
have the same mapping and any attempts to configure the affinity for
a given GPIO can conflict with another that shares the same IRQ, for
now it is simpler to just remove set affinity support and this avoids
the above warnings being seen.

Cc: <stable@vger.kernel.org>
Fixes: c4e1f7d92cd6 ("gpio: tegra186: Set affinity callback to parent")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-tegra186.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/drivers/gpio/gpio-tegra186.c
+++ b/drivers/gpio/gpio-tegra186.c
@@ -444,16 +444,6 @@ static int tegra186_irq_set_wake(struct
 	return 0;
 }
 
-static int tegra186_irq_set_affinity(struct irq_data *data,
-				     const struct cpumask *dest,
-				     bool force)
-{
-	if (data->parent_data)
-		return irq_chip_set_affinity_parent(data, dest, force);
-
-	return -EINVAL;
-}
-
 static void tegra186_gpio_irq(struct irq_desc *desc)
 {
 	struct tegra_gpio *gpio = irq_desc_get_handler_data(desc);
@@ -700,7 +690,6 @@ static int tegra186_gpio_probe(struct pl
 	gpio->intc.irq_unmask = tegra186_irq_unmask;
 	gpio->intc.irq_set_type = tegra186_irq_set_type;
 	gpio->intc.irq_set_wake = tegra186_irq_set_wake;
-	gpio->intc.irq_set_affinity = tegra186_irq_set_affinity;
 
 	irq = &gpio->gpio.irq;
 	irq->chip = &gpio->intc;


