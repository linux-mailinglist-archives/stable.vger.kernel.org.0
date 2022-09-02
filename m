Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8175AB078
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237882AbiIBMya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238059AbiIBMxm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:53:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 991DBDF4E9;
        Fri,  2 Sep 2022 05:38:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03DF4B82AC1;
        Fri,  2 Sep 2022 12:37:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229FBC433D6;
        Fri,  2 Sep 2022 12:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122248;
        bh=57v22oWKlBJNCWurriBwjO5ps+GiYL40nKe2KYU6GkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hfdlv0DnCdov4ZDvSLzT6deg9Dii6bpuGI5ygX8SbjXwoY1U1FRrZ/YtCdt+W6jeB
         2SFXMgKYcpcOaNRWcwmLujvPcKfLYg5AAiwFzgR+LPsLWLcknr+qPQhKO8OKwDan8t
         V/sIpOYPpi75FyHOwHKpSPyY7D3HDwqPwclt1omM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yifeng Zhao <yifeng.zhao@rock-chips.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 29/72] mmc: sdhci-of-dwcmshc: add reset call back for rockchip Socs
Date:   Fri,  2 Sep 2022 14:19:05 +0200
Message-Id: <20220902121405.750003506@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
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

From: Yifeng Zhao <yifeng.zhao@rock-chips.com>

[ Upstream commit 70f832206fe72e9998b46363e8e59e89b0b757bc ]

The reset function build in the SDHCI will not reset the logic
circuit related to the tuning function, which may cause data
reading errors. Resetting the complete SDHCI controller through
the reset controller fixes the issue.

Signed-off-by: Yifeng Zhao <yifeng.zhao@rock-chips.com>
[rebase, use optional variant of reset getter]
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Link: https://lore.kernel.org/r/20220504213251.264819-10-sebastian.reichel@collabora.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-of-dwcmshc.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-of-dwcmshc.c b/drivers/mmc/host/sdhci-of-dwcmshc.c
index bac874ab0b33a..3a1b5ba364051 100644
--- a/drivers/mmc/host/sdhci-of-dwcmshc.c
+++ b/drivers/mmc/host/sdhci-of-dwcmshc.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/reset.h>
 #include <linux/sizes.h>
 
 #include "sdhci-pltfm.h"
@@ -63,6 +64,7 @@
 struct rk3568_priv {
 	/* Rockchip specified optional clocks */
 	struct clk_bulk_data rockchip_clks[RK3568_MAX_CLKS];
+	struct reset_control *reset;
 	u8 txclk_tapnum;
 };
 
@@ -255,6 +257,21 @@ static void dwcmshc_rk3568_set_clock(struct sdhci_host *host, unsigned int clock
 	sdhci_writel(host, extra, DWCMSHC_EMMC_DLL_STRBIN);
 }
 
+static void rk35xx_sdhci_reset(struct sdhci_host *host, u8 mask)
+{
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct dwcmshc_priv *dwc_priv = sdhci_pltfm_priv(pltfm_host);
+	struct rk35xx_priv *priv = dwc_priv->priv;
+
+	if (mask & SDHCI_RESET_ALL && priv->reset) {
+		reset_control_assert(priv->reset);
+		udelay(1);
+		reset_control_deassert(priv->reset);
+	}
+
+	sdhci_reset(host, mask);
+}
+
 static const struct sdhci_ops sdhci_dwcmshc_ops = {
 	.set_clock		= sdhci_set_clock,
 	.set_bus_width		= sdhci_set_bus_width,
@@ -269,7 +286,7 @@ static const struct sdhci_ops sdhci_dwcmshc_rk3568_ops = {
 	.set_bus_width		= sdhci_set_bus_width,
 	.set_uhs_signaling	= dwcmshc_set_uhs_signaling,
 	.get_max_clock		= sdhci_pltfm_clk_get_max_clock,
-	.reset			= sdhci_reset,
+	.reset			= rk35xx_sdhci_reset,
 	.adma_write_desc	= dwcmshc_adma_write_desc,
 };
 
@@ -292,6 +309,13 @@ static int dwcmshc_rk3568_init(struct sdhci_host *host, struct dwcmshc_priv *dwc
 	int err;
 	struct rk3568_priv *priv = dwc_priv->priv;
 
+	priv->reset = devm_reset_control_array_get_optional_exclusive(mmc_dev(host->mmc));
+	if (IS_ERR(priv->reset)) {
+		err = PTR_ERR(priv->reset);
+		dev_err(mmc_dev(host->mmc), "failed to get reset control %d\n", err);
+		return err;
+	}
+
 	priv->rockchip_clks[0].id = "axi";
 	priv->rockchip_clks[1].id = "block";
 	priv->rockchip_clks[2].id = "timer";
-- 
2.35.1



