Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476221FBB13
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730712AbgFPQQg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 12:16:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:54266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731069AbgFPPkG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:40:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FB8B2145D;
        Tue, 16 Jun 2020 15:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322006;
        bh=vmYf8wrr+Mn8iTIgZUODDNK0UKmCF71dcWHs18fgZAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zaETHSQ9MrK6qr5u5zvvcwab5AaBNcQArNPxhjX2dK7D/IIhr5yeBTlqBMz2KeTuD
         46WPbCo7H9ZcSEX/SVJ2bAqHWqDphEOrU7ezBl9vR8oxzOnP4KquzNMU5TwS96iB5z
         yywEKSsTBRX26Y6akvU6hvPZEVuQAiJJcUVgBs88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
        Matthew Riley <mattdr@google.com>,
        Aristeu Rozanski <aris@redhat.com>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH 5.4 099/134] EDAC/skx: Use the mcmtr register to retrieve close_pg/bank_xor_enable
Date:   Tue, 16 Jun 2020 17:34:43 +0200
Message-Id: <20200616153105.527610945@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

commit 1032095053b34d474aa20f2625d97dd306e0991b upstream.

The skx_edac driver wrongly uses the mtr register to retrieve two fields
close_pg and bank_xor_enable. Fix it by using the correct mcmtr register
to get the two fields.

Cc: <stable@vger.kernel.org>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Reported-by: Matthew Riley <mattdr@google.com>
Acked-by: Aristeu Rozanski <aris@redhat.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/r/20200515210146.1337-1-tony.luck@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/edac/i10nm_base.c |    2 +-
 drivers/edac/skx_base.c   |   20 ++++++++------------
 drivers/edac/skx_common.c |    6 +++---
 drivers/edac/skx_common.h |    2 +-
 4 files changed, 13 insertions(+), 17 deletions(-)

--- a/drivers/edac/i10nm_base.c
+++ b/drivers/edac/i10nm_base.c
@@ -162,7 +162,7 @@ static int i10nm_get_dimm_config(struct
 				 mtr, mcddrtcfg, imc->mc, i, j);
 
 			if (IS_DIMM_PRESENT(mtr))
-				ndimms += skx_get_dimm_info(mtr, 0, dimm,
+				ndimms += skx_get_dimm_info(mtr, 0, 0, dimm,
 							    imc, i, j);
 			else if (IS_NVDIMM_PRESENT(mcddrtcfg, j))
 				ndimms += skx_get_nvdimm_info(dimm, imc, i, j,
--- a/drivers/edac/skx_base.c
+++ b/drivers/edac/skx_base.c
@@ -151,27 +151,23 @@ static const struct x86_cpu_id skx_cpuid
 };
 MODULE_DEVICE_TABLE(x86cpu, skx_cpuids);
 
-#define SKX_GET_MTMTR(dev, reg) \
-	pci_read_config_dword((dev), 0x87c, &(reg))
-
-static bool skx_check_ecc(struct pci_dev *pdev)
+static bool skx_check_ecc(u32 mcmtr)
 {
-	u32 mtmtr;
-
-	SKX_GET_MTMTR(pdev, mtmtr);
-
-	return !!GET_BITFIELD(mtmtr, 2, 2);
+	return !!GET_BITFIELD(mcmtr, 2, 2);
 }
 
 static int skx_get_dimm_config(struct mem_ctl_info *mci)
 {
 	struct skx_pvt *pvt = mci->pvt_info;
+	u32 mtr, mcmtr, amap, mcddrtcfg;
 	struct skx_imc *imc = pvt->imc;
-	u32 mtr, amap, mcddrtcfg;
 	struct dimm_info *dimm;
 	int i, j;
 	int ndimms;
 
+	/* Only the mcmtr on the first channel is effective */
+	pci_read_config_dword(imc->chan[0].cdev, 0x87c, &mcmtr);
+
 	for (i = 0; i < SKX_NUM_CHANNELS; i++) {
 		ndimms = 0;
 		pci_read_config_dword(imc->chan[i].cdev, 0x8C, &amap);
@@ -182,14 +178,14 @@ static int skx_get_dimm_config(struct me
 			pci_read_config_dword(imc->chan[i].cdev,
 					      0x80 + 4 * j, &mtr);
 			if (IS_DIMM_PRESENT(mtr)) {
-				ndimms += skx_get_dimm_info(mtr, amap, dimm, imc, i, j);
+				ndimms += skx_get_dimm_info(mtr, mcmtr, amap, dimm, imc, i, j);
 			} else if (IS_NVDIMM_PRESENT(mcddrtcfg, j)) {
 				ndimms += skx_get_nvdimm_info(dimm, imc, i, j,
 							      EDAC_MOD_STR);
 				nvdimm_count++;
 			}
 		}
-		if (ndimms && !skx_check_ecc(imc->chan[0].cdev)) {
+		if (ndimms && !skx_check_ecc(mcmtr)) {
 			skx_printk(KERN_ERR, "ECC is disabled on imc %d\n", imc->mc);
 			return -ENODEV;
 		}
--- a/drivers/edac/skx_common.c
+++ b/drivers/edac/skx_common.c
@@ -283,7 +283,7 @@ static int skx_get_dimm_attr(u32 reg, in
 #define numrow(reg)	skx_get_dimm_attr(reg, 2, 4, 12, 1, 6, "rows")
 #define numcol(reg)	skx_get_dimm_attr(reg, 0, 1, 10, 0, 2, "cols")
 
-int skx_get_dimm_info(u32 mtr, u32 amap, struct dimm_info *dimm,
+int skx_get_dimm_info(u32 mtr, u32 mcmtr, u32 amap, struct dimm_info *dimm,
 		      struct skx_imc *imc, int chan, int dimmno)
 {
 	int  banks = 16, ranks, rows, cols, npages;
@@ -303,8 +303,8 @@ int skx_get_dimm_info(u32 mtr, u32 amap,
 		 imc->mc, chan, dimmno, size, npages,
 		 banks, 1 << ranks, rows, cols);
 
-	imc->chan[chan].dimms[dimmno].close_pg = GET_BITFIELD(mtr, 0, 0);
-	imc->chan[chan].dimms[dimmno].bank_xor_enable = GET_BITFIELD(mtr, 9, 9);
+	imc->chan[chan].dimms[dimmno].close_pg = GET_BITFIELD(mcmtr, 0, 0);
+	imc->chan[chan].dimms[dimmno].bank_xor_enable = GET_BITFIELD(mcmtr, 9, 9);
 	imc->chan[chan].dimms[dimmno].fine_grain_bank = GET_BITFIELD(amap, 0, 0);
 	imc->chan[chan].dimms[dimmno].rowbits = rows;
 	imc->chan[chan].dimms[dimmno].colbits = cols;
--- a/drivers/edac/skx_common.h
+++ b/drivers/edac/skx_common.h
@@ -126,7 +126,7 @@ int skx_get_all_bus_mappings(unsigned in
 
 int skx_get_hi_lo(unsigned int did, int off[], u64 *tolm, u64 *tohm);
 
-int skx_get_dimm_info(u32 mtr, u32 amap, struct dimm_info *dimm,
+int skx_get_dimm_info(u32 mtr, u32 mcmtr, u32 amap, struct dimm_info *dimm,
 		      struct skx_imc *imc, int chan, int dimmno);
 
 int skx_get_nvdimm_info(struct dimm_info *dimm, struct skx_imc *imc,


