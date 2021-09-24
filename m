Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F159D4174AF
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346065AbhIXNJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:09:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346583AbhIXNHe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:07:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB7726138B;
        Fri, 24 Sep 2021 12:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488208;
        bh=0GvFKGbZkmXWcXob+UxUW1n1/KXjvJoMo3LCwMHfQQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cAwbyjWUVnWZ5UUyDj0igc9As1E5yER2PZSyKfOFSirWtmCjSR9ihi5fzRQi9ffN0
         zqVdKG6Ya+3OJ0gSQeL2XwtsBcVZKEde9EgfIoSOQrp8eH5Z3ZT/pslrBqj2Haqt8l
         Ebq6gf7eag4WjZ+ol/tgZIOquZRkQ/VDSYYP7hmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sylvain Lemieux <slemieux@tycoint.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH 5.10 25/63] pwm: lpc32xx: Dont modify HW state in .probe() after the PWM chip was registered
Date:   Fri, 24 Sep 2021 14:44:25 +0200
Message-Id: <20210924124335.128342669@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124334.228235870@linuxfoundation.org>
References: <20210924124334.228235870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit 3d2813fb17e5fd0d73c1d1442ca0192bde4af10e upstream.

This fixes a race condition: After pwmchip_add() is called there might
already be a consumer and then modifying the hardware behind the
consumer's back is bad. So set the default before.

(Side-note: I don't know what this register setting actually does, if
this modifies the polarity there is an inconsistency because the
inversed polarity isn't considered if the PWM is already running during
.probe().)

Fixes: acfd92fdfb93 ("pwm: lpc32xx: Set PWM_PIN_LEVEL bit to default value")
Cc: Sylvain Lemieux <slemieux@tycoint.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-lpc32xx.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/pwm/pwm-lpc32xx.c
+++ b/drivers/pwm/pwm-lpc32xx.c
@@ -120,17 +120,17 @@ static int lpc32xx_pwm_probe(struct plat
 	lpc32xx->chip.npwm = 1;
 	lpc32xx->chip.base = -1;
 
+	/* If PWM is disabled, configure the output to the default value */
+	val = readl(lpc32xx->base + (lpc32xx->chip.pwms[0].hwpwm << 2));
+	val &= ~PWM_PIN_LEVEL;
+	writel(val, lpc32xx->base + (lpc32xx->chip.pwms[0].hwpwm << 2));
+
 	ret = pwmchip_add(&lpc32xx->chip);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to add PWM chip, error %d\n", ret);
 		return ret;
 	}
 
-	/* When PWM is disable, configure the output to the default value */
-	val = readl(lpc32xx->base + (lpc32xx->chip.pwms[0].hwpwm << 2));
-	val &= ~PWM_PIN_LEVEL;
-	writel(val, lpc32xx->base + (lpc32xx->chip.pwms[0].hwpwm << 2));
-
 	platform_set_drvdata(pdev, lpc32xx);
 
 	return 0;


