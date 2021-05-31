Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D0F395F6C
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbhEaOL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:11:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233460AbhEaOJY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:09:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C1B061461;
        Mon, 31 May 2021 13:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468410;
        bh=6ZOBp95rw4h/8YnRs5mvXTJ5grO4wqegQKxjVp5celU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j6Z+V7iOgpad40QHAgJ+EXVDkcjbhyEMPO/g8KKXOuQw1Tq+Ue3q9xipxzz/MwPu3
         i2yIKz7I6zbt7PoRgD+XVA+3rkk+bxogCBsRfus3z4XXowk+2xYyU6yi+NQHQ/+h/S
         dc9GQQl8LZxCjLQN/f0WlUfqNlbDrPJaPaA5vu7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Liguang Zhang <zhangliguang@linux.alibaba.com>,
        Jay Fang <f.fangjian@huawei.com>,
        Sven Van Asbroeck <thesven73@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Xin Hao <xhao@linux.alibaba.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 197/252] spi: Assume GPIO CS active high in ACPI case
Date:   Mon, 31 May 2021 15:14:22 +0200
Message-Id: <20210531130704.713282925@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 6b69546912a57ff8c31061f98e56383cc0beffd3 ]

Currently GPIO CS handling, when descriptors are in use, doesn't
take into consideration that in ACPI case the default polarity
is Active High and can't be altered. Instead we have to use the
per-chip definition provided by SPISerialBus() resource.

Fixes: 766c6b63aa04 ("spi: fix client driver breakages when using GPIO descriptors")
Cc: Liguang Zhang <zhangliguang@linux.alibaba.com>
Cc: Jay Fang <f.fangjian@huawei.com>
Cc: Sven Van Asbroeck <thesven73@gmail.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Xin Hao <xhao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20210511140912.30757-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 419de3d40481..a6f1e94af13c 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -814,16 +814,29 @@ static void spi_set_cs(struct spi_device *spi, bool enable, bool force)
 
 	if (spi->cs_gpiod || gpio_is_valid(spi->cs_gpio)) {
 		if (!(spi->mode & SPI_NO_CS)) {
-			if (spi->cs_gpiod)
-				/* polarity handled by gpiolib */
-				gpiod_set_value_cansleep(spi->cs_gpiod,
-							 enable1);
-			else
+			if (spi->cs_gpiod) {
+				/*
+				 * Historically ACPI has no means of the GPIO polarity and
+				 * thus the SPISerialBus() resource defines it on the per-chip
+				 * basis. In order to avoid a chain of negations, the GPIO
+				 * polarity is considered being Active High. Even for the cases
+				 * when _DSD() is involved (in the updated versions of ACPI)
+				 * the GPIO CS polarity must be defined Active High to avoid
+				 * ambiguity. That's why we use enable, that takes SPI_CS_HIGH
+				 * into account.
+				 */
+				if (has_acpi_companion(&spi->dev))
+					gpiod_set_value_cansleep(spi->cs_gpiod, !enable);
+				else
+					/* Polarity handled by GPIO library */
+					gpiod_set_value_cansleep(spi->cs_gpiod, enable1);
+			} else {
 				/*
 				 * invert the enable line, as active low is
 				 * default for SPI.
 				 */
 				gpio_set_value_cansleep(spi->cs_gpio, !enable);
+			}
 		}
 		/* Some SPI masters need both GPIO CS & slave_select */
 		if ((spi->controller->flags & SPI_MASTER_GPIO_SS) &&
-- 
2.30.2



