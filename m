Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A72273A6330
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233891AbhFNLLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:11:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232976AbhFNLHV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:07:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF0E661932;
        Mon, 14 Jun 2021 10:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667558;
        bh=++IjVnJrTOloecjWxoyojTYo4/TfK0pcHzYTeoY3xBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s+3TrkjnrdM3tBdWMsx0h+pI8e1sxUlwDqwXbgNNDMOolDGfupbmYannjOwyhqp3k
         F3DY4Ue5m8fZ7bWFkqZt/9YbtL9rWwOf2SRLWEM8bi7FlTBNAo1G7RYY3erY0YhTCj
         NXuuC6QP/QeSS/tiKkQfcT+Nx5MX+6lffj7hqVPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Agner <stefan@agner.ch>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 084/131] USB: serial: cp210x: fix alternate function for CP2102N QFN20
Date:   Mon, 14 Jun 2021 12:27:25 +0200
Message-Id: <20210614102655.864085996@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Agner <stefan@agner.ch>

commit 6f7ec77cc8b64ff5037c1945e4650c65c458037d upstream.

The QFN20 part has a different GPIO/port function assignment. The
configuration struct bit field ordered as TX/RX/RS485/WAKEUP/CLK
which exactly matches GPIO0-3 for QFN24/28. However, QFN20 has a
different GPIO to primary function assignment.

Special case QFN20 to follow to properly detect which GPIOs are
available.

Signed-off-by: Stefan Agner <stefan@agner.ch>
Link: https://lore.kernel.org/r/51830b2b24118eb0f77c5c9ac64ffb2f519dbb1d.1622218300.git.stefan@agner.ch
Fixes: c8acfe0aadbe ("USB: serial: cp210x: implement GPIO support for CP2102N")
Cc: stable@vger.kernel.org	# 4.19
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/cp210x.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -533,6 +533,12 @@ struct cp210x_single_port_config {
 #define CP210X_2NCONFIG_GPIO_RSTLATCH_IDX	587
 #define CP210X_2NCONFIG_GPIO_CONTROL_IDX	600
 
+/* CP2102N QFN20 port configuration values */
+#define CP2102N_QFN20_GPIO2_TXLED_MODE		BIT(2)
+#define CP2102N_QFN20_GPIO3_RXLED_MODE		BIT(3)
+#define CP2102N_QFN20_GPIO1_RS485_MODE		BIT(4)
+#define CP2102N_QFN20_GPIO0_CLK_MODE		BIT(6)
+
 /* CP210X_VENDOR_SPECIFIC, CP210X_WRITE_LATCH call writes these 0x2 bytes. */
 struct cp210x_gpio_write {
 	u8	mask;
@@ -1884,7 +1890,19 @@ static int cp2102n_gpioconf_init(struct
 	priv->gpio_pushpull = (gpio_pushpull >> 3) & 0x0f;
 
 	/* 0 indicates GPIO mode, 1 is alternate function */
-	priv->gpio_altfunc = (gpio_ctrl >> 2) & 0x0f;
+	if (priv->partnum == CP210X_PARTNUM_CP2102N_QFN20) {
+		/* QFN20 is special... */
+		if (gpio_ctrl & CP2102N_QFN20_GPIO0_CLK_MODE)   /* GPIO 0 */
+			priv->gpio_altfunc |= BIT(0);
+		if (gpio_ctrl & CP2102N_QFN20_GPIO1_RS485_MODE) /* GPIO 1 */
+			priv->gpio_altfunc |= BIT(1);
+		if (gpio_ctrl & CP2102N_QFN20_GPIO2_TXLED_MODE) /* GPIO 2 */
+			priv->gpio_altfunc |= BIT(2);
+		if (gpio_ctrl & CP2102N_QFN20_GPIO3_RXLED_MODE) /* GPIO 3 */
+			priv->gpio_altfunc |= BIT(3);
+	} else {
+		priv->gpio_altfunc = (gpio_ctrl >> 2) & 0x0f;
+	}
 
 	if (priv->partnum == CP210X_PARTNUM_CP2102N_QFN28) {
 		/*


