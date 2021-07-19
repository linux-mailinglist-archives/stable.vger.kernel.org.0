Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5723CDFA4
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344854AbhGSPLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:11:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:40366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346051AbhGSPKA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:10:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3E3261279;
        Mon, 19 Jul 2021 15:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709813;
        bh=qZkyoG2FBn2OT+lhuZGNVpkXT/zpxIylfZrc701XAf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oeaCVKWmt9B938Fjazdn3p0qZnTa9aFwJm8WfZtgtjQcd/24dF3eVbe3/ugeXVU4w
         1EJjHQEcszfCsdTm3lmc0tHuATK6OzJS79AnQmvS/6Fh6Nbf1fl8lpHtp4LRtAWD18
         talG8OahLnS5aP0FjZ9PbUi73Jz4tteYvA73SuhE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 109/149] pwm: imx1: Dont disable clocks at device remove time
Date:   Mon, 19 Jul 2021 16:53:37 +0200
Message-Id: <20210719144927.183141317@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
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
index f8b2c2e001a7..c17652c40e14 100644
--- a/drivers/pwm/pwm-imx1.c
+++ b/drivers/pwm/pwm-imx1.c
@@ -180,8 +180,6 @@ static int pwm_imx1_remove(struct platform_device *pdev)
 {
 	struct pwm_imx1_chip *imx = platform_get_drvdata(pdev);
 
-	pwm_imx1_clk_disable_unprepare(&imx->chip);
-
 	return pwmchip_remove(&imx->chip);
 }
 
-- 
2.30.2



