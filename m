Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E45FB2364D
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389093AbfETM1c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:27:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389496AbfETM1b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:27:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7004220675;
        Mon, 20 May 2019 12:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355249;
        bh=oylC+PnrQAI7xZixoEnQt8HZ1NVPrVmRDNirD/k4gVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rCdU2jgttGkSt01YmouESo9yLT7tgCgCNdhAnM9r/5uwgtJVYu8ybDlsWeiHzvDef
         syWQTDcoF+VhVv/yeN/FnRzhr/6y3x5jZQTqVwcwC8lhKNaLiWZOFSJcD9lx23m2BH
         D83g0ohrmK4qJx4WFLvdqTsIqrOuD9OBlF4ajZ/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.0 046/123] mmc: sdhci-pci: Fix BYT OCP setting
Date:   Mon, 20 May 2019 14:13:46 +0200
Message-Id: <20190520115247.798779686@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 0a49a619e7e1aeb3f5f5511ca59314423c83dae2 upstream.

Some time ago, a fix was done for the sdhci-acpi driver, refer
commit 6e1c7d6103fe ("mmc: sdhci-acpi: Reduce Baytrail eMMC/SD/SDIO
hangs"). The same issue was not expected to affect the sdhci-pci driver,
but there have been reports to the contrary, so make the same hardware
setting change.

This patch applies to v5.0+ but before that backports will be required.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/Kconfig          |    1 
 drivers/mmc/host/sdhci-pci-core.c |   96 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 97 insertions(+)

--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -92,6 +92,7 @@ config MMC_SDHCI_PCI
 	tristate "SDHCI support on PCI bus"
 	depends on MMC_SDHCI && PCI
 	select MMC_CQHCI
+	select IOSF_MBI if X86
 	help
 	  This selects the PCI Secure Digital Host Controller Interface.
 	  Most controllers found today are PCI devices.
--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -31,6 +31,10 @@
 #include <linux/mmc/sdhci-pci-data.h>
 #include <linux/acpi.h>
 
+#ifdef CONFIG_X86
+#include <asm/iosf_mbi.h>
+#endif
+
 #include "cqhci.h"
 
 #include "sdhci.h"
@@ -451,6 +455,50 @@ static const struct sdhci_pci_fixes sdhc
 	.probe_slot	= pch_hc_probe_slot,
 };
 
+#ifdef CONFIG_X86
+
+#define BYT_IOSF_SCCEP			0x63
+#define BYT_IOSF_OCP_NETCTRL0		0x1078
+#define BYT_IOSF_OCP_TIMEOUT_BASE	GENMASK(10, 8)
+
+static void byt_ocp_setting(struct pci_dev *pdev)
+{
+	u32 val = 0;
+
+	if (pdev->device != PCI_DEVICE_ID_INTEL_BYT_EMMC &&
+	    pdev->device != PCI_DEVICE_ID_INTEL_BYT_SDIO &&
+	    pdev->device != PCI_DEVICE_ID_INTEL_BYT_SD &&
+	    pdev->device != PCI_DEVICE_ID_INTEL_BYT_EMMC2)
+		return;
+
+	if (iosf_mbi_read(BYT_IOSF_SCCEP, MBI_CR_READ, BYT_IOSF_OCP_NETCTRL0,
+			  &val)) {
+		dev_err(&pdev->dev, "%s read error\n", __func__);
+		return;
+	}
+
+	if (!(val & BYT_IOSF_OCP_TIMEOUT_BASE))
+		return;
+
+	val &= ~BYT_IOSF_OCP_TIMEOUT_BASE;
+
+	if (iosf_mbi_write(BYT_IOSF_SCCEP, MBI_CR_WRITE, BYT_IOSF_OCP_NETCTRL0,
+			   val)) {
+		dev_err(&pdev->dev, "%s write error\n", __func__);
+		return;
+	}
+
+	dev_dbg(&pdev->dev, "%s completed\n", __func__);
+}
+
+#else
+
+static inline void byt_ocp_setting(struct pci_dev *pdev)
+{
+}
+
+#endif
+
 enum {
 	INTEL_DSM_FNS		=  0,
 	INTEL_DSM_V18_SWITCH	=  3,
@@ -715,6 +763,8 @@ static void byt_probe_slot(struct sdhci_
 
 	byt_read_dsm(slot);
 
+	byt_ocp_setting(slot->chip->pdev);
+
 	ops->execute_tuning = intel_execute_tuning;
 	ops->start_signal_voltage_switch = intel_start_signal_voltage_switch;
 
@@ -938,7 +988,35 @@ static int byt_sd_probe_slot(struct sdhc
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
+
+static int byt_resume(struct sdhci_pci_chip *chip)
+{
+	byt_ocp_setting(chip->pdev);
+
+	return sdhci_pci_resume_host(chip);
+}
+
+#endif
+
+#ifdef CONFIG_PM
+
+static int byt_runtime_resume(struct sdhci_pci_chip *chip)
+{
+	byt_ocp_setting(chip->pdev);
+
+	return sdhci_pci_runtime_resume_host(chip);
+}
+
+#endif
+
 static const struct sdhci_pci_fixes sdhci_intel_byt_emmc = {
+#ifdef CONFIG_PM_SLEEP
+	.resume		= byt_resume,
+#endif
+#ifdef CONFIG_PM
+	.runtime_resume	= byt_runtime_resume,
+#endif
 	.allow_runtime_pm = true,
 	.probe_slot	= byt_emmc_probe_slot,
 	.quirks		= SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC |
@@ -972,6 +1050,12 @@ static const struct sdhci_pci_fixes sdhc
 };
 
 static const struct sdhci_pci_fixes sdhci_ni_byt_sdio = {
+#ifdef CONFIG_PM_SLEEP
+	.resume		= byt_resume,
+#endif
+#ifdef CONFIG_PM
+	.runtime_resume	= byt_runtime_resume,
+#endif
 	.quirks		= SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC |
 			  SDHCI_QUIRK_NO_LED,
 	.quirks2	= SDHCI_QUIRK2_HOST_OFF_CARD_ON |
@@ -983,6 +1067,12 @@ static const struct sdhci_pci_fixes sdhc
 };
 
 static const struct sdhci_pci_fixes sdhci_intel_byt_sdio = {
+#ifdef CONFIG_PM_SLEEP
+	.resume		= byt_resume,
+#endif
+#ifdef CONFIG_PM
+	.runtime_resume	= byt_runtime_resume,
+#endif
 	.quirks		= SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC |
 			  SDHCI_QUIRK_NO_LED,
 	.quirks2	= SDHCI_QUIRK2_HOST_OFF_CARD_ON |
@@ -994,6 +1084,12 @@ static const struct sdhci_pci_fixes sdhc
 };
 
 static const struct sdhci_pci_fixes sdhci_intel_byt_sd = {
+#ifdef CONFIG_PM_SLEEP
+	.resume		= byt_resume,
+#endif
+#ifdef CONFIG_PM
+	.runtime_resume	= byt_runtime_resume,
+#endif
 	.quirks		= SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC |
 			  SDHCI_QUIRK_NO_LED,
 	.quirks2	= SDHCI_QUIRK2_CARD_ON_NEEDS_BUS_ON |


