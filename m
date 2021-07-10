Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D103C2E94
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbhGJC1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:27:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233685AbhGJC05 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:26:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5722613F7;
        Sat, 10 Jul 2021 02:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883849;
        bh=tRb1rL9r1jHfW6knxthlrBoGc/o/vZ5eKhsuyfbMuSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JRRoM5REPs5+yPQ4tSwce3OPKUFk/aYyShGMXUcV0tbctp5uKYbSU8uwx5t8VzEDK
         001LFLCp1kgsEakWt+sTZBS+RuoqHQ5nXfFTaqSlgZooKQrnSI8LD6h/Ftqh0eFhvW
         5d9Wg5o/whmmJlMYgzsMb+a7WARK2aTQ+CUMEbkWuioHQU9hnmN592Ulg/I4Zl0jpK
         862RDdHo/do42OKI/QzrPw3qfEb9XVP2uFw8ZSz1KB58kF6vO48L002sT8DrbXFfpE
         uoPtY50zHuzFSyZHZJush3IrWO3vWTKhjly9iSopDUl/spgWQKo3J+maqnlJEs55vv
         rql9dLLrtVq1g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 093/104] backlight: lm3630a: Fix return code of .update_status() callback
Date:   Fri,  9 Jul 2021 22:21:45 -0400
Message-Id: <20210710022156.3168825-93-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
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
index e88a2b0e5904..7140b0d98082 100644
--- a/drivers/video/backlight/lm3630a_bl.c
+++ b/drivers/video/backlight/lm3630a_bl.c
@@ -190,7 +190,7 @@ static int lm3630a_bank_a_update_status(struct backlight_device *bl)
 	if ((pwm_ctrl & LM3630A_PWM_BANK_A) != 0) {
 		lm3630a_pwm_ctrl(pchip, bl->props.brightness,
 				 bl->props.max_brightness);
-		return bl->props.brightness;
+		return 0;
 	}
 
 	/* disable sleep */
@@ -210,8 +210,8 @@ static int lm3630a_bank_a_update_status(struct backlight_device *bl)
 	return 0;
 
 out_i2c_err:
-	dev_err(pchip->dev, "i2c failed to access\n");
-	return bl->props.brightness;
+	dev_err(pchip->dev, "i2c failed to access (%pe)\n", ERR_PTR(ret));
+	return ret;
 }
 
 static int lm3630a_bank_a_get_brightness(struct backlight_device *bl)
@@ -267,7 +267,7 @@ static int lm3630a_bank_b_update_status(struct backlight_device *bl)
 	if ((pwm_ctrl & LM3630A_PWM_BANK_B) != 0) {
 		lm3630a_pwm_ctrl(pchip, bl->props.brightness,
 				 bl->props.max_brightness);
-		return bl->props.brightness;
+		return 0;
 	}
 
 	/* disable sleep */
@@ -287,8 +287,8 @@ static int lm3630a_bank_b_update_status(struct backlight_device *bl)
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

