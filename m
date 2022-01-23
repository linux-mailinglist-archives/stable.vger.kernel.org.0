Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA80497218
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 15:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236739AbiAWO1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 09:27:04 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38218 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbiAWO1D (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 09:27:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 358C760C97
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 14:27:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F04C340E2;
        Sun, 23 Jan 2022 14:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642948022;
        bh=CryLZgtNLA3uaSi8CLhM3YSaoMNYzfw24c9eByNvaBY=;
        h=Subject:To:Cc:From:Date:From;
        b=eLQn8VLD+HK0lt73Mpa7VY0zPaLjs3PphXgcnuKGOQL0K+YCi95OD0zm2jVNd1A9d
         HAoUZRtvzNCj4lO6Ju2V0uYiXuKIO44rQ5ZBLCQsd2epEve3cEmmt+4d3GnHNiktTg
         FvHJ2RZF9zzw56uOcakV5i0UdwykRkpwWdLcS3Po=
Subject: FAILED: patch "[PATCH] iommu/io-pgtable-arm-v7s: Add error handle for page table" failed to apply to 4.19-stable tree
To:     yf.wang@mediatek.com, robin.murphy@arm.com, stable@vger.kernel.org,
        will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 15:26:51 +0100
Message-ID: <1642948011227141@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From a556cfe4cabc6d79cbb7733f118bbb420b376fe6 Mon Sep 17 00:00:00 2001
From: Yunfei Wang <yf.wang@mediatek.com>
Date: Tue, 7 Dec 2021 19:33:15 +0800
Subject: [PATCH] iommu/io-pgtable-arm-v7s: Add error handle for page table
 allocation failure

In __arm_v7s_alloc_table function:
iommu call kmem_cache_alloc to allocate page table, this function
allocate memory may fail, when kmem_cache_alloc fails to allocate
table, call virt_to_phys will be abnomal and return unexpected phys
and goto out_free, then call kmem_cache_free to release table will
trigger KE, __get_free_pages and free_pages have similar problem,
so add error handle for page table allocation failure.

Fixes: 29859aeb8a6e ("iommu/io-pgtable-arm-v7s: Abort allocation when table address overflows the PTE")
Signed-off-by: Yunfei Wang <yf.wang@mediatek.com>
Cc: <stable@vger.kernel.org> # 5.10.*
Acked-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/20211207113315.29109-1-yf.wang@mediatek.com
Signed-off-by: Will Deacon <will@kernel.org>

diff --git a/drivers/iommu/io-pgtable-arm-v7s.c b/drivers/iommu/io-pgtable-arm-v7s.c
index bfb6acb651e5..be066c1503d3 100644
--- a/drivers/iommu/io-pgtable-arm-v7s.c
+++ b/drivers/iommu/io-pgtable-arm-v7s.c
@@ -246,13 +246,17 @@ static void *__arm_v7s_alloc_table(int lvl, gfp_t gfp,
 			__GFP_ZERO | ARM_V7S_TABLE_GFP_DMA, get_order(size));
 	else if (lvl == 2)
 		table = kmem_cache_zalloc(data->l2_tables, gfp);
+
+	if (!table)
+		return NULL;
+
 	phys = virt_to_phys(table);
 	if (phys != (arm_v7s_iopte)phys) {
 		/* Doesn't fit in PTE */
 		dev_err(dev, "Page table does not fit in PTE: %pa", &phys);
 		goto out_free;
 	}
-	if (table && !cfg->coherent_walk) {
+	if (!cfg->coherent_walk) {
 		dma = dma_map_single(dev, table, size, DMA_TO_DEVICE);
 		if (dma_mapping_error(dev, dma))
 			goto out_free;

