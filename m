Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0AA681165
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237224AbjA3ONQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:13:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237306AbjA3ONI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:13:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8615D5276
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:12:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 655BD61035
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:12:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58136C433D2;
        Mon, 30 Jan 2023 14:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087971;
        bh=SpKR6kXQ7uEP5pqQ7D79aqSZpEYKhGNStOZ+YFs1cYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M6pi8UV5UOdkio1IAHr3f3hE/Gb5aiSr+jHjv83cP+2JPgus9aQL9Qz0yejudKri1
         PhWo8LK4x1y6j4FO8Hr2dR6Ebv9jYSWpW5GE4LofWqtscsZ4JdGF/jCBibQbyuoEHV
         PCd/WBeNPvTI0S9GulJWjwJSl0VC4kDEsK3ettr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Linus Walleij <linus.walleij@linaro.org>,
        Marc Zyngier <maz@kernel.org>, Marek Vasut <marex@denx.de>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/204] gpio: mxc: Protect GPIO irqchip RMW with bgpio spinlock
Date:   Mon, 30 Jan 2023 14:50:08 +0100
Message-Id: <20230130134318.214538458@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit e5464277625c1aca5c002e0f470377cdd6816dcf ]

The driver currently performs register read-modify-write without locking
in its irqchip part, this could lead to a race condition when configuring
interrupt mode setting. Add the missing bgpio spinlock lock/unlock around
the register read-modify-write.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Fixes: 07bd1a6cc7cbb ("MXC arch: Add gpio support for the whole platform")
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mxc.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
index c871602fc5ba..6cc98a5684ae 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/spinlock.h>
 #include <linux/syscore_ops.h>
 #include <linux/gpio/driver.h>
 #include <linux/of.h>
@@ -147,6 +148,7 @@ static int gpio_set_irq_type(struct irq_data *d, u32 type)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	struct mxc_gpio_port *port = gc->private;
+	unsigned long flags;
 	u32 bit, val;
 	u32 gpio_idx = d->hwirq;
 	int edge;
@@ -185,6 +187,8 @@ static int gpio_set_irq_type(struct irq_data *d, u32 type)
 		return -EINVAL;
 	}
 
+	raw_spin_lock_irqsave(&port->gc.bgpio_lock, flags);
+
 	if (GPIO_EDGE_SEL >= 0) {
 		val = readl(port->base + GPIO_EDGE_SEL);
 		if (edge == GPIO_INT_BOTH_EDGES)
@@ -204,15 +208,20 @@ static int gpio_set_irq_type(struct irq_data *d, u32 type)
 
 	writel(1 << gpio_idx, port->base + GPIO_ISR);
 
+	raw_spin_unlock_irqrestore(&port->gc.bgpio_lock, flags);
+
 	return 0;
 }
 
 static void mxc_flip_edge(struct mxc_gpio_port *port, u32 gpio)
 {
 	void __iomem *reg = port->base;
+	unsigned long flags;
 	u32 bit, val;
 	int edge;
 
+	raw_spin_lock_irqsave(&port->gc.bgpio_lock, flags);
+
 	reg += GPIO_ICR1 + ((gpio & 0x10) >> 2); /* lower or upper register */
 	bit = gpio & 0xf;
 	val = readl(reg);
@@ -230,6 +239,8 @@ static void mxc_flip_edge(struct mxc_gpio_port *port, u32 gpio)
 		return;
 	}
 	writel(val | (edge << (bit << 1)), reg);
+
+	raw_spin_unlock_irqrestore(&port->gc.bgpio_lock, flags);
 }
 
 /* handle 32 interrupts in one status register */
-- 
2.39.0



