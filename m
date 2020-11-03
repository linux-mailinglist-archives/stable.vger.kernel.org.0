Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C342A520D
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729971AbgKCUqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:46:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:35522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731176AbgKCUqT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:46:19 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0F21223EA;
        Tue,  3 Nov 2020 20:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436378;
        bh=pnPJofv3doOy05qO53vmNPc8J3I3WH/+dOxhct9afTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lcjthLCF83uJyjFJ/ThlcTTBif1vCC14qjahYCCFd9Y6j5TNDrYi2q35UP9yBrveG
         HJe0117K49rFp7behYZQwJCr/Tu6A8EgRTaTGuLY80jf07SlXgq9UquMfi+hr6MKBl
         520kUZq1JjeMnFviE6t67SIvowjXtjb0z4TkSPrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.9 186/391] mmc: sdhci: Add LTR support for some Intel BYT based controllers
Date:   Tue,  3 Nov 2020 21:33:57 +0100
Message-Id: <20201103203359.438089478@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 46f4a69ec8ed6ab9f6a6172afe50df792c8bc1b6 upstream.

Some Intel BYT based host controllers support the setting of latency
tolerance.  Accordingly, implement the PM QoS ->set_latency_tolerance()
callback.  The raw register values are also exposed via debugfs.

Intel EHL controllers require this support.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Fixes: cb3a7d4a0aec4e ("mmc: sdhci-pci: Add support for Intel EHL")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200818104508.7149-1-adrian.hunter@intel.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-pci-core.c |  154 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 154 insertions(+)

--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -24,6 +24,8 @@
 #include <linux/iopoll.h>
 #include <linux/gpio.h>
 #include <linux/pm_runtime.h>
+#include <linux/pm_qos.h>
+#include <linux/debugfs.h>
 #include <linux/mmc/slot-gpio.h>
 #include <linux/mmc/sdhci-pci-data.h>
 #include <linux/acpi.h>
@@ -516,6 +518,8 @@ struct intel_host {
 	bool	rpm_retune_ok;
 	u32	glk_rx_ctrl1;
 	u32	glk_tun_val;
+	u32	active_ltr;
+	u32	idle_ltr;
 };
 
 static const guid_t intel_dsm_guid =
@@ -760,6 +764,108 @@ static int intel_execute_tuning(struct m
 	return 0;
 }
 
+#define INTEL_ACTIVELTR		0x804
+#define INTEL_IDLELTR		0x808
+
+#define INTEL_LTR_REQ		BIT(15)
+#define INTEL_LTR_SCALE_MASK	GENMASK(11, 10)
+#define INTEL_LTR_SCALE_1US	(2 << 10)
+#define INTEL_LTR_SCALE_32US	(3 << 10)
+#define INTEL_LTR_VALUE_MASK	GENMASK(9, 0)
+
+static void intel_cache_ltr(struct sdhci_pci_slot *slot)
+{
+	struct intel_host *intel_host = sdhci_pci_priv(slot);
+	struct sdhci_host *host = slot->host;
+
+	intel_host->active_ltr = readl(host->ioaddr + INTEL_ACTIVELTR);
+	intel_host->idle_ltr = readl(host->ioaddr + INTEL_IDLELTR);
+}
+
+static void intel_ltr_set(struct device *dev, s32 val)
+{
+	struct sdhci_pci_chip *chip = dev_get_drvdata(dev);
+	struct sdhci_pci_slot *slot = chip->slots[0];
+	struct intel_host *intel_host = sdhci_pci_priv(slot);
+	struct sdhci_host *host = slot->host;
+	u32 ltr;
+
+	pm_runtime_get_sync(dev);
+
+	/*
+	 * Program latency tolerance (LTR) accordingly what has been asked
+	 * by the PM QoS layer or disable it in case we were passed
+	 * negative value or PM_QOS_LATENCY_ANY.
+	 */
+	ltr = readl(host->ioaddr + INTEL_ACTIVELTR);
+
+	if (val == PM_QOS_LATENCY_ANY || val < 0) {
+		ltr &= ~INTEL_LTR_REQ;
+	} else {
+		ltr |= INTEL_LTR_REQ;
+		ltr &= ~INTEL_LTR_SCALE_MASK;
+		ltr &= ~INTEL_LTR_VALUE_MASK;
+
+		if (val > INTEL_LTR_VALUE_MASK) {
+			val >>= 5;
+			if (val > INTEL_LTR_VALUE_MASK)
+				val = INTEL_LTR_VALUE_MASK;
+			ltr |= INTEL_LTR_SCALE_32US | val;
+		} else {
+			ltr |= INTEL_LTR_SCALE_1US | val;
+		}
+	}
+
+	if (ltr == intel_host->active_ltr)
+		goto out;
+
+	writel(ltr, host->ioaddr + INTEL_ACTIVELTR);
+	writel(ltr, host->ioaddr + INTEL_IDLELTR);
+
+	/* Cache the values into lpss structure */
+	intel_cache_ltr(slot);
+out:
+	pm_runtime_put_autosuspend(dev);
+}
+
+static bool intel_use_ltr(struct sdhci_pci_chip *chip)
+{
+	switch (chip->pdev->device) {
+	case PCI_DEVICE_ID_INTEL_BYT_EMMC:
+	case PCI_DEVICE_ID_INTEL_BYT_EMMC2:
+	case PCI_DEVICE_ID_INTEL_BYT_SDIO:
+	case PCI_DEVICE_ID_INTEL_BYT_SD:
+	case PCI_DEVICE_ID_INTEL_BSW_EMMC:
+	case PCI_DEVICE_ID_INTEL_BSW_SDIO:
+	case PCI_DEVICE_ID_INTEL_BSW_SD:
+		return false;
+	default:
+		return true;
+	}
+}
+
+static void intel_ltr_expose(struct sdhci_pci_chip *chip)
+{
+	struct device *dev = &chip->pdev->dev;
+
+	if (!intel_use_ltr(chip))
+		return;
+
+	dev->power.set_latency_tolerance = intel_ltr_set;
+	dev_pm_qos_expose_latency_tolerance(dev);
+}
+
+static void intel_ltr_hide(struct sdhci_pci_chip *chip)
+{
+	struct device *dev = &chip->pdev->dev;
+
+	if (!intel_use_ltr(chip))
+		return;
+
+	dev_pm_qos_hide_latency_tolerance(dev);
+	dev->power.set_latency_tolerance = NULL;
+}
+
 static void byt_probe_slot(struct sdhci_pci_slot *slot)
 {
 	struct mmc_host_ops *ops = &slot->host->mmc_host_ops;
@@ -774,6 +880,43 @@ static void byt_probe_slot(struct sdhci_
 	ops->start_signal_voltage_switch = intel_start_signal_voltage_switch;
 
 	device_property_read_u32(dev, "max-frequency", &mmc->f_max);
+
+	if (!mmc->slotno) {
+		slot->chip->slots[mmc->slotno] = slot;
+		intel_ltr_expose(slot->chip);
+	}
+}
+
+static void byt_add_debugfs(struct sdhci_pci_slot *slot)
+{
+	struct intel_host *intel_host = sdhci_pci_priv(slot);
+	struct mmc_host *mmc = slot->host->mmc;
+	struct dentry *dir = mmc->debugfs_root;
+
+	if (!intel_use_ltr(slot->chip))
+		return;
+
+	debugfs_create_x32("active_ltr", 0444, dir, &intel_host->active_ltr);
+	debugfs_create_x32("idle_ltr", 0444, dir, &intel_host->idle_ltr);
+
+	intel_cache_ltr(slot);
+}
+
+static int byt_add_host(struct sdhci_pci_slot *slot)
+{
+	int ret = sdhci_add_host(slot->host);
+
+	if (!ret)
+		byt_add_debugfs(slot);
+	return ret;
+}
+
+static void byt_remove_slot(struct sdhci_pci_slot *slot, int dead)
+{
+	struct mmc_host *mmc = slot->host->mmc;
+
+	if (!mmc->slotno)
+		intel_ltr_hide(slot->chip);
 }
 
 static int byt_emmc_probe_slot(struct sdhci_pci_slot *slot)
@@ -855,6 +998,8 @@ static int glk_emmc_add_host(struct sdhc
 	if (ret)
 		goto cleanup;
 
+	byt_add_debugfs(slot);
+
 	return 0;
 
 cleanup:
@@ -1032,6 +1177,8 @@ static const struct sdhci_pci_fixes sdhc
 #endif
 	.allow_runtime_pm = true,
 	.probe_slot	= byt_emmc_probe_slot,
+	.add_host	= byt_add_host,
+	.remove_slot	= byt_remove_slot,
 	.quirks		= SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC |
 			  SDHCI_QUIRK_NO_LED,
 	.quirks2	= SDHCI_QUIRK2_PRESET_VALUE_BROKEN |
@@ -1045,6 +1192,7 @@ static const struct sdhci_pci_fixes sdhc
 	.allow_runtime_pm	= true,
 	.probe_slot		= glk_emmc_probe_slot,
 	.add_host		= glk_emmc_add_host,
+	.remove_slot		= byt_remove_slot,
 #ifdef CONFIG_PM_SLEEP
 	.suspend		= sdhci_cqhci_suspend,
 	.resume			= sdhci_cqhci_resume,
@@ -1075,6 +1223,8 @@ static const struct sdhci_pci_fixes sdhc
 			  SDHCI_QUIRK2_PRESET_VALUE_BROKEN,
 	.allow_runtime_pm = true,
 	.probe_slot	= ni_byt_sdio_probe_slot,
+	.add_host	= byt_add_host,
+	.remove_slot	= byt_remove_slot,
 	.ops		= &sdhci_intel_byt_ops,
 	.priv_size	= sizeof(struct intel_host),
 };
@@ -1092,6 +1242,8 @@ static const struct sdhci_pci_fixes sdhc
 			SDHCI_QUIRK2_PRESET_VALUE_BROKEN,
 	.allow_runtime_pm = true,
 	.probe_slot	= byt_sdio_probe_slot,
+	.add_host	= byt_add_host,
+	.remove_slot	= byt_remove_slot,
 	.ops		= &sdhci_intel_byt_ops,
 	.priv_size	= sizeof(struct intel_host),
 };
@@ -1111,6 +1263,8 @@ static const struct sdhci_pci_fixes sdhc
 	.allow_runtime_pm = true,
 	.own_cd_for_runtime_pm = true,
 	.probe_slot	= byt_sd_probe_slot,
+	.add_host	= byt_add_host,
+	.remove_slot	= byt_remove_slot,
 	.ops		= &sdhci_intel_byt_ops,
 	.priv_size	= sizeof(struct intel_host),
 };


