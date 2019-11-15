Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC3B8FE21C
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 16:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbfKOP6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 10:58:16 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:39511 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727505AbfKOP6Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 10:58:16 -0500
X-Originating-IP: 90.66.177.178
Received: from localhost (lfbn-1-2888-178.w90-66.abo.wanadoo.fr [90.66.177.178])
        (Authenticated sender: gregory.clement@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 515674000B;
        Fri, 15 Nov 2019 15:58:13 +0000 (UTC)
From:   Gregory CLEMENT <gregory.clement@bootlin.com>
To:     Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH] pinctrl: armada-37xx: Fix irq mask access in armada_37xx_irq_set_type()
Date:   Fri, 15 Nov 2019 16:57:52 +0100
Message-Id: <20191115155752.2562-1-gregory.clement@bootlin.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As explained in the following commit a9a1a4833613 ("pinctrl:
armada-37xx: Fix gpio interrupt setup") the armada_37xx_irq_set_type()
function can be called before the initialization of the mask field.

That means that we can't use this field in this function and need to
workaround it using hwirq.

Fixes: 30ac0d3b0702 ("pinctrl: armada-37xx: Add edge both type gpio irq support")
Cc: stable@vger.kernel.org
Reported-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
---
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
index 9df4277a16be..aa9dcde0f069 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -595,10 +595,10 @@ static int armada_37xx_irq_set_type(struct irq_data *d, unsigned int type)
 		regmap_read(info->regmap, in_reg, &in_val);
 
 		/* Set initial polarity based on current input level. */
-		if (in_val & d->mask)
-			val |= d->mask;		/* falling */
+		if (in_val & BIT(d->hwirq % GPIO_PER_REG))
+			val |= BIT(d->hwirq % GPIO_PER_REG);	/* falling */
 		else
-			val &= ~d->mask;	/* rising */
+			val &= ~(BIT(d->hwirq % GPIO_PER_REG));	/* rising */
 		break;
 	}
 	default:
-- 
2.24.0

