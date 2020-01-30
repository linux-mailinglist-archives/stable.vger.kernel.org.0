Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF4D14E199
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731088AbgA3Spt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:45:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:55466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731083AbgA3Spp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:45:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C91B21734;
        Thu, 30 Jan 2020 18:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409943;
        bh=mjJrS8A36FDuKb9fONPOUFh7RpbbhF9DWKvJqd6eeek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pEpH8Qh1CcCxq0iIynqjX/6f+3ZRCA7ZNhy6iXyNui4G82bHTFkEBR/4syR2gG14m
         GtMdWnWNCK5jIgljLDrJZzftyTbQ+sB9b/0HDUgZWHqOtL1YCBj/jwt1LqMPwKFPX/
         m/aC4QrdmGtqWfiBeCs3OocYhgU5GJZSxN/OrU1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raul E Rangel <rrangel@chromium.org>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 092/110] mmc: sdhci-pci: Quirk for AMD SDHC Device 0x7906
Date:   Thu, 30 Jan 2020 19:39:08 +0100
Message-Id: <20200130183624.964768848@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raul E Rangel <rrangel@chromium.org>

[ Upstream commit 7a869f00bb15bcefb8804d798a49b086267b03e6 ]

AMD SDHC 0x7906 requires a hard reset to clear all internal state.
Otherwise it can get into a bad state where the DATA lines are always
read as zeros.

This change requires firmware that can transition the device into
D3Cold for it to work correctly. If the firmware does not support
transitioning to D3Cold then the power state transitions are a no-op.

Signed-off-by: Raul E Rangel <rrangel@chromium.org>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-pci-core.c | 51 ++++++++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-pci-core.c b/drivers/mmc/host/sdhci-pci-core.c
index 642a9667db4dd..96a163f36a395 100644
--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -21,6 +21,7 @@
 #include <linux/mmc/mmc.h>
 #include <linux/scatterlist.h>
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include <linux/gpio.h>
 #include <linux/pm_runtime.h>
 #include <linux/mmc/slot-gpio.h>
@@ -1598,11 +1599,59 @@ static int amd_probe(struct sdhci_pci_chip *chip)
 	return 0;
 }
 
+static u32 sdhci_read_present_state(struct sdhci_host *host)
+{
+	return sdhci_readl(host, SDHCI_PRESENT_STATE);
+}
+
+void amd_sdhci_reset(struct sdhci_host *host, u8 mask)
+{
+	struct sdhci_pci_slot *slot = sdhci_priv(host);
+	struct pci_dev *pdev = slot->chip->pdev;
+	u32 present_state;
+
+	/*
+	 * SDHC 0x7906 requires a hard reset to clear all internal state.
+	 * Otherwise it can get into a bad state where the DATA lines are always
+	 * read as zeros.
+	 */
+	if (pdev->device == 0x7906 && (mask & SDHCI_RESET_ALL)) {
+		pci_clear_master(pdev);
+
+		pci_save_state(pdev);
+
+		pci_set_power_state(pdev, PCI_D3cold);
+		pr_debug("%s: power_state=%u\n", mmc_hostname(host->mmc),
+			pdev->current_state);
+		pci_set_power_state(pdev, PCI_D0);
+
+		pci_restore_state(pdev);
+
+		/*
+		 * SDHCI_RESET_ALL says the card detect logic should not be
+		 * reset, but since we need to reset the entire controller
+		 * we should wait until the card detect logic has stabilized.
+		 *
+		 * This normally takes about 40ms.
+		 */
+		readx_poll_timeout(
+			sdhci_read_present_state,
+			host,
+			present_state,
+			present_state & SDHCI_CD_STABLE,
+			10000,
+			100000
+		);
+	}
+
+	return sdhci_reset(host, mask);
+}
+
 static const struct sdhci_ops amd_sdhci_pci_ops = {
 	.set_clock			= sdhci_set_clock,
 	.enable_dma			= sdhci_pci_enable_dma,
 	.set_bus_width			= sdhci_set_bus_width,
-	.reset				= sdhci_reset,
+	.reset				= amd_sdhci_reset,
 	.set_uhs_signaling		= sdhci_set_uhs_signaling,
 };
 
-- 
2.20.1



