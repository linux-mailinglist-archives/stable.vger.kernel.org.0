Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09BF925993A
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730782AbgIAQgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:36:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730523AbgIAP3a (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:29:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E1CE206C0;
        Tue,  1 Sep 2020 15:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974169;
        bh=wqqX+cTIgOQPbsHNJEMEc15JcoBSxZtRCl7iHHIeKic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qmryfeqWiN/N8/8Pq85b6JbZI/yX9J+Gje2HzkXbiPKKtrke3Qxq9LR0jEStu7I3/
         qT96n2oIiWRmlOqej3cOlNMzsYSupEXjCgxMgrj0rTiiy5Mt1GofIiWBOiUp4tOlhB
         jeBDnMbyTp0fRBfDrXWk/3CSenPy8H7qk6BwMaKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 072/214] PM / devfreq: rk3399_dmc: Disable devfreq-event device when fails
Date:   Tue,  1 Sep 2020 17:09:12 +0200
Message-Id: <20200901150956.424222905@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangtao Li <tiny.windzz@gmail.com>

[ Upstream commit 39a6e4739c19d5334e552d71ceca544ed84f4b87 ]

The probe process may fail, but the devfreq event device remains
enabled. Call devfreq_event_disable_edev on the error return path.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/devfreq/rk3399_dmc.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/devfreq/rk3399_dmc.c b/drivers/devfreq/rk3399_dmc.c
index 2f1027c5b6475..24f04f78285b7 100644
--- a/drivers/devfreq/rk3399_dmc.c
+++ b/drivers/devfreq/rk3399_dmc.c
@@ -364,7 +364,8 @@ static int rk3399_dmcfreq_probe(struct platform_device *pdev)
 			if (res.a0) {
 				dev_err(dev, "Failed to set dram param: %ld\n",
 					res.a0);
-				return -EINVAL;
+				ret = -EINVAL;
+				goto err_edev;
 			}
 		}
 	}
@@ -373,8 +374,10 @@ static int rk3399_dmcfreq_probe(struct platform_device *pdev)
 	if (node) {
 		data->regmap_pmu = syscon_node_to_regmap(node);
 		of_node_put(node);
-		if (IS_ERR(data->regmap_pmu))
-			return PTR_ERR(data->regmap_pmu);
+		if (IS_ERR(data->regmap_pmu)) {
+			ret = PTR_ERR(data->regmap_pmu);
+			goto err_edev;
+		}
 	}
 
 	regmap_read(data->regmap_pmu, RK3399_PMUGRF_OS_REG2, &val);
@@ -392,7 +395,8 @@ static int rk3399_dmcfreq_probe(struct platform_device *pdev)
 		data->odt_dis_freq = data->timing.lpddr4_odt_dis_freq;
 		break;
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_edev;
 	};
 
 	arm_smccc_smc(ROCKCHIP_SIP_DRAM_FREQ, 0, 0,
@@ -426,7 +430,8 @@ static int rk3399_dmcfreq_probe(struct platform_device *pdev)
 	 */
 	if (dev_pm_opp_of_add_table(dev)) {
 		dev_err(dev, "Invalid operating-points in device tree.\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_edev;
 	}
 
 	of_property_read_u32(np, "upthreshold",
@@ -466,6 +471,9 @@ static int rk3399_dmcfreq_probe(struct platform_device *pdev)
 
 err_free_opp:
 	dev_pm_opp_of_remove_table(&pdev->dev);
+err_edev:
+	devfreq_event_disable_edev(data->edev);
+
 	return ret;
 }
 
-- 
2.25.1



