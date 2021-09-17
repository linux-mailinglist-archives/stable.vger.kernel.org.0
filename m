Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C225F40EF48
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 04:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240937AbhIQCew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 22:34:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:60390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242894AbhIQCej (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 22:34:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD2C2610C8;
        Fri, 17 Sep 2021 02:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631845997;
        bh=oxSEl0L78Bsi4cp4QK3n/uSxdCPFeZyicU0XM9jbVBU=;
        h=From:To:Cc:Subject:Date:From;
        b=a2bnpo6BKrxJC3D4H46G93SWj0SFBSF86U0riNRmMfGaFTrBDRuhh85j81Qt3xhv4
         lJd0LrwjUpYqf+2Z7KWqwxgZ2mAiWKJ/UKrpd8FPmq1+hubhc6eUqxW0qQ5x7cISxo
         zky6B/QlFfCJYmM9B8p2+axa8tMaujMFCk+5jOow+detiyMSO0O36IipcJAWNzJk+U
         K8DEF/sY/Qi7A3rtLeobKBaq85VqhCt0enhfQi3C7FsbCHRyne45Y2G7yxMwZr/1oW
         j0Sx+rEIOxx2wV4f/ixTCD+vdV8F9LBxhFloG4DYZVUnECA3ImAQO4vt81NVSGki0N
         1N/svWf7KSXjw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>, niklas.soderlund@ragnatech.se,
        rui.zhang@intel.com, linux-renesas-soc@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 01/21] thermal/drivers/rcar_gen3_thermal: Store TSC id as unsigned int
Date:   Thu, 16 Sep 2021 22:32:55 -0400
Message-Id: <20210917023315.816225-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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
2.30.2

