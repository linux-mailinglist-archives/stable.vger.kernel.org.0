Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C7E417242
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344036AbhIXMrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:47:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343744AbhIXMqc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:46:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8977F61251;
        Fri, 24 Sep 2021 12:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487499;
        bh=l1gzoSs4ajRaNO/iXl96GbK9WlpuKTQmAaQln8y91Ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t0fSK7132f1XVDt8PTqhAkSdCS3f+xHSX3TDNFGKwKQjwkDCF9uFrqJpPdjB3+xWA
         1BMVR7i2/YU2h7nQGPVq6A7/F1JyJv+mN4nB3VpyzYQhNb3pO5uKpZX+wbDoz2V6N1
         dI7bZTFyRGjK4I3iKToyumIUsT84Zo2YyackOmfQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH 4.4 09/23] pwm: mxs: Dont modify HW state in .probe() after the PWM chip was registered
Date:   Fri, 24 Sep 2021 14:43:50 +0200
Message-Id: <20210924124328.125888005@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124327.816210800@linuxfoundation.org>
References: <20210924124327.816210800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit 020162d6f49f2963062229814a56a89c86cbeaa8 upstream.

This fixes a race condition: After pwmchip_add() is called there might
already be a consumer and then modifying the hardware behind the
consumer's back is bad. So reset before calling pwmchip_add().

Note that reseting the hardware isn't the right thing to do if the PWM
is already running as it might e.g. disable (or even enable) a backlight
that is supposed to be on (or off).

Fixes: 4dce82c1e840 ("pwm: add pwm-mxs support")
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-mxs.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/drivers/pwm/pwm-mxs.c
+++ b/drivers/pwm/pwm-mxs.c
@@ -158,6 +158,11 @@ static int mxs_pwm_probe(struct platform
 		return ret;
 	}
 
+	/* FIXME: Only do this if the PWM isn't already running */
+	ret = stmp_reset_block(mxs->base);
+	if (ret)
+		return dev_err_probe(&pdev->dev, ret, "failed to reset PWM\n");
+
 	ret = pwmchip_add(&mxs->chip);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to add pwm chip %d\n", ret);
@@ -166,15 +171,7 @@ static int mxs_pwm_probe(struct platform
 
 	platform_set_drvdata(pdev, mxs);
 
-	ret = stmp_reset_block(mxs->base);
-	if (ret)
-		goto pwm_remove;
-
 	return 0;
-
-pwm_remove:
-	pwmchip_remove(&mxs->chip);
-	return ret;
 }
 
 static int mxs_pwm_remove(struct platform_device *pdev)


