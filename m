Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80100259690
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgIAPlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:41:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728446AbgIAPlt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:41:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86D442078B;
        Tue,  1 Sep 2020 15:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974909;
        bh=AAuVh8NhIbqqWMMFxEOADh7bUSWjy+xTniY3cUJ+4Rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vAhVWlnHPHa9CDx0/oVwX8zAYS2EENJECX5ODG+gHHo0allEnBWIQTR5pW+d+ncNP
         zjx4xSBxk0ovJF0gbQ0gUfWIdtOr0+D3adyhW7HPbOll2iQNapX5RBCJYgvKHBLXRW
         pL3Ty0hHzKS9MaHrpBpW9sIZBSsAMUHa8B1YIpbE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 136/255] dma-pool: Only allocate from CMA when in same memory zone
Date:   Tue,  1 Sep 2020 17:09:52 +0200
Message-Id: <20200901151007.230785391@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

[ Upstream commit d7e673ec2c8e0ea39c4c70fc490d67d7fbda869d ]

There is no guarantee to CMA's placement, so allocating a zone specific
atomic pool from CMA might return memory from a completely different
memory zone. To get around this double check CMA's placement before
allocating from it.

Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/pool.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
index 5d071d4a3cbaa..06582b488e317 100644
--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -3,7 +3,9 @@
  * Copyright (C) 2012 ARM Ltd.
  * Copyright (C) 2020 Google LLC
  */
+#include <linux/cma.h>
 #include <linux/debugfs.h>
+#include <linux/dma-contiguous.h>
 #include <linux/dma-direct.h>
 #include <linux/dma-noncoherent.h>
 #include <linux/init.h>
@@ -55,6 +57,29 @@ static void dma_atomic_pool_size_add(gfp_t gfp, size_t size)
 		pool_size_kernel += size;
 }
 
+static bool cma_in_zone(gfp_t gfp)
+{
+	unsigned long size;
+	phys_addr_t end;
+	struct cma *cma;
+
+	cma = dev_get_cma_area(NULL);
+	if (!cma)
+		return false;
+
+	size = cma_get_size(cma);
+	if (!size)
+		return false;
+
+	/* CMA can't cross zone boundaries, see cma_activate_area() */
+	end = cma_get_base(cma) + size - 1;
+	if (IS_ENABLED(CONFIG_ZONE_DMA) && (gfp & GFP_DMA))
+		return end <= DMA_BIT_MASK(zone_dma_bits);
+	if (IS_ENABLED(CONFIG_ZONE_DMA32) && (gfp & GFP_DMA32))
+		return end <= DMA_BIT_MASK(32);
+	return true;
+}
+
 static int atomic_pool_expand(struct gen_pool *pool, size_t pool_size,
 			      gfp_t gfp)
 {
@@ -68,7 +93,11 @@ static int atomic_pool_expand(struct gen_pool *pool, size_t pool_size,
 
 	do {
 		pool_size = 1 << (PAGE_SHIFT + order);
-		page = alloc_pages(gfp, order);
+		if (cma_in_zone(gfp))
+			page = dma_alloc_from_contiguous(NULL, 1 << order,
+							 order, false);
+		if (!page)
+			page = alloc_pages(gfp, order);
 	} while (!page && order-- > 0);
 	if (!page)
 		goto out;
-- 
2.25.1



