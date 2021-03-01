Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAED3328925
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238930AbhCARvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:51:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:37380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234653AbhCARog (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:44:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5B8564FD0;
        Mon,  1 Mar 2021 16:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617867;
        bh=4UHRkePNas9cWOvVz8eVmlrTVkRlDREIIo6dIL8n2aU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=go2zL2p0MKflldgLu6ryHJkcE0fYy+dUhQF7jEWkgl3YiuG/r9OiWh3SqJWkLUmQD
         8z9uL895tOhLDYXW7dLhsgfV+jfJh4KMQ7g3mIKiukqk2VUy9Y34TaR+LKZvaH7QQB
         b1O0xUMVeSpo/Zbok+ZNoWvnBoJjCogN+ilHjdH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 223/340] vfio/type1: Use follow_pte()
Date:   Mon,  1 Mar 2021 17:12:47 +0100
Message-Id: <20210301161059.268477792@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Williamson <alex.williamson@redhat.com>

[ Upstream commit 07956b6269d3ed05d854233d5bb776dca91751dd ]

follow_pfn() doesn't make sure that we're using the correct page
protections, get the pte with follow_pte() so that we can test
protections and get the pfn from the pte.

Fixes: 5cbf3264bc71 ("vfio/type1: Fix VA->PA translation for PFNMAP VMAs in vaddr_get_pfn()")
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio_iommu_type1.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 9cbe058a530f0..6b1e8cba17984 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -24,6 +24,7 @@
 #include <linux/compat.h>
 #include <linux/device.h>
 #include <linux/fs.h>
+#include <linux/highmem.h>
 #include <linux/iommu.h>
 #include <linux/module.h>
 #include <linux/mm.h>
@@ -339,9 +340,11 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
 			    unsigned long vaddr, unsigned long *pfn,
 			    bool write_fault)
 {
+	pte_t *ptep;
+	spinlock_t *ptl;
 	int ret;
 
-	ret = follow_pfn(vma, vaddr, pfn);
+	ret = follow_pte(vma->vm_mm, vaddr, &ptep, &ptl);
 	if (ret) {
 		bool unlocked = false;
 
@@ -355,9 +358,17 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
 		if (ret)
 			return ret;
 
-		ret = follow_pfn(vma, vaddr, pfn);
+		ret = follow_pte(vma->vm_mm, vaddr, &ptep, &ptl);
+		if (ret)
+			return ret;
 	}
 
+	if (write_fault && !pte_write(*ptep))
+		ret = -EFAULT;
+	else
+		*pfn = pte_pfn(*ptep);
+
+	pte_unmap_unlock(ptep, ptl);
 	return ret;
 }
 
-- 
2.27.0



