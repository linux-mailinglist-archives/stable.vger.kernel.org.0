Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF401AF09A
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 16:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbgDROut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 10:50:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728461AbgDROm4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 10:42:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EB0622251;
        Sat, 18 Apr 2020 14:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587220975;
        bh=3jyXQNdliyg0/srm3l5j7/EEi4rqjhuFR4BLL/s0Di0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G1ZihzvpQqAKeQ0inl8O+1r3f8im8vaoq6TDavwBfOtDYMhlxTWxxDO2RoAIjk5yY
         Obu9kWvhqrqfy0djYNIPrGx4MN2OWpVsVQ/NrP3Tap2zkgOC/oZxFL7cPj3pmMOYAR
         /IC2MpyW30b0tvOZP039s0oraotkWSOgveev8EPs=
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
Subject: [PATCH AUTOSEL 4.19 21/47] pwm: pca9685: Fix PWM/GPIO inter-operation
Date:   Sat, 18 Apr 2020 10:42:01 -0400
Message-Id: <20200418144227.9802-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418144227.9802-1-sashal@kernel.org>
References: <20200418144227.9802-1-sashal@kernel.org>
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
index e1e5dfcb16f36..259fd58812aed 100644
--- a/drivers/pwm/pwm-pca9685.c
+++ b/drivers/pwm/pwm-pca9685.c
@@ -31,6 +31,7 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/pm_runtime.h>
+#include <linux/bitmap.h>
 
 /*
  * Because the PCA9685 has only one prescaler per chip, changing the period of
@@ -85,6 +86,7 @@ struct pca9685 {
 #if IS_ENABLED(CONFIG_GPIOLIB)
 	struct mutex lock;
 	struct gpio_chip gpio;
+	DECLARE_BITMAP(pwms_inuse, PCA9685_MAXCHAN + 1);
 #endif
 };
 
@@ -94,51 +96,51 @@ static inline struct pca9685 *to_pca(struct pwm_chip *chip)
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
@@ -173,6 +175,7 @@ static void pca9685_pwm_gpio_free(struct gpio_chip *gpio, unsigned int offset)
 
 	pca9685_pwm_gpio_set(gpio, offset, 0);
 	pm_runtime_put(pca->chip.dev);
+	pca9685_pwm_clear_inuse(pca, offset);
 }
 
 static int pca9685_pwm_gpio_get_direction(struct gpio_chip *chip,
@@ -224,12 +227,17 @@ static int pca9685_pwm_gpio_probe(struct pca9685 *pca)
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
@@ -413,7 +421,7 @@ static int pca9685_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct pca9685 *pca = to_pca(chip);
 
-	if (pca9685_pwm_is_gpio(pca, pwm))
+	if (pca9685_pwm_test_and_set_inuse(pca, pwm->hwpwm))
 		return -EBUSY;
 	pm_runtime_get_sync(chip->dev);
 
@@ -422,8 +430,11 @@ static int pca9685_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
 
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

