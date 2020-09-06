Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15D1D25EE49
	for <lists+stable@lfdr.de>; Sun,  6 Sep 2020 16:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728946AbgIFObt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Sep 2020 10:31:49 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:38470 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728681AbgIFOMU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Sep 2020 10:12:20 -0400
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Sun, 6 Sep 2020 07:12:08 -0700
Received: from akaher-virtual-machine.eng.vmware.com (unknown [10.197.103.239])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id 9EC11408D7;
        Sun,  6 Sep 2020 07:12:07 -0700 (PDT)
From:   Ajay Kaher <akaher@vmware.com>
To:     <gregkh@linuxfoundation.org>
CC:     <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <peterx@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <srivatsab@vmware.com>, <srivatsa@csail.mit.edu>,
        <vsirnapalli@vmware.com>, <akaher@vmware.com>
Subject: [PATCH v5.4.y 2/3] vfio-pci: Fault mmaps to enable vma tracking
Date:   Sun, 6 Sep 2020 19:37:55 +0530
Message-ID: <1599401277-32172-2-git-send-email-akaher@vmware.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599401277-32172-1-git-send-email-akaher@vmware.com>
References: <1599401277-32172-1-git-send-email-akaher@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: akaher@vmware.com does not
 designate permitted sender hosts)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 11c4cd07ba111a09f49625f9e4c851d83daf0a22 upstream.

Rather than calling remap_pfn_range() when a region is mmap'd, setup
a vm_ops handler to support dynamic faulting of the range on access.
This allows us to manage a list of vmas actively mapping the area that
we can later use to invalidate those mappings.  The open callback
invalidates the vma range so that all tracking is inserted in the
fault handler and removed in the close handler.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Ajay Kaher <akaher@vmware.com>
---
 drivers/vfio/pci/vfio_pci.c         | 76 ++++++++++++++++++++++++++++++++++++-
 drivers/vfio/pci/vfio_pci_private.h |  7 ++++
 2 files changed, 81 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 0220616..da1d1ea 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1192,6 +1192,70 @@ static ssize_t vfio_pci_write(void *device_data, const char __user *buf,
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
@@ -1250,8 +1314,14 @@ static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
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
@@ -1327,6 +1397,8 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&vdev->irqlock);
 	mutex_init(&vdev->ioeventfds_lock);
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
+	mutex_init(&vdev->vma_lock);
+	INIT_LIST_HEAD(&vdev->vma_list);
 
 	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
 	if (ret) {
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index ee6ee91..8988448 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -84,6 +84,11 @@ struct vfio_pci_reflck {
 	struct mutex		lock;
 };
 
+struct vfio_pci_mmap_vma {
+	struct vm_area_struct	*vma;
+	struct list_head	vma_next;
+};
+
 struct vfio_pci_device {
 	struct pci_dev		*pdev;
 	void __iomem		*barmap[PCI_STD_RESOURCE_END + 1];
@@ -122,6 +127,8 @@ struct vfio_pci_device {
 	struct list_head	dummy_resources_list;
 	struct mutex		ioeventfds_lock;
 	struct list_head	ioeventfds_list;
+	struct mutex		vma_lock;
+	struct list_head	vma_list;
 };
 
 #define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)
-- 
2.7.4

