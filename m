Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA80431E4B
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234200AbhJRN75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:59:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234322AbhJRN54 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:57:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9411061A3F;
        Mon, 18 Oct 2021 13:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564471;
        bh=eHYOWKrClaFyIu88IKMatWBTTPoSX2145ljr+K/yZ+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qivfKoQhqoFNUjD2YZwO5lG4xp6vMoBwuRu2k3fnRqFSOO2k/LPYRZFjFR2DsECtg
         uhbZTleNeO0EOwOyKP3VlM9cCjql070GFJuIM0DV+fFguGsXlK+D0FPAyQ8JjKBM1I
         DSsGtIZudgKMmeznYUvHIdoyi3YmI+dQtInSDVZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: [PATCH 5.14 100/151] gpio: pca953x: Improve bias setting
Date:   Mon, 18 Oct 2021 15:24:39 +0200
Message-Id: <20211018132343.925150241@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 55a9968c7e139209a9e93d4ca4321731bea5fc95 upstream.

The commit 15add06841a3 ("gpio: pca953x: add ->set_config implementation")
introduced support for bias setting. However this, due to being half-baked,
brought potential issues:
 - the turning bias via disabling makes the pin floating for a while;
 - once enabled, bias can't be disabled.

Fix all these by adding support for bias disabling and move the disabling
part under the corresponding conditional.

While at it, add support for default setting, since it's cheap to add.

Fixes: 15add06841a3 ("gpio: pca953x: add ->set_config implementation")
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-pca953x.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -559,21 +559,21 @@ static int pca953x_gpio_set_pull_up_down
 
 	mutex_lock(&chip->i2c_lock);
 
-	/* Disable pull-up/pull-down */
-	ret = regmap_write_bits(chip->regmap, pull_en_reg, bit, 0);
-	if (ret)
-		goto exit;
-
 	/* Configure pull-up/pull-down */
 	if (config == PIN_CONFIG_BIAS_PULL_UP)
 		ret = regmap_write_bits(chip->regmap, pull_sel_reg, bit, bit);
 	else if (config == PIN_CONFIG_BIAS_PULL_DOWN)
 		ret = regmap_write_bits(chip->regmap, pull_sel_reg, bit, 0);
+	else
+		ret = 0;
 	if (ret)
 		goto exit;
 
-	/* Enable pull-up/pull-down */
-	ret = regmap_write_bits(chip->regmap, pull_en_reg, bit, bit);
+	/* Disable/Enable pull-up/pull-down */
+	if (config == PIN_CONFIG_BIAS_DISABLE)
+		ret = regmap_write_bits(chip->regmap, pull_en_reg, bit, 0);
+	else
+		ret = regmap_write_bits(chip->regmap, pull_en_reg, bit, bit);
 
 exit:
 	mutex_unlock(&chip->i2c_lock);
@@ -587,7 +587,9 @@ static int pca953x_gpio_set_config(struc
 
 	switch (pinconf_to_config_param(config)) {
 	case PIN_CONFIG_BIAS_PULL_UP:
+	case PIN_CONFIG_BIAS_PULL_PIN_DEFAULT:
 	case PIN_CONFIG_BIAS_PULL_DOWN:
+	case PIN_CONFIG_BIAS_DISABLE:
 		return pca953x_gpio_set_pull_up_down(chip, offset, config);
 	default:
 		return -ENOTSUPP;


