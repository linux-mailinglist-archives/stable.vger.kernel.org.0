Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F123A593272
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 17:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiHOPt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 11:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbiHOPtz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 11:49:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA34312AD7
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 08:49:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E528B80F92
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 15:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7684C433C1;
        Mon, 15 Aug 2022 15:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660578591;
        bh=zNesuTmJrVDqdhiLxqFo7jdS36Vtzcf1R0kX9PLcsJg=;
        h=Subject:To:Cc:From:Date:From;
        b=XJ2rqD25tKUYc3dmih9S1BBETITMREZsHBwT9F2rylzwojqq7FmiBa6VTifd0iMve
         ETdctDrocjdsjah2CLSXEFtoaHy4WfU9h9iettu3GXjD92O1dh3WEB3xdTy/OB63Fb
         lP2MPx9nHM9V+M2RlZT/6TcQ6f6cg30GJQfAG/wU=
Subject: FAILED: patch "[PATCH] pwm: ab8500: Fix register offset calculation to not depend on" failed to apply to 5.10-stable tree
To:     u.kleine-koenig@pengutronix.de, linus.walleij@linaro.org,
        thierry.reding@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Aug 2022 17:49:48 +0200
Message-ID: <1660578588167111@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From eb41f334589d66b9da6f2b1acf7963ef8ca8d94e Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Date: Mon, 5 Jul 2021 18:55:10 +0200
Subject: [PATCH] pwm: ab8500: Fix register offset calculation to not depend on
 probe order
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/drivers/pwm/pwm-ab8500.c b/drivers/pwm/pwm-ab8500.c
index e2a26d9da25b..281f74a1c50b 100644
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
@@ -37,7 +44,7 @@ static int ab8500_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	if (!state->enabled) {
 		ret = abx500_mask_and_set_register_interruptible(chip->dev,
 					AB8500_MISC, AB8500_PWM_OUT_CTRL7_REG,
-					1 << (chip->base - 1), 0);
+					1 << ab8500->hwid, 0);
 
 		if (ret < 0)
 			dev_err(chip->dev, "%s: Failed to disable PWM, Error %d\n",
@@ -56,7 +63,7 @@ static int ab8500_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	 */
 	higher_val = ((state->duty_cycle & 0x0300) >> 8);
 
-	reg = AB8500_PWM_OUT_CTRL1_REG + ((chip->base - 1) * 2);
+	reg = AB8500_PWM_OUT_CTRL1_REG + (ab8500->hwid * 2);
 
 	ret = abx500_set_register_interruptible(chip->dev, AB8500_MISC,
 			reg, (u8)lower_val);
@@ -70,7 +77,7 @@ static int ab8500_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	ret = abx500_mask_and_set_register_interruptible(chip->dev,
 				AB8500_MISC, AB8500_PWM_OUT_CTRL7_REG,
-				1 << (chip->base - 1), 1 << (chip->base - 1));
+				1 << ab8500->hwid, 1 << ab8500->hwid);
 	if (ret < 0)
 		dev_err(chip->dev, "%s: Failed to enable PWM, Error %d\n",
 							pwm->label, ret);
@@ -88,6 +95,9 @@ static int ab8500_pwm_probe(struct platform_device *pdev)
 	struct ab8500_pwm_chip *ab8500;
 	int err;
 
+	if (pdev->id < 1 || pdev->id > 31)
+		return dev_err_probe(&pdev->dev, EINVAL, "Invalid device id %d\n", pdev->id);
+
 	/*
 	 * Nothing to be done in probe, this is required to get the
 	 * device which is required for ab8500 read and write
@@ -99,6 +109,7 @@ static int ab8500_pwm_probe(struct platform_device *pdev)
 	ab8500->chip.dev = &pdev->dev;
 	ab8500->chip.ops = &ab8500_pwm_ops;
 	ab8500->chip.npwm = 1;
+	ab8500->hwid = pdev->id - 1;
 
 	err = pwmchip_add(&ab8500->chip);
 	if (err < 0)

