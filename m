Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAEA2E64D2
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390535AbgL1Ngz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:36:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:35674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391243AbgL1NgB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:36:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CC7E208BA;
        Mon, 28 Dec 2020 13:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162546;
        bh=XzsH2Q/ocLHZ+e33xlKac2hhFE/qebg0xmfxEOt6V+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OAQl2bsRFNdc/bIkhGuhpMrkNx9xhOLkcsf4K+GXNkgphvf3doB621iSikTx+qVTQ
         YnQ0NTNz32YHGo14oipl4kWPEmwfQQPVJ6WXYuZS7r7DIyRNsdJ80wYvcUDDYOp+x7
         9xOX2gp6eo9eme+lCx+ZjD8ZTz3dMk+2mqCAN4q0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangtao Li <frank@allwinnertech.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4.19 336/346] pinctrl: sunxi: Always call chained_irq_{enter, exit} in sunxi_pinctrl_irq_handler
Date:   Mon, 28 Dec 2020 13:50:55 +0100
Message-Id: <20201228124936.007795639@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangtao Li <frank@allwinnertech.com>

commit a1158e36f876f6269978a4176e3a1d48d27fe7a1 upstream.

It is found on many allwinner soc that there is a low probability that
the interrupt status cannot be read in sunxi_pinctrl_irq_handler. This
will cause the interrupt status of a gpio bank to always be active on
gic, preventing gic from responding to other spi interrupts correctly.

So we should call the chained_irq_* each time enter sunxi_pinctrl_irq_handler().

Signed-off-by: Yangtao Li <frank@allwinnertech.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/85263ce8b058e80cea25c6ad6383eb256ce96cc8.1604988979.git.frank@allwinnertech.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/sunxi/pinctrl-sunxi.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -1001,20 +1001,22 @@ static void sunxi_pinctrl_irq_handler(st
 	if (bank == pctl->desc->irq_banks)
 		return;
 
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


