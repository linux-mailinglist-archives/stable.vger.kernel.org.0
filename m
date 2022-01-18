Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24DA491626
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234865AbiARCcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:32:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40436 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245655AbiARC3D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:29:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91BB9B81253;
        Tue, 18 Jan 2022 02:29:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83365C36AF4;
        Tue, 18 Jan 2022 02:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472941;
        bh=xsfclcnth22emOhXnExQDbZEHeQPjA9k8JwPqBUjW/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b2oh9ayRpf4MxDWfq/+vVzR1aR64v2/7EqWF0oN6f+SPg6qkP4xhs+Mypm1m2iWwJ
         9ETgpG9XETKJN8/cDlhS528FLQBpVkxlb52zg8OygbEs4goRJ7zC72OTrUg+ovnbLC
         LpwGkl+jRQI1EOaBDBFgN53/6WQUGrwXpw65lWJf0yh9A5RFZO4uE70YnJbeHMaj8g
         /0KI9tfwEMPPFUOY+ia5n4aw8Ag1BMX0/8sXRwZKqTjSVkKrLtU5oTl4Yco7MGWbUv
         lh2SyjoIGH7kLRviFMcnVSRS4QKVXZL0fz3i8fhzztMxwg8J1dlOP8euX2LluJ6uuG
         rgitUb6cqOX0Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hector Martin <marcan@marcan.st>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 169/217] mmc: sdhci-pci-gli: GL9755: Support for CD/WP inversion on OF platforms
Date:   Mon, 17 Jan 2022 21:18:52 -0500
Message-Id: <20220118021940.1942199-169-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
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

