Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C205B2E400B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391140AbgL1OrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:47:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:59708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502843AbgL1OXj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:23:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C06D9221F0;
        Mon, 28 Dec 2020 14:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165379;
        bh=9NahrlYyNAdZZ/yKDuE0CcW/q+WhkGrcf3ZkyE8qS/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a9aPrI2PnqVo28Gjv8JXbZptgLzUsGugxzNF8xN+GiJh0vwobIfbq/y+SU7ltE9hu
         NLgP6P7ikurSUEQY/c/Y/B/9Ve72VdIg/I8JIFwzKCCTx1W/eA5HOfLcqZ+rnAnrfq
         UiyUSY3SrU1YIwsbzd0X600ph0jsBcdPy7IkjCvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Shawn Guo <shawn.guo@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 479/717] pwm: zx: Add missing cleanup in error path
Date:   Mon, 28 Dec 2020 13:47:57 +0100
Message-Id: <20201228125043.916154515@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
index e2c21cc34a96a..3763ce5311ac2 100644
--- a/drivers/pwm/pwm-zx.c
+++ b/drivers/pwm/pwm-zx.c
@@ -238,6 +238,7 @@ static int zx_pwm_probe(struct platform_device *pdev)
 	ret = pwmchip_add(&zpc->chip);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to add PWM chip: %d\n", ret);
+		clk_disable_unprepare(zpc->pclk);
 		return ret;
 	}
 
-- 
2.27.0



