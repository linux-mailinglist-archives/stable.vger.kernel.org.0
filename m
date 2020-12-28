Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65872E6597
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390003AbgL1N2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:28:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:57302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389996AbgL1N2v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:28:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 560CB22A84;
        Mon, 28 Dec 2020 13:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162115;
        bh=CPhtakaKPiwWF1cWE3tzLV3Cwm4lpKA9HczcKkF2zbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P6PNHxf9e5kfqe1PWHR5mthjoYZeQRh/RH1Qco5Ca4YLmSuWZj15wpherjYrRYgpA
         ac5GqD+VDHFZUBAzXPei81HlUom1+/USiruT+vplJNX8ZstIBJPtZ32N2PsN5KxD9E
         jkYOjPjU3ZYqex/EQHwgaCA9e3kNEf2nR3bLis6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Peter Xu <peterx@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 193/346] vfio-pci: Use io_remap_pfn_range() for PCI IO memory
Date:   Mon, 28 Dec 2020 13:48:32 +0100
Message-Id: <20201228124929.121935552@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
index 58e7336b2748b..5e23e4aa5b0a3 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1380,8 +1380,8 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
 
 	mutex_unlock(&vdev->vma_lock);
 
-	if (remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
-			    vma->vm_end - vma->vm_start, vma->vm_page_prot))
+	if (io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
+			       vma->vm_end - vma->vm_start, vma->vm_page_prot))
 		ret = VM_FAULT_SIGBUS;
 
 up_out:
-- 
2.27.0



