Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2E144181E
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbhKAJos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:44:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232892AbhKAJln (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:41:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A24B6120E;
        Mon,  1 Nov 2021 09:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758886;
        bh=wKfcRtTmHWG5jIR9h9tYeyIZJyugVY2tS0GmrlpS9Zc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wmsTyhIWJRoVHlejolTFuCyn4Vzu94KDLetL7+dczh+ccp9FxK4Guc4v+4h/NFYwZ
         Wg98ouHfnu2MmEG2qlxVGw4LOzISllFLYq6RT6Y9+1fxVM3Do5FFVPZl2dY3kgqeOH
         mnyQE9sJifSICr98m3Wrw5IRRwYCUUXok3uUYCis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.14 023/125] mmc: sdhci-pci: Read card detect from ACPI for Intel Merrifield
Date:   Mon,  1 Nov 2021 10:16:36 +0100
Message-Id: <20211101082537.831773918@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 6ab4e2eb5e956a61e4d53cea3ab8c866ba79a830 upstream.

Intel Merrifield platform had been converted to use ACPI enumeration.
However, the driver missed an update to retrieve card detect GPIO.
Fix it here.

Unfortunately we can't rely on CD GPIO state because there are two
different PCB designs in the wild that are using the opposite card
detection sense and there is no way to distinguish those platforms,
that's why ignore CD GPIO completely and use it only as an event.

Fixes: 4590d98f5a4f ("sfi: Remove framework for deprecated firmware")
BugLink: https://github.com/edison-fw/meta-intel-edison/issues/135
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20211013201723.52212-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pci-core.c |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -616,16 +616,12 @@ static int intel_select_drive_strength(s
 	return intel_host->drv_strength;
 }
 
-static int bxt_get_cd(struct mmc_host *mmc)
+static int sdhci_get_cd_nogpio(struct mmc_host *mmc)
 {
-	int gpio_cd = mmc_gpio_get_cd(mmc);
 	struct sdhci_host *host = mmc_priv(mmc);
 	unsigned long flags;
 	int ret = 0;
 
-	if (!gpio_cd)
-		return 0;
-
 	spin_lock_irqsave(&host->lock, flags);
 
 	if (host->flags & SDHCI_DEVICE_DEAD)
@@ -638,6 +634,21 @@ out:
 	return ret;
 }
 
+static int bxt_get_cd(struct mmc_host *mmc)
+{
+	int gpio_cd = mmc_gpio_get_cd(mmc);
+
+	if (!gpio_cd)
+		return 0;
+
+	return sdhci_get_cd_nogpio(mmc);
+}
+
+static int mrfld_get_cd(struct mmc_host *mmc)
+{
+	return sdhci_get_cd_nogpio(mmc);
+}
+
 #define SDHCI_INTEL_PWR_TIMEOUT_CNT	20
 #define SDHCI_INTEL_PWR_TIMEOUT_UDELAY	100
 
@@ -1341,6 +1352,14 @@ static int intel_mrfld_mmc_probe_slot(st
 					 MMC_CAP_1_8V_DDR;
 		break;
 	case INTEL_MRFLD_SD:
+		slot->cd_idx = 0;
+		slot->cd_override_level = true;
+		/*
+		 * There are two PCB designs of SD card slot with the opposite
+		 * card detection sense. Quirk this out by ignoring GPIO state
+		 * completely in the custom ->get_cd() callback.
+		 */
+		slot->host->mmc_host_ops.get_cd = mrfld_get_cd;
 		slot->host->quirks2 |= SDHCI_QUIRK2_NO_1_8_V;
 		break;
 	case INTEL_MRFLD_SDIO:


