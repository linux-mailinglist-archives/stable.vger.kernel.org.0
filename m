Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A4E21B327
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 12:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgGJK2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 06:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgGJK2E (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 06:28:04 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E09F5C08C5CE
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 03:28:03 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1jtqG8-0005cN-Hu; Fri, 10 Jul 2020 12:28:00 +0200
Received: from ukl by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1jtqG7-0002ow-TG; Fri, 10 Jul 2020 12:27:59 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     stable@vger.kernel.org
Cc:     "H. Nikolaus Schaller" <hns@goldelico.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        letux-kernel@openphoenux.org, linux-mips@vger.kernel.org,
        tsbogend@alpha.franken.de
Subject: [PATCH] [stable v5.4.x] pwm: jz4740: Fix build failure
Date:   Fri, 10 Jul 2020 12:27:58 +0200
Message-Id: <20200710102758.8341-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When commit 9017dc4fbd59 ("pwm: jz4740: Enhance precision in calculation
of duty cycle") from v5.8-rc1 was backported to v5.4.x its dependency on
commit ce1f9cece057 ("pwm: jz4740: Use clocks from TCU driver") was not
noticed which made the pwm-jz4740 driver fail to build.

As ce1f9cece057 depends on still more rework, just backport a small part
of this commit to make the driver build again. (There is no dependency
on the functionality introduced in ce1f9cece057, just the rate variable
is needed.)

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

@Paul: Can you please check this is correct? I only build-tested this
change.

Best regards
Uwe

 drivers/pwm/pwm-jz4740.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-jz4740.c b/drivers/pwm/pwm-jz4740.c
index d0f5c69930d0..77c28313e95f 100644
--- a/drivers/pwm/pwm-jz4740.c
+++ b/drivers/pwm/pwm-jz4740.c
@@ -92,11 +92,12 @@ static int jz4740_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 {
 	struct jz4740_pwm_chip *jz4740 = to_jz4740(pwm->chip);
 	unsigned long long tmp;
-	unsigned long period, duty;
+	unsigned long rate, period, duty;
 	unsigned int prescaler = 0;
 	uint16_t ctrl;
 
-	tmp = (unsigned long long)clk_get_rate(jz4740->clk) * state->period;
+	rate = clk_get_rate(jz4740->clk);
+	tmp = rate * state->period;
 	do_div(tmp, 1000000000);
 	period = tmp;
 
-- 
2.27.0

