Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9788A37836A
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbhEJKpw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:45:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232243AbhEJKmT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:42:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2809E6192E;
        Mon, 10 May 2021 10:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642739;
        bh=oQT3PPvqxykPVhMPF6b9p3ASdg0cEpgtCmbnV8N2ChM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uf2p+DesDlbBdzfsRzI13+6FwL4zZFkTZmD6UYd9wNJpFQ4zRg99JMkpPTB6REZ3W
         vwDrCRu3pPnWVlgpFmHE2vwwuKeEmQCMRXsL4fzaRvoNjjDRcJH4FlaZt3MW+k/6nZ
         L6Y/S784r7wOeWi2KhBH0PkLCyS0GQ/zfKJH0wTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 031/299] mmc: sdhci-pci: Fix initialization of some SD cards for Intel BYT-based controllers
Date:   Mon, 10 May 2021 12:17:08 +0200
Message-Id: <20210510102005.877537773@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 2970134b927834e9249659a70aac48e62dff804a upstream.

Bus power may control card power, but the full reset done by SDHCI at
initialization still may not reset the power, whereas a direct write to
SDHCI_POWER_CONTROL can. That might be needed to initialize correctly, if
the card was left powered on previously.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210331081752.23621-1-adrian.hunter@intel.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pci-core.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -516,6 +516,7 @@ struct intel_host {
 	int	drv_strength;
 	bool	d3_retune;
 	bool	rpm_retune_ok;
+	bool	needs_pwr_off;
 	u32	glk_rx_ctrl1;
 	u32	glk_tun_val;
 	u32	active_ltr;
@@ -643,9 +644,25 @@ out:
 static void sdhci_intel_set_power(struct sdhci_host *host, unsigned char mode,
 				  unsigned short vdd)
 {
+	struct sdhci_pci_slot *slot = sdhci_priv(host);
+	struct intel_host *intel_host = sdhci_pci_priv(slot);
 	int cntr;
 	u8 reg;
 
+	/*
+	 * Bus power may control card power, but a full reset still may not
+	 * reset the power, whereas a direct write to SDHCI_POWER_CONTROL can.
+	 * That might be needed to initialize correctly, if the card was left
+	 * powered on previously.
+	 */
+	if (intel_host->needs_pwr_off) {
+		intel_host->needs_pwr_off = false;
+		if (mode != MMC_POWER_OFF) {
+			sdhci_writeb(host, 0, SDHCI_POWER_CONTROL);
+			usleep_range(10000, 12500);
+		}
+	}
+
 	sdhci_set_power(host, mode, vdd);
 
 	if (mode == MMC_POWER_OFF)
@@ -1135,6 +1152,14 @@ static int byt_sdio_probe_slot(struct sd
 	return 0;
 }
 
+static void byt_needs_pwr_off(struct sdhci_pci_slot *slot)
+{
+	struct intel_host *intel_host = sdhci_pci_priv(slot);
+	u8 reg = sdhci_readb(slot->host, SDHCI_POWER_CONTROL);
+
+	intel_host->needs_pwr_off = reg  & SDHCI_POWER_ON;
+}
+
 static int byt_sd_probe_slot(struct sdhci_pci_slot *slot)
 {
 	byt_probe_slot(slot);
@@ -1152,6 +1177,8 @@ static int byt_sd_probe_slot(struct sdhc
 	    slot->chip->pdev->subsystem_device == PCI_SUBDEVICE_ID_NI_78E3)
 		slot->host->mmc->caps2 |= MMC_CAP2_AVOID_3_3V;
 
+	byt_needs_pwr_off(slot);
+
 	return 0;
 }
 


