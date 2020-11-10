Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6992ACE0F
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 05:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387490AbgKJEGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 23:06:25 -0500
Received: from smtp2207-205.mail.aliyun.com ([121.197.207.205]:50000 "EHLO
        smtp2207-205.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387433AbgKJEGX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 23:06:23 -0500
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.2995258|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.00377925-0.00159346-0.994627;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047188;MF=frank@allwinnertech.com;NM=1;PH=DS;RN=29;RT=29;SR=0;TI=SMTPD_---.IulFdj5_1604981159;
Received: from allwinnertech.com(mailfrom:frank@allwinnertech.com fp:SMTPD_---.IulFdj5_1604981159)
          by smtp.aliyun-inc.com(10.147.42.135);
          Tue, 10 Nov 2020 12:06:15 +0800
From:   Frank Lee <frank@allwinnertech.com>
To:     vkoul@kernel.org, robh+dt@kernel.org, mripard@kernel.org,
        wens@csie.org, ulf.hansson@linaro.org, kishon@ti.com,
        wim@linux-watchdog.org, linux@roeck-us.net,
        dan.j.williams@intel.com, linus.walleij@linaro.org,
        wsa+renesas@sang-engineering.com, dianders@chromium.org,
        marex@denx.de, colin.king@canonical.com, rdunlap@infradead.org,
        krzk@kernel.org, gregkh@linuxfoundation.org, megous@megous.com,
        rikard.falkeborn@gmail.com, dmaengine@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-gpio@vger.kernel.org,
        tiny.windzz@gmail.com
Cc:     Yangtao Li <frank@allwinnertech.com>, stable@vger.kernel.org
Subject: [PATCH 03/19] pinctrl: sunxi: Always call chained_irq_{enter, exit} in sunxi_pinctrl_irq_handler
Date:   Tue, 10 Nov 2020 12:05:37 +0800
Message-Id: <20201110040553.1381-4-frank@allwinnertech.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201110040553.1381-1-frank@allwinnertech.com>
References: <20201110040553.1381-1-frank@allwinnertech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangtao Li <frank@allwinnertech.com>

It is found on many allwinner soc that there is a low probability that
the interrupt status cannot be read in sunxi_pinctrl_irq_handler. This
will cause the interrupt status of a gpio bank to always be active on
gic, preventing gic from responding to other spi interrupts correctly.

So we should call the chained_irq_* each time enter sunxi_pinctrl_irq_handler().

Cc: stable@vger.kernel.org
Signed-off-by: Yangtao Li <frank@allwinnertech.com>
---
 drivers/pinctrl/sunxi/pinctrl-sunxi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.c b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
index 9d8b59dafa4b..dc8d39ae045b 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -1141,20 +1141,22 @@ static void sunxi_pinctrl_irq_handler(struct irq_desc *desc)
 
 	WARN_ON(bank == pctl->desc->irq_banks);
 
+	chained_irq_enter(chip, desc);
+
 	reg = sunxi_irq_status_reg_from_bank(pctl->desc, bank);
 	val = readl(pctl->membase + reg);
 
 	if (val) {
 		int irqoffset;
 
-		chained_irq_enter(chip, desc);
 		for_each_set_bit(irqoffset, &val, IRQ_PER_BANK) {
 			int pin_irq = irq_find_mapping(pctl->domain,
 						       bank * IRQ_PER_BANK + irqoffset);
 			generic_handle_irq(pin_irq);
 		}
-		chained_irq_exit(chip, desc);
 	}
+
+	chained_irq_exit(chip, desc);
 }
 
 static int sunxi_pinctrl_add_function(struct sunxi_pinctrl *pctl,
-- 
2.28.0

