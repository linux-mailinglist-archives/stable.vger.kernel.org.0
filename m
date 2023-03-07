Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A88E56AED80
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjCGSFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:05:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbjCGSE3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:04:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BBCABAC0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:57:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E042C6150B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7582C433EF;
        Tue,  7 Mar 2023 17:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211832;
        bh=7JDr19sAhHILsDT17gNT5tOX7qapJGJ3XMyXlKyTFZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I7D81AUYy4QIpb+0ohjjKYpb8wbDGLBjFlSOpEQnphSxsiS/bZF3gFQ7iM23oOLNw
         jBH80fVYXeSzPs4iSSruTaginPqf4eCyIJ9NOStv5F/6Akead7OqMsW3gsWUl8QJ7E
         Z8698tsaaxhvZBB2k/4stJuME09n8e4ZeAO/5c1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Steve Sistare <steven.sistare@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 6.2 0990/1001] vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
Date:   Tue,  7 Mar 2023 18:02:42 +0100
Message-Id: <20230307170105.226402197@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve Sistare <steven.sistare@oracle.com>

commit ef3a3f6a294ba65fd906a291553935881796f8a5 upstream.

Disable the VFIO_UPDATE_VADDR capability if mediated devices are present.
Their kernel threads could be blocked indefinitely by a misbehaving
userland while trying to pin/unpin pages while vaddrs are being updated.

Do not allow groups to be added to the container while vaddr's are invalid,
so we never need to block user threads from pinning, and can delete the
vaddr-waiting code in a subsequent patch.

Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")
Cc: stable@vger.kernel.org
Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/1675184289-267876-2-git-send-email-steven.sistare@oracle.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/vfio_iommu_type1.c |   44 ++++++++++++++++++++++++++++++++++++++--
 include/uapi/linux/vfio.h       |   15 ++++++++-----
 2 files changed, 51 insertions(+), 8 deletions(-)

--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -861,6 +861,12 @@ static int vfio_iommu_type1_pin_pages(vo
 
 	mutex_lock(&iommu->lock);
 
+	if (WARN_ONCE(iommu->vaddr_invalid_count,
+		      "vfio_pin_pages not allowed with VFIO_UPDATE_VADDR\n")) {
+		ret = -EBUSY;
+		goto pin_done;
+	}
+
 	/*
 	 * Wait for all necessary vaddr's to be valid so they can be used in
 	 * the main loop without dropping the lock, to avoid racing vs unmap.
@@ -1343,6 +1349,12 @@ static int vfio_dma_do_unmap(struct vfio
 
 	mutex_lock(&iommu->lock);
 
+	/* Cannot update vaddr if mdev is present. */
+	if (invalidate_vaddr && !list_empty(&iommu->emulated_iommu_groups)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
 	pgshift = __ffs(iommu->pgsize_bitmap);
 	pgsize = (size_t)1 << pgshift;
 
@@ -2194,11 +2206,16 @@ static int vfio_iommu_type1_attach_group
 	struct iommu_domain_geometry *geo;
 	LIST_HEAD(iova_copy);
 	LIST_HEAD(group_resv_regions);
-	int ret = -EINVAL;
+	int ret = -EBUSY;
 
 	mutex_lock(&iommu->lock);
 
+	/* Attach could require pinning, so disallow while vaddr is invalid. */
+	if (iommu->vaddr_invalid_count)
+		goto out_unlock;
+
 	/* Check for duplicates */
+	ret = -EINVAL;
 	if (vfio_iommu_find_iommu_group(iommu, iommu_group))
 		goto out_unlock;
 
@@ -2669,6 +2686,16 @@ static int vfio_domains_have_enforce_cac
 	return ret;
 }
 
+static bool vfio_iommu_has_emulated(struct vfio_iommu *iommu)
+{
+	bool ret;
+
+	mutex_lock(&iommu->lock);
+	ret = !list_empty(&iommu->emulated_iommu_groups);
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
 static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
 					    unsigned long arg)
 {
@@ -2677,8 +2704,13 @@ static int vfio_iommu_type1_check_extens
 	case VFIO_TYPE1v2_IOMMU:
 	case VFIO_TYPE1_NESTING_IOMMU:
 	case VFIO_UNMAP_ALL:
-	case VFIO_UPDATE_VADDR:
 		return 1;
+	case VFIO_UPDATE_VADDR:
+		/*
+		 * Disable this feature if mdevs are present.  They cannot
+		 * safely pin/unpin/rw while vaddrs are being updated.
+		 */
+		return iommu && !vfio_iommu_has_emulated(iommu);
 	case VFIO_DMA_CC_IOMMU:
 		if (!iommu)
 			return 0;
@@ -3147,6 +3179,13 @@ static int vfio_iommu_type1_dma_rw(void
 	size_t done;
 
 	mutex_lock(&iommu->lock);
+
+	if (WARN_ONCE(iommu->vaddr_invalid_count,
+		      "vfio_dma_rw not allowed with VFIO_UPDATE_VADDR\n")) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	while (count > 0) {
 		ret = vfio_iommu_type1_dma_rw_chunk(iommu, user_iova, data,
 						    count, write, &done);
@@ -3158,6 +3197,7 @@ static int vfio_iommu_type1_dma_rw(void
 		user_iova += done;
 	}
 
+out:
 	mutex_unlock(&iommu->lock);
 	return ret;
 }
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -49,7 +49,11 @@
 /* Supports VFIO_DMA_UNMAP_FLAG_ALL */
 #define VFIO_UNMAP_ALL			9
 
-/* Supports the vaddr flag for DMA map and unmap */
+/*
+ * Supports the vaddr flag for DMA map and unmap.  Not supported for mediated
+ * devices, so this capability is subject to change as groups are added or
+ * removed.
+ */
 #define VFIO_UPDATE_VADDR		10
 
 /*
@@ -1343,8 +1347,7 @@ struct vfio_iommu_type1_info_dma_avail {
  * Map process virtual addresses to IO virtual addresses using the
  * provided struct vfio_dma_map. Caller sets argsz. READ &/ WRITE required.
  *
- * If flags & VFIO_DMA_MAP_FLAG_VADDR, update the base vaddr for iova, and
- * unblock translation of host virtual addresses in the iova range.  The vaddr
+ * If flags & VFIO_DMA_MAP_FLAG_VADDR, update the base vaddr for iova. The vaddr
  * must have previously been invalidated with VFIO_DMA_UNMAP_FLAG_VADDR.  To
  * maintain memory consistency within the user application, the updated vaddr
  * must address the same memory object as originally mapped.  Failure to do so
@@ -1395,9 +1398,9 @@ struct vfio_bitmap {
  * must be 0.  This cannot be combined with the get-dirty-bitmap flag.
  *
  * If flags & VFIO_DMA_UNMAP_FLAG_VADDR, do not unmap, but invalidate host
- * virtual addresses in the iova range.  Tasks that attempt to translate an
- * iova's vaddr will block.  DMA to already-mapped pages continues.  This
- * cannot be combined with the get-dirty-bitmap flag.
+ * virtual addresses in the iova range.  DMA to already-mapped pages continues.
+ * Groups may not be added to the container while any addresses are invalid.
+ * This cannot be combined with the get-dirty-bitmap flag.
  */
 struct vfio_iommu_type1_dma_unmap {
 	__u32	argsz;


