Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C83AC60BEA9
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 01:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbiJXXdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 19:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbiJXXcZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 19:32:25 -0400
Received: from aposti.net (aposti.net [89.234.176.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE040107A8C;
        Mon, 24 Oct 2022 14:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1666644740; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=avcN02YNvaxpZRdy8N6BP2+uTVrnwX31SrzsZGCAp0c=;
        b=Bmyh2YOhAjfg1GSy4ncnAj+0uagLOdl4JNbxAeyUKnYnHQsPI4htDWCoHQuYlBqCsqa7qz
        a1TvbaO2+3VP3gUDS4UmlqXfBkR5Tze5O7MPfwSi++v+pk0pHtro5AQCZftppjugDkmdxZ
        IqWyRrP0D7KxE5peHD5QjkDZvR7LGAI=
From:   Paul Cercueil <paul@crapouillou.net>
To:     Thierry Reding <thierry.reding@gmail.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     od@opendingux.net, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        Paul Cercueil <paul@crapouillou.net>, stable@vger.kernel.org
Subject: [PATCH 1/5] pwm: jz4740: Fix pin level of disabled TCU2 channels, part 1
Date:   Mon, 24 Oct 2022 21:52:09 +0100
Message-Id: <20221024205213.327001-2-paul@crapouillou.net>
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

The "duty > cycle" trick to force the pin level of a disabled TCU2
channel would only work when the channel had been enabled previously.

Address this issue by enabling the PWM mode in jz4740_pwm_disable
(I know, right) so that the "duty > cycle" trick works before disabling
the PWM channel right after.

This issue went unnoticed, as the PWM pins on the majority of the boards
tested would default to the inactive level once the corresponding TCU
clock was enabled, so the first call to jz4740_pwm_disable() would not
actually change the pin levels.

On the GCW Zero however, the PWM pin for the backlight (PWM1, which is
a TCU2 channel) goes active as soon as the timer1 clock is enabled.
Since the jz4740_pwm_disable() function did not work on channels not
previously enabled, the backlight would shine at full brightness from
the moment the backlight driver would probe, until the backlight driver
tried to *enable* the PWM output.

With this fix, the PWM pins will be forced inactive as soon as
jz4740_pwm_apply() is called (and might be reconfigured to active if
dictated by the pwm_state). This means that there is still a tiny time
frame between the .request() and .apply() callbacks where the PWM pin
might be active. Sadly, there is no way to fix this issue: it is
impossible to write a PWM channel's registers if the corresponding clock
is not enabled, and enabling the clock is what causes the PWM pin to go
active.

There is a workaround, though, which complements this fix: simply
starting the backlight driver (or any PWM client driver) with a "init"
pinctrl state that sets the pin as an inactive GPIO. Once the driver is
probed and the pinctrl state switches to "default", the regular PWM pin
configuration can be used as it will be properly driven.

Fixes: c2693514a0a1 ("pwm: jz4740: Obtain regmap from parent node")
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Cc: stable@vger.kernel.org
---
 drivers/pwm/pwm-jz4740.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-jz4740.c b/drivers/pwm/pwm-jz4740.c
index a5fdf97c0d2e..228eb104bf1e 100644
--- a/drivers/pwm/pwm-jz4740.c
+++ b/drivers/pwm/pwm-jz4740.c
@@ -102,11 +102,14 @@ static void jz4740_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 	struct jz4740_pwm_chip *jz = to_jz4740(chip);
 
 	/*
-	 * Set duty > period. This trick allows the TCU channels in TCU2 mode to
-	 * properly return to their init level.
+	 * Set duty > period, then enable PWM mode and start the counter.
+	 * This trick allows to force the inactive pin level for the TCU2
+	 * channels.
 	 */
 	regmap_write(jz->map, TCU_REG_TDHRc(pwm->hwpwm), 0xffff);
 	regmap_write(jz->map, TCU_REG_TDFRc(pwm->hwpwm), 0x0);
+	regmap_set_bits(jz->map, TCU_REG_TCSRc(pwm->hwpwm), TCU_TCSR_PWM_EN);
+	regmap_write(jz->map, TCU_REG_TESR, BIT(pwm->hwpwm));
 
 	/*
 	 * Disable PWM output.
-- 
2.35.1

