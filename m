Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7338411D76
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348892AbhITRUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:20:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346711AbhITRSn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:18:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6053761A2F;
        Mon, 20 Sep 2021 16:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157191;
        bh=HPXnj/Qb0YFHLsTSz6Kt0aSpTtygeDnH2kVS/uy0QYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=djneZY6GIbJrdwKfonZLsUL5lUpDdX/fCaewfMehtTA0DNsXDEjtOOkyGyefvcS6V
         1hXZM4JcwpDsvafesHNHGT3mEd1iujl9d1gFp+icYA63p5nk0BB3nsyGc8mKEz59W5
         YZb7NCEFu+7njwiTSxbeta+6TVHabSmiO4efe9r0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 095/217] backlight: pwm_bl: Improve bootloader/kernel device handover
Date:   Mon, 20 Sep 2021 18:41:56 +0200
Message-Id: <20210920163927.857122329@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Thompson <daniel.thompson@linaro.org>

commit 79fad92f2e596f5a8dd085788a24f540263ef887 upstream.

Currently there are (at least) two problems in the way pwm_bl starts
managing the enable_gpio pin. Both occur when the backlight is initially
off and the driver finds the pin not already in output mode and, as a
result, unconditionally switches it to output-mode and asserts the signal.

Problem 1: This could cause the backlight to flicker since, at this stage
in driver initialisation, we have no idea what the PWM and regulator are
doing (an unconfigured PWM could easily "rest" at 100% duty cycle).

Problem 2: This will cause us not to correctly honour the
post_pwm_on_delay (which also risks flickers).

Fix this by moving the code to configure the GPIO output mode until after
we have examines the handover state. That allows us to initialize
enable_gpio to off if the backlight is currently off and on if the
backlight is on.

Cc: stable@vger.kernel.org
Reported-by: Marek Vasut <marex@denx.de>
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Acked-by: Marek Vasut <marex@denx.de>
Tested-by: Marek Vasut <marex@denx.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/backlight/pwm_bl.c |   54 ++++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 26 deletions(-)

--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -199,6 +199,33 @@ static int pwm_backlight_parse_dt(struct
 static int pwm_backlight_initial_power_state(const struct pwm_bl_data *pb)
 {
 	struct device_node *node = pb->dev->of_node;
+	bool active = true;
+
+	/*
+	 * If the enable GPIO is present, observable (either as input
+	 * or output) and off then the backlight is not currently active.
+	 * */
+	if (pb->enable_gpio && gpiod_get_value_cansleep(pb->enable_gpio) == 0)
+		active = false;
+
+	if (!regulator_is_enabled(pb->power_supply))
+		active = false;
+
+	if (!pwm_is_enabled(pb->pwm))
+		active = false;
+
+	/*
+	 * Synchronize the enable_gpio with the observed state of the
+	 * hardware.
+	 */
+	if (pb->enable_gpio)
+		gpiod_direction_output(pb->enable_gpio, active);
+
+	/*
+	 * Do not change pb->enabled here! pb->enabled essentially
+	 * tells us if we own one of the regulator's use counts and
+	 * right now we do not.
+	 */
 
 	/* Not booted with device tree or no phandle link to the node */
 	if (!node || !node->phandle)
@@ -210,20 +237,7 @@ static int pwm_backlight_initial_power_s
 	 * assume that another driver will enable the backlight at the
 	 * appropriate time. Therefore, if it is disabled, keep it so.
 	 */
-
-	/* if the enable GPIO is disabled, do not enable the backlight */
-	if (pb->enable_gpio && gpiod_get_value_cansleep(pb->enable_gpio) == 0)
-		return FB_BLANK_POWERDOWN;
-
-	/* The regulator is disabled, do not enable the backlight */
-	if (!regulator_is_enabled(pb->power_supply))
-		return FB_BLANK_POWERDOWN;
-
-	/* The PWM is disabled, keep it like this */
-	if (!pwm_is_enabled(pb->pwm))
-		return FB_BLANK_POWERDOWN;
-
-	return FB_BLANK_UNBLANK;
+	return active ? FB_BLANK_UNBLANK: FB_BLANK_POWERDOWN;
 }
 
 static int pwm_backlight_probe(struct platform_device *pdev)
@@ -300,18 +314,6 @@ static int pwm_backlight_probe(struct pl
 		pb->enable_gpio = gpio_to_desc(data->enable_gpio);
 	}
 
-	/*
-	 * If the GPIO is not known to be already configured as output, that
-	 * is, if gpiod_get_direction returns either 1 or -EINVAL, change the
-	 * direction to output and set the GPIO as active.
-	 * Do not force the GPIO to active when it was already output as it
-	 * could cause backlight flickering or we would enable the backlight too
-	 * early. Leave the decision of the initial backlight state for later.
-	 */
-	if (pb->enable_gpio &&
-	    gpiod_get_direction(pb->enable_gpio) != 0)
-		gpiod_direction_output(pb->enable_gpio, 1);
-
 	pb->power_supply = devm_regulator_get(&pdev->dev, "power");
 	if (IS_ERR(pb->power_supply)) {
 		ret = PTR_ERR(pb->power_supply);


