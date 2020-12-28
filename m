Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93FAE2E380F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730494AbgL1NEq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:04:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:60856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730503AbgL1NEo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:04:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58B86207C9;
        Mon, 28 Dec 2020 13:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160641;
        bh=ceZIMqhfPUh1tw8dIvdLwto0g4ZmHkjNQh09UorvhTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jSHsDGZEdpmKt3VxqRRo2ZFkWxo16X1j3NOAt6b/O+5tDhJiXVmXW/n40QfbpLZ2/
         0HffvWd5CDbkWAzELBWOkvgcD0ZSqgzSfn4PGeQefeWzZ1ZiZTXimXU/zRxExSqI39
         e5Gy5yJ5NVjTC2QNmPj0e+3MMywh25pGbQe8SMjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Peter Xu <peterx@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 090/175] vfio-pci: Use io_remap_pfn_range() for PCI IO memory
Date:   Mon, 28 Dec 2020 13:49:03 +0100
Message-Id: <20201228124857.610339811@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 7b06a56d468b756ad6bb43ac21b11e474ebc54a0 ]

commit f8f6ae5d077a ("mm: always have io_remap_pfn_range() set
pgprot_decrypted()") allows drivers using mmap to put PCI memory mapped
BAR space into userspace to work correctly on AMD SME systems that default
to all memory encrypted.

Since vfio_pci_mmap_fault() is working with PCI memory mapped BAR space it
should be calling io_remap_pfn_range() otherwise it will not work on SME
systems.

Fixes: 11c4cd07ba11 ("vfio-pci: Fault mmaps to enable vma tracking")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Peter Xu <peterx@redhat.com>
Tested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 237d5aceb302d..f9a3da02c631b 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1403,8 +1403,8 @@ static int vfio_pci_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 
 	mutex_unlock(&vdev->vma_lock);
 
-	if (remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
-			    vma->vm_end - vma->vm_start, vma->vm_page_prot))
+	if (io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
+			       vma->vm_end - vma->vm_start, vma->vm_page_prot))
 		ret = VM_FAULT_SIGBUS;
 
 up_out:
-- 
2.27.0



