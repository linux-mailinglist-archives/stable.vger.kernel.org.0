Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 164CBE66FC
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730947AbfJ0VRD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:17:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:36790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730960AbfJ0VRC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:17:02 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FFA6205C9;
        Sun, 27 Oct 2019 21:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211021;
        bh=RN3J+c2aI3xGWtqzibHTF3WvE8CWzIM6XRDq3Jdbv4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SEDj/AJvAOhNBwdoIswkXEVFDW3DgZ57LFioimSuD1Dpxo/eT8kKOGwVJLHf6YcYS
         CXsMRtONG8B5GxFFAWKOFM6Pf1SoMwCXMX2FmlmdsamcQrSJ8pCvXW+P7YCiEeyILQ
         FTr3lktWDhZ5XrNwxYmM/eQDAQuJoQHfWWF63l2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Patrick Williams <alpawi@amazon.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4.19 82/93] pinctrl: armada-37xx: fix control of pins 32 and up
Date:   Sun, 27 Oct 2019 22:01:34 +0100
Message-Id: <20191027203313.485974413@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203251.029297948@linuxfoundation.org>
References: <20191027203251.029297948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrick Williams <alpawi@amazon.com>

commit 20504fa1d2ffd5d03cdd9dc9c9dd4ed4579b97ef upstream.

The 37xx configuration registers are only 32 bits long, so
pins 32-35 spill over into the next register.  The calculation
for the register address was done, but the bitmask was not, so
any configuration to pin 32 or above resulted in a bitmask that
overflowed and performed no action.

Fix the register / offset calculation to also adjust the offset.

Fixes: 5715092a458c ("pinctrl: armada-37xx: Add gpio support")
Signed-off-by: Patrick Williams <alpawi@amazon.com>
Acked-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191001154634.96165-1-alpawi@amazon.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -218,11 +218,11 @@ static const struct armada_37xx_pin_data
 };
 
 static inline void armada_37xx_update_reg(unsigned int *reg,
-					  unsigned int offset)
+					  unsigned int *offset)
 {
 	/* We never have more than 2 registers */
-	if (offset >= GPIO_PER_REG) {
-		offset -= GPIO_PER_REG;
+	if (*offset >= GPIO_PER_REG) {
+		*offset -= GPIO_PER_REG;
 		*reg += sizeof(u32);
 	}
 }
@@ -373,7 +373,7 @@ static inline void armada_37xx_irq_updat
 {
 	int offset = irqd_to_hwirq(d);
 
-	armada_37xx_update_reg(reg, offset);
+	armada_37xx_update_reg(reg, &offset);
 }
 
 static int armada_37xx_gpio_direction_input(struct gpio_chip *chip,
@@ -383,7 +383,7 @@ static int armada_37xx_gpio_direction_in
 	unsigned int reg = OUTPUT_EN;
 	unsigned int mask;
 
-	armada_37xx_update_reg(&reg, offset);
+	armada_37xx_update_reg(&reg, &offset);
 	mask = BIT(offset);
 
 	return regmap_update_bits(info->regmap, reg, mask, 0);
@@ -396,7 +396,7 @@ static int armada_37xx_gpio_get_directio
 	unsigned int reg = OUTPUT_EN;
 	unsigned int val, mask;
 
-	armada_37xx_update_reg(&reg, offset);
+	armada_37xx_update_reg(&reg, &offset);
 	mask = BIT(offset);
 	regmap_read(info->regmap, reg, &val);
 
@@ -410,7 +410,7 @@ static int armada_37xx_gpio_direction_ou
 	unsigned int reg = OUTPUT_EN;
 	unsigned int mask, val, ret;
 
-	armada_37xx_update_reg(&reg, offset);
+	armada_37xx_update_reg(&reg, &offset);
 	mask = BIT(offset);
 
 	ret = regmap_update_bits(info->regmap, reg, mask, mask);
@@ -431,7 +431,7 @@ static int armada_37xx_gpio_get(struct g
 	unsigned int reg = INPUT_VAL;
 	unsigned int val, mask;
 
-	armada_37xx_update_reg(&reg, offset);
+	armada_37xx_update_reg(&reg, &offset);
 	mask = BIT(offset);
 
 	regmap_read(info->regmap, reg, &val);
@@ -446,7 +446,7 @@ static void armada_37xx_gpio_set(struct
 	unsigned int reg = OUTPUT_VAL;
 	unsigned int mask, val;
 
-	armada_37xx_update_reg(&reg, offset);
+	armada_37xx_update_reg(&reg, &offset);
 	mask = BIT(offset);
 	val = value ? mask : 0;
 


