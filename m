Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 152E62FA2C1
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392785AbhAROSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:18:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:39666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390617AbhARLpD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:45:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31480230FA;
        Mon, 18 Jan 2021 11:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970264;
        bh=JL2CyNISPQy4If4ZizhtYPcGYuhw7Rf1LAlS2ehGsuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ps1m6FMPQATzuU2dRoQSJ0AJlHIGy6lTz2t3ZUG1TUc/u7rrTGRAPMVXCTxvMVWs7
         QbRCYum5vAo27S2u5aTWi/2q0ora2LrsTaytDV3PCmlEiWH+fLwcIJYynJMRIcf8h+
         Brdzgq9raIzrG8BkfoL262YSnSuIvLK6Jh6xsVmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 075/152] hwmon: (pwm-fan) Ensure that calculation doesnt discard big period values
Date:   Mon, 18 Jan 2021 12:34:10 +0100
Message-Id: <20210118113356.386418132@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



