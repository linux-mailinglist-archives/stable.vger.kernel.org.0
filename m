Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD33247245
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391351AbgHQSkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:40:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:45360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730837AbgHQP5v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:57:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF03820729;
        Mon, 17 Aug 2020 15:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679870;
        bh=CsHthHehN7Oq9N7RKyJZNpDPp0iklDcRQQ7X8Zxd+CQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CvLjzCK2Bnj+RzxGUeJCNiIx75mQBSCWhsFDzxfrfWzow4QBXVSJdN+egneeKlLSP
         mf0Jph3gLWkhAZyol1xqzCisR0gsSNz8OomIWfwiUGvU5OiPMsU5vnrySOoa0mAn/z
         FaaKZk5gw3MDyrbPqwyRcEMAkwbgEZOqBy3rdz/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 5.7 363/393] PM / devfreq: rk3399_dmc: Fix kernel oops when rockchip,pmu is absent
Date:   Mon, 17 Aug 2020 17:16:53 +0200
Message-Id: <20200817143837.210716874@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 63ef91f24f9bfc70b6446319f6cabfd094481372 upstream.

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
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/devfreq/rk3399_dmc.c |   42 +++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

--- a/drivers/devfreq/rk3399_dmc.c
+++ b/drivers/devfreq/rk3399_dmc.c
@@ -95,18 +95,20 @@ static int rk3399_dmcfreq_target(struct
 
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
@@ -371,13 +373,14 @@ static int rk3399_dmcfreq_probe(struct p
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
@@ -399,6 +402,7 @@ static int rk3399_dmcfreq_probe(struct p
 		goto err_edev;
 	};
 
+no_pmu:
 	arm_smccc_smc(ROCKCHIP_SIP_DRAM_FREQ, 0, 0,
 		      ROCKCHIP_SIP_CONFIG_DRAM_INIT,
 		      0, 0, 0, 0, &res);


