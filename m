Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A002C0767
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732499AbgKWMkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:40:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:53436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732491AbgKWMkb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:40:31 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B6182065E;
        Mon, 23 Nov 2020 12:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135230;
        bh=0xFYtswHs996qT16yliztaODTaRCOTVzG2AspEumhos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WWDzOkLL2hwKwR/K80jZVSEupVLY2Tqa8HYs9VDwTs1MbXUtwZ4lNXMCXZtrN8ZP2
         /AK2Zstlonw0tfYAkNAy7EcJrrlerQPVl9Mu45Lo2w80KI2jXw/7N5UfVD8CTGvaHu
         J8fO2rXMJ37EY+IuuMMBUe5X4KX9RfxhADeRvfo4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 151/158] mmc: sdhci-pci: Prefer SDR25 timing for High Speed mode for BYT-based Intel controllers
Date:   Mon, 23 Nov 2020 13:22:59 +0100
Message-Id: <20201123121827.216458634@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 60d53566100abde4acc5504b524bc97f89015690 upstream.

A UHS setting of SDR25 can give better results for High Speed mode.
This is because there is no setting corresponding to high speed.  Currently
SDHCI sets no value, which means zero which is also the setting for SDR12.
There was an attempt to change this in sdhci.c but it caused problems for
some drivers, so it was reverted and the change was made to sdhci-brcmstb
in commit 2fefc7c5f7d16e ("mmc: sdhci-brcmstb: Fix incorrect switch to HS
mode").  Several other drivers also do this.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org # v5.4+
Link: https://lore.kernel.org/r/20201112133656.20317-1-adrian.hunter@intel.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-pci-core.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -669,6 +669,15 @@ static void sdhci_intel_set_power(struct
 	}
 }
 
+static void sdhci_intel_set_uhs_signaling(struct sdhci_host *host,
+					  unsigned int timing)
+{
+	/* Set UHS timing to SDR25 for High Speed mode */
+	if (timing == MMC_TIMING_MMC_HS || timing == MMC_TIMING_SD_HS)
+		timing = MMC_TIMING_UHS_SDR25;
+	sdhci_set_uhs_signaling(host, timing);
+}
+
 #define INTEL_HS400_ES_REG 0x78
 #define INTEL_HS400_ES_BIT BIT(0)
 
@@ -725,7 +734,7 @@ static const struct sdhci_ops sdhci_inte
 	.enable_dma		= sdhci_pci_enable_dma,
 	.set_bus_width		= sdhci_set_bus_width,
 	.reset			= sdhci_reset,
-	.set_uhs_signaling	= sdhci_set_uhs_signaling,
+	.set_uhs_signaling	= sdhci_intel_set_uhs_signaling,
 	.hw_reset		= sdhci_pci_hw_reset,
 };
 
@@ -735,7 +744,7 @@ static const struct sdhci_ops sdhci_inte
 	.enable_dma		= sdhci_pci_enable_dma,
 	.set_bus_width		= sdhci_set_bus_width,
 	.reset			= sdhci_cqhci_reset,
-	.set_uhs_signaling	= sdhci_set_uhs_signaling,
+	.set_uhs_signaling	= sdhci_intel_set_uhs_signaling,
 	.hw_reset		= sdhci_pci_hw_reset,
 	.irq			= sdhci_cqhci_irq,
 };


