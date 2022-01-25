Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9E1849B418
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 13:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383702AbiAYMjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 07:39:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383382AbiAYMeq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 07:34:46 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE3AC06176C;
        Tue, 25 Jan 2022 04:34:42 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id w11so7448883wra.4;
        Tue, 25 Jan 2022 04:34:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7KQ9zYLdW+k4aKNdv2IbRYPTwBUiRRe1pTBMQGoDkYs=;
        b=fWWE2KtG+RYLfi/zSpVoSjx9LzMWqpmeU8l/xXBfj3fDeXKdF2DnYo9XUdRzF3r0kB
         d43p02IIrfGE6IQKdXWzXpoZgKeOJYGlghHdGVN3mGLbuOsg0a6DCtTi3B1xE3Sy/4mJ
         7T6Jf6gvcH4V4W8EZ/Yngt7lLja9evs/+mFgrhUXK2ojo6YWOKos/Q47TaL2gcrX11rH
         yVAHduKiVtAUI765sh/B9inAVtHDhxOdnsC2bgYgA5r+NozA1KckQsgeMC3aS+H9Q9mR
         xYznYL8Y8oh/nbNIwabY4MV2MuPVvKjL7YIhhyAe8E6Is9P0mHouRicJ4lkgRXRBQ0LJ
         BviQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7KQ9zYLdW+k4aKNdv2IbRYPTwBUiRRe1pTBMQGoDkYs=;
        b=f8CPOtB9Py0G6eaqm3+ZtFLkVRHS/TUi5KJgDvf11RHKXB/wqc7Bxdor+G1v+1t4XS
         GPNYYkaOIEQHU34KV3Oktg3wOIbbYXrAXCQDKTSiQjINibl5IY+zWj2oGQTBKR+dd9gn
         tHlpjlipQfyoKsRhzirskIw9ZChZ6HA1iTqD5PJ8MpgjRiHqOjKozIy06oAJOTYY+jcs
         VAPtL52R7rSzzacazPe08iY62r0VlywCO5jQpyl01CeRYhLWoC/HkCv15UOwn8Y4bVK5
         p6HxL/uFiom3attIXCCWLAMOT2H8yHgNvml67qutsQ9ewsbr3PWg1SHslcyzc/p0HoIt
         hJ1w==
X-Gm-Message-State: AOAM531zE2+o2pHEYBhnps+J8FEDOjh/vEGs6aqdMdlcNmBK+pvcu+1p
        wuwh06yn8PX4IQSQuPcYfvaR8ztOqMM=
X-Google-Smtp-Source: ABdhPJyzZP4+E2xWuSCnFYnHmJMyTjNijsc2IK5BN1bQTczUgycsgCjn2bRkcJyxBkSMLHp+m7v0aQ==
X-Received: by 2002:a5d:6d04:: with SMTP id e4mr8301944wrq.398.1643114081426;
        Tue, 25 Jan 2022 04:34:41 -0800 (PST)
Received: from heron.intern.cm-ag (p200300dc6f046a000000000000000fd2.dip0.t-ipconnect.de. [2003:dc:6f04:6a00::fd2])
        by smtp.gmail.com with ESMTPSA id e10sm1558633wrq.53.2022.01.25.04.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 04:34:40 -0800 (PST)
From:   Max Kellermann <max.kellermann@gmail.com>
To:     linux-pwm@vger.kernel.org, thierry.reding@gmail.com,
        u.kleine-koenig@pengutronix.de, lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, andrey@lebedev.lt,
        Max Kellermann <max.kellermann@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH 3/3] pwm-sun4i: calculate the delay without rounding down to jiffies
Date:   Tue, 25 Jan 2022 13:34:29 +0100
Message-Id: <20220125123429.3490883-3-max.kellermann@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20220125123429.3490883-1-max.kellermann@gmail.com>
References: <20220125123429.3490883-1-max.kellermann@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This fixes a problem that was supposed to be addressed by commit
6eefb79d6f5bc ("pwm: sun4i: Remove erroneous else branch") - backlight
could not be switched off on some Allwinner A20.  The commit was
correct, but was not a reliable fix for the problem, which was timing
related.

The real problem for the backlight switching problem was that sleeping
for a full period did not work, because delay_us is always zero.

It is zero because the period (plus 1 microsecond) is rounded down to
the next "jiffies", but the period is less than one jiffy.

On my Cubieboard 2, the period is 5ms, and 1 jiffy (at the default
HZ=100) is 10ms, so nsecs_to_jiffies(10ms+1us)=0.

The roundtrip from nanoseconds to jiffies and back to microseconds is
an unnecessary loss of precision; always rounding down (via
nsecs_to_jiffies()) then causes the breakage.

This patch eliminates this roundtrip, and directly converts from
nanoseconds to microseconds (for usleep_range()), using
DIV_ROUND_UP_ULL() to force rounding up.  This way, the sleep time is
never zero, and after the sleep, we are guaranteed to be in a
different period, and the device is ready for another control command
for sure.

Cc: stable@vger.kernel.org
Signed-off-by: Max Kellermann <max.kellermann@gmail.com>
---
 drivers/pwm/pwm-sun4i.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pwm/pwm-sun4i.c b/drivers/pwm/pwm-sun4i.c
index b44deececb8b..8527a655034c 100644
--- a/drivers/pwm/pwm-sun4i.c
+++ b/drivers/pwm/pwm-sun4i.c
@@ -234,7 +234,6 @@ static int sun4i_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	struct pwm_state cstate;
 	u32 ctrl, duty = 0, period = 0, val;
 	int ret;
-	unsigned int delay_jiffies;
 	unsigned int delay_us, prescaler = 0;
 	bool bypass;
 
@@ -302,8 +301,7 @@ static int sun4i_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 		return 0;
 
 	/* We need a full period to elapse before disabling the channel. */
-	delay_jiffies = nsecs_to_jiffies(cstate.period + 1000);
-	delay_us = jiffies_to_usecs(delay_jiffies);
+	delay_us = DIV_ROUND_UP_ULL(cstate.period, NSEC_PER_USEC);
 	if ((delay_us / 500) > MAX_UDELAY_MS)
 		msleep(delay_us / 1000 + 1);
 	else
-- 
2.34.0

