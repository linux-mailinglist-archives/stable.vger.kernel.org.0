Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC0D272DF5
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729171AbgIUQom (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:44:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729697AbgIUQok (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:44:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D52422076B;
        Mon, 21 Sep 2020 16:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706679;
        bh=vWtcyqwtyNOp01tEM8J/9uDwxaqAR3NU3ZCdVnk7iOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hauHFvVut/ruSlfm1QkAQgaeYm8iD1pDDp399lAjJQ0KPG+Q7Evro55g9ouMx4SMy
         uu/NWs2765Pffd+ul14NgztBm3e6uhxW7PByaD5d6QDsz4wab03ZcCjzN9YZQFIP2l
         ZTtMniHyndHm5NM5HfAWPQ9MHSn8b9DRJvyzGVMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Bundy <christianbundy@fraction.io>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 050/118] ASoC: Intel: haswell: Fix power transition refactor
Date:   Mon, 21 Sep 2020 18:27:42 +0200
Message-Id: <20200921162038.646649970@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 154549558a622b31702fcaa01ccd85e6e34073de ]

While addressing existing power-cycle limitations for
sound/soc/intel/haswell solution, change brings regression for standard
audio userspace flows e.g.: when using PulseAudio.

Occasional sound-card initialization fail is still better than
permanent audio distortions, so revert the change.

Fixes: 8ec7d6043263 ("ASoC: Intel: haswell: Power transition refactor")
Reported-by: Christian Bundy <christianbundy@fraction.io>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200901153041.14771-1-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/haswell/sst-haswell-dsp.c | 185 ++++++++++------------
 1 file changed, 81 insertions(+), 104 deletions(-)

diff --git a/sound/soc/intel/haswell/sst-haswell-dsp.c b/sound/soc/intel/haswell/sst-haswell-dsp.c
index de80e19454c13..88c3f63bded90 100644
--- a/sound/soc/intel/haswell/sst-haswell-dsp.c
+++ b/sound/soc/intel/haswell/sst-haswell-dsp.c
@@ -243,92 +243,45 @@ static irqreturn_t hsw_irq(int irq, void *context)
 	return ret;
 }
 
-#define CSR_DEFAULT_VALUE 0x8480040E
-#define ISC_DEFAULT_VALUE 0x0
-#define ISD_DEFAULT_VALUE 0x0
-#define IMC_DEFAULT_VALUE 0x7FFF0003
-#define IMD_DEFAULT_VALUE 0x7FFF0003
-#define IPCC_DEFAULT_VALUE 0x0
-#define IPCD_DEFAULT_VALUE 0x0
-#define CLKCTL_DEFAULT_VALUE 0x7FF
-#define CSR2_DEFAULT_VALUE 0x0
-#define LTR_CTRL_DEFAULT_VALUE 0x0
-#define HMD_CTRL_DEFAULT_VALUE 0x0
-
-static void hsw_set_shim_defaults(struct sst_dsp *sst)
-{
-	sst_dsp_shim_write_unlocked(sst, SST_CSR, CSR_DEFAULT_VALUE);
-	sst_dsp_shim_write_unlocked(sst, SST_ISRX, ISC_DEFAULT_VALUE);
-	sst_dsp_shim_write_unlocked(sst, SST_ISRD, ISD_DEFAULT_VALUE);
-	sst_dsp_shim_write_unlocked(sst, SST_IMRX, IMC_DEFAULT_VALUE);
-	sst_dsp_shim_write_unlocked(sst, SST_IMRD, IMD_DEFAULT_VALUE);
-	sst_dsp_shim_write_unlocked(sst, SST_IPCX, IPCC_DEFAULT_VALUE);
-	sst_dsp_shim_write_unlocked(sst, SST_IPCD, IPCD_DEFAULT_VALUE);
-	sst_dsp_shim_write_unlocked(sst, SST_CLKCTL, CLKCTL_DEFAULT_VALUE);
-	sst_dsp_shim_write_unlocked(sst, SST_CSR2, CSR2_DEFAULT_VALUE);
-	sst_dsp_shim_write_unlocked(sst, SST_LTRC, LTR_CTRL_DEFAULT_VALUE);
-	sst_dsp_shim_write_unlocked(sst, SST_HMDC, HMD_CTRL_DEFAULT_VALUE);
-}
-
-/* all clock-gating minus DCLCGE and DTCGE */
-#define SST_VDRTCL2_CG_OTHER	0xB7D
-
 static void hsw_set_dsp_D3(struct sst_dsp *sst)
 {
+	u32 val;
 	u32 reg;
 
-	/* disable clock core gating */
+	/* Disable core clock gating (VDRTCTL2.DCLCGE = 0) */
 	reg = readl(sst->addr.pci_cfg + SST_VDRTCTL2);
-	reg &= ~(SST_VDRTCL2_DCLCGE);
+	reg &= ~(SST_VDRTCL2_DCLCGE | SST_VDRTCL2_DTCGE);
 	writel(reg, sst->addr.pci_cfg + SST_VDRTCTL2);
 
-	/* stall, reset and set 24MHz XOSC */
-	sst_dsp_shim_update_bits_unlocked(sst, SST_CSR,
-			SST_CSR_24MHZ_LPCS | SST_CSR_STALL | SST_CSR_RST,
-			SST_CSR_24MHZ_LPCS | SST_CSR_STALL | SST_CSR_RST);
-
-	/* DRAM power gating all */
-	reg = readl(sst->addr.pci_cfg + SST_VDRTCTL0);
-	reg |= SST_VDRTCL0_ISRAMPGE_MASK |
-		SST_VDRTCL0_DSRAMPGE_MASK;
-	reg &= ~(SST_VDRTCL0_D3SRAMPGD);
-	reg |= SST_VDRTCL0_D3PGD;
-	writel(reg, sst->addr.pci_cfg + SST_VDRTCTL0);
-	udelay(50);
+	/* enable power gating and switch off DRAM & IRAM blocks */
+	val = readl(sst->addr.pci_cfg + SST_VDRTCTL0);
+	val |= SST_VDRTCL0_DSRAMPGE_MASK |
+		SST_VDRTCL0_ISRAMPGE_MASK;
+	val &= ~(SST_VDRTCL0_D3PGD | SST_VDRTCL0_D3SRAMPGD);
+	writel(val, sst->addr.pci_cfg + SST_VDRTCTL0);
 
-	/* PLL shutdown enable */
-	reg = readl(sst->addr.pci_cfg + SST_VDRTCTL2);
-	reg |= SST_VDRTCL2_APLLSE_MASK;
-	writel(reg, sst->addr.pci_cfg + SST_VDRTCTL2);
+	/* switch off audio PLL */
+	val = readl(sst->addr.pci_cfg + SST_VDRTCTL2);
+	val |= SST_VDRTCL2_APLLSE_MASK;
+	writel(val, sst->addr.pci_cfg + SST_VDRTCTL2);
 
-	/* disable MCLK */
+	/* disable MCLK(clkctl.smos = 0) */
 	sst_dsp_shim_update_bits_unlocked(sst, SST_CLKCTL,
-			SST_CLKCTL_MASK, 0);
-
-	/* switch clock gating */
-	reg = readl(sst->addr.pci_cfg + SST_VDRTCTL2);
-	reg |= SST_VDRTCL2_CG_OTHER;
-	reg &= ~(SST_VDRTCL2_DTCGE);
-	writel(reg, sst->addr.pci_cfg + SST_VDRTCTL2);
-	/* enable DTCGE separatelly */
-	reg = readl(sst->addr.pci_cfg + SST_VDRTCTL2);
-	reg |= SST_VDRTCL2_DTCGE;
-	writel(reg, sst->addr.pci_cfg + SST_VDRTCTL2);
+		SST_CLKCTL_MASK, 0);
 
-	/* set shim defaults */
-	hsw_set_shim_defaults(sst);
-
-	/* set D3 */
-	reg = readl(sst->addr.pci_cfg + SST_PMCS);
-	reg |= SST_PMCS_PS_MASK;
-	writel(reg, sst->addr.pci_cfg + SST_PMCS);
+	/* Set D3 state, delay 50 us */
+	val = readl(sst->addr.pci_cfg + SST_PMCS);
+	val |= SST_PMCS_PS_MASK;
+	writel(val, sst->addr.pci_cfg + SST_PMCS);
 	udelay(50);
 
-	/* enable clock core gating */
+	/* Enable core clock gating (VDRTCTL2.DCLCGE = 1), delay 50 us */
 	reg = readl(sst->addr.pci_cfg + SST_VDRTCTL2);
-	reg |= SST_VDRTCL2_DCLCGE;
+	reg |= SST_VDRTCL2_DCLCGE | SST_VDRTCL2_DTCGE;
 	writel(reg, sst->addr.pci_cfg + SST_VDRTCTL2);
+
 	udelay(50);
+
 }
 
 static void hsw_reset(struct sst_dsp *sst)
@@ -346,62 +299,75 @@ static void hsw_reset(struct sst_dsp *sst)
 		SST_CSR_RST | SST_CSR_STALL, SST_CSR_STALL);
 }
 
-/* recommended CSR state for power-up */
-#define SST_CSR_D0_MASK (0x18A09C0C | SST_CSR_DCS_MASK)
-
 static int hsw_set_dsp_D0(struct sst_dsp *sst)
 {
-	u32 reg;
+	int tries = 10;
+	u32 reg, fw_dump_bit;
 
-	/* disable clock core gating */
+	/* Disable core clock gating (VDRTCTL2.DCLCGE = 0) */
 	reg = readl(sst->addr.pci_cfg + SST_VDRTCTL2);
-	reg &= ~(SST_VDRTCL2_DCLCGE);
+	reg &= ~(SST_VDRTCL2_DCLCGE | SST_VDRTCL2_DTCGE);
 	writel(reg, sst->addr.pci_cfg + SST_VDRTCTL2);
 
-	/* switch clock gating */
-	reg = readl(sst->addr.pci_cfg + SST_VDRTCTL2);
-	reg |= SST_VDRTCL2_CG_OTHER;
-	reg &= ~(SST_VDRTCL2_DTCGE);
-	writel(reg, sst->addr.pci_cfg + SST_VDRTCTL2);
+	/* Disable D3PG (VDRTCTL0.D3PGD = 1) */
+	reg = readl(sst->addr.pci_cfg + SST_VDRTCTL0);
+	reg |= SST_VDRTCL0_D3PGD;
+	writel(reg, sst->addr.pci_cfg + SST_VDRTCTL0);
 
-	/* set D0 */
+	/* Set D0 state */
 	reg = readl(sst->addr.pci_cfg + SST_PMCS);
-	reg &= ~(SST_PMCS_PS_MASK);
+	reg &= ~SST_PMCS_PS_MASK;
 	writel(reg, sst->addr.pci_cfg + SST_PMCS);
 
-	/* DRAM power gating none */
-	reg = readl(sst->addr.pci_cfg + SST_VDRTCTL0);
-	reg &= ~(SST_VDRTCL0_ISRAMPGE_MASK |
-		SST_VDRTCL0_DSRAMPGE_MASK);
-	reg |= SST_VDRTCL0_D3SRAMPGD;
-	reg |= SST_VDRTCL0_D3PGD;
-	writel(reg, sst->addr.pci_cfg + SST_VDRTCTL0);
-	mdelay(10);
+	/* check that ADSP shim is enabled */
+	while (tries--) {
+		reg = readl(sst->addr.pci_cfg + SST_PMCS) & SST_PMCS_PS_MASK;
+		if (reg == 0)
+			goto finish;
+
+		msleep(1);
+	}
+
+	return -ENODEV;
 
-	/* set shim defaults */
-	hsw_set_shim_defaults(sst);
+finish:
+	/* select SSP1 19.2MHz base clock, SSP clock 0, turn off Low Power Clock */
+	sst_dsp_shim_update_bits_unlocked(sst, SST_CSR,
+		SST_CSR_S1IOCS | SST_CSR_SBCS1 | SST_CSR_LPCS, 0x0);
+
+	/* stall DSP core, set clk to 192/96Mhz */
+	sst_dsp_shim_update_bits_unlocked(sst,
+		SST_CSR, SST_CSR_STALL | SST_CSR_DCS_MASK,
+		SST_CSR_STALL | SST_CSR_DCS(4));
 
-	/* restore MCLK */
+	/* Set 24MHz MCLK, prevent local clock gating, enable SSP0 clock */
 	sst_dsp_shim_update_bits_unlocked(sst, SST_CLKCTL,
-			SST_CLKCTL_MASK, SST_CLKCTL_MASK);
+		SST_CLKCTL_MASK | SST_CLKCTL_DCPLCG | SST_CLKCTL_SCOE0,
+		SST_CLKCTL_MASK | SST_CLKCTL_DCPLCG | SST_CLKCTL_SCOE0);
 
-	/* PLL shutdown disable */
+	/* Stall and reset core, set CSR */
+	hsw_reset(sst);
+
+	/* Enable core clock gating (VDRTCTL2.DCLCGE = 1), delay 50 us */
 	reg = readl(sst->addr.pci_cfg + SST_VDRTCTL2);
-	reg &= ~(SST_VDRTCL2_APLLSE_MASK);
+	reg |= SST_VDRTCL2_DCLCGE | SST_VDRTCL2_DTCGE;
 	writel(reg, sst->addr.pci_cfg + SST_VDRTCTL2);
 
-	sst_dsp_shim_update_bits_unlocked(sst, SST_CSR,
-			SST_CSR_D0_MASK, SST_CSR_SBCS0 | SST_CSR_SBCS1 |
-			SST_CSR_STALL | SST_CSR_DCS(4));
 	udelay(50);
 
-	/* enable clock core gating */
+	/* switch on audio PLL */
 	reg = readl(sst->addr.pci_cfg + SST_VDRTCTL2);
-	reg |= SST_VDRTCL2_DCLCGE;
+	reg &= ~SST_VDRTCL2_APLLSE_MASK;
 	writel(reg, sst->addr.pci_cfg + SST_VDRTCTL2);
 
-	/* clear reset */
-	sst_dsp_shim_update_bits_unlocked(sst, SST_CSR, SST_CSR_RST, 0);
+	/* set default power gating control, enable power gating control for all blocks. that is,
+	can't be accessed, please enable each block before accessing. */
+	reg = readl(sst->addr.pci_cfg + SST_VDRTCTL0);
+	reg |= SST_VDRTCL0_DSRAMPGE_MASK | SST_VDRTCL0_ISRAMPGE_MASK;
+	/* for D0, always enable the block(DSRAM[0]) used for FW dump */
+	fw_dump_bit = 1 << SST_VDRTCL0_DSRAMPGE_SHIFT;
+	writel(reg & ~fw_dump_bit, sst->addr.pci_cfg + SST_VDRTCTL0);
+
 
 	/* disable DMA finish function for SSP0 & SSP1 */
 	sst_dsp_shim_update_bits_unlocked(sst, SST_CSR2, SST_CSR2_SDFD_SSP1,
@@ -418,6 +384,12 @@ static int hsw_set_dsp_D0(struct sst_dsp *sst)
 	sst_dsp_shim_update_bits(sst, SST_IMRD, (SST_IMRD_DONE | SST_IMRD_BUSY |
 				SST_IMRD_SSP0 | SST_IMRD_DMAC), 0x0);
 
+	/* clear IPC registers */
+	sst_dsp_shim_write(sst, SST_IPCX, 0x0);
+	sst_dsp_shim_write(sst, SST_IPCD, 0x0);
+	sst_dsp_shim_write(sst, 0x80, 0x6);
+	sst_dsp_shim_write(sst, 0xe0, 0x300a);
+
 	return 0;
 }
 
@@ -443,6 +415,11 @@ static void hsw_sleep(struct sst_dsp *sst)
 {
 	dev_dbg(sst->dev, "HSW_PM dsp runtime suspend\n");
 
+	/* put DSP into reset and stall */
+	sst_dsp_shim_update_bits(sst, SST_CSR,
+		SST_CSR_24MHZ_LPCS | SST_CSR_RST | SST_CSR_STALL,
+		SST_CSR_RST | SST_CSR_STALL | SST_CSR_24MHZ_LPCS);
+
 	hsw_set_dsp_D3(sst);
 	dev_dbg(sst->dev, "HSW_PM dsp runtime suspend exit\n");
 }
-- 
2.25.1



