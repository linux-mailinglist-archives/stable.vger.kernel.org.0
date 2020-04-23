Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C07C1B6597
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 22:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgDWUkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 16:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgDWUkV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 16:40:21 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E6C8C09B042
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 13:40:21 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id t14so8218546wrw.12
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 13:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AD3yazCLz1166rGwfU67/jVo25D89AfNG0UXBEmhdE8=;
        b=kOgVZ9y/OAS9m/11EgGrV3+ksXR3i0o5GTfUuSFRzUlNSacjyFmmrb0CdXWQF6H5/g
         OZtZLAcappoFs6DV7/qXJ5HSeQBP7eh+hNwtwNHkzbSxEhWOwIOA1ljhVHIIHFTn6X6e
         W5/CR2nQ+4aR20BwvZDvL7JeB+i5ATff4nmnIRNLXyrn2nVw2Pn2Y0EfSk598AkoT0oC
         u/5J1DH+fjQhdbXX2n3Q8eNz+UTl2YfkdTlEDDBONILkyvafWJNEZOJqyVLb8ZIfAu7n
         5bLtzDWY5+XV2fyGG3X8G3rFNkW0S8K++oRkBzRwztGK0pG9GhLpYf3avWXdo58qFiMW
         55vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AD3yazCLz1166rGwfU67/jVo25D89AfNG0UXBEmhdE8=;
        b=NyASHLaj0Hbwm+DHt2Ye3/EYRyxQdiLVfOSTXDjFx4EcmT2r0hK5xrqdqFDOsIwgd9
         X/sK8L9c7ZAqY75ol1TnhuJ52eO1ml7gI7cjJJN6iirbi5S5Dj9+cxJ1wkNN899ZEpTS
         RX+kAbPuMfbgZmI7qiOcneK0gtDDu/XogVTOl+NSCzuUz1D4pfEwjWqgxsEeTNdC8nDz
         gBHjI2Jg/L5SIh3bTeYSTpL2IGeSavDLSMuwcLdYi9PwhWAfV/AB/H7IFFiub9M4Wdby
         ydU7Nu+9HKy70ITvJNIbFotYhknG3Z8rW1b3doztSAs1wwp6PRwaKtrAdTx43WmxGpGE
         gyxQ==
X-Gm-Message-State: AGi0PuZn/tSrCqPxpVgt9rlqQyU3VsIOctRR36C2gfJIdt86sqZzRprH
        /U4nfL3maiEzcb95tCeOXMNBEDVVVe8=
X-Google-Smtp-Source: APiQypK18k7HIafKdmMtkEaqLLlH8Djq//bY84lqLT2znYZxhixSsfaK7sLXg+tdBnQ9JZfnITQV8g==
X-Received: by 2002:a5d:4e45:: with SMTP id r5mr6865199wrt.26.1587674419692;
        Thu, 23 Apr 2020 13:40:19 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u17sm5933726wra.63.2020.04.23.13.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 13:40:18 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 02/16] gpiolib: Fix references to gpiod_[gs]et_*value_cansleep() variants
Date:   Thu, 23 Apr 2020 21:40:00 +0100
Message-Id: <20200423204014.784944-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200423204014.784944-1-lee.jones@linaro.org>
References: <20200423204014.784944-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

Commit 372e722ea4dd4ca1 ("gpiolib: use descriptors internally") renamed
the functions to use a "gpiod" prefix, and commit 79a9becda8940deb
("gpiolib: export descriptor-based GPIO interface") introduced the "raw"
variants, but both changes forgot to update the comments.

Readd a similar reference to gpiod_set_value(), which was accidentally
removed by commit 1e77fc82110ac36f ("gpio: Add missing open drain/source
handling to gpiod_set_value_cansleep()").

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20190701142738.25219-1-geert+renesas@glider.be
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/gpio/gpiolib.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 503405d32d240..3369dcc230e58 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1304,7 +1304,7 @@ int gpiod_get_raw_value(const struct gpio_desc *desc)
 {
 	if (!desc)
 		return 0;
-	/* Should be using gpio_get_value_cansleep() */
+	/* Should be using gpiod_get_raw_value_cansleep() */
 	WARN_ON(desc->chip->can_sleep);
 	return _gpiod_get_raw_value(desc);
 }
@@ -1325,7 +1325,7 @@ int gpiod_get_value(const struct gpio_desc *desc)
 	int value;
 	if (!desc)
 		return 0;
-	/* Should be using gpio_get_value_cansleep() */
+	/* Should be using gpiod_get_value_cansleep() */
 	WARN_ON(desc->chip->can_sleep);
 
 	value = _gpiod_get_raw_value(desc);
@@ -1501,7 +1501,7 @@ void gpiod_set_raw_value(struct gpio_desc *desc, int value)
 {
 	if (!desc)
 		return;
-	/* Should be using gpio_set_value_cansleep() */
+	/* Should be using gpiod_set_raw_value_cansleep() */
 	WARN_ON(desc->chip->can_sleep);
 	_gpiod_set_raw_value(desc, value);
 }
@@ -1522,7 +1522,7 @@ void gpiod_set_value(struct gpio_desc *desc, int value)
 {
 	if (!desc)
 		return;
-	/* Should be using gpio_set_value_cansleep() */
+	/* Should be using gpiod_set_value_cansleep() */
 	WARN_ON(desc->chip->can_sleep);
 	if (test_bit(FLAG_ACTIVE_LOW, &desc->flags))
 		value = !value;
-- 
2.25.1

