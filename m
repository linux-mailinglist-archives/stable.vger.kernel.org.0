Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 178F1BA6B0
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729202AbfIVSwW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:52:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726828AbfIVSwV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:52:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45ED421479;
        Sun, 22 Sep 2019 18:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178340;
        bh=aF29muMYd0aFbQLCZ8bnN7wOIqz7jZ7RkN0z5SAUhJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bK6w6rbsHZ8UTdYORUbbAjUBLiZbZhYy3gMCwHvXyWeLgOhfHsoEzP9EDXsdn5W3S
         +nBMVVWX8W253Jq7zsk51niD4cnSuH56o2dGjPJ58ix/AE5ATSvPZU5qgdOa3Oc+pe
         uD5LYHQtQYyjMJR8e15jF5+RBvZpMXvW1cRfVsSs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yazen Ghannam <yazen.ghannam@amd.com>,
        Borislav Petkov <bp@suse.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        James Morse <james.morse@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 101/185] EDAC/amd64: Support more than two controllers for chip selects handling
Date:   Sun, 22 Sep 2019 14:47:59 -0400
Message-Id: <20190922184924.32534-101-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yazen Ghannam <yazen.ghannam@amd.com>

[ Upstream commit d971e28e2ce4696fcc32998c8aced5e47701fffe ]

The struct chip_select array that's used for saving chip select bases
and masks is fixed at length of two. There should be one struct
chip_select for each controller, so this array should be increased to
support systems that may have more than two controllers.

Increase the size of the struct chip_select array to eight, which is the
largest number of controllers per die currently supported on AMD
systems.

Fix number of DIMMs and Chip Select bases/masks on Family17h, because
AMD Family 17h systems support 2 DIMMs, 4 CS bases, and 2 CS masks per
channel.

Also, carve out the Family 17h+ reading of the bases/masks into a
separate function. This effectively reverts the original bases/masks
reading code to before Family 17h support was added.

Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Link: https://lkml.kernel.org/r/20190821235938.118710-2-Yazen.Ghannam@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/amd64_edac.c | 123 +++++++++++++++++++++-----------------
 drivers/edac/amd64_edac.h |   5 +-
 2 files changed, 71 insertions(+), 57 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 873437be86d9c..dd60cf5a3d969 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -810,7 +810,7 @@ static void debug_display_dimm_sizes_df(struct amd64_pvt *pvt, u8 ctrl)
 
 	edac_printk(KERN_DEBUG, EDAC_MC, "UMC%d chip selects:\n", ctrl);
 
-	for (dimm = 0; dimm < 4; dimm++) {
+	for (dimm = 0; dimm < 2; dimm++) {
 		size0 = 0;
 		cs0 = dimm * 2;
 
@@ -942,89 +942,102 @@ static void prep_chip_selects(struct amd64_pvt *pvt)
 	} else if (pvt->fam == 0x15 && pvt->model == 0x30) {
 		pvt->csels[0].b_cnt = pvt->csels[1].b_cnt = 4;
 		pvt->csels[0].m_cnt = pvt->csels[1].m_cnt = 2;
+	} else if (pvt->fam >= 0x17) {
+		int umc;
+
+		for_each_umc(umc) {
+			pvt->csels[umc].b_cnt = 4;
+			pvt->csels[umc].m_cnt = 2;
+		}
+
 	} else {
 		pvt->csels[0].b_cnt = pvt->csels[1].b_cnt = 8;
 		pvt->csels[0].m_cnt = pvt->csels[1].m_cnt = 4;
 	}
 }
 
+static void read_umc_base_mask(struct amd64_pvt *pvt)
+{
+	u32 umc_base_reg, umc_mask_reg;
+	u32 base_reg, mask_reg;
+	u32 *base, *mask;
+	int cs, umc;
+
+	for_each_umc(umc) {
+		umc_base_reg = get_umc_base(umc) + UMCCH_BASE_ADDR;
+
+		for_each_chip_select(cs, umc, pvt) {
+			base = &pvt->csels[umc].csbases[cs];
+
+			base_reg = umc_base_reg + (cs * 4);
+
+			if (!amd_smn_read(pvt->mc_node_id, base_reg, base))
+				edac_dbg(0, "  DCSB%d[%d]=0x%08x reg: 0x%x\n",
+					 umc, cs, *base, base_reg);
+		}
+
+		umc_mask_reg = get_umc_base(umc) + UMCCH_ADDR_MASK;
+
+		for_each_chip_select_mask(cs, umc, pvt) {
+			mask = &pvt->csels[umc].csmasks[cs];
+
+			mask_reg = umc_mask_reg + (cs * 4);
+
+			if (!amd_smn_read(pvt->mc_node_id, mask_reg, mask))
+				edac_dbg(0, "  DCSM%d[%d]=0x%08x reg: 0x%x\n",
+					 umc, cs, *mask, mask_reg);
+		}
+	}
+}
+
 /*
  * Function 2 Offset F10_DCSB0; read in the DCS Base and DCS Mask registers
  */
 static void read_dct_base_mask(struct amd64_pvt *pvt)
 {
-	int base_reg0, base_reg1, mask_reg0, mask_reg1, cs;
+	int cs;
 
 	prep_chip_selects(pvt);
 
-	if (pvt->umc) {
-		base_reg0 = get_umc_base(0) + UMCCH_BASE_ADDR;
-		base_reg1 = get_umc_base(1) + UMCCH_BASE_ADDR;
-		mask_reg0 = get_umc_base(0) + UMCCH_ADDR_MASK;
-		mask_reg1 = get_umc_base(1) + UMCCH_ADDR_MASK;
-	} else {
-		base_reg0 = DCSB0;
-		base_reg1 = DCSB1;
-		mask_reg0 = DCSM0;
-		mask_reg1 = DCSM1;
-	}
+	if (pvt->umc)
+		return read_umc_base_mask(pvt);
 
 	for_each_chip_select(cs, 0, pvt) {
-		int reg0   = base_reg0 + (cs * 4);
-		int reg1   = base_reg1 + (cs * 4);
+		int reg0   = DCSB0 + (cs * 4);
+		int reg1   = DCSB1 + (cs * 4);
 		u32 *base0 = &pvt->csels[0].csbases[cs];
 		u32 *base1 = &pvt->csels[1].csbases[cs];
 
-		if (pvt->umc) {
-			if (!amd_smn_read(pvt->mc_node_id, reg0, base0))
-				edac_dbg(0, "  DCSB0[%d]=0x%08x reg: 0x%x\n",
-					 cs, *base0, reg0);
-
-			if (!amd_smn_read(pvt->mc_node_id, reg1, base1))
-				edac_dbg(0, "  DCSB1[%d]=0x%08x reg: 0x%x\n",
-					 cs, *base1, reg1);
-		} else {
-			if (!amd64_read_dct_pci_cfg(pvt, 0, reg0, base0))
-				edac_dbg(0, "  DCSB0[%d]=0x%08x reg: F2x%x\n",
-					 cs, *base0, reg0);
+		if (!amd64_read_dct_pci_cfg(pvt, 0, reg0, base0))
+			edac_dbg(0, "  DCSB0[%d]=0x%08x reg: F2x%x\n",
+				 cs, *base0, reg0);
 
-			if (pvt->fam == 0xf)
-				continue;
+		if (pvt->fam == 0xf)
+			continue;
 
-			if (!amd64_read_dct_pci_cfg(pvt, 1, reg0, base1))
-				edac_dbg(0, "  DCSB1[%d]=0x%08x reg: F2x%x\n",
-					 cs, *base1, (pvt->fam == 0x10) ? reg1
-								: reg0);
-		}
+		if (!amd64_read_dct_pci_cfg(pvt, 1, reg0, base1))
+			edac_dbg(0, "  DCSB1[%d]=0x%08x reg: F2x%x\n",
+				 cs, *base1, (pvt->fam == 0x10) ? reg1
+							: reg0);
 	}
 
 	for_each_chip_select_mask(cs, 0, pvt) {
-		int reg0   = mask_reg0 + (cs * 4);
-		int reg1   = mask_reg1 + (cs * 4);
+		int reg0   = DCSM0 + (cs * 4);
+		int reg1   = DCSM1 + (cs * 4);
 		u32 *mask0 = &pvt->csels[0].csmasks[cs];
 		u32 *mask1 = &pvt->csels[1].csmasks[cs];
 
-		if (pvt->umc) {
-			if (!amd_smn_read(pvt->mc_node_id, reg0, mask0))
-				edac_dbg(0, "    DCSM0[%d]=0x%08x reg: 0x%x\n",
-					 cs, *mask0, reg0);
-
-			if (!amd_smn_read(pvt->mc_node_id, reg1, mask1))
-				edac_dbg(0, "    DCSM1[%d]=0x%08x reg: 0x%x\n",
-					 cs, *mask1, reg1);
-		} else {
-			if (!amd64_read_dct_pci_cfg(pvt, 0, reg0, mask0))
-				edac_dbg(0, "    DCSM0[%d]=0x%08x reg: F2x%x\n",
-					 cs, *mask0, reg0);
+		if (!amd64_read_dct_pci_cfg(pvt, 0, reg0, mask0))
+			edac_dbg(0, "    DCSM0[%d]=0x%08x reg: F2x%x\n",
+				 cs, *mask0, reg0);
 
-			if (pvt->fam == 0xf)
-				continue;
+		if (pvt->fam == 0xf)
+			continue;
 
-			if (!amd64_read_dct_pci_cfg(pvt, 1, reg0, mask1))
-				edac_dbg(0, "    DCSM1[%d]=0x%08x reg: F2x%x\n",
-					 cs, *mask1, (pvt->fam == 0x10) ? reg1
-								: reg0);
-		}
+		if (!amd64_read_dct_pci_cfg(pvt, 1, reg0, mask1))
+			edac_dbg(0, "    DCSM1[%d]=0x%08x reg: F2x%x\n",
+				 cs, *mask1, (pvt->fam == 0x10) ? reg1
+							: reg0);
 	}
 }
 
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 8f66472f7adc2..4dce6a2ac75f9 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -96,6 +96,7 @@
 /* Hardware limit on ChipSelect rows per MC and processors per system */
 #define NUM_CHIPSELECTS			8
 #define DRAM_RANGES			8
+#define NUM_CONTROLLERS			8
 
 #define ON true
 #define OFF false
@@ -351,8 +352,8 @@ struct amd64_pvt {
 	u32 dbam0;		/* DRAM Base Address Mapping reg for DCT0 */
 	u32 dbam1;		/* DRAM Base Address Mapping reg for DCT1 */
 
-	/* one for each DCT */
-	struct chip_select csels[2];
+	/* one for each DCT/UMC */
+	struct chip_select csels[NUM_CONTROLLERS];
 
 	/* DRAM base and limit pairs F1x[78,70,68,60,58,50,48,40] */
 	struct dram_range ranges[DRAM_RANGES];
-- 
2.20.1

