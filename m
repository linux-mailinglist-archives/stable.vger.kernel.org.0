Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F67205E6F
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390186AbgFWUWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:22:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389009AbgFWUWe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:22:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDC982073E;
        Tue, 23 Jun 2020 20:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943754;
        bh=zHdIzfMLwkkB8F+ORviGrhtu7onRrDFKT25ro4B5dCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kYOkD6CWqhqxb7h+s4+s8PYGaNtXRZqZJimiyR6xjQ7BozKpjjHJav4SnWBjALdUA
         8tNF3XpAin080qa6oQZyr4nP/9XrlQQbVf7jsSDHYzCDeE3ZTsHZe5UK7M2g/4Is9q
         hev36aSU5QJ74W3BC3b5Py9LggoyVw9efspUhOuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 038/314] pinctrl: ocelot: Fix GPIO interrupt decoding on Jaguar2
Date:   Tue, 23 Jun 2020 21:53:53 +0200
Message-Id: <20200623195340.625888089@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index fb76fb2e9ea54..0a951a75c82b3 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -711,11 +711,12 @@ static void ocelot_irq_handler(struct irq_desc *desc)
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



