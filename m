Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB6B41744A
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345790AbhIXNE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:04:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:34560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344882AbhIXNC1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:02:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91CE76140D;
        Fri, 24 Sep 2021 12:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488084;
        bh=jua1uYqQ4j+nEO1o1UAf3f7t6086GJOPnXPOwQut2fw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ill5htQhosD9P9tFlf5n7SJYyB4THJMtM/hJdB0n/FN8gqy95PnAKeWqsd+NYBJNy
         w/d/VTaurvgpeFe/6wUWS30x2iCh2lYHgiyiFhaO0Uxaq6k8HE8g6x2QlcCTGKaM4L
         XbHp1ZOXSQQFOzX6MviJV7GyPsAghlXr4xwTo/nE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 078/100] thermal/drivers/rcar_gen3_thermal: Store TSC id as unsigned int
Date:   Fri, 24 Sep 2021 14:44:27 +0200
Message-Id: <20210924124344.074553839@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

[ Upstream commit d3a2328e741bf6e9e6bda750e0a63832fa365a74 ]

The TSC id and number of TSC ids should be stored as unsigned int as
they can't be negative. Fix the datatype of the loop counter 'i' and
rcar_gen3_thermal_tsc.id to reflect this.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210804091818.2196806-3-niklas.soderlund+renesas@ragnatech.se
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/rcar_gen3_thermal.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/rcar_gen3_thermal.c b/drivers/thermal/rcar_gen3_thermal.c
index fdf16aa34eb4..702696cf58b6 100644
--- a/drivers/thermal/rcar_gen3_thermal.c
+++ b/drivers/thermal/rcar_gen3_thermal.c
@@ -84,7 +84,7 @@ struct rcar_gen3_thermal_tsc {
 	struct thermal_zone_device *zone;
 	struct equation_coefs coef;
 	int tj_t;
-	int id; /* thermal channel id */
+	unsigned int id; /* thermal channel id */
 };
 
 struct rcar_gen3_thermal_priv {
@@ -310,7 +310,8 @@ static int rcar_gen3_thermal_probe(struct platform_device *pdev)
 	const int *ths_tj_1 = of_device_get_match_data(dev);
 	struct resource *res;
 	struct thermal_zone_device *zone;
-	int ret, i;
+	unsigned int i;
+	int ret;
 
 	/* default values if FUSEs are missing */
 	/* TODO: Read values from hardware on supported platforms */
@@ -376,7 +377,7 @@ static int rcar_gen3_thermal_probe(struct platform_device *pdev)
 		if (ret < 0)
 			goto error_unregister;
 
-		dev_info(dev, "TSC%d: Loaded %d trip points\n", i, ret);
+		dev_info(dev, "TSC%u: Loaded %d trip points\n", i, ret);
 	}
 
 	priv->num_tscs = i;
-- 
2.33.0



