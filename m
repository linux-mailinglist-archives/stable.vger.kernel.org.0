Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C257B2E411E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408149AbgL1PC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:02:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:47404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439939AbgL1OMp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:12:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87F11206D4;
        Mon, 28 Dec 2020 14:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164725;
        bh=HgKUPluJdE/RxiBOMmBpeTvxKGLKCWxO9nN7QGeN6i4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AY75YjIeRIuKhVmOQtCCFoVcHZymONA6cEzK7oMOukU6Lr4GxasVICKFrFX/pNK1X
         UGG7saaPSaQrgyB0ri97IUoPzLYDuOcSqQfa0Qdln9LNzwAh8zeU8qKdFJe7bE1kgt
         SofHDYnbPEbgpy1qH4sWZVRXId7rJC0TWWVm08Cg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Peter Xu <peterx@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 274/717] vfio-pci: Use io_remap_pfn_range() for PCI IO memory
Date:   Mon, 28 Dec 2020 13:44:32 +0100
Message-Id: <20201228125034.145098805@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
index e6190173482c7..89e451615729a 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1635,8 +1635,8 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
 
 	mutex_unlock(&vdev->vma_lock);
 
-	if (remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
-			    vma->vm_end - vma->vm_start, vma->vm_page_prot))
+	if (io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
+			       vma->vm_end - vma->vm_start, vma->vm_page_prot))
 		ret = VM_FAULT_SIGBUS;
 
 up_out:
-- 
2.27.0



