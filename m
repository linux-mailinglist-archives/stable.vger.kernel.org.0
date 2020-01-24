Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA24147AE6
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731599AbgAXJjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:39:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:36440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731589AbgAXJjQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:39:16 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF6F120838;
        Fri, 24 Jan 2020 09:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858755;
        bh=ejhYGlJz29qxxXkISQoQ1D5EU/HBA6lMprgq1m3Zw8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Exai8LaWVl5cCsTHlt8HlyGM1b4evtisH2b7KiH1DxCfDIh08D/wTeEPFhEN9hpOV
         /uJOsiWUnZ4ONLyXKHmOsU57FtTycPX8Yhwq5ACSxjpwPUSOcwjuebGD/JYbjIQ7X5
         dbujnhfBbA2xCU2urKkQWxyzq399eVzZMiY/SMIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.4 048/102] gpiolib: No need to call gpiochip_remove_pin_ranges() twice
Date:   Fri, 24 Jan 2020 10:30:49 +0100
Message-Id: <20200124092813.549446778@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 2f4133bb5f14f49a99acf0cc55b84996dbfb4dff upstream.

of_gpiochip_add(), when fails, calls gpiochip_remove_pin_ranges().

ADD:
  gpiochip_add_data_with_key() ->
    of_gpiochip_add() -> (ERROR path)
      gpiochip_remove_pin_ranges()

At the same time of_gpiochip_remove() calls exactly the above mentioned
function unconditionally and so does gpiochip_remove().

REMOVE:
  gpiochip_remove() ->
    gpiochip_remove_pin_ranges()
    of_gpiochip_remove() ->
      gpiochip_remove_pin_ranges()

Since gpiochip_remove() calls gpiochip_remove_pin_ranges() unconditionally,
we have duplicate call to the same function when it's not necessary.

Move gpiochip_remove_pin_ranges() from of_gpiochip_add() to gpiochip_add()
to avoid duplicate calls and be consistent with the explicit call in
gpiochip_remove().

Fixes: e93fa3f24353 ("gpiolib: remove duplicate pin range code")
Depends-on: f7299d441a4d ("gpio: of: Fix of_gpiochip_add() error path")
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpiolib-of.c |    5 +----
 drivers/gpio/gpiolib.c    |    3 ++-
 2 files changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -909,16 +909,13 @@ int of_gpiochip_add(struct gpio_chip *ch
 	of_node_get(chip->of_node);
 
 	ret = of_gpiochip_scan_gpios(chip);
-	if (ret) {
+	if (ret)
 		of_node_put(chip->of_node);
-		gpiochip_remove_pin_ranges(chip);
-	}
 
 	return ret;
 }
 
 void of_gpiochip_remove(struct gpio_chip *chip)
 {
-	gpiochip_remove_pin_ranges(chip);
 	of_node_put(chip->of_node);
 }
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1452,6 +1452,7 @@ err_remove_of_chip:
 	gpiochip_free_hogs(chip);
 	of_gpiochip_remove(chip);
 err_free_gpiochip_mask:
+	gpiochip_remove_pin_ranges(chip);
 	gpiochip_free_valid_mask(chip);
 err_remove_from_list:
 	spin_lock_irqsave(&gpio_lock, flags);
@@ -1507,8 +1508,8 @@ void gpiochip_remove(struct gpio_chip *c
 	gdev->chip = NULL;
 	gpiochip_irqchip_remove(chip);
 	acpi_gpiochip_remove(chip);
-	gpiochip_remove_pin_ranges(chip);
 	of_gpiochip_remove(chip);
+	gpiochip_remove_pin_ranges(chip);
 	gpiochip_free_valid_mask(chip);
 	/*
 	 * We accept no more calls into the driver from this point, so


