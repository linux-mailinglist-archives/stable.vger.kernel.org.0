Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7954917EC
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343607AbiARCng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:43:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56008 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239896AbiARCid (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:38:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 147DB61291;
        Tue, 18 Jan 2022 02:38:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D5FC36AF3;
        Tue, 18 Jan 2022 02:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473512;
        bh=xsfclcnth22emOhXnExQDbZEHeQPjA9k8JwPqBUjW/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DiH2120Roex9uNV4zrMSXP6w7UAnR096Csr5RSJVpHhoRJ6Pw5pMdT2gg0NkEotOF
         vNBiWO90RlknVl34w9opYU+EEVTO+cz95zXLcx7dJAndNE0iF1lK30W8K//nQgYXs1
         Pgqx/g8SXj9TMijz9QoEMQi//On1aDhqEa1Ak0TgRnLRV+roREq3zf+T0BVk0RvYM+
         b8+kPb5DFygRGr0OZYEhI9qD22GJztQMs4i+8XOqzY/X8GKwaxYVkYSBsNJmHW7Z5g
         SvEniROPKoIpNgHk/7i8uWoXAkuCG2j8D/n8WRWB7eQ6eksC0QTc5F1/Vx0JJXw6Z1
         UYJrFduYNdXQw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hector Martin <marcan@marcan.st>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 143/188] mmc: sdhci-pci-gli: GL9755: Support for CD/WP inversion on OF platforms
Date:   Mon, 17 Jan 2022 21:31:07 -0500
Message-Id: <20220118023152.1948105-143-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hector Martin <marcan@marcan.st>

[ Upstream commit 189f1d9bc3a5ea3e442e119e4a5deda63da8c462 ]

This is required on some Apple ARM64 laptops using this controller.
As is typical on DT platforms, pull these quirks from the device tree
using the standard mmc bindings.

See Documentation/devicetree/bindings/mmc/mmc-controller.yaml

Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Hector Martin <marcan@marcan.st>
Link: https://lore.kernel.org/r/20211215161045.38843-2-marcan@marcan.st
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-pci-gli.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/mmc/host/sdhci-pci-gli.c b/drivers/mmc/host/sdhci-pci-gli.c
index 4fd99c1e82ba3..ad50f16658fe2 100644
--- a/drivers/mmc/host/sdhci-pci-gli.c
+++ b/drivers/mmc/host/sdhci-pci-gli.c
@@ -12,6 +12,7 @@
 #include <linux/pci.h>
 #include <linux/mmc/mmc.h>
 #include <linux/delay.h>
+#include <linux/of.h>
 #include "sdhci.h"
 #include "sdhci-pci.h"
 #include "cqhci.h"
@@ -116,6 +117,8 @@
 #define PCI_GLI_9755_PECONF   0x44
 #define   PCI_GLI_9755_LFCLK    GENMASK(14, 12)
 #define   PCI_GLI_9755_DMACLK   BIT(29)
+#define   PCI_GLI_9755_INVERT_CD  BIT(30)
+#define   PCI_GLI_9755_INVERT_WP  BIT(31)
 
 #define PCI_GLI_9755_CFG2          0x48
 #define   PCI_GLI_9755_CFG2_L1DLY    GENMASK(28, 24)
@@ -570,6 +573,14 @@ static void gl9755_hw_setting(struct sdhci_pci_slot *slot)
 	gl9755_wt_on(pdev);
 
 	pci_read_config_dword(pdev, PCI_GLI_9755_PECONF, &value);
+	/*
+	 * Apple ARM64 platforms using these chips may have
+	 * inverted CD/WP detection.
+	 */
+	if (of_property_read_bool(pdev->dev.of_node, "cd-inverted"))
+		value |= PCI_GLI_9755_INVERT_CD;
+	if (of_property_read_bool(pdev->dev.of_node, "wp-inverted"))
+		value |= PCI_GLI_9755_INVERT_WP;
 	value &= ~PCI_GLI_9755_LFCLK;
 	value &= ~PCI_GLI_9755_DMACLK;
 	pci_write_config_dword(pdev, PCI_GLI_9755_PECONF, value);
-- 
2.34.1

