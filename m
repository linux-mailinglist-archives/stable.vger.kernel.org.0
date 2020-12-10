Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 149E52D62A2
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 17:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391053AbgLJQyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 11:54:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:44076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391051AbgLJOgw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:36:52 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Eggers <ceggers@arri.de>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.4 22/54] i2c: imx: Dont generate STOP condition if arbitration has been lost
Date:   Thu, 10 Dec 2020 15:26:59 +0100
Message-Id: <20201210142603.130425280@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142602.037095225@linuxfoundation.org>
References: <20201210142602.037095225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Eggers <ceggers@arri.de>

commit 61e6fe59ede155881a622f5901551b1cc8748f6a upstream.

If arbitration is lost, the master automatically changes to slave mode.
I2SR_IBB may or may not be reset by hardware. Raising a STOP condition
by resetting I2CR_MSTA has no effect and will not clear I2SR_IBB.

So calling i2c_imx_bus_busy() is not required and would busy-wait until
timeout.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Tested (not extensively) on Vybrid VF500 (Toradex VF50):
Tested-by: Krzysztof Kozlowski <krzk@kernel.org>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: stable@vger.kernel.org # Requires trivial backporting, simple remove
                           # the 3rd argument from the calls to
                           # i2c_imx_bus_busy().
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-imx.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -567,6 +567,8 @@ static void i2c_imx_stop(struct imx_i2c_
 		/* Stop I2C transaction */
 		dev_dbg(&i2c_imx->adapter.dev, "<%s>\n", __func__);
 		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
+		if (!(temp & I2CR_MSTA))
+			i2c_imx->stopped = 1;
 		temp &= ~(I2CR_MSTA | I2CR_MTX);
 		if (i2c_imx->dma)
 			temp &= ~I2CR_DMAEN;
@@ -732,9 +734,12 @@ static int i2c_imx_dma_read(struct imx_i
 		 */
 		dev_dbg(dev, "<%s> clear MSTA\n", __func__);
 		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
+		if (!(temp & I2CR_MSTA))
+			i2c_imx->stopped = 1;
 		temp &= ~(I2CR_MSTA | I2CR_MTX);
 		imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
-		i2c_imx_bus_busy(i2c_imx, 0);
+		if (!i2c_imx->stopped)
+			i2c_imx_bus_busy(i2c_imx, 0);
 	} else {
 		/*
 		 * For i2c master receiver repeat restart operation like:
@@ -857,9 +862,12 @@ static int i2c_imx_read(struct imx_i2c_s
 				dev_dbg(&i2c_imx->adapter.dev,
 					"<%s> clear MSTA\n", __func__);
 				temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
+				if (!(temp & I2CR_MSTA))
+					i2c_imx->stopped =  1;
 				temp &= ~(I2CR_MSTA | I2CR_MTX);
 				imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
-				i2c_imx_bus_busy(i2c_imx, 0);
+				if (!i2c_imx->stopped)
+					i2c_imx_bus_busy(i2c_imx, 0);
 			} else {
 				/*
 				 * For i2c master receiver repeat restart operation like:


