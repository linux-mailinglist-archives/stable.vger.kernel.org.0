Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E433C3765
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbhGJXwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:52:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231766AbhGJXv6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:51:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CE386135C;
        Sat, 10 Jul 2021 23:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625960952;
        bh=Jxp4XfILcSlnmavtHA8DR7HbSTaJRkfBAiSUv4lxPXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g40oPjYVk+Rd74vGaO2FA3E1nCqKl+gfl0HvfIMARm4ktsVjulckljUPufqNvHKWA
         u+ssa+JQ6Z0PbEhUmFKGN/dlFXJgnsU7YBHm3Kwv6Cl1i384tf+0XnOWeG3svKDhmm
         2uV/h2bmRr/khpy2JokgOzsHWKRMR/X/3oFBgaIbk7K6/ArPmBP0vSXnbGJHAEcvj6
         ao0VGCRoVALz3Kiu8PxRrMukDTtqbaF9Mcy0Ukq1lkbXlBXzRPtt5GHe/iwpKuvfsk
         nJg7+jWfaAZDXCgNGSpouHI33OHAKrRZxN9gufDMZDahkSLf1HKxghey+95OgDjJJ/
         P2zCazE0Z5YfA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Clemens Gruber <clemens.gruber@pqgruber.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pwm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 10/53] pwm: pca9685: Restrict period change for enabled PWMs
Date:   Sat, 10 Jul 2021 19:48:14 -0400
Message-Id: <20210710234857.3220040-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710234857.3220040-1-sashal@kernel.org>
References: <20210710234857.3220040-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Clemens Gruber <clemens.gruber@pqgruber.com>

[ Upstream commit 6d6e7050276d40b5de97aa950d5d71057f2e2a25 ]

Previously, the last used PWM channel could change the global prescale
setting, even if other channels are already in use.

Fix it by only allowing the first enabled PWM to change the global
chip-wide prescale setting. If there is more than one channel in use,
the prescale settings resulting from the chosen periods must match.

GPIOs do not count as enabled PWMs as they are not using the prescaler
and can't change it.

Signed-off-by: Clemens Gruber <clemens.gruber@pqgruber.com>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-pca9685.c | 74 +++++++++++++++++++++++++++++++++------
 1 file changed, 64 insertions(+), 10 deletions(-)

diff --git a/drivers/pwm/pwm-pca9685.c b/drivers/pwm/pwm-pca9685.c
index 7c9f174de64e..ec9f93006654 100644
--- a/drivers/pwm/pwm-pca9685.c
+++ b/drivers/pwm/pwm-pca9685.c
@@ -23,11 +23,11 @@
 #include <linux/bitmap.h>
 
 /*
- * Because the PCA9685 has only one prescaler per chip, changing the period of
- * one channel affects the period of all 16 PWM outputs!
- * However, the ratio between each configured duty cycle and the chip-wide
- * period remains constant, because the OFF time is set in proportion to the
- * counter range.
+ * Because the PCA9685 has only one prescaler per chip, only the first channel
+ * that is enabled is allowed to change the prescale register.
+ * PWM channels requested afterwards must use a period that results in the same
+ * prescale setting as the one set by the first requested channel.
+ * GPIOs do not count as enabled PWMs as they are not using the prescaler.
  */
 
 #define PCA9685_MODE1		0x00
@@ -78,8 +78,9 @@
 struct pca9685 {
 	struct pwm_chip chip;
 	struct regmap *regmap;
-#if IS_ENABLED(CONFIG_GPIOLIB)
 	struct mutex lock;
+	DECLARE_BITMAP(pwms_enabled, PCA9685_MAXCHAN + 1);
+#if IS_ENABLED(CONFIG_GPIOLIB)
 	struct gpio_chip gpio;
 	DECLARE_BITMAP(pwms_inuse, PCA9685_MAXCHAN + 1);
 #endif
@@ -90,6 +91,22 @@ static inline struct pca9685 *to_pca(struct pwm_chip *chip)
 	return container_of(chip, struct pca9685, chip);
 }
 
+/* This function is supposed to be called with the lock mutex held */
+static bool pca9685_prescaler_can_change(struct pca9685 *pca, int channel)
+{
+	/* No PWM enabled: Change allowed */
+	if (bitmap_empty(pca->pwms_enabled, PCA9685_MAXCHAN + 1))
+		return true;
+	/* More than one PWM enabled: Change not allowed */
+	if (bitmap_weight(pca->pwms_enabled, PCA9685_MAXCHAN + 1) > 1)
+		return false;
+	/*
+	 * Only one PWM enabled: Change allowed if the PWM about to
+	 * be changed is the one that is already enabled
+	 */
+	return test_bit(channel, pca->pwms_enabled);
+}
+
 /* Helper function to set the duty cycle ratio to duty/4096 (e.g. duty=2048 -> 50%) */
 static void pca9685_pwm_set_duty(struct pca9685 *pca, int channel, unsigned int duty)
 {
@@ -240,8 +257,6 @@ static int pca9685_pwm_gpio_probe(struct pca9685 *pca)
 {
 	struct device *dev = pca->chip.dev;
 
-	mutex_init(&pca->lock);
-
 	pca->gpio.label = dev_name(dev);
 	pca->gpio.parent = dev;
 	pca->gpio.request = pca9685_pwm_gpio_request;
@@ -285,8 +300,8 @@ static void pca9685_set_sleep_mode(struct pca9685 *pca, bool enable)
 	}
 }
 
-static int pca9685_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
-			     const struct pwm_state *state)
+static int __pca9685_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
+			       const struct pwm_state *state)
 {
 	struct pca9685 *pca = to_pca(chip);
 	unsigned long long duty, prescale;
@@ -309,6 +324,12 @@ static int pca9685_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	regmap_read(pca->regmap, PCA9685_PRESCALE, &val);
 	if (prescale != val) {
+		if (!pca9685_prescaler_can_change(pca, pwm->hwpwm)) {
+			dev_err(chip->dev,
+				"pwm not changed: periods of enabled pwms must match!\n");
+			return -EBUSY;
+		}
+
 		/*
 		 * Putting the chip briefly into SLEEP mode
 		 * at this point won't interfere with the
@@ -331,6 +352,25 @@ static int pca9685_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	return 0;
 }
 
+static int pca9685_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
+			     const struct pwm_state *state)
+{
+	struct pca9685 *pca = to_pca(chip);
+	int ret;
+
+	mutex_lock(&pca->lock);
+	ret = __pca9685_pwm_apply(chip, pwm, state);
+	if (ret == 0) {
+		if (state->enabled)
+			set_bit(pwm->hwpwm, pca->pwms_enabled);
+		else
+			clear_bit(pwm->hwpwm, pca->pwms_enabled);
+	}
+	mutex_unlock(&pca->lock);
+
+	return ret;
+}
+
 static void pca9685_pwm_get_state(struct pwm_chip *chip, struct pwm_device *pwm,
 				  struct pwm_state *state)
 {
@@ -372,6 +412,14 @@ static int pca9685_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
 
 	if (pca9685_pwm_test_and_set_inuse(pca, pwm->hwpwm))
 		return -EBUSY;
+
+	if (pwm->hwpwm < PCA9685_MAXCHAN) {
+		/* PWMs - except the "all LEDs" channel - default to enabled */
+		mutex_lock(&pca->lock);
+		set_bit(pwm->hwpwm, pca->pwms_enabled);
+		mutex_unlock(&pca->lock);
+	}
+
 	pm_runtime_get_sync(chip->dev);
 
 	return 0;
@@ -381,7 +429,11 @@ static void pca9685_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct pca9685 *pca = to_pca(chip);
 
+	mutex_lock(&pca->lock);
 	pca9685_pwm_set_duty(pca, pwm->hwpwm, 0);
+	clear_bit(pwm->hwpwm, pca->pwms_enabled);
+	mutex_unlock(&pca->lock);
+
 	pm_runtime_put(chip->dev);
 	pca9685_pwm_clear_inuse(pca, pwm->hwpwm);
 }
@@ -422,6 +474,8 @@ static int pca9685_pwm_probe(struct i2c_client *client,
 
 	i2c_set_clientdata(client, pca);
 
+	mutex_init(&pca->lock);
+
 	regmap_read(pca->regmap, PCA9685_MODE2, &reg);
 
 	if (device_property_read_bool(&client->dev, "invert"))
-- 
2.30.2

