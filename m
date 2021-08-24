Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84A9E3F6415
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235895AbhHXRAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:00:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238912AbhHXQ7M (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:59:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DDB7611AF;
        Tue, 24 Aug 2021 16:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824252;
        bh=oE9uR7V4OH3XiW1tDEuMmOgRU8YCLANasm1e6deDn3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hylBdZKYVWfY6xXo8fYncrevYHaN/7ssXQMN9PIIRjv29zX0XRvYCB2NAQjSpKOfw
         Tz6uceUYPBxfvbSglJ/qS1ZMGyMKh28T7Oj9UzTvOLUkE5YIWLA8V85Cxd/TxATG8b
         YzIPDfn3GVkwlpwjTsoUV6XpfEhFp3tHznO0b+jH4RX9bu2wCoiUrLH36p5n1xhuWO
         7QkQvihSBv9olfGvDP79HgS+P5vxjYv89tnYkkUAUC7L9C++/4DbzTjl8PWpJ1xchL
         jVxHsWnr2MXu3raPFpai24+Nfdwb1zOUDB6wnGikv+WycOQYehfCM58mDqqEX0GWzq
         t9ylvY9CcMj3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ezequiel Garcia <ezequiel@collabora.com>,
        Christoph Hellwig <hch@lst.de>, Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 085/127] iommu/dma: Fix leak in non-contiguous API
Date:   Tue, 24 Aug 2021 12:55:25 -0400
Message-Id: <20210824165607.709387-86-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ezequiel Garcia <ezequiel@collabora.com>

[ Upstream commit 0fbea680540108b09db7b26d9f4d24236d58a6ad ]

Currently, iommu_dma_alloc_noncontiguous() allocates a
struct dma_sgt_handle object to hold some state needed for
iommu_dma_free_noncontiguous().

However, the handle is neither freed nor returned explicitly by
the ->alloc_noncontiguous method, and therefore seems leaked.
This was found by code inspection, so please review carefully and test.

As a side note, it appears the struct dma_sgt_handle type is exposed
to users of the DMA-API by linux/dma-map-ops.h, but is has no users
or functions returning the type explicitly.

This may indicate it's a good idea to move the struct dma_sgt_handle type
to drivers/iommu/dma-iommu.c. The decision is left to maintainers :-)

Cc: stable@vger.kernel.org
Fixes: e817ee5f2f95c ("dma-iommu: implement ->alloc_noncontiguous")
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20210723010552.50969-1-ezequiel@collabora.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/dma-iommu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 5d96fcc45fec..698707699327 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -768,6 +768,7 @@ static void iommu_dma_free_noncontiguous(struct device *dev, size_t size,
 	__iommu_dma_unmap(dev, sgt->sgl->dma_address, size);
 	__iommu_dma_free_pages(sh->pages, PAGE_ALIGN(size) >> PAGE_SHIFT);
 	sg_free_table(&sh->sgt);
+	kfree(sh);
 }
 #endif /* CONFIG_DMA_REMAP */
 
-- 
2.30.2

