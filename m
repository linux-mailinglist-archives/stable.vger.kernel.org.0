Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 022811014E3
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729774AbfKSFi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:38:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:60458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729706AbfKSFi0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:38:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF79B21783;
        Tue, 19 Nov 2019 05:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141906;
        bh=lEQzvuo/J49Mv9aF5nepvQGDuy/fag8KPX8/WX6w/8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vDl3LD0dib2NF9X6zgTPcViyEmsxQ1KywVMgdqDutbCK8HgjJYdncgjRHd8qpkLRY
         MRtWbafYY0IKD5j+mtVQQiEdmhS6/NIUIcEhWuB1ZNW6hOdwB0tljRzqJnN8RdQJNx
         n78FiBGflNPBOWFDJqrg8oQGPYlXDRpc+bk7U4C8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
        Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@suse.de>,
        Aristeu Rozanski <aris@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-edac@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 322/422] EDAC: Correct DIMM capacity unit symbol
Date:   Tue, 19 Nov 2019 06:18:39 +0100
Message-Id: <20191119051419.862928802@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7447f1453200d..53074ad361e58 100644
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
 
@@ -424,7 +424,7 @@ unknown_size:
 	dimm->mtype = MEM_NVDIMM;
 	dimm->edac_mode = EDAC_SECDED; /* likely better than this */
 
-	edac_dbg(0, "mc#%d: channel %d, dimm %d, %llu Mb (%u pages)\n",
+	edac_dbg(0, "mc#%d: channel %d, dimm %d, %llu MiB (%u pages)\n",
 		 imc->mc, chan, dimmno, size >> 20, dimm->nr_pages);
 
 	snprintf(dimm->label, sizeof(dimm->label), "CPU_SrcID#%u_MC#%u_Chan#%u_DIMM#%u",
-- 
2.20.1



