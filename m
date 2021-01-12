Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0802F3150
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbhALNRh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:17:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:53840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389835AbhALM5Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C8D22313B;
        Tue, 12 Jan 2021 12:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456169;
        bh=JL2CyNISPQy4If4ZizhtYPcGYuhw7Rf1LAlS2ehGsuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XljfOV89P/oDMOIYh4lEudliHbKBPVtJbQUGL0J0Y2wNH2f6ACFVU5JQBGzhOk+MX
         yATSNLz+x+osGEgFytGOk/uJUo82++2DxB53hb5HMXRy4z6ZKDr/4qsfMDQ4JFrRWa
         aO1xqxp/fT9y6CqlpcbJL+uHuBsKH/Z9lK9z5bMH6+++WYyhBG+0mIKlFaG0MyYaOo
         XrlNWQXgqi5gI4OETnPGkmJv+zxu1AyG1aCh6ypPnSvMJ7Nlx3l1qZXOna+LNh75xV
         WPtycfZ/G/ANxK4dgvzBmGsyvJ9f8S1uwZougtbcU0q9qVaj19ieF9fh+1/y1Mm/UL
         3aAhTJ3rVFqfA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 26/51] hwmon: (pwm-fan) Ensure that calculation doesn't discard big period values
Date:   Tue, 12 Jan 2021 07:55:08 -0500
Message-Id: <20210112125534.70280-26-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 1eda52334e6d13eb1a85f713ce06dd39342b5020 ]

With MAX_PWM being defined to 255 the code

	unsigned long period;
	...
	period = ctx->pwm->args.period;
	state.duty_cycle = DIV_ROUND_UP(pwm * (period - 1), MAX_PWM);

calculates a too small value for duty_cycle if the configured period is
big (either by discarding the 64 bit value ctx->pwm->args.period or by
overflowing the multiplication). As this results in a too slow fan and
so maybe an overheating machine better be safe than sorry and error out
in .probe.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20201215092031.152243-1-u.kleine-koenig@pengutronix.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pwm-fan.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/pwm-fan.c b/drivers/hwmon/pwm-fan.c
index 1f63807c0399e..ec171f2b684a1 100644
--- a/drivers/hwmon/pwm-fan.c
+++ b/drivers/hwmon/pwm-fan.c
@@ -324,8 +324,18 @@ static int pwm_fan_probe(struct platform_device *pdev)
 
 	ctx->pwm_value = MAX_PWM;
 
-	/* Set duty cycle to maximum allowed and enable PWM output */
 	pwm_init_state(ctx->pwm, &state);
+	/*
+	 * __set_pwm assumes that MAX_PWM * (period - 1) fits into an unsigned
+	 * long. Check this here to prevent the fan running at a too low
+	 * frequency.
+	 */
+	if (state.period > ULONG_MAX / MAX_PWM + 1) {
+		dev_err(dev, "Configured period too big\n");
+		return -EINVAL;
+	}
+
+	/* Set duty cycle to maximum allowed and enable PWM output */
 	state.duty_cycle = ctx->pwm->args.period - 1;
 	state.enabled = true;
 
-- 
2.27.0

