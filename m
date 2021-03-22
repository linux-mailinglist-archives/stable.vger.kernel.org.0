Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9231F3442BA
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbhCVMoi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:44:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:33602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232623AbhCVMmy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:42:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99784619C4;
        Mon, 22 Mar 2021 12:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416845;
        bh=HPxwojPgdvYx/mN7Pbjc6NF13FRwu/s4xKS4rA8gDj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YCP2Jz9IZb3U7PYWrqvDFouLWxTQhFm4VTueEEqo98ajEhKk4dMLQbOJkivZmIMFe
         LPDyybAhAvUDBIkyn3PH5AYnS4h+prsW2tygBEUiKQHAlJpFicfbTV1T+S3K+99+4B
         JUiAXmTiPXXuvUFlAJnTtEJ4GUFqllghIb84mDp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/157] regulator: pca9450: Add SD_VSEL GPIO for LDO5
Date:   Mon, 22 Mar 2021 13:27:46 +0100
Message-Id: <20210322121937.225489958@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

[ Upstream commit 8c67a11bae889f51fe5054364c3c789dfae3ad73 ]

LDO5 has two separate control registers. LDO5CTRL_L is used if the
input signal SD_VSEL is low and LDO5CTRL_H if it is high.
The current driver implementation only uses LDO5CTRL_H. To make this
work on boards that have SD_VSEL connected to a GPIO, we add support
for specifying an optional GPIO and setting it to high at probe time.

In the future we might also want to add support for boards that have
SD_VSEL set to a fixed low level. In this case we need to change the
driver to be able to use the LDO5CTRL_L register.

Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Link: https://lore.kernel.org/r/20210211105534.38972-1-frieder.schrempf@kontron.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/pca9450-regulator.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/regulator/pca9450-regulator.c b/drivers/regulator/pca9450-regulator.c
index cb29421d745a..1bba8fdcb7b7 100644
--- a/drivers/regulator/pca9450-regulator.c
+++ b/drivers/regulator/pca9450-regulator.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/err.h>
+#include <linux/gpio/consumer.h>
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
@@ -32,6 +33,7 @@ struct pca9450_regulator_desc {
 struct pca9450 {
 	struct device *dev;
 	struct regmap *regmap;
+	struct gpio_desc *sd_vsel_gpio;
 	enum pca9450_chip_type type;
 	unsigned int rcnt;
 	int irq;
@@ -795,6 +797,18 @@ static int pca9450_i2c_probe(struct i2c_client *i2c,
 		return ret;
 	}
 
+	/*
+	 * The driver uses the LDO5CTRL_H register to control the LDO5 regulator.
+	 * This is only valid if the SD_VSEL input of the PMIC is high. Let's
+	 * check if the pin is available as GPIO and set it to high.
+	 */
+	pca9450->sd_vsel_gpio = gpiod_get_optional(pca9450->dev, "sd-vsel", GPIOD_OUT_HIGH);
+
+	if (IS_ERR(pca9450->sd_vsel_gpio)) {
+		dev_err(&i2c->dev, "Failed to get SD_VSEL GPIO\n");
+		return ret;
+	}
+
 	dev_info(&i2c->dev, "%s probed.\n",
 		type == PCA9450_TYPE_PCA9450A ? "pca9450a" : "pca9450bc");
 
-- 
2.30.1



