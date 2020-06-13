Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573E11F825D
	for <lists+stable@lfdr.de>; Sat, 13 Jun 2020 12:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgFMKAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jun 2020 06:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgFMKAd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Jun 2020 06:00:33 -0400
X-Greylist: delayed 47709 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 13 Jun 2020 03:00:32 PDT
Received: from sw.superlogical.ch (sw.superlogical.ch [IPv6:2a03:4000:9:189::4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F833C03E96F
        for <stable@vger.kernel.org>; Sat, 13 Jun 2020 03:00:32 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A7878C2310;
        Sat, 13 Jun 2020 12:00:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hb9fxq.ch; s=default;
        t=1592042424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wcKQaaOnaE7mAScuMcNL3tTGjW0JaYqWnYsBtGYhorc=;
        b=znAH3jDeSNDFUXUzTfUsl3/8KA65LOcw/bqZrVD48fn4rb0JikwHTH7kxpUAD8KNW/lGLE
        ckKG8WkG8YAJxQMJD03h+xmXzRuP8T1H1FVSZI10k+61CqbEbwApP/5v+DLvexOdMZPEVS
        6HdaOw0dgAmVNhUgdXt1G1EO9nVtpjEFrbim8vgNnprUoB1Mns07LcECL7nYd8vlYVdjQ4
        KLye6a1w5hw7/FPWysZtiTwDqWLONc/t2GQf2yvI7QyLoNGP/ojWTpIRNlDCBx1ICS052G
        4YcsA0R8lBqIfVlat/Hbkmi2V8l9kWggOcXDLKQa0JsWe3Y6XoEcMT8P1b+3Ew==
From:   Frank Werner-Krippendorf <mail@hb9fxq.ch>
To:     mail@kripp.ch
Cc:     Hans de Goede <hdegoede@redhat.com>, stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH 05/17] pwm: lpss: Fix get_state runtime-pm reference handling
Date:   Sat, 13 Jun 2020 12:00:04 +0200
Message-Id: <20200613100016.17808-5-mail@hb9fxq.ch>
In-Reply-To: <20200613100016.17808-1-mail@hb9fxq.ch>
References: <20200613100016.17808-1-mail@hb9fxq.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

Before commit cfc4c189bc70 ("pwm: Read initial hardware state at request
time"), a driver's get_state callback would get called once per PWM from
pwmchip_add().

pwm-lpss' runtime-pm code was relying on this, getting a runtime-pm ref for
PWMs which are enabled at probe time from within its get_state callback,
before enabling runtime-pm.

The change to calling get_state at request time causes a number of
problems:

1. PWMs enabled at probe time may get runtime suspended before they are
requested, causing e.g. a LCD backlight controlled by the PWM to turn off.

2. When the request happens when the PWM has been runtime suspended, the
ctrl register will read all 1 / 0xffffffff, causing get_state to store
bogus values in the pwm_state.

3. get_state was using an async pm_runtime_get() call, because it assumed
that runtime-pm has not been enabled yet. If shortly after the request an
apply call is made, then the pwm_lpss_is_updating() check may trigger
because the resume triggered by the pm_runtime_get() call is not complete
yet, so the ctrl register still reads all 1 / 0xffffffff.

This commit fixes these issues by moving the initial pm_runtime_get() call
for PWMs which are enabled at probe time to the pwm_lpss_probe() function;
and by making get_state take a runtime-pm ref before reading the ctrl reg.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1828927
Fixes: cfc4c189bc70 ("pwm: Read initial hardware state at request time")
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
---
 drivers/pwm/pwm-lpss.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/pwm/pwm-lpss.c b/drivers/pwm/pwm-lpss.c
index 75bbfe5f3bc2..9d965ffe66d1 100644
--- a/drivers/pwm/pwm-lpss.c
+++ b/drivers/pwm/pwm-lpss.c
@@ -158,7 +158,6 @@ static int pwm_lpss_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	return 0;
 }
 
-/* This function gets called once from pwmchip_add to get the initial state */
 static void pwm_lpss_get_state(struct pwm_chip *chip, struct pwm_device *pwm,
 			       struct pwm_state *state)
 {
@@ -167,6 +166,8 @@ static void pwm_lpss_get_state(struct pwm_chip *chip, struct pwm_device *pwm,
 	unsigned long long base_unit, freq, on_time_div;
 	u32 ctrl;
 
+	pm_runtime_get_sync(chip->dev);
+
 	base_unit_range = BIT(lpwm->info->base_unit_bits);
 
 	ctrl = pwm_lpss_read(pwm);
@@ -187,8 +188,7 @@ static void pwm_lpss_get_state(struct pwm_chip *chip, struct pwm_device *pwm,
 	state->polarity = PWM_POLARITY_NORMAL;
 	state->enabled = !!(ctrl & PWM_ENABLE);
 
-	if (state->enabled)
-		pm_runtime_get(chip->dev);
+	pm_runtime_put(chip->dev);
 }
 
 static const struct pwm_ops pwm_lpss_ops = {
@@ -202,7 +202,8 @@ struct pwm_lpss_chip *pwm_lpss_probe(struct device *dev, struct resource *r,
 {
 	struct pwm_lpss_chip *lpwm;
 	unsigned long c;
-	int ret;
+	int i, ret;
+	u32 ctrl;
 
 	if (WARN_ON(info->npwm > MAX_PWMS))
 		return ERR_PTR(-ENODEV);
@@ -232,6 +233,12 @@ struct pwm_lpss_chip *pwm_lpss_probe(struct device *dev, struct resource *r,
 		return ERR_PTR(ret);
 	}
 
+	for (i = 0; i < lpwm->info->npwm; i++) {
+		ctrl = pwm_lpss_read(&lpwm->chip.pwms[i]);
+		if (ctrl & PWM_ENABLE)
+			pm_runtime_get(dev);
+	}
+
 	return lpwm;
 }
 EXPORT_SYMBOL_GPL(pwm_lpss_probe);
-- 
2.20.1

