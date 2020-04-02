Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 406AE19C9B7
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388668AbgDBTRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:17:04 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35040 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388621AbgDBTRE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:17:04 -0400
Received: by mail-wm1-f67.google.com with SMTP id i19so4978322wmb.0
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=TF7tLYxH/nWJdyfEM3nOdhDC+3Fxk90WqRFDxs2gGHI=;
        b=hzs7GSdOnOBNCMm/6GUNt35h4qj8Dv0KIcLr8en9w1a2KiAK5ib3nUSw/Ky1y+W+zT
         MXEj279R1BZ6RDR0P//KzuUdLRa1Y/R8gJ6Uskbd9rIgOE3EeaIkNhPp2GSfPcWbr19K
         ZbNmAMRj+FSSnnO9fgqlq+HaLucy+pW5kZdA466HxA0U4cLQub7jNOQsry8nHT7nhu5W
         JpymHx+HhMOYSRYQougcfNIu9ARulYJF58iOo0K/JMUB0QEPG/oBiwMygtinoD/Ygv3V
         sX2ZyDk0hyKEJBx4uyEBWGJ2gaM76kr+pn+oQD32VMxKBYqTpZfLMbUCs1XBr0HMFvgq
         f6Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TF7tLYxH/nWJdyfEM3nOdhDC+3Fxk90WqRFDxs2gGHI=;
        b=UYnYVvPK7LKQJxdzbhVEp2/PUBrOMEAJd3NGirgRIHx7tjdHujw+XgBj7X3dvvukBE
         hS5+nYj8dHqBqkSLX2y5PndSj+p9nboG7eWaGijqf3o/gQWKg72LAmIukp4iDobv3+7D
         G5XVYqdwiuHEAkd7jYgiRzO5gp/URpFZNKA12VpVZ6DP3PmZ9GXYlbngc8kSmsaVTP6C
         hXkeoObsvtJ6pt97ikxMPV8cBqWB2NdNZQjI0Pjd4e9k3ExKOYosChF24GQhFs2PRpss
         ZBCk3NlU3DMvTrKpD4KFyl2Q/TZ4B6LOcXZCwnFbntxGnHzVGqSxahvYthJqaFTRh6RZ
         l5Ag==
X-Gm-Message-State: AGi0PuZKpEv4E8bpBEKLtgwNS7wtV5LO8kQsHWmBE1NyL+3577615dhY
        0hc3JjPF+gIAHs1cYwzmhS/M+MGCnh5Syw==
X-Google-Smtp-Source: APiQypIFpuvABD4svKxU8s3R2U2RDrnF+L7aAlToN7adZCII9J5q3pofsd21KePSMwk9gJnn+h0Yhg==
X-Received: by 2002:a1c:4c1a:: with SMTP id z26mr4759557wmf.94.1585855022345;
        Thu, 02 Apr 2020 12:17:02 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y1sm879050wmd.14.2020.04.02.12.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:17:01 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 08/24] Revert "gpio: set up initial state from .get_direction()"
Date:   Thu,  2 Apr 2020 20:17:31 +0100
Message-Id: <20200402191747.789097-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191747.789097-1-lee.jones@linaro.org>
References: <20200402191747.789097-1-lee.jones@linaro.org>
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
index 505dead076196..73d02f6089d56 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1232,31 +1232,14 @@ int gpiochip_add_data(struct gpio_chip *chip, void *data)
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

