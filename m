Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2521D41116D
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 10:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236053AbhITI4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 04:56:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236070AbhITI4l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 04:56:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E01F5601FF;
        Mon, 20 Sep 2021 08:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632128115;
        bh=G/puF257Oz1vmhcSi8baSr4Os3iGoSmF9tUMiUMNZcY=;
        h=Subject:To:Cc:From:Date:From;
        b=1w8Nb76ASZuknHojwjIGa68diUjoTORUrlbzUPQ2OjH8utrP+hp2KKnNL3hBpawKH
         BNXncYBorqks4HEPBmbtsWuCPGMP0prQ25gFXx0gAVBrqFWKo+IV3LOpwHO7EFxfl6
         0lSdNBHe2YnBIqSvvn0utiAvNIo8OPCAq3T0pvOA=
Subject: FAILED: patch "[PATCH] s390/pci_mmio: fully validate the VMA before calling" failed to apply to 5.10-stable tree
To:     david@redhat.com, Liam.Howlett@oracle.com, gor@linux.ibm.com,
        schnelle@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Sep 2021 10:55:12 +0200
Message-ID: <1632128112176198@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a8b92b8c1eac8d655a97b1e90f4d83c25d9b9a18 Mon Sep 17 00:00:00 2001
From: David Hildenbrand <david@redhat.com>
Date: Thu, 9 Sep 2021 16:59:42 +0200
Subject: [PATCH] s390/pci_mmio: fully validate the VMA before calling
 follow_pte()

We should not walk/touch page tables outside of VMA boundaries when
holding only the mmap sem in read mode. Evil user space can modify the
VMA layout just before this function runs and e.g., trigger races with
page table removal code since commit dd2283f2605e ("mm: mmap: zap pages
with read mmap_sem in munmap").

find_vma() does not check if the address is >= the VMA start address;
use vma_lookup() instead.

Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Fixes: dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in munmap")
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>

diff --git a/arch/s390/pci/pci_mmio.c b/arch/s390/pci/pci_mmio.c
index ae683aa623ac..c5b35ea129cf 100644
--- a/arch/s390/pci/pci_mmio.c
+++ b/arch/s390/pci/pci_mmio.c
@@ -159,7 +159,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned long, mmio_addr,
 
 	mmap_read_lock(current->mm);
 	ret = -EINVAL;
-	vma = find_vma(current->mm, mmio_addr);
+	vma = vma_lookup(current->mm, mmio_addr);
 	if (!vma)
 		goto out_unlock_mmap;
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
@@ -298,7 +298,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_read, unsigned long, mmio_addr,
 
 	mmap_read_lock(current->mm);
 	ret = -EINVAL;
-	vma = find_vma(current->mm, mmio_addr);
+	vma = vma_lookup(current->mm, mmio_addr);
 	if (!vma)
 		goto out_unlock_mmap;
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))

