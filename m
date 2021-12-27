Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470E047FFB5
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238961AbhL0Pkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:40:52 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38678 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238176AbhL0Pii (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:38:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB3DF6104C;
        Mon, 27 Dec 2021 15:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC64CC36AEA;
        Mon, 27 Dec 2021 15:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619517;
        bh=wHvBjqF3xDMimUo+nyPPw/s0p538xNGkCv+t+wQLQdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UqB6L84KJGM/ZaPyQ4IEyScwvZLbCreNyafCKEjakFB9XMvzVB9jAzofCDEzLQ6GZ
         Ft3eDQJ9L6hsQMCoy2yW1ZkV/f+zip86L8gqK6QNm7x8OurHLqzgLJMfYjYDcfK2XK
         sZfz8VkjEx0kCcg5dxEVzZNHsvNcY82kz05fGIlQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prathamesh Shete <pshete@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 52/76] mmc: sdhci-tegra: Fix switch to HS400ES mode
Date:   Mon, 27 Dec 2021 16:31:07 +0100
Message-Id: <20211227151326.495778974@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prathamesh Shete <pshete@nvidia.com>

commit 4fc7261dbab139d3c64c3b618262504e16cfe7ee upstream.

When CMD13 is sent after switching to HS400ES mode, the bus
is operating at either MMC_HIGH_26_MAX_DTR or MMC_HIGH_52_MAX_DTR.
To meet Tegra SDHCI requirement at HS400ES mode, force SDHCI
interface clock to MMC_HS200_MAX_DTR (200 MHz) so that host
controller CAR clock and the interface clock are rate matched.

Signed-off-by: Prathamesh Shete <pshete@nvidia.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Fixes: dfc9700cef77 ("mmc: tegra: Implement HS400 enhanced strobe")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20211214113653.4631-1-pshete@nvidia.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-tegra.c |   43 ++++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -354,23 +354,6 @@ static void tegra_sdhci_set_tap(struct s
 	}
 }
 
-static void tegra_sdhci_hs400_enhanced_strobe(struct mmc_host *mmc,
-					      struct mmc_ios *ios)
-{
-	struct sdhci_host *host = mmc_priv(mmc);
-	u32 val;
-
-	val = sdhci_readl(host, SDHCI_TEGRA_VENDOR_SYS_SW_CTRL);
-
-	if (ios->enhanced_strobe)
-		val |= SDHCI_TEGRA_SYS_SW_CTRL_ENHANCED_STROBE;
-	else
-		val &= ~SDHCI_TEGRA_SYS_SW_CTRL_ENHANCED_STROBE;
-
-	sdhci_writel(host, val, SDHCI_TEGRA_VENDOR_SYS_SW_CTRL);
-
-}
-
 static void tegra_sdhci_reset(struct sdhci_host *host, u8 mask)
 {
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
@@ -791,6 +774,32 @@ static void tegra_sdhci_set_clock(struct
 	}
 }
 
+static void tegra_sdhci_hs400_enhanced_strobe(struct mmc_host *mmc,
+					      struct mmc_ios *ios)
+{
+	struct sdhci_host *host = mmc_priv(mmc);
+	u32 val;
+
+	val = sdhci_readl(host, SDHCI_TEGRA_VENDOR_SYS_SW_CTRL);
+
+	if (ios->enhanced_strobe) {
+		val |= SDHCI_TEGRA_SYS_SW_CTRL_ENHANCED_STROBE;
+		/*
+		 * When CMD13 is sent from mmc_select_hs400es() after
+		 * switching to HS400ES mode, the bus is operating at
+		 * either MMC_HIGH_26_MAX_DTR or MMC_HIGH_52_MAX_DTR.
+		 * To meet Tegra SDHCI requirement at HS400ES mode, force SDHCI
+		 * interface clock to MMC_HS200_MAX_DTR (200 MHz) so that host
+		 * controller CAR clock and the interface clock are rate matched.
+		 */
+		tegra_sdhci_set_clock(host, MMC_HS200_MAX_DTR);
+	} else {
+		val &= ~SDHCI_TEGRA_SYS_SW_CTRL_ENHANCED_STROBE;
+	}
+
+	sdhci_writel(host, val, SDHCI_TEGRA_VENDOR_SYS_SW_CTRL);
+}
+
 static unsigned int tegra_sdhci_get_max_clock(struct sdhci_host *host)
 {
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);


