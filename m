Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 198EE2D605C
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 16:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391999AbgLJPsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 10:48:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:46710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391210AbgLJOjJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:39:09 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Eggers <ceggers@arri.de>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.9 29/75] i2c: imx: Fix reset of I2SR_IAL flag
Date:   Thu, 10 Dec 2020 15:26:54 +0100
Message-Id: <20201210142607.490267087@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Eggers <ceggers@arri.de>

commit 384a9565f70a876c2e78e58c5ca0bbf0547e4f6d upstream.

According to the "VFxxx Controller Reference Manual" (and the comment
block starting at line 97), Vybrid requires writing a one for clearing
an interrupt flag. Syncing the method for clearing I2SR_IIF in
i2c_imx_isr().

Signed-off-by: Christian Eggers <ceggers@arri.de>
Fixes: 4b775022f6fd ("i2c: imx: add struct to hold more configurable quirks")
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: stable@vger.kernel.org
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-imx.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -412,6 +412,19 @@ static void i2c_imx_dma_free(struct imx_
 	dma->chan_using = NULL;
 }
 
+static void i2c_imx_clear_irq(struct imx_i2c_struct *i2c_imx, unsigned int bits)
+{
+	unsigned int temp;
+
+	/*
+	 * i2sr_clr_opcode is the value to clear all interrupts. Here we want to
+	 * clear only <bits>, so we write ~i2sr_clr_opcode with just <bits>
+	 * toggled. This is required because i.MX needs W0C and Vybrid uses W1C.
+	 */
+	temp = ~i2c_imx->hwdata->i2sr_clr_opcode ^ bits;
+	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2SR);
+}
+
 static int i2c_imx_bus_busy(struct imx_i2c_struct *i2c_imx, int for_busy, bool atomic)
 {
 	unsigned long orig_jiffies = jiffies;
@@ -424,8 +437,7 @@ static int i2c_imx_bus_busy(struct imx_i
 
 		/* check for arbitration lost */
 		if (temp & I2SR_IAL) {
-			temp &= ~I2SR_IAL;
-			imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2SR);
+			i2c_imx_clear_irq(i2c_imx, I2SR_IAL);
 			return -EAGAIN;
 		}
 
@@ -469,7 +481,7 @@ static int i2c_imx_trx_complete(struct i
 		 */
 		readb_poll_timeout_atomic(addr, regval, regval & I2SR_IIF, 5, 1000 + 100);
 		i2c_imx->i2csr = regval;
-		imx_i2c_write_reg(0, i2c_imx, IMX_I2C_I2SR);
+		i2c_imx_clear_irq(i2c_imx, I2SR_IIF | I2SR_IAL);
 	} else {
 		wait_event_timeout(i2c_imx->queue, i2c_imx->i2csr & I2SR_IIF, HZ / 10);
 	}
@@ -623,9 +635,7 @@ static irqreturn_t i2c_imx_isr(int irq,
 	if (temp & I2SR_IIF) {
 		/* save status register */
 		i2c_imx->i2csr = temp;
-		temp &= ~I2SR_IIF;
-		temp |= (i2c_imx->hwdata->i2sr_clr_opcode & I2SR_IIF);
-		imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2SR);
+		i2c_imx_clear_irq(i2c_imx, I2SR_IIF);
 		wake_up(&i2c_imx->queue);
 		return IRQ_HANDLED;
 	}


