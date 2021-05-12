Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8669C37CD9D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238879AbhELQ4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:56:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244018AbhELQm0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D82CC61CFE;
        Wed, 12 May 2021 16:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835766;
        bh=QYhKg1ipg8gwStly9KfleUaRd3j7GsHD+zBg5syh+Bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aLrz9UtzMR8gzuErOj1gkd7oPt9CpWaO2or28E7roVrWxeq7zpYRgf51/KB8UQgqa
         nG7BmuRb0gJlQF97oHclj/vciMx4a3uG/huAfFpZ+dXGDlEPL1l4vFBWVc1/pLNA8M
         Hn0VgI2WAz/dx7VR7pIZucoLKlvNkXLpOdEdVVRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>, Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 476/677] gpio: guard gpiochip_irqchip_add_domain() with GPIOLIB_IRQCHIP
Date:   Wed, 12 May 2021 16:48:42 +0200
Message-Id: <20210512144853.166617268@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Álvaro Fernández Rojas <noltari@gmail.com>

[ Upstream commit 9c7d24693d864f90b27aad5d15fbfe226c02898b ]

The current code doesn't check if GPIOLIB_IRQCHIP is enabled, which results in
a compilation error when trying to build gpio-regmap if CONFIG_GPIOLIB_IRQCHIP
isn't enabled.

Fixes: 6a45b0e2589f ("gpiolib: Introduce gpiochip_irqchip_add_domain()")
Suggested-by: Michael Walle <michael@walle.cc>
Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Michael Walle <michael@walle.cc>
Acked-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Link: https://lore.kernel.org/r/20210324081923.20379-2-noltari@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/gpio/driver.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index 286de0520574..ecf0032a0995 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -624,8 +624,17 @@ void gpiochip_irq_domain_deactivate(struct irq_domain *domain,
 bool gpiochip_irqchip_irq_valid(const struct gpio_chip *gc,
 				unsigned int offset);
 
+#ifdef CONFIG_GPIOLIB_IRQCHIP
 int gpiochip_irqchip_add_domain(struct gpio_chip *gc,
 				struct irq_domain *domain);
+#else
+static inline int gpiochip_irqchip_add_domain(struct gpio_chip *gc,
+					      struct irq_domain *domain)
+{
+	WARN_ON(1);
+	return -EINVAL;
+}
+#endif
 
 int gpiochip_generic_request(struct gpio_chip *gc, unsigned int offset);
 void gpiochip_generic_free(struct gpio_chip *gc, unsigned int offset);
-- 
2.30.2



