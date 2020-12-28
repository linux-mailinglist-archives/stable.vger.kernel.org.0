Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20AE42E3B59
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405886AbgL1NtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:49:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:50564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406030AbgL1Ns6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:48:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7F2322B47;
        Mon, 28 Dec 2020 13:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163297;
        bh=bUPiKQLNXtx8/iJR4wmUgEoOef8OQYb4cHYzEMqaWLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vLjJMaLUeG/j9tJ4j/gmfM9DXVAj7MNLmTl9xYYTEFZVCa9EJ8MhHHKxF19tqqDD4
         YQG8+lN6WPYZXX8kv5wTRaQe7/pQXAFsKAzwl3Kw8F+N3VmCmAtjrehBhYwQX84M8+
         RmKA/b0/9Xo/sqAwpHzHEYnw2M6Om+BeqyrmrznA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Peter Xu <peterx@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 207/453] vfio-pci: Use io_remap_pfn_range() for PCI IO memory
Date:   Mon, 28 Dec 2020 13:47:23 +0100
Message-Id: <20201228124947.177124046@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
index 443a35dde7f52..632653cd70e3b 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1451,8 +1451,8 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
 
 	mutex_unlock(&vdev->vma_lock);
 
-	if (remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
-			    vma->vm_end - vma->vm_start, vma->vm_page_prot))
+	if (io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
+			       vma->vm_end - vma->vm_start, vma->vm_page_prot))
 		ret = VM_FAULT_SIGBUS;
 
 up_out:
-- 
2.27.0



