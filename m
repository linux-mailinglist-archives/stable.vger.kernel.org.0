Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC64E3C31AC
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235552AbhGJCnq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:43:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:33764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235392AbhGJCmy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:42:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B754A613DC;
        Sat, 10 Jul 2021 02:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884745;
        bh=p58epB/5XPf9VoPg+aVuld8nvvB+GnyYnomEpyTlmtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RTGdlvbfdUD5I0oxng4J/M86/7SY//Ses4uUbSdWlcrd+Lca9Hy4nbQITf681Y/iw
         AaPhh0LQbxj2QxFBsJxJxNFCYUV79KtjWTtkK8hQHE0YP7ZIDglQR1PiMs38SoqGru
         pALrgxNY0Gqw9gCAQvHNySzoca3iwbf5e47r3dnvhzuMOJCNrPEEMa0fmggUWdWr7O
         DKXu7TmOxgRxPj+dN1Ga0BHUw3fR35uGkr3I59N6Tg1tP1o0XZ7CbsNT3SBT1CbAuE
         4oDdl5mHBvVp0MveCXS/Exvtzxj0vCMaiF1M6rpZ7SR6uk+bOQbum4yI/OTyR0FRqQ
         u9lOBXReuv39g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 22/26] backlight: lm3630a: Fix return code of .update_status() callback
Date:   Fri,  9 Jul 2021 22:36:00 -0400
Message-Id: <20210710023604.3172486-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023604.3172486-1-sashal@kernel.org>
References: <20210710023604.3172486-1-sashal@kernel.org>
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
index 1771220b2437..90a24b975240 100644
--- a/drivers/video/backlight/lm3630a_bl.c
+++ b/drivers/video/backlight/lm3630a_bl.c
@@ -183,7 +183,7 @@ static int lm3630a_bank_a_update_status(struct backlight_device *bl)
 	if ((pwm_ctrl & LM3630A_PWM_BANK_A) != 0) {
 		lm3630a_pwm_ctrl(pchip, bl->props.brightness,
 				 bl->props.max_brightness);
-		return bl->props.brightness;
+		return 0;
 	}
 
 	/* disable sleep */
@@ -203,8 +203,8 @@ static int lm3630a_bank_a_update_status(struct backlight_device *bl)
 	return 0;
 
 out_i2c_err:
-	dev_err(pchip->dev, "i2c failed to access\n");
-	return bl->props.brightness;
+	dev_err(pchip->dev, "i2c failed to access (%pe)\n", ERR_PTR(ret));
+	return ret;
 }
 
 static int lm3630a_bank_a_get_brightness(struct backlight_device *bl)
@@ -260,7 +260,7 @@ static int lm3630a_bank_b_update_status(struct backlight_device *bl)
 	if ((pwm_ctrl & LM3630A_PWM_BANK_B) != 0) {
 		lm3630a_pwm_ctrl(pchip, bl->props.brightness,
 				 bl->props.max_brightness);
-		return bl->props.brightness;
+		return 0;
 	}
 
 	/* disable sleep */
@@ -280,8 +280,8 @@ static int lm3630a_bank_b_update_status(struct backlight_device *bl)
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

