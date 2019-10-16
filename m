Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09BEFD9EF8
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390539AbfJPWD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:03:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:53764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438436AbfJPV7P (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:59:15 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BFBB20872;
        Wed, 16 Oct 2019 21:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263154;
        bh=Sk6PmnLgdm6ngqX6fYigEPSb3szExWuwzAEc9WD5sPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nrx+Qp1Ty7LFy/LvcsY1WMF/M9dp0G5F3zj+tK7sWeAfZ++l0YAGfXyGCrIftrz6d
         Y1DfBYW8YUk8maDB+MbRf7wOzvvMJCeSw7UToHOcC8KhRhah37FF7nGttdekV6MGu9
         NEuWL4fFWxiNtkDJPeuuTNZV4Wxl5EVtg8CPWB3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kent Gibson <warthog618@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 082/112] gpiolib: dont clear FLAG_IS_OUT when emulating open-drain/open-source
Date:   Wed, 16 Oct 2019 14:51:14 -0700
Message-Id: <20191016214904.700115170@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
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
[Bartosz: backported to v5.3, v4.19]
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2775,8 +2775,10 @@ int gpiod_direction_output(struct gpio_d
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
@@ -2784,8 +2786,10 @@ int gpiod_direction_output(struct gpio_d
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
@@ -2793,6 +2797,17 @@ int gpiod_direction_output(struct gpio_d
 
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
 
@@ -3153,8 +3168,6 @@ static void gpio_set_open_drain_value_co
 
 	if (value) {
 		err = chip->direction_input(chip, offset);
-		if (!err)
-			clear_bit(FLAG_IS_OUT, &desc->flags);
 	} else {
 		err = chip->direction_output(chip, offset, 0);
 		if (!err)
@@ -3184,8 +3197,6 @@ static void gpio_set_open_source_value_c
 			set_bit(FLAG_IS_OUT, &desc->flags);
 	} else {
 		err = chip->direction_input(chip, offset);
-		if (!err)
-			clear_bit(FLAG_IS_OUT, &desc->flags);
 	}
 	trace_gpio_direction(desc_to_gpio(desc), !value, err);
 	if (err < 0)


