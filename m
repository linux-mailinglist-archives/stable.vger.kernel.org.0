Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C53812D6053
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 16:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391227AbgLJPrT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 10:47:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:47226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391226AbgLJOji (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:39:38 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Eggers <ceggers@arri.de>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.9 30/75] i2c: imx: Check for I2SR_IAL after every byte
Date:   Thu, 10 Dec 2020 15:26:55 +0100
Message-Id: <20201210142607.540345153@linuxfoundation.org>
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

commit 1de67a3dee7a279ebe4d892b359fe3696938ec15 upstream.

Arbitration Lost (IAL) can happen after every single byte transfer. If
arbitration is lost, the I2C hardware will autonomously switch from
master mode to slave. If a transfer is not aborted in this state,
consecutive transfers will not be executed by the hardware and will
timeout.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Tested (not extensively) on Vybrid VF500 (Toradex VF50):
Tested-by: Krzysztof Kozlowski <krzk@kernel.org>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: stable@vger.kernel.org
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-imx.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -490,6 +490,16 @@ static int i2c_imx_trx_complete(struct i
 		dev_dbg(&i2c_imx->adapter.dev, "<%s> Timeout\n", __func__);
 		return -ETIMEDOUT;
 	}
+
+	/* check for arbitration lost */
+	if (i2c_imx->i2csr & I2SR_IAL) {
+		dev_dbg(&i2c_imx->adapter.dev, "<%s> Arbitration lost\n", __func__);
+		i2c_imx_clear_irq(i2c_imx, I2SR_IAL);
+
+		i2c_imx->i2csr = 0;
+		return -EAGAIN;
+	}
+
 	dev_dbg(&i2c_imx->adapter.dev, "<%s> TRX complete\n", __func__);
 	i2c_imx->i2csr = 0;
 	return 0;


