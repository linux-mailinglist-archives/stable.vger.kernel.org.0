Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CACFB190FF9
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbgCXNY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:24:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728938AbgCXNYY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:24:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AD6B208C3;
        Tue, 24 Mar 2020 13:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056264;
        bh=JMSM1luKAuE5kdgCyq1bEGHhHwVBpP6yWiX8i/xm41Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lq/A1tNEfHvtsqzfP27auLc0S7IWS/VBC6yCsmF3s6y/IwRrW9wf1DLkgHtfQ7cM0
         okeyLTqUju22ml7QbzvKvBx1H7krsTykWt+tUSC62bJcevN+fdzQ8x9uy80N/405oo
         JR8XLu8ovHcYyddH/zFcfID6WJWe9AYiE6DzUI/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.5 073/119] mmc: sdhci-cadence: set SDHCI_QUIRK2_PRESET_VALUE_BROKEN for UniPhier
Date:   Tue, 24 Mar 2020 14:10:58 +0100
Message-Id: <20200324130815.526127999@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

commit 18b587b45c13bb6a07ed0edac15f06892593d07a upstream.

The SDHCI_PRESET_FOR_* registers are not set for the UniPhier platform
integration. (They are all read as zeros).

Set the SDHCI_QUIRK2_PRESET_VALUE_BROKEN quirk flag. Otherwise, the
High Speed DDR mode on the eMMC controller (MMC_TIMING_MMC_DDR52)
would not work.

I split the platform data to give no impact to other platforms,
although the UniPhier platform is currently only the upstream user
of this IP.

The SDHCI_QUIRK2_PRESET_VALUE_BROKEN flag is set if the compatible
string matches to "socionext,uniphier-sd4hc".

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200312104257.21017-1-yamada.masahiro@socionext.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-cadence.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/sdhci-cadence.c
+++ b/drivers/mmc/host/sdhci-cadence.c
@@ -11,6 +11,7 @@
 #include <linux/mmc/host.h>
 #include <linux/mmc/mmc.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 
 #include "sdhci-pltfm.h"
 
@@ -235,6 +236,11 @@ static const struct sdhci_ops sdhci_cdns
 	.set_uhs_signaling = sdhci_cdns_set_uhs_signaling,
 };
 
+static const struct sdhci_pltfm_data sdhci_cdns_uniphier_pltfm_data = {
+	.ops = &sdhci_cdns_ops,
+	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN,
+};
+
 static const struct sdhci_pltfm_data sdhci_cdns_pltfm_data = {
 	.ops = &sdhci_cdns_ops,
 };
@@ -334,6 +340,7 @@ static void sdhci_cdns_hs400_enhanced_st
 static int sdhci_cdns_probe(struct platform_device *pdev)
 {
 	struct sdhci_host *host;
+	const struct sdhci_pltfm_data *data;
 	struct sdhci_pltfm_host *pltfm_host;
 	struct sdhci_cdns_priv *priv;
 	struct clk *clk;
@@ -350,8 +357,12 @@ static int sdhci_cdns_probe(struct platf
 	if (ret)
 		return ret;
 
+	data = of_device_get_match_data(dev);
+	if (!data)
+		data = &sdhci_cdns_pltfm_data;
+
 	nr_phy_params = sdhci_cdns_phy_param_count(dev->of_node);
-	host = sdhci_pltfm_init(pdev, &sdhci_cdns_pltfm_data,
+	host = sdhci_pltfm_init(pdev, data,
 				struct_size(priv, phy_params, nr_phy_params));
 	if (IS_ERR(host)) {
 		ret = PTR_ERR(host);
@@ -431,7 +442,10 @@ static const struct dev_pm_ops sdhci_cdn
 };
 
 static const struct of_device_id sdhci_cdns_match[] = {
-	{ .compatible = "socionext,uniphier-sd4hc" },
+	{
+		.compatible = "socionext,uniphier-sd4hc",
+		.data = &sdhci_cdns_uniphier_pltfm_data,
+	},
 	{ .compatible = "cdns,sd4hc" },
 	{ /* sentinel */ }
 };


