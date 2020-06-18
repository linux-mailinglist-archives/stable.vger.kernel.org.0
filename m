Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C341FDAED
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbgFRBJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:09:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728102AbgFRBJR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:09:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADE122193E;
        Thu, 18 Jun 2020 01:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442556;
        bh=6gruKfqidV8dlcCkOj9tUa6RXFVX8x50lVwibQBN1mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ksQ0AyCPqlmHiHObWLQsZZXtpdSuGhFQxYf8f/R0naOk4Mbm4mviGUv4K425KoFYE
         njGtxg8A+bWByqHhU5VlVd76iWpXRBxF2TKABek2wBoVxBF96cwHWdtMymzxsyto9q
         5WY2MsGxqWP0N1X45rrKxxz0H24ZR2XkNL+8tN7U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lars Povlsen <lars.povlsen@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 053/388] pinctrl: ocelot: Fix GPIO interrupt decoding on Jaguar2
Date:   Wed, 17 Jun 2020 21:02:30 -0400
Message-Id: <20200618010805.600873-53-sashal@kernel.org>
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

[ Upstream commit 0b47afc65453a70bc521e251138418056f65793f ]

This fixes a problem with using the GPIO as an interrupt on Jaguar2
(and similar), as the register layout of the platforms with 64 GPIO's
are pairwise, such that the original offset must be multiplied with
the platform stride.

Fixes: da801ab56ad8 pinctrl: ocelot: add MSCC Jaguar2 support.
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
Link: https://lore.kernel.org/r/20200513125532.24585-4-lars.povlsen@microchip.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-ocelot.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index ed8eac6c1494..4b99922d6c7e 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -714,11 +714,12 @@ static void ocelot_irq_handler(struct irq_desc *desc)
 	struct irq_chip *parent_chip = irq_desc_get_chip(desc);
 	struct gpio_chip *chip = irq_desc_get_handler_data(desc);
 	struct ocelot_pinctrl *info = gpiochip_get_data(chip);
+	unsigned int id_reg = OCELOT_GPIO_INTR_IDENT * info->stride;
 	unsigned int reg = 0, irq, i;
 	unsigned long irqs;
 
 	for (i = 0; i < info->stride; i++) {
-		regmap_read(info->map, OCELOT_GPIO_INTR_IDENT + 4 * i, &reg);
+		regmap_read(info->map, id_reg + 4 * i, &reg);
 		if (!reg)
 			continue;
 
-- 
2.25.1

