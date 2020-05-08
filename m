Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76AEF1CAAFC
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbgEHMir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:38:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:55720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728470AbgEHMir (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:38:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20FC724973;
        Fri,  8 May 2020 12:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941526;
        bh=j9jM0Mzrvgf4FP6B636x7mc63CPHN9JBIKo3Smq40iM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jkTYkrfoTKmns5Zbo++oXwkFyt9xZj0qYn3waV4xK1xRvY5Ed0RrK/nXEzTSp9BYm
         M4IJlhLyEOrtBI2EHsM/gJYr+zAo/kOZuF47ge9Waldrkh3IWo5SEydblQKM/favEz
         947awLbIfeY8KMWNqaEGjMpXnQwRl2JtS5r9E63s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 4.4 060/312] PCI: Supply CPU physical address (not bus address) to iomem_is_exclusive()
Date:   Fri,  8 May 2020 14:30:51 +0200
Message-Id: <20200508123128.776388929@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

commit ca620723d4ff9ea7ed484eab46264c3af871b9ae upstream.

iomem_is_exclusive() requires a CPU physical address, but on some arches we
supplied a PCI bus address instead.

On most arches, pci_resource_to_user(res) returns "res->start", which is a
CPU physical address.  But on microblaze, mips, powerpc, and sparc, it
returns the PCI bus address corresponding to "res->start".

The result is that pci_mmap_resource() may fail when it shouldn't (if the
bus address happens to match an existing resource), or it may succeed when
it should fail (if the resource is exclusive but the bus address doesn't
match it).

Call iomem_is_exclusive() with "res->start", which is always a CPU physical
address, not the result of pci_resource_to_user().

Fixes: e8de1481fd71 ("resource: allow MMIO exclusivity for device drivers")
Suggested-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/pci-sysfs.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1027,6 +1027,9 @@ static int pci_mmap_resource(struct kobj
 	if (i >= PCI_ROM_RESOURCE)
 		return -ENODEV;
 
+	if (res->flags & IORESOURCE_MEM && iomem_is_exclusive(res->start))
+		return -EINVAL;
+
 	if (!pci_mmap_fits(pdev, i, vma, PCI_MMAP_SYSFS)) {
 		WARN(1, "process \"%s\" tried to map 0x%08lx bytes at page 0x%08lx on %s BAR %d (start 0x%16Lx, size 0x%16Lx)\n",
 			current->comm, vma->vm_end-vma->vm_start, vma->vm_pgoff,
@@ -1043,10 +1046,6 @@ static int pci_mmap_resource(struct kobj
 	pci_resource_to_user(pdev, i, res, &start, &end);
 	vma->vm_pgoff += start >> PAGE_SHIFT;
 	mmap_type = res->flags & IORESOURCE_MEM ? pci_mmap_mem : pci_mmap_io;
-
-	if (res->flags & IORESOURCE_MEM && iomem_is_exclusive(start))
-		return -EINVAL;
-
 	return pci_mmap_page_range(pdev, vma, mmap_type, write_combine);
 }
 


