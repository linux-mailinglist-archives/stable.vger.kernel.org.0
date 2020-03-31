Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84486199040
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731590AbgCaJK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:10:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731449AbgCaJKZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:10:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A989520772;
        Tue, 31 Mar 2020 09:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645824;
        bh=wB267HqQ56hcOlLCkrIh1/TIwyS/tpTCEVPWzIHX01I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sdXQsaNajXmXW0ybAfvvGmSC9gM4g0x/SP/XNyam1PB7gT2whlpo6YY6onBZuOzJ6
         Y84NcIa7pfInkbNNUU1qgaH6o2ApaS7yVARJgD5WoMpJtlX0wzMisuQ319iHsNRrnO
         8h3r1kJJXL6yyIjlrK2Yw72gS4bfFOkDrK4D558o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH 5.5 161/170] staging: wfx: add proper "compatible" string
Date:   Tue, 31 Mar 2020 10:59:35 +0200
Message-Id: <20200331085439.925354461@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

commit eec6e3ee636ec3adaa85ebe4b4acaacfcf06277e upstream.

Add "compatible" string matching "vendor,chip" template and proper
GPIO flags handling. Keep support for old name and reset polarity
for older devicetrees.

Cc: stable@vger.kernel.org   # d3a5bcb4a17f ("gpio: add gpiod_toggle_active_low()")
Cc: stable@vger.kernel.org
Fixes: 0096214a59a7 ("staging: wfx: add support for I/O access")
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Link: https://lore.kernel.org/r/0e6dda06f145676861860f073a53dc95987c7ab5.1581416843.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/wfx/Documentation/devicetree/bindings/net/wireless/siliabs,wfx.txt |    7 ++---
 drivers/staging/wfx/bus_spi.c                                                      |   14 +++++++---
 2 files changed, 14 insertions(+), 7 deletions(-)

--- a/drivers/staging/wfx/Documentation/devicetree/bindings/net/wireless/siliabs,wfx.txt
+++ b/drivers/staging/wfx/Documentation/devicetree/bindings/net/wireless/siliabs,wfx.txt
@@ -6,7 +6,7 @@ SPI
 You have to declare the WFxxx chip in your device tree.
 
 Required properties:
- - compatible: Should be "silabs,wfx-spi"
+ - compatible: Should be "silabs,wf200"
  - reg: Chip select address of device
  - spi-max-frequency: Maximum SPI clocking speed of device in Hz
  - interrupts-extended: Should contain interrupt line (interrupt-parent +
@@ -15,6 +15,7 @@ Required properties:
 Optional properties:
  - reset-gpios: phandle of gpio that will be used to reset chip during probe.
    Without this property, you may encounter issues with warm boot.
+   (Legacy: when compatible == "silabs,wfx-spi", the gpio is inverted.)
 
 Please consult Documentation/devicetree/bindings/spi/spi-bus.txt for optional
 SPI connection related properties,
@@ -23,12 +24,12 @@ Example:
 
 &spi1 {
 	wfx {
-		compatible = "silabs,wfx-spi";
+		compatible = "silabs,wf200";
 		pinctrl-names = "default";
 		pinctrl-0 = <&wfx_irq &wfx_gpios>;
 		interrupts-extended = <&gpio 16 IRQ_TYPE_EDGE_RISING>;
 		wakeup-gpios = <&gpio 12 GPIO_ACTIVE_HIGH>;
-		reset-gpios = <&gpio 13 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&gpio 13 GPIO_ACTIVE_LOW>;
 		reg = <0>;
 		spi-max-frequency = <42000000>;
 	};
--- a/drivers/staging/wfx/bus_spi.c
+++ b/drivers/staging/wfx/bus_spi.c
@@ -27,6 +27,8 @@ MODULE_PARM_DESC(gpio_reset, "gpio numbe
 #define SET_WRITE 0x7FFF        /* usage: and operation */
 #define SET_READ 0x8000         /* usage: or operation */
 
+#define WFX_RESET_INVERTED 1
+
 static const struct wfx_platform_data wfx_spi_pdata = {
 	.file_fw = "wfm_wf200",
 	.file_pds = "wf200.pds",
@@ -199,9 +201,11 @@ static int wfx_spi_probe(struct spi_devi
 	if (!bus->gpio_reset) {
 		dev_warn(&func->dev, "try to load firmware anyway\n");
 	} else {
-		gpiod_set_value(bus->gpio_reset, 0);
-		udelay(100);
+		if (spi_get_device_id(func)->driver_data & WFX_RESET_INVERTED)
+			gpiod_toggle_active_low(bus->gpio_reset);
 		gpiod_set_value(bus->gpio_reset, 1);
+		udelay(100);
+		gpiod_set_value(bus->gpio_reset, 0);
 		udelay(2000);
 	}
 
@@ -243,14 +247,16 @@ static int wfx_spi_disconnect(struct spi
  * stripped.
  */
 static const struct spi_device_id wfx_spi_id[] = {
-	{ "wfx-spi", 0 },
+	{ "wfx-spi", WFX_RESET_INVERTED },
+	{ "wf200", 0 },
 	{ },
 };
 MODULE_DEVICE_TABLE(spi, wfx_spi_id);
 
 #ifdef CONFIG_OF
 static const struct of_device_id wfx_spi_of_match[] = {
-	{ .compatible = "silabs,wfx-spi" },
+	{ .compatible = "silabs,wfx-spi", .data = (void *)WFX_RESET_INVERTED },
+	{ .compatible = "silabs,wf200" },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, wfx_spi_of_match);


