Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE5063CE360
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241377AbhGSPhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:37:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:59768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347285AbhGSPfG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38CA261461;
        Mon, 19 Jul 2021 16:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711126;
        bh=jHaHEvBaMngbGlFOPVwwTzBpRwK1qt1DGNPYQrrnlQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QmHvCyGqZ5eHe50TbCBwag8OONjYZDcI5Hp3bc+3n/aEywCdKZPUfN+4Yltv25D3N
         CVA15grp+OqfkzI9Le6wP4Bl70fk728tApuyWRV2NTIVEDcq60uR/StSKyjVWyL6vp
         /jm4+NidZ8uO2hXapWeljKInV582fK/8U2hLeM9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 204/351] pwm: visconti: Fix and simplify period calculation
Date:   Mon, 19 Jul 2021 16:52:30 +0200
Message-Id: <20210719144951.717684587@linuxfoundation.org>
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

[ Upstream commit 937efa29e70f7f8424b74631375dcb35d82a4614 ]

With the original code a request for period = 65536000 ns and period =
32768000 ns yields the same register settings (which results in 32768000
ns) because the value for pwmc0 was miscalculated.

Also simplify using that fls(0) is 0.

Fixes: 721b595744f1 ("pwm: visconti: Add Toshiba Visconti SoC PWM support")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-visconti.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/pwm/pwm-visconti.c b/drivers/pwm/pwm-visconti.c
index 46d903786366..af4e37d3e3a6 100644
--- a/drivers/pwm/pwm-visconti.c
+++ b/drivers/pwm/pwm-visconti.c
@@ -82,17 +82,14 @@ static int visconti_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 		return -ERANGE;
 
 	/*
-	 * PWMC controls a divider that divides the input clk by a
-	 * power of two between 1 and 8. As a smaller divider yields
-	 * higher precision, pick the smallest possible one.
+	 * PWMC controls a divider that divides the input clk by a power of two
+	 * between 1 and 8. As a smaller divider yields higher precision, pick
+	 * the smallest possible one. As period is at most 0xffff << 3, pwmc0 is
+	 * in the intended range [0..3].
 	 */
-	if (period > 0xffff) {
-		pwmc0 = ilog2(period >> 16);
-		if (WARN_ON(pwmc0 > 3))
-			return -EINVAL;
-	} else {
-		pwmc0 = 0;
-	}
+	pwmc0 = fls(period >> 16);
+	if (WARN_ON(pwmc0 > 3))
+		return -EINVAL;
 
 	period >>= pwmc0;
 	duty_cycle >>= pwmc0;
-- 
2.30.2



