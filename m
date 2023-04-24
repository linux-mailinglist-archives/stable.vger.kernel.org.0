Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06A2E6EC4D6
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 07:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjDXFbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 01:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjDXFbO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 01:31:14 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93CD4270B
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 22:31:13 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pqonA-0003zM-2X; Mon, 24 Apr 2023 07:31:12 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pqon9-00DP7B-BK; Mon, 24 Apr 2023 07:31:11 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pqon8-00FjdL-M7; Mon, 24 Apr 2023 07:31:10 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     stable@vger.kernel.org
Cc:     thierry.reding@gmail.com, Jeff LaBundy <jeff@labundy.com>
Subject: [PATCH v5.10.x 1/2] pwm: iqs620a: Explicitly set .polarity in .get_state()
Date:   Mon, 24 Apr 2023 07:31:04 +0200
Message-Id: <20230424053105.21872-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1148; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=aZvHng2sxU4JqfBWRDsa4cNjSk8X1XCtQQHaZVubAt0=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkRhQXk+5K/jq8PTs2A0mweADqcvWyIAlhHO0Wj qNit3EKi+GJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZEYUFwAKCRCPgPtYfRL+ TkOCB/9MDvzKwBZcP6MKJM8Xpf9nCZUmNBurQEINja9hbnytPWseXUYaqIisg/zgzK5PkeXFr0v 8K5X+1pEJGQ/lwu9J3It4TWWSEDd3nOCJIRM0zG9E7hTMlm7+aZeHQX6k0jnKZxP8jcX7qtHE73 1l52jPwE2XsYSC/pLzIUWVkuwqoUVLfdaQsTVfRhyEnSULEoE3xwjI1N8RcayEUyr+ACl+tH7Tc FT2fHzHztA8W7NDAw7f576kTcQ6tJjNQLjSIik03rD1sg4yQOkPSFkEIa5zvfZt6sOKJLtbbxTI 03lk1gKgQujgMD0Z5wZsKqx87FcYb1G5C923zqhmEDqe+icu
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b20b097128d9145fadcea1cbb45c4d186cb57466 ]

The driver only supports normal polarity. Complete the implementation of
.get_state() by setting .polarity accordingly.

Fixes: 6f0841a8197b ("pwm: Add support for Azoteq IQS620A PWM generator")
Reviewed-by: Jeff LaBundy <jeff@labundy.com>
Link: https://lore.kernel.org/r/20230228135508.1798428-4-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/pwm/pwm-iqs620a.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pwm/pwm-iqs620a.c b/drivers/pwm/pwm-iqs620a.c
index 3e967a12458c..a2aef006cb71 100644
--- a/drivers/pwm/pwm-iqs620a.c
+++ b/drivers/pwm/pwm-iqs620a.c
@@ -132,6 +132,7 @@ static void iqs620_pwm_get_state(struct pwm_chip *chip, struct pwm_device *pwm,
 	mutex_unlock(&iqs620_pwm->lock);
 
 	state->period = IQS620_PWM_PERIOD_NS;
+	state->polarity = PWM_POLARITY_NORMAL;
 }
 
 static int iqs620_pwm_notifier(struct notifier_block *notifier,
-- 
2.39.2

