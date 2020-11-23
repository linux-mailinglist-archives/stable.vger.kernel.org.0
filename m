Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7272C0A06
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733176AbgKWMoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:44:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:57126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733168AbgKWMoC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:44:02 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAC34208C3;
        Mon, 23 Nov 2020 12:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135442;
        bh=aYS2f1e6fLmruGW0G06TxwfCvJ1cA7p5SDkLwRweTKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m+SN3pgJnUtEwfYfYDS6y24w6VWKh6y5mSj3TT8eXTbOu1F6LN3dK6esLSgWjdM15
         wjpuecwMC9/m4aGGlZBxZVKsu4KEWlYXNTiGvYJP3c+YoU8qBU3qLiOt7m1EAFIISL
         lMEkvUmpMG10N3M5xQnIIffzALGyPKHJh+wsjEYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Barker <pbarker@konsulko.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 069/252] hwmon: (pwm-fan) Fix RPM calculation
Date:   Mon, 23 Nov 2020 13:20:19 +0100
Message-Id: <20201123121838.919203389@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Barker <pbarker@konsulko.com>

[ Upstream commit fd8feec665fef840277515a5c2b9b7c3e3970fad ]

To convert the number of pulses counted into an RPM estimation, we need
to divide by the width of our measurement interval instead of
multiplying by it. If the width of the measurement interval is zero we
don't update the RPM value to avoid dividing by zero.

We also don't need to do 64-bit division, with 32-bits we can handle a
fan running at over 4 million RPM.

Signed-off-by: Paul Barker <pbarker@konsulko.com>
Link: https://lore.kernel.org/r/20201111164643.7087-1-pbarker@konsulko.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pwm-fan.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/hwmon/pwm-fan.c b/drivers/hwmon/pwm-fan.c
index 17bb64299bfd8..3642086498d98 100644
--- a/drivers/hwmon/pwm-fan.c
+++ b/drivers/hwmon/pwm-fan.c
@@ -54,16 +54,18 @@ static irqreturn_t pulse_handler(int irq, void *dev_id)
 static void sample_timer(struct timer_list *t)
 {
 	struct pwm_fan_ctx *ctx = from_timer(ctx, t, rpm_timer);
+	unsigned int delta = ktime_ms_delta(ktime_get(), ctx->sample_start);
 	int pulses;
-	u64 tmp;
 
-	pulses = atomic_read(&ctx->pulses);
-	atomic_sub(pulses, &ctx->pulses);
-	tmp = (u64)pulses * ktime_ms_delta(ktime_get(), ctx->sample_start) * 60;
-	do_div(tmp, ctx->pulses_per_revolution * 1000);
-	ctx->rpm = tmp;
+	if (delta) {
+		pulses = atomic_read(&ctx->pulses);
+		atomic_sub(pulses, &ctx->pulses);
+		ctx->rpm = (unsigned int)(pulses * 1000 * 60) /
+			(ctx->pulses_per_revolution * delta);
+
+		ctx->sample_start = ktime_get();
+	}
 
-	ctx->sample_start = ktime_get();
 	mod_timer(&ctx->rpm_timer, jiffies + HZ);
 }
 
-- 
2.27.0



