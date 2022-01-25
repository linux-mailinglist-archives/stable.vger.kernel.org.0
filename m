Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39FFC49B412
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 13:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383655AbiAYMiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 07:38:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1451351AbiAYMej (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 07:34:39 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB32C061769;
        Tue, 25 Jan 2022 04:34:38 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id e8so17835987wrc.0;
        Tue, 25 Jan 2022 04:34:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XU7BD3ZCwSatg7jSB64inzSJiC7IsFXIbFfu4ywKzMU=;
        b=HFRXWbjFZwTAqv/NjKXo/nKLZ86h7hbHRecQhkPDbgdfezb/qA9aC4UDfkmKy57f8H
         CalqE9+XDJ8YD0fjFFKvf8A1RfN5lztuEJjhG/g8kTF5AEnKY01G9C90Iy87d27FIYNQ
         EZG1ow5Hx5BX9tZMD4E61TUONqjDmrKqIqdblTAeySBNSgHkVorBvHt9CD70TyfPgHXI
         J2a7ONxPEGi5LMdQ4Od3vi6jYexeQ+jeR26tKNA3CDk+7GNtjERlagGM+6o6rpaa/y+n
         CAhPNdiQO4qt+zH3V3bX+JAMYOtiaI0Wl44j9YKAVchnOYVSmm7r/gGrFnRYwB7Xg71l
         r+rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XU7BD3ZCwSatg7jSB64inzSJiC7IsFXIbFfu4ywKzMU=;
        b=pH9lE6dS+tbxt55YvcloUv991cmNY9QJHC1exhI+2vl1Gx1vaJWiVL6Mh+guvroky4
         njTv0mqF7NN8vfY0JcTIu6zicVxeNmE4J8MtMeWpVyum6xLAQiwiAGmdxGCi4YNFXDSc
         WFDQjDKmjrOY1ptA18kE9aL2WXjkNmx2ieNwwaNCk4IncN/XefrNj6z1vrqr4GrmoAkq
         QJqVDfEVArlRIrihELCgns8cAG2YXF5/U+MYNSAtGmwiN55WaiIUysYfgl1ZIn+FzBPE
         Rl/BnKW+zW/XqeFANEbQJE38DRzBUxYSCsK6yoVP78zAE2CxVDNWRl/+Tppf+R0LjsIy
         o4CA==
X-Gm-Message-State: AOAM530emckiLjVt29pq/2OXxdt0VH7A74+ox7sv3fhFwcK57Mc4mOcP
        cCkQLEkN36Wx+WlMIvqZdiUpSWZOA6Y=
X-Google-Smtp-Source: ABdhPJwtJj3Putd2RYBejOhKxuX/HNBAXLYwr58mXSXw8ALxLch+seyPNA09653LY7qWWg4gUtuIBg==
X-Received: by 2002:adf:fc8e:: with SMTP id g14mr18057287wrr.260.1643114077318;
        Tue, 25 Jan 2022 04:34:37 -0800 (PST)
Received: from heron.intern.cm-ag (p200300dc6f046a000000000000000fd2.dip0.t-ipconnect.de. [2003:dc:6f04:6a00::fd2])
        by smtp.gmail.com with ESMTPSA id e10sm1558633wrq.53.2022.01.25.04.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 04:34:36 -0800 (PST)
From:   Max Kellermann <max.kellermann@gmail.com>
To:     linux-pwm@vger.kernel.org, thierry.reding@gmail.com,
        u.kleine-koenig@pengutronix.de, lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, andrey@lebedev.lt,
        Max Kellermann <max.kellermann@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/3] pwm-sun4i: convert "next_period" to local variable
Date:   Tue, 25 Jan 2022 13:34:27 +0100
Message-Id: <20220125123429.3490883-1-max.kellermann@gmail.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Its value is calculated in sun4i_pwm_apply() and is used only there.

Cc: stable@vger.kernel.org
Signed-off-by: Max Kellermann <max.kellermann@gmail.com>
---
 drivers/pwm/pwm-sun4i.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/pwm/pwm-sun4i.c b/drivers/pwm/pwm-sun4i.c
index 91ca67651abd..c7c564a6bf36 100644
--- a/drivers/pwm/pwm-sun4i.c
+++ b/drivers/pwm/pwm-sun4i.c
@@ -89,7 +89,6 @@ struct sun4i_pwm_chip {
 	void __iomem *base;
 	spinlock_t ctrl_lock;
 	const struct sun4i_pwm_data *data;
-	unsigned long next_period[2];
 };
 
 static inline struct sun4i_pwm_chip *to_sun4i_pwm_chip(struct pwm_chip *chip)
@@ -237,6 +236,7 @@ static int sun4i_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	int ret;
 	unsigned int delay_us, prescaler = 0;
 	unsigned long now;
+	unsigned long next_period;
 	bool bypass;
 
 	pwm_get_state(pwm, &cstate);
@@ -284,7 +284,7 @@ static int sun4i_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	val = (duty & PWM_DTY_MASK) | PWM_PRD(period);
 	sun4i_pwm_writel(sun4i_pwm, val, PWM_CH_PRD(pwm->hwpwm));
-	sun4i_pwm->next_period[pwm->hwpwm] = jiffies +
+	next_period = jiffies +
 		nsecs_to_jiffies(cstate.period + 1000);
 
 	if (state->polarity != PWM_POLARITY_NORMAL)
@@ -306,9 +306,8 @@ static int sun4i_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	/* We need a full period to elapse before disabling the channel. */
 	now = jiffies;
-	if (time_before(now, sun4i_pwm->next_period[pwm->hwpwm])) {
-		delay_us = jiffies_to_usecs(sun4i_pwm->next_period[pwm->hwpwm] -
-					   now);
+	if (time_before(now, next_period)) {
+		delay_us = jiffies_to_usecs(next_period - now);
 		if ((delay_us / 500) > MAX_UDELAY_MS)
 			msleep(delay_us / 1000 + 1);
 		else
-- 
2.34.0

