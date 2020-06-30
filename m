Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2D8F20F223
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 12:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732196AbgF3KFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 06:05:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:44640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732078AbgF3KFw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Jun 2020 06:05:52 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02BA62073E;
        Tue, 30 Jun 2020 10:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593511552;
        bh=WGsfVoaT6gosQlq2ySDAquPdQTa/aXDxRdmxD1Nsln8=;
        h=From:To:Cc:Subject:Date:From;
        b=um9iXcbbiq0/h4rBLL3CVKNNpdpKp8XNwiBmhB/N1BOewXCoTQv7OhhXdXZq6f9ui
         Ijow/waRSxqxqtWZvi2jPWc9y+xoFjYJ/OGRAqwMc0EOJkcvDXR1W1S/yQT7zbDCba
         +uBUUkYa6Ti/Pk+a4NA0Euc+oJuMGK+VCk/70QcA=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jqD9C-007hs2-EG; Tue, 30 Jun 2020 11:05:50 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Chanwoo Choi <cw00.choi@samsung.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>
Cc:     MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Heiko Stuebner <heiko@sntech.de>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        stable@vger.kernel.org
Subject: [PATCH v3] PM / devfreq: rk3399_dmc: Fix kernel oops when rockchip,pmu is absent
Date:   Tue, 30 Jun 2020 11:05:46 +0100
Message-Id: <20200630100546.862468-1-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: cw00.choi@samsung.com, enric.balletbo@collabora.com, myungjoo.ham@samsung.com, kyungmin.park@samsung.com, heiko@sntech.de, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@android.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Booting a recent kernel on a rk3399-based system (nanopc-t4),
equipped with a recent u-boot and ATF results in an Oops due
to a NULL pointer dereference.

This turns out to be due to the rk3399-dmc driver looking for
an *undocumented* property (rockchip,pmu), and happily using
a NULL pointer when the property isn't there.

Instead, make most of what was brought in with 9173c5ceb035
("PM / devfreq: rk3399_dmc: Pass ODT and auto power down parameters
to TF-A.") conditioned on finding this property in the device-tree,
preventing the driver from exploding.

Cc: stable@vger.kernel.org
Fixes: 9173c5ceb035 ("PM / devfreq: rk3399_dmc: Pass ODT and auto power down parameters to TF-A.")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
* From v2:
  - Trimmed down commit message
  - Cc stable

 drivers/devfreq/rk3399_dmc.c | 42 ++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/devfreq/rk3399_dmc.c b/drivers/devfreq/rk3399_dmc.c
index 24f04f78285b..027769e39f9b 100644
--- a/drivers/devfreq/rk3399_dmc.c
+++ b/drivers/devfreq/rk3399_dmc.c
@@ -95,18 +95,20 @@ static int rk3399_dmcfreq_target(struct device *dev, unsigned long *freq,
 
 	mutex_lock(&dmcfreq->lock);
 
-	if (target_rate >= dmcfreq->odt_dis_freq)
-		odt_enable = true;
-
-	/*
-	 * This makes a SMC call to the TF-A to set the DDR PD (power-down)
-	 * timings and to enable or disable the ODT (on-die termination)
-	 * resistors.
-	 */
-	arm_smccc_smc(ROCKCHIP_SIP_DRAM_FREQ, dmcfreq->odt_pd_arg0,
-		      dmcfreq->odt_pd_arg1,
-		      ROCKCHIP_SIP_CONFIG_DRAM_SET_ODT_PD,
-		      odt_enable, 0, 0, 0, &res);
+	if (dmcfreq->regmap_pmu) {
+		if (target_rate >= dmcfreq->odt_dis_freq)
+			odt_enable = true;
+
+		/*
+		 * This makes a SMC call to the TF-A to set the DDR PD
+		 * (power-down) timings and to enable or disable the
+		 * ODT (on-die termination) resistors.
+		 */
+		arm_smccc_smc(ROCKCHIP_SIP_DRAM_FREQ, dmcfreq->odt_pd_arg0,
+			      dmcfreq->odt_pd_arg1,
+			      ROCKCHIP_SIP_CONFIG_DRAM_SET_ODT_PD,
+			      odt_enable, 0, 0, 0, &res);
+	}
 
 	/*
 	 * If frequency scaling from low to high, adjust voltage first.
@@ -371,13 +373,14 @@ static int rk3399_dmcfreq_probe(struct platform_device *pdev)
 	}
 
 	node = of_parse_phandle(np, "rockchip,pmu", 0);
-	if (node) {
-		data->regmap_pmu = syscon_node_to_regmap(node);
-		of_node_put(node);
-		if (IS_ERR(data->regmap_pmu)) {
-			ret = PTR_ERR(data->regmap_pmu);
-			goto err_edev;
-		}
+	if (!node)
+		goto no_pmu;
+
+	data->regmap_pmu = syscon_node_to_regmap(node);
+	of_node_put(node);
+	if (IS_ERR(data->regmap_pmu)) {
+		ret = PTR_ERR(data->regmap_pmu);
+		goto err_edev;
 	}
 
 	regmap_read(data->regmap_pmu, RK3399_PMUGRF_OS_REG2, &val);
@@ -399,6 +402,7 @@ static int rk3399_dmcfreq_probe(struct platform_device *pdev)
 		goto err_edev;
 	};
 
+no_pmu:
 	arm_smccc_smc(ROCKCHIP_SIP_DRAM_FREQ, 0, 0,
 		      ROCKCHIP_SIP_CONFIG_DRAM_INIT,
 		      0, 0, 0, 0, &res);
-- 
2.27.0

