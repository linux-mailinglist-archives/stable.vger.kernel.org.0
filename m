Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D4129B521
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793801AbgJ0PIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:08:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1793798AbgJ0PIV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:08:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAAE5206E5;
        Tue, 27 Oct 2020 15:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811300;
        bh=jBNNwsIKnn0W5z4A48N5P+kQ4x2eqUrJssaQKKdLJdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dnl1VywCfEIEGUtZunvDdvqUPGwCF/f8zp1BOiRTaXtShrkAQIon6f8Hf75v83RkA
         3d0wN6w4xLplN4bg+AjPtv7wvuEXb+YQ2x7D7qRbRNlBP7ethmjazpuvbwQQ3LL3nf
         ljQJ0sizS8oyr5EWWxaczjXNUg0Yv3PTBesMowws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon South <simon@simonsouth.net>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Heiko Stuebner <heiko@sntech.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 443/633] pwm: rockchip: Keep enabled PWMs running while probing
Date:   Tue, 27 Oct 2020 14:53:06 +0100
Message-Id: <20201027135543.498231956@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Simon South <simon@simonsouth.net>

[ Upstream commit 457f74abbed060a0395f75ab5297f2d76cada516 ]

Following commit cfc4c189bc70 ("pwm: Read initial hardware state at
request time") the Rockchip PWM driver can no longer assume a device's
pwm_state structure has been populated after a call to pwmchip_add().
Consequently, the test in rockchip_pwm_probe() intended to prevent the
driver from stopping PWM devices already enabled by the bootloader no
longer functions reliably and this can lead to the kernel hanging
during startup, particularly on devices like the Pinebook Pro that use
a PWM-controlled backlight for their display.

Avoid this by querying the device directly at probe time to determine
whether or not it is enabled.

Fixes: cfc4c189bc70 ("pwm: Read initial hardware state at request time")
Signed-off-by: Simon South <simon@simonsouth.net>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-rockchip.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-rockchip.c b/drivers/pwm/pwm-rockchip.c
index eb8c9cb645a6c..098e94335cb5b 100644
--- a/drivers/pwm/pwm-rockchip.c
+++ b/drivers/pwm/pwm-rockchip.c
@@ -288,6 +288,7 @@ static int rockchip_pwm_probe(struct platform_device *pdev)
 	const struct of_device_id *id;
 	struct rockchip_pwm_chip *pc;
 	struct resource *r;
+	u32 enable_conf, ctrl;
 	int ret, count;
 
 	id = of_match_device(rockchip_pwm_dt_ids, &pdev->dev);
@@ -362,7 +363,9 @@ static int rockchip_pwm_probe(struct platform_device *pdev)
 	}
 
 	/* Keep the PWM clk enabled if the PWM appears to be up and running. */
-	if (!pwm_is_enabled(pc->chip.pwms))
+	enable_conf = pc->data->enable_conf;
+	ctrl = readl_relaxed(pc->base + pc->data->regs.ctrl);
+	if ((ctrl & enable_conf) != enable_conf)
 		clk_disable(pc->clk);
 
 	return 0;
-- 
2.25.1



