Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDE71E4073
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 13:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbgE0Lw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 07:52:57 -0400
Received: from outils.crapouillou.net ([89.234.176.41]:41026 "EHLO
        crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgE0Lw4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 May 2020 07:52:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1590580367; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UvvvrXWRYDHu3UfDWTLrB6GvtVeps3r3Hz5jfYNCgNM=;
        b=BETk0rSmUVWgGf8DbdbhV68+hbnghdRRuJiBQKcvnE4i0DS0ITfJ4neHWaddQH9wDILioS
        ObkHGmYjJGKiBfDQM+thUHY3U2z/UlirrIJjJxJ8CMkag0ceYMKzskNoAO/cGJ4V9+xi7z
        mT3BDxMc1I8lN/VVBS93fQuunVXTNuQ=
From:   Paul Cercueil <paul@crapouillou.net>
To:     Thierry Reding <thierry.reding@gmail.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     od@zcrc.me, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        stable@vger.kernel.org
Subject: [PATCH v3 2/4] pwm: jz4740: Enhance precision in calculation of duty cycle
Date:   Wed, 27 May 2020 13:52:23 +0200
Message-Id: <20200527115225.10069-2-paul@crapouillou.net>
In-Reply-To: <20200527115225.10069-1-paul@crapouillou.net>
References: <20200527115225.10069-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Calculating the hardware value for the duty from the hardware value of
the period resulted in a precision loss versus calculating it from the
clock rate directly.

(Also remove a cast that doesn't really need to be here)

Fixes: f6b8a5700057 ("pwm: Add Ingenic JZ4740 support")
Cc: <stable@vger.kernel.org>
Suggested-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---

Notes:
    v2: New patch. I don't consider this a fix but an enhancement, since the old
    	behaviour was in place since the driver was born in ~2010, so no Fixes tag.
    v3: Add Fixes tag and Uwe's Reviewed-by

 drivers/pwm/pwm-jz4740.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pwm/pwm-jz4740.c b/drivers/pwm/pwm-jz4740.c
index 3cd5c054ad9a..4fe9d99ac9a9 100644
--- a/drivers/pwm/pwm-jz4740.c
+++ b/drivers/pwm/pwm-jz4740.c
@@ -158,11 +158,11 @@ static int jz4740_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	/* Calculate period value */
 	tmp = (unsigned long long)rate * state->period;
 	do_div(tmp, NSEC_PER_SEC);
-	period = (unsigned long)tmp;
+	period = tmp;
 
 	/* Calculate duty value */
-	tmp = (unsigned long long)period * state->duty_cycle;
-	do_div(tmp, state->period);
+	tmp = (unsigned long long)rate * state->duty_cycle;
+	do_div(tmp, NSEC_PER_SEC);
 	duty = period - tmp;
 
 	if (duty >= period)
-- 
2.26.2

