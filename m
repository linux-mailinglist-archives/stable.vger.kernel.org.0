Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF2F1B4173
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729482AbgDVKw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:52:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728947AbgDVKKI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:10:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9888020775;
        Wed, 22 Apr 2020 10:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550207;
        bh=aGquuusWEy//4Cijg3ojUT8EFZej4syeVu8388MiEp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sIA8bzobJSeocmwKnZv0psD+I6F6FkWpOCFH9Dv0qGWOeb7jDpoLhzcJ7/rpCu3yE
         92DFBTZ3sRG7rQjiPJp5zLl39lNyqhI6pTPKvBPZDrCgRlDo/XxH1JBmsYJB6rzdmK
         oaCvrkgGjkG8tSE27upk9whXU9QH2z75Mf1c27wI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 4.14 050/199] PCI: endpoint: Fix for concurrent memory allocation in OB address region
Date:   Wed, 22 Apr 2020 11:56:16 +0200
Message-Id: <20200422095103.177403649@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095057.806111593@linuxfoundation.org>
References: <20200422095057.806111593@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

commit 04e046ca57ebed3943422dee10eec9e73aec081e upstream.

pci-epc-mem uses a bitmap to manage the Endpoint outbound (OB) address
region. This address region will be shared by multiple endpoint
functions (in the case of multi function endpoint) and it has to be
protected from concurrent access to avoid updating an inconsistent state.

Use a mutex to protect bitmap updates to prevent the memory
allocation API from returning incorrect addresses.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: stable@vger.kernel.org # v4.14+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/endpoint/pci-epc-mem.c |   10 ++++++++--
 include/linux/pci-epc.h            |    3 +++
 2 files changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/pci/endpoint/pci-epc-mem.c
+++ b/drivers/pci/endpoint/pci-epc-mem.c
@@ -90,6 +90,7 @@ int __pci_epc_mem_init(struct pci_epc *e
 	mem->page_size = page_size;
 	mem->pages = pages;
 	mem->size = size;
+	mutex_init(&mem->lock);
 
 	epc->mem = mem;
 
@@ -133,7 +134,7 @@ void __iomem *pci_epc_mem_alloc_addr(str
 				     phys_addr_t *phys_addr, size_t size)
 {
 	int pageno;
-	void __iomem *virt_addr;
+	void __iomem *virt_addr = NULL;
 	struct pci_epc_mem *mem = epc->mem;
 	unsigned int page_shift = ilog2(mem->page_size);
 	int order;
@@ -141,15 +142,18 @@ void __iomem *pci_epc_mem_alloc_addr(str
 	size = ALIGN(size, mem->page_size);
 	order = pci_epc_mem_get_order(mem, size);
 
+	mutex_lock(&mem->lock);
 	pageno = bitmap_find_free_region(mem->bitmap, mem->pages, order);
 	if (pageno < 0)
-		return NULL;
+		goto ret;
 
 	*phys_addr = mem->phys_base + (pageno << page_shift);
 	virt_addr = ioremap(*phys_addr, size);
 	if (!virt_addr)
 		bitmap_release_region(mem->bitmap, pageno, order);
 
+ret:
+	mutex_unlock(&mem->lock);
 	return virt_addr;
 }
 EXPORT_SYMBOL_GPL(pci_epc_mem_alloc_addr);
@@ -175,7 +179,9 @@ void pci_epc_mem_free_addr(struct pci_ep
 	pageno = (phys_addr - mem->phys_base) >> page_shift;
 	size = ALIGN(size, mem->page_size);
 	order = pci_epc_mem_get_order(mem, size);
+	mutex_lock(&mem->lock);
 	bitmap_release_region(mem->bitmap, pageno, order);
+	mutex_unlock(&mem->lock);
 }
 EXPORT_SYMBOL_GPL(pci_epc_mem_free_addr);
 
--- a/include/linux/pci-epc.h
+++ b/include/linux/pci-epc.h
@@ -63,6 +63,7 @@ struct pci_epc_ops {
  * @bitmap: bitmap to manage the PCI address space
  * @pages: number of bits representing the address region
  * @page_size: size of each page
+ * @lock: mutex to protect bitmap
  */
 struct pci_epc_mem {
 	phys_addr_t	phys_base;
@@ -70,6 +71,8 @@ struct pci_epc_mem {
 	unsigned long	*bitmap;
 	size_t		page_size;
 	int		pages;
+	/* mutex to protect against concurrent access for memory allocation*/
+	struct mutex	lock;
 };
 
 /**


