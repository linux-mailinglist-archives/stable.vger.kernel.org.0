Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20F26EC4BC
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 07:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbjDXFUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 01:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbjDXFUt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 01:20:49 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD9526A3
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 22:20:47 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pqod3-0002tR-8X; Mon, 24 Apr 2023 07:20:45 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pqod2-00DP6A-8g; Mon, 24 Apr 2023 07:20:44 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pqod1-00FjZp-Gw; Mon, 24 Apr 2023 07:20:43 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     stable@vger.kernel.org
Cc:     thierry.reding@gmail.com, Jeff LaBundy <jeff@labundy.com>
Subject: [PATCH v5.15.x 1/2] pwm: iqs620a: Explicitly set .polarity in .get_state()
Date:   Mon, 24 Apr 2023 07:20:36 +0200
Message-Id: <20230424052037.20895-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1148; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=gA9K+ZYT/l3HSAxNKl5mm3+o7QQ3QiOpYWUCAQlQ3BI=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkRhGjblubgIg2NalffR3o66It9SvgwjJmW7WvK zsdbkE+932JATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZEYRowAKCRCPgPtYfRL+ TiI7CAC2qOypX/UWpH8Fvt6m1iKIwZGKHMsIhHlYt6Qe/547jz3eNVAMyfw+jcLXk/4Wwm0P6dx Ra84/CB2Ctl5ztil3oa1UwrGDxASFms6ZXSlvMmpfREl3xSxvFy0QJwLP7D3u8uPo8GL8A6PagD uUSSp/9jOSGqEPNx+pGNHgaXO2I2fxP7NkvERGZ3BQLprKkozS3JvuTJCBkBDbFYZ3TTYPnSrer Do9GGdjeEfMlR9W/ByQRrCnc0wv7otfE6txC4yd0peSTpYNYtt7gccvIO/VohMovR+wYJIH2FlJ X9R6J3eg7hLFx4z7w5BwMlCmLd3HyFBPVQGqjtzKSLQ/ZH9K
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
index 54bd95a5cab0..8cee8f626d4e 100644
--- a/drivers/pwm/pwm-iqs620a.c
+++ b/drivers/pwm/pwm-iqs620a.c
@@ -126,6 +126,7 @@ static void iqs620_pwm_get_state(struct pwm_chip *chip, struct pwm_device *pwm,
 	mutex_unlock(&iqs620_pwm->lock);
 
 	state->period = IQS620_PWM_PERIOD_NS;
+	state->polarity = PWM_POLARITY_NORMAL;
 }
 
 static int iqs620_pwm_notifier(struct notifier_block *notifier,
-- 
2.39.2

