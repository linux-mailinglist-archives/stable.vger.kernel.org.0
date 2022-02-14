Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 718F54B4AA1
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347804AbiBNKdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:33:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347805AbiBNKcu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:32:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2432BCD;
        Mon, 14 Feb 2022 02:00:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BEAC60B3A;
        Mon, 14 Feb 2022 10:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679EFC340EF;
        Mon, 14 Feb 2022 10:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832825;
        bh=Km2YhEkEz2xOCSXKSI50CX7nkOUZDmi2vmFH2ra+6Pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QCKChNz5PL9AKqy9LmJ1I7sBZCrk9WmnOpRl7Rptm4b2Yrkki0T0t+2lG9REGcMdj
         SYGlVDBKEBXE++I5/HjPNC4VrBq4ig9aN0KteFIgfYJtUHamDE+ih0eylKLHiuUqcO
         EInpSyGxzwoWhJ8vHKwu4qMyZCJJFWdQF7MOLT7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Mikko=20Salom=C3=A4ki?= <ms@datarespons.se>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 109/203] gpio: aggregator: Fix calling into sleeping GPIO controllers
Date:   Mon, 14 Feb 2022 10:25:53 +0100
Message-Id: <20220214092513.947410133@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
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
index e9671d1660ef4..ac20f9bd1be61 100644
--- a/drivers/gpio/gpio-aggregator.c
+++ b/drivers/gpio/gpio-aggregator.c
@@ -278,7 +278,8 @@ static int gpio_fwd_get(struct gpio_chip *chip, unsigned int offset)
 {
 	struct gpiochip_fwd *fwd = gpiochip_get_data(chip);
 
-	return gpiod_get_value(fwd->descs[offset]);
+	return chip->can_sleep ? gpiod_get_value_cansleep(fwd->descs[offset])
+			       : gpiod_get_value(fwd->descs[offset]);
 }
 
 static int gpio_fwd_get_multiple(struct gpiochip_fwd *fwd, unsigned long *mask,
@@ -293,7 +294,10 @@ static int gpio_fwd_get_multiple(struct gpiochip_fwd *fwd, unsigned long *mask,
 	for_each_set_bit(i, mask, fwd->chip.ngpio)
 		descs[j++] = fwd->descs[i];
 
-	error = gpiod_get_array_value(j, descs, NULL, values);
+	if (fwd->chip.can_sleep)
+		error = gpiod_get_array_value_cansleep(j, descs, NULL, values);
+	else
+		error = gpiod_get_array_value(j, descs, NULL, values);
 	if (error)
 		return error;
 
@@ -328,7 +332,10 @@ static void gpio_fwd_set(struct gpio_chip *chip, unsigned int offset, int value)
 {
 	struct gpiochip_fwd *fwd = gpiochip_get_data(chip);
 
-	gpiod_set_value(fwd->descs[offset], value);
+	if (chip->can_sleep)
+		gpiod_set_value_cansleep(fwd->descs[offset], value);
+	else
+		gpiod_set_value(fwd->descs[offset], value);
 }
 
 static void gpio_fwd_set_multiple(struct gpiochip_fwd *fwd, unsigned long *mask,
@@ -343,7 +350,10 @@ static void gpio_fwd_set_multiple(struct gpiochip_fwd *fwd, unsigned long *mask,
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



