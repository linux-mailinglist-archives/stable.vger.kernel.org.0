Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4320F479014
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 16:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbhLQPgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 10:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232296AbhLQPgQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 10:36:16 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87831C061574;
        Fri, 17 Dec 2021 07:36:16 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id kk22so2766209qvb.0;
        Fri, 17 Dec 2021 07:36:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2LwWlutyqD7nYHQDeBKlm46WqzAPw9nhQoOANdu3Uaw=;
        b=q8IUWkXLVm8YCthA9Y5eGFPWI3h1KYJ8ThNN5a++xPVUcxGdtmWWiaPE2yTvW5iKd3
         jlSramBjUPaGLM0nKipLU9eXOwGZKFL4c0NoogduBGdH8Oz8rwRmkWZ+orG6LPg2Mm1b
         D06/7ZShkX8JAutkIks8rVE8AcJu/on4ZdWMB5LHuAVFO4d4V4tdB8S0icRkLb97+H8i
         ShLNW1xByib/KQFWrSH6mYBvFs+qi1lIshIwHCDvUqkHn2gC0Sai26OCCgQmaW7dkSLk
         Mzo0Ak9uJ4cfeG6juFlrCn1C+wR94/PPsuy/BCSNumCHrY1gxAyFmYGXysd9twEPCtiZ
         uZdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2LwWlutyqD7nYHQDeBKlm46WqzAPw9nhQoOANdu3Uaw=;
        b=DgeW1LFzJueWVb+KCPCGkQ54ySTVRJpT3CHLNzFmkLmmcGOAgVvUkQVFvnJSe6vuvf
         Ewa+cq9Ti1e6qWveKet3/EY0a6SeOc0/PdUcoDlZuuwe5ZkukLm6x8Oe6TFaM8VfkdVk
         OF1BDjwSw7WHFCp5u6zozrNPEswkvPJ61P1Vd85YzYOIrK0XXc8bDv7HuHnP4w1Sh6Ey
         ZyVK2/6/IxfRV+M3mI6Ifk9sMpBz5CA0BRH6mB1QYylPJPxYuDdgGc8TnXJhMhF2RV6D
         GQqkeLw7lHLFRuHkDx5KXG+XGHhJnfebCQkvu+vZSA6uEew9nFpuoDC4vGbF5Zocrk7B
         Rslw==
X-Gm-Message-State: AOAM533l9L1wozecIczDnKlbsDKSSp9DC7h6RZaDqwEEJHX/Bf1LIN/w
        hXc8p5dWX2gtxGuWyMJ4bK7Vz6boA5Z5VQ==
X-Google-Smtp-Source: ABdhPJyux52uQUndq+YCULd3pt1Vq6dc9/BDuceV3zj9qPUux3TNaYwH1G2ATvEgO+X5MI+MOXb8xQ==
X-Received: by 2002:a05:6214:3004:: with SMTP id ke4mr3120202qvb.48.1639755374470;
        Fri, 17 Dec 2021 07:36:14 -0800 (PST)
Received: from linux-af78.suse ([189.122.236.87])
        by smtp.gmail.com with ESMTPSA id w14sm5086438qkp.54.2021.12.17.07.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 07:36:14 -0800 (PST)
From:   Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>
To:     stable@vger.kernel.org, regressions@lists.linux.dev,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        linux-gpio@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Edmond Chung <edmondchung@google.com>,
        Andrew Chant <achant@google.com>,
        Will McVicker <willmcvicker@google.com>,
        Sergio Tanzilli <tanzilli@acmesystems.it>
Cc:     Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>
Subject: [PATCH] gpio: Revert regression in sysfs-gpio (gpiolib.c)
Date:   Fri, 17 Dec 2021 12:35:55 -0300
Message-Id: <20211217153555.9413-1-marcelo.jimenez@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some GPIO lines have stopped working after the patch
commit 2ab73c6d8323f ("gpio: Support GPIO controllers without pin-ranges")

And this has supposedly been fixed in the following patches
commit 89ad556b7f96a ("gpio: Avoid using pin ranges with !PINCTRL")
commit 6dbbf84603961 ("gpiolib: Don't free if pin ranges are not defined")

But an erratic behavior where some GPIO lines work while others do not work
has been introduced.

This patch reverts those changes so that the sysfs-gpio interface works
properly again.

Signed-off-by: Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>
---

Hi,

My system is ARM926EJ-S rev 5 (v5l) (AT91SAM9G25), the board is an ACME Systems Arietta.

The system used sysfs-gpio to manage a few gpio lines, and I have noticed that some have stopped working.

The test script is very simple:

	#! /bin/bash

	cd /sys/class/gpio/
	echo 24 > export 

	cd pioA24
	echo out > direction

	echo 0 > value
	cat value
	echo 1 > value
	cat value
	echo 0 > value
	cat value
	echo 1 > value
	cat value

	cd ..
	echo 24 > unexport

In a "good" kernel, this script outputs 0, 1, 0, 1. In a bad kernel, the output result is 1, 1, 1, 1. Also it must be possible to run this script twice without errors, that was the issue with the gpiochip_generic_free() call that had been addressed in another patch.

In my system PINCTRL is automatically selected by 
SOC_AT91SAM9 [=y] && ARCH_AT91 [=y] && ARCH_MULTI_V5 [=y]

So it is not an option to disable it to make it work.

Best regards,
Marcelo.


 drivers/gpio/gpiolib.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index af5bb8fedfea..ac69ec8fb37a 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1804,11 +1804,6 @@ static inline void gpiochip_irqchip_free_valid_mask(struct gpio_chip *gc)
  */
 int gpiochip_generic_request(struct gpio_chip *gc, unsigned offset)
 {
-#ifdef CONFIG_PINCTRL
-	if (list_empty(&gc->gpiodev->pin_ranges))
-		return 0;
-#endif
-
 	return pinctrl_gpio_request(gc->gpiodev->base + offset);
 }
 EXPORT_SYMBOL_GPL(gpiochip_generic_request);
@@ -1820,11 +1815,6 @@ EXPORT_SYMBOL_GPL(gpiochip_generic_request);
  */
 void gpiochip_generic_free(struct gpio_chip *gc, unsigned offset)
 {
-#ifdef CONFIG_PINCTRL
-	if (list_empty(&gc->gpiodev->pin_ranges))
-		return;
-#endif
-
 	pinctrl_gpio_free(gc->gpiodev->base + offset);
 }
 EXPORT_SYMBOL_GPL(gpiochip_generic_free);
-- 
2.30.2

