Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE3412157F
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731909AbfLPSVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:21:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:54410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732206AbfLPSVN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:21:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7947821775;
        Mon, 16 Dec 2019 18:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520472;
        bh=NfLTpMpdY1P59r8KrNeZwv9n+oDLlDos8mnXv/OtaBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C+0GQxioZiWjsMibv/40ge6woAn4tTDnkEUpRfwYYjwb55esdpsdDY8y/jVAWGpYZ
         d+FSilx/WI0wGKlEsuB9dHW5iQIhU9IFLLrI9d01N/Z/g0im8X3yPEebezVWlw8cAf
         5mB+BlHGuyBA/wLhaVl4AT6sq1Yga7x7Hk3OvO6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.4 132/177] pinctrl: armada-37xx: Fix irq mask access in armada_37xx_irq_set_type()
Date:   Mon, 16 Dec 2019 18:49:48 +0100
Message-Id: <20191216174844.642009420@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gregory CLEMENT <gregory.clement@bootlin.com>

commit 04fb02757ae5188031eb71b2f6f189edb1caf5dc upstream.

As explained in the following commit a9a1a4833613 ("pinctrl:
armada-37xx: Fix gpio interrupt setup") the armada_37xx_irq_set_type()
function can be called before the initialization of the mask field.

That means that we can't use this field in this function and need to
workaround it using hwirq.

Fixes: 30ac0d3b0702 ("pinctrl: armada-37xx: Add edge both type gpio irq support")
Cc: stable@vger.kernel.org
Reported-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Link: https://lore.kernel.org/r/20191115155752.2562-1-gregory.clement@bootlin.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -595,10 +595,10 @@ static int armada_37xx_irq_set_type(stru
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


