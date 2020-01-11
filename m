Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19593137F8E
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729289AbgAKKU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:20:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:43308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730577AbgAKKU4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:20:56 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC8C420848;
        Sat, 11 Jan 2020 10:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738055;
        bh=Ls5eP08dXgIKhQU5IUZfcznzPTY9R0mvtRrX9FJWQTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tAEW9qTJRfWMhZo40h6uKHuGQCWTErlgIJz2HS8S8kOk32wc8qfEQoGdU7OHKoiDg
         qLS20meJ2FhdaNncNgCzV8NwohYpkDijsTbdeRBop8lWZ1pHkQFMNxxLv72bxowG8s
         U40qIXyaH93K7VxVDOR1FEcOF8l9iZL/Ror8YmmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 008/165] gpio: Handle counting of Freescale chipselects
Date:   Sat, 11 Jan 2020 10:48:47 +0100
Message-Id: <20200111094921.938767017@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 71b8f600b034c7f5780f6fb311dabfe331c64feb ]

We have a special quirk to handle the Freescale
nonstandard SPI chipselect GPIOs in the gpiolib-of.c
file, but it currently only handles the case where
the GPIOs are actually requested (gpiod_*get()).

We also need to handle that the SPI core attempts
to count the GPIOs before use, and that needs a
similar quirk in the OF part of the library.

Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Reported-by: Christophe Leroy <christophe.leroy@c-s.fr>
Fixes: 0f0581b24bd0 ("spi: fsl: Convert to use CS GPIO descriptors")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: Christophe Leroy <christophe.leroy@c-s.fr>
Link: https://lore.kernel.org/r/20191128083718.39177-2-linus.walleij@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-of.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 80ea49f570f4..43ffec3a6fbb 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -23,6 +23,29 @@
 #include "gpiolib.h"
 #include "gpiolib-of.h"
 
+/**
+ * of_gpio_spi_cs_get_count() - special GPIO counting for SPI
+ * Some elder GPIO controllers need special quirks. Currently we handle
+ * the Freescale GPIO controller with bindings that doesn't use the
+ * established "cs-gpios" for chip selects but instead rely on
+ * "gpios" for the chip select lines. If we detect this, we redirect
+ * the counting of "cs-gpios" to count "gpios" transparent to the
+ * driver.
+ */
+int of_gpio_spi_cs_get_count(struct device *dev, const char *con_id)
+{
+	struct device_node *np = dev->of_node;
+
+	if (!IS_ENABLED(CONFIG_SPI_MASTER))
+		return 0;
+	if (!con_id || strcmp(con_id, "cs"))
+		return 0;
+	if (!of_device_is_compatible(np, "fsl,spi") &&
+	    !of_device_is_compatible(np, "aeroflexgaisler,spictrl"))
+		return 0;
+	return of_gpio_named_count(np, "gpios");
+}
+
 /*
  * This is used by external users of of_gpio_count() from <linux/of_gpio.h>
  *
@@ -35,6 +58,10 @@ int of_gpio_get_count(struct device *dev, const char *con_id)
 	char propname[32];
 	unsigned int i;
 
+	ret = of_gpio_spi_cs_get_count(dev, con_id);
+	if (ret > 0)
+		return ret;
+
 	for (i = 0; i < ARRAY_SIZE(gpio_suffixes); i++) {
 		if (con_id)
 			snprintf(propname, sizeof(propname), "%s-%s",
-- 
2.20.1



