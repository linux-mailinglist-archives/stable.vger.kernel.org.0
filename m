Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E5738A20A
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbhETJhk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:37:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:35510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232667AbhETJfk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:35:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30DA461400;
        Thu, 20 May 2021 09:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502975;
        bh=GtQQU2/YwRJB25fysrCZsRra6HEV0iHpir8zLswlSlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hTaXNum9A4thFAyxZeuPIToQp/3V8uqm0v5SlYMBAlIXFias48AG0mVWYUJpoCRRi
         P7+qtSIcpfQrjOVqGmK9eQ2aZz/0xi84GMaQ4oAakOQdtiFqm6akg4Qo8tOn13/GIG
         miAeFl433WiiViYB0tEnCyhSnX5XlzvB+e7VmpmY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 013/425] mmc: sdhci-pci: Fix initialization of some SD cards for Intel BYT-based controllers
Date:   Thu, 20 May 2021 11:16:22 +0200
Message-Id: <20210520092131.785347848@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
@@ -465,6 +465,7 @@ struct intel_host {
 	int	drv_strength;
 	bool	d3_retune;
 	bool	rpm_retune_ok;
+	bool	needs_pwr_off;
 	u32	glk_rx_ctrl1;
 	u32	glk_tun_val;
 };
@@ -590,9 +591,25 @@ out:
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
@@ -926,6 +943,14 @@ static int byt_sdio_probe_slot(struct sd
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
@@ -943,6 +968,8 @@ static int byt_sd_probe_slot(struct sdhc
 	    slot->chip->pdev->subsystem_device == PCI_SUBDEVICE_ID_NI_78E3)
 		slot->host->mmc->caps2 |= MMC_CAP2_AVOID_3_3V;
 
+	byt_needs_pwr_off(slot);
+
 	return 0;
 }
 


