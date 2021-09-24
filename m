Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4EEE4173B1
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345378AbhIXM7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:59:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345280AbhIXM5w (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:57:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1413261164;
        Fri, 24 Sep 2021 12:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487932;
        bh=lgAjcY1Xveb6/jSqLQ58PJmpaE78qrD1fp6XzgRUo78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dw1GLuXgkQQQa20r50kQgyiQxGQv044MWJGiHF2cqj4Ia1TYuTTJKRo6jRdrJ3hOq
         paINeeFy0YaRXR34PAsQ+kYUF5lS8rhb0b0bffQ8IyNf5NjAvFxAkjPG0JnpKhX9w7
         EI/2ekwOgWDEcSk3bwmMGU2V99GLBh25UkrcIylA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH 5.14 018/100] pwm: ab8500: Fix register offset calculation to not depend on probe order
Date:   Fri, 24 Sep 2021 14:43:27 +0200
Message-Id: <20210924124342.049506808@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit eb41f334589d66b9da6f2b1acf7963ef8ca8d94e upstream.

The assumption that lead to commit 5e5da1e9fbee ("pwm: ab8500:
Explicitly allocate pwm chip base dynamically") was wrong: The
pwm-ab8500 devices are not directly instantiated from device tree, but
from the ab8500 mfd driver. So the pdev->id isn't -1, but a number
between 1 and 3. Now that pwmchip ids are always allocated dynamically,
this cannot easily be reverted.

Introduce a new member in the driver data struct that tracks the
hardware id and use this to calculate the register offset.

Side-note: Using chip->base to calculate the offset was never robust
because if there was already a PWM with id 1 at the time ab8500-pwm.1
was probed, the associated pwmchip would get assigned chip->base = 2 (or
something bigger).

Fixes: 5e5da1e9fbee ("pwm: ab8500: Explicitly allocate pwm chip base dynamically")
Fixes: 6173f8f4ed9c ("pwm: Move AB8500 PWM driver to PWM framework")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-ab8500.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/pwm/pwm-ab8500.c
+++ b/drivers/pwm/pwm-ab8500.c
@@ -22,14 +22,21 @@
 
 struct ab8500_pwm_chip {
 	struct pwm_chip chip;
+	unsigned int hwid;
 };
 
+static struct ab8500_pwm_chip *ab8500_pwm_from_chip(struct pwm_chip *chip)
+{
+	return container_of(chip, struct ab8500_pwm_chip, chip);
+}
+
 static int ab8500_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 			    const struct pwm_state *state)
 {
 	int ret;
 	u8 reg;
 	unsigned int higher_val, lower_val;
+	struct ab8500_pwm_chip *ab8500 = ab8500_pwm_from_chip(chip);
 
 	if (state->polarity != PWM_POLARITY_NORMAL)
 		return -EINVAL;
@@ -37,7 +44,7 @@ static int ab8500_pwm_apply(struct pwm_c
 	if (!state->enabled) {
 		ret = abx500_mask_and_set_register_interruptible(chip->dev,
 					AB8500_MISC, AB8500_PWM_OUT_CTRL7_REG,
-					1 << (chip->base - 1), 0);
+					1 << ab8500->hwid, 0);
 
 		if (ret < 0)
 			dev_err(chip->dev, "%s: Failed to disable PWM, Error %d\n",
@@ -56,7 +63,7 @@ static int ab8500_pwm_apply(struct pwm_c
 	 */
 	higher_val = ((state->duty_cycle & 0x0300) >> 8);
 
-	reg = AB8500_PWM_OUT_CTRL1_REG + ((chip->base - 1) * 2);
+	reg = AB8500_PWM_OUT_CTRL1_REG + (ab8500->hwid * 2);
 
 	ret = abx500_set_register_interruptible(chip->dev, AB8500_MISC,
 			reg, (u8)lower_val);
@@ -70,7 +77,7 @@ static int ab8500_pwm_apply(struct pwm_c
 
 	ret = abx500_mask_and_set_register_interruptible(chip->dev,
 				AB8500_MISC, AB8500_PWM_OUT_CTRL7_REG,
-				1 << (chip->base - 1), 1 << (chip->base - 1));
+				1 << ab8500->hwid, 1 << ab8500->hwid);
 	if (ret < 0)
 		dev_err(chip->dev, "%s: Failed to enable PWM, Error %d\n",
 							pwm->label, ret);
@@ -88,6 +95,9 @@ static int ab8500_pwm_probe(struct platf
 	struct ab8500_pwm_chip *ab8500;
 	int err;
 
+	if (pdev->id < 1 || pdev->id > 31)
+		return dev_err_probe(&pdev->dev, EINVAL, "Invalid device id %d\n", pdev->id);
+
 	/*
 	 * Nothing to be done in probe, this is required to get the
 	 * device which is required for ab8500 read and write
@@ -99,6 +109,7 @@ static int ab8500_pwm_probe(struct platf
 	ab8500->chip.dev = &pdev->dev;
 	ab8500->chip.ops = &ab8500_pwm_ops;
 	ab8500->chip.npwm = 1;
+	ab8500->hwid = pdev->id - 1;
 
 	err = pwmchip_add(&ab8500->chip);
 	if (err < 0)


