Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C931829BBF5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802658AbgJ0Puo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:50:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801679AbgJ0PnJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:43:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0F0420657;
        Tue, 27 Oct 2020 15:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813387;
        bh=jBNNwsIKnn0W5z4A48N5P+kQ4x2eqUrJssaQKKdLJdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PxGX0o3HsX1vJWIo0km6OrnAz/0o1hvr0fdOz2kZPDHIq0txsNty2LkhS+8nn2lgc
         5weCQgYHd8aVBmnS0kxRc1Audgy0lLiL3W9ym17xJckkO6XzIkqmNPhcmCf4qa+Rjd
         D2fiDmx/KNBahfbqEUaOZ+979990nVyIejvoKmUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon South <simon@simonsouth.net>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Heiko Stuebner <heiko@sntech.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 534/757] pwm: rockchip: Keep enabled PWMs running while probing
Date:   Tue, 27 Oct 2020 14:53:04 +0100
Message-Id: <20201027135515.544383197@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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



