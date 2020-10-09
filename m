Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3526728878A
	for <lists+stable@lfdr.de>; Fri,  9 Oct 2020 13:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732761AbgJILFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 07:05:30 -0400
Received: from mailout07.rmx.de ([94.199.90.95]:60653 "EHLO mailout07.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731963AbgJILFa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Oct 2020 07:05:30 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout07.rmx.de (Postfix) with ESMTPS id 4C74x03Nb3zBvPR;
        Fri,  9 Oct 2020 13:05:24 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4C74vq4nwXz2TRt0;
        Fri,  9 Oct 2020 13:04:23 +0200 (CEST)
Received: from N95HX1G2.wgnetz.xx (192.168.54.145) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Fri, 9 Oct
 2020 13:04:00 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Oleksij Rempel <linux@rempel-privat.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        "David Laight" <David.Laight@ACULAB.COM>
CC:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        <linux-i2c@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Christian Eggers <ceggers@arri.de>,
        Krzysztof Kozlowski <krzk@kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v6 1/3] i2c: imx: Fix reset of I2SR_IAL flag
Date:   Fri, 9 Oct 2020 13:03:18 +0200
Message-ID: <20201009110320.20832-2-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201009110320.20832-1-ceggers@arri.de>
References: <20201009110320.20832-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.54.145]
X-RMX-ID: 20201009-130425-4C74vq4nwXz2TRt0-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

According to the "VFxxx Controller Reference Manual" (and the comment
block starting at line 97), Vybrid requires writing a one for clearing
an interrupt flag. Syncing the method for clearing I2SR_IIF in
i2c_imx_isr().

Signed-off-by: Christian Eggers <ceggers@arri.de>
Fixes: 4b775022f6fd ("i2c: imx: add struct to hold more configurable quirks")
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: stable@vger.kernel.org
---
 drivers/i2c/busses/i2c-imx.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index 0ab5381aa012..028f8a626410 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -412,6 +412,19 @@ static void i2c_imx_dma_free(struct imx_i2c_struct *i2c_imx)
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
@@ -424,8 +437,7 @@ static int i2c_imx_bus_busy(struct imx_i2c_struct *i2c_imx, int for_busy, bool a
 
 		/* check for arbitration lost */
 		if (temp & I2SR_IAL) {
-			temp &= ~I2SR_IAL;
-			imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2SR);
+			i2c_imx_clear_irq(i2c_imx, I2SR_IAL);
 			return -EAGAIN;
 		}
 
@@ -469,7 +481,7 @@ static int i2c_imx_trx_complete(struct imx_i2c_struct *i2c_imx, bool atomic)
 		 */
 		readb_poll_timeout_atomic(addr, regval, regval & I2SR_IIF, 5, 1000 + 100);
 		i2c_imx->i2csr = regval;
-		imx_i2c_write_reg(0, i2c_imx, IMX_I2C_I2SR);
+		i2c_imx_clear_irq(i2c_imx, I2SR_IIF | I2SR_IAL);
 	} else {
 		wait_event_timeout(i2c_imx->queue, i2c_imx->i2csr & I2SR_IIF, HZ / 10);
 	}
@@ -623,9 +635,7 @@ static irqreturn_t i2c_imx_isr(int irq, void *dev_id)
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
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

