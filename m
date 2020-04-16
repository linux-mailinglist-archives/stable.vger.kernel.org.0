Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6F61AC30E
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897427AbgDPNhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:37:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896757AbgDPNhM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:37:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1121221F7;
        Thu, 16 Apr 2020 13:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044232;
        bh=yhI3NI1KmfPDccG/EU6FqCzaXscBVZV5NqW/j9k7kIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aiWXXYb7/YhWFJzmc473YiH+RX1cn+RqiGLre0dSjL5mB8+PUQvXIqtSfZEOZGTmx
         fkp9MNKBzyi4QnXzAs7S3RGSLZNmn5AaC1tB2C4vCYG+xUS679tO2W8/O+AB4xpsU7
         8Kyw2yRdw1wLdcuR7eJXTYAzaKFoVbWpOqFjC6mM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.5 117/257] PCI: endpoint: Fix for concurrent memory allocation in OB address region
Date:   Thu, 16 Apr 2020 15:22:48 +0200
Message-Id: <20200416131340.891461151@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
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
@@ -79,6 +79,7 @@ int __pci_epc_mem_init(struct pci_epc *e
 	mem->page_size = page_size;
 	mem->pages = pages;
 	mem->size = size;
+	mutex_init(&mem->lock);
 
 	epc->mem = mem;
 
@@ -122,7 +123,7 @@ void __iomem *pci_epc_mem_alloc_addr(str
 				     phys_addr_t *phys_addr, size_t size)
 {
 	int pageno;
-	void __iomem *virt_addr;
+	void __iomem *virt_addr = NULL;
 	struct pci_epc_mem *mem = epc->mem;
 	unsigned int page_shift = ilog2(mem->page_size);
 	int order;
@@ -130,15 +131,18 @@ void __iomem *pci_epc_mem_alloc_addr(str
 	size = ALIGN(size, mem->page_size);
 	order = pci_epc_mem_get_order(mem, size);
 
+	mutex_lock(&mem->lock);
 	pageno = bitmap_find_free_region(mem->bitmap, mem->pages, order);
 	if (pageno < 0)
-		return NULL;
+		goto ret;
 
 	*phys_addr = mem->phys_base + ((phys_addr_t)pageno << page_shift);
 	virt_addr = ioremap(*phys_addr, size);
 	if (!virt_addr)
 		bitmap_release_region(mem->bitmap, pageno, order);
 
+ret:
+	mutex_unlock(&mem->lock);
 	return virt_addr;
 }
 EXPORT_SYMBOL_GPL(pci_epc_mem_alloc_addr);
@@ -164,7 +168,9 @@ void pci_epc_mem_free_addr(struct pci_ep
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
@@ -71,6 +71,7 @@ struct pci_epc_ops {
  * @bitmap: bitmap to manage the PCI address space
  * @pages: number of bits representing the address region
  * @page_size: size of each page
+ * @lock: mutex to protect bitmap
  */
 struct pci_epc_mem {
 	phys_addr_t	phys_base;
@@ -78,6 +79,8 @@ struct pci_epc_mem {
 	unsigned long	*bitmap;
 	size_t		page_size;
 	int		pages;
+	/* mutex to protect against concurrent access for memory allocation*/
+	struct mutex	lock;
 };
 
 /**


