Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0084FACDD7
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733257AbfIHMwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:52:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:45464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733249AbfIHMwy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:52:54 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AE0621479;
        Sun,  8 Sep 2019 12:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567947172;
        bh=FxbGv5hFJ/w8muR36FY4ddff9aeMidj+SEbT1AxUP8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JuK4QcRKmEqBDbmGrh3BG8Rxty98Vgp5ditT3DeuLVO8jY4S+5YqN6+l1YpnXdq3/
         QTn7WfCytrKmZouLiYc0i907CmGI8kdurnYWPh1eyFTJhm8In1ZM1u53JNj94Gi+Ng
         ahBJv0MlPIbHAqfpQdaQrqzGYkPc50eyv5KR3DOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wei Xu <xuwei5@hisilicon.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 88/94] gpio: Fix irqchip initialization order
Date:   Sun,  8 Sep 2019 13:42:24 +0100
Message-Id: <20190908121152.950273533@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 48057ed1840fde9239b1e000bea1a0a1f07c5e99 ]

The new API for registering a gpio_irq_chip along with a
gpio_chip has a different semantic ordering than the old
API which added the irqchip explicitly after registering
the gpio_chip.

Move the calls to add the gpio_irq_chip *last* in the
function, so that the different hooks setting up OF and
ACPI and machine gpio_chips are called *before* we try
to register the interrupts, preserving the elder semantic
order.

This cropped up in the PL061 driver which used to work
fine with no special ACPI quirks, but started to misbehave
using the new API.

Fixes: e0d897289813 ("gpio: Implement tighter IRQ chip integration")
Cc: Thierry Reding <treding@nvidia.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Reported-by: Wei Xu <xuwei5@hisilicon.com>
Tested-by: Wei Xu <xuwei5@hisilicon.com>
Reported-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20190820080527.11796-1-linus.walleij@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 7f9f752011382..f272b51439977 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1373,21 +1373,13 @@ int gpiochip_add_data_with_key(struct gpio_chip *chip, void *data,
 	if (status)
 		goto err_remove_from_list;
 
-	status = gpiochip_irqchip_init_valid_mask(chip);
-	if (status)
-		goto err_remove_from_list;
-
 	status = gpiochip_alloc_valid_mask(chip);
 	if (status)
-		goto err_remove_irqchip_mask;
-
-	status = gpiochip_add_irqchip(chip, lock_key, request_key);
-	if (status)
-		goto err_free_gpiochip_mask;
+		goto err_remove_from_list;
 
 	status = of_gpiochip_add(chip);
 	if (status)
-		goto err_remove_chip;
+		goto err_free_gpiochip_mask;
 
 	status = gpiochip_init_valid_mask(chip);
 	if (status)
@@ -1413,6 +1405,14 @@ int gpiochip_add_data_with_key(struct gpio_chip *chip, void *data,
 
 	machine_gpiochip_add(chip);
 
+	status = gpiochip_irqchip_init_valid_mask(chip);
+	if (status)
+		goto err_remove_acpi_chip;
+
+	status = gpiochip_add_irqchip(chip, lock_key, request_key);
+	if (status)
+		goto err_remove_irqchip_mask;
+
 	/*
 	 * By first adding the chardev, and then adding the device,
 	 * we get a device node entry in sysfs under
@@ -1424,21 +1424,21 @@ int gpiochip_add_data_with_key(struct gpio_chip *chip, void *data,
 	if (gpiolib_initialized) {
 		status = gpiochip_setup_dev(gdev);
 		if (status)
-			goto err_remove_acpi_chip;
+			goto err_remove_irqchip;
 	}
 	return 0;
 
+err_remove_irqchip:
+	gpiochip_irqchip_remove(chip);
+err_remove_irqchip_mask:
+	gpiochip_irqchip_free_valid_mask(chip);
 err_remove_acpi_chip:
 	acpi_gpiochip_remove(chip);
 err_remove_of_chip:
 	gpiochip_free_hogs(chip);
 	of_gpiochip_remove(chip);
-err_remove_chip:
-	gpiochip_irqchip_remove(chip);
 err_free_gpiochip_mask:
 	gpiochip_free_valid_mask(chip);
-err_remove_irqchip_mask:
-	gpiochip_irqchip_free_valid_mask(chip);
 err_remove_from_list:
 	spin_lock_irqsave(&gpio_lock, flags);
 	list_del(&gdev->list);
-- 
2.20.1



