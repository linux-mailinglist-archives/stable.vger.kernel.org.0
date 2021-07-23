Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F7E3D3901
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 13:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbhGWKX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 06:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231682AbhGWKX2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 06:23:28 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602E9C061575
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 04:04:02 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id a80-20020a1c98530000b0290245467f26a4so1418640wme.0
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 04:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zS2GWn48je0bjrRKkqgGo/XGjFxQUky99Wi4nJkA+88=;
        b=G7PfQVwbTct99uIkTWzMyoXTLraDkSlKbm/Xbh7VjFeJGaKm6pqms2ifNfSHPFHUPa
         sx5cJj87jyfUixwhlYOzFnfk7JLUPpTlKiJoggiiQEQ8MYMKe3ueLtY9DY8R0IjoesLc
         ixq4b15VCtZpnoJhN/lkrqlrQjbN4UEt2PXvj/CWEHF9sA9gM7F+pdcEKGQNvYh+SYpF
         AY6nnT4cBdmbYVtTirbReGkptGvI48FYtp8TjFPrQ4dKkZKSMsxVCguOHepAR5jV2bOh
         BZdBuT4YOS4PKlCS9tbC9HZG4PT8saRMG/AbkhI0qn/y352UmjCA9Rj4uRr0288B4Jrl
         sdnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zS2GWn48je0bjrRKkqgGo/XGjFxQUky99Wi4nJkA+88=;
        b=HA93aUhfoO0F8ZeNREZJr157IVjrelad9fWnM8KuHJptiuWiK1Lj+TXFYVXmpj6DbZ
         En1lY4QA1Vwd3y9XpHjLbtmVIoQFDFUI4ipb7R2RcfZ09tjZ8MOQIxwaS52PatmU8m2w
         dDSSBd51Jw0ZHV4KJQWSkpnCY3tswvj4zlDLf8b7954AcmYw8YHo7JbjhtYaa+erguuI
         IYaNyOLQGAYOrxjGqCg6xPzMKzkcfIVAOTnZ5fqeBZRnsxXqY4sYdMYFf+Y+A1979qeF
         y+qUCjU4SJGfL5AtS+c9PwhJ6C69Th5NhSgyAL6fuhaigqr/rACm83cBqXjw1SqrxZlz
         6pNA==
X-Gm-Message-State: AOAM533Kl7lLatuCpb2dsbz0VVnRVLzeb1hB4e1KyLS1ivN2r6H01hsE
        mBsG7D0EWri80T6YteBm856kRg==
X-Google-Smtp-Source: ABdhPJwXjYd/l4dQLMWFtE8wkIOw/4pJFY+8TKTo/OL8hFIe/dm7K2TB2C3x4d1nl4jaIOXOk4Dlaw==
X-Received: by 2002:a1c:9851:: with SMTP id a78mr13505101wme.33.1627038240862;
        Fri, 23 Jul 2021 04:04:00 -0700 (PDT)
Received: from maple.lan (cpc141216-aztw34-2-0-cust174.18-1.cable.virginm.net. [80.7.220.175])
        by smtp.gmail.com with ESMTPSA id w18sm35025315wrg.68.2021.07.23.04.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 04:03:59 -0700 (PDT)
From:   Daniel Thompson <daniel.thompson@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>, Jingoo Han <jingoohan1@gmail.com>
Cc:     Daniel Thompson <daniel.thompson@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, linux-pwm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marek Vasut <marex@denx.de>,
        stable@vger.kernel.org
Subject: [PATCH v3] backlight: pwm_bl: Improve bootloader/kernel device handover
Date:   Fri, 23 Jul 2021 12:03:45 +0100
Message-Id: <20210723110345.1724410-1-daniel.thompson@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210722145227.1573115-1-daniel.thompson@linaro.org>
References: <20210722145227.1573115-1-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

There has also been lots of discussion recently about how pwm_bl inherits
the initial state established by the bootloader (or by power-on reset if
the bootloader doesn't do anything to the backlight). Let's take this
chance to document the four handover cases.

Reported-by: Marek Vasut <marex@denx.de>
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: stable@vger.kernel.org
Fixes: 3698d7e7d221 ("backlight: pwm_bl: Avoid backlight flicker when probed from DT")
Acked-by: Marek Vasut <marex@denx.de>
Tested-by: Marek Vasut <marex@denx.de>
---

Notes:
    v3: Added better documentation of the different handover cases (thanks
        Marek)
    v2: Added Fixes: tag (sorry for the noise)

 drivers/video/backlight/pwm_bl.c | 110 +++++++++++++++++++++++--------
 1 file changed, 83 insertions(+), 27 deletions(-)

diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index e48fded3e414..5dda3f11129a 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -406,9 +406,90 @@ static bool pwm_backlight_is_linear(struct platform_pwm_backlight_data *data)
 	return true;
 }

+/*
+ * Inherit the initial power state from the hardware.
+ *
+ * This function provides the features necessary to achieve a flicker-free boot
+ * sequence regardless of the initial state of the backlight.
+ *
+ * There are two factors that affect the behaviour of this function.
+ *
+ * 1. Whether the backlight was on or off when the kernel was booted.  We
+ *    currently determine the state of the backlight by checking if the PWM is
+ *    enabled, whether the regulator (if there is one) is enabled and whether
+ *    the enable_gpio (if there is one) is asserted.  All must be enabled for
+ *    the backlight to be on.
+ *
+ * 2. Whether the backlight is linked to a display device. This matters because
+ *    when there is a linked display is will automatically handle the
+ *    backlight as part of its own blank/unblanking.
+ *
+ * This gives us four possible cases.
+ *
+ * Backlight initially off, display linked:
+ *
+ *   The backlight must remain off (a.k.a. FB_BLANK_POWERDOWN) during and after
+ *   the backlight probe. This allows a splash screen to be drawn before the
+ *   backlight is enabled by the display driver. This avoids a flicker when the
+ *   backlight comes on (which typically changes the black level slightly)
+ *   before the splash image has been drawn.
+ *
+ * Backlight initially on, display linked:
+ *
+ *   The backlight must remain on (a.k.a. FB_BLANK_UNBLANK) during and after
+ *   the backlight probe.  This allows a bootloader to show a splash screen and
+ *   for the display system (including the backlight) to continue showing the
+ *   splash image until the kernel is ready to take over the display and draw
+ *   something else.
+ *
+ * Backlight initially off, no display:
+ *
+ *   The backlight must transition from off to on (a.k.a. FB_BLANK_UNBLANK)
+ *   during the backlight probe. This is largely a legacy case. We must
+ *   unblank the backlight at boot because some userspaces are not
+ *   capable of changing the power state of a free-standing backlight
+ *   (they only know how to set the brightness level).
+ *
+ * Backlight initially on, no display:
+ *
+ *   Identical to the initially on, display linked case.
+ *
+ * Note: In both cases where backlight is initially off then we must
+ *       explicitly deassert the enable_gpio in order to ensure we
+ *       honour the post_pwm_on_delay when the backlight is eventually
+ *       activated.  This is required regardless of both the initial state of
+ *       the enable pin and whether we intend to activate the backlight during
+ *       the probe.
+ */
 static int pwm_backlight_initial_power_state(const struct pwm_bl_data *pb)
 {
-	struct device_node *node = pb->dev->of_node;
+	struct device_node *node = pb->dev->of_node; bool active = true;
+
+	/*
+	 * If the enable GPIO is present, observable (either as input
+	 * or output) and off then the backlight is not currently active.
+	 */
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
@@ -420,20 +501,7 @@ static int pwm_backlight_initial_power_state(const struct pwm_bl_data *pb)
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
+	return active ? FB_BLANK_UNBLANK : FB_BLANK_POWERDOWN;
 }

 static int pwm_backlight_probe(struct platform_device *pdev)
@@ -486,18 +554,6 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 		goto err_alloc;
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

base-commit: 2734d6c1b1a089fb593ef6a23d4b70903526fe0c
--
2.30.2

