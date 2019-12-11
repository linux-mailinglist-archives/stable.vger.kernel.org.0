Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9CD11AF48
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731012AbfLKPMY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:12:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:33908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731114AbfLKPMY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82CD62465C;
        Wed, 11 Dec 2019 15:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077143;
        bh=hlOVCucT8KQDZPTtqqt3AstmcgO+lKwoR7CKhjwYEB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jOyXABVWuCmej/AdhwfremDRhxsxbHAuKHhOak0wu5XuVssEVk+Io2D3Yd2/4kgz0
         Ht3dhLMjZoXUgjqVRsOncIOcQ3MCSh+Hiih4+RWj2N07bp+FKNQM84Yt184al5bEkC
         nvWApzPnTGPO6QBmZrrCBMfh6OJ37/unQLQ3Ptw0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Murzin <vladimir.murzin@arm.com>,
        Daniele Alessandrelli <daniele.alessandrelli@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 030/134] dma-mapping: fix handling of dma-ranges for reserved memory (again)
Date:   Wed, 11 Dec 2019 10:10:06 -0500
Message-Id: <20191211151150.19073-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Murzin <vladimir.murzin@arm.com>

[ Upstream commit a445e940ea686fc60475564009821010eb213be3 ]

Daniele reported that issue previously fixed in c41f9ea998f3
("drivers: dma-coherent: Account dma_pfn_offset when used with device
tree") reappear shortly after 43fc509c3efb ("dma-coherent: introduce
interface for default DMA pool") where fix was accidentally dropped.

Lets put fix back in place and respect dma-ranges for reserved memory.

Fixes: 43fc509c3efb ("dma-coherent: introduce interface for default DMA pool")

Reported-by: Daniele Alessandrelli <daniele.alessandrelli@gmail.com>
Tested-by: Daniele Alessandrelli <daniele.alessandrelli@gmail.com>
Tested-by: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/dma-mapping-nommu.c |  2 +-
 include/linux/dma-mapping.h     |  4 ++--
 kernel/dma/coherent.c           | 16 +++++++++-------
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mm/dma-mapping-nommu.c b/arch/arm/mm/dma-mapping-nommu.c
index db92478983005..287ef898a55e1 100644
--- a/arch/arm/mm/dma-mapping-nommu.c
+++ b/arch/arm/mm/dma-mapping-nommu.c
@@ -35,7 +35,7 @@ static void *arm_nommu_dma_alloc(struct device *dev, size_t size,
 				 unsigned long attrs)
 
 {
-	void *ret = dma_alloc_from_global_coherent(size, dma_handle);
+	void *ret = dma_alloc_from_global_coherent(dev, size, dma_handle);
 
 	/*
 	 * dma_alloc_from_global_coherent() may fail because:
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 0aad641d662c3..4d450672b7d66 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -162,7 +162,7 @@ int dma_release_from_dev_coherent(struct device *dev, int order, void *vaddr);
 int dma_mmap_from_dev_coherent(struct device *dev, struct vm_area_struct *vma,
 			    void *cpu_addr, size_t size, int *ret);
 
-void *dma_alloc_from_global_coherent(ssize_t size, dma_addr_t *dma_handle);
+void *dma_alloc_from_global_coherent(struct device *dev, ssize_t size, dma_addr_t *dma_handle);
 int dma_release_from_global_coherent(int order, void *vaddr);
 int dma_mmap_from_global_coherent(struct vm_area_struct *vma, void *cpu_addr,
 				  size_t size, int *ret);
@@ -172,7 +172,7 @@ int dma_mmap_from_global_coherent(struct vm_area_struct *vma, void *cpu_addr,
 #define dma_release_from_dev_coherent(dev, order, vaddr) (0)
 #define dma_mmap_from_dev_coherent(dev, vma, vaddr, order, ret) (0)
 
-static inline void *dma_alloc_from_global_coherent(ssize_t size,
+static inline void *dma_alloc_from_global_coherent(struct device *dev, ssize_t size,
 						   dma_addr_t *dma_handle)
 {
 	return NULL;
diff --git a/kernel/dma/coherent.c b/kernel/dma/coherent.c
index 545e3869b0e32..551b0eb7028a3 100644
--- a/kernel/dma/coherent.c
+++ b/kernel/dma/coherent.c
@@ -123,8 +123,9 @@ int dma_declare_coherent_memory(struct device *dev, phys_addr_t phys_addr,
 	return ret;
 }
 
-static void *__dma_alloc_from_coherent(struct dma_coherent_mem *mem,
-		ssize_t size, dma_addr_t *dma_handle)
+static void *__dma_alloc_from_coherent(struct device *dev,
+				       struct dma_coherent_mem *mem,
+				       ssize_t size, dma_addr_t *dma_handle)
 {
 	int order = get_order(size);
 	unsigned long flags;
@@ -143,7 +144,7 @@ static void *__dma_alloc_from_coherent(struct dma_coherent_mem *mem,
 	/*
 	 * Memory was found in the coherent area.
 	 */
-	*dma_handle = mem->device_base + (pageno << PAGE_SHIFT);
+	*dma_handle = dma_get_device_base(dev, mem) + (pageno << PAGE_SHIFT);
 	ret = mem->virt_base + (pageno << PAGE_SHIFT);
 	spin_unlock_irqrestore(&mem->spinlock, flags);
 	memset(ret, 0, size);
@@ -175,17 +176,18 @@ int dma_alloc_from_dev_coherent(struct device *dev, ssize_t size,
 	if (!mem)
 		return 0;
 
-	*ret = __dma_alloc_from_coherent(mem, size, dma_handle);
+	*ret = __dma_alloc_from_coherent(dev, mem, size, dma_handle);
 	return 1;
 }
 
-void *dma_alloc_from_global_coherent(ssize_t size, dma_addr_t *dma_handle)
+void *dma_alloc_from_global_coherent(struct device *dev, ssize_t size,
+				     dma_addr_t *dma_handle)
 {
 	if (!dma_coherent_default_memory)
 		return NULL;
 
-	return __dma_alloc_from_coherent(dma_coherent_default_memory, size,
-			dma_handle);
+	return __dma_alloc_from_coherent(dev, dma_coherent_default_memory, size,
+					 dma_handle);
 }
 
 static int __dma_release_from_coherent(struct dma_coherent_mem *mem,
-- 
2.20.1

