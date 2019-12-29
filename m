Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5393F12C588
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729793AbfL2Rgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:36:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:42016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729212AbfL2Rge (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:36:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEB10207FD;
        Sun, 29 Dec 2019 17:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640994;
        bh=sNEGOUsjQGQ7cznUG+BSOS9n51CubnbSP2N4pT3Ygno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hIzx3DJ4L5yaE9n0GuRI1d21Nf2fcEiTbyw4ytbJobqhIIMrkPxOUL+AhQC4uBJMu
         x3fDo9yYdMUMvN5hvVVcmcPu1Iy3bTdDpZQGnAyCZJj3zBGETZ2qvoVX4ZeKu0hVOV
         STaF68A1OvK3khEfqDLBcc6aQ9GbqePfFhAgGCdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 217/219] mmc: sdhci: Workaround broken command queuing on Intel GLK
Date:   Sun, 29 Dec 2019 18:20:19 +0100
Message-Id: <20191229162543.202210496@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
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
@@ -30,6 +30,7 @@
 #include <linux/mmc/slot-gpio.h>
 #include <linux/mmc/sdhci-pci-data.h>
 #include <linux/acpi.h>
+#include <linux/dmi.h>
 
 #include "cqhci.h"
 
@@ -732,11 +733,18 @@ static int byt_emmc_probe_slot(struct sd
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


