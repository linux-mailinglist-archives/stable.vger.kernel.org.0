Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 204BC2E3A2A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389548AbgL1NdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:33:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:59522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390825AbgL1NbY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:31:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B13A521D94;
        Mon, 28 Dec 2020 13:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162269;
        bh=fWQJ8GJNj4rZDgu6T4wbPlxyJHgCU5LZGAH2iFSLVAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FPNxOcisU0y3h7i6VEx3FrctHDuqX4kN7HdHiXY2RH+YfupQ6GxaWBwbkpRJ8OU5d
         jr4hxWJWlZoYs2L9ssDw0xmn/+UuxbBTMXVWdvzlAK6PKZpNz8fI1DcLQgXmG8V+kS
         4HYjlmc0Gq7D0Buiyv2tBqLRIwFySqM2yHcjfnys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Shawn Guo <shawn.guo@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 245/346] pwm: zx: Add missing cleanup in error path
Date:   Mon, 28 Dec 2020 13:49:24 +0100
Message-Id: <20201228124931.617592311@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 269effd03f6142df4c74814cfdd5f0b041b30bf9 ]

zx_pwm_probe() called clk_prepare_enable() before; this must be undone
in the error path.

Fixes: 4836193c435c ("pwm: Add ZTE ZX PWM device driver")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-zx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pwm/pwm-zx.c b/drivers/pwm/pwm-zx.c
index 5d27c16edfb13..0d4112410b69d 100644
--- a/drivers/pwm/pwm-zx.c
+++ b/drivers/pwm/pwm-zx.c
@@ -241,6 +241,7 @@ static int zx_pwm_probe(struct platform_device *pdev)
 	ret = pwmchip_add(&zpc->chip);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to add PWM chip: %d\n", ret);
+		clk_disable_unprepare(zpc->pclk);
 		return ret;
 	}
 
-- 
2.27.0



