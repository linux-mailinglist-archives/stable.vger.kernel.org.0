Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 039A33C8E44
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233767AbhGNTq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:46:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237550AbhGNTqG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:46:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67214613D0;
        Wed, 14 Jul 2021 19:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291756;
        bh=vKp1w6mzPYQWF8SDNjXlnynHwI8sobYdegTGqYLa7xY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TUl5TgJkHTVrERJ99mYOehhwNv0l2JyfLa622ST3hSIzpp9aDciRBMGpq/4vjTn9M
         c/vJq5OKJuZ0UGDaPW0q9uZ9zFncNQUVCIMkRmWW0zUWRzrekYdZ2UoN9bk0e4xM7U
         CpS00c7Gbw40tvz+BeA7eIfxDznW0jryLVS/bj1ZIg4ppzBRBiIwJ11qTjjdkIFwLs
         6FYOUBEch+yV2cqj7CsRMg2wK/rj0McHXJyBj/f7Gtg72SKhur47Ms+CJT/CU1JQSb
         lrunuc6XVgZGQlZVBCGd5nyIkvUKkls0tHyGFiAyJGYZX5pA44Jm2ipi1E/eS+pisT
         dpJaLo2aJ3KgA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 084/102] thermal/drivers/rcar_gen3_thermal: Do not shadow rcar_gen3_ths_tj_1
Date:   Wed, 14 Jul 2021 15:40:17 -0400
Message-Id: <20210714194036.53141-84-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194036.53141-1-sashal@kernel.org>
References: <20210714194036.53141-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 3ae5950db617d1cc3eb4eb55750fa9d138529b49 ]

With -Wshadow:

    drivers/thermal/rcar_gen3_thermal.c: In function ‘rcar_gen3_thermal_probe’:
    drivers/thermal/rcar_gen3_thermal.c:310:13: warning: declaration of ‘rcar_gen3_ths_tj_1’ shadows a global declaration [-Wshadow]
      310 |  const int *rcar_gen3_ths_tj_1 = of_device_get_match_data(dev);
	  |             ^~~~~~~~~~~~~~~~~~
    drivers/thermal/rcar_gen3_thermal.c:246:18: note: shadowed declaration is here
      246 | static const int rcar_gen3_ths_tj_1 = 126;
	  |                  ^~~~~~~~~~~~~~~~~~

To add to the confusion, the local variable has a different type.

Fix the shadowing by renaming the local variable to ths_tj_1.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/9ea7e65d0331daba96f9a7925cb3d12d2170efb1.1623076804.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/rcar_gen3_thermal.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/rcar_gen3_thermal.c b/drivers/thermal/rcar_gen3_thermal.c
index 75c69fe6e955..f732735d98ec 100644
--- a/drivers/thermal/rcar_gen3_thermal.c
+++ b/drivers/thermal/rcar_gen3_thermal.c
@@ -306,7 +306,7 @@ static int rcar_gen3_thermal_probe(struct platform_device *pdev)
 {
 	struct rcar_gen3_thermal_priv *priv;
 	struct device *dev = &pdev->dev;
-	const int *rcar_gen3_ths_tj_1 = of_device_get_match_data(dev);
+	const int *ths_tj_1 = of_device_get_match_data(dev);
 	struct resource *res;
 	struct thermal_zone_device *zone;
 	int ret, i;
@@ -351,8 +351,7 @@ static int rcar_gen3_thermal_probe(struct platform_device *pdev)
 		priv->tscs[i] = tsc;
 
 		priv->thermal_init(tsc);
-		rcar_gen3_thermal_calc_coefs(tsc, ptat, thcodes[i],
-					     *rcar_gen3_ths_tj_1);
+		rcar_gen3_thermal_calc_coefs(tsc, ptat, thcodes[i], *ths_tj_1);
 
 		zone = devm_thermal_zone_of_sensor_register(dev, i, tsc,
 							    &rcar_gen3_tz_of_ops);
-- 
2.30.2

