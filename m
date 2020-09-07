Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6F82605C1
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 22:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgIGUjW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 16:39:22 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:9185 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726962AbgIGUjW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Sep 2020 16:39:22 -0400
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Mon, 7 Sep 2020 13:39:20 -0700
Received: from akaher-virtual-machine.eng.vmware.com (unknown [10.197.103.239])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id 6F07240385;
        Mon,  7 Sep 2020 13:39:21 -0700 (PDT)
From:   Ajay Kaher <akaher@vmware.com>
To:     <gregkh@linuxfoundation.org>, <sashal@kernel.org>
CC:     <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <peterx@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <srivatsab@vmware.com>, <srivatsa@csail.mit.edu>,
        <vsirnapalli@vmware.com>, <akaher@vmware.com>
Subject: [PATCH v4.9.y 1/3] vfio/type1: Support faulting PFNMAP vmas
Date:   Tue, 8 Sep 2020 02:05:14 +0530
Message-ID: <1599510917-23734-1-git-send-email-akaher@vmware.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-001.vmware.com: akaher@vmware.com does not
 designate permitted sender hosts)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Williamson <alex.williamson@redhat.com>

commit 41311242221e3482b20bfed10fa4d9db98d87016 upstream.

With conversion to follow_pfn(), DMA mapping a PFNMAP range depends on
the range being faulted into the vma.  Add support to manually provide
that, in the same way as done on KVM with hva_to_pfn_remapped().

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
[Ajay: Regenerated the patch for v4.9]
Signed-off-by: Ajay Kaher <akaher@vmware.com>
---
 drivers/vfio/vfio_iommu_type1.c | 36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index a9f58f3..ccef02c 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -213,6 +213,32 @@ static int put_pfn(unsigned long pfn, int prot)
 	return 0;
 }
 
+static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
+			    unsigned long vaddr, unsigned long *pfn,
+			    bool write_fault)
+{
+	int ret;
+
+	ret = follow_pfn(vma, vaddr, pfn);
+	if (ret) {
+		bool unlocked = false;
+
+		ret = fixup_user_fault(NULL, mm, vaddr,
+				       FAULT_FLAG_REMOTE |
+				       (write_fault ?  FAULT_FLAG_WRITE : 0),
+				       &unlocked);
+		if (unlocked)
+			return -EAGAIN;
+
+		if (ret)
+			return ret;
+
+		ret = follow_pfn(vma, vaddr, pfn);
+	}
+
+	return ret;
+}
+
 static int vaddr_get_pfn(unsigned long vaddr, int prot, unsigned long *pfn)
 {
 	struct page *page[1];
@@ -226,12 +252,16 @@ static int vaddr_get_pfn(unsigned long vaddr, int prot, unsigned long *pfn)
 
 	down_read(&current->mm->mmap_sem);
 
+retry:
 	vma = find_vma_intersection(current->mm, vaddr, vaddr + 1);
 
 	if (vma && vma->vm_flags & VM_PFNMAP) {
-		if (!follow_pfn(vma, vaddr, pfn) &&
-		    is_invalid_reserved_pfn(*pfn))
-			ret = 0;
+		ret = follow_fault_pfn(vma, current->mm, vaddr, pfn, prot & IOMMU_WRITE);
+		if (ret == -EAGAIN)
+			goto retry;
+
+		if (!ret && !is_invalid_reserved_pfn(*pfn))
+			ret = -EFAULT;
 	}
 
 	up_read(&current->mm->mmap_sem);
-- 
2.7.4

