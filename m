Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6659429BF7B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1815444AbgJ0RCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:02:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1793757AbgJ0PIJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:08:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E9372072E;
        Tue, 27 Oct 2020 15:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811289;
        bh=4vcFbVa/Vybn0zQxlqjW4uGB44G7cOGwTI67CNqHscM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zvb//mUWPg7tf2+ObeqrYYIR7hI/bRZuyz0sgUBEqiuI0sgsffqAeuTC2rFiUrU/l
         pVc1a1T566cooE8oXtixzjfo2ekjjZKRR3WIcTe19g99xK9bxN8B+VxPD2E/TzjcKp
         hzYV/sruO2x/Ek4L2KCc7XzFBkwllzcSS2PZ43vU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 440/633] vfio/type1: fix dirty bitmap calculation in vfio_dma_rw
Date:   Tue, 27 Oct 2020 14:53:03 +0100
Message-Id: <20201027135543.365492736@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yan Zhao <yan.y.zhao@intel.com>

[ Upstream commit 2c5af98592f65517170c7bcc714566590d3f7397 ]

The count of dirtied pages is not only determined by count of copied
pages, but also by the start offset.

e.g. if offset = PAGE_SIZE - 1, and *copied=2, the dirty pages count
is 2, instead of 1 or 0.

Fixes: d6a4c185660c ("vfio iommu: Implementation of ioctl for dirty pages tracking")
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio_iommu_type1.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index f48f0db908a46..eb7bb14e4f62a 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2899,7 +2899,8 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
 			 * size
 			 */
 			bitmap_set(dma->bitmap, offset >> pgshift,
-				   *copied >> pgshift);
+				   ((offset + *copied - 1) >> pgshift) -
+				   (offset >> pgshift) + 1);
 		}
 	} else
 		*copied = copy_from_user(data, (void __user *)vaddr,
-- 
2.25.1



