Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 900ED30388B
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 10:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390744AbhAZJC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 04:02:56 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:58133 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728030AbhAZJBd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Jan 2021 04:01:33 -0500
Received: from tarshish.tkos.co.il (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 03B4A4405AD;
        Tue, 26 Jan 2021 11:00:38 +0200 (IST)
From:   Baruch Siach <baruch@tkos.co.il>
To:     stable@vger.kernel.org
Cc:     Baruch Siach <baruch@tkos.co.il>,
        Russell King <linux@armlinux.org.uk>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.10-stable] gpio: mvebu: fix pwm .get_state period calculation
Date:   Tue, 26 Jan 2021 11:00:11 +0200
Message-Id: <d1d7d548eba25119397de87211de763c54b5d8cd.1611651611.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit e73b0101ae5124bf7cd3fb5d250302ad2f16a416 upstream.

The period is the sum of on and off values. That is, calculate period as

  ($on + $off) / clkrate

instead of

  $off / clkrate - $on / clkrate

that makes no sense.

Reported-by: Russell King <linux@armlinux.org.uk>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Fixes: 757642f9a584e ("gpio: mvebu: Add limited PWM support")
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---

This backported patch applies to all kernels between 4.14 and 5.10
(inclusive).
---
 drivers/gpio/gpio-mvebu.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index 2f245594a90a..ed7c5fc47f52 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -660,9 +660,8 @@ static void mvebu_pwm_get_state(struct pwm_chip *chip,
 
 	spin_lock_irqsave(&mvpwm->lock, flags);
 
-	val = (unsigned long long)
-		readl_relaxed(mvebu_pwmreg_blink_on_duration(mvpwm));
-	val *= NSEC_PER_SEC;
+	u = readl_relaxed(mvebu_pwmreg_blink_on_duration(mvpwm));
+	val = (unsigned long long) u * NSEC_PER_SEC;
 	do_div(val, mvpwm->clk_rate);
 	if (val > UINT_MAX)
 		state->duty_cycle = UINT_MAX;
@@ -671,21 +670,17 @@ static void mvebu_pwm_get_state(struct pwm_chip *chip,
 	else
 		state->duty_cycle = 1;
 
-	val = (unsigned long long)
-		readl_relaxed(mvebu_pwmreg_blink_off_duration(mvpwm));
+	val = (unsigned long long) u; /* on duration */
+	/* period = on + off duration */
+	val += readl_relaxed(mvebu_pwmreg_blink_off_duration(mvpwm));
 	val *= NSEC_PER_SEC;
 	do_div(val, mvpwm->clk_rate);
-	if (val < state->duty_cycle) {
+	if (val > UINT_MAX)
+		state->period = UINT_MAX;
+	else if (val)
+		state->period = val;
+	else
 		state->period = 1;
-	} else {
-		val -= state->duty_cycle;
-		if (val > UINT_MAX)
-			state->period = UINT_MAX;
-		else if (val)
-			state->period = val;
-		else
-			state->period = 1;
-	}
 
 	regmap_read(mvchip->regs, GPIO_BLINK_EN_OFF + mvchip->offset, &u);
 	if (u)
-- 
2.29.2

