Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287D13D28A8
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbhGVP56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:57:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:33718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230000AbhGVP5f (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:57:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40E126135F;
        Thu, 22 Jul 2021 16:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971889;
        bh=+UnJFToStn6Zy5d8VSNkYrQbGPBofNFoARKKatCE95U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uv6isEvk6nAi7lOKj0UHhTsXRtvFDWFw0PNSDKWFTe+syJpgSlRZqp4wf26o7zV2M
         O2Qs0oBwEdHZbjyLmz+P3eLReH38iCFaDJenJgRYmZBiwlIOrgPbopTt9TOi24n1Nz
         Ooj2X9by2Xc70qJP2T2iySDxdmTlBqpPWyAXdKPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/125] thermal/drivers/rcar_gen3_thermal: Do not shadow rcar_gen3_ths_tj_1
Date:   Thu, 22 Jul 2021 18:30:56 +0200
Message-Id: <20210722155626.852411130@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8d724d92d57f..c4f28752d148 100644
--- a/drivers/thermal/rcar_gen3_thermal.c
+++ b/drivers/thermal/rcar_gen3_thermal.c
@@ -366,7 +366,7 @@ static int rcar_gen3_thermal_probe(struct platform_device *pdev)
 {
 	struct rcar_gen3_thermal_priv *priv;
 	struct device *dev = &pdev->dev;
-	const int *rcar_gen3_ths_tj_1 = of_device_get_match_data(dev);
+	const int *ths_tj_1 = of_device_get_match_data(dev);
 	struct resource *res;
 	struct thermal_zone_device *zone;
 	int ret, irq, i;
@@ -434,8 +434,7 @@ static int rcar_gen3_thermal_probe(struct platform_device *pdev)
 		priv->tscs[i] = tsc;
 
 		priv->thermal_init(tsc);
-		rcar_gen3_thermal_calc_coefs(tsc, ptat, thcodes[i],
-					     *rcar_gen3_ths_tj_1);
+		rcar_gen3_thermal_calc_coefs(tsc, ptat, thcodes[i], *ths_tj_1);
 
 		zone = devm_thermal_zone_of_sensor_register(dev, i, tsc,
 							    &rcar_gen3_tz_of_ops);
-- 
2.30.2



