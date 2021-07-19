Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D213CE159
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349142AbhGSPZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:25:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:59628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346642AbhGSPRp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:17:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5005461248;
        Mon, 19 Jul 2021 15:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710266;
        bh=lwqM6PvVga1wrNPdaKICIzDas3E2Hl7kjyv++ULeiNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S0+jozdPH48u2uqLerUpQxOQBtUzQ9vAhcHeAgrrNk7P2ufNzSDWYeKioHlrG5B9h
         k9hsxWyjw7Z3pb/5W2tsdQVinPDakCTUBUbztcSJJlZOoGHSbwSYr+Aar0o8gSTmj8
         UAHBMMTQcG0NTujqOI4Yy/yl2UOD0m/TTFrj+g1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 113/243] pwm: spear: Dont modify HW state in .remove callback
Date:   Mon, 19 Jul 2021 16:52:22 +0200
Message-Id: <20210719144944.558644158@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit b601a18f12383001e7a8da238de7ca1559ebc450 ]

A consumer is expected to disable a PWM before calling pwm_put(). And if
they didn't there is hopefully a good reason (or the consumer needs
fixing). Also if disabling an enabled PWM was the right thing to do,
this should better be done in the framework instead of in each low level
driver.

So drop the hardware modification from the .remove() callback.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-spear.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/pwm/pwm-spear.c b/drivers/pwm/pwm-spear.c
index 6c6b44fd3f43..2d11ac277de8 100644
--- a/drivers/pwm/pwm-spear.c
+++ b/drivers/pwm/pwm-spear.c
@@ -231,10 +231,6 @@ static int spear_pwm_probe(struct platform_device *pdev)
 static int spear_pwm_remove(struct platform_device *pdev)
 {
 	struct spear_pwm_chip *pc = platform_get_drvdata(pdev);
-	int i;
-
-	for (i = 0; i < NUM_PWM; i++)
-		pwm_disable(&pc->chip.pwms[i]);
 
 	/* clk was prepared in probe, hence unprepare it here */
 	clk_unprepare(pc->clk);
-- 
2.30.2



