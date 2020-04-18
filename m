Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 234281AED67
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 15:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgDRNvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 09:51:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726701AbgDRNtF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 09:49:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 587B62054F;
        Sat, 18 Apr 2020 13:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587217744;
        bh=TFFg3LbECDGuRvcOFMP9lajUE38r4GIFQSFV6ldiKTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nXb/9yYtn4hRgwKnXdlfB0W52JV1mixk5lGKr2TdnMLtQrELsX/7yhd6gyprzuWuG
         Olr5smq1eYDcZT/10gN1YEZf56xiQzzFX/UUKOvU8sd185psDG6QgDPbmBXZA9sXTe
         BfzCQzzzRDsWZHs7ns9ug+xBP9sNsqh2R0IdhHgk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Van Asbroeck <TheSven73@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Clemens Gruber <clemens.gruber@pqgruber.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pwm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 38/73] pwm: pca9685: Fix PWM/GPIO inter-operation
Date:   Sat, 18 Apr 2020 09:47:40 -0400
Message-Id: <20200418134815.6519-38-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418134815.6519-1-sashal@kernel.org>
References: <20200418134815.6519-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Van Asbroeck <TheSven73@gmail.com>

[ Upstream commit 9cc5f232a4b6a0ef6e9b57876d61b88f61bdd7c2 ]

This driver allows pwms to be requested as gpios via gpiolib. Obviously,
it should not be allowed to request a GPIO when its corresponding PWM is
already requested (and vice versa). So it requires some exclusion code.

Given that the PWMm and GPIO cores are not synchronized with respect to
each other, this exclusion code will also require proper
synchronization.

Such a mechanism was in place, but was inadvertently removed by Uwe's
clean-up in commit e926b12c611c ("pwm: Clear chip_data in pwm_put()").

Upon revisiting the synchronization mechanism, we found that
theoretically, it could allow two threads to successfully request
conflicting PWMs/GPIOs.

Replace with a bitmap which tracks PWMs in-use, plus a mutex. As long as
PWM and GPIO's respective request/free functions modify the in-use
bitmap while holding the mutex, proper synchronization will be
guaranteed.

Reported-by: YueHaibing <yuehaibing@huawei.com>
Fixes: e926b12c611c ("pwm: Clear chip_data in pwm_put()")
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: YueHaibing <yuehaibing@huawei.com>
Link: https://lkml.org/lkml/2019/5/31/963
Signed-off-by: Sven Van Asbroeck <TheSven73@gmail.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
[cg: Tested on an i.MX6Q board with two NXP PCA9685 chips]
Tested-by: Clemens Gruber <clemens.gruber@pqgruber.com>
Reviewed-by: Sven Van Asbroeck <TheSven73@gmail.com> # cg's rebase
Link: https://lore.kernel.org/lkml/20200330160238.GD2817345@ulmo/
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-pca9685.c | 85 ++++++++++++++++++++++-----------------
 1 file changed, 48 insertions(+), 37 deletions(-)

diff --git a/drivers/pwm/pwm-pca9685.c b/drivers/pwm/pwm-pca9685.c
index b07bdca3d510d..590375be52147 100644
--- a/drivers/pwm/pwm-pca9685.c
+++ b/drivers/pwm/pwm-pca9685.c
@@ -20,6 +20,7 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/pm_runtime.h>
+#include <linux/bitmap.h>
 
 /*
  * Because the PCA9685 has only one prescaler per chip, changing the period of
@@ -74,6 +75,7 @@ struct pca9685 {
 #if IS_ENABLED(CONFIG_GPIOLIB)
 	struct mutex lock;
 	struct gpio_chip gpio;
+	DECLARE_BITMAP(pwms_inuse, PCA9685_MAXCHAN + 1);
 #endif
 };
 
@@ -83,51 +85,51 @@ static inline struct pca9685 *to_pca(struct pwm_chip *chip)
 }
 
 #if IS_ENABLED(CONFIG_GPIOLIB)
-static int pca9685_pwm_gpio_request(struct gpio_chip *gpio, unsigned int offset)
+static bool pca9685_pwm_test_and_set_inuse(struct pca9685 *pca, int pwm_idx)
 {
-	struct pca9685 *pca = gpiochip_get_data(gpio);
-	struct pwm_device *pwm;
+	bool is_inuse;
 
 	mutex_lock(&pca->lock);
-
-	pwm = &pca->chip.pwms[offset];
-
-	if (pwm->flags & (PWMF_REQUESTED | PWMF_EXPORTED)) {
-		mutex_unlock(&pca->lock);
-		return -EBUSY;
+	if (pwm_idx >= PCA9685_MAXCHAN) {
+		/*
+		 * "all LEDs" channel:
+		 * pretend already in use if any of the PWMs are requested
+		 */
+		if (!bitmap_empty(pca->pwms_inuse, PCA9685_MAXCHAN)) {
+			is_inuse = true;
+			goto out;
+		}
+	} else {
+		/*
+		 * regular channel:
+		 * pretend already in use if the "all LEDs" channel is requested
+		 */
+		if (test_bit(PCA9685_MAXCHAN, pca->pwms_inuse)) {
+			is_inuse = true;
+			goto out;
+		}
 	}
-
-	pwm_set_chip_data(pwm, (void *)1);
-
+	is_inuse = test_and_set_bit(pwm_idx, pca->pwms_inuse);
+out:
 	mutex_unlock(&pca->lock);
-	pm_runtime_get_sync(pca->chip.dev);
-	return 0;
+	return is_inuse;
 }
 
-static bool pca9685_pwm_is_gpio(struct pca9685 *pca, struct pwm_device *pwm)
+static void pca9685_pwm_clear_inuse(struct pca9685 *pca, int pwm_idx)
 {
-	bool is_gpio = false;
-
 	mutex_lock(&pca->lock);
+	clear_bit(pwm_idx, pca->pwms_inuse);
+	mutex_unlock(&pca->lock);
+}
 
-	if (pwm->hwpwm >= PCA9685_MAXCHAN) {
-		unsigned int i;
-
-		/*
-		 * Check if any of the GPIOs are requested and in that case
-		 * prevent using the "all LEDs" channel.
-		 */
-		for (i = 0; i < pca->gpio.ngpio; i++)
-			if (gpiochip_is_requested(&pca->gpio, i)) {
-				is_gpio = true;
-				break;
-			}
-	} else if (pwm_get_chip_data(pwm)) {
-		is_gpio = true;
-	}
+static int pca9685_pwm_gpio_request(struct gpio_chip *gpio, unsigned int offset)
+{
+	struct pca9685 *pca = gpiochip_get_data(gpio);
 
-	mutex_unlock(&pca->lock);
-	return is_gpio;
+	if (pca9685_pwm_test_and_set_inuse(pca, offset))
+		return -EBUSY;
+	pm_runtime_get_sync(pca->chip.dev);
+	return 0;
 }
 
 static int pca9685_pwm_gpio_get(struct gpio_chip *gpio, unsigned int offset)
@@ -162,6 +164,7 @@ static void pca9685_pwm_gpio_free(struct gpio_chip *gpio, unsigned int offset)
 
 	pca9685_pwm_gpio_set(gpio, offset, 0);
 	pm_runtime_put(pca->chip.dev);
+	pca9685_pwm_clear_inuse(pca, offset);
 }
 
 static int pca9685_pwm_gpio_get_direction(struct gpio_chip *chip,
@@ -213,12 +216,17 @@ static int pca9685_pwm_gpio_probe(struct pca9685 *pca)
 	return devm_gpiochip_add_data(dev, &pca->gpio, pca);
 }
 #else
-static inline bool pca9685_pwm_is_gpio(struct pca9685 *pca,
-				       struct pwm_device *pwm)
+static inline bool pca9685_pwm_test_and_set_inuse(struct pca9685 *pca,
+						  int pwm_idx)
 {
 	return false;
 }
 
+static inline void
+pca9685_pwm_clear_inuse(struct pca9685 *pca, int pwm_idx)
+{
+}
+
 static inline int pca9685_pwm_gpio_probe(struct pca9685 *pca)
 {
 	return 0;
@@ -402,7 +410,7 @@ static int pca9685_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct pca9685 *pca = to_pca(chip);
 
-	if (pca9685_pwm_is_gpio(pca, pwm))
+	if (pca9685_pwm_test_and_set_inuse(pca, pwm->hwpwm))
 		return -EBUSY;
 	pm_runtime_get_sync(chip->dev);
 
@@ -411,8 +419,11 @@ static int pca9685_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
 
 static void pca9685_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
 {
+	struct pca9685 *pca = to_pca(chip);
+
 	pca9685_pwm_disable(chip, pwm);
 	pm_runtime_put(chip->dev);
+	pca9685_pwm_clear_inuse(pca, pwm->hwpwm);
 }
 
 static const struct pwm_ops pca9685_pwm_ops = {
-- 
2.20.1

