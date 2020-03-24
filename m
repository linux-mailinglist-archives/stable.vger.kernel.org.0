Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D04C190FFC
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729661AbgCXNY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:24:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729153AbgCXNY1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:24:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 252C5208C3;
        Tue, 24 Mar 2020 13:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056266;
        bh=2Ml+X2qizleTr5PxexEyNNhI+m65sFtwalBiyIMpn2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0BGmhS79Z4KspK7P0CqXCv32uNPtiX3Ono0Dz9pQYjNcdGrJa4+qKemnqW/l0fy1L
         WAD170tlLglrNWT0jOeLqk45ZRTNojWLUyRzg1I88eJaTIkDxlStabQnh2sklwbbBl
         L/4DfKUnriir2jrl6HDB6gS0CpQrCdEvgiew1f4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        russianneuromancer <russianneuromancer@ya.ru>,
        Hans de Goede <hdegoede@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.5 074/119] mmc: sdhci-acpi: Switch signal voltage back to 3.3V on suspend on external microSD on Lenovo Miix 320
Date:   Tue, 24 Mar 2020 14:10:59 +0100
Message-Id: <20200324130815.687400232@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

commit 84d49b3d08a1d33690cc159036f381c31c27c17b upstream.

Based on a sample of 7 DSDTs from Cherry Trail devices using an AXP288
PMIC depending on the design one of 2 possible LDOs on the PMIC is used
for the MMC signalling voltage, either DLDO3 or GPIO1LDO (GPIO1 pin in
low noise LDO mode).

The Lenovo Miix 320-10ICR uses GPIO1LDO in the SHC1 ACPI device's DSM
methods to set 3.3 or 1.8 signalling voltage and this appears to work
as advertised, so presumably the device is actually using GPIO1LDO for
the external microSD signalling voltage.

But this device has a bug in the _PS0 method of the SHC1 ACPI device,
the DSM remembers the last set signalling voltage and the _PS0 restores
this after a (runtime) suspend-resume cycle, but it "restores" the voltage
on DLDO3 instead of setting it on GPIO1LDO as the DSM method does. DLDO3
is used for the LCD and setting it to 1.8V causes the LCD to go black.

This commit works around this issue by calling the Intel DSM to reset the
signal voltage to 3.3V after the host has been runtime suspended.
This will make the _PS0 method reprogram the DLDO3 voltage to 3.3V, which
leaves it at its original setting fixing the LCD going black.

This commit adds and uses a DMI quirk mechanism to only trigger this
workaround on the Lenovo Miix 320 while leaving the behavior of the
driver unchanged on other devices.

BugLink: https://bugs.freedesktop.org/show_bug.cgi?id=111294
BugLink: https://gitlab.freedesktop.org/drm/intel/issues/355
Reported-by: russianneuromancer <russianneuromancer@ya.ru>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200316184753.393458-1-hdegoede@redhat.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-acpi.c |   68 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 66 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/sdhci-acpi.c
+++ b/drivers/mmc/host/sdhci-acpi.c
@@ -23,6 +23,7 @@
 #include <linux/pm.h>
 #include <linux/pm_runtime.h>
 #include <linux/delay.h>
+#include <linux/dmi.h>
 
 #include <linux/mmc/host.h>
 #include <linux/mmc/pm.h>
@@ -72,9 +73,15 @@ struct sdhci_acpi_host {
 	const struct sdhci_acpi_slot	*slot;
 	struct platform_device		*pdev;
 	bool				use_runtime_pm;
+	bool				is_intel;
+	bool				reset_signal_volt_on_suspend;
 	unsigned long			private[0] ____cacheline_aligned;
 };
 
+enum {
+	DMI_QUIRK_RESET_SD_SIGNAL_VOLT_ON_SUSP			= BIT(0),
+};
+
 static inline void *sdhci_acpi_priv(struct sdhci_acpi_host *c)
 {
 	return (void *)c->private;
@@ -391,6 +398,8 @@ static int intel_probe_slot(struct platf
 	host->mmc_host_ops.start_signal_voltage_switch =
 					intel_start_signal_voltage_switch;
 
+	c->is_intel = true;
+
 	return 0;
 }
 
@@ -647,6 +656,24 @@ static const struct acpi_device_id sdhci
 };
 MODULE_DEVICE_TABLE(acpi, sdhci_acpi_ids);
 
+static const struct dmi_system_id sdhci_acpi_quirks[] = {
+	{
+		/*
+		 * The Lenovo Miix 320-10ICR has a bug in the _PS0 method of
+		 * the SHC1 ACPI device, this bug causes it to reprogram the
+		 * wrong LDO (DLDO3) to 1.8V if 1.8V modes are used and the
+		 * card is (runtime) suspended + resumed. DLDO3 is used for
+		 * the LCD and setting it to 1.8V causes the LCD to go black.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo MIIX 320-10ICR"),
+		},
+		.driver_data = (void *)DMI_QUIRK_RESET_SD_SIGNAL_VOLT_ON_SUSP,
+	},
+	{} /* Terminating entry */
+};
+
 static const struct sdhci_acpi_slot *sdhci_acpi_get_slot(struct acpi_device *adev)
 {
 	const struct sdhci_acpi_uid_slot *u;
@@ -663,17 +690,23 @@ static int sdhci_acpi_probe(struct platf
 	struct device *dev = &pdev->dev;
 	const struct sdhci_acpi_slot *slot;
 	struct acpi_device *device, *child;
+	const struct dmi_system_id *id;
 	struct sdhci_acpi_host *c;
 	struct sdhci_host *host;
 	struct resource *iomem;
 	resource_size_t len;
 	size_t priv_size;
+	int quirks = 0;
 	int err;
 
 	device = ACPI_COMPANION(dev);
 	if (!device)
 		return -ENODEV;
 
+	id = dmi_first_match(sdhci_acpi_quirks);
+	if (id)
+		quirks = (long)id->driver_data;
+
 	slot = sdhci_acpi_get_slot(device);
 
 	/* Power on the SDHCI controller and its children */
@@ -759,6 +792,9 @@ static int sdhci_acpi_probe(struct platf
 			dev_warn(dev, "failed to setup card detect gpio\n");
 			c->use_runtime_pm = false;
 		}
+
+		if (quirks & DMI_QUIRK_RESET_SD_SIGNAL_VOLT_ON_SUSP)
+			c->reset_signal_volt_on_suspend = true;
 	}
 
 	err = sdhci_setup_host(host);
@@ -823,17 +859,39 @@ static int sdhci_acpi_remove(struct plat
 	return 0;
 }
 
+static void __maybe_unused sdhci_acpi_reset_signal_voltage_if_needed(
+	struct device *dev)
+{
+	struct sdhci_acpi_host *c = dev_get_drvdata(dev);
+	struct sdhci_host *host = c->host;
+
+	if (c->is_intel && c->reset_signal_volt_on_suspend &&
+	    host->mmc->ios.signal_voltage != MMC_SIGNAL_VOLTAGE_330) {
+		struct intel_host *intel_host = sdhci_acpi_priv(c);
+		unsigned int fn = INTEL_DSM_V33_SWITCH;
+		u32 result = 0;
+
+		intel_dsm(intel_host, dev, fn, &result);
+	}
+}
+
 #ifdef CONFIG_PM_SLEEP
 
 static int sdhci_acpi_suspend(struct device *dev)
 {
 	struct sdhci_acpi_host *c = dev_get_drvdata(dev);
 	struct sdhci_host *host = c->host;
+	int ret;
 
 	if (host->tuning_mode != SDHCI_TUNING_MODE_3)
 		mmc_retune_needed(host->mmc);
 
-	return sdhci_suspend_host(host);
+	ret = sdhci_suspend_host(host);
+	if (ret)
+		return ret;
+
+	sdhci_acpi_reset_signal_voltage_if_needed(dev);
+	return 0;
 }
 
 static int sdhci_acpi_resume(struct device *dev)
@@ -853,11 +911,17 @@ static int sdhci_acpi_runtime_suspend(st
 {
 	struct sdhci_acpi_host *c = dev_get_drvdata(dev);
 	struct sdhci_host *host = c->host;
+	int ret;
 
 	if (host->tuning_mode != SDHCI_TUNING_MODE_3)
 		mmc_retune_needed(host->mmc);
 
-	return sdhci_runtime_suspend_host(host);
+	ret = sdhci_runtime_suspend_host(host);
+	if (ret)
+		return ret;
+
+	sdhci_acpi_reset_signal_voltage_if_needed(dev);
+	return 0;
 }
 
 static int sdhci_acpi_runtime_resume(struct device *dev)


