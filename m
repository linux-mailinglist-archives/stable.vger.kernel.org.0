Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D53462F73
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 10:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236095AbhK3JZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 04:25:08 -0500
Received: from twspam01.aspeedtech.com ([211.20.114.71]:50974 "EHLO
        twspam01.aspeedtech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240121AbhK3JZI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 04:25:08 -0500
Received: from mail.aspeedtech.com ([192.168.0.24])
        by twspam01.aspeedtech.com with ESMTP id 1AU8uNuZ069770;
        Tue, 30 Nov 2021 16:56:23 +0800 (GMT-8)
        (envelope-from billy_tsai@aspeedtech.com)
Received: from BillyTsai-pc.aspeed.com (192.168.2.149) by TWMBX02.aspeed.com
 (192.168.0.24) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 30 Nov
 2021 17:20:54 +0800
From:   Billy Tsai <billy_tsai@aspeedtech.com>
To:     <b.zolnierkie@samsung.com>, <jdelvare@suse.com>,
        <linux@roeck-us.net>, <u.kleine-koenig@pengutronix.de>,
        <linux-hwmon@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <BMC-SW@aspeedtech.com>, <stable@vger.kernel.org>
Subject: [PATCH] hwmon: (pwm-fan) Ensure the fan going on in .probe()
Date:   Tue, 30 Nov 2021 17:22:12 +0800
Message-ID: <20211130092212.17783-1-billy_tsai@aspeedtech.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.2.149]
X-ClientProxiedBy: TWMBX02.aspeed.com (192.168.0.24) To TWMBX02.aspeed.com
 (192.168.0.24)
X-DNSRBL: 
X-MAIL: twspam01.aspeedtech.com 1AU8uNuZ069770
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Before commit 86585c61972f ("hwmon: (pwm-fan) stop using legacy
PWM functions and some cleanups") pwm_apply_state() was called
unconditionally in pwm_fan_probe(). In this commit this direct
call was replaced by a call to __set_pwm(ct, MAX_PWM) which
however is a noop if ctx->pwm_value already matches the value to
set.
After probe the fan is supposed to run at full speed, and the
internal driver state suggests it does, but this isn't asserted
and depending on bootloader and pwm low-level driver, the fan
might just be off.
So drop setting pwm_value to MAX_PWM to ensure the check in
__set_pwm doesn't make it exit early and the fan goes on as
intended.

Cc: stable@vger.kernel.org
Fixes: 86585c61972f ("hwmon: (pwm-fan) stop using legacy PWM functions and some cleanups")
Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
---
 drivers/hwmon/pwm-fan.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/hwmon/pwm-fan.c b/drivers/hwmon/pwm-fan.c
index 17518b4cab1b..f12b9a28a232 100644
--- a/drivers/hwmon/pwm-fan.c
+++ b/drivers/hwmon/pwm-fan.c
@@ -336,8 +336,6 @@ static int pwm_fan_probe(struct platform_device *pdev)
 			return ret;
 	}
 
-	ctx->pwm_value = MAX_PWM;
-
 	pwm_init_state(ctx->pwm, &ctx->pwm_state);
 
 	/*
-- 
2.25.1

