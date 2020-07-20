Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3E822660F
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732334AbgGTP76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:59:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732329AbgGTP75 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:59:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3999E20773;
        Mon, 20 Jul 2020 15:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260796;
        bh=NU3TG0s7MfbTzVYgvNToxG5Yjvfw1M2N6dcL0zCmgGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1GQ4dOtZoXFWFvAmbQLCp3Pmhvey7EE41b/wYWRzLfieEsQBZNAdUdByna8+5bUpZ
         zwPYiHbPVvqQn5z/nPXapP4WumhhoW6rh0/nLCzbhevsfoZzHmgX6RHIiyp1llXruS
         MSmvJoQ3WWqryjxFNVYMeL0oTVmyxNh2wl1X+1Ew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ludovic Barre <ludovic.barre@st.com>,
        Brian Masney <masneyb@onstation.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Niklas Cassel <niklas.cassel@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 069/215] mmc: mmci: Support any block sizes for ux500v2 and qcom variant
Date:   Mon, 20 Jul 2020 17:35:51 +0200
Message-Id: <20200720152823.494421593@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 2253ed4b36dc876d1598c4dab5587e537ec68c34 ]

For the ux500v2 variant of the PL18x block, any block sizes
are supported. This is necessary to support some SDIO
transfers. This also affects the QCOM MMCI variant and the
ST micro variant.

For Ux500 an additional quirk only allowing DMA on blocks
that are a power of two is needed. This might be a bug in
the DMA engine (DMA40) or the MMCI or in the interconnect,
but the most likely is the MMCI, as transfers of these
sizes work fine for other devices using the same DMA
engine. DMA works fine also with SDIO as long as the
blocksize is a power of 2.

This patch has proven necessary for enabling SDIO for WLAN on
PostmarketOS-based Ux500 platforms.

What we managed to test in practice is Broadcom WiFi over
SDIO on the Ux500 based Samsung GT-I8190 and GT-S7710.
This WiFi chip, BCM4334 works fine after the patch.

Before this patch:

brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac4334-sdio
	  for chip BCM4334/3
mmci-pl18x 80118000.sdi1_per2: unsupported block size (60 bytes)
brcmfmac: brcmf_sdiod_ramrw: membytes transfer failed
brcmfmac: brcmf_sdio_download_code_file: error -22 on writing
	  434236 membytes at 0x00000000
brcmfmac: brcmf_sdio_download_firmware: dongle image file download
	  failed

After this patch:

brcmfmac: brcmf_c_preinit_dcmds: Firmware: BCM4334/3 wl0:
	  Nov 21 2012 00:21:28 version 6.10.58.813 (B2) FWID 01-0

Bringing up networks, discovering networks with "iw dev wlan0 scan"
and connecting works fine from this point.

This patch is inspired by Ulf Hansson's patch
http://www.spinics.net/lists/linux-mmc/msg12160.html

As the DMA engines on these platforms may now get block sizes
they were not used to before, make sure to also respect if
the DMA engine says "no" to a transfer.

Make a drive-by fix for datactrl_blocksz, misspelled.

Cc: Ludovic Barre <ludovic.barre@st.com>
Cc: Brian Masney <masneyb@onstation.org>
Cc: Stephan Gerhold <stephan@gerhold.net>
Cc: Niklas Cassel <niklas.cassel@linaro.org>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20191217143952.2885-1-linus.walleij@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mmci.c | 34 ++++++++++++++++++++++++++++++----
 drivers/mmc/host/mmci.h |  8 +++++++-
 2 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index c37e70dbe250e..7e4bc9124efde 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -168,6 +168,8 @@ static struct variant_data variant_ux500 = {
 	.cmdreg_srsp		= MCI_CPSM_RESPONSE,
 	.datalength_bits	= 24,
 	.datactrl_blocksz	= 11,
+	.datactrl_any_blocksz	= true,
+	.dma_power_of_2		= true,
 	.datactrl_mask_sdio	= MCI_DPSM_ST_SDIOEN,
 	.st_sdio		= true,
 	.st_clkdiv		= true,
@@ -201,6 +203,8 @@ static struct variant_data variant_ux500v2 = {
 	.datactrl_mask_ddrmode	= MCI_DPSM_ST_DDRMODE,
 	.datalength_bits	= 24,
 	.datactrl_blocksz	= 11,
+	.datactrl_any_blocksz	= true,
+	.dma_power_of_2		= true,
 	.datactrl_mask_sdio	= MCI_DPSM_ST_SDIOEN,
 	.st_sdio		= true,
 	.st_clkdiv		= true,
@@ -260,6 +264,7 @@ static struct variant_data variant_stm32_sdmmc = {
 	.datacnt_useless	= true,
 	.datalength_bits	= 25,
 	.datactrl_blocksz	= 14,
+	.datactrl_any_blocksz	= true,
 	.stm32_idmabsize_mask	= GENMASK(12, 5),
 	.init			= sdmmc_variant_init,
 };
@@ -279,6 +284,7 @@ static struct variant_data variant_qcom = {
 	.data_cmd_enable	= MCI_CPSM_QCOM_DATCMD,
 	.datalength_bits	= 24,
 	.datactrl_blocksz	= 11,
+	.datactrl_any_blocksz	= true,
 	.pwrreg_powerup		= MCI_PWR_UP,
 	.f_max			= 208000000,
 	.explicit_mclk_control	= true,
@@ -447,10 +453,11 @@ void mmci_dma_setup(struct mmci_host *host)
 static int mmci_validate_data(struct mmci_host *host,
 			      struct mmc_data *data)
 {
+	struct variant_data *variant = host->variant;
+
 	if (!data)
 		return 0;
-
-	if (!is_power_of_2(data->blksz)) {
+	if (!is_power_of_2(data->blksz) && !variant->datactrl_any_blocksz) {
 		dev_err(mmc_dev(host->mmc),
 			"unsupported block size (%d bytes)\n", data->blksz);
 		return -EINVAL;
@@ -515,7 +522,9 @@ int mmci_dma_start(struct mmci_host *host, unsigned int datactrl)
 		 "Submit MMCI DMA job, sglen %d blksz %04x blks %04x flags %08x\n",
 		 data->sg_len, data->blksz, data->blocks, data->flags);
 
-	host->ops->dma_start(host, &datactrl);
+	ret = host->ops->dma_start(host, &datactrl);
+	if (ret)
+		return ret;
 
 	/* Trigger the DMA transfer */
 	mmci_write_datactrlreg(host, datactrl);
@@ -822,6 +831,18 @@ static int _mmci_dmae_prep_data(struct mmci_host *host, struct mmc_data *data,
 	if (data->blksz * data->blocks <= variant->fifosize)
 		return -EINVAL;
 
+	/*
+	 * This is necessary to get SDIO working on the Ux500. We do not yet
+	 * know if this is a bug in:
+	 * - The Ux500 DMA controller (DMA40)
+	 * - The MMCI DMA interface on the Ux500
+	 * some power of two blocks (such as 64 bytes) are sent regularly
+	 * during SDIO traffic and those work fine so for these we enable DMA
+	 * transfers.
+	 */
+	if (host->variant->dma_power_of_2 && !is_power_of_2(data->blksz))
+		return -EINVAL;
+
 	device = chan->device;
 	nr_sg = dma_map_sg(device->dev, data->sg, data->sg_len,
 			   mmc_get_dma_dir(data));
@@ -872,9 +893,14 @@ int mmci_dmae_prep_data(struct mmci_host *host,
 int mmci_dmae_start(struct mmci_host *host, unsigned int *datactrl)
 {
 	struct mmci_dmae_priv *dmae = host->dma_priv;
+	int ret;
 
 	host->dma_in_progress = true;
-	dmaengine_submit(dmae->desc_current);
+	ret = dma_submit_error(dmaengine_submit(dmae->desc_current));
+	if (ret < 0) {
+		host->dma_in_progress = false;
+		return ret;
+	}
 	dma_async_issue_pending(dmae->cur);
 
 	*datactrl |= MCI_DPSM_DMAENABLE;
diff --git a/drivers/mmc/host/mmci.h b/drivers/mmc/host/mmci.h
index 833236ecb31e6..89ab73343cf30 100644
--- a/drivers/mmc/host/mmci.h
+++ b/drivers/mmc/host/mmci.h
@@ -278,7 +278,11 @@ struct mmci_host;
  * @stm32_clkdiv: true if using a STM32-specific clock divider algorithm
  * @datactrl_mask_ddrmode: ddr mode mask in datactrl register.
  * @datactrl_mask_sdio: SDIO enable mask in datactrl register
- * @datactrl_blksz: block size in power of two
+ * @datactrl_blocksz: block size in power of two
+ * @datactrl_any_blocksz: true if block any block sizes are accepted by
+ *		  hardware, such as with some SDIO traffic that send
+ *		  odd packets.
+ * @dma_power_of_2: DMA only works with blocks that are a power of 2.
  * @datactrl_first: true if data must be setup before send command
  * @datacnt_useless: true if you could not use datacnt register to read
  *		     remaining data
@@ -323,6 +327,8 @@ struct variant_data {
 	unsigned int		datactrl_mask_ddrmode;
 	unsigned int		datactrl_mask_sdio;
 	unsigned int		datactrl_blocksz;
+	u8			datactrl_any_blocksz:1;
+	u8			dma_power_of_2:1;
 	u8			datactrl_first:1;
 	u8			datacnt_useless:1;
 	u8			st_sdio:1;
-- 
2.25.1



