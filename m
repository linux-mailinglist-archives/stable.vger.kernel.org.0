Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1CE86AE5E8
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 17:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjCGQHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 11:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjCGQG7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 11:06:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C9623301
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 08:05:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D60B461492
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 16:05:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9F5C433D2;
        Tue,  7 Mar 2023 16:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678205135;
        bh=bNFzzBDtXYaMM9PY6jFoZWkria7W3gXM9uWoY4yj33I=;
        h=Subject:To:Cc:From:Date:From;
        b=vRIldyrCJg2ERixxvYn4cDbRaBy8TdDHW6rUazZM8jb43XBr4SvUl2XnW3534xdEe
         YLDuJg6DP0lPHR++7q8FK7pxQNDiGeUDbRH+1oFjwvIgYBnBw/oirK9GuSeG5cDvkr
         9K5cBJIyKOPxdvSHNAttQsN5CqquRJLO/kTWscME=
Subject: FAILED: patch "[PATCH] vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR" failed to apply to 5.15-stable tree
To:     steven.sistare@oracle.com, alex.williamson@redhat.com,
        jgg@nvidia.com, kevin.tian@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 17:05:32 +0100
Message-ID: <1678205132164221@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x ef3a3f6a294ba65fd906a291553935881796f8a5
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678205132164221@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

ef3a3f6a294b ("vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR")
296e505baddf ("vfio/iommu_type1: remove the "external" domain")
65cdbf106337 ("vfio/iommu_type1: initialize pgsize_bitmap in ->open")
c3c0fa9d94f7 ("vfio: clean up the check for mediated device in vfio_iommu_type1")
fda49d97f2c4 ("vfio: remove the unused mdev iommu hook")
8cc02d22d7e1 ("vfio: move the vfio_iommu_driver_ops interface out of <linux/vfio.h>")
67462037872d ("vfio: remove unused method from vfio_iommu_driver_ops")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ef3a3f6a294ba65fd906a291553935881796f8a5 Mon Sep 17 00:00:00 2001
From: Steve Sistare <steven.sistare@oracle.com>
Date: Tue, 31 Jan 2023 08:58:03 -0800
Subject: [PATCH] vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR

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

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 23c24fe98c00..144f5bb20fb8 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -861,6 +861,12 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 
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
@@ -1343,6 +1349,12 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 
 	mutex_lock(&iommu->lock);
 
+	/* Cannot update vaddr if mdev is present. */
+	if (invalidate_vaddr && !list_empty(&iommu->emulated_iommu_groups)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
 	pgshift = __ffs(iommu->pgsize_bitmap);
 	pgsize = (size_t)1 << pgshift;
 
@@ -2185,11 +2197,16 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
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
 
@@ -2660,6 +2677,16 @@ static int vfio_domains_have_enforce_cache_coherency(struct vfio_iommu *iommu)
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
@@ -2668,8 +2695,13 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
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
@@ -3138,6 +3170,13 @@ static int vfio_iommu_type1_dma_rw(void *iommu_data, dma_addr_t user_iova,
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
@@ -3149,6 +3188,7 @@ static int vfio_iommu_type1_dma_rw(void *iommu_data, dma_addr_t user_iova,
 		user_iova += done;
 	}
 
+out:
 	mutex_unlock(&iommu->lock);
 	return ret;
 }
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 23105eb036fa..0552e8dcf0cb 100644
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

