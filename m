Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 490136EC4BD
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 07:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbjDXFUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 01:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjDXFUt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 01:20:49 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66222688
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 22:20:46 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pqod3-0002tW-80; Mon, 24 Apr 2023 07:20:45 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pqod2-00DP6D-Kj; Mon, 24 Apr 2023 07:20:44 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pqod1-00FjZs-SV; Mon, 24 Apr 2023 07:20:43 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     stable@vger.kernel.org
Cc:     thierry.reding@gmail.com
Subject: [PATCH v5.15.x 2/2] pwm: hibvt: Explicitly set .polarity in .get_state()
Date:   Mon, 24 Apr 2023 07:20:37 +0200
Message-Id: <20230424052037.20895-2-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230424052037.20895-1-u.kleine-koenig@pengutronix.de>
References: <20230424052037.20895-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1193; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=tCk1QshSYjYZjYeK8aY9IvvEu4oCm1fVSUIdRQoBWq0=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkRhGk1X/vz5MFQ5xemykfK0fbCurFFCK2y6/de RDApLdoJD2JATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZEYRpAAKCRCPgPtYfRL+ TvECB/wNro0bIJbuMQqCmGQ8XCr1qyXwDJiP5xXfjD01WVUH6YJ+NgxG6fXlKXoeqvE24HKq/42 ZoErQnEYqgOEr+Z6ZGI6qffT874iUinFeoYtpLmgKURHHODPw074+ajQAHacKj1HjYzRSlNdNyl Io1adNN1JBGFJIYJlhu3aDEJZ26yRdqGtVHsAwrpOry8zto2xp4l3axd+1wzZGhoJRDdgNednYc hZCOLrGzga2RzE7tj5EGLR3jKFL4q1Ij3wL0gSZnzyeHCJ4qbE25JfIwzUQSg7ZOoS4hTRtIBII EH30HxPNEorDnwtgjgQForjCiD+Kc4mvd7gEsTU3HaIZC7Uw
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

[ Upstream commit 6f57937980142715e927697a6ffd2050f38ed6f6 ]

The driver only both polarities. Complete the implementation of
.get_state() by setting .polarity according to the configured hardware
state.

Fixes: d09f00810850 ("pwm: Add PWM driver for HiSilicon BVT SOCs")
Link: https://lore.kernel.org/r/20230228135508.1798428-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/pwm/pwm-hibvt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pwm/pwm-hibvt.c b/drivers/pwm/pwm-hibvt.c
index 333f1b18ff4e..54035563fc0e 100644
--- a/drivers/pwm/pwm-hibvt.c
+++ b/drivers/pwm/pwm-hibvt.c
@@ -146,6 +146,7 @@ static void hibvt_pwm_get_state(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	value = readl(base + PWM_CTRL_ADDR(pwm->hwpwm));
 	state->enabled = (PWM_ENABLE_MASK & value);
+	state->polarity = (PWM_POLARITY_MASK & value) ? PWM_POLARITY_INVERSED : PWM_POLARITY_NORMAL;
 }
 
 static int hibvt_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
-- 
2.39.2

