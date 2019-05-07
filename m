Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25EE215C48
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 08:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbfEGFfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:35:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbfEGFfd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:35:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1274B206A3;
        Tue,  7 May 2019 05:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207331;
        bh=5bm6hP6cV7FT6X/0RYs804BTWFcllcfkZq9xn1tITn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xPS3uSxQtLCh7/ru2mC7uuCu3+19shzQDu/A2XcfwIcSmt3bBF7jcbwT4HVmL3Q8g
         GMKuSN5cKtCG6gxzWiYngdjvL63BD2KG59OhmP9rRgKEAiYvBJFJHuhcFpv6T+H4tg
         1RCXKcb4MZLJYR5hDO+mRCqTBkUJPuyc7H2rKjYA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Mukesh Ojha <mojha@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 91/99] gpio: Fix gpiochip_add_data_with_key() error path
Date:   Tue,  7 May 2019 01:32:25 -0400
Message-Id: <20190507053235.29900-91-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 357798909164bf423eac6a78ff7da7e98d2d7f7f ]

The err_remove_chip block is too coarse, and may perform cleanup that
must not be done.  E.g. if of_gpiochip_add() fails, of_gpiochip_remove()
is still called, causing:

    OF: ERROR: Bad of_node_put() on /soc/gpio@e6050000
    CPU: 1 PID: 20 Comm: kworker/1:1 Not tainted 5.1.0-rc2-koelsch+ #407
    Hardware name: Generic R-Car Gen2 (Flattened Device Tree)
    Workqueue: events deferred_probe_work_func
    [<c020ec74>] (unwind_backtrace) from [<c020ae58>] (show_stack+0x10/0x14)
    [<c020ae58>] (show_stack) from [<c07c1224>] (dump_stack+0x7c/0x9c)
    [<c07c1224>] (dump_stack) from [<c07c5a80>] (kobject_put+0x94/0xbc)
    [<c07c5a80>] (kobject_put) from [<c0470420>] (gpiochip_add_data_with_key+0x8d8/0xa3c)
    [<c0470420>] (gpiochip_add_data_with_key) from [<c0473738>] (gpio_rcar_probe+0x1d4/0x314)
    [<c0473738>] (gpio_rcar_probe) from [<c052fca8>] (platform_drv_probe+0x48/0x94)

and later, if a GPIO consumer tries to use a GPIO from a failed
controller:

    WARNING: CPU: 0 PID: 1 at lib/refcount.c:156 kobject_get+0x38/0x4c
    refcount_t: increment on 0; use-after-free.
    Modules linked in:
    CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.1.0-rc2-koelsch+ #407
    Hardware name: Generic R-Car Gen2 (Flattened Device Tree)
    [<c020ec74>] (unwind_backtrace) from [<c020ae58>] (show_stack+0x10/0x14)
    [<c020ae58>] (show_stack) from [<c07c1224>] (dump_stack+0x7c/0x9c)
    [<c07c1224>] (dump_stack) from [<c0221580>] (__warn+0xd0/0xec)
    [<c0221580>] (__warn) from [<c02215e0>] (warn_slowpath_fmt+0x44/0x6c)
    [<c02215e0>] (warn_slowpath_fmt) from [<c07c58fc>] (kobject_get+0x38/0x4c)
    [<c07c58fc>] (kobject_get) from [<c068b3ec>] (of_node_get+0x14/0x1c)
    [<c068b3ec>] (of_node_get) from [<c0686f24>] (of_find_node_by_phandle+0xc0/0xf0)
    [<c0686f24>] (of_find_node_by_phandle) from [<c0686fbc>] (of_phandle_iterator_next+0x68/0x154)
    [<c0686fbc>] (of_phandle_iterator_next) from [<c0687fe4>] (__of_parse_phandle_with_args+0x40/0xd0)
    [<c0687fe4>] (__of_parse_phandle_with_args) from [<c0688204>] (of_parse_phandle_with_args_map+0x100/0x3ac)
    [<c0688204>] (of_parse_phandle_with_args_map) from [<c0471240>] (of_get_named_gpiod_flags+0x38/0x380)
    [<c0471240>] (of_get_named_gpiod_flags) from [<c046f864>] (gpiod_get_from_of_node+0x24/0xd8)
    [<c046f864>] (gpiod_get_from_of_node) from [<c0470aa4>] (devm_fwnode_get_index_gpiod_from_child+0xa0/0x144)
    [<c0470aa4>] (devm_fwnode_get_index_gpiod_from_child) from [<c05f425c>] (gpio_keys_probe+0x418/0x7bc)
    [<c05f425c>] (gpio_keys_probe) from [<c052fca8>] (platform_drv_probe+0x48/0x94)

Fix this by splitting the cleanup block, and adding a missing call to
gpiochip_irqchip_remove().

Fixes: 28355f81969962cf ("gpio: defer probe if pinctrl cannot be found")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index d1adfdf50fb3..34fbf879411f 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1379,7 +1379,7 @@ int gpiochip_add_data_with_key(struct gpio_chip *chip, void *data,
 
 	status = gpiochip_add_irqchip(chip, lock_key, request_key);
 	if (status)
-		goto err_remove_chip;
+		goto err_free_gpiochip_mask;
 
 	status = of_gpiochip_add(chip);
 	if (status)
@@ -1387,7 +1387,7 @@ int gpiochip_add_data_with_key(struct gpio_chip *chip, void *data,
 
 	status = gpiochip_init_valid_mask(chip);
 	if (status)
-		goto err_remove_chip;
+		goto err_remove_of_chip;
 
 	for (i = 0; i < chip->ngpio; i++) {
 		struct gpio_desc *desc = &gdev->descs[i];
@@ -1415,14 +1415,18 @@ int gpiochip_add_data_with_key(struct gpio_chip *chip, void *data,
 	if (gpiolib_initialized) {
 		status = gpiochip_setup_dev(gdev);
 		if (status)
-			goto err_remove_chip;
+			goto err_remove_acpi_chip;
 	}
 	return 0;
 
-err_remove_chip:
+err_remove_acpi_chip:
 	acpi_gpiochip_remove(chip);
+err_remove_of_chip:
 	gpiochip_free_hogs(chip);
 	of_gpiochip_remove(chip);
+err_remove_chip:
+	gpiochip_irqchip_remove(chip);
+err_free_gpiochip_mask:
 	gpiochip_free_valid_mask(chip);
 err_remove_irqchip_mask:
 	gpiochip_irqchip_free_valid_mask(chip);
-- 
2.20.1

