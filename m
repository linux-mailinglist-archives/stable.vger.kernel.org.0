Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39CDBF626C
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbfKJCnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:43:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:40380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728149AbfKJCnG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:43:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A35121D7F;
        Sun, 10 Nov 2019 02:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353785;
        bh=8c60UcOuLaLaEMv9/jm2csBMtwnh7BkgFOxAkkxWLEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xba1LZ86fReb2h4TuaSd/TFnH6fNRBfU/7mLpVMtHJLGUR8KbD2W/GCCRJuRDCCw0
         zlwFkmEMOrtlhTOPuhHkwKLot3qRrCKeU2Yu+dkzgk8MygI4O9zm3khsWjQ/LbA21j
         4xw5YsdRxD/Ha3GQZNuBFPW1eDANvydCbPtShm5g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Aristeu Rozanski <aris@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-edac@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 088/191] EDAC: Correct DIMM capacity unit symbol
Date:   Sat,  9 Nov 2019 21:38:30 -0500
Message-Id: <20191110024013.29782-88-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit 6f6da136046294a1e8d2944336eb97412751f653 ]

The {i3200|i7core|sb|skx}_edac drivers show DIMM capacity using the
wrong unit symbol: 'Mb' - megabit. Fix them by replacing 'Mb' with
'MiB' - mebibyte.

[Tony: These are all "edac_dbg()" messages, so this won't break scripts
       that parse console logs.]

Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Aristeu Rozanski <aris@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-edac@vger.kernel.org
Link: https://lkml.kernel.org/r/20180919003433.16475-1-tony.luck@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/i3200_edac.c  | 2 +-
 drivers/edac/i7core_edac.c | 2 +-
 drivers/edac/sb_edac.c     | 2 +-
 drivers/edac/skx_edac.c    | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/edac/i3200_edac.c b/drivers/edac/i3200_edac.c
index d92d56cee1017..299b441647cd5 100644
--- a/drivers/edac/i3200_edac.c
+++ b/drivers/edac/i3200_edac.c
@@ -399,7 +399,7 @@ static int i3200_probe1(struct pci_dev *pdev, int dev_idx)
 			if (nr_pages == 0)
 				continue;
 
-			edac_dbg(0, "csrow %d, channel %d%s, size = %ld Mb\n", i, j,
+			edac_dbg(0, "csrow %d, channel %d%s, size = %ld MiB\n", i, j,
 				 stacked ? " (stacked)" : "", PAGES_TO_MiB(nr_pages));
 
 			dimm->nr_pages = nr_pages;
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index f1d19504a0281..4a3300c2da333 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -597,7 +597,7 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 			/* DDR3 has 8 I/O banks */
 			size = (rows * cols * banks * ranks) >> (20 - 3);
 
-			edac_dbg(0, "\tdimm %d %d Mb offset: %x, bank: %d, rank: %d, row: %#x, col: %#x\n",
+			edac_dbg(0, "\tdimm %d %d MiB offset: %x, bank: %d, rank: %d, row: %#x, col: %#x\n",
 				 j, size,
 				 RANKOFFSET(dimm_dod[j]),
 				 banks, ranks, rows, cols);
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 72cea3cb86224..acb9db55f5700 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -1622,7 +1622,7 @@ static int __populate_dimms(struct mem_ctl_info *mci,
 				size = ((u64)rows * cols * banks * ranks) >> (20 - 3);
 				npages = MiB_TO_PAGES(size);
 
-				edac_dbg(0, "mc#%d: ha %d channel %d, dimm %d, %lld Mb (%d pages) bank: %d, rank: %d, row: %#x, col: %#x\n",
+				edac_dbg(0, "mc#%d: ha %d channel %d, dimm %d, %lld MiB (%d pages) bank: %d, rank: %d, row: %#x, col: %#x\n",
 					 pvt->sbridge_dev->mc, pvt->sbridge_dev->dom, i, j,
 					 size, npages,
 					 banks, ranks, rows, cols);
diff --git a/drivers/edac/skx_edac.c b/drivers/edac/skx_edac.c
index 4ba92f1dd0f74..dd209e0dd9abb 100644
--- a/drivers/edac/skx_edac.c
+++ b/drivers/edac/skx_edac.c
@@ -364,7 +364,7 @@ static int get_dimm_info(u32 mtr, u32 amap, struct dimm_info *dimm,
 	size = ((1ull << (rows + cols + ranks)) * banks) >> (20 - 3);
 	npages = MiB_TO_PAGES(size);
 
-	edac_dbg(0, "mc#%d: channel %d, dimm %d, %lld Mb (%d pages) bank: %d, rank: %d, row: %#x, col: %#x\n",
+	edac_dbg(0, "mc#%d: channel %d, dimm %d, %lld MiB (%d pages) bank: %d, rank: %d, row: %#x, col: %#x\n",
 		 imc->mc, chan, dimmno, size, npages,
 		 banks, 1 << ranks, rows, cols);
 
@@ -424,7 +424,7 @@ static int get_nvdimm_info(struct dimm_info *dimm, struct skx_imc *imc,
 	dimm->mtype = MEM_NVDIMM;
 	dimm->edac_mode = EDAC_SECDED; /* likely better than this */
 
-	edac_dbg(0, "mc#%d: channel %d, dimm %d, %llu Mb (%u pages)\n",
+	edac_dbg(0, "mc#%d: channel %d, dimm %d, %llu MiB (%u pages)\n",
 		 imc->mc, chan, dimmno, size >> 20, dimm->nr_pages);
 
 	snprintf(dimm->label, sizeof(dimm->label), "CPU_SrcID#%u_MC#%u_Chan#%u_DIMM#%u",
-- 
2.20.1

