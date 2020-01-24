Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2914A147E76
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389369AbgAXKJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:09:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:46190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730613AbgAXKJR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:09:17 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7334621734;
        Fri, 24 Jan 2020 10:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579860557;
        bh=nyUG4Wx3Jh4rCfYBfl4XE2bnxiFixVKIL6DlJgHOFT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vVLlQGjQzreedwKSuFpN2a71HB/l4gFD/RD1VMZexoqal8TD8jkRVIFZDy66EYphn
         UBDdNwOpqBeuW8eK85oeqpLrowW8nZydUAjIW4+sC9G11gg/DjDFyCTivLKyLeUpU2
         sg8IkyP3USFxKZdgHY8Nuh1+BI0cM5mti8f0HZ9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jean-Jacques Hiblot <jjhiblot@ti.com>,
        Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 4.19 014/639] leds: tlc591xx: update the maximum brightness
Date:   Fri, 24 Jan 2020 10:23:04 +0100
Message-Id: <20200124093048.912391801@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean-Jacques Hiblot <jjhiblot@ti.com>

commit a2cafdfd8cf5ad8adda6c0ce44a59f46431edf02 upstream.

The TLC chips actually offer 257 levels:
- 0: led OFF
- 1-255: Led dimmed is using a PWM. The duty cycle range from 0.4% to 99.6%
- 256: led fully ON

Fixes: e370d010a5fe ("leds: tlc591xx: Driver for the TI 8/16 Channel i2c LED driver")
Signed-off-by: Jean-Jacques Hiblot <jjhiblot@ti.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/leds/leds-tlc591xx.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/leds/leds-tlc591xx.c
+++ b/drivers/leds/leds-tlc591xx.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 
 #define TLC591XX_MAX_LEDS	16
+#define TLC591XX_MAX_BRIGHTNESS	256
 
 #define TLC591XX_REG_MODE1	0x00
 #define MODE1_RESPON_ADDR_MASK	0xF0
@@ -115,11 +116,11 @@ tlc591xx_brightness_set(struct led_class
 	struct tlc591xx_priv *priv = led->priv;
 	int err;
 
-	switch (brightness) {
+	switch ((int)brightness) {
 	case 0:
 		err = tlc591xx_set_ledout(priv, led, LEDOUT_OFF);
 		break;
-	case LED_FULL:
+	case TLC591XX_MAX_BRIGHTNESS:
 		err = tlc591xx_set_ledout(priv, led, LEDOUT_ON);
 		break;
 	default:
@@ -160,7 +161,7 @@ tlc591xx_configure(struct device *dev,
 		led->priv = priv;
 		led->led_no = i;
 		led->ldev.brightness_set_blocking = tlc591xx_brightness_set;
-		led->ldev.max_brightness = LED_FULL;
+		led->ldev.max_brightness = TLC591XX_MAX_BRIGHTNESS;
 		err = led_classdev_register(dev, &led->ldev);
 		if (err < 0) {
 			dev_err(dev, "couldn't register LED %s\n",


