Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51EFE240862
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgHJPUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:20:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:51072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728009AbgHJPUe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:20:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2546120768;
        Mon, 10 Aug 2020 15:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597072833;
        bh=whRtReFj08e1xp24K+N5xB+MQVPRFfMYSvGhLz/DV98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YRr7Jef4yq0dM7Pl5DgFWfWAszjhc94UqSojY1fEcinKGbiz41DqIPppsAG86SFbG
         tttJc5xJLQMwd+KcieInp1ObUV46Z04YZ8gOhgDA9ps3yil1WxeH8qUJyW2gmuoyxi
         rm2EdMlFAxRpcqhuGzIKl12Q++R3Ti993gaPaUnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Chauvet <kwizart@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Manikanta Maddireddy <mmaddireddy@nvidia.com>
Subject: [PATCH 5.8 34/38] PCI: tegra: Revert tegra124 raw_violation_fixup
Date:   Mon, 10 Aug 2020 17:19:24 +0200
Message-Id: <20200810151805.595967901@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151803.920113428@linuxfoundation.org>
References: <20200810151803.920113428@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Chauvet <kwizart@gmail.com>

commit e7b856dfcec6d3bf028adee8c65342d7035914a1 upstream.

As reported in https://bugzilla.kernel.org/206217 , raw_violation_fixup
is causing more harm than good in some common use-cases.

This patch is a partial revert of commit:

191cd6fb5d2c ("PCI: tegra: Add SW fixup for RAW violations")

and fixes the following regression since then.

* Description:

When both the NIC and MMC are used one can see the following message:

  NETDEV WATCHDOG: enp1s0 (r8169): transmit queue 0 timed out

and

  pcieport 0000:00:02.0: AER: Uncorrected (Non-Fatal) error received: 0000:01:00.0
  r8169 0000:01:00.0: AER: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
  r8169 0000:01:00.0: AER:   device [10ec:8168] error status/mask=00004000/00400000
  r8169 0000:01:00.0: AER:    [14] CmpltTO                (First)
  r8169 0000:01:00.0: AER: can't recover (no error_detected callback)
  pcieport 0000:00:02.0: AER: device recovery failed

After that, the ethernet NIC is not functional anymore even after
reloading the r8169 module. After a reboot, this is reproducible by
copying a large file over the NIC to the MMC.

For some reason this is not reproducible when files are copied to a tmpfs.

* Little background on the fixup, by Manikanta Maddireddy:
  "In the internal testing with dGPU on Tegra124, CmplTO is reported by
dGPU. This happened because FIFO queue in AFI(AXI to PCIe) module
get full by upstream posted writes. Back to back upstream writes
interleaved with infrequent reads, triggers RAW violation and CmpltTO.
This is fixed by reducing the posted write credits and by changing
updateFC timer frequency. These settings are fixed after stress test.

In the current case, RTL NIC is also reporting CmplTO. These settings
seems to be aggravating the issue instead of fixing it."

Link: https://lore.kernel.org/r/20200718100710.15398-1-kwizart@gmail.com
Fixes: 191cd6fb5d2c ("PCI: tegra: Add SW fixup for RAW violations")
Signed-off-by: Nicolas Chauvet <kwizart@gmail.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Manikanta Maddireddy <mmaddireddy@nvidia.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/controller/pci-tegra.c |   32 --------------------------------
 1 file changed, 32 deletions(-)

--- a/drivers/pci/controller/pci-tegra.c
+++ b/drivers/pci/controller/pci-tegra.c
@@ -181,13 +181,6 @@
 
 #define AFI_PEXBIAS_CTRL_0		0x168
 
-#define RP_PRIV_XP_DL		0x00000494
-#define  RP_PRIV_XP_DL_GEN2_UPD_FC_TSHOLD	(0x1ff << 1)
-
-#define RP_RX_HDR_LIMIT		0x00000e00
-#define  RP_RX_HDR_LIMIT_PW_MASK	(0xff << 8)
-#define  RP_RX_HDR_LIMIT_PW		(0x0e << 8)
-
 #define RP_ECTL_2_R1	0x00000e84
 #define  RP_ECTL_2_R1_RX_CTLE_1C_MASK		0xffff
 
@@ -323,7 +316,6 @@ struct tegra_pcie_soc {
 	bool program_uphy;
 	bool update_clamp_threshold;
 	bool program_deskew_time;
-	bool raw_violation_fixup;
 	bool update_fc_timer;
 	bool has_cache_bars;
 	struct {
@@ -659,23 +651,6 @@ static void tegra_pcie_apply_sw_fixup(st
 		writel(value, port->base + RP_VEND_CTL0);
 	}
 
-	/* Fixup for read after write violation. */
-	if (soc->raw_violation_fixup) {
-		value = readl(port->base + RP_RX_HDR_LIMIT);
-		value &= ~RP_RX_HDR_LIMIT_PW_MASK;
-		value |= RP_RX_HDR_LIMIT_PW;
-		writel(value, port->base + RP_RX_HDR_LIMIT);
-
-		value = readl(port->base + RP_PRIV_XP_DL);
-		value |= RP_PRIV_XP_DL_GEN2_UPD_FC_TSHOLD;
-		writel(value, port->base + RP_PRIV_XP_DL);
-
-		value = readl(port->base + RP_VEND_XP);
-		value &= ~RP_VEND_XP_UPDATE_FC_THRESHOLD_MASK;
-		value |= soc->update_fc_threshold;
-		writel(value, port->base + RP_VEND_XP);
-	}
-
 	if (soc->update_fc_timer) {
 		value = readl(port->base + RP_VEND_XP);
 		value &= ~RP_VEND_XP_UPDATE_FC_THRESHOLD_MASK;
@@ -2416,7 +2391,6 @@ static const struct tegra_pcie_soc tegra
 	.program_uphy = true,
 	.update_clamp_threshold = false,
 	.program_deskew_time = false,
-	.raw_violation_fixup = false,
 	.update_fc_timer = false,
 	.has_cache_bars = true,
 	.ectl.enable = false,
@@ -2446,7 +2420,6 @@ static const struct tegra_pcie_soc tegra
 	.program_uphy = true,
 	.update_clamp_threshold = false,
 	.program_deskew_time = false,
-	.raw_violation_fixup = false,
 	.update_fc_timer = false,
 	.has_cache_bars = false,
 	.ectl.enable = false,
@@ -2459,8 +2432,6 @@ static const struct tegra_pcie_soc tegra
 	.pads_pll_ctl = PADS_PLL_CTL_TEGRA30,
 	.tx_ref_sel = PADS_PLL_CTL_TXCLKREF_BUF_EN,
 	.pads_refclk_cfg0 = 0x44ac44ac,
-	/* FC threshold is bit[25:18] */
-	.update_fc_threshold = 0x03fc0000,
 	.has_pex_clkreq_en = true,
 	.has_pex_bias_ctrl = true,
 	.has_intr_prsnt_sense = true,
@@ -2470,7 +2441,6 @@ static const struct tegra_pcie_soc tegra
 	.program_uphy = true,
 	.update_clamp_threshold = true,
 	.program_deskew_time = false,
-	.raw_violation_fixup = true,
 	.update_fc_timer = false,
 	.has_cache_bars = false,
 	.ectl.enable = false,
@@ -2494,7 +2464,6 @@ static const struct tegra_pcie_soc tegra
 	.program_uphy = true,
 	.update_clamp_threshold = true,
 	.program_deskew_time = true,
-	.raw_violation_fixup = false,
 	.update_fc_timer = true,
 	.has_cache_bars = false,
 	.ectl = {
@@ -2536,7 +2505,6 @@ static const struct tegra_pcie_soc tegra
 	.program_uphy = false,
 	.update_clamp_threshold = false,
 	.program_deskew_time = false,
-	.raw_violation_fixup = false,
 	.update_fc_timer = false,
 	.has_cache_bars = false,
 	.ectl.enable = false,


