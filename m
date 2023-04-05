Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A09C6D8AAE
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 00:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbjDEWeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 18:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232512AbjDEWd6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 18:33:58 -0400
X-Greylist: delayed 899 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 05 Apr 2023 15:33:42 PDT
Received: from office2.cesnet.cz (office2.cesnet.cz [IPv6:2001:718:1:101::144:244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 759BA10CA;
        Wed,  5 Apr 2023 15:33:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2a07:b241:1002:700:4e4e:6933:e4c7:c369])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by office2.cesnet.cz (Postfix) with ESMTPSA id 8949440006E;
        Thu,  6 Apr 2023 00:08:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cesnet.cz;
        s=office2-2020; t=1680732520;
        bh=7uoEWwtS5aJ2FrMUmr00QijBbcq8rkXN+j+WBOIPi1I=;
        h=Resent-Date:Resent-From:Resent-To:Resent-Cc:From:Date:Subject:To:
         Cc;
        b=lId1yiwyie/IA9AUQqZtXkz+5EdsylFbItckRK5vzpwUPL8a1zaWdbGZvUQUKC/0Z
         cA36rcXiMpzBaezgE+FVC45qnQl4zMb+EXbyTRo8ditkKEzmarX8V+Ca5lJ2MNwSo+
         8HtBvk9ZUPVEquI6ibBV98v07vAeKjJyVolz2E7W9BudD9Y6K9Dx0fjiQwZpNrq+bH
         rydHxzrofuc4RFFn0mRfP6xRSPGeRLNAWAIcgLA4fuBcgWtpWmrnb9s9mbEkg9c03l
         5TYzoBleOaDfZ/Wevy7i3MqmJQvAaAQWH1OxOyP/qGIllk7ShzMJiAYCWlRKFUhQWH
         lRynuEHP0jr/w==
Message-Id: <79db8e82aadb0e174bc82b9996423c3503c8fb37.1680732084.git.jan.kundrat@cesnet.cz>
From:   =?UTF-8?q?Jan=20Kundr=C3=A1t?= <jan.kundrat@cesnet.cz>
Date:   Wed, 5 Apr 2023 22:14:23 +0200
Subject: [PATCH] serial: max310x: fix IO data corruption in batched operations
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To:     linux-serial@vger.kernel.org
Cc:     Cosmin Tanislav <cosmin.tanislav@analog.com>,
        Cosmin Tanislav <demonsingur@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jirislaby@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After upgrading from 5.16 to 6.1, our board with a MAX14830 started
producing lots of garbage data over UART. Bisection pointed out commit
285e76fc049c as the culprit. That patch tried to replace hand-written
code which I added in 2b4bac48c1084 ("serial: max310x: Use batched reads
when reasonably safe") with the generic regmap infrastructure for
batched operations.

Unfortunately, the `regmap_raw_read` and `regmap_raw_write` which were
used are actually functions which perform IO over *multiple* registers.
That's not what is needed for accessing these Tx/Rx FIFOs; the
appropriate functions are the `_noinc_` versions, not the `_raw_` ones.

Fix this regression by using `regmap_noinc_read()` and
`regmap_noinc_write()` along with the necessary `regmap_config` setup;
with this patch in place, our board communicates happily again. Since
our board uses SPI for talking to this chip, the I2C part is completely
untested.

Fixes: 285e76fc049c serial: max310x: use regmap methods for SPI batch operations
Signed-off-by: Jan Kundrát <jan.kundrat@cesnet.cz>
Cc: stable@vger.kernel.org
---
 drivers/tty/serial/max310x.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index c82391c928cb..47520d4a381f 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -529,6 +529,11 @@ static bool max310x_reg_precious(struct device *dev, unsigned int reg)
 	return false;
 }
 
+static bool max310x_reg_noinc(struct device *dev, unsigned int reg)
+{
+	return reg == MAX310X_RHR_REG;
+}
+
 static int max310x_set_baud(struct uart_port *port, int baud)
 {
 	unsigned int mode = 0, div = 0, frac = 0, c = 0, F = 0;
@@ -658,14 +663,14 @@ static void max310x_batch_write(struct uart_port *port, u8 *txbuf, unsigned int
 {
 	struct max310x_one *one = to_max310x_port(port);
 
-	regmap_raw_write(one->regmap, MAX310X_THR_REG, txbuf, len);
+	regmap_noinc_write(one->regmap, MAX310X_THR_REG, txbuf, len);
 }
 
 static void max310x_batch_read(struct uart_port *port, u8 *rxbuf, unsigned int len)
 {
 	struct max310x_one *one = to_max310x_port(port);
 
-	regmap_raw_read(one->regmap, MAX310X_RHR_REG, rxbuf, len);
+	regmap_noinc_read(one->regmap, MAX310X_RHR_REG, rxbuf, len);
 }
 
 static void max310x_handle_rx(struct uart_port *port, unsigned int rxlen)
@@ -1480,6 +1485,10 @@ static struct regmap_config regcfg = {
 	.writeable_reg = max310x_reg_writeable,
 	.volatile_reg = max310x_reg_volatile,
 	.precious_reg = max310x_reg_precious,
+	.writeable_noinc_reg = max310x_reg_noinc,
+	.readable_noinc_reg = max310x_reg_noinc,
+	.max_raw_read = MAX310X_FIFO_SIZE,
+	.max_raw_write = MAX310X_FIFO_SIZE,
 };
 
 #ifdef CONFIG_SPI_MASTER
@@ -1565,6 +1574,10 @@ static struct regmap_config regcfg_i2c = {
 	.volatile_reg = max310x_reg_volatile,
 	.precious_reg = max310x_reg_precious,
 	.max_register = MAX310X_I2C_REVID_EXTREG,
+	.writeable_noinc_reg = max310x_reg_noinc,
+	.readable_noinc_reg = max310x_reg_noinc,
+	.max_raw_read = MAX310X_FIFO_SIZE,
+	.max_raw_write = MAX310X_FIFO_SIZE,
 };
 
 static const struct max310x_if_cfg max310x_i2c_if_cfg = {
-- 
2.39.2


