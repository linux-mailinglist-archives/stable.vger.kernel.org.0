Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82EF8CFFD8
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 19:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfJHR2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 13:28:39 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:50075 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725939AbfJHR2j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 13:28:39 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 4CF9721BBF;
        Tue,  8 Oct 2019 13:28:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 08 Oct 2019 13:28:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=K/vOvA
        o9p8/GMeqwusSAz+jcOeE2jQYnrY15FW8c2ag=; b=N2kzz6aUirhjYt1oet4+eo
        Yjz6gKeCIKe1qu3CYBHrv6VWKVX2swV4fAF61Pfe0CyuUi6hcvhUdMOnhBEwbWBi
        KV0ogmkIM5yZBdLppKNr0TGU8zMMOu7pmwWn5muEFeu97iu0RuOy3cKYmxO+22Et
        1FiTiQR1xqqFuDezfT7ZldwbPBi7zG6ri6TXhY8OR85D0yBWNDIWToeCAeRLz00M
        sYQB2mDdUw7M3/5ntZ5p56wcb7ZjNmegjxpEYfwKqpIsw4L9hc6Ey2SHCN+pX789
        t2U4q9jsN5nwK03uZwLvxX89bbVAjTFax3t9VUsYY7wLWHAwUtdA4kY7UhxIqPfw
        ==
X-ME-Sender: <xms:RMecXUHFzgeuP_ydFFfh8gXH8YMVETIpFMoiWSUMuvA8TaDjqASTlw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheelgdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:RMecXRlYU-9bRcVVwaL_VImFMxcmceAqLXUpF4w8_ydnyS4QrylJLw>
    <xmx:RMecXZLlWW4jxNXzxIqLGAtwWV9D4Pf4G0clNv8nGI2Ay_K3AavqvQ>
    <xmx:RMecXab0Hg6gjso4nqyGdyupJXKgSIz4aEMmprcEd6Lia81K95wq7Q>
    <xmx:RcecXWWda9_594B2F2BU1oidTp0wzbp-2mGdWwd413voN8LjEct6mg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9912E80062;
        Tue,  8 Oct 2019 13:28:36 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mmc: tegra: Implement ->set_dma_mask()" failed to apply to 4.19-stable tree
To:     nicoleotsuka@gmail.com, adrian.hunter@intel.com,
        treding@nvidia.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Oct 2019 19:28:35 +0200
Message-ID: <157055571510029@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b960bc448a252428bacca271f3416a8bda3b599b Mon Sep 17 00:00:00 2001
From: Nicolin Chen <nicoleotsuka@gmail.com>
Date: Mon, 23 Sep 2019 12:08:10 +0200
Subject: [PATCH] mmc: tegra: Implement ->set_dma_mask()

The SDHCI controller on Tegra186 supports 40-bit addressing, which is
usually enough to address all of system memory. However, if the SDHCI
controller is behind an IOMMU, the address space can go beyond. This
happens on Tegra186 and later where the ARM SMMU has an input address
space of 48 bits. If the DMA API is backed by this ARM SMMU, the top-
down IOVA allocator will cause IOV addresses to be returned that the
SDHCI controller cannot access.

Unfortunately, prior to the introduction of the ->set_dma_mask() host
operation, the SDHCI core would set either a 64-bit DMA mask if the
controller claimed to support 64-bit addressing, or a 32-bit DMA mask
otherwise.

Since the full 64 bits cannot be addressed on Tegra, this had to be
worked around in commit 68481a7e1c84 ("mmc: tegra: Mark 64 bit dma
broken on Tegra186") by setting the SDHCI_QUIRK2_BROKEN_64_BIT_DMA
quirk, which effectively restricts the DMA mask to 32 bits.

One disadvantage of this is that dma_map_*() APIs will now try to use
the swiotlb to bounce DMA to addresses beyond of the controller's DMA
mask. This in turn caused degraded performance and can lead to
situations where the swiotlb buffer is exhausted, which in turn leads
to DMA transfers to fail.

With the recent introduction of the ->set_dma_mask() host operation,
this can now be properly fixed. For each generation of Tegra, the exact
supported DMA mask can be configured. This kills two birds with one
stone: it avoids the use of bounce buffers because system memory never
exceeds the addressable memory range of the SDHCI controllers on these
devices, and at the same time when an IOMMU is involved, it prevents
IOV addresses from being allocated beyond the addressible range of the
controllers.

Since the DMA mask is now properly handled, the 64-bit DMA quirk can be
removed.

Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
[treding@nvidia.com: provide more background in commit message]
Tested-by: Nicolin Chen <nicoleotsuka@gmail.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Cc: stable@vger.kernel.org # v4.15 +
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index 02d8f524bb9e..7bc950520fd9 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/dma-mapping.h>
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -104,6 +105,7 @@
 
 struct sdhci_tegra_soc_data {
 	const struct sdhci_pltfm_data *pdata;
+	u64 dma_mask;
 	u32 nvquirks;
 	u8 min_tap_delay;
 	u8 max_tap_delay;
@@ -1233,11 +1235,25 @@ static const struct cqhci_host_ops sdhci_tegra_cqhci_ops = {
 	.update_dcmd_desc = sdhci_tegra_update_dcmd_desc,
 };
 
+static int tegra_sdhci_set_dma_mask(struct sdhci_host *host)
+{
+	struct sdhci_pltfm_host *platform = sdhci_priv(host);
+	struct sdhci_tegra *tegra = sdhci_pltfm_priv(platform);
+	const struct sdhci_tegra_soc_data *soc = tegra->soc_data;
+	struct device *dev = mmc_dev(host->mmc);
+
+	if (soc->dma_mask)
+		return dma_set_mask_and_coherent(dev, soc->dma_mask);
+
+	return 0;
+}
+
 static const struct sdhci_ops tegra_sdhci_ops = {
 	.get_ro     = tegra_sdhci_get_ro,
 	.read_w     = tegra_sdhci_readw,
 	.write_l    = tegra_sdhci_writel,
 	.set_clock  = tegra_sdhci_set_clock,
+	.set_dma_mask = tegra_sdhci_set_dma_mask,
 	.set_bus_width = sdhci_set_bus_width,
 	.reset      = tegra_sdhci_reset,
 	.platform_execute_tuning = tegra_sdhci_execute_tuning,
@@ -1257,6 +1273,7 @@ static const struct sdhci_pltfm_data sdhci_tegra20_pdata = {
 
 static const struct sdhci_tegra_soc_data soc_data_tegra20 = {
 	.pdata = &sdhci_tegra20_pdata,
+	.dma_mask = DMA_BIT_MASK(32),
 	.nvquirks = NVQUIRK_FORCE_SDHCI_SPEC_200 |
 		    NVQUIRK_ENABLE_BLOCK_GAP_DET,
 };
@@ -1283,6 +1300,7 @@ static const struct sdhci_pltfm_data sdhci_tegra30_pdata = {
 
 static const struct sdhci_tegra_soc_data soc_data_tegra30 = {
 	.pdata = &sdhci_tegra30_pdata,
+	.dma_mask = DMA_BIT_MASK(32),
 	.nvquirks = NVQUIRK_ENABLE_SDHCI_SPEC_300 |
 		    NVQUIRK_ENABLE_SDR50 |
 		    NVQUIRK_ENABLE_SDR104 |
@@ -1295,6 +1313,7 @@ static const struct sdhci_ops tegra114_sdhci_ops = {
 	.write_w    = tegra_sdhci_writew,
 	.write_l    = tegra_sdhci_writel,
 	.set_clock  = tegra_sdhci_set_clock,
+	.set_dma_mask = tegra_sdhci_set_dma_mask,
 	.set_bus_width = sdhci_set_bus_width,
 	.reset      = tegra_sdhci_reset,
 	.platform_execute_tuning = tegra_sdhci_execute_tuning,
@@ -1316,6 +1335,7 @@ static const struct sdhci_pltfm_data sdhci_tegra114_pdata = {
 
 static const struct sdhci_tegra_soc_data soc_data_tegra114 = {
 	.pdata = &sdhci_tegra114_pdata,
+	.dma_mask = DMA_BIT_MASK(32),
 };
 
 static const struct sdhci_pltfm_data sdhci_tegra124_pdata = {
@@ -1325,22 +1345,13 @@ static const struct sdhci_pltfm_data sdhci_tegra124_pdata = {
 		  SDHCI_QUIRK_NO_HISPD_BIT |
 		  SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC |
 		  SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN,
-	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN |
-		   /*
-		    * The TRM states that the SD/MMC controller found on
-		    * Tegra124 can address 34 bits (the maximum supported by
-		    * the Tegra memory controller), but tests show that DMA
-		    * to or from above 4 GiB doesn't work. This is possibly
-		    * caused by missing programming, though it's not obvious
-		    * what sequence is required. Mark 64-bit DMA broken for
-		    * now to fix this for existing users (e.g. Nyan boards).
-		    */
-		   SDHCI_QUIRK2_BROKEN_64_BIT_DMA,
+	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN,
 	.ops  = &tegra114_sdhci_ops,
 };
 
 static const struct sdhci_tegra_soc_data soc_data_tegra124 = {
 	.pdata = &sdhci_tegra124_pdata,
+	.dma_mask = DMA_BIT_MASK(34),
 };
 
 static const struct sdhci_ops tegra210_sdhci_ops = {
@@ -1349,6 +1360,7 @@ static const struct sdhci_ops tegra210_sdhci_ops = {
 	.write_w    = tegra210_sdhci_writew,
 	.write_l    = tegra_sdhci_writel,
 	.set_clock  = tegra_sdhci_set_clock,
+	.set_dma_mask = tegra_sdhci_set_dma_mask,
 	.set_bus_width = sdhci_set_bus_width,
 	.reset      = tegra_sdhci_reset,
 	.set_uhs_signaling = tegra_sdhci_set_uhs_signaling,
@@ -1369,6 +1381,7 @@ static const struct sdhci_pltfm_data sdhci_tegra210_pdata = {
 
 static const struct sdhci_tegra_soc_data soc_data_tegra210 = {
 	.pdata = &sdhci_tegra210_pdata,
+	.dma_mask = DMA_BIT_MASK(34),
 	.nvquirks = NVQUIRK_NEEDS_PAD_CONTROL |
 		    NVQUIRK_HAS_PADCALIB |
 		    NVQUIRK_DIS_CARD_CLK_CONFIG_TAP |
@@ -1383,6 +1396,7 @@ static const struct sdhci_ops tegra186_sdhci_ops = {
 	.read_w     = tegra_sdhci_readw,
 	.write_l    = tegra_sdhci_writel,
 	.set_clock  = tegra_sdhci_set_clock,
+	.set_dma_mask = tegra_sdhci_set_dma_mask,
 	.set_bus_width = sdhci_set_bus_width,
 	.reset      = tegra_sdhci_reset,
 	.set_uhs_signaling = tegra_sdhci_set_uhs_signaling,
@@ -1398,20 +1412,13 @@ static const struct sdhci_pltfm_data sdhci_tegra186_pdata = {
 		  SDHCI_QUIRK_NO_HISPD_BIT |
 		  SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC |
 		  SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN,
-	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN |
-		   /* SDHCI controllers on Tegra186 support 40-bit addressing.
-		    * IOVA addresses are 48-bit wide on Tegra186.
-		    * With 64-bit dma mask used for SDHCI, accesses can
-		    * be broken. Disable 64-bit dma, which would fall back
-		    * to 32-bit dma mask. Ideally 40-bit dma mask would work,
-		    * But it is not supported as of now.
-		    */
-		   SDHCI_QUIRK2_BROKEN_64_BIT_DMA,
+	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN,
 	.ops  = &tegra186_sdhci_ops,
 };
 
 static const struct sdhci_tegra_soc_data soc_data_tegra186 = {
 	.pdata = &sdhci_tegra186_pdata,
+	.dma_mask = DMA_BIT_MASK(40),
 	.nvquirks = NVQUIRK_NEEDS_PAD_CONTROL |
 		    NVQUIRK_HAS_PADCALIB |
 		    NVQUIRK_DIS_CARD_CLK_CONFIG_TAP |
@@ -1424,6 +1431,7 @@ static const struct sdhci_tegra_soc_data soc_data_tegra186 = {
 
 static const struct sdhci_tegra_soc_data soc_data_tegra194 = {
 	.pdata = &sdhci_tegra186_pdata,
+	.dma_mask = DMA_BIT_MASK(39),
 	.nvquirks = NVQUIRK_NEEDS_PAD_CONTROL |
 		    NVQUIRK_HAS_PADCALIB |
 		    NVQUIRK_DIS_CARD_CLK_CONFIG_TAP |

