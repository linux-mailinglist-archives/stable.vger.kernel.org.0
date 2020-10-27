Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA2929BDAC
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1811942AbgJ0QoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:44:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801625AbgJ0Pm7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:42:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEA1820657;
        Tue, 27 Oct 2020 15:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813378;
        bh=7q/JQ6xcywKZCtNq0QDWAbIYsmYcN3Bk48T8RwPhRzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sIDDNp9elOoAbQx5WHcr51Lz2NBne+QeDqdr/OHUsfI0ZKs2cav90H9tdWBFxkVKm
         IHqSxmFOrJ4AxQrcT9YLhVJ1n4GdXt4QMTut7ldavIeaN6gb6H9Uoq6MdN4ET9WK+P
         NTBSqDyb+ZNd0REKbF4Kc/QsLB5pBH1i3WcrMKnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 531/757] vfio/type1: fix dirty bitmap calculation in vfio_dma_rw
Date:   Tue, 27 Oct 2020 14:53:01 +0100
Message-Id: <20201027135515.400930230@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
index 5fbf0c1f74338..d0438388feebe 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2933,7 +2933,8 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
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



