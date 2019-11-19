Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE59B1018C9
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbfKSFaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:30:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:48772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729079AbfKSFaF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:30:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D427F21939;
        Tue, 19 Nov 2019 05:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141404;
        bh=6Wjnw45fi1Pp9pwaOW/zFICTaYR/dlHhA6uONnThtAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CjdXO+I/O+KHvUa6DQPk/+FcL8EQJlcs/znUUcIhvt+YIhI9FlTdjcgFagfoty1Ju
         Ych9dmXcuALTxX+xUcXYMEuL1ZSgW3s8+yaae5rf8/GYSk+wTpidwBNSuA61xzFZPX
         7NnS9VKZz1ARbY4hxCzamkT61GiGr9vhlmE9rVbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Radu Pirea <radu.pirea@microchip.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 150/422] tty/serial: atmel: Change the driver to work under at91-usart MFD
Date:   Tue, 19 Nov 2019 06:15:47 +0100
Message-Id: <20191119051408.360814564@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Radu Pirea <radu.pirea@microchip.com>

[ Upstream commit c24d25317a7c6bb3053d4c193b3cf57d1e9a3e4b ]

This patch modifies the place where resources and device tree properties
are searched.

Signed-off-by: Radu Pirea <radu.pirea@microchip.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Acked-by: Richard Genoud <richard.genoud@gmail.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/Kconfig        |  1 +
 drivers/tty/serial/atmel_serial.c | 42 ++++++++++++++++++++-----------
 2 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index df8bd0c7b97db..32886c3046413 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -118,6 +118,7 @@ config SERIAL_ATMEL
 	depends on ARCH_AT91 || COMPILE_TEST
 	select SERIAL_CORE
 	select SERIAL_MCTRL_GPIO if GPIOLIB
+	select MFD_AT91_USART
 	help
 	  This enables the driver for the on-chip UARTs of the Atmel
 	  AT91 processors.
diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index dd8949e8fcd7a..251f708f47f76 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -195,8 +195,7 @@ static struct console atmel_console;
 
 #if defined(CONFIG_OF)
 static const struct of_device_id atmel_serial_dt_ids[] = {
-	{ .compatible = "atmel,at91rm9200-usart" },
-	{ .compatible = "atmel,at91sam9260-usart" },
+	{ .compatible = "atmel,at91rm9200-usart-serial" },
 	{ /* sentinel */ }
 };
 #endif
@@ -926,6 +925,7 @@ static void atmel_tx_dma(struct uart_port *port)
 static int atmel_prepare_tx_dma(struct uart_port *port)
 {
 	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
+	struct device *mfd_dev = port->dev->parent;
 	dma_cap_mask_t		mask;
 	struct dma_slave_config config;
 	int ret, nent;
@@ -933,7 +933,7 @@ static int atmel_prepare_tx_dma(struct uart_port *port)
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
 
-	atmel_port->chan_tx = dma_request_slave_channel(port->dev, "tx");
+	atmel_port->chan_tx = dma_request_slave_channel(mfd_dev, "tx");
 	if (atmel_port->chan_tx == NULL)
 		goto chan_err;
 	dev_info(port->dev, "using %s for tx DMA transfers\n",
@@ -1104,6 +1104,7 @@ static void atmel_rx_from_dma(struct uart_port *port)
 static int atmel_prepare_rx_dma(struct uart_port *port)
 {
 	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
+	struct device *mfd_dev = port->dev->parent;
 	struct dma_async_tx_descriptor *desc;
 	dma_cap_mask_t		mask;
 	struct dma_slave_config config;
@@ -1115,7 +1116,7 @@ static int atmel_prepare_rx_dma(struct uart_port *port)
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_CYCLIC, mask);
 
-	atmel_port->chan_rx = dma_request_slave_channel(port->dev, "rx");
+	atmel_port->chan_rx = dma_request_slave_channel(mfd_dev, "rx");
 	if (atmel_port->chan_rx == NULL)
 		goto chan_err;
 	dev_info(port->dev, "using %s for rx DMA transfers\n",
@@ -2246,8 +2247,8 @@ static const char *atmel_type(struct uart_port *port)
  */
 static void atmel_release_port(struct uart_port *port)
 {
-	struct platform_device *pdev = to_platform_device(port->dev);
-	int size = pdev->resource[0].end - pdev->resource[0].start + 1;
+	struct platform_device *mpdev = to_platform_device(port->dev->parent);
+	int size = resource_size(mpdev->resource);
 
 	release_mem_region(port->mapbase, size);
 
@@ -2262,8 +2263,8 @@ static void atmel_release_port(struct uart_port *port)
  */
 static int atmel_request_port(struct uart_port *port)
 {
-	struct platform_device *pdev = to_platform_device(port->dev);
-	int size = pdev->resource[0].end - pdev->resource[0].start + 1;
+	struct platform_device *mpdev = to_platform_device(port->dev->parent);
+	int size = resource_size(mpdev->resource);
 
 	if (!request_mem_region(port->mapbase, size, "atmel_serial"))
 		return -EBUSY;
@@ -2365,27 +2366,28 @@ static int atmel_init_port(struct atmel_uart_port *atmel_port,
 {
 	int ret;
 	struct uart_port *port = &atmel_port->uart;
+	struct platform_device *mpdev = to_platform_device(pdev->dev.parent);
 
 	atmel_init_property(atmel_port, pdev);
 	atmel_set_ops(port);
 
-	uart_get_rs485_mode(&pdev->dev, &port->rs485);
+	uart_get_rs485_mode(&mpdev->dev, &port->rs485);
 
 	port->iotype		= UPIO_MEM;
 	port->flags		= UPF_BOOT_AUTOCONF | UPF_IOREMAP;
 	port->ops		= &atmel_pops;
 	port->fifosize		= 1;
 	port->dev		= &pdev->dev;
-	port->mapbase	= pdev->resource[0].start;
-	port->irq	= pdev->resource[1].start;
+	port->mapbase		= mpdev->resource[0].start;
+	port->irq		= mpdev->resource[1].start;
 	port->rs485_config	= atmel_config_rs485;
-	port->membase	= NULL;
+	port->membase		= NULL;
 
 	memset(&atmel_port->rx_ring, 0, sizeof(atmel_port->rx_ring));
 
 	/* for console, the clock could already be configured */
 	if (!atmel_port->clk) {
-		atmel_port->clk = clk_get(&pdev->dev, "usart");
+		atmel_port->clk = clk_get(&mpdev->dev, "usart");
 		if (IS_ERR(atmel_port->clk)) {
 			ret = PTR_ERR(atmel_port->clk);
 			atmel_port->clk = NULL;
@@ -2718,13 +2720,22 @@ static void atmel_serial_probe_fifos(struct atmel_uart_port *atmel_port,
 static int atmel_serial_probe(struct platform_device *pdev)
 {
 	struct atmel_uart_port *atmel_port;
-	struct device_node *np = pdev->dev.of_node;
+	struct device_node *np = pdev->dev.parent->of_node;
 	void *data;
 	int ret = -ENODEV;
 	bool rs485_enabled;
 
 	BUILD_BUG_ON(ATMEL_SERIAL_RINGSIZE & (ATMEL_SERIAL_RINGSIZE - 1));
 
+	/*
+	 * In device tree there is no node with "atmel,at91rm9200-usart-serial"
+	 * as compatible string. This driver is probed by at91-usart mfd driver
+	 * which is just a wrapper over the atmel_serial driver and
+	 * spi-at91-usart driver. All attributes needed by this driver are
+	 * found in of_node of parent.
+	 */
+	pdev->dev.of_node = np;
+
 	ret = of_alias_get_id(np, "serial");
 	if (ret < 0)
 		/* port id not found in platform data nor device-tree aliases:
@@ -2860,6 +2871,7 @@ static int atmel_serial_remove(struct platform_device *pdev)
 
 	clk_put(atmel_port->clk);
 	atmel_port->clk = NULL;
+	pdev->dev.of_node = NULL;
 
 	return ret;
 }
@@ -2870,7 +2882,7 @@ static struct platform_driver atmel_serial_driver = {
 	.suspend	= atmel_serial_suspend,
 	.resume		= atmel_serial_resume,
 	.driver		= {
-		.name			= "atmel_usart",
+		.name			= "atmel_usart_serial",
 		.of_match_table		= of_match_ptr(atmel_serial_dt_ids),
 	},
 };
-- 
2.20.1



