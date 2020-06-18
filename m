Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF771FE74C
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729776AbgFRCkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:40:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728989AbgFRBMr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:12:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A41320EDD;
        Thu, 18 Jun 2020 01:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442766;
        bh=K9zxSlIgRYqNErbEqIuvrgg8NyT9/rYN3WcDSo2mlqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A5t7+/4GwY7+Dl9Ne5Im7aoHoZO8s75bgQ+ttXnDoZhLDbpbJZzWTpRZOmujIdXAE
         jiMnoBDeI/2LSTxiCjxL3zPGMJnIDO62yy9fasRklN1jisp5PKm+QERYNF2SPSz6Ul
         mC7AniL9wP2WRSPoSMlB8+3IndkkVyTu+LQ9YAlQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lars Povlsen <lars.povlsen@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 215/388] pinctrl: ocelot: Always register GPIO driver
Date:   Wed, 17 Jun 2020 21:05:12 -0400
Message-Id: <20200618010805.600873-215-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lars Povlsen <lars.povlsen@microchip.com>

[ Upstream commit 550713e33f4338c8596776828a936fd1e3bf35de ]

This fixes the situation where the GPIO controller is not
used as an interrupt controller as well.

Previously, the driver would silently fail to register even the
GPIO's. With this change, the driver will only register as an
interrupt controller if a parent interrupt is provided.

Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
Link: https://lore.kernel.org/r/20200513125532.24585-2-lars.povlsen@microchip.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-ocelot.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index 4b99922d6c7e..b1bf46ec207f 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -752,21 +752,21 @@ static int ocelot_gpiochip_register(struct platform_device *pdev,
 	gc->of_node = info->dev->of_node;
 	gc->label = "ocelot-gpio";
 
-	irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
-	if (irq <= 0)
-		return irq;
-
-	girq = &gc->irq;
-	girq->chip = &ocelot_irqchip;
-	girq->parent_handler = ocelot_irq_handler;
-	girq->num_parents = 1;
-	girq->parents = devm_kcalloc(&pdev->dev, 1, sizeof(*girq->parents),
-				     GFP_KERNEL);
-	if (!girq->parents)
-		return -ENOMEM;
-	girq->parents[0] = irq;
-	girq->default_type = IRQ_TYPE_NONE;
-	girq->handler = handle_edge_irq;
+	irq = irq_of_parse_and_map(gc->of_node, 0);
+	if (irq) {
+		girq = &gc->irq;
+		girq->chip = &ocelot_irqchip;
+		girq->parent_handler = ocelot_irq_handler;
+		girq->num_parents = 1;
+		girq->parents = devm_kcalloc(&pdev->dev, 1,
+					     sizeof(*girq->parents),
+					     GFP_KERNEL);
+		if (!girq->parents)
+			return -ENOMEM;
+		girq->parents[0] = irq;
+		girq->default_type = IRQ_TYPE_NONE;
+		girq->handler = handle_edge_irq;
+	}
 
 	ret = devm_gpiochip_add_data(&pdev->dev, gc, info);
 	if (ret)
-- 
2.25.1

