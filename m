Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D56C49A3E3
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369114AbiAYAA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584585AbiAXXSO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:18:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16ABFC07E28A;
        Mon, 24 Jan 2022 11:44:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA8DE61554;
        Mon, 24 Jan 2022 19:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E67C340E5;
        Mon, 24 Jan 2022 19:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053470;
        bh=4nEF6vs37MRNU+7bIdqhL7iZYdxIXNA2Bc+gWhM3i0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KFywy1OsKymUSsCEd3KQY/9tjWJHvDyAIlnJTrsSgDoIVEgjLgPYuCusFvikENExL
         QOQPPdtKSXeK+te8fqGnTbmy+AiB8iDOylJQ5mkkuYKlN+zZiQ0giHaFljDgJMotCQ
         tk2+23Ik2qkQcGZp8IJ+ytz/wophWDyiMvxju7Dk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunfei Wang <yf.wang@mediatek.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.10 033/563] iommu/io-pgtable-arm-v7s: Add error handle for page table allocation failure
Date:   Mon, 24 Jan 2022 19:36:38 +0100
Message-Id: <20220124184025.573063034@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunfei Wang <yf.wang@mediatek.com>

commit a556cfe4cabc6d79cbb7733f118bbb420b376fe6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/io-pgtable-arm-v7s.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/iommu/io-pgtable-arm-v7s.c
+++ b/drivers/iommu/io-pgtable-arm-v7s.c
@@ -242,13 +242,17 @@ static void *__arm_v7s_alloc_table(int l
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


