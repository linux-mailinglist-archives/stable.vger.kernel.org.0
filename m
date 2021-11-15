Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC3014510D7
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243099AbhKOSzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:55:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:54314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243152AbhKOSw1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:52:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EC576345F;
        Mon, 15 Nov 2021 18:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999784;
        bh=8g5ph0B54mj9+afhsJADtE4Qtx43GPKcwAsE3iJGZsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0FTzwYssJfuwlSvpS97T9TxrOBg3Vj3IuK2jRkq+pgCC8DV3M6b5x4K9llPmqZCFK
         We4c0cCz/dfp7rp+/KFj70MeQI9UJSxk/imCHsZT3EUE/Mb5kM5bCZyuqzONLSLXOo
         7eQyjQaqgttA/Kw4IT5girgEysQQv5xhqgR/cldo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 421/849] mmc: sdhci-omap: Fix context restore
Date:   Mon, 15 Nov 2021 17:58:24 +0100
Message-Id: <20211115165434.507638152@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit d806e334d0390502cd2a820ad33d65d7f9bba618 ]

We need to restore context in a specified order with HCTL set in two
phases. This is similar to what omap_hsmmc_context_restore() is doing.
Otherwise SDIO can stop working on resume.

And for PM runtime and SDIO cards, we need to also save SYSCTL, IE and
ISE.

This should not be a problem currently, and these patches can be applied
whenever suitable.

Fixes: ee0f309263a6 ("mmc: sdhci-omap: Add Support for Suspend/Resume")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20210921110029.21944-3-tony@atomide.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-omap.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-omap.c b/drivers/mmc/host/sdhci-omap.c
index 3ddced779e965..fd188b6d88f49 100644
--- a/drivers/mmc/host/sdhci-omap.c
+++ b/drivers/mmc/host/sdhci-omap.c
@@ -62,6 +62,8 @@
 #define SDHCI_OMAP_IE		0x234
 #define INT_CC_EN		BIT(0)
 
+#define SDHCI_OMAP_ISE		0x238
+
 #define SDHCI_OMAP_AC12		0x23c
 #define AC12_V1V8_SIGEN		BIT(19)
 #define AC12_SCLK_SEL		BIT(23)
@@ -113,6 +115,8 @@ struct sdhci_omap_host {
 	u32			hctl;
 	u32			sysctl;
 	u32			capa;
+	u32			ie;
+	u32			ise;
 };
 
 static void sdhci_omap_start_clock(struct sdhci_omap_host *omap_host);
@@ -1245,14 +1249,23 @@ static void sdhci_omap_context_save(struct sdhci_omap_host *omap_host)
 {
 	omap_host->con = sdhci_omap_readl(omap_host, SDHCI_OMAP_CON);
 	omap_host->hctl = sdhci_omap_readl(omap_host, SDHCI_OMAP_HCTL);
+	omap_host->sysctl = sdhci_omap_readl(omap_host, SDHCI_OMAP_SYSCTL);
 	omap_host->capa = sdhci_omap_readl(omap_host, SDHCI_OMAP_CAPA);
+	omap_host->ie = sdhci_omap_readl(omap_host, SDHCI_OMAP_IE);
+	omap_host->ise = sdhci_omap_readl(omap_host, SDHCI_OMAP_ISE);
 }
 
+/* Order matters here, HCTL must be restored in two phases */
 static void sdhci_omap_context_restore(struct sdhci_omap_host *omap_host)
 {
-	sdhci_omap_writel(omap_host, SDHCI_OMAP_CON, omap_host->con);
 	sdhci_omap_writel(omap_host, SDHCI_OMAP_HCTL, omap_host->hctl);
 	sdhci_omap_writel(omap_host, SDHCI_OMAP_CAPA, omap_host->capa);
+	sdhci_omap_writel(omap_host, SDHCI_OMAP_HCTL, omap_host->hctl);
+
+	sdhci_omap_writel(omap_host, SDHCI_OMAP_SYSCTL, omap_host->sysctl);
+	sdhci_omap_writel(omap_host, SDHCI_OMAP_CON, omap_host->con);
+	sdhci_omap_writel(omap_host, SDHCI_OMAP_IE, omap_host->ie);
+	sdhci_omap_writel(omap_host, SDHCI_OMAP_ISE, omap_host->ise);
 }
 
 static int __maybe_unused sdhci_omap_suspend(struct device *dev)
-- 
2.33.0



