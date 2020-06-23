Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C25205D7D
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388750AbgFWUNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:13:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389128AbgFWUNs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:13:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A60520707;
        Tue, 23 Jun 2020 20:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943227;
        bh=v5hAGQBR3Z47eYCc7rV9jqnpUlqIw0f7hV3iflVxzkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oqJwqfJrcylXtwwCBrX7yz6cX6heMjbItto2l0G1zVc6QMaqhcQbW4FiduwA6r2Gt
         aLrY7lA3w7X+Q5PrH38fiHueUnPw8I44ua0LdlVX3fKJX7qoBF3PDfjt4mThiVVxUE
         t7RfN+wGEmaIY+vuMy+eW/KwDzny2AVXMSKfaJFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 310/477] pwm: imx27: Fix rounding behavior
Date:   Tue, 23 Jun 2020 21:55:07 +0200
Message-Id: <20200623195422.189586454@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit aef1a3799b5cb3ba4841f6034497b179646ccc70 ]

To not trigger the warnings provided by CONFIG_PWM_DEBUG

 - use up-rounding in .get_state()
 - don't divide by the result of a division
 - don't use the rounded counter value for the period length to calculate
   the counter value for the duty cycle

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-imx27.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/pwm/pwm-imx27.c b/drivers/pwm/pwm-imx27.c
index a6e40d4c485f3..732a6f3701e8e 100644
--- a/drivers/pwm/pwm-imx27.c
+++ b/drivers/pwm/pwm-imx27.c
@@ -150,13 +150,12 @@ static void pwm_imx27_get_state(struct pwm_chip *chip,
 
 	prescaler = MX3_PWMCR_PRESCALER_GET(val);
 	pwm_clk = clk_get_rate(imx->clk_per);
-	pwm_clk = DIV_ROUND_CLOSEST_ULL(pwm_clk, prescaler);
 	val = readl(imx->mmio_base + MX3_PWMPR);
 	period = val >= MX3_PWMPR_MAX ? MX3_PWMPR_MAX : val;
 
 	/* PWMOUT (Hz) = PWMCLK / (PWMPR + 2) */
-	tmp = NSEC_PER_SEC * (u64)(period + 2);
-	state->period = DIV_ROUND_CLOSEST_ULL(tmp, pwm_clk);
+	tmp = NSEC_PER_SEC * (u64)(period + 2) * prescaler;
+	state->period = DIV_ROUND_UP_ULL(tmp, pwm_clk);
 
 	/*
 	 * PWMSAR can be read only if PWM is enabled. If the PWM is disabled,
@@ -167,8 +166,8 @@ static void pwm_imx27_get_state(struct pwm_chip *chip,
 	else
 		val = imx->duty_cycle;
 
-	tmp = NSEC_PER_SEC * (u64)(val);
-	state->duty_cycle = DIV_ROUND_CLOSEST_ULL(tmp, pwm_clk);
+	tmp = NSEC_PER_SEC * (u64)(val) * prescaler;
+	state->duty_cycle = DIV_ROUND_UP_ULL(tmp, pwm_clk);
 
 	pwm_imx27_clk_disable_unprepare(imx);
 }
@@ -220,22 +219,23 @@ static int pwm_imx27_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	struct pwm_imx27_chip *imx = to_pwm_imx27_chip(chip);
 	struct pwm_state cstate;
 	unsigned long long c;
+	unsigned long long clkrate;
 	int ret;
 	u32 cr;
 
 	pwm_get_state(pwm, &cstate);
 
-	c = clk_get_rate(imx->clk_per);
-	c *= state->period;
+	clkrate = clk_get_rate(imx->clk_per);
+	c = clkrate * state->period;
 
-	do_div(c, 1000000000);
+	do_div(c, NSEC_PER_SEC);
 	period_cycles = c;
 
 	prescale = period_cycles / 0x10000 + 1;
 
 	period_cycles /= prescale;
-	c = (unsigned long long)period_cycles * state->duty_cycle;
-	do_div(c, state->period);
+	c = clkrate * state->duty_cycle;
+	do_div(c, NSEC_PER_SEC * prescale);
 	duty_cycles = c;
 
 	/*
-- 
2.25.1



