Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918AC328AE8
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234822AbhCASZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:25:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:39682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239357AbhCASTJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:19:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AFF66520B;
        Mon,  1 Mar 2021 17:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619326;
        bh=cuH7aAYOZaYAQgG1PzHdVOOD6HC21+jin1SqcQACh8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CJPdT2VfRy+nRU7v3jmu9WCkI9YFgiSW9qABy8foEfD8iDAXp4I3kgIDJvTIFnhEc
         cMtBPE48KyR2aN4jSYOiKroVd6uJ9tt5MuXFReRQ0tdCOA5ybhReYrHTOA2y3wf1uh
         khQvDNoTizGeje0pyq5U/hFtFlOvLVFBfSvCCo/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 414/663] vfio/iommu_type1: Populate full dirty when detach non-pinned group
Date:   Mon,  1 Mar 2021 17:11:02 +0100
Message-Id: <20210301161202.359213278@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keqian Zhu <zhukeqian1@huawei.com>

[ Upstream commit d0a78f91761fcd837da1e7a4b0f8368873adc646 ]

If a group with non-pinned-page dirty scope is detached with dirty
logging enabled, we should fully populate the dirty bitmaps at the
time it's removed since we don't know the extent of its previous DMA,
nor will the group be present to trigger the full bitmap when the user
retrieves the dirty bitmap.

Fixes: d6a4c185660c ("vfio iommu: Implementation of ioctl for dirty pages tracking")
Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio_iommu_type1.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 67e8276389951..a08b2cb4ec66e 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -236,6 +236,18 @@ static void vfio_dma_populate_bitmap(struct vfio_dma *dma, size_t pgsize)
 	}
 }
 
+static void vfio_iommu_populate_bitmap_full(struct vfio_iommu *iommu)
+{
+	struct rb_node *n;
+	unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
+
+	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
+		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
+
+		bitmap_set(dma->bitmap, 0, dma->size >> pgshift);
+	}
+}
+
 static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu, size_t pgsize)
 {
 	struct rb_node *n;
@@ -2415,8 +2427,11 @@ detach_group_done:
 	 * Removal of a group without dirty tracking may allow the iommu scope
 	 * to be promoted.
 	 */
-	if (update_dirty_scope)
+	if (update_dirty_scope) {
 		update_pinned_page_dirty_scope(iommu);
+		if (iommu->dirty_page_tracking)
+			vfio_iommu_populate_bitmap_full(iommu);
+	}
 	mutex_unlock(&iommu->lock);
 }
 
-- 
2.27.0



