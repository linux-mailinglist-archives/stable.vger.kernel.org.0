Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D7B2B5FE2
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbgKQM7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 07:59:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:54132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727685AbgKQM5U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 07:57:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EBD12467A;
        Tue, 17 Nov 2020 12:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605617839;
        bh=aYS2f1e6fLmruGW0G06TxwfCvJ1cA7p5SDkLwRweTKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1X86R/a6jKYR/jso+a5MS+Bl/K3VPdgy60amO1ej37emUmYQIRAPNAzOjfVNL5UwB
         rkrtdrEhUZxc2if7hOaE4iJm3eUtds1CgqZdkCDcZtYLOC98CRIfey+OdV7F3vVzqD
         sM3gYp5PJc0o06vsIXL5mzSH2IpaH0lA+pdSQPMs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Barker <pbarker@konsulko.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 17/21] hwmon: (pwm-fan) Fix RPM calculation
Date:   Tue, 17 Nov 2020 07:56:48 -0500
Message-Id: <20201117125652.599614-17-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201117125652.599614-1-sashal@kernel.org>
References: <20201117125652.599614-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

