Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 449E6D66E2
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 18:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387778AbfJNQKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 12:10:31 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38663 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731999AbfJNQKb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 12:10:31 -0400
Received: by mail-wm1-f68.google.com with SMTP id 3so17328805wmi.3
        for <stable@vger.kernel.org>; Mon, 14 Oct 2019 09:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fdHT8ivUwY4K/O7PUXhsjrPh/KxNdPrKz/rCnEthp2g=;
        b=oB/o2n+sTLQb0mMT+TNUEFarogNB9IVzXN+2eOk7fQ+XH2wl3FQN7tDFmZHcZaKQDU
         5Z9Q98L6a/ILIPaLPEEkEQ0tZj/RGM+OckMK1JpetjW/MCQCiEkz+gCP4NnAzJ1IStQK
         gYIAMkpYjDFdeTKE18Y8Slw8pF4LNChHOnAIkx1PrLbsusZUUHh2WrZbgI9Tb2ilH8ZF
         VXrV8d4zVKhhi+pjxTUorG2aiAMcFlaf70P3kAkB2+Qqs2dVydw8zLgX1Gt1g7tjnB2b
         j4vsFzJ6JNVkuFC8MLafwDh4WCxbJmOKL1rHGBzN45bSb6oUG3RfAsuWcUAzDXwIyndH
         i3Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fdHT8ivUwY4K/O7PUXhsjrPh/KxNdPrKz/rCnEthp2g=;
        b=MEj/IZApG7F3ueQRLSUQQ3/9EwnHO33x9Ko/YoTuHUZCw7ebbL+o1364H7pj9h1WYX
         wbCTJtHJCtBl1PWp8zLnDk8ZywpwHvhqV9cLFBeYBl0IViLcvFDfcUHX6gnyRMhTax85
         vBsVi9JnHCq79QVXS179IyqjWb/syZLpUDGMp7RUM9IvhVaTjqgBViVPEIHJOU64DBP8
         aclvEhzsKFp0VMVS68DRba2dWsZGnE4Cbmi6JZV6TL1gMWbnreeud1MbxZR+NAcAGfml
         PDj8sah9Hd3HF98/rzG/zdk6Gr0LQ1Kv1tRBROwPumHPWPkjy/o8v3pAbtZGEu2Aw3b6
         a9GA==
X-Gm-Message-State: APjAAAXoYwRqTPSPDqjs9BgmKHYwBvqRDISpowvJwX+WQi1Br/lhHRmH
        PU2Id1ehuceFVsnhiC2VpEi0Og==
X-Google-Smtp-Source: APXvYqzkDoe8bdRO8MAfjPHLrQcgvTAYzar3eF+de15mMhjyRU45QBNIhXHM2/KZneCpcXX3deYGpA==
X-Received: by 2002:a7b:cc99:: with SMTP id p25mr15161976wma.43.1571069427733;
        Mon, 14 Oct 2019 09:10:27 -0700 (PDT)
Received: from localhost.localdomain ([2a01:cb1d:af:5b00:6d6c:8493:1ab5:dad7])
        by smtp.gmail.com with ESMTPSA id z13sm16658694wrq.51.2019.10.14.09.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 09:10:27 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-gpio@vger.kernel.org, stable@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Kent Gibson <warthog618@gmail.com>
Subject: [PATCH v4.14] gpiolib: don't clear FLAG_IS_OUT when emulating open-drain/open-source
Date:   Mon, 14 Oct 2019 18:10:24 +0200
Message-Id: <20191014161024.17152-1-brgl@bgdev.pl>
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
[Bartosz: backported to v4.14]
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/gpio/gpiolib.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index f1809a54fcee..c7f5f0be2d74 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2329,8 +2329,10 @@ static int _gpiod_direction_output_raw(struct gpio_desc *desc, int value)
 		if (!ret)
 			goto set_output_value;
 		/* Emulate open drain by not actively driving the line high */
-		if (val)
-			return gpiod_direction_input(desc);
+		if (val) {
+			ret = gpiod_direction_input(desc);
+			goto set_output_flag;
+		}
 	}
 	else if (test_bit(FLAG_OPEN_SOURCE, &desc->flags)) {
 		ret = gpio_set_drive_single_ended(gc, gpio_chip_hwgpio(desc),
@@ -2338,8 +2340,10 @@ static int _gpiod_direction_output_raw(struct gpio_desc *desc, int value)
 		if (!ret)
 			goto set_output_value;
 		/* Emulate open source by not actively driving the line low */
-		if (!val)
-			return gpiod_direction_input(desc);
+		if (!val) {
+			ret = gpiod_direction_input(desc);
+			goto set_output_flag;
+		}
 	} else {
 		gpio_set_drive_single_ended(gc, gpio_chip_hwgpio(desc),
 					    PIN_CONFIG_DRIVE_PUSH_PULL);
@@ -2359,6 +2363,17 @@ static int _gpiod_direction_output_raw(struct gpio_desc *desc, int value)
 	trace_gpio_value(desc_to_gpio(desc), 0, val);
 	trace_gpio_direction(desc_to_gpio(desc), 0, ret);
 	return ret;
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
 
 /**
@@ -2540,8 +2555,6 @@ static void _gpio_set_open_drain_value(struct gpio_desc *desc, bool value)
 
 	if (value) {
 		err = chip->direction_input(chip, offset);
-		if (!err)
-			clear_bit(FLAG_IS_OUT, &desc->flags);
 	} else {
 		err = chip->direction_output(chip, offset, 0);
 		if (!err)
@@ -2571,8 +2584,6 @@ static void _gpio_set_open_source_value(struct gpio_desc *desc, bool value)
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

