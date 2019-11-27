Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8470C10BD7C
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731187AbfK0U50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:57:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:48492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729717AbfK0U50 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:57:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0261A21850;
        Wed, 27 Nov 2019 20:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888245;
        bh=pHdX6CY6Rf7zrpKNhcJf+fkTXPMjxTYy8EVKOPNPvA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RAtoEdtei/cK51XFDuRQng4NwaDN+2+kCRCU0xIIRu0GqG+y5uaPEmCOZ5fIgZVb/
         Y/++T0yaCtrOu/GCWmCkQ23YAOp1GM1HIWEJw98YWVdZYB41TDwAZqe7mutTMsmfPm
         QLX+H8orz0+JfOX6eQLm5wrJlvNRLzMR6LCSEEJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 061/306] pwm: lpss: Only set update bit if we are actually changing the settings
Date:   Wed, 27 Nov 2019 21:28:31 +0100
Message-Id: <20191127203119.213170315@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 2153bbc12f77fb2203276befc0f0dddbfb023bb1 ]

According to the datasheet the update bit must be set if the on-time-div
or the base-unit changes.

Now that we properly order device resume on Cherry Trail so that the GFX0
_PS0 method no longer exits with an error, we end up with a sequence of
events where we are writing the same values twice in a row.

First the _PS0 method restores the duty cycle of 0% the GPU driver set
on suspend and then the GPU driver first updates just the enabled bit in
the pwm_state from 0 to 1, causing us to write the same values again,
before restoring the pre-suspend duty-cycle in a separate pwm_apply call.

When writing the update bit the second time, without changing any of
the values the update bit clears immediately / instantly, instead of
staying 1 for a while as usual. After this the next setting of the update
bit seems to be ignored, causing the restoring of the pre-suspend
duty-cycle to not get applied. This makes the backlight come up with
a 0% dutycycle after suspend/resume.

Any further brightness changes after this do work.

This commit moves the setting of the update bit into pwm_lpss_prepare()
and only sets the bit if we have actually changed any of the values.

This avoids the setting of the update bit the second time we configure
the PWM to 0% dutycycle, this fixes the backlight coming up with 0%
duty-cycle after a suspend/resume.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-lpss.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/pwm/pwm-lpss.c b/drivers/pwm/pwm-lpss.c
index 4721a264bac25..1e69c1c9ec096 100644
--- a/drivers/pwm/pwm-lpss.c
+++ b/drivers/pwm/pwm-lpss.c
@@ -97,7 +97,7 @@ static void pwm_lpss_prepare(struct pwm_lpss_chip *lpwm, struct pwm_device *pwm,
 	unsigned long long on_time_div;
 	unsigned long c = lpwm->info->clk_rate, base_unit_range;
 	unsigned long long base_unit, freq = NSEC_PER_SEC;
-	u32 ctrl;
+	u32 orig_ctrl, ctrl;
 
 	do_div(freq, period_ns);
 
@@ -114,13 +114,17 @@ static void pwm_lpss_prepare(struct pwm_lpss_chip *lpwm, struct pwm_device *pwm,
 	do_div(on_time_div, period_ns);
 	on_time_div = 255ULL - on_time_div;
 
-	ctrl = pwm_lpss_read(pwm);
+	orig_ctrl = ctrl = pwm_lpss_read(pwm);
 	ctrl &= ~PWM_ON_TIME_DIV_MASK;
 	ctrl &= ~(base_unit_range << PWM_BASE_UNIT_SHIFT);
 	base_unit &= base_unit_range;
 	ctrl |= (u32) base_unit << PWM_BASE_UNIT_SHIFT;
 	ctrl |= on_time_div;
-	pwm_lpss_write(pwm, ctrl);
+
+	if (orig_ctrl != ctrl) {
+		pwm_lpss_write(pwm, ctrl);
+		pwm_lpss_write(pwm, ctrl | PWM_SW_UPDATE);
+	}
 }
 
 static inline void pwm_lpss_cond_enable(struct pwm_device *pwm, bool cond)
@@ -144,7 +148,6 @@ static int pwm_lpss_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 				return ret;
 			}
 			pwm_lpss_prepare(lpwm, pwm, state->duty_cycle, state->period);
-			pwm_lpss_write(pwm, pwm_lpss_read(pwm) | PWM_SW_UPDATE);
 			pwm_lpss_cond_enable(pwm, lpwm->info->bypass == false);
 			ret = pwm_lpss_wait_for_update(pwm);
 			if (ret) {
@@ -157,7 +160,6 @@ static int pwm_lpss_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 			if (ret)
 				return ret;
 			pwm_lpss_prepare(lpwm, pwm, state->duty_cycle, state->period);
-			pwm_lpss_write(pwm, pwm_lpss_read(pwm) | PWM_SW_UPDATE);
 			return pwm_lpss_wait_for_update(pwm);
 		}
 	} else if (pwm_is_enabled(pwm)) {
-- 
2.20.1



