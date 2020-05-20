Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91FB31DAE70
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 11:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgETJOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 05:14:04 -0400
Received: from www413.your-server.de ([88.198.28.140]:53256 "EHLO
        www413.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbgETJOE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 05:14:04 -0400
X-Greylist: delayed 1404 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 May 2020 05:14:01 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=cyberus-technology.de; s=default1911; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=AGnM7XhxhHj0RbBCrLmi3dACAYwjZ9rMZOuwTi0Brt4=; b=lhGJYqfck4GmSp4pYKS6cGMv1
        IYE2t4TsFFPmThQOVZm5aWuRZD0Fv6F7x0G4KVjL08aPUdSijbOwFj+GZ6m6LN14y3FKYucw4oKUv
        JdL2pfYDIb4WTYsFn0YF2z7AuW5VHh8H6rPWsYjieRlH/bKu2b3zB1WueTLK7ETcHlo8oNlWF7YKD
        pIfSqwhQP4g9XcsYNd/ZoPygjKQijxx4aO2tXIWP81q858Ir/6DxES92mCf7sRwRg3AyG+ISH3QPc
        e5275M90v8dBd4d7YOcwIfjKiUmxRrEJlNDRmO0O8xl49iO8L3okV809Dpj5fyJbbrtZMEfUU+r8I
        VZoiALBsQ==;
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www413.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <julian.stecklina@cyberus-technology.de>)
        id 1jbKQt-0003yq-FP; Wed, 20 May 2020 10:50:35 +0200
Received: from [2a02:8106:231:700:6975:3446:3ada:292d] (helo=localhost.localdomain)
        by sslproxy01.your-server.de with esmtpsa (TLSv1:ECDHE-RSA-AES256-SHA:256)
        (Exim 4.92)
        (envelope-from <julian.stecklina@cyberus-technology.de>)
        id 1jbKQt-000U7V-9O; Wed, 20 May 2020 10:50:35 +0200
From:   Julian Stecklina <julian.stecklina@cyberus-technology.de>
To:     stable@vger.kernel.org
Cc:     Tina Zhang <tina.zhang@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Julian Stecklina <julian.stecklina@cyberus-technology.de>
Subject: [PATCH] drm/i915/gvt: Pin vgpu dma address before using
Date:   Wed, 20 May 2020 10:49:57 +0200
Message-Id: <20200520084957.17652-1-julian.stecklina@cyberus-technology.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: julian.stecklina@cyberus-technology.de
X-Virus-Scanned: Clear (ClamAV 0.102.2/25817/Tue May 19 14:16:16 2020)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tina Zhang <tina.zhang@intel.com>

commit 9f674c811740b5db4b34668b72d47f6e7b879b0a upstream.

Dma-buf display uses the vgpu dma address saved in the guest part GGTT
table which is updated by vCPU thread. In host side, when the dma
address is used by qemu ui thread, gvt-g must make sure the dma address
is validated before letting it go to the HW. Invalid guest dma address
will easily cause DMA fault and make GPU hang.

v2: Rebase

Fixes: e546e281d33d ("drm/i915/gvt: Dmabuf support for GVT-g")
Acked-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Tina Zhang <tina.zhang@intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20191212141342.3417-1-tina.zhang@intel.com
Cc: <stable@vger.kernel.org> # 5.4
Signed-off-by: Julian Stecklina <julian.stecklina@cyberus-technology.de>
---
 drivers/gpu/drm/i915/gvt/dmabuf.c    | 63 ++++++++++++++++++++++++++--
 drivers/gpu/drm/i915/gvt/hypercall.h |  2 +
 drivers/gpu/drm/i915/gvt/kvmgt.c     | 23 ++++++++++
 drivers/gpu/drm/i915/gvt/mpt.h       | 15 +++++++
 4 files changed, 99 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/dmabuf.c b/drivers/gpu/drm/i915/gvt/dmabuf.c
index c0347956f7cf..eae003605ebc 100644
--- a/drivers/gpu/drm/i915/gvt/dmabuf.c
+++ b/drivers/gpu/drm/i915/gvt/dmabuf.c
@@ -36,13 +36,32 @@
 
 #define GEN8_DECODE_PTE(pte) (pte & GENMASK_ULL(63, 12))
 
+static int vgpu_pin_dma_address(struct intel_vgpu *vgpu,
+				unsigned long size,
+				dma_addr_t dma_addr)
+{
+	int ret = 0;
+
+	if (intel_gvt_hypervisor_dma_pin_guest_page(vgpu, dma_addr))
+		ret = -EINVAL;
+
+	return ret;
+}
+
+static void vgpu_unpin_dma_address(struct intel_vgpu *vgpu,
+				   dma_addr_t dma_addr)
+{
+	intel_gvt_hypervisor_dma_unmap_guest_page(vgpu, dma_addr);
+}
+
 static int vgpu_gem_get_pages(
 		struct drm_i915_gem_object *obj)
 {
 	struct drm_i915_private *dev_priv = to_i915(obj->base.dev);
+	struct intel_vgpu *vgpu;
 	struct sg_table *st;
 	struct scatterlist *sg;
-	int i, ret;
+	int i, j, ret;
 	gen8_pte_t __iomem *gtt_entries;
 	struct intel_vgpu_fb_info *fb_info;
 	u32 page_num;
@@ -51,6 +70,10 @@ static int vgpu_gem_get_pages(
 	if (WARN_ON(!fb_info))
 		return -ENODEV;
 
+	vgpu = fb_info->obj->vgpu;
+	if (WARN_ON(!vgpu))
+		return -ENODEV;
+
 	st = kmalloc(sizeof(*st), GFP_KERNEL);
 	if (unlikely(!st))
 		return -ENOMEM;
@@ -64,21 +87,53 @@ static int vgpu_gem_get_pages(
 	gtt_entries = (gen8_pte_t __iomem *)dev_priv->ggtt.gsm +
 		(fb_info->start >> PAGE_SHIFT);
 	for_each_sg(st->sgl, sg, page_num, i) {
+		dma_addr_t dma_addr =
+			GEN8_DECODE_PTE(readq(&gtt_entries[i]));
+		if (vgpu_pin_dma_address(vgpu, PAGE_SIZE, dma_addr)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
 		sg->offset = 0;
 		sg->length = PAGE_SIZE;
-		sg_dma_address(sg) =
-			GEN8_DECODE_PTE(readq(&gtt_entries[i]));
 		sg_dma_len(sg) = PAGE_SIZE;
+		sg_dma_address(sg) = dma_addr;
 	}
 
 	__i915_gem_object_set_pages(obj, st, PAGE_SIZE);
+out:
+	if (ret) {
+		dma_addr_t dma_addr;
+
+		for_each_sg(st->sgl, sg, i, j) {
+			dma_addr = sg_dma_address(sg);
+			if (dma_addr)
+				vgpu_unpin_dma_address(vgpu, dma_addr);
+		}
+		sg_free_table(st);
+		kfree(st);
+	}
+
+	return ret;
 
-	return 0;
 }
 
 static void vgpu_gem_put_pages(struct drm_i915_gem_object *obj,
 		struct sg_table *pages)
 {
+	struct scatterlist *sg;
+
+	if (obj->base.dma_buf) {
+		struct intel_vgpu_fb_info *fb_info = obj->gvt_info;
+		struct intel_vgpu_dmabuf_obj *obj = fb_info->obj;
+		struct intel_vgpu *vgpu = obj->vgpu;
+		int i;
+
+		for_each_sg(pages->sgl, sg, fb_info->size, i)
+			vgpu_unpin_dma_address(vgpu,
+					       sg_dma_address(sg));
+	}
+
 	sg_free_table(pages);
 	kfree(pages);
 }
diff --git a/drivers/gpu/drm/i915/gvt/hypercall.h b/drivers/gpu/drm/i915/gvt/hypercall.h
index 4862fb12778e..b19a3b1ea4c1 100644
--- a/drivers/gpu/drm/i915/gvt/hypercall.h
+++ b/drivers/gpu/drm/i915/gvt/hypercall.h
@@ -62,6 +62,8 @@ struct intel_gvt_mpt {
 				  unsigned long size, dma_addr_t *dma_addr);
 	void (*dma_unmap_guest_page)(unsigned long handle, dma_addr_t dma_addr);
 
+	int (*dma_pin_guest_page)(unsigned long handle, dma_addr_t dma_addr);
+
 	int (*map_gfn_to_mfn)(unsigned long handle, unsigned long gfn,
 			      unsigned long mfn, unsigned int nr, bool map);
 	int (*set_trap_area)(unsigned long handle, u64 start, u64 end,
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 343d79c1cb7e..3571666ed403 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1933,6 +1933,28 @@ static int kvmgt_dma_map_guest_page(unsigned long handle, unsigned long gfn,
 	return ret;
 }
 
+static int kvmgt_dma_pin_guest_page(unsigned long handle, dma_addr_t dma_addr)
+{
+	struct kvmgt_guest_info *info;
+	struct gvt_dma *entry;
+	int ret = 0;
+
+	if (!handle_valid(handle))
+		return -ENODEV;
+
+	info = (struct kvmgt_guest_info *)handle;
+
+	mutex_lock(&info->vgpu->vdev.cache_lock);
+	entry = __gvt_cache_find_dma_addr(info->vgpu, dma_addr);
+	if (entry)
+		kref_get(&entry->ref);
+	else
+		ret = -ENOMEM;
+	mutex_unlock(&info->vgpu->vdev.cache_lock);
+
+	return ret;
+}
+
 static void __gvt_dma_release(struct kref *ref)
 {
 	struct gvt_dma *entry = container_of(ref, typeof(*entry), ref);
@@ -2044,6 +2066,7 @@ static struct intel_gvt_mpt kvmgt_mpt = {
 	.gfn_to_mfn = kvmgt_gfn_to_pfn,
 	.dma_map_guest_page = kvmgt_dma_map_guest_page,
 	.dma_unmap_guest_page = kvmgt_dma_unmap_guest_page,
+	.dma_pin_guest_page = kvmgt_dma_pin_guest_page,
 	.set_opregion = kvmgt_set_opregion,
 	.set_edid = kvmgt_set_edid,
 	.get_vfio_device = kvmgt_get_vfio_device,
diff --git a/drivers/gpu/drm/i915/gvt/mpt.h b/drivers/gpu/drm/i915/gvt/mpt.h
index 0f9440128123..9ad224df9c68 100644
--- a/drivers/gpu/drm/i915/gvt/mpt.h
+++ b/drivers/gpu/drm/i915/gvt/mpt.h
@@ -254,6 +254,21 @@ static inline void intel_gvt_hypervisor_dma_unmap_guest_page(
 	intel_gvt_host.mpt->dma_unmap_guest_page(vgpu->handle, dma_addr);
 }
 
+/**
+ * intel_gvt_hypervisor_dma_pin_guest_page - pin guest dma buf
+ * @vgpu: a vGPU
+ * @dma_addr: guest dma addr
+ *
+ * Returns:
+ * 0 on success, negative error code if failed.
+ */
+static inline int
+intel_gvt_hypervisor_dma_pin_guest_page(struct intel_vgpu *vgpu,
+					dma_addr_t dma_addr)
+{
+	return intel_gvt_host.mpt->dma_pin_guest_page(vgpu->handle, dma_addr);
+}
+
 /**
  * intel_gvt_hypervisor_map_gfn_to_mfn - map a GFN region to MFN
  * @vgpu: a vGPU
-- 
2.26.2

