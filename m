Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD9A2619F9
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731353AbgIHS2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:28:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731412AbgIHQKZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:10:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EDD424750;
        Tue,  8 Sep 2020 15:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579680;
        bh=MQc8Wj/iSwvEc0xqKu84iF1sHwPVVtPbYUR17fiYn58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0LjcfkdAkIKqepeALdo4bHEIyEWx/fO9hXTNYyL8dNIapJY9U7MWNVWk1v3VwRSDP
         z14NnsqAUiG+zikoh47OFBg02yS0GaI5zXwyKDUvW1Uh0Q+Q6W97QBOheZl1fw4gM6
         xNflxrQtymWTliopgaZRBC8x0/8KYpbuNpLFas+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.8 148/186] mmc: sdhci-pci: Fix SDHCI_RESET_ALL for CQHCI for Intel GLK-based controllers
Date:   Tue,  8 Sep 2020 17:24:50 +0200
Message-Id: <20200908152248.836466906@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit df57d73276b863af1debc48546b0e59e44998a55 upstream.

For Intel controllers, SDHCI_RESET_ALL resets also CQHCI registers.
Normally, SDHCI_RESET_ALL is not used while CQHCI is enabled, but that can
happen on the error path. e.g. if mmc_cqe_recovery() fails, mmc_blk_reset()
is called which, for a eMMC that does not support HW Reset, will cycle the
bus power and the driver will perform SDHCI_RESET_ALL.

So whenever performing SDHCI_RESET_ALL ensure CQHCI is deactivated.
That will force the driver to reinitialize CQHCI when it is next used.

A similar change was done already for sdhci-msm, and other drivers using
CQHCI might benefit from a similar change, if they also have CQHCI reset
by SDHCI_RESET_ALL.

Fixes: 8ee82bda230fc9 ("mmc: sdhci-pci: Add CQHCI support for Intel GLK")
Cc: stable@vger.kernel.org # 5.4.x: 0ffa6cfbd949: mmc: cqhci: Add cqhci_deactivate()
Cc: stable@vger.kernel.org # 5.4+
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20200819121848.16967-1-adrian.hunter@intel.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-pci-core.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -232,6 +232,14 @@ static void sdhci_pci_dumpregs(struct mm
 	sdhci_dumpregs(mmc_priv(mmc));
 }
 
+static void sdhci_cqhci_reset(struct sdhci_host *host, u8 mask)
+{
+	if ((host->mmc->caps2 & MMC_CAP2_CQE) && (mask & SDHCI_RESET_ALL) &&
+	    host->mmc->cqe_private)
+		cqhci_deactivate(host->mmc);
+	sdhci_reset(host, mask);
+}
+
 /*****************************************************************************\
  *                                                                           *
  * Hardware specific quirk handling                                          *
@@ -718,7 +726,7 @@ static const struct sdhci_ops sdhci_inte
 	.set_power		= sdhci_intel_set_power,
 	.enable_dma		= sdhci_pci_enable_dma,
 	.set_bus_width		= sdhci_set_bus_width,
-	.reset			= sdhci_reset,
+	.reset			= sdhci_cqhci_reset,
 	.set_uhs_signaling	= sdhci_set_uhs_signaling,
 	.hw_reset		= sdhci_pci_hw_reset,
 	.irq			= sdhci_cqhci_irq,


