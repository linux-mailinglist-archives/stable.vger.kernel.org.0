Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191AE1AC906
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392388AbgDPPRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:17:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:34548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898750AbgDPNsi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:48:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A70B621974;
        Thu, 16 Apr 2020 13:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044914;
        bh=wfXgQROazFBxrkbDeVJO+X/lLtDftS0z146jAskHZgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sz3birDbrk/vbUXhPw33ylEZQ+yDnpR3ErXloE2DrBvg9cXMZ6aAoVzmd9GEUaYiq
         TSjbVkbGyN/s8YK4Ancfcs7Pq98YmZ311ZDOdN37Qx7I47ThFDFt2s0RD8eNZkGNRW
         EcB/L7CNUVwW68KK/kvyHPBSpRxRCIEok1/bP0cE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangbo Lu <yangbo.lu@nxp.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 153/232] mmc: sdhci-of-esdhc: fix esdhc_reset() for different controller versions
Date:   Thu, 16 Apr 2020 15:24:07 +0200
Message-Id: <20200416131334.133946063@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangbo Lu <yangbo.lu@nxp.com>

commit 2aa3d826adb578b26629a79b775a552cfe3fedf7 upstream.

This patch is to fix operating in esdhc_reset() for different
controller versions, and to add bus-width restoring after data
reset for eSDHC (verdor version <= 2.2).

Also add annotation for understanding.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20200108040713.38888-1-yangbo.lu@nxp.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-of-esdhc.c |   43 ++++++++++++++++++++++++++++++++++----
 1 file changed, 39 insertions(+), 4 deletions(-)

--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -734,23 +734,58 @@ static void esdhc_reset(struct sdhci_hos
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


