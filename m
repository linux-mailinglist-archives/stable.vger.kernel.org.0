Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC652E38F1
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730929AbgL1NQ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:16:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:44004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733153AbgL1NQR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:16:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B57BD208D5;
        Mon, 28 Dec 2020 13:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161362;
        bh=fWQJ8GJNj4rZDgu6T4wbPlxyJHgCU5LZGAH2iFSLVAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Asduomims+HqGpwt2Cd0AUe4WN0Xl8tk0lhe8b6fQ5eAS8bVlmQ6kYHzosrAtFXbS
         cVyfdTnJY8lhOx1JcjP+FUqhwlzOw6LC+iuKo3TKgk+EELMPIW1dE6xCUIdqBcHBVH
         QmqkqQjVR+h7GMMmoZ4N5h7ShcLk/sPJRcNMPj2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Shawn Guo <shawn.guo@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 171/242] pwm: zx: Add missing cleanup in error path
Date:   Mon, 28 Dec 2020 13:49:36 +0100
Message-Id: <20201228124913.116534218@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
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



