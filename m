Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02E8A49B416
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 13:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbiAYMi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 07:38:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383355AbiAYMel (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 07:34:41 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB15BC06176A;
        Tue, 25 Jan 2022 04:34:40 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id s9so3780342wrb.6;
        Tue, 25 Jan 2022 04:34:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6OAWPEyWDr+7hDA+9CSD9lvGUK7uqcFht/9bAYyx1tI=;
        b=GJ2iBuMMg3rc7pKhvRcmfe66yvZQHpb2iu2SlxeGm+GpdYkOH0ngQicdG7sDB6ituq
         CC3hE9sykx63yWoOoabfqueA43EsAJeUgWndaHgtXpmOQ+gfuM+/aR/Es1sKPSCcS9Az
         zekiaJlHncAODU6gkJHyOCU94DiaOEwD70CVrecmqlQeEK2L/Rw+GToG4V1px+xMXLXE
         pEC/4MprKsABarW0xRMJGcD7de2WfT3fKTRQIZFac8IY1JixACIkpsKl8r3dYdQ15EZZ
         kN8P4P2gTNE0tydyMNFvsmkDZn6mOlUZU/UUA+rJHA7B+l1TZ/J/RNdacys9cSqOA96K
         Quxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6OAWPEyWDr+7hDA+9CSD9lvGUK7uqcFht/9bAYyx1tI=;
        b=0a8mxCdgLIGrB14Vv0GZICE6s010DR0kEr2G2hxBs0XUCzynICDd33TBPbMOh/qotj
         zESy5rR6QR4tnXacccoijtCD73qCoRsBnF/1ukg0AP+4K/vXDTGQqcN6kzca6jVg/dY3
         ooI8G2JgpUayg6J2hVXNwC7GeVXLHEjx7H8mtuhzQbum3+5bG/HnNRqy+VoIcDgQXvED
         wadwZwbY2dNBzNOaYx1GZsLXFpURkEQplq9HdhxvC9qmzRG73jW+hzP03JmLMAu2snRS
         wbdEN75dqSiWb93IHf5oeb6bZDR+hqHfahTxfLiyfvC7oRUlClTuU5+iIaw5bs3WDPA4
         8JEA==
X-Gm-Message-State: AOAM533fikDsFQ4Yav1pX4ZHltEt91xOEKXoJHP5Slsbgr2C8SX7hqcs
        lRsy0nYPe81XQX92I4XZ8g+tHZSUDjw=
X-Google-Smtp-Source: ABdhPJzQnr6JeOKYIbhvf7bj5FHd7nmYtpQUpiJm+mK6YbPElOShBgup9CrHNvL+zowsK10siQLiqg==
X-Received: by 2002:adf:dfd0:: with SMTP id q16mr18676146wrn.131.1643114079572;
        Tue, 25 Jan 2022 04:34:39 -0800 (PST)
Received: from heron.intern.cm-ag (p200300dc6f046a000000000000000fd2.dip0.t-ipconnect.de. [2003:dc:6f04:6a00::fd2])
        by smtp.gmail.com with ESMTPSA id e10sm1558633wrq.53.2022.01.25.04.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 04:34:39 -0800 (PST)
From:   Max Kellermann <max.kellermann@gmail.com>
To:     linux-pwm@vger.kernel.org, thierry.reding@gmail.com,
        u.kleine-koenig@pengutronix.de, lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, andrey@lebedev.lt,
        Max Kellermann <max.kellermann@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/3] pwm-sun4i: calculate "delay_jiffies" directly, eliminate absolute time
Date:   Tue, 25 Jan 2022 13:34:28 +0100
Message-Id: <20220125123429.3490883-2-max.kellermann@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20220125123429.3490883-1-max.kellermann@gmail.com>
References: <20220125123429.3490883-1-max.kellermann@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Basically this code did "jiffies + period - jiffies", and we can
simply eliminate the "jiffies" time stamp here.

Cc: stable@vger.kernel.org
Signed-off-by: Max Kellermann <max.kellermann@gmail.com>
---
 drivers/pwm/pwm-sun4i.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/pwm/pwm-sun4i.c b/drivers/pwm/pwm-sun4i.c
index c7c564a6bf36..b44deececb8b 100644
--- a/drivers/pwm/pwm-sun4i.c
+++ b/drivers/pwm/pwm-sun4i.c
@@ -234,9 +234,8 @@ static int sun4i_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	struct pwm_state cstate;
 	u32 ctrl, duty = 0, period = 0, val;
 	int ret;
+	unsigned int delay_jiffies;
 	unsigned int delay_us, prescaler = 0;
-	unsigned long now;
-	unsigned long next_period;
 	bool bypass;
 
 	pwm_get_state(pwm, &cstate);
@@ -284,8 +283,6 @@ static int sun4i_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	val = (duty & PWM_DTY_MASK) | PWM_PRD(period);
 	sun4i_pwm_writel(sun4i_pwm, val, PWM_CH_PRD(pwm->hwpwm));
-	next_period = jiffies +
-		nsecs_to_jiffies(cstate.period + 1000);
 
 	if (state->polarity != PWM_POLARITY_NORMAL)
 		ctrl &= ~BIT_CH(PWM_ACT_STATE, pwm->hwpwm);
@@ -305,14 +302,12 @@ static int sun4i_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 		return 0;
 
 	/* We need a full period to elapse before disabling the channel. */
-	now = jiffies;
-	if (time_before(now, next_period)) {
-		delay_us = jiffies_to_usecs(next_period - now);
-		if ((delay_us / 500) > MAX_UDELAY_MS)
-			msleep(delay_us / 1000 + 1);
-		else
-			usleep_range(delay_us, delay_us * 2);
-	}
+	delay_jiffies = nsecs_to_jiffies(cstate.period + 1000);
+	delay_us = jiffies_to_usecs(delay_jiffies);
+	if ((delay_us / 500) > MAX_UDELAY_MS)
+		msleep(delay_us / 1000 + 1);
+	else
+		usleep_range(delay_us, delay_us * 2);
 
 	spin_lock(&sun4i_pwm->ctrl_lock);
 	ctrl = sun4i_pwm_readl(sun4i_pwm, PWM_CTRL_REG);
-- 
2.34.0

