Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD99612F0DB
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728464AbgABWSb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:18:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:33768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728462AbgABWSa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:18:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52C222253D;
        Thu,  2 Jan 2020 22:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003509;
        bh=9Y/scra3EenU/EyuLnNEBmmVW0FiYiey53aeraK4SoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vfvMenPyP6pQr2oRqZ6vK31dznoDgLY1IysmrH/OnncKZBWjsJz71W5BRByWW74EF
         CAPzlVykJ7hozVFkmdW6d3+ybJWf9s0O1il40qfqKC7MMdbmRcqBWBVBrdL/m4fxms
         S/ulYsCY5XrAc210sssY4j9mPUQj6JCcx+MO8Rbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yinbo Zhu <yinbo.zhu@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 190/191] mmc: sdhci-of-esdhc: fix up erratum A-008171 workaround
Date:   Thu,  2 Jan 2020 23:07:52 +0100
Message-Id: <20200102215849.984863022@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangbo Lu <yangbo.lu@nxp.com>

[ Upstream commit 22dc132d5448db1b1c021de0c34aa8033ca7d98f ]

A previous patch implemented an incomplete workaround of erratum
A-008171. The complete workaround is as below. This patch is to
implement the complete workaround which uses SW tuning if HW tuning
fails, and retries both HW/SW tuning once with reduced clock if
workaround fails. This is suggested by hardware team, and the patch
had been verified on LS1046A eSDHC + Phison 32G eMMC which could
trigger the erratum.

Workaround:
/* For T1040, T2080, LS1021A, T1023 Rev 1: */
1. Program TBPTR[TB_WNDW_END_PTR] = 3*DIV_RATIO.
2. Program TBPTR[TB_WNDW_START_PTR] = 5*DIV_RATIO.
3. Program the software tuning mode by setting TBCTL[TB_MODE] = 2'h3.
4. Set SYSCTL2[EXTN] and SYSCTL2[SAMPCLKSEL].
5. Issue SEND_TUNING_BLK Command (CMD19 for SD, CMD21 for MMC).
6. Wait for IRQSTAT[BRR], buffer read ready, to be set.
7. Clear IRQSTAT[BRR].
8. Check SYSCTL2[EXTN] to be cleared.
9. Check SYSCTL2[SAMPCLKSEL], Sampling Clock Select. It's set value
   indicate tuning procedure success, and clear indicate failure.
   In case of tuning failure, fixed sampling scheme could be used by
   clearing TBCTL[TB_EN].
/* For LS1080A Rev 1, LS2088A Rev 1.0, LA1575A Rev 1.0: */
1. Read the TBCTL[31:0] register. Write TBCTL[11:8]=4'h8 and wait for
   1ms.
2. Read the TBCTL[31:0] register and rewrite again. Wait for 1ms second.
3. Read the TBSTAT[31:0] register twice.
3.1 Reset data lines by setting ESDHCCTL[RSTD] bit.
3.2 Check ESDHCCTL[RSTD] bit.
3.3 If ESDHCCTL[RSTD] is 0, go to step 3.4 else go to step 3.2.
3.4 Write 32'hFFFF_FFFF to IRQSTAT register.
4. if TBSTAT[15:8]-TBSTAT[7:0] > 4*DIV_RATIO or TBSTAT[7:0]-TBSTAT[15:8]
   > 4*DIV_RATIO , then program TBPTR[TB_WNDW_END_PTR] = 4*DIV_RATIO and
   program TBPTR[TB_WNDW_START_PTR] = 8*DIV_RATIO.
/* For LS1012A Rev1, LS1043A Rev 1.x, LS1046A 1.0: */
1. Read the TBCTL[0:31] register. Write TBCTL[20:23]=4'h8 and wait for
   1ms.
2. Read the TBCTL[0:31] register and rewrite again. Wait for 1ms second.
3. Read the TBSTAT[0:31] register twice.
3.1 Reset data lines by setting ESDHCCTL[RSTD] bit.
3.2 Check ESDHCCTL[RSTD] bit.
3.3 If ESDHCCTL[RSTD] is 0, go to step 3.4 else go to step 3.2.
3.4 Write 32'hFFFF_FFFF to IRQSTAT register.
4. if TBSTAT[16:23]-TBSTAT[24:31] > 4*DIV_RATIO or TBSTAT[24:31]-
   TBSTAT[16:23] > 4* DIV_RATIO , then program TBPTR[TB_WNDW_END_PTR] =
   4*DIV_RATIO and program TBPTR[TB_WNDW_START_PTR] = 8*DIV_RATIO.
/* For LS1080A Rev 1, LS2088A Rev 1.0, LA1575A Rev 1.0 LS1012A Rev1,
 * LS1043A Rev 1.x, LS1046A 1.0:
 */
5. else program TBPTR[TB_WNDW_END_PTR] = 3*DIV_RATIO and program
   TBPTR[TB_WNDW_START_PTR] = 5*DIV_RATIO.
6. Program the software tuning mode by setting TBCTL[TB_MODE] = 2'h3.
7. Set SYSCTL2[EXTN], wait 1us and SYSCTL2[SAMPCLKSEL].
8. Issue SEND_TUNING_BLK Command (CMD19 for SD, CMD21 for MMC).
9. Wait for IRQSTAT[BRR], buffer read ready, to be set.
10. Clear IRQSTAT[BRR].
11. Check SYSCTL2[EXTN] to be cleared.
12. Check SYSCTL2[SAMPCLKSEL], Sampling Clock Select. It's set value
    indicate tuning procedure success, and clear indicate failure.
    In case of tuning failure, fixed sampling scheme could be used by
    clearing TBCTL[TB_EN].

Fixes: b1f378ab5334 ("mmc: sdhci-of-esdhc: add erratum A008171 support")
Signed-off-by: Yinbo Zhu <yinbo.zhu@nxp.com>
Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-esdhc.h    |  14 ++
 drivers/mmc/host/sdhci-of-esdhc.c | 222 +++++++++++++++++++++++++-----
 2 files changed, 203 insertions(+), 33 deletions(-)

diff --git a/drivers/mmc/host/sdhci-esdhc.h b/drivers/mmc/host/sdhci-esdhc.h
index 57b582bf73d9..9289bb4d633e 100644
--- a/drivers/mmc/host/sdhci-esdhc.h
+++ b/drivers/mmc/host/sdhci-esdhc.h
@@ -51,6 +51,11 @@
 #define ESDHC_CLOCK_HCKEN		0x00000002
 #define ESDHC_CLOCK_IPGEN		0x00000001
 
+/* System Control 2 Register */
+#define ESDHC_SYSTEM_CONTROL_2		0x3c
+#define ESDHC_SMPCLKSEL			0x00800000
+#define ESDHC_EXTN			0x00400000
+
 /* Host Controller Capabilities Register 2 */
 #define ESDHC_CAPABILITIES_1		0x114
 
@@ -59,7 +64,16 @@
 #define ESDHC_HS400_WNDW_ADJUST		0x00000040
 #define ESDHC_HS400_MODE		0x00000010
 #define ESDHC_TB_EN			0x00000004
+#define ESDHC_TB_MODE_MASK		0x00000003
+#define ESDHC_TB_MODE_SW		0x00000003
+#define ESDHC_TB_MODE_3			0x00000002
+
+#define ESDHC_TBSTAT			0x124
+
 #define ESDHC_TBPTR			0x128
+#define ESDHC_WNDW_STRT_PTR_SHIFT	8
+#define ESDHC_WNDW_STRT_PTR_MASK	(0x7f << 8)
+#define ESDHC_WNDW_END_PTR_MASK		0x7f
 
 /* SD Clock Control Register */
 #define ESDHC_SDCLKCTL			0x144
diff --git a/drivers/mmc/host/sdhci-of-esdhc.c b/drivers/mmc/host/sdhci-of-esdhc.c
index 889ed98ec0e7..14f0cb7fa374 100644
--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -77,8 +77,10 @@ struct sdhci_esdhc {
 	bool quirk_incorrect_hostver;
 	bool quirk_limited_clk_division;
 	bool quirk_unreliable_pulse_detection;
-	bool quirk_fixup_tuning;
+	bool quirk_tuning_erratum_type1;
+	bool quirk_tuning_erratum_type2;
 	bool quirk_ignore_data_inhibit;
+	bool in_sw_tuning;
 	unsigned int peripheral_clock;
 	const struct esdhc_clk_fixup *clk_fixup;
 	u32 div_ratio;
@@ -408,6 +410,8 @@ static void esdhc_le_writel(struct sdhci_host *host, u32 val, int reg)
 
 static void esdhc_be_writew(struct sdhci_host *host, u16 val, int reg)
 {
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct sdhci_esdhc *esdhc = sdhci_pltfm_priv(pltfm_host);
 	int base = reg & ~0x3;
 	u32 value;
 	u32 ret;
@@ -416,10 +420,24 @@ static void esdhc_be_writew(struct sdhci_host *host, u16 val, int reg)
 	ret = esdhc_writew_fixup(host, reg, val, value);
 	if (reg != SDHCI_TRANSFER_MODE)
 		iowrite32be(ret, host->ioaddr + base);
+
+	/* Starting SW tuning requires ESDHC_SMPCLKSEL to be set
+	 * 1us later after ESDHC_EXTN is set.
+	 */
+	if (base == ESDHC_SYSTEM_CONTROL_2) {
+		if (!(value & ESDHC_EXTN) && (ret & ESDHC_EXTN) &&
+		    esdhc->in_sw_tuning) {
+			udelay(1);
+			ret |= ESDHC_SMPCLKSEL;
+			iowrite32be(ret, host->ioaddr + base);
+		}
+	}
 }
 
 static void esdhc_le_writew(struct sdhci_host *host, u16 val, int reg)
 {
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct sdhci_esdhc *esdhc = sdhci_pltfm_priv(pltfm_host);
 	int base = reg & ~0x3;
 	u32 value;
 	u32 ret;
@@ -428,6 +446,18 @@ static void esdhc_le_writew(struct sdhci_host *host, u16 val, int reg)
 	ret = esdhc_writew_fixup(host, reg, val, value);
 	if (reg != SDHCI_TRANSFER_MODE)
 		iowrite32(ret, host->ioaddr + base);
+
+	/* Starting SW tuning requires ESDHC_SMPCLKSEL to be set
+	 * 1us later after ESDHC_EXTN is set.
+	 */
+	if (base == ESDHC_SYSTEM_CONTROL_2) {
+		if (!(value & ESDHC_EXTN) && (ret & ESDHC_EXTN) &&
+		    esdhc->in_sw_tuning) {
+			udelay(1);
+			ret |= ESDHC_SMPCLKSEL;
+			iowrite32(ret, host->ioaddr + base);
+		}
+	}
 }
 
 static void esdhc_be_writeb(struct sdhci_host *host, u8 val, int reg)
@@ -793,16 +823,21 @@ static int esdhc_signal_voltage_switch(struct mmc_host *mmc,
 	}
 }
 
-static struct soc_device_attribute soc_fixup_tuning[] = {
+static struct soc_device_attribute soc_tuning_erratum_type1[] = {
+	{ .family = "QorIQ T1023", .revision = "1.0", },
 	{ .family = "QorIQ T1040", .revision = "1.0", },
 	{ .family = "QorIQ T2080", .revision = "1.0", },
-	{ .family = "QorIQ T1023", .revision = "1.0", },
 	{ .family = "QorIQ LS1021A", .revision = "1.0", },
-	{ .family = "QorIQ LS1080A", .revision = "1.0", },
-	{ .family = "QorIQ LS2080A", .revision = "1.0", },
+	{ },
+};
+
+static struct soc_device_attribute soc_tuning_erratum_type2[] = {
 	{ .family = "QorIQ LS1012A", .revision = "1.0", },
 	{ .family = "QorIQ LS1043A", .revision = "1.*", },
 	{ .family = "QorIQ LS1046A", .revision = "1.0", },
+	{ .family = "QorIQ LS1080A", .revision = "1.0", },
+	{ .family = "QorIQ LS2080A", .revision = "1.0", },
+	{ .family = "QorIQ LA1575A", .revision = "1.0", },
 	{ },
 };
 
@@ -826,15 +861,97 @@ static void esdhc_tuning_block_enable(struct sdhci_host *host, bool enable)
 	esdhc_clock_enable(host, true);
 }
 
+static void esdhc_prepare_sw_tuning(struct sdhci_host *host, u8 *window_start,
+				    u8 *window_end)
+{
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct sdhci_esdhc *esdhc = sdhci_pltfm_priv(pltfm_host);
+	u8 tbstat_15_8, tbstat_7_0;
+	u32 val;
+
+	if (esdhc->quirk_tuning_erratum_type1) {
+		*window_start = 5 * esdhc->div_ratio;
+		*window_end = 3 * esdhc->div_ratio;
+		return;
+	}
+
+	/* Write TBCTL[11:8]=4'h8 */
+	val = sdhci_readl(host, ESDHC_TBCTL);
+	val &= ~(0xf << 8);
+	val |= 8 << 8;
+	sdhci_writel(host, val, ESDHC_TBCTL);
+
+	mdelay(1);
+
+	/* Read TBCTL[31:0] register and rewrite again */
+	val = sdhci_readl(host, ESDHC_TBCTL);
+	sdhci_writel(host, val, ESDHC_TBCTL);
+
+	mdelay(1);
+
+	/* Read the TBSTAT[31:0] register twice */
+	val = sdhci_readl(host, ESDHC_TBSTAT);
+	val = sdhci_readl(host, ESDHC_TBSTAT);
+
+	/* Reset data lines by setting ESDHCCTL[RSTD] */
+	sdhci_reset(host, SDHCI_RESET_DATA);
+	/* Write 32'hFFFF_FFFF to IRQSTAT register */
+	sdhci_writel(host, 0xFFFFFFFF, SDHCI_INT_STATUS);
+
+	/* If TBSTAT[15:8]-TBSTAT[7:0] > 4 * div_ratio
+	 * or TBSTAT[7:0]-TBSTAT[15:8] > 4 * div_ratio,
+	 * then program TBPTR[TB_WNDW_END_PTR] = 4 * div_ratio
+	 * and program TBPTR[TB_WNDW_START_PTR] = 8 * div_ratio.
+	 */
+	tbstat_7_0 = val & 0xff;
+	tbstat_15_8 = (val >> 8) & 0xff;
+
+	if (abs(tbstat_15_8 - tbstat_7_0) > (4 * esdhc->div_ratio)) {
+		*window_start = 8 * esdhc->div_ratio;
+		*window_end = 4 * esdhc->div_ratio;
+	} else {
+		*window_start = 5 * esdhc->div_ratio;
+		*window_end = 3 * esdhc->div_ratio;
+	}
+}
+
+static int esdhc_execute_sw_tuning(struct mmc_host *mmc, u32 opcode,
+				   u8 window_start, u8 window_end)
+{
+	struct sdhci_host *host = mmc_priv(mmc);
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct sdhci_esdhc *esdhc = sdhci_pltfm_priv(pltfm_host);
+	u32 val;
+	int ret;
+
+	/* Program TBPTR[TB_WNDW_END_PTR] and TBPTR[TB_WNDW_START_PTR] */
+	val = ((u32)window_start << ESDHC_WNDW_STRT_PTR_SHIFT) &
+	      ESDHC_WNDW_STRT_PTR_MASK;
+	val |= window_end & ESDHC_WNDW_END_PTR_MASK;
+	sdhci_writel(host, val, ESDHC_TBPTR);
+
+	/* Program the software tuning mode by setting TBCTL[TB_MODE]=2'h3 */
+	val = sdhci_readl(host, ESDHC_TBCTL);
+	val &= ~ESDHC_TB_MODE_MASK;
+	val |= ESDHC_TB_MODE_SW;
+	sdhci_writel(host, val, ESDHC_TBCTL);
+
+	esdhc->in_sw_tuning = true;
+	ret = sdhci_execute_tuning(mmc, opcode);
+	esdhc->in_sw_tuning = false;
+	return ret;
+}
+
 static int esdhc_execute_tuning(struct mmc_host *mmc, u32 opcode)
 {
 	struct sdhci_host *host = mmc_priv(mmc);
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct sdhci_esdhc *esdhc = sdhci_pltfm_priv(pltfm_host);
+	u8 window_start, window_end;
+	int ret, retries = 1;
 	bool hs400_tuning;
 	unsigned int clk;
 	u32 val;
-	int ret;
 
 	/* For tuning mode, the sd clock divisor value
 	 * must be larger than 3 according to reference manual.
@@ -843,39 +960,73 @@ static int esdhc_execute_tuning(struct mmc_host *mmc, u32 opcode)
 	if (host->clock > clk)
 		esdhc_of_set_clock(host, clk);
 
-	if (esdhc->quirk_limited_clk_division &&
-	    host->flags & SDHCI_HS400_TUNING)
-		esdhc_of_set_clock(host, host->clock);
-
 	esdhc_tuning_block_enable(host, true);
 
 	hs400_tuning = host->flags & SDHCI_HS400_TUNING;
-	ret = sdhci_execute_tuning(mmc, opcode);
 
-	if (hs400_tuning) {
-		val = sdhci_readl(host, ESDHC_SDTIMNGCTL);
-		val |= ESDHC_FLW_CTL_BG;
-		sdhci_writel(host, val, ESDHC_SDTIMNGCTL);
-	}
+	do {
+		if (esdhc->quirk_limited_clk_division &&
+		    hs400_tuning)
+			esdhc_of_set_clock(host, host->clock);
 
-	if (host->tuning_err == -EAGAIN && esdhc->quirk_fixup_tuning) {
+		/* Do HW tuning */
+		val = sdhci_readl(host, ESDHC_TBCTL);
+		val &= ~ESDHC_TB_MODE_MASK;
+		val |= ESDHC_TB_MODE_3;
+		sdhci_writel(host, val, ESDHC_TBCTL);
 
-		/* program TBPTR[TB_WNDW_END_PTR] = 3*DIV_RATIO and
-		 * program TBPTR[TB_WNDW_START_PTR] = 5*DIV_RATIO
-		 */
-		val = sdhci_readl(host, ESDHC_TBPTR);
-		val = (val & ~((0x7f << 8) | 0x7f)) |
-		(3 * esdhc->div_ratio) | ((5 * esdhc->div_ratio) << 8);
-		sdhci_writel(host, val, ESDHC_TBPTR);
+		ret = sdhci_execute_tuning(mmc, opcode);
+		if (ret)
+			break;
 
-		/* program the software tuning mode by setting
-		 * TBCTL[TB_MODE]=2'h3
+		/* If HW tuning fails and triggers erratum,
+		 * try workaround.
 		 */
-		val = sdhci_readl(host, ESDHC_TBCTL);
-		val |= 0x3;
-		sdhci_writel(host, val, ESDHC_TBCTL);
-		sdhci_execute_tuning(mmc, opcode);
+		ret = host->tuning_err;
+		if (ret == -EAGAIN &&
+		    (esdhc->quirk_tuning_erratum_type1 ||
+		     esdhc->quirk_tuning_erratum_type2)) {
+			/* Recover HS400 tuning flag */
+			if (hs400_tuning)
+				host->flags |= SDHCI_HS400_TUNING;
+			pr_info("%s: Hold on to use fixed sampling clock. Try SW tuning!\n",
+				mmc_hostname(mmc));
+			/* Do SW tuning */
+			esdhc_prepare_sw_tuning(host, &window_start,
+						&window_end);
+			ret = esdhc_execute_sw_tuning(mmc, opcode,
+						      window_start,
+						      window_end);
+			if (ret)
+				break;
+
+			/* Retry both HW/SW tuning with reduced clock. */
+			ret = host->tuning_err;
+			if (ret == -EAGAIN && retries) {
+				/* Recover HS400 tuning flag */
+				if (hs400_tuning)
+					host->flags |= SDHCI_HS400_TUNING;
+
+				clk = host->max_clk / (esdhc->div_ratio + 1);
+				esdhc_of_set_clock(host, clk);
+				pr_info("%s: Hold on to use fixed sampling clock. Try tuning with reduced clock!\n",
+					mmc_hostname(mmc));
+			} else {
+				break;
+			}
+		} else {
+			break;
+		}
+	} while (retries--);
+
+	if (ret) {
+		esdhc_tuning_block_enable(host, false);
+	} else if (hs400_tuning) {
+		val = sdhci_readl(host, ESDHC_SDTIMNGCTL);
+		val |= ESDHC_FLW_CTL_BG;
+		sdhci_writel(host, val, ESDHC_SDTIMNGCTL);
 	}
+
 	return ret;
 }
 
@@ -1111,10 +1262,15 @@ static int sdhci_esdhc_probe(struct platform_device *pdev)
 
 	pltfm_host = sdhci_priv(host);
 	esdhc = sdhci_pltfm_priv(pltfm_host);
-	if (soc_device_match(soc_fixup_tuning))
-		esdhc->quirk_fixup_tuning = true;
+	if (soc_device_match(soc_tuning_erratum_type1))
+		esdhc->quirk_tuning_erratum_type1 = true;
+	else
+		esdhc->quirk_tuning_erratum_type1 = false;
+
+	if (soc_device_match(soc_tuning_erratum_type2))
+		esdhc->quirk_tuning_erratum_type2 = true;
 	else
-		esdhc->quirk_fixup_tuning = false;
+		esdhc->quirk_tuning_erratum_type2 = false;
 
 	if (esdhc->vendor_ver == VENDOR_V_22)
 		host->quirks2 |= SDHCI_QUIRK2_HOST_NO_CMD23;
-- 
2.20.1



