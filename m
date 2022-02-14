Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B17DA4B4B32
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344669AbiBNKHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:07:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344355AbiBNKEn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:04:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70564A3ED;
        Mon, 14 Feb 2022 01:49:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C848B80DC8;
        Mon, 14 Feb 2022 09:49:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B81FC340E9;
        Mon, 14 Feb 2022 09:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832149;
        bh=RGZA6G40eAW3uX2cR5Zais31mABtdKrTd4GgeiCbSUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nA3V7YoNpFStkhoZKUIJjjbSImyeJmMGCePRFwxkLn5EUWZ+7Rd7lGeKu7C8Bns5A
         KOSPGkh3LAwGZEG5HQWUHcOInReePdZJwGBEfU11yweab2lkhYJO43CK/4NPxhW88Q
         3s5hjQXelUR/lHI8Vj9wpD+/85zuih3rizNvl6fc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Mikko=20Salom=C3=A4ki?= <ms@datarespons.se>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 093/172] gpio: aggregator: Fix calling into sleeping GPIO controllers
Date:   Mon, 14 Feb 2022 10:25:51 +0100
Message-Id: <20220214092509.617063943@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 2cba05451a6d0c703bb74f1a250691404f27c4f1 ]

If the parent GPIO controller is a sleeping controller (e.g. a GPIO
controller connected to I2C), getting or setting a GPIO triggers a
might_sleep() warning.  This happens because the GPIO Aggregator takes
the can_sleep flag into account only for its internal locking, not for
calling into the parent GPIO controller.

Fix this by using the gpiod_[gs]et*_cansleep() APIs when calling into a
sleeping GPIO controller.

Reported-by: Mikko Salomäki <ms@datarespons.se>
Fixes: 828546e24280f721 ("gpio: Add GPIO Aggregator")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-aggregator.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-aggregator.c b/drivers/gpio/gpio-aggregator.c
index 34e35b64dcdc0..23047dc84ef1b 100644
--- a/drivers/gpio/gpio-aggregator.c
+++ b/drivers/gpio/gpio-aggregator.c
@@ -273,7 +273,8 @@ static int gpio_fwd_get(struct gpio_chip *chip, unsigned int offset)
 {
 	struct gpiochip_fwd *fwd = gpiochip_get_data(chip);
 
-	return gpiod_get_value(fwd->descs[offset]);
+	return chip->can_sleep ? gpiod_get_value_cansleep(fwd->descs[offset])
+			       : gpiod_get_value(fwd->descs[offset]);
 }
 
 static int gpio_fwd_get_multiple(struct gpiochip_fwd *fwd, unsigned long *mask,
@@ -292,7 +293,10 @@ static int gpio_fwd_get_multiple(struct gpiochip_fwd *fwd, unsigned long *mask,
 	for_each_set_bit(i, mask, fwd->chip.ngpio)
 		descs[j++] = fwd->descs[i];
 
-	error = gpiod_get_array_value(j, descs, NULL, values);
+	if (fwd->chip.can_sleep)
+		error = gpiod_get_array_value_cansleep(j, descs, NULL, values);
+	else
+		error = gpiod_get_array_value(j, descs, NULL, values);
 	if (error)
 		return error;
 
@@ -327,7 +331,10 @@ static void gpio_fwd_set(struct gpio_chip *chip, unsigned int offset, int value)
 {
 	struct gpiochip_fwd *fwd = gpiochip_get_data(chip);
 
-	gpiod_set_value(fwd->descs[offset], value);
+	if (chip->can_sleep)
+		gpiod_set_value_cansleep(fwd->descs[offset], value);
+	else
+		gpiod_set_value(fwd->descs[offset], value);
 }
 
 static void gpio_fwd_set_multiple(struct gpiochip_fwd *fwd, unsigned long *mask,
@@ -346,7 +353,10 @@ static void gpio_fwd_set_multiple(struct gpiochip_fwd *fwd, unsigned long *mask,
 		descs[j++] = fwd->descs[i];
 	}
 
-	gpiod_set_array_value(j, descs, NULL, values);
+	if (fwd->chip.can_sleep)
+		gpiod_set_array_value_cansleep(j, descs, NULL, values);
+	else
+		gpiod_set_array_value(j, descs, NULL, values);
 }
 
 static void gpio_fwd_set_multiple_locked(struct gpio_chip *chip,
-- 
2.34.1



