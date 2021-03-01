Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578083288FB
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238724AbhCARrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:47:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:35580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237465AbhCARmf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:42:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 671B6650CD;
        Mon,  1 Mar 2021 16:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617828;
        bh=s+zyr0PNELZLGoaoKNMygPWr3TDS6MMw3b0tgq/dubk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MrovSFNkncreQ3YLT2HffEpbxLJzaObdjEYoVpjo4BonqhCtOpUrki2XmL/L4zffc
         8gfHC7GJQGv79iKxo0svORgdEMJe3uCMGb1SdlYTt+5+AUYkzoLwJMUgNV530GtvUN
         CSWZED/Ww6Uht1KoHB6xer8TjbsPRbRGFaXmpByI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keqian Zhu <zhukeqian1@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 211/340] vfio/iommu_type1: Fix some sanity checks in detach group
Date:   Mon,  1 Mar 2021 17:12:35 +0100
Message-Id: <20210301161058.685101812@linuxfoundation.org>
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

From: Keqian Zhu <zhukeqian1@huawei.com>

[ Upstream commit 4a19f37a3dd3f29997735e61b25ddad24b8abe73 ]

vfio_sanity_check_pfn_list() is used to check whether pfn_list and
notifier are empty when remove the external domain, so it makes a
wrong assumption that only external domain will use the pinning
interface.

Now we apply the pfn_list check when a vfio_dma is removed and apply
the notifier check when all domains are removed.

Fixes: a54eb55045ae ("vfio iommu type1: Add support for mediated devices")
Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio_iommu_type1.c | 31 ++++++++-----------------------
 1 file changed, 8 insertions(+), 23 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index bc6ba41686fa3..9cbe058a530f0 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -866,6 +866,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 
 static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
 {
+	WARN_ON(!RB_EMPTY_ROOT(&dma->pfn_list));
 	vfio_unmap_unpin(iommu, dma, true);
 	vfio_unlink_dma(iommu, dma);
 	put_task_struct(dma->task);
@@ -1974,23 +1975,6 @@ static void vfio_iommu_unmap_unpin_reaccount(struct vfio_iommu *iommu)
 	}
 }
 
-static void vfio_sanity_check_pfn_list(struct vfio_iommu *iommu)
-{
-	struct rb_node *n;
-
-	n = rb_first(&iommu->dma_list);
-	for (; n; n = rb_next(n)) {
-		struct vfio_dma *dma;
-
-		dma = rb_entry(n, struct vfio_dma, node);
-
-		if (WARN_ON(!RB_EMPTY_ROOT(&dma->pfn_list)))
-			break;
-	}
-	/* mdev vendor driver must unregister notifier */
-	WARN_ON(iommu->notifier.head);
-}
-
 /*
  * Called when a domain is removed in detach. It is possible that
  * the removed domain decided the iova aperture window. Modify the
@@ -2088,10 +2072,10 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 			kfree(group);
 
 			if (list_empty(&iommu->external_domain->group_list)) {
-				vfio_sanity_check_pfn_list(iommu);
-
-				if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu))
+				if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
+					WARN_ON(iommu->notifier.head);
 					vfio_iommu_unmap_unpin_all(iommu);
+				}
 
 				kfree(iommu->external_domain);
 				iommu->external_domain = NULL;
@@ -2124,10 +2108,12 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 		 */
 		if (list_empty(&domain->group_list)) {
 			if (list_is_singular(&iommu->domain_list)) {
-				if (!iommu->external_domain)
+				if (!iommu->external_domain) {
+					WARN_ON(iommu->notifier.head);
 					vfio_iommu_unmap_unpin_all(iommu);
-				else
+				} else {
 					vfio_iommu_unmap_unpin_reaccount(iommu);
+				}
 			}
 			iommu_domain_free(domain->domain);
 			list_del(&domain->next);
@@ -2201,7 +2187,6 @@ static void vfio_iommu_type1_release(void *iommu_data)
 
 	if (iommu->external_domain) {
 		vfio_release_domain(iommu->external_domain, true);
-		vfio_sanity_check_pfn_list(iommu);
 		kfree(iommu->external_domain);
 	}
 
-- 
2.27.0



