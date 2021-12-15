Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEE3475E86
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245309AbhLORWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:22:41 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43518 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245294AbhLORWk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:22:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F70F619E1;
        Wed, 15 Dec 2021 17:22:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9F5C36AE3;
        Wed, 15 Dec 2021 17:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639588959;
        bh=j1HcexReetMC3wT/dqAegjZV2JRPrsg7hWze3WxVraY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xywDw3pTo4hafSVGaA05fknYjYL6xQ7s64YhxNwQcEZb+psglRlW0KF8nGm9BNHcw
         Poelwq9fY9Bgn+es2zj5P5Z7pwpebvtGawGS/nPu+iYbtSSTpbiQb9JR7LMvsoIWlw
         Wn4lx9LOeGMLMG0MmeDulxFY3c5I1Bm5zN0etzgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 13/42] RDMA/irdma: Fix a potential memory allocation issue in irdma_prm_add_pble_mem()
Date:   Wed, 15 Dec 2021 18:20:54 +0100
Message-Id: <20211215172027.091182108@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172026.641863587@linuxfoundation.org>
References: <20211215172026.641863587@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 117697cc935b0ab04ec66274d8e64ccfebd7d0d2 ]

'pchunk->bitmapbuf' is a bitmap. Its size (in number of bits) is stored in
'pchunk->sizeofbitmap'.

When it is allocated, the size (in bytes) is computed by:
   size_in_bits >> 3

There are 2 issues (numbers bellow assume that longs are 64 bits):
   - there is no guarantee here that 'pchunk->bitmapmem.size' is modulo
     BITS_PER_LONG but bitmaps are stored as longs
     (sizeofbitmap=8 bits will only allocate 1 byte, instead of 8 (1 long))

   - the number of bytes is computed with a shift, not a round up, so we
     may allocate less memory than needed
     (sizeofbitmap=65 bits will only allocate 8 bytes (i.e. 1 long), when 2
     longs are needed = 16 bytes)

Fix both issues by using 'bitmap_zalloc()' and remove the useless
'bitmapmem' from 'struct irdma_chunk'.

While at it, remove some useless NULL test before calling
kfree/bitmap_free.

Fixes: 915cc7ac0f8e ("RDMA/irdma: Add miscellaneous utility definitions")
Link: https://lore.kernel.org/r/5e670b640508e14b1869c3e8e4fb970d78cbe997.1638692171.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/pble.c  | 6 ++----
 drivers/infiniband/hw/irdma/pble.h  | 1 -
 drivers/infiniband/hw/irdma/utils.c | 9 ++-------
 3 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/pble.c b/drivers/infiniband/hw/irdma/pble.c
index da032b952755e..fed49da770f3b 100644
--- a/drivers/infiniband/hw/irdma/pble.c
+++ b/drivers/infiniband/hw/irdma/pble.c
@@ -25,8 +25,7 @@ void irdma_destroy_pble_prm(struct irdma_hmc_pble_rsrc *pble_rsrc)
 		list_del(&chunk->list);
 		if (chunk->type == PBLE_SD_PAGED)
 			irdma_pble_free_paged_mem(chunk);
-		if (chunk->bitmapbuf)
-			kfree(chunk->bitmapmem.va);
+		bitmap_free(chunk->bitmapbuf);
 		kfree(chunk->chunkmem.va);
 	}
 }
@@ -299,8 +298,7 @@ add_pble_prm(struct irdma_hmc_pble_rsrc *pble_rsrc)
 	return 0;
 
 error:
-	if (chunk->bitmapbuf)
-		kfree(chunk->bitmapmem.va);
+	bitmap_free(chunk->bitmapbuf);
 	kfree(chunk->chunkmem.va);
 
 	return ret_code;
diff --git a/drivers/infiniband/hw/irdma/pble.h b/drivers/infiniband/hw/irdma/pble.h
index e1b3b8118a2ca..aa20827dcc9de 100644
--- a/drivers/infiniband/hw/irdma/pble.h
+++ b/drivers/infiniband/hw/irdma/pble.h
@@ -78,7 +78,6 @@ struct irdma_chunk {
 	u32 pg_cnt;
 	enum irdma_alloc_type type;
 	struct irdma_sc_dev *dev;
-	struct irdma_virt_mem bitmapmem;
 	struct irdma_virt_mem chunkmem;
 };
 
diff --git a/drivers/infiniband/hw/irdma/utils.c b/drivers/infiniband/hw/irdma/utils.c
index ac91ea5296db9..1bbf23689de48 100644
--- a/drivers/infiniband/hw/irdma/utils.c
+++ b/drivers/infiniband/hw/irdma/utils.c
@@ -2284,15 +2284,10 @@ enum irdma_status_code irdma_prm_add_pble_mem(struct irdma_pble_prm *pprm,
 
 	sizeofbitmap = (u64)pchunk->size >> pprm->pble_shift;
 
-	pchunk->bitmapmem.size = sizeofbitmap >> 3;
-	pchunk->bitmapmem.va = kzalloc(pchunk->bitmapmem.size, GFP_KERNEL);
-
-	if (!pchunk->bitmapmem.va)
+	pchunk->bitmapbuf = bitmap_zalloc(sizeofbitmap, GFP_KERNEL);
+	if (!pchunk->bitmapbuf)
 		return IRDMA_ERR_NO_MEMORY;
 
-	pchunk->bitmapbuf = pchunk->bitmapmem.va;
-	bitmap_zero(pchunk->bitmapbuf, sizeofbitmap);
-
 	pchunk->sizeofbitmap = sizeofbitmap;
 	/* each pble is 8 bytes hence shift by 3 */
 	pprm->total_pble_alloc += pchunk->size >> 3;
-- 
2.33.0



