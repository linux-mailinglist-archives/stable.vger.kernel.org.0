Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDE3D6699
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 17:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729858AbfJNPyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 11:54:40 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35346 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730561AbfJNPyk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 11:54:40 -0400
Received: by mail-wr1-f66.google.com with SMTP id v8so20352321wrt.2
        for <stable@vger.kernel.org>; Mon, 14 Oct 2019 08:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TkFjkjTMp886xdjclYNX5BFj79F6kyRdIe7v3CZ5y/U=;
        b=fW7n9A01iwnlBbKVondMyrjpTQ6E5MaNj5FMF3rNu3dYPEHnpWDK2FD95DncENpD6/
         CqE7RNAO5nwFdqPydati1E5/Sn9LBMCOYMZKc5YZeqCColWWh1y+jHJfVCLTpfFoiqtO
         XC6rI8J7UV5hO1x1o5QtjDqbHfURNz6Y/grsEyEGU8aWhu1zee4w7nkvGUsX+6PaRc2V
         c1kWDAK9X+9H1SRGt5OXUd8x3ZtQY83id+WZMnKQnDsRzd0KVyMvodZTQvJTULq898nf
         NjUM5+hXALi0QaQqdnT0K8/bQ8BaQMWBvByOQT2j8fQK75TmGAVouY/77mEFKQBdHSU6
         /Y7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TkFjkjTMp886xdjclYNX5BFj79F6kyRdIe7v3CZ5y/U=;
        b=uXXxRhgyzaKnT6FJBr225PnOPguDhmJRZ8LBaZZR4WawJ5tiS2F4Jj6O60rHLUJ2xM
         qbz2PcbfkedJ156uDL6BkiQRTJT6ZD0AJCS5tlro0in9r4huKvBp51UeZInPYqIPhNsT
         0kkJT8ICEqzyNdsQYJve9oSLJuAj/pgtwpB5QphPNmF9bn3Vv+j95C3MMv5fhv4tkYSP
         4jy5yb3qIfh6OKmqgIC+iPdCGn+quSRdgo/8Ksu61nMC7CfysKZcZQn0sAKekFv5xqPA
         83n4/kmlV1A+V6XuaxcnUi+yeCp8Hm9TAYpgS5Uvpfygpa7HmLKCKMIJ8lI7L8lSFX3V
         z6cQ==
X-Gm-Message-State: APjAAAUrYa4FMHVOPqoTt4wYOu03WjY2u2dVgGROTlyGpy9G9pP3jqiX
        vuzBZ3oaAYqtMNgNKz7bLxX4Mw==
X-Google-Smtp-Source: APXvYqwOuaJSGmXpozR/Ykv3asUT3rbUKSBJusklWa+bIoUiEbip2/AcI4wIksHipsOrqULNWPgKiw==
X-Received: by 2002:a5d:4aca:: with SMTP id y10mr15413353wrs.292.1571068478024;
        Mon, 14 Oct 2019 08:54:38 -0700 (PDT)
Received: from localhost.localdomain ([2a01:cb1d:af:5b00:6d6c:8493:1ab5:dad7])
        by smtp.gmail.com with ESMTPSA id l18sm20936836wrc.18.2019.10.14.08.54.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 08:54:37 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-gpio@vger.kernel.org, stable@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Kent Gibson <warthog618@gmail.com>
Subject: [PATCH v5.3, v4.19] gpiolib: don't clear FLAG_IS_OUT when emulating open-drain/open-source
Date:   Mon, 14 Oct 2019 17:54:35 +0200
Message-Id: <20191014155435.13234-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

When emulating open-drain/open-source by not actively driving the output
lines - we're simply changing their mode to input. This is wrong as it
will then make it impossible to change the value of such line - it's now
considered to actually be in input mode. If we want to still use the
direction_input() callback for simplicity then we need to set FLAG_IS_OUT
manually in gpiod_direction_output() and not clear it in
gpio_set_open_drain_value_commit() and
gpio_set_open_source_value_commit().

Fixes: c663e5f56737 ("gpio: support native single-ended hardware drivers")
Cc: stable@vger.kernel.org
Reported-by: Kent Gibson <warthog618@gmail.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
[Bartosz: backported to v5.3, v4.19]
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/gpio/gpiolib.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index e4203c1eb869..74a77001b1bd 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2775,8 +2775,10 @@ int gpiod_direction_output(struct gpio_desc *desc, int value)
 		if (!ret)
 			goto set_output_value;
 		/* Emulate open drain by not actively driving the line high */
-		if (value)
-			return gpiod_direction_input(desc);
+		if (value) {
+			ret = gpiod_direction_input(desc);
+			goto set_output_flag;
+		}
 	}
 	else if (test_bit(FLAG_OPEN_SOURCE, &desc->flags)) {
 		ret = gpio_set_config(gc, gpio_chip_hwgpio(desc),
@@ -2784,8 +2786,10 @@ int gpiod_direction_output(struct gpio_desc *desc, int value)
 		if (!ret)
 			goto set_output_value;
 		/* Emulate open source by not actively driving the line low */
-		if (!value)
-			return gpiod_direction_input(desc);
+		if (!value) {
+			ret = gpiod_direction_input(desc);
+			goto set_output_flag;
+		}
 	} else {
 		gpio_set_config(gc, gpio_chip_hwgpio(desc),
 				PIN_CONFIG_DRIVE_PUSH_PULL);
@@ -2793,6 +2797,17 @@ int gpiod_direction_output(struct gpio_desc *desc, int value)
 
 set_output_value:
 	return gpiod_direction_output_raw_commit(desc, value);
+
+set_output_flag:
+	/*
+	 * When emulating open-source or open-drain functionalities by not
+	 * actively driving the line (setting mode to input) we still need to
+	 * set the IS_OUT flag or otherwise we won't be able to set the line
+	 * value anymore.
+	 */
+	if (ret == 0)
+		set_bit(FLAG_IS_OUT, &desc->flags);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(gpiod_direction_output);
 
@@ -3153,8 +3168,6 @@ static void gpio_set_open_drain_value_commit(struct gpio_desc *desc, bool value)
 
 	if (value) {
 		err = chip->direction_input(chip, offset);
-		if (!err)
-			clear_bit(FLAG_IS_OUT, &desc->flags);
 	} else {
 		err = chip->direction_output(chip, offset, 0);
 		if (!err)
@@ -3184,8 +3197,6 @@ static void gpio_set_open_source_value_commit(struct gpio_desc *desc, bool value
 			set_bit(FLAG_IS_OUT, &desc->flags);
 	} else {
 		err = chip->direction_input(chip, offset);
-		if (!err)
-			clear_bit(FLAG_IS_OUT, &desc->flags);
 	}
 	trace_gpio_direction(desc_to_gpio(desc), !value, err);
 	if (err < 0)
-- 
2.23.0

