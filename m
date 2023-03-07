Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97CAE6AE96E
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbjCGRYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:24:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbjCGRXj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:23:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C565BA02A7
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:19:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D331B819AC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:19:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE66C433A8;
        Tue,  7 Mar 2023 17:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209552;
        bh=tOf2/A02JuPTdrXHDFh7J2qjHSVFBS/ForIMHDsIT1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2VIlrsbSw/rMZGJQ/zyOz3f7KqFJt9Y8jlkInvuiJcyZrR3WdUFxon4j6lX9H8MHw
         5mqKfJRnnNF/qlANrKG+oHqCONuaiHAviA71InhEbXYhXU0pvhCrn7ZYgoguXiAU3A
         8r3zkZzSnyxdvPLIUO7P9LJjeCiy/9U7bc7ot2GY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Siddharth Vadapalli <s-vadapalli@ti.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Roger Quadros <rogerq@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0224/1001] net: ethernet: ti: am65-cpsw/cpts: Fix CPTS release action
Date:   Tue,  7 Mar 2023 17:49:56 +0100
Message-Id: <20230307170031.602236736@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Siddharth Vadapalli <s-vadapalli@ti.com>

[ Upstream commit 4ad8766cd3982744e53f107f378d2c65b76ff9a8 ]

The am65_cpts_release() function is registered as a devm_action in the
am65_cpts_create() function in am65-cpts driver. When the am65-cpsw driver
invokes am65_cpts_create(), am65_cpts_release() is added in the set of devm
actions associated with the am65-cpsw driver's device.

In the event of probe failure or probe deferral, the platform_drv_probe()
function invokes dev_pm_domain_detach() which powers off the CPSW and the
CPSW's CPTS hardware, both of which share the same power domain. Since the
am65_cpts_disable() function invoked by the am65_cpts_release() function
attempts to reset the CPTS hardware by writing to its registers, the CPTS
hardware is assumed to be powered on at this point. However, the hardware
is powered off before the devm actions are executed.

Fix this by getting rid of the devm action for am65_cpts_release() and
invoking it directly on the cleanup and exit paths.

Fixes: f6bd59526ca5 ("net: ethernet: ti: introduce am654 common platform time sync driver")
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c |  2 ++
 drivers/net/ethernet/ti/am65-cpts.c      | 15 +++++----------
 drivers/net/ethernet/ti/am65-cpts.h      |  5 +++++
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 6cda4b7c10cb6..3e17152798554 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2852,6 +2852,7 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 
 err_free_phylink:
 	am65_cpsw_nuss_phylink_cleanup(common);
+	am65_cpts_release(common->cpts);
 err_of_clear:
 	of_platform_device_destroy(common->mdio_dev, NULL);
 err_pm_clear:
@@ -2880,6 +2881,7 @@ static int am65_cpsw_nuss_remove(struct platform_device *pdev)
 	 */
 	am65_cpsw_nuss_cleanup_ndev(common);
 	am65_cpsw_nuss_phylink_cleanup(common);
+	am65_cpts_release(common->cpts);
 
 	of_platform_device_destroy(common->mdio_dev, NULL);
 
diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
index 9535396b28cd9..a297890152d92 100644
--- a/drivers/net/ethernet/ti/am65-cpts.c
+++ b/drivers/net/ethernet/ti/am65-cpts.c
@@ -929,14 +929,13 @@ static int am65_cpts_of_parse(struct am65_cpts *cpts, struct device_node *node)
 	return cpts_of_mux_clk_setup(cpts, node);
 }
 
-static void am65_cpts_release(void *data)
+void am65_cpts_release(struct am65_cpts *cpts)
 {
-	struct am65_cpts *cpts = data;
-
 	ptp_clock_unregister(cpts->ptp_clock);
 	am65_cpts_disable(cpts);
 	clk_disable_unprepare(cpts->refclk);
 }
+EXPORT_SYMBOL_GPL(am65_cpts_release);
 
 struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
 				   struct device_node *node)
@@ -1014,18 +1013,12 @@ struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
 	}
 	cpts->phc_index = ptp_clock_index(cpts->ptp_clock);
 
-	ret = devm_add_action_or_reset(dev, am65_cpts_release, cpts);
-	if (ret) {
-		dev_err(dev, "failed to add ptpclk reset action %d", ret);
-		return ERR_PTR(ret);
-	}
-
 	ret = devm_request_threaded_irq(dev, cpts->irq, NULL,
 					am65_cpts_interrupt,
 					IRQF_ONESHOT, dev_name(dev), cpts);
 	if (ret < 0) {
 		dev_err(cpts->dev, "error attaching irq %d\n", ret);
-		return ERR_PTR(ret);
+		goto reset_ptpclk;
 	}
 
 	dev_info(dev, "CPTS ver 0x%08x, freq:%u, add_val:%u\n",
@@ -1034,6 +1027,8 @@ struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
 
 	return cpts;
 
+reset_ptpclk:
+	am65_cpts_release(cpts);
 refclk_disable:
 	clk_disable_unprepare(cpts->refclk);
 	return ERR_PTR(ret);
diff --git a/drivers/net/ethernet/ti/am65-cpts.h b/drivers/net/ethernet/ti/am65-cpts.h
index bd08f4b2edd2d..6e14df0be1137 100644
--- a/drivers/net/ethernet/ti/am65-cpts.h
+++ b/drivers/net/ethernet/ti/am65-cpts.h
@@ -18,6 +18,7 @@ struct am65_cpts_estf_cfg {
 };
 
 #if IS_ENABLED(CONFIG_TI_K3_AM65_CPTS)
+void am65_cpts_release(struct am65_cpts *cpts);
 struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
 				   struct device_node *node);
 int am65_cpts_phc_index(struct am65_cpts *cpts);
@@ -31,6 +32,10 @@ void am65_cpts_estf_disable(struct am65_cpts *cpts, int idx);
 void am65_cpts_suspend(struct am65_cpts *cpts);
 void am65_cpts_resume(struct am65_cpts *cpts);
 #else
+static inline void am65_cpts_release(struct am65_cpts *cpts)
+{
+}
+
 static inline struct am65_cpts *am65_cpts_create(struct device *dev,
 						 void __iomem *regs,
 						 struct device_node *node)
-- 
2.39.2



