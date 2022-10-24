Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA4760BE99
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 01:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbiJXXbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 19:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbiJXXbT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 19:31:19 -0400
Received: from aposti.net (aposti.net [89.234.176.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1916FE93F;
        Mon, 24 Oct 2022 14:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1666644741; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fhJrUP+Njp6HsgAA/ZXoqJpzcRmNXj5pVHzoSisYMV4=;
        b=X3ViSXvrs2DTVmBs1bS+Stp7Zsayi6JvxxstatJ+bXCQrKzYPB71+k+m1NyhYpgUfMubvJ
        1dhLa4d241qWW23ro7HP2VPDT6HVtKb9MrcefjBfaOWEPUqVCF2iMd9coarbeAtB+h+dD8
        8LWesp3qkUci38YVquaZ1QjiD5SP8lU=
From:   Paul Cercueil <paul@crapouillou.net>
To:     Thierry Reding <thierry.reding@gmail.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     od@opendingux.net, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        Paul Cercueil <paul@crapouillou.net>, stable@vger.kernel.org
Subject: [PATCH 2/5] pwm: jz4740: Fix pin level of disabled TCU2 channels, part 2
Date:   Mon, 24 Oct 2022 21:52:10 +0100
Message-Id: <20221024205213.327001-3-paul@crapouillou.net>
In-Reply-To: <20221024205213.327001-1-paul@crapouillou.net>
References: <20221024205213.327001-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After commit a020f22a4ff5 ("pwm: jz4740: Make PWM start with the active part"),
the trick to set duty > period to properly shut down TCU2 channels did
not work anymore, because of the polarity inversion.

Address this issue by restoring the proper polarity before disabling the
channels.

Fixes: a020f22a4ff5 ("pwm: jz4740: Make PWM start with the active part")
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Cc: stable@vger.kernel.org
---
 drivers/pwm/pwm-jz4740.c | 62 ++++++++++++++++++++++++++--------------
 1 file changed, 40 insertions(+), 22 deletions(-)

diff --git a/drivers/pwm/pwm-jz4740.c b/drivers/pwm/pwm-jz4740.c
index 228eb104bf1e..65462a0052af 100644
--- a/drivers/pwm/pwm-jz4740.c
+++ b/drivers/pwm/pwm-jz4740.c
@@ -97,6 +97,19 @@ static int jz4740_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 	return 0;
 }
 
+static void jz4740_pwm_set_polarity(struct jz4740_pwm_chip *jz,
+				    unsigned int hwpwm,
+				    enum pwm_polarity polarity)
+{
+	unsigned int value = 0;
+
+	if (polarity == PWM_POLARITY_INVERSED)
+		value = TCU_TCSR_PWM_INITL_HIGH;
+
+	regmap_update_bits(jz->map, TCU_REG_TCSRc(hwpwm),
+			   TCU_TCSR_PWM_INITL_HIGH, value);
+}
+
 static void jz4740_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct jz4740_pwm_chip *jz = to_jz4740(chip);
@@ -130,6 +143,7 @@ static int jz4740_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	unsigned long long tmp = 0xffffull * NSEC_PER_SEC;
 	struct clk *clk = pwm_get_chip_data(pwm);
 	unsigned long period, duty;
+	enum pwm_polarity polarity;
 	long rate;
 	int err;
 
@@ -169,6 +183,9 @@ static int jz4740_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	if (duty >= period)
 		duty = period - 1;
 
+	/* Restore regular polarity before disabling the channel. */
+	jz4740_pwm_set_polarity(jz4740, pwm->hwpwm, state->polarity);
+
 	jz4740_pwm_disable(chip, pwm);
 
 	err = clk_set_rate(clk, rate);
@@ -190,29 +207,30 @@ static int jz4740_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	regmap_update_bits(jz4740->map, TCU_REG_TCSRc(pwm->hwpwm),
 			   TCU_TCSR_PWM_SD, TCU_TCSR_PWM_SD);
 
-	/*
-	 * Set polarity.
-	 *
-	 * The PWM starts in inactive state until the internal timer reaches the
-	 * duty value, then becomes active until the timer reaches the period
-	 * value. In theory, we should then use (period - duty) as the real duty
-	 * value, as a high duty value would otherwise result in the PWM pin
-	 * being inactive most of the time.
-	 *
-	 * Here, we don't do that, and instead invert the polarity of the PWM
-	 * when it is active. This trick makes the PWM start with its active
-	 * state instead of its inactive state.
-	 */
-	if ((state->polarity == PWM_POLARITY_NORMAL) ^ state->enabled)
-		regmap_update_bits(jz4740->map, TCU_REG_TCSRc(pwm->hwpwm),
-				   TCU_TCSR_PWM_INITL_HIGH, 0);
-	else
-		regmap_update_bits(jz4740->map, TCU_REG_TCSRc(pwm->hwpwm),
-				   TCU_TCSR_PWM_INITL_HIGH,
-				   TCU_TCSR_PWM_INITL_HIGH);
-
-	if (state->enabled)
+	if (state->enabled) {
+		/*
+		 * Set polarity.
+		 *
+		 * The PWM starts in inactive state until the internal timer
+		 * reaches the duty value, then becomes active until the timer
+		 * reaches the period value. In theory, we should then use
+		 * (period - duty) as the real duty value, as a high duty value
+		 * would otherwise result in the PWM pin being inactive most of
+		 * the time.
+		 *
+		 * Here, we don't do that, and instead invert the polarity of
+		 * the PWM when it is active. This trick makes the PWM start
+		 * with its active state instead of its inactive state.
+		 */
+		if (state->polarity == PWM_POLARITY_NORMAL)
+			polarity = PWM_POLARITY_INVERSED;
+		else
+			polarity = PWM_POLARITY_NORMAL;
+
+		jz4740_pwm_set_polarity(jz4740, pwm->hwpwm, polarity);
+
 		jz4740_pwm_enable(chip, pwm);
+	}
 
 	return 0;
 }
-- 
2.35.1

