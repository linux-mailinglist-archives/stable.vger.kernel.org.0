Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B33C36EC4D5
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 07:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjDXFa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 01:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjDXFa6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 01:30:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF903270B
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 22:30:53 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pqomp-0003vU-1j; Mon, 24 Apr 2023 07:30:51 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pqomn-00DP76-Ob; Mon, 24 Apr 2023 07:30:49 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pqomm-00FjdE-Nm; Mon, 24 Apr 2023 07:30:48 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     gregkh@linuxfoundation.org
Cc:     kamatam@amazon.com, martin.blumenstingl@googlemail.com,
        thierry.reding@gmail.com, stable@vger.kernel.org
Subject: [PATCH v5.10.x] pwm: meson: Explicitly set .polarity in .get_state()
Date:   Mon, 24 Apr 2023 07:30:24 +0200
Message-Id: <20230424053024.21837-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <2023042242-unsaved-sanded-d4c1@gregkh>
References: <2023042242-unsaved-sanded-d4c1@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2317; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=FTHT2ehQ0wZwNAzQCwuLzSDarKYioB6NPDdBNqcaBls=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkRhPvb6l1otCPTp6Nj2NpqEe4RTY/4d0/wTVUP t1s8klsNcuJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZEYT7wAKCRCPgPtYfRL+ TrJbCACSd+ZtWzH7aNNrZbtPCkHJ/M5pnvUchk7f96WxFkJldd6+zMFKd86wvjY6frkgBrAFzkW XKj9ioA+ab8EOYCu5MsGawE93s/tl/0qq/kHFbV5SWyXPIwY2uzRxj9bYqm6X0djWv5GKsTBsz5 uVUwKVoVOwoG2j+GzhmvK9HNxKNXYRkumEkwYVyGqq3tMAWyOfECCEQrw/rAiyQHW4dtKo2vCTv jTFkObzo2vtNlzsTVtdFIgg1cGcXf8P0ZCigJXhdKxGmTkIiAytaiKkfbvfeoIKlgabwXQ9tbrO 8pfZPeqOtWhPJtFSHLlekCoC1AoEX9N/XCBwI/5ivM+xgpBc
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

[ Upstream commit 8caa81eb950cb2e9d2d6959b37d853162d197f57 ]

The driver only supports normal polarity. Complete the implementation of
.get_state() by setting .polarity accordingly.

This fixes a regression that was possible since commit c73a3107624d
("pwm: Handle .get_state() failures") which stopped to zero-initialize
the state passed to the .get_state() callback. This was reported at
https://forum.odroid.com/viewtopic.php?f=177&t=46360 . While this was an
unintended side effect, the real issue is the driver's callback not
setting the polarity.

There is a complicating fact, that the .apply() callback fakes support
for inversed polarity. This is not (and cannot) be matched by
.get_state(). As fixing this isn't easy, only point it out in a comment
to prevent authors of other drivers from copying that approach.

Fixes: c375bcbaabdb ("pwm: meson: Read the full hardware state in meson_pwm_get_state()")
Reported-by: Munehisa Kamata <kamatam@amazon.com>
Acked-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20230310191405.2606296-1-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/pwm/pwm-meson.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/pwm/pwm-meson.c b/drivers/pwm/pwm-meson.c
index bd0d7336b898..237bb8e06593 100644
--- a/drivers/pwm/pwm-meson.c
+++ b/drivers/pwm/pwm-meson.c
@@ -168,6 +168,12 @@ static int meson_pwm_calc(struct meson_pwm *meson, struct pwm_device *pwm,
 	duty = state->duty_cycle;
 	period = state->period;
 
+	/*
+	 * Note this is wrong. The result is an output wave that isn't really
+	 * inverted and so is wrongly identified by .get_state as normal.
+	 * Fixing this needs some care however as some machines might rely on
+	 * this.
+	 */
 	if (state->polarity == PWM_POLARITY_INVERSED)
 		duty = period - duty;
 
@@ -366,6 +372,7 @@ static void meson_pwm_get_state(struct pwm_chip *chip, struct pwm_device *pwm,
 		state->period = 0;
 		state->duty_cycle = 0;
 	}
+	state->polarity = PWM_POLARITY_NORMAL;
 }
 
 static const struct pwm_ops meson_pwm_ops = {
-- 
2.39.2

