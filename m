Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5283CE3A9
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346504AbhGSPiu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:38:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347635AbhGSPfN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69C2061463;
        Mon, 19 Jul 2021 16:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711146;
        bh=8hZM0TH5jMTV5SS61jK1QbiVK7qmppmV8FJNt8l1stM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NMzdJMbgAA8Gj6XVOAslDnSHZh8dLUTnJa5or6p3C0UT2rl2PA9FwS3UzPJC8sJ9R
         O8SR9lQD3PG3Z7QeY1yP3r0RAk8Szbu48o6neVXzgH538xyXCcnnPNKVVb+0bYjJQN
         akpwgpMaKm0Mnf72r3ByEcvf0ZoCckdC5ZhBUlGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 237/351] pwm: imx1: Dont disable clocks at device remove time
Date:   Mon, 19 Jul 2021 16:53:03 +0200
Message-Id: <20210719144952.782722889@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 1bc6ea31cb41d50302a3c9b401964cf0a88d41f9 ]

The .remove() callback disables clocks that were not enabled in
.probe(). So just probing and then unbinding the driver results in a clk
enable imbalance.

So just drop the call to disable the clocks. (Which BTW was also in the
wrong order because the call makes the PWM unfunctional and so should
have come only after pwmchip_remove()).

Fixes: 9f4c8f9607c3 ("pwm: imx: Add ipg clock operation")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-imx1.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/pwm/pwm-imx1.c b/drivers/pwm/pwm-imx1.c
index c957b365448e..e73858a8e464 100644
--- a/drivers/pwm/pwm-imx1.c
+++ b/drivers/pwm/pwm-imx1.c
@@ -168,8 +168,6 @@ static int pwm_imx1_remove(struct platform_device *pdev)
 {
 	struct pwm_imx1_chip *imx = platform_get_drvdata(pdev);
 
-	pwm_imx1_clk_disable_unprepare(&imx->chip);
-
 	return pwmchip_remove(&imx->chip);
 }
 
-- 
2.30.2



