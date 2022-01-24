Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C46784999DC
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377680AbiAXViK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:38:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444177AbiAXV1G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:27:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25713C073214;
        Mon, 24 Jan 2022 12:18:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF4F9B8121C;
        Mon, 24 Jan 2022 20:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFEE8C340E8;
        Mon, 24 Jan 2022 20:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055502;
        bh=muVOtGtyr0Hg8KOiY7lMxc783mCGaGKnx1t//W1goEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MMgTjbDD3FA6u0pxxk0galDRdp2DWSib+vuNozcjTojjiXfvmgLCaw6ya9Kxy1qBJ
         ADxKPtfNk63kDtvlVcKiaPihgll0jwLWzQgYi0VxGz6edO7vDSALQyMk8eCQOmeMUT
         laEj6HqoQ/+Y0mxO9DD1N/ZDqbqOxCk6VEdKvaJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 172/846] net: stmmac: Add platform level debug register dump feature
Date:   Mon, 24 Jan 2022 19:34:49 +0100
Message-Id: <20220124184106.909212033@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bhupesh Sharma <bhupesh.sharma@linaro.org>

[ Upstream commit 4047b9db1aa7512a10ba3560a3f63821c8c40235 ]

dwmac-qcom-ethqos currently exposes a mechanism to dump rgmii registers
after the 'stmmac_dvr_probe()' returns. However with commit
5ec55823438e ("net: stmmac: add clocks management for gmac driver"),
we now let 'pm_runtime_put()' disable the clocks before returning from
'stmmac_dvr_probe()'.

This causes a crash when 'rgmii_dump()' register dumps are enabled,
as the clocks are already off.

Since other dwmac drivers (possible future users as well) might
require a similar register dump feature, introduce a platform level
callback to allow the same.

This fixes the crash noticed while enabling rgmii_dump() dumps in
dwmac-qcom-ethqos driver as well. It also allows future changes
to keep a invoking the register dump callback from the correct
place inside 'stmmac_dvr_probe()'.

Fixes: 5ec55823438e ("net: stmmac: add clocks management for gmac driver")
Cc: Joakim Zhang <qiangqing.zhang@nxp.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c | 7 ++++---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c       | 3 +++
 include/linux/stmmac.h                                  | 1 +
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index 5c74b6279d690..6b1d9e8879f46 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -113,8 +113,10 @@ static void rgmii_updatel(struct qcom_ethqos *ethqos,
 	rgmii_writel(ethqos, temp, offset);
 }
 
-static void rgmii_dump(struct qcom_ethqos *ethqos)
+static void rgmii_dump(void *priv)
 {
+	struct qcom_ethqos *ethqos = priv;
+
 	dev_dbg(&ethqos->pdev->dev, "Rgmii register dump\n");
 	dev_dbg(&ethqos->pdev->dev, "RGMII_IO_MACRO_CONFIG: %x\n",
 		rgmii_readl(ethqos, RGMII_IO_MACRO_CONFIG));
@@ -499,6 +501,7 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 
 	plat_dat->bsp_priv = ethqos;
 	plat_dat->fix_mac_speed = ethqos_fix_mac_speed;
+	plat_dat->dump_debug_regs = rgmii_dump;
 	plat_dat->has_gmac4 = 1;
 	plat_dat->pmt = 1;
 	plat_dat->tso_en = of_property_read_bool(np, "snps,tso");
@@ -507,8 +510,6 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_clk;
 
-	rgmii_dump(ethqos);
-
 	return ret;
 
 err_clk:
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 3422f0746d825..06e5431cf51df 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7077,6 +7077,9 @@ int stmmac_dvr_probe(struct device *device,
 	stmmac_init_fs(ndev);
 #endif
 
+	if (priv->plat->dump_debug_regs)
+		priv->plat->dump_debug_regs(priv->plat->bsp_priv);
+
 	/* Let pm_runtime_put() disable the clocks.
 	 * If CONFIG_PM is not enabled, the clocks will stay powered.
 	 */
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index a6f03b36fc4f7..1450397fc0bcd 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -233,6 +233,7 @@ struct plat_stmmacenet_data {
 	int (*clks_config)(void *priv, bool enabled);
 	int (*crosststamp)(ktime_t *device, struct system_counterval_t *system,
 			   void *ctx);
+	void (*dump_debug_regs)(void *priv);
 	void *bsp_priv;
 	struct clk *stmmac_clk;
 	struct clk *pclk;
-- 
2.34.1



