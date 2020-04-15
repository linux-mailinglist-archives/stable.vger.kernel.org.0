Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723F41A91AF
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 05:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393057AbgDOD4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 23:56:00 -0400
Received: from inva021.nxp.com ([92.121.34.21]:46082 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733225AbgDODz7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Apr 2020 23:55:59 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 13CA9200725;
        Wed, 15 Apr 2020 05:55:57 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 4FA182005E0;
        Wed, 15 Apr 2020 05:55:54 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 3E4B240293;
        Wed, 15 Apr 2020 11:55:50 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     stable@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Daniel Walker <danielwa@cisco.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [v5.4] mmc: sdhci-of-esdhc: fix esdhc_reset() for different controller versions
Date:   Wed, 15 Apr 2020 11:51:46 +0800
Message-Id: <20200415035146.19086-2-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200415035146.19086-1-yangbo.lu@nxp.com>
References: <20200415035146.19086-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 2aa3d826adb578b26629a79b775a552cfe3fedf7 upstream.

This patch is to fix operating in esdhc_reset() for different
controller versions, and to add bus-width restoring after data
reset for eSDHC (verdor version <= 2.2).

Also add annotation for understanding.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20200108040713.38888-1-yangbo.lu@nxp.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/sdhci-of-esdhc.c | 43 +++++++++++++++++++++++++++++++++++----
 1 file changed, 39 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/sdhci-of-esdhc.c b/drivers/mmc/host/sdhci-of-esdhc.c
index fcfb50f..fd1251e 100644
--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -734,23 +734,58 @@ static void esdhc_reset(struct sdhci_host *host, u8 mask)
 {
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct sdhci_esdhc *esdhc = sdhci_pltfm_priv(pltfm_host);
-	u32 val;
+	u32 val, bus_width = 0;
 
+	/*
+	 * Add delay to make sure all the DMA transfers are finished
+	 * for quirk.
+	 */
 	if (esdhc->quirk_delay_before_data_reset &&
 	    (mask & SDHCI_RESET_DATA) &&
 	    (host->flags & SDHCI_REQ_USE_DMA))
 		mdelay(5);
 
+	/*
+	 * Save bus-width for eSDHC whose vendor version is 2.2
+	 * or lower for data reset.
+	 */
+	if ((mask & SDHCI_RESET_DATA) &&
+	    (esdhc->vendor_ver <= VENDOR_V_22)) {
+		val = sdhci_readl(host, ESDHC_PROCTL);
+		bus_width = val & ESDHC_CTRL_BUSWIDTH_MASK;
+	}
+
 	sdhci_reset(host, mask);
 
-	sdhci_writel(host, host->ier, SDHCI_INT_ENABLE);
-	sdhci_writel(host, host->ier, SDHCI_SIGNAL_ENABLE);
+	/*
+	 * Restore bus-width setting and interrupt registers for eSDHC
+	 * whose vendor version is 2.2 or lower for data reset.
+	 */
+	if ((mask & SDHCI_RESET_DATA) &&
+	    (esdhc->vendor_ver <= VENDOR_V_22)) {
+		val = sdhci_readl(host, ESDHC_PROCTL);
+		val &= ~ESDHC_CTRL_BUSWIDTH_MASK;
+		val |= bus_width;
+		sdhci_writel(host, val, ESDHC_PROCTL);
+
+		sdhci_writel(host, host->ier, SDHCI_INT_ENABLE);
+		sdhci_writel(host, host->ier, SDHCI_SIGNAL_ENABLE);
+	}
 
-	if (mask & SDHCI_RESET_ALL) {
+	/*
+	 * Some bits have to be cleaned manually for eSDHC whose spec
+	 * version is higher than 3.0 for all reset.
+	 */
+	if ((mask & SDHCI_RESET_ALL) &&
+	    (esdhc->spec_ver >= SDHCI_SPEC_300)) {
 		val = sdhci_readl(host, ESDHC_TBCTL);
 		val &= ~ESDHC_TB_EN;
 		sdhci_writel(host, val, ESDHC_TBCTL);
 
+		/*
+		 * Initialize eSDHC_DLLCFG1[DLL_PD_PULSE_STRETCH_SEL] to
+		 * 0 for quirk.
+		 */
 		if (esdhc->quirk_unreliable_pulse_detection) {
 			val = sdhci_readl(host, ESDHC_DLLCFG1);
 			val &= ~ESDHC_DLL_PD_PULSE_STRETCH_SEL;
-- 
2.7.4

