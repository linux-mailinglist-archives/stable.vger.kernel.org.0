Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2DD312C8EF
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387554AbfL2R6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:58:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:49638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387547AbfL2R6c (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:58:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FC9E208C4;
        Sun, 29 Dec 2019 17:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642311;
        bh=HEAfP2DpH3vTFkVmZhQgNVLLR4hvdMxYtbL2NEughgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HxMMFwBViJTUB59bzAPMmwrVAwYXASm6GuPLj/ZdTHrkYSXSwccXIi4AJdEbpxo3w
         iFIh6YzWiql0BOG9HqSnqBtajp9tshBM70MQgBT5ivw5fK+JvUtu7cmdJ63BBXEyvm
         E9R1OWIjcpGniASp5C4wCmYhryseevzOv197HXfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 431/434] mmc: sdhci: Workaround broken command queuing on Intel GLK
Date:   Sun, 29 Dec 2019 18:28:04 +0100
Message-Id: <20191229172731.998484839@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit bedf9fc01ff1f40cfd1a79ccacedd9f3cd8e652a upstream.

Command queuing has been reported broken on some Lenovo systems based on
Intel GLK. This is likely a BIOS issue, so disable command queuing for
Intel GLK if the BIOS vendor string is "LENOVO".

Fixes: 8ee82bda230f ("mmc: sdhci-pci: Add CQHCI support for Intel GLK")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20191217095349.14592-1-adrian.hunter@intel.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-pci-core.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -26,6 +26,7 @@
 #include <linux/mmc/slot-gpio.h>
 #include <linux/mmc/sdhci-pci-data.h>
 #include <linux/acpi.h>
+#include <linux/dmi.h>
 
 #ifdef CONFIG_X86
 #include <asm/iosf_mbi.h>
@@ -782,11 +783,18 @@ static int byt_emmc_probe_slot(struct sd
 	return 0;
 }
 
+static bool glk_broken_cqhci(struct sdhci_pci_slot *slot)
+{
+	return slot->chip->pdev->device == PCI_DEVICE_ID_INTEL_GLK_EMMC &&
+	       dmi_match(DMI_BIOS_VENDOR, "LENOVO");
+}
+
 static int glk_emmc_probe_slot(struct sdhci_pci_slot *slot)
 {
 	int ret = byt_emmc_probe_slot(slot);
 
-	slot->host->mmc->caps2 |= MMC_CAP2_CQE;
+	if (!glk_broken_cqhci(slot))
+		slot->host->mmc->caps2 |= MMC_CAP2_CQE;
 
 	if (slot->chip->pdev->device != PCI_DEVICE_ID_INTEL_GLK_EMMC) {
 		slot->host->mmc->caps2 |= MMC_CAP2_HS400_ES,


