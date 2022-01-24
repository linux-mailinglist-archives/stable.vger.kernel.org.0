Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41803499C56
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1579055AbiAXWEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:04:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1577796AbiAXWBF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:01:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F06C02B8FD;
        Mon, 24 Jan 2022 12:40:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8218BB81057;
        Mon, 24 Jan 2022 20:40:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACAC8C340E5;
        Mon, 24 Jan 2022 20:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056824;
        bh=xsfclcnth22emOhXnExQDbZEHeQPjA9k8JwPqBUjW/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AYa8Gz0vDEf9qjpi4XHtSAn6O5tGog8CC5G2kbITzLF6Vn122b/KYdEsND65ddJ6Q
         DM5O6fuYcGsd2WgdDpuZmEujwf0dkXjjcUnlqhFR8liBplnM7APqAu0kBcG7Vm5ARA
         SstBSRXxgT+iwjTQSKShiVMvxJWhmDI2NtvgbFII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Hector Martin <marcan@marcan.st>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 580/846] mmc: sdhci-pci-gli: GL9755: Support for CD/WP inversion on OF platforms
Date:   Mon, 24 Jan 2022 19:41:37 +0100
Message-Id: <20220124184121.056138082@linuxfoundation.org>
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



