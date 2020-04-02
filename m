Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79D0E19C9D1
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389465AbgDBTSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:18:07 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53034 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728452AbgDBTSH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:18:07 -0400
Received: by mail-wm1-f66.google.com with SMTP id t8so4638085wmi.2
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=AD3yazCLz1166rGwfU67/jVo25D89AfNG0UXBEmhdE8=;
        b=KkZPd1YCbMZiUObcXC5ECSZMRIy/IYXDPG7WGTyXiwNIX2n2bwdc85IVwKsX9HUn3a
         AbxXK8VySqFTpS3N32WnqY2AN+eHZEhuNV+ij6ghcLYuXf6Mat4A3v4d3qJ8KeN/Ire3
         aGiMkHJw+OuXZB+rxtK5t8Y75tJeRArFkWVZlIvUjnTOmMqGLtpU1AwYJ0wUP5BlTQm3
         xE3mj+2JbBAuoiIibzCpJ0eTICP+gMf31zIqNWeC7bZpRuD2qOXxJDku9Y+GPXAfMcVy
         3v+krb55CTDQ/dV0eWnXL7wxWnJRMmtEELIg+H3c3x3Z4NMsM2vuHszZ+mut8X2Od51B
         Mi/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AD3yazCLz1166rGwfU67/jVo25D89AfNG0UXBEmhdE8=;
        b=YD/I+CgLMFKu36MO+/kkjSf7cuok/nCNmDorul3NulJmWB8pTVAS5wUWkB+IqLw09Q
         2vzep7FEUj9kx02h4/rgpgAqWxHoufg/eWkI8Q6vk44AxaoMOzJzky2PrWcXYxSpSpNK
         RWfkhfuIWDBTgQCHhynjQRo5z9hC0J407exa5d7323lhDjsh/c7kInd4wUS9bNfrn9GV
         zUP0ee5RTfl8saleKYHLWhx32ud+PwxtWHmehs447JYSr2lQrb2lvnuNjklHshp6Q7fS
         HZBpqDB1qgoQWhWCMdQCG5rF4yrB7j1sZ1MRHnjtT8HuvRyy8tbktdrS0Jk7a3O0Bbuk
         baZQ==
X-Gm-Message-State: AGi0PuYJERLx8bj11TMOm0oiTIl+wvTgqa2wJHeunumbz16qohss0Uc5
        VHpRJpjiku4qIl9HkOcLcJZYY1E8Q8dHOA==
X-Google-Smtp-Source: APiQypJUtS7jMSOPPYlCT0iKrFVh/qTJQEWE2ZC/xnXiiO49LUV3qz08uSVF77tlZ6gjijaklDh5Ww==
X-Received: by 2002:a05:600c:1403:: with SMTP id g3mr4660861wmi.76.1585855085215;
        Thu, 02 Apr 2020 12:18:05 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id l10sm8622707wrq.95.2020.04.02.12.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:18:04 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.4 03/20] gpiolib: Fix references to gpiod_[gs]et_*value_cansleep() variants
Date:   Thu,  2 Apr 2020 20:18:39 +0100
Message-Id: <20200402191856.789622-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191856.789622-1-lee.jones@linaro.org>
References: <20200402191856.789622-1-lee.jones@linaro.org>
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

