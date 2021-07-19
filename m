Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F523CE62B
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349837AbhGSQB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 12:01:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349855AbhGSPuW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:50:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7F6661925;
        Mon, 19 Jul 2021 16:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712153;
        bh=9l8ONWHow1x/neUW7Sm/TNZo9OeLh2as9+jsHXzgPkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YgnHvuCJ9noUOf8PUWYQuRtrQK6WMcT0mXgE9++EeXd6Ju4MX17A+RFH8BhmxJPID
         kOWIuxKIpr8WU3lnXJzk9c/9z7t0iQFpvcXYCcvdvXJoFUnolAVo6E2MgW4GsMOhUv
         F1SnWzsLZQP2aNc3yKg5LBZYyAnCrjf47ZCCLZEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 271/292] thermal/drivers/rcar_gen3_thermal: Fix coefficient calculations
Date:   Mon, 19 Jul 2021 16:55:33 +0200
Message-Id: <20210719144951.832995455@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

[ Upstream commit 8946187ab57ffd02088e50256c73dd31f49db06d ]

The fixed value of 157 used in the calculations are only correct for
M3-W, on other Gen3 SoC it should be 167. The constant can be derived
correctly from the static TJ_3 constant and the SoC specific TJ_1 value.
Update the calculation be correct on all Gen3 SoCs.

Fixes: 4eb39f79ef44 ("thermal: rcar_gen3_thermal: Update value of Tj_1")
Reported-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210605085211.564909-1-niklas.soderlund+renesas@ragnatech.se
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/rcar_gen3_thermal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/rcar_gen3_thermal.c b/drivers/thermal/rcar_gen3_thermal.c
index 75c69fe6e955..c02922d2d1d5 100644
--- a/drivers/thermal/rcar_gen3_thermal.c
+++ b/drivers/thermal/rcar_gen3_thermal.c
@@ -142,7 +142,7 @@ static void rcar_gen3_thermal_calc_coefs(struct rcar_gen3_thermal_tsc *tsc,
 	 * Division is not scaled in BSP and if scaled it might overflow
 	 * the dividend (4095 * 4095 << 14 > INT_MAX) so keep it unscaled
 	 */
-	tsc->tj_t = (FIXPT_INT((ptat[1] - ptat[2]) * 157)
+	tsc->tj_t = (FIXPT_INT((ptat[1] - ptat[2]) * (ths_tj_1 - TJ_3))
 		     / (ptat[0] - ptat[2])) + FIXPT_INT(TJ_3);
 
 	tsc->coef.a1 = FIXPT_DIV(FIXPT_INT(thcode[1] - thcode[2]),
-- 
2.30.2



