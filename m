Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82CBA412541
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349302AbhITSmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:42:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382501AbhITSkb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:40:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B619363338;
        Mon, 20 Sep 2021 17:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159092;
        bh=LIQR5vIzGDugMsTTNQGx6cy8uXVW1K9EDJLiVhnSt1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n5Pbd9yRH0zjWvIAZxoaGb0cxL+nfy9hUgb/RCW9XNbTXRk8mtb5svtPnEGJPjMFO
         d1T1KZXuKkT5asYcqQuzFbm3ke9yb3IAfOBvMdOa7As/JRjHNG5A9DyXPbyneLAzle
         Db6sA6OYaqXy5+r2PM1uHhM6tct+p6AZ+IUZtJOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Schnelle <schnelle@linux.ibm.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.14 073/168] s390/pci_mmio: fully validate the VMA before calling follow_pte()
Date:   Mon, 20 Sep 2021 18:43:31 +0200
Message-Id: <20210920163924.041752812@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

commit a8b92b8c1eac8d655a97b1e90f4d83c25d9b9a18 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci_mmio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/s390/pci/pci_mmio.c
+++ b/arch/s390/pci/pci_mmio.c
@@ -159,7 +159,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, uns
 
 	mmap_read_lock(current->mm);
 	ret = -EINVAL;
-	vma = find_vma(current->mm, mmio_addr);
+	vma = vma_lookup(current->mm, mmio_addr);
 	if (!vma)
 		goto out_unlock_mmap;
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
@@ -298,7 +298,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_read, unsi
 
 	mmap_read_lock(current->mm);
 	ret = -EINVAL;
-	vma = find_vma(current->mm, mmio_addr);
+	vma = vma_lookup(current->mm, mmio_addr);
 	if (!vma)
 		goto out_unlock_mmap;
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))


