Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E593290BE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238677AbhCAUOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:14:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:35800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242686AbhCAUDP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:03:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08CC46539A;
        Mon,  1 Mar 2021 17:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621480;
        bh=138niFgcTp3Q5a3I0xP9sHnjfEsADdFrgU6I8A0YXYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QUV6YXC+wSI/lg8LUxaXx+3veSmU8LHZDRbE3DdyTBSQ8Ig/cIsyomlueFiGMngaj
         J5A6krGx0T8hmEkOd2oJPYPc62apOYKlFxHzZc+Lz4j373igts4FBZzaGWTlv1COAo
         a7MWgEZwKPA/ex3gf2D97xm8AyGy0c+7PlKRYqM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 500/775] vfio/iommu_type1: Populate full dirty when detach non-pinned group
Date:   Mon,  1 Mar 2021 17:11:08 +0100
Message-Id: <20210301161226.223358715@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index 0b4dedaa91289..161725395f2fb 100644
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



