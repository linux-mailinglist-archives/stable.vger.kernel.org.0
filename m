Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C07CA24EC
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbfH2S0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:26:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:57482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728558AbfH2SPm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:15:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D2D42342C;
        Thu, 29 Aug 2019 18:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102541;
        bh=mbc88SK90w/+Uoyl1A5Z9fHXLSXvvuFhUGHwFq5VEjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LPxdlt4jc51i344ngRHxG5qcsbiAkd3xYeNa04aHazXAwxq1rwWkEKyE8j323ii7S
         OyKjyxYreIXbPwZkqhKsdXkLScthARpfWsUlt/3YAxv9S3749QEhbayuSf6f16CP/i
         CboIi1Pnpn4y3wotVCICF8d8EJW9B/Jo+JdCMmcM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Thierry Reding <treding@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wei Xu <xuwei5@hisilicon.com>, Sasha Levin <sashal@kernel.org>,
        linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 75/76] gpio: Fix irqchip initialization order
Date:   Thu, 29 Aug 2019 14:13:10 -0400
Message-Id: <20190829181311.7562-75-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181311.7562-1-sashal@kernel.org>
References: <20190829181311.7562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

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
index 4f333d6f2e230..42f9e00ff4d1b 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1371,21 +1371,13 @@ int gpiochip_add_data_with_key(struct gpio_chip *chip, void *data,
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
@@ -1411,6 +1403,14 @@ int gpiochip_add_data_with_key(struct gpio_chip *chip, void *data,
 
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
@@ -1422,21 +1422,21 @@ int gpiochip_add_data_with_key(struct gpio_chip *chip, void *data,
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

