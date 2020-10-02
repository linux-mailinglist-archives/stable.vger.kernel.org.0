Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA13281683
	for <lists+stable@lfdr.de>; Fri,  2 Oct 2020 17:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388226AbgJBPZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Oct 2020 11:25:34 -0400
Received: from mailout08.rmx.de ([94.199.90.85]:55090 "EHLO mailout08.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgJBPZe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Oct 2020 11:25:34 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout08.rmx.de (Postfix) with ESMTPS id 4C2v2K2YhpzMsBB;
        Fri,  2 Oct 2020 17:25:29 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4C2v1N4P7Vz2TSBr;
        Fri,  2 Oct 2020 17:24:40 +0200 (CEST)
Received: from N95HX1G2.wgnetz.xx (192.168.54.33) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Fri, 2 Oct
 2020 17:24:31 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Oleksij Rempel <linux@rempel-privat.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
CC:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        <linux-i2c@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Christian Eggers <ceggers@arri.de>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 1/3] i2c: imx: Fix reset of I2SR_IAL flag
Date:   Fri, 2 Oct 2020 17:23:03 +0200
Message-ID: <20201002152305.4963-2-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201002152305.4963-1-ceggers@arri.de>
References: <20201002152305.4963-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.33]
X-RMX-ID: 20201002-172448-4C2v1N4P7Vz2TSBr-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

According to the "VFxxx Controller Reference Manual" (and the comment
block starting at line 97), Vybrid requires writing a one for clearing
an interrupt flag. Syncing the method for clearing I2SR_IIF in
i2c_imx_isr().

Signed-off-by: Christian Eggers <ceggers@arri.de>
Cc: stable@vger.kernel.org
---
 drivers/i2c/busses/i2c-imx.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index 0ab5381aa012..34648df7f1a6 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -424,7 +424,12 @@ static int i2c_imx_bus_busy(struct imx_i2c_struct *i2c_imx, int for_busy, bool a
 
 		/* check for arbitration lost */
 		if (temp & I2SR_IAL) {
-			temp &= ~I2SR_IAL;
+			/*
+			 * i2sr_clr_opcode is the value to clear all interrupts.
+			 * Here we want to clear only I2SR_IAL, so we write
+			 * ~i2sr_clr_opcode with just the I2SR_IAL bit toggled.
+			 */
+			temp = ~i2c_imx->hwdata->i2sr_clr_opcode ^ I2SR_IAL;
 			imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2SR);
 			return -EAGAIN;
 		}
@@ -623,8 +628,12 @@ static irqreturn_t i2c_imx_isr(int irq, void *dev_id)
 	if (temp & I2SR_IIF) {
 		/* save status register */
 		i2c_imx->i2csr = temp;
-		temp &= ~I2SR_IIF;
-		temp |= (i2c_imx->hwdata->i2sr_clr_opcode & I2SR_IIF);
+		/*
+		 * i2sr_clr_opcode is the value to clear all interrupts.
+		 * Here we want to clear only I2SR_IIF, so we write
+		 * ~i2sr_clr_opcode with just the I2SR_IIF bit toggled.
+		 */
+		temp = ~i2c_imx->hwdata->i2sr_clr_opcode ^ I2SR_IIF;
 		imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2SR);
 		wake_up(&i2c_imx->queue);
 		return IRQ_HANDLED;
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

