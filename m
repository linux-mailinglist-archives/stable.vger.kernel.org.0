Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6AF5261A7B
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731653AbgIHSgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:36:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731359AbgIHQJV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:09:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50F1A24179;
        Tue,  8 Sep 2020 15:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580164;
        bh=sgebLogZ6YMo2agxjm5idtNjYZ+IkVAyw/Tr5CG68xE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D04sRxddQet5o62az0/1+66FW4NuXH6PMgTro5go+x7FPNZ6P7D+AEbAufaaUHEzI
         PS2V6DVa7Og1f7e3yOtzOpIWLP4mTD0P4zNHzSP4KY3coV9lW/szpT3vo1JJtzk2t/
         PfLBvYo9l16+ldOoTHWVyLo7g82eKDxB/twCK/DE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ajay Kaher <akaher@vmware.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 56/88] vfio-pci: Fault mmaps to enable vma tracking
Date:   Tue,  8 Sep 2020 17:25:57 +0200
Message-Id: <20200908152223.933542744@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152221.082184905@linuxfoundation.org>
References: <20200908152221.082184905@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Williamson <alex.williamson@redhat.com>

commit 11c4cd07ba111a09f49625f9e4c851d83daf0a22 upstream.

Rather than calling remap_pfn_range() when a region is mmap'd, setup
a vm_ops handler to support dynamic faulting of the range on access.
This allows us to manage a list of vmas actively mapping the area that
we can later use to invalidate those mappings.  The open callback
invalidates the vma range so that all tracking is inserted in the
fault handler and removed in the close handler.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
[Ajay: Regenerated the patch for v4.19]
Signed-off-by: Ajay Kaher <akaher@vmware.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci.c         | 76 ++++++++++++++++++++++++++++-
 drivers/vfio/pci/vfio_pci_private.h |  7 +++
 2 files changed, 81 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 66783a37f450c..3cd596023c2bb 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1121,6 +1121,70 @@ static ssize_t vfio_pci_write(void *device_data, const char __user *buf,
 	return vfio_pci_rw(device_data, (char __user *)buf, count, ppos, true);
 }
 
+static int vfio_pci_add_vma(struct vfio_pci_device *vdev,
+			    struct vm_area_struct *vma)
+{
+	struct vfio_pci_mmap_vma *mmap_vma;
+
+	mmap_vma = kmalloc(sizeof(*mmap_vma), GFP_KERNEL);
+	if (!mmap_vma)
+		return -ENOMEM;
+
+	mmap_vma->vma = vma;
+
+	mutex_lock(&vdev->vma_lock);
+	list_add(&mmap_vma->vma_next, &vdev->vma_list);
+	mutex_unlock(&vdev->vma_lock);
+
+	return 0;
+}
+
+/*
+ * Zap mmaps on open so that we can fault them in on access and therefore
+ * our vma_list only tracks mappings accessed since last zap.
+ */
+static void vfio_pci_mmap_open(struct vm_area_struct *vma)
+{
+	zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);
+}
+
+static void vfio_pci_mmap_close(struct vm_area_struct *vma)
+{
+	struct vfio_pci_device *vdev = vma->vm_private_data;
+	struct vfio_pci_mmap_vma *mmap_vma;
+
+	mutex_lock(&vdev->vma_lock);
+	list_for_each_entry(mmap_vma, &vdev->vma_list, vma_next) {
+		if (mmap_vma->vma == vma) {
+			list_del(&mmap_vma->vma_next);
+			kfree(mmap_vma);
+			break;
+		}
+	}
+	mutex_unlock(&vdev->vma_lock);
+}
+
+static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	struct vfio_pci_device *vdev = vma->vm_private_data;
+
+	if (vfio_pci_add_vma(vdev, vma))
+		return VM_FAULT_OOM;
+
+	if (remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
+			    vma->vm_end - vma->vm_start, vma->vm_page_prot))
+		return VM_FAULT_SIGBUS;
+
+	return VM_FAULT_NOPAGE;
+}
+
+static const struct vm_operations_struct vfio_pci_mmap_ops = {
+	.open = vfio_pci_mmap_open,
+	.close = vfio_pci_mmap_close,
+	.fault = vfio_pci_mmap_fault,
+};
+
 static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 {
 	struct vfio_pci_device *vdev = device_data;
@@ -1170,8 +1234,14 @@ static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	vma->vm_pgoff = (pci_resource_start(pdev, index) >> PAGE_SHIFT) + pgoff;
 
-	return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
-			       req_len, vma->vm_page_prot);
+	/*
+	 * See remap_pfn_range(), called from vfio_pci_fault() but we can't
+	 * change vm_flags within the fault handler.  Set them now.
+	 */
+	vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
+	vma->vm_ops = &vfio_pci_mmap_ops;
+
+	return 0;
 }
 
 static void vfio_pci_request(void *device_data, unsigned int count)
@@ -1243,6 +1313,8 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&vdev->irqlock);
 	mutex_init(&vdev->ioeventfds_lock);
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
+	mutex_init(&vdev->vma_lock);
+	INIT_LIST_HEAD(&vdev->vma_list);
 
 	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
 	if (ret) {
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index cde3b5d3441ad..9743c934199d6 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -76,6 +76,11 @@ struct vfio_pci_dummy_resource {
 	struct list_head	res_next;
 };
 
+struct vfio_pci_mmap_vma {
+	struct vm_area_struct	*vma;
+	struct list_head	vma_next;
+};
+
 struct vfio_pci_device {
 	struct pci_dev		*pdev;
 	void __iomem		*barmap[PCI_STD_RESOURCE_END + 1];
@@ -111,6 +116,8 @@ struct vfio_pci_device {
 	struct list_head	dummy_resources_list;
 	struct mutex		ioeventfds_lock;
 	struct list_head	ioeventfds_list;
+	struct mutex		vma_lock;
+	struct list_head	vma_list;
 };
 
 #define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)
-- 
2.25.1



