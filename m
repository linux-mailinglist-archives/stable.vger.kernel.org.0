Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2D21FE4DD
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbgFRBSj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:18:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726997AbgFRBSh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:18:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04DF4221F3;
        Thu, 18 Jun 2020 01:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443116;
        bh=Hwb8RdOICnfAWn54O9C5w3TGy5ajzSZfqY6SLChfTmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YceVCmldxSxcQLCIB+G2P5JF5bofy7Vqxk/wNfSZOE7uro3YrwrSEinXM/DSfUyUI
         Ff1a2UZx+1o2WtzBGabrUDtlSmChOLwTvlhEoXYpk/KvNCpdhPs4gIWIWLjpYOro9g
         gWYhOFENVD5DYt3KXWDYE4GiZKY7r9pwZnFxaEfI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 092/266] gpio: dwapb: Append MODULE_ALIAS for platform driver
Date:   Wed, 17 Jun 2020 21:13:37 -0400
Message-Id: <20200618011631.604574-92-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit c58220cba2e03618659fa7d5dfae31f5ad4ae9d0 ]

The commit 3d2613c4289f
  ("GPIO: gpio-dwapb: Enable platform driver binding to MFD driver")
introduced a use of the platform driver but missed to add the following line
to it:
  MODULE_ALIAS("platform:gpio-dwapb");

Add this to get driver loaded automatically if platform device is registered.

Fixes: 3d2613c4289f ("GPIO: gpio-dwapb: Enable platform driver binding to MFD driver")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Serge Semin <fancer.lancer@gmail.com>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Link: https://lore.kernel.org/r/20200415141534.31240-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-dwapb.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
index 02cf4c43a4c4..ed6061b5cca1 100644
--- a/drivers/gpio/gpio-dwapb.c
+++ b/drivers/gpio/gpio-dwapb.c
@@ -49,7 +49,9 @@
 #define GPIO_EXT_PORTC		0x58
 #define GPIO_EXT_PORTD		0x5c
 
+#define DWAPB_DRIVER_NAME	"gpio-dwapb"
 #define DWAPB_MAX_PORTS		4
+
 #define GPIO_EXT_PORT_STRIDE	0x04 /* register stride 32 bits */
 #define GPIO_SWPORT_DR_STRIDE	0x0c /* register stride 3*32 bits */
 #define GPIO_SWPORT_DDR_STRIDE	0x0c /* register stride 3*32 bits */
@@ -398,7 +400,7 @@ static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
 		return;
 
 	err = irq_alloc_domain_generic_chips(gpio->domain, ngpio, 2,
-					     "gpio-dwapb", handle_level_irq,
+					     DWAPB_DRIVER_NAME, handle_level_irq,
 					     IRQ_NOREQUEST, 0,
 					     IRQ_GC_INIT_NESTED_LOCK);
 	if (err) {
@@ -455,7 +457,7 @@ static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
 		 */
 		err = devm_request_irq(gpio->dev, pp->irq[0],
 				       dwapb_irq_handler_mfd,
-				       IRQF_SHARED, "gpio-dwapb-mfd", gpio);
+				       IRQF_SHARED, DWAPB_DRIVER_NAME, gpio);
 		if (err) {
 			dev_err(gpio->dev, "error requesting IRQ\n");
 			irq_domain_remove(gpio->domain);
@@ -843,7 +845,7 @@ static SIMPLE_DEV_PM_OPS(dwapb_gpio_pm_ops, dwapb_gpio_suspend,
 
 static struct platform_driver dwapb_gpio_driver = {
 	.driver		= {
-		.name	= "gpio-dwapb",
+		.name	= DWAPB_DRIVER_NAME,
 		.pm	= &dwapb_gpio_pm_ops,
 		.of_match_table = of_match_ptr(dwapb_of_match),
 		.acpi_match_table = ACPI_PTR(dwapb_acpi_match),
@@ -857,3 +859,4 @@ module_platform_driver(dwapb_gpio_driver);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jamie Iles");
 MODULE_DESCRIPTION("Synopsys DesignWare APB GPIO driver");
+MODULE_ALIAS("platform:" DWAPB_DRIVER_NAME);
-- 
2.25.1

