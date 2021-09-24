Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5477B4172C6
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344671AbhIXMvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:51:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344412AbhIXMtk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:49:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E19D561283;
        Fri, 24 Sep 2021 12:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487680;
        bh=Z4McYNiEwNXxv/YA7HLEkflslNkWA+CMHTq3Ka3jd28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ca20TL78qKOFI0RADhqj2BwLb6ZwDj5n42LE0hstTyUsj1fdUAqnRoNXK06zyt3Kx
         u9v8JGnsJ3qC8tcdNYmIivSBgOtAyDW5XtggPKJd5rMn5IOj+2TOhXsbHTCl02sQRX
         1+034t+A1fTbp0vE2dlAtXXNQtdz/HhZ8MlrK/QM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sylvain Lemieux <slemieux@tycoint.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH 4.14 12/27] pwm: lpc32xx: Dont modify HW state in .probe() after the PWM chip was registered
Date:   Fri, 24 Sep 2021 14:44:06 +0200
Message-Id: <20210924124329.583402422@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124329.173674820@linuxfoundation.org>
References: <20210924124329.173674820@linuxfoundation.org>
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
@@ -124,17 +124,17 @@ static int lpc32xx_pwm_probe(struct plat
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


