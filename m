Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDD7266531
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 18:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgIKQzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 12:55:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726323AbgIKPFa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 11:05:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D239622403;
        Fri, 11 Sep 2020 12:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829150;
        bh=UoDf2Uwl0Yq8QLtFZRUy0JZ7qxXffEpxG3NsTmdAtDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nSU5ge54SG1KJ3couPPLdM8Tk+UWUa2wrEmqwWOR4sH2Ki2jAxazGowAa47bkZI0B
         +uVoc4xTAuHDyc6YuF7Ee7R3kIM0JDFv4O8IshUQrp59XmEOsqws5KVmnIOMfdMr3M
         I8CxE+1EIneWsrIqCu9kIDtLwQQpqyMIpSdauf3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ajay Kaher <akaher@vmware.com>
Subject: [PATCH 4.14 04/12] vfio-pci: Fault mmaps to enable vma tracking
Date:   Fri, 11 Sep 2020 14:46:58 +0200
Message-Id: <20200911122458.637277425@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122458.413137406@linuxfoundation.org>
References: <20200911122458.413137406@linuxfoundation.org>
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
[Ajay: Regenerated the patch for v4.14]
Signed-off-by: Ajay Kaher <akaher@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/pci/vfio_pci.c         |   76 +++++++++++++++++++++++++++++++++++-
 drivers/vfio/pci/vfio_pci_private.h |    7 +++
 2 files changed, 81 insertions(+), 2 deletions(-)

--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1120,6 +1120,70 @@ static ssize_t vfio_pci_write(void *devi
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
+static int vfio_pci_mmap_fault(struct vm_fault *vmf)
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
@@ -1185,8 +1249,14 @@ static int vfio_pci_mmap(void *device_da
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
@@ -1243,6 +1313,8 @@ static int vfio_pci_probe(struct pci_dev
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
 	mutex_init(&vdev->igate);
 	spin_lock_init(&vdev->irqlock);
+	mutex_init(&vdev->vma_lock);
+	INIT_LIST_HEAD(&vdev->vma_list);
 
 	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
 	if (ret) {
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -63,6 +63,11 @@ struct vfio_pci_dummy_resource {
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
@@ -95,6 +100,8 @@ struct vfio_pci_device {
 	struct eventfd_ctx	*err_trigger;
 	struct eventfd_ctx	*req_trigger;
 	struct list_head	dummy_resources_list;
+	struct mutex		vma_lock;
+	struct list_head	vma_list;
 };
 
 #define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)


