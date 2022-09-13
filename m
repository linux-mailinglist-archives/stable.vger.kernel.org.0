Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61DAA5B7889
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 19:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233487AbiIMRo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 13:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233455AbiIMRoc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 13:44:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ADE45FF7D;
        Tue, 13 Sep 2022 09:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18FF3B80FAC;
        Tue, 13 Sep 2022 14:33:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F0AC4314E;
        Tue, 13 Sep 2022 14:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079600;
        bh=5zgtdzP6Uj3MhmAN1sLcUUmjwImUtlCWT3xicPNs8Vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MC6WB++Thc4O4SQzcvZt5YctE/OgsFtSy3DAm9wNWVKttCj/3IFZCf8DEtLaR+HDC
         ClSxgCD2n1k8dxLOL6dcGpnZ7gxYmGabcZc/RFwGWkCdPkCN3sWNxNwYOr+0YVm5yt
         rq5459ncGX04u1ZUVhok/UvW/hz4bJ8OaLTFBR7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 63/79] soc: brcmstb: pm-arm: Fix refcount leak and __iomem leak bugs
Date:   Tue, 13 Sep 2022 16:07:21 +0200
Message-Id: <20220913140351.938232316@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140348.835121645@linuxfoundation.org>
References: <20220913140348.835121645@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 1085f5080647f0c9f357c270a537869191f7f2a1 ]

In brcmstb_pm_probe(), there are two kinds of leak bugs:

(1) we need to add of_node_put() when for_each__matching_node() breaks
(2) we need to add iounmap() for each iomap in fail path

Fixes: 0b741b8234c8 ("soc: bcm: brcmstb: Add support for S2/S3/S5 suspend states (ARM)")
Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20220707015620.306468-1-windhl@126.com
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/bcm/brcmstb/pm/pm-arm.c | 50 ++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 11 deletions(-)

diff --git a/drivers/soc/bcm/brcmstb/pm/pm-arm.c b/drivers/soc/bcm/brcmstb/pm/pm-arm.c
index f4ad45a1efabe..fd124e0850207 100644
--- a/drivers/soc/bcm/brcmstb/pm/pm-arm.c
+++ b/drivers/soc/bcm/brcmstb/pm/pm-arm.c
@@ -689,13 +689,14 @@ static int brcmstb_pm_probe(struct platform_device *pdev)
 	const struct of_device_id *of_id = NULL;
 	struct device_node *dn;
 	void __iomem *base;
-	int ret, i;
+	int ret, i, s;
 
 	/* AON ctrl registers */
 	base = brcmstb_ioremap_match(aon_ctrl_dt_ids, 0, NULL);
 	if (IS_ERR(base)) {
 		pr_err("error mapping AON_CTRL\n");
-		return PTR_ERR(base);
+		ret = PTR_ERR(base);
+		goto aon_err;
 	}
 	ctrl.aon_ctrl_base = base;
 
@@ -705,8 +706,10 @@ static int brcmstb_pm_probe(struct platform_device *pdev)
 		/* Assume standard offset */
 		ctrl.aon_sram = ctrl.aon_ctrl_base +
 				     AON_CTRL_SYSTEM_DATA_RAM_OFS;
+		s = 0;
 	} else {
 		ctrl.aon_sram = base;
+		s = 1;
 	}
 
 	writel_relaxed(0, ctrl.aon_sram + AON_REG_PANIC);
@@ -716,7 +719,8 @@ static int brcmstb_pm_probe(struct platform_device *pdev)
 				     (const void **)&ddr_phy_data);
 	if (IS_ERR(base)) {
 		pr_err("error mapping DDR PHY\n");
-		return PTR_ERR(base);
+		ret = PTR_ERR(base);
+		goto ddr_phy_err;
 	}
 	ctrl.support_warm_boot = ddr_phy_data->supports_warm_boot;
 	ctrl.pll_status_offset = ddr_phy_data->pll_status_offset;
@@ -736,17 +740,20 @@ static int brcmstb_pm_probe(struct platform_device *pdev)
 	for_each_matching_node(dn, ddr_shimphy_dt_ids) {
 		i = ctrl.num_memc;
 		if (i >= MAX_NUM_MEMC) {
+			of_node_put(dn);
 			pr_warn("too many MEMCs (max %d)\n", MAX_NUM_MEMC);
 			break;
 		}
 
 		base = of_io_request_and_map(dn, 0, dn->full_name);
 		if (IS_ERR(base)) {
+			of_node_put(dn);
 			if (!ctrl.support_warm_boot)
 				break;
 
 			pr_err("error mapping DDR SHIMPHY %d\n", i);
-			return PTR_ERR(base);
+			ret = PTR_ERR(base);
+			goto ddr_shimphy_err;
 		}
 		ctrl.memcs[i].ddr_shimphy_base = base;
 		ctrl.num_memc++;
@@ -757,14 +764,18 @@ static int brcmstb_pm_probe(struct platform_device *pdev)
 	for_each_matching_node(dn, brcmstb_memc_of_match) {
 		base = of_iomap(dn, 0);
 		if (!base) {
+			of_node_put(dn);
 			pr_err("error mapping DDR Sequencer %d\n", i);
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto brcmstb_memc_err;
 		}
 
 		of_id = of_match_node(brcmstb_memc_of_match, dn);
 		if (!of_id) {
 			iounmap(base);
-			return -EINVAL;
+			of_node_put(dn);
+			ret = -EINVAL;
+			goto brcmstb_memc_err;
 		}
 
 		ddr_seq_data = of_id->data;
@@ -784,21 +795,24 @@ static int brcmstb_pm_probe(struct platform_device *pdev)
 	dn = of_find_matching_node(NULL, sram_dt_ids);
 	if (!dn) {
 		pr_err("SRAM not found\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto brcmstb_memc_err;
 	}
 
 	ret = brcmstb_init_sram(dn);
 	of_node_put(dn);
 	if (ret) {
 		pr_err("error setting up SRAM for PM\n");
-		return ret;
+		goto brcmstb_memc_err;
 	}
 
 	ctrl.pdev = pdev;
 
 	ctrl.s3_params = kmalloc(sizeof(*ctrl.s3_params), GFP_KERNEL);
-	if (!ctrl.s3_params)
-		return -ENOMEM;
+	if (!ctrl.s3_params) {
+		ret = -ENOMEM;
+		goto s3_params_err;
+	}
 	ctrl.s3_params_pa = dma_map_single(&pdev->dev, ctrl.s3_params,
 					   sizeof(*ctrl.s3_params),
 					   DMA_TO_DEVICE);
@@ -818,7 +832,21 @@ static int brcmstb_pm_probe(struct platform_device *pdev)
 
 out:
 	kfree(ctrl.s3_params);
-
+s3_params_err:
+	iounmap(ctrl.boot_sram);
+brcmstb_memc_err:
+	for (i--; i >= 0; i--)
+		iounmap(ctrl.memcs[i].ddr_ctrl);
+ddr_shimphy_err:
+	for (i = 0; i < ctrl.num_memc; i++)
+		iounmap(ctrl.memcs[i].ddr_shimphy_base);
+
+	iounmap(ctrl.memcs[0].ddr_phy_base);
+ddr_phy_err:
+	iounmap(ctrl.aon_ctrl_base);
+	if (s)
+		iounmap(ctrl.aon_sram);
+aon_err:
 	pr_warn("PM: initialization failed with code %d\n", ret);
 
 	return ret;
-- 
2.35.1



