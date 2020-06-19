Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11FC62010C8
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403876AbgFSPdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:33:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404895AbgFSPdD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:33:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A984B2166E;
        Fri, 19 Jun 2020 15:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580782;
        bh=thQfZr/q8RAdyDUbyWCNv25/gg/BpfzE787BTka3u6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=An3xlAUc7TfD/GJVt6wTHmoNH2wkRHeSgIKerGjpFXsS0TWMJlIbgtW4E9bJQ0hf9
         YRfCChW2PEcQdSbn9e0pCG0rKskRPWx0EF+doKaFz39fwhJcMAuu5PaPS9eCCYq+04
         oOO0n26YgoHFHh/vMtvibrN88GZDzFq1iRGzbCRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH 5.7 350/376] pwm: lpss: Fix get_state runtime-pm reference handling
Date:   Fri, 19 Jun 2020 16:34:28 +0200
Message-Id: <20200619141726.893185565@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 01aa905d4791da7d3630f6030ff99d58105cca00 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pwm/pwm-lpss.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/pwm/pwm-lpss.c
+++ b/drivers/pwm/pwm-lpss.c
@@ -158,7 +158,6 @@ static int pwm_lpss_apply(struct pwm_chi
 	return 0;
 }
 
-/* This function gets called once from pwmchip_add to get the initial state */
 static void pwm_lpss_get_state(struct pwm_chip *chip, struct pwm_device *pwm,
 			       struct pwm_state *state)
 {
@@ -167,6 +166,8 @@ static void pwm_lpss_get_state(struct pw
 	unsigned long long base_unit, freq, on_time_div;
 	u32 ctrl;
 
+	pm_runtime_get_sync(chip->dev);
+
 	base_unit_range = BIT(lpwm->info->base_unit_bits);
 
 	ctrl = pwm_lpss_read(pwm);
@@ -187,8 +188,7 @@ static void pwm_lpss_get_state(struct pw
 	state->polarity = PWM_POLARITY_NORMAL;
 	state->enabled = !!(ctrl & PWM_ENABLE);
 
-	if (state->enabled)
-		pm_runtime_get(chip->dev);
+	pm_runtime_put(chip->dev);
 }
 
 static const struct pwm_ops pwm_lpss_ops = {
@@ -202,7 +202,8 @@ struct pwm_lpss_chip *pwm_lpss_probe(str
 {
 	struct pwm_lpss_chip *lpwm;
 	unsigned long c;
-	int ret;
+	int i, ret;
+	u32 ctrl;
 
 	if (WARN_ON(info->npwm > MAX_PWMS))
 		return ERR_PTR(-ENODEV);
@@ -232,6 +233,12 @@ struct pwm_lpss_chip *pwm_lpss_probe(str
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


