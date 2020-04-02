Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01DE419C98E
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389243AbgDBTNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:13:09 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52510 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389214AbgDBTNJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:13:09 -0400
Received: by mail-wm1-f65.google.com with SMTP id t8so4623138wmi.2
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=FufN8ACRAoxbxjTegJ+M/1R/ELgdwjuEiGq1TqIq1Lc=;
        b=zlcZ6P9xHgTRMA2xGAYRz2jGPUk3ByBZhUFX1aWtAJbvCacE28u0XHgrjt2vNiIPv3
         Mjh6szFlryYtPB+rrCBXMRpNQupmg8ghzEw9H2G8p+LbuGKGOmUUg22m5F5pJrxdHf7l
         ki0x8NvuDpUH5q5YeMOuquh7zpYfyxqsImBL7K2bgVvWMRpkD1Xv0uxsvfrDez/rgJZ6
         8RnBLMu+YFww7wpImZtDKYRltSGzF/FTE+SG7yQiYfKyikr/NTf/XU5HIaTfdlHvXeUh
         vSoDXzOL5nom1o+GT2Ro3Q+co2XxuUY96aOeQ+/W48MYQ++QvNaxCe/n+KrPsZIsOgEM
         3i7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FufN8ACRAoxbxjTegJ+M/1R/ELgdwjuEiGq1TqIq1Lc=;
        b=c2bIHh5UwDqRIFp1AZ6wVjvBGIstqykAER5rX97posRXOBIR9IaeNrwM0hkSXukV2A
         i+sVV8oHyotR4gcpr1BSt0OYIv+a+ms5YpyvZ/J7ZB6FFwdFH+Z2qc6L9bVJTRaboMIM
         5lS1/WwOqz7eU0T93gQZCJeYeL/K7GNrhZ77BBQbf1s7uWIrhTWrajqQTLUqXHLmPAe0
         o95ggfGKZ4JA4ts1Hx0pj/BUMpDNvE5FCe8EN9HK75HG9csE5U0aAu0QEODyAQWhvByB
         SZujmzUnlfBKvjQMa6vgNkHk5sdro81dQHd1RYwCQJ1oskUfgxzj8WVjp/2wMa0qCQfn
         AmeA==
X-Gm-Message-State: AGi0PuaQkEW6e/ryEYtFprI59wtBA6QEgaK7eriljYoQ7EKvG7AmRWrO
        ks3F/uUEJjNVG7s98KoxGAC66i1HCUaiSQ==
X-Google-Smtp-Source: APiQypLkhYlLr8m8DIBnDk0hoEALV3w6F0tbZbXdVuYzXmwrWzqwzMAYNhodXMvgr62XsggS/JEZcQ==
X-Received: by 2002:a05:600c:2611:: with SMTP id h17mr5008579wma.183.1585854786232;
        Thu, 02 Apr 2020 12:13:06 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y12sm5511514wrn.55.2020.04.02.12.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:13:05 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 07/33] Revert "gpio: set up initial state from .get_direction()"
Date:   Thu,  2 Apr 2020 20:13:27 +0100
Message-Id: <20200402191353.787836-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191353.787836-1-lee.jones@linaro.org>
References: <20200402191353.787836-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Timur Tabi <timur@codeaurora.org>

[ Upstream commit 1ca2a92b2a99323f666f1b669b7484df4bda05e4 ]

This reverts commit 72d3200061776264941be1b5a9bb8e926b3b30a5.

We cannot blindly query the direction of all GPIOs when the pins are
first registered.  The get_direction callback normally triggers a
read/write to hardware, but we shouldn't be touching the hardware for
an individual GPIO until after it's been properly claimed.

Signed-off-by: Timur Tabi <timur@codeaurora.org>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/gpio/gpiolib.c | 31 +++++++------------------------
 1 file changed, 7 insertions(+), 24 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index f0777a7a4305b..d5b42cc86d718 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1245,31 +1245,14 @@ int gpiochip_add_data(struct gpio_chip *chip, void *data)
 		struct gpio_desc *desc = &gdev->descs[i];
 
 		desc->gdev = gdev;
-		/*
-		 * REVISIT: most hardware initializes GPIOs as inputs
-		 * (often with pullups enabled) so power usage is
-		 * minimized. Linux code should set the gpio direction
-		 * first thing; but until it does, and in case
-		 * chip->get_direction is not set, we may expose the
-		 * wrong direction in sysfs.
-		 */
-
-		if (chip->get_direction) {
-			/*
-			 * If we have .get_direction, set up the initial
-			 * direction flag from the hardware.
-			 */
-			int dir = chip->get_direction(chip, i);
 
-			if (!dir)
-				set_bit(FLAG_IS_OUT, &desc->flags);
-		} else if (!chip->direction_input) {
-			/*
-			 * If the chip lacks the .direction_input callback
-			 * we logically assume all lines are outputs.
-			 */
-			set_bit(FLAG_IS_OUT, &desc->flags);
-		}
+		/* REVISIT: most hardware initializes GPIOs as inputs (often
+		 * with pullups enabled) so power usage is minimized. Linux
+		 * code should set the gpio direction first thing; but until
+		 * it does, and in case chip->get_direction is not set, we may
+		 * expose the wrong direction in sysfs.
+		 */
+		desc->flags = !chip->direction_input ? (1 << FLAG_IS_OUT) : 0;
 	}
 
 #ifdef CONFIG_PINCTRL
-- 
2.25.1

