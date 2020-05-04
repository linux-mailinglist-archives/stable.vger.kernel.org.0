Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690D91C437B
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 19:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730474AbgEDR6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 13:58:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:51650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730508AbgEDR6r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 13:58:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA33C206D9;
        Mon,  4 May 2020 17:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615126;
        bh=F5cUo0zMBN5ifTcN/uTHP0dIFbVP1qNdzHk9h4IGZFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m7jM8InGXl1ZJfygZscmSvbqTgdHf8RAh7xy6iPNlrqH3pd4QQ+xcXWy7+5ZKuSN0
         diBkc6IDd1v4l9LanwpWfgWpbnOQ8hT0Ic5xDd3q1ggHA7hSJ3ZZNIkrqtfnQAgMj2
         O09jnjd91tkzncJ0exAQSDvV4CfLeCebFpqB0XY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 4.4 06/18] vfio/type1: Fix VA->PA translation for PFNMAP VMAs in vaddr_get_pfn()
Date:   Mon,  4 May 2020 19:57:04 +0200
Message-Id: <20200504165442.985286875@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165441.533160703@linuxfoundation.org>
References: <20200504165441.533160703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit 5cbf3264bc715e9eb384e2b68601f8c02bb9a61d upstream.

Use follow_pfn() to get the PFN of a PFNMAP VMA instead of assuming that
vma->vm_pgoff holds the base PFN of the VMA.  This fixes a bug where
attempting to do VFIO_IOMMU_MAP_DMA on an arbitrary PFNMAP'd region of
memory calculates garbage for the PFN.

Hilariously, this only got detected because the first "PFN" calculated
by vaddr_get_pfn() is PFN 0 (vma->vm_pgoff==0), and iommu_iova_to_phys()
uses PA==0 as an error, which triggers a WARN in vfio_unmap_unpin()
because the translation "failed".  PFN 0 is now unconditionally reserved
on x86 in order to mitigate L1TF, which causes is_invalid_reserved_pfn()
to return true and in turns results in vaddr_get_pfn() returning success
for PFN 0.  Eventually the bogus calculation runs into PFNs that aren't
reserved and leads to failure in vfio_pin_map_dma().  The subsequent
call to vfio_remove_dma() attempts to unmap PFN 0 and WARNs.

  WARNING: CPU: 8 PID: 5130 at drivers/vfio/vfio_iommu_type1.c:750 vfio_unmap_unpin+0x2e1/0x310 [vfio_iommu_type1]
  Modules linked in: vfio_pci vfio_virqfd vfio_iommu_type1 vfio ...
  CPU: 8 PID: 5130 Comm: sgx Tainted: G        W         5.6.0-rc5-705d787c7fee-vfio+ #3
  Hardware name: Intel Corporation Mehlow UP Server Platform/Moss Beach Server, BIOS CNLSE2R1.D00.X119.B49.1803010910 03/01/2018
  RIP: 0010:vfio_unmap_unpin+0x2e1/0x310 [vfio_iommu_type1]
  Code: <0f> 0b 49 81 c5 00 10 00 00 e9 c5 fe ff ff bb 00 10 00 00 e9 3d fe
  RSP: 0018:ffffbeb5039ebda8 EFLAGS: 00010246
  RAX: 0000000000000000 RBX: ffff9a55cbf8d480 RCX: 0000000000000000
  RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff9a52b771c200
  RBP: 0000000000000000 R08: 0000000000000040 R09: 00000000fffffff2
  R10: 0000000000000001 R11: ffff9a51fa896000 R12: 0000000184010000
  R13: 0000000184000000 R14: 0000000000010000 R15: ffff9a55cb66ea08
  FS:  00007f15d3830b40(0000) GS:ffff9a55d5600000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000561cf39429e0 CR3: 000000084f75f005 CR4: 00000000003626e0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   vfio_remove_dma+0x17/0x70 [vfio_iommu_type1]
   vfio_iommu_type1_ioctl+0x9e3/0xa7b [vfio_iommu_type1]
   ksys_ioctl+0x92/0xb0
   __x64_sys_ioctl+0x16/0x20
   do_syscall_64+0x4c/0x180
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  RIP: 0033:0x7f15d04c75d7
  Code: <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 81 48 2d 00 f7 d8 64 89 01 48

Fixes: 73fa0d10d077 ("vfio: Type1 IOMMU implementation")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vfio/vfio_iommu_type1.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -227,8 +227,8 @@ static int vaddr_get_pfn(unsigned long v
 	vma = find_vma_intersection(current->mm, vaddr, vaddr + 1);
 
 	if (vma && vma->vm_flags & VM_PFNMAP) {
-		*pfn = ((vaddr - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
-		if (is_invalid_reserved_pfn(*pfn))
+		if (!follow_pfn(vma, vaddr, pfn) &&
+		    is_invalid_reserved_pfn(*pfn))
 			ret = 0;
 	}
 


