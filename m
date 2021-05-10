Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0DD337857E
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235264AbhEJLAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:00:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234279AbhEJK4H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:56:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05E0E613C2;
        Mon, 10 May 2021 10:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643506;
        bh=4Myl21CWU6U64fWgTeuorGSlIN0APLEr2lw40LdBvVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KJRagKUbLrKlN/1EmAfOOsErWppXzni4gYTj8VQtuKLgVXwuRrfMa412BibxfJqQG
         V6DW60gjIYtOOgLVFtNUgyMfoF8Rxl132vFqGIoCfymCcuI/FN0nz2Bd4UcY65gNe9
         dxWNLEesUhcZ4mPXK0xmUAqbLedakQDTtIWu1MpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Mostafa <kamal@canonical.com>,
        Aniruddha Tvs Rao <anrao@nvidia.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Thierry Reding <treding@nvidia.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.11 042/342] mmc: sdhci-tegra: Add required callbacks to set/clear CQE_EN bit
Date:   Mon, 10 May 2021 12:17:12 +0200
Message-Id: <20210510102011.501871055@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aniruddha Tvs Rao <anrao@nvidia.com>

commit 5ec6fa5a6dc5e42a4aa782f3a81d5f08b0fac1e6 upstream.

CMD8 is not supported with Command Queue Enabled. Add required callback
to clear CQE_EN and CQE_INTR fields in the host controller register
before sending CMD8. Add corresponding callback in the CQHCI resume path
to re-enable CQE_EN and CQE_INTR fields.

Reported-by: Kamal Mostafa <kamal@canonical.com>
Tested-by: Kamal Mostafa <kamal@canonical.com>
Signed-off-by: Aniruddha Tvs Rao <anrao@nvidia.com>
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20210407094617.770495-1-jonathanh@nvidia.com
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-tegra.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -119,6 +119,10 @@
 /* SDMMC CQE Base Address for Tegra Host Ver 4.1 and Higher */
 #define SDHCI_TEGRA_CQE_BASE_ADDR			0xF000
 
+#define SDHCI_TEGRA_CQE_TRNS_MODE	(SDHCI_TRNS_MULTI | \
+					 SDHCI_TRNS_BLK_CNT_EN | \
+					 SDHCI_TRNS_DMA)
+
 struct sdhci_tegra_soc_data {
 	const struct sdhci_pltfm_data *pdata;
 	u64 dma_mask;
@@ -1156,6 +1160,7 @@ static void tegra_sdhci_voltage_switch(s
 static void tegra_cqhci_writel(struct cqhci_host *cq_host, u32 val, int reg)
 {
 	struct mmc_host *mmc = cq_host->mmc;
+	struct sdhci_host *host = mmc_priv(mmc);
 	u8 ctrl;
 	ktime_t timeout;
 	bool timed_out;
@@ -1170,6 +1175,7 @@ static void tegra_cqhci_writel(struct cq
 	 */
 	if (reg == CQHCI_CTL && !(val & CQHCI_HALT) &&
 	    cqhci_readl(cq_host, CQHCI_CTL) & CQHCI_HALT) {
+		sdhci_writew(host, SDHCI_TEGRA_CQE_TRNS_MODE, SDHCI_TRANSFER_MODE);
 		sdhci_cqe_enable(mmc);
 		writel(val, cq_host->mmio + reg);
 		timeout = ktime_add_us(ktime_get(), 50);
@@ -1205,6 +1211,7 @@ static void sdhci_tegra_update_dcmd_desc
 static void sdhci_tegra_cqe_enable(struct mmc_host *mmc)
 {
 	struct cqhci_host *cq_host = mmc->cqe_private;
+	struct sdhci_host *host = mmc_priv(mmc);
 	u32 val;
 
 	/*
@@ -1218,6 +1225,7 @@ static void sdhci_tegra_cqe_enable(struc
 		if (val & CQHCI_ENABLE)
 			cqhci_writel(cq_host, (val & ~CQHCI_ENABLE),
 				     CQHCI_CFG);
+		sdhci_writew(host, SDHCI_TEGRA_CQE_TRNS_MODE, SDHCI_TRANSFER_MODE);
 		sdhci_cqe_enable(mmc);
 		if (val & CQHCI_ENABLE)
 			cqhci_writel(cq_host, val, CQHCI_CFG);
@@ -1281,12 +1289,36 @@ static void tegra_sdhci_set_timeout(stru
 	__sdhci_set_timeout(host, cmd);
 }
 
+static void sdhci_tegra_cqe_pre_enable(struct mmc_host *mmc)
+{
+	struct cqhci_host *cq_host = mmc->cqe_private;
+	u32 reg;
+
+	reg = cqhci_readl(cq_host, CQHCI_CFG);
+	reg |= CQHCI_ENABLE;
+	cqhci_writel(cq_host, reg, CQHCI_CFG);
+}
+
+static void sdhci_tegra_cqe_post_disable(struct mmc_host *mmc)
+{
+	struct cqhci_host *cq_host = mmc->cqe_private;
+	struct sdhci_host *host = mmc_priv(mmc);
+	u32 reg;
+
+	reg = cqhci_readl(cq_host, CQHCI_CFG);
+	reg &= ~CQHCI_ENABLE;
+	cqhci_writel(cq_host, reg, CQHCI_CFG);
+	sdhci_writew(host, 0x0, SDHCI_TRANSFER_MODE);
+}
+
 static const struct cqhci_host_ops sdhci_tegra_cqhci_ops = {
 	.write_l    = tegra_cqhci_writel,
 	.enable	= sdhci_tegra_cqe_enable,
 	.disable = sdhci_cqe_disable,
 	.dumpregs = sdhci_tegra_dumpregs,
 	.update_dcmd_desc = sdhci_tegra_update_dcmd_desc,
+	.pre_enable = sdhci_tegra_cqe_pre_enable,
+	.post_disable = sdhci_tegra_cqe_post_disable,
 };
 
 static int tegra_sdhci_set_dma_mask(struct sdhci_host *host)


