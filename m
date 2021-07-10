Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 994A13C313B
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234838AbhGJClA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:41:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234886AbhGJCjR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:39:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2DAC613EB;
        Sat, 10 Jul 2021 02:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884506;
        bh=lAu+LTAR349mDL0w4BHlXProjoot0ns5zpTda0DaVLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n8zaVreUzXkhMDgzdqi/E5WDXJbQAZvzSmJF/86P2q/H/n6qwHX3tevrbG2bRtY6b
         WZJ3f3Cc3Y76JMRDlo+e5oRbsEb1NMK8eITl9Wg/mMM8XSqn+kKg9gZd0MJ2HUY3ga
         iZYU2YktMNEH9z8Ngi4LizVaU4z8V/7nQNllQysnAG+pRgyD9vPM1jtSiOxNK9BIZK
         P1oUISXisaLWCFQCo4BCUqBvL7sUldTkPwTAXp7gpvpQD7zz50GkYpY+qAJVczTlOx
         ncYPDrcR4LjuYM8qjtQxOJWT4IEHBjg5EUNRVfNdAntW4ZrqIY1v8u2XcC/Kn4Cvkq
         213OabovX61Ug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 33/39] backlight: lm3630a: Fix return code of .update_status() callback
Date:   Fri,  9 Jul 2021 22:31:58 -0400
Message-Id: <20210710023204.3171428-33-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023204.3171428-1-sashal@kernel.org>
References: <20210710023204.3171428-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit b9481a667a90ec739995e85f91f3672ca44d6ffa ]

According to <linux/backlight.h> .update_status() is supposed to
return 0 on success and a negative error code otherwise. Adapt
lm3630a_bank_a_update_status() and lm3630a_bank_b_update_status() to
actually do it.

While touching that also add the error code to the failure message.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/lm3630a_bl.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/video/backlight/lm3630a_bl.c b/drivers/video/backlight/lm3630a_bl.c
index ef2553f452ca..f17e5a8860fa 100644
--- a/drivers/video/backlight/lm3630a_bl.c
+++ b/drivers/video/backlight/lm3630a_bl.c
@@ -184,7 +184,7 @@ static int lm3630a_bank_a_update_status(struct backlight_device *bl)
 	if ((pwm_ctrl & LM3630A_PWM_BANK_A) != 0) {
 		lm3630a_pwm_ctrl(pchip, bl->props.brightness,
 				 bl->props.max_brightness);
-		return bl->props.brightness;
+		return 0;
 	}
 
 	/* disable sleep */
@@ -204,8 +204,8 @@ static int lm3630a_bank_a_update_status(struct backlight_device *bl)
 	return 0;
 
 out_i2c_err:
-	dev_err(pchip->dev, "i2c failed to access\n");
-	return bl->props.brightness;
+	dev_err(pchip->dev, "i2c failed to access (%pe)\n", ERR_PTR(ret));
+	return ret;
 }
 
 static int lm3630a_bank_a_get_brightness(struct backlight_device *bl)
@@ -261,7 +261,7 @@ static int lm3630a_bank_b_update_status(struct backlight_device *bl)
 	if ((pwm_ctrl & LM3630A_PWM_BANK_B) != 0) {
 		lm3630a_pwm_ctrl(pchip, bl->props.brightness,
 				 bl->props.max_brightness);
-		return bl->props.brightness;
+		return 0;
 	}
 
 	/* disable sleep */
@@ -281,8 +281,8 @@ static int lm3630a_bank_b_update_status(struct backlight_device *bl)
 	return 0;
 
 out_i2c_err:
-	dev_err(pchip->dev, "i2c failed to access REG_CTRL\n");
-	return bl->props.brightness;
+	dev_err(pchip->dev, "i2c failed to access (%pe)\n", ERR_PTR(ret));
+	return ret;
 }
 
 static int lm3630a_bank_b_get_brightness(struct backlight_device *bl)
-- 
2.30.2

