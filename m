Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD5DD9E16
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 23:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406637AbfJPV4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:56:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406635AbfJPV4W (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:56:22 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18FEB21D7A;
        Wed, 16 Oct 2019 21:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262982;
        bh=xo/L09ZgP4LeDy+q31yqN9pOD3i7IOOqUXmleRUTRks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sdXVbma/v6UuFpF4hjnCfFEWHPB+8wW2amKvzLeAvELiA3TZCj96Dpy5DC9R6Egqm
         oUc9khurzj0jo4at9dfmZgd5iaoL9kaWtRCW6GmmUJalO8PRy0qn7D91Mm8z6Fl14q
         v3QM/tY83WvZb7Sn9TJQgAqnWne3Pgwh1Pu5fFeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kent Gibson <warthog618@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 51/65] gpiolib: dont clear FLAG_IS_OUT when emulating open-drain/open-source
Date:   Wed, 16 Oct 2019 14:51:05 -0700
Message-Id: <20191016214836.824184063@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214756.457746573@linuxfoundation.org>
References: <20191016214756.457746573@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

[ Upstream commit e735244e2cf068f98b6384681a38993e0517a838 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index f1809a54fceeb..c7f5f0be2d749 100644
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
2.20.1



