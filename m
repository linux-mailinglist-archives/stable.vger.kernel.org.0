Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F29F1CF302
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 13:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgELLAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 07:00:53 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55013 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727859AbgELLAx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 May 2020 07:00:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589281252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=tQSc1TJDaYwxYLceWP29iPDKblot1rwfivc0kNtIR+o=;
        b=VPW44cq9o4e07lxFH6YAzsTFENIMs6MwDOfyK6TCiybSf8g5gbqeORsjTfRW9W1+nC7QEE
        XlEeHjYWN7O6Pe6ta3xPWDgTcD77frMJCScntzsAipAbLdRVQIlM08RG8ZulTIUVCnXPAb
        D+wHbw0RFGk2rYGQ0/H9AXnpfmxjs1g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-Xu03e-A9OeWDOLi_le5K1A-1; Tue, 12 May 2020 07:00:48 -0400
X-MC-Unique: Xu03e-A9OeWDOLi_le5K1A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 080618018A7;
        Tue, 12 May 2020 11:00:47 +0000 (UTC)
Received: from x1.localdomain.com (ovpn-113-117.ams2.redhat.com [10.36.113.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7CBAB78B21;
        Tue, 12 May 2020 11:00:45 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Thierry Reding <thierry.reding@gmail.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-pwm@vger.kernel.org, linux-acpi@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] pwm: lpss: Fix get_state runtime-pm reference handling
Date:   Tue, 12 May 2020 13:00:44 +0200
Message-Id: <20200512110044.95984-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
2.26.0

