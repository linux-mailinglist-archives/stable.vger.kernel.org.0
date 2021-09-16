Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49AEA40E0D0
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240506AbhIPQYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:24:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241321AbhIPQWi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:22:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2FED61411;
        Thu, 16 Sep 2021 16:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808929;
        bh=Jmw/wUq4Cw8gVxsFJPO7nTs4LAwlEVqSdbTxeDI4KAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NLQ+ETAa/+DG38lNH4J/TuzMsot98U6VtatKmU0urDePlGPcCL3LLsmsgkAVCQhOl
         bEv3NxWX28X59F210389CNITVcaUK20KXlUtlSCjzzNwyGGsZtEPKuh5McOdHA4LSa
         Ip+RK39Le2slQo1DDyZNTNJNnOwFQVFDSSw2bbYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manish Narani <manish.narani@xilinx.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 247/306] mmc: sdhci-of-arasan: Modified SD default speed to 19MHz for ZynqMP
Date:   Thu, 16 Sep 2021 17:59:52 +0200
Message-Id: <20210916155802.487704609@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manish Narani <manish.narani@xilinx.com>

[ Upstream commit c0b4e411a9b09748466ee06d2ae6772effa64dfb ]

SD standard speed timing was met only at 19MHz and not 25 MHz, that's
why changing driver to 19MHz. The reason for this is when a level shifter
is used on the board, timing was met for standard speed only at 19MHz.
Since this level shifter is commonly required for high speed modes,
the driver is modified to use standard speed of 19Mhz.

Signed-off-by: Manish Narani <manish.narani@xilinx.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/1623753837-21035-2-git-send-email-manish.narani@xilinx.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-of-arasan.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/mmc/host/sdhci-of-arasan.c b/drivers/mmc/host/sdhci-of-arasan.c
index 3b8d456e857d..0c5479a06e9e 100644
--- a/drivers/mmc/host/sdhci-of-arasan.c
+++ b/drivers/mmc/host/sdhci-of-arasan.c
@@ -159,6 +159,12 @@ struct sdhci_arasan_data {
 /* Controller immediately reports SDHCI_CLOCK_INT_STABLE after enabling the
  * internal clock even when the clock isn't stable */
 #define SDHCI_ARASAN_QUIRK_CLOCK_UNSTABLE BIT(1)
+/*
+ * Some of the Arasan variations might not have timing requirements
+ * met at 25MHz for Default Speed mode, those controllers work at
+ * 19MHz instead
+ */
+#define SDHCI_ARASAN_QUIRK_CLOCK_25_BROKEN BIT(2)
 };
 
 struct sdhci_arasan_of_data {
@@ -290,6 +296,16 @@ static void sdhci_arasan_set_clock(struct sdhci_host *host, unsigned int clock)
 		sdhci_arasan->is_phy_on = false;
 	}
 
+	if (sdhci_arasan->quirks & SDHCI_ARASAN_QUIRK_CLOCK_25_BROKEN) {
+		/*
+		 * Some of the Arasan variations might not have timing
+		 * requirements met at 25MHz for Default Speed mode,
+		 * those controllers work at 19MHz instead.
+		 */
+		if (clock == DEFAULT_SPEED_MAX_DTR)
+			clock = (DEFAULT_SPEED_MAX_DTR * 19) / 25;
+	}
+
 	/* Set the Input and Output Clock Phase Delays */
 	if (clk_data->set_clk_delays)
 		clk_data->set_clk_delays(host);
@@ -1598,6 +1614,8 @@ static int sdhci_arasan_probe(struct platform_device *pdev)
 	if (of_device_is_compatible(np, "xlnx,zynqmp-8.9a")) {
 		host->mmc_host_ops.execute_tuning =
 			arasan_zynqmp_execute_tuning;
+
+		sdhci_arasan->quirks |= SDHCI_ARASAN_QUIRK_CLOCK_25_BROKEN;
 	}
 
 	arasan_dt_parse_clk_phases(&pdev->dev, &sdhci_arasan->clk_data);
-- 
2.30.2



