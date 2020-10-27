Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6304829C080
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1782146AbgJ0O4n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:56:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:57442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1782137AbgJ0O4m (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:56:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C21C72071A;
        Tue, 27 Oct 2020 14:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810602;
        bh=pNEonzz9ekuxyoltgKy746HMB6/xkaaWy32FqbccLjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x1G3QBWDpHIBxij9ni+8kg0p/ZOaMQwkbI7HjB6UnbH0yCo9/cHduIuD6KrInH1r3
         STJ4QqksG7RSmJK37/RcvTNYzp8zmlwuQIRBfCCUtsKK1pkWetRG+6FUz/Xk7ybhyA
         GrzTBWsjB3SO9L8JkGfEHnKb3TgFQRuPu+Pa6WtM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 197/633] pwm: lpss: Fix off by one error in base_unit math in pwm_lpss_prepare()
Date:   Tue, 27 Oct 2020 14:49:00 +0100
Message-Id: <20201027135531.923559446@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 181f4d2f44463fe09fe4df02e03095cb87151c29 ]

According to the data-sheet the way the PWM controller works is that
each input clock-cycle the base_unit gets added to a N bit counter and
that counter overflowing determines the PWM output frequency.

So assuming e.g. a 16 bit counter this means that if base_unit is set to 1,
after 65535 input clock-cycles the counter has been increased from 0 to
65535 and it will overflow on the next cycle, so it will overflow after
every 65536 clock cycles and thus the calculations done in
pwm_lpss_prepare() should use 65536 and not 65535.

This commit fixes this. Note this also aligns the calculations in
pwm_lpss_prepare() with those in pwm_lpss_get_state().

Note this effectively reverts commit 684309e5043e ("pwm: lpss: Avoid
potential overflow of base_unit"). The next patch in this series really
fixes the potential overflow of the base_unit value.

Fixes: 684309e5043e ("pwm: lpss: Avoid potential overflow of base_unit")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200903112337.4113-4-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-lpss.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pwm/pwm-lpss.c b/drivers/pwm/pwm-lpss.c
index 9d965ffe66d1e..43b1fc634af1a 100644
--- a/drivers/pwm/pwm-lpss.c
+++ b/drivers/pwm/pwm-lpss.c
@@ -93,7 +93,7 @@ static void pwm_lpss_prepare(struct pwm_lpss_chip *lpwm, struct pwm_device *pwm,
 	 * The equation is:
 	 * base_unit = round(base_unit_range * freq / c)
 	 */
-	base_unit_range = BIT(lpwm->info->base_unit_bits) - 1;
+	base_unit_range = BIT(lpwm->info->base_unit_bits);
 	freq *= base_unit_range;
 
 	base_unit = DIV_ROUND_CLOSEST_ULL(freq, c);
@@ -104,8 +104,8 @@ static void pwm_lpss_prepare(struct pwm_lpss_chip *lpwm, struct pwm_device *pwm,
 
 	orig_ctrl = ctrl = pwm_lpss_read(pwm);
 	ctrl &= ~PWM_ON_TIME_DIV_MASK;
-	ctrl &= ~(base_unit_range << PWM_BASE_UNIT_SHIFT);
-	base_unit &= base_unit_range;
+	ctrl &= ~((base_unit_range - 1) << PWM_BASE_UNIT_SHIFT);
+	base_unit &= (base_unit_range - 1);
 	ctrl |= (u32) base_unit << PWM_BASE_UNIT_SHIFT;
 	ctrl |= on_time_div;
 
-- 
2.25.1



