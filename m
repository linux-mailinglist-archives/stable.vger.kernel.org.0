Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4909813E495
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389652AbgAPRJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:09:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:44864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389646AbgAPRJS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:09:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FDEB205F4;
        Thu, 16 Jan 2020 17:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194557;
        bh=Us2oXtdbboe0sr3+v+28oDWDxQ0tEGkRNRlLlWzXMIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KjAwXYZcaI0IjcJ9iLeNmboVk2M+YaDOVs0WQY9T89RJMoZssIxvY8W8iA4+fJDfb
         MQ/p7/kz8CHV+oIheNInIqcYbpMR18r4ZcVNUuV6pey4Ts/XCbUQuy5vYY3L5RYBlL
         oZuvDfOfYbG07RyeCx5anifSrxIMIxhb439B9CAU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matthias Kaehlcke <mka@chromium.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pwm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 438/671] backlight: pwm_bl: Fix heuristic to determine number of brightness levels
Date:   Thu, 16 Jan 2020 12:01:16 -0500
Message-Id: <20200116170509.12787-175-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Kaehlcke <mka@chromium.org>

[ Upstream commit 73fbfc499448455f1e1c77717040e09e25f1d976 ]

With commit 88ba95bedb79 ("backlight: pwm_bl: Compute brightness of
LED linearly to human eye") the number of set bits (aka hweight())
in the PWM period is used in the heuristic to determine the number
of brightness levels, when the brightness table isn't specified in
the DT. The number of set bits doesn't provide a reliable clue about
the length of the period, instead change the heuristic to:

 nlevels = period / fls(period)

Also limit the maximum number of brightness levels to 4096 to avoid
excessively large tables.

With this the number of levels increases monotonically with the PWM
period, until the maximum of 4096 levels is reached:

period (ns)    # levels

100    	       16
500	       62
1000	       111
5000	       416
10000	       769
50000	       3333
100000	       4096

Fixes: 88ba95bedb79 ("backlight: pwm_bl: Compute brightness of LED linearly to human eye")
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Acked-by: Daniel Thompson <daniel.thompson@linaro.org>
Tested-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/pwm_bl.c | 24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 7ddc0930e98c..3a3098d4873b 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -199,29 +199,17 @@ int pwm_backlight_brightness_default(struct device *dev,
 				     struct platform_pwm_backlight_data *data,
 				     unsigned int period)
 {
-	unsigned int counter = 0;
-	unsigned int i, n;
+	unsigned int i;
 	u64 retval;
 
 	/*
-	 * Count the number of bits needed to represent the period number. The
-	 * number of bits is used to calculate the number of levels used for the
-	 * brightness-levels table, the purpose of this calculation is have a
-	 * pre-computed table with enough levels to get linear brightness
-	 * perception. The period is divided by the number of bits so for a
-	 * 8-bit PWM we have 255 / 8 = 32 brightness levels or for a 16-bit PWM
-	 * we have 65535 / 16 = 4096 brightness levels.
-	 *
-	 * Note that this method is based on empirical testing on different
-	 * devices with PWM of 8 and 16 bits of resolution.
+	 * Once we have 4096 levels there's little point going much higher...
+	 * neither interactive sliders nor animation benefits from having
+	 * more values in the table.
 	 */
-	n = period;
-	while (n) {
-		counter += n % 2;
-		n >>= 1;
-	}
+	data->max_brightness =
+		min((int)DIV_ROUND_UP(period, fls(period)), 4096);
 
-	data->max_brightness = DIV_ROUND_UP(period, counter);
 	data->levels = devm_kcalloc(dev, data->max_brightness,
 				    sizeof(*data->levels), GFP_KERNEL);
 	if (!data->levels)
-- 
2.20.1

