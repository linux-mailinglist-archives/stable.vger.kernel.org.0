Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE7910BDFA
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbfK0VdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:33:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:40358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730628AbfK0Uwi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:52:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 437FD21847;
        Wed, 27 Nov 2019 20:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887957;
        bh=vBFYOrfj1IE1io4Th6lrRDVblv4ioYm1LhZ/3QjbwXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VlgwWCjp8lma0ax/cS5Ue9Z4/kqdnplZHvYchvlqBy8pQKRubOQJS0uu74wIf9HQK
         MSA/Utyt8/uUjD6LT3z6+uXcptCiGfBNBXZP/y7Nk58DyViOQbiHhzexykRiZDU6PG
         nx19k5BmuHp2DNpPNwxMqkRETRrxKvS0/nMK3uoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 160/211] i2c: uniphier-f: fix timeout error after reading 8 bytes
Date:   Wed, 27 Nov 2019 21:31:33 +0100
Message-Id: <20191127203109.055859220@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

[ Upstream commit c2a653deaa81f5a750c0dfcbaf9f8e5195cbe4a5 ]

I was totally screwed up in commit eaba68785c2d ("i2c: uniphier-f:
fix race condition when IRQ is cleared"). Since that commit, if the
number of read bytes is multiple of the FIFO size (8, 16, 24... bytes),
the STOP condition could be issued twice, depending on the timing.
If this happens, the controller will go wrong, resulting in the timeout
error.

It was more than 3 years ago when I wrote this driver, so my memory
about this hardware was vague. Please let me correct the description
in the commit log of eaba68785c2d.

Clearing the IRQ status on exiting the IRQ handler is absolutely
fine. This controller makes a pause while any IRQ status is asserted.
If the IRQ status is cleared first, the hardware may start the next
transaction before the IRQ handler finishes what it supposed to do.

This partially reverts the bad commit with clear comments so that I
will never repeat this mistake.

I also investigated what is happening at the last moment of the read
mode. The UNIPHIER_FI2C_INT_RF interrupt is asserted a bit earlier
(by half a period of the clock cycle) than UNIPHIER_FI2C_INT_RB.

I consulted a hardware engineer, and I got the following information:

UNIPHIER_FI2C_INT_RF
    asserted at the falling edge of SCL at the 8th bit.

UNIPHIER_FI2C_INT_RB
    asserted at the rising edge of SCL at the 9th (ACK) bit.

In order to avoid calling uniphier_fi2c_stop() twice, check the latter
interrupt. I also commented this because it is obscure hardware internal.

Fixes: eaba68785c2d ("i2c: uniphier-f: fix race condition when IRQ is cleared")
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-uniphier-f.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-uniphier-f.c b/drivers/i2c/busses/i2c-uniphier-f.c
index 928ea9930d17e..dd0687e36a47b 100644
--- a/drivers/i2c/busses/i2c-uniphier-f.c
+++ b/drivers/i2c/busses/i2c-uniphier-f.c
@@ -173,8 +173,6 @@ static irqreturn_t uniphier_fi2c_interrupt(int irq, void *dev_id)
 		"interrupt: enabled_irqs=%04x, irq_status=%04x\n",
 		priv->enabled_irqs, irq_status);
 
-	uniphier_fi2c_clear_irqs(priv, irq_status);
-
 	if (irq_status & UNIPHIER_FI2C_INT_STOP)
 		goto complete;
 
@@ -214,7 +212,13 @@ static irqreturn_t uniphier_fi2c_interrupt(int irq, void *dev_id)
 
 	if (irq_status & (UNIPHIER_FI2C_INT_RF | UNIPHIER_FI2C_INT_RB)) {
 		uniphier_fi2c_drain_rxfifo(priv);
-		if (!priv->len)
+		/*
+		 * If the number of bytes to read is multiple of the FIFO size
+		 * (msg->len == 8, 16, 24, ...), the INT_RF bit is set a little
+		 * earlier than INT_RB. We wait for INT_RB to confirm the
+		 * completion of the current message.
+		 */
+		if (!priv->len && (irq_status & UNIPHIER_FI2C_INT_RB))
 			goto data_done;
 
 		if (unlikely(priv->flags & UNIPHIER_FI2C_MANUAL_NACK)) {
@@ -253,6 +257,13 @@ static irqreturn_t uniphier_fi2c_interrupt(int irq, void *dev_id)
 	}
 
 handled:
+	/*
+	 * This controller makes a pause while any bit of the IRQ status is
+	 * asserted. Clear the asserted bit to kick the controller just before
+	 * exiting the handler.
+	 */
+	uniphier_fi2c_clear_irqs(priv, irq_status);
+
 	spin_unlock(&priv->lock);
 
 	return IRQ_HANDLED;
-- 
2.20.1



